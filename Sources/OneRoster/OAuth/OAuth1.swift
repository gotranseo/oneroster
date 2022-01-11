//===----------------------------------------------------------------------===//
//
// This source file is part of the OneRoster open source project
//
// Copyright (c) 2021 the OneRoster project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Foundation
import Vapor

/// A namespace for OAuth 1-related types.
public enum OAuth1 {
    /// A set of configuration and credential parameters for authorizing requests with OAuth 1.
    public struct Parameters {
        /// A method used to generate per-request signatures.
        ///
        /// The plaintext, HMAC-SHA1, and RSA-SHA1 methods from RFC5849 § 3.4.2-3.4.4 are not
        /// implemented; they are both very outdated and very insecure.
        public enum SignatureMethod: String {
            case hmacSHA256 = "HMAC-SHA256"
        }
        
        /// A public client identifier (i.e. a "username").
        public let clientId: String
        
        /// A private client secret (i.e. a "password").
        public let clientSecret: String

        /// An OAuth 1 "token" key, if applicable.
        public let userKey: String?
        
        /// An OAuth 1 "token" secret, if applicable.
        public let userSecret: String?
        
        /// The algorithm used to compute signatures.
        public let signatureMethod: SignatureMethod
        
        /// Overrides the timestamp used for signature computation.
        ///
        /// You probably don't want to use this unless you're writing tests and need deterministic behavior.
        public let timestamp: Date?
        
        /// Overrides the generation of a random nonce per-request for signature computation.
        ///
        /// You probably don't want to use this unless you're writing tests and need deterministic behavior.
        public let nonce: String?
        
        /// Memberwise initializer.
        public init(
            clientId: String, clientSecret: String, userKey: String? = nil, userSecret: String? = nil,
            signatureMethod: SignatureMethod = .hmacSHA256, timestamp: Date? = nil, nonce: String? = nil
        ) {
            self.clientId = clientId
            self.clientSecret = clientSecret
            self.userKey = userKey
            self.userSecret = userSecret
            self.signatureMethod = signatureMethod
            self.timestamp = timestamp
            self.nonce = nonce
        }
    }
    
    /// Generate an OAuth signature and parameter set.
    ///
    /// See `generateSignature(for:method:body:using:)` below for important details.
    internal static func generateSignature(
        for request: URI,
        method: HTTPMethod,
        body: ByteBuffer? = nil,
        using parameters: Parameters
    ) -> String {
        guard let url = URL(string: request.string) else {
            fatalError("A Vapor.URI can't be parsed as a Foundation.URL, this is a pretty bad thing: \(request)")
        }
        return Self.generateSignature(for: url, method: method, body: body, using: parameters)
    }
    
    /// Calculate the OAuth parameter set and signature for a given request URL, content, and method using the given
    /// parameters. Return the calculated parameter set, including the signature, as a combined string suitable for
    /// inclusion in an `Authorization` header using the `OAuth` type.
    ///
    /// - Warning: Does not correctly handle url-encoded form request bodies as RFC 5849 § 3.4.1.3.1 requires.
    ///
    /// - Note: `internal` rather than `fileprivate` for the benefit of tests. Ensuure `SWIFT_DETERMINISTIC_HASHING` is
    ///   set in the test environment to guarantee reproducible ordering of the parameter set.
    internal static func generateSignature(
        for request: URL,
        method: HTTPMethod,
        body: ByteBuffer? = nil,
        using parameters: Parameters
    ) -> String {
        guard let parts = URLComponents(url: request, resolvingAgainstBaseURL: true) else {
            fatalError("A URL can't be parsed into its components, this is a pretty bad thing: \(request)")
        }

        // RFC 5849 § 3.3
        let timestamp = UInt64((parameters.timestamp ?? Date()).timeIntervalSince1970)
        let nonce = parameters.nonce ?? UUID().uuidString
        
        // RFC 5849 § 3.1
        var oauthParams = [
            "oauth_consumer_key": parameters.clientId,
            "oauth_signature_method": parameters.signatureMethod.rawValue,
            "oauth_timestamp": "\(timestamp)",
            "oauth_nonce": nonce,
            "oauth_version": "1.0",
            "oauth_token": parameters.userKey
        ].compactMapValues { $0 }

        // RFC 5849 § 3.4.1.3.1
        let rawParams = oauthParams.map { $0 } + (parts.queryItems ?? []).map { ($0.name, $0.value ?? "") }
        // RFC 5849 § 3.4.1.3.2
        let encodedParams = rawParams.map { (name: $0.rfc5849Encoded, value: $1.rfc5849Encoded) }
        let sortedParams = encodedParams.sorted {
            if $0.name.utf8 != $1.name.utf8 {
                return $0.name.utf8 < $1.name.utf8
            } else {
                return $0.value.utf8 < $1.value.utf8
            }
        }
        let allParams = sortedParams.map { "\($0)=\($1)" }.joined(separator: "&")

        // RFC 5849 § 3.4.1.1
        let signatureBase = [method.rawValue, parts.rfc5849BaseString ?? "", allParams]
            .map(\.rfc5849Encoded).joined(separator: "&")
        
        // RFC 5849 $ 3.4.2
        let signatureKey = [parameters.clientSecret, parameters.userSecret ?? ""]
            .map(\.rfc5849Encoded).joined(separator: "&")
        
        oauthParams["oauth_signature"] = Data(HMAC<SHA256>.authenticationCode(
            for: Data(signatureBase.utf8),
            using: .init(data: Data(signatureKey.utf8))
        )).base64EncodedString()
        
        // RFC 5849 § 3.5
        return oauthParams
            .map { "\($0.rfc5849Encoded)=\"\($1.rfc5849Encoded)\"" }
            .joined(separator: ", ")
    }

    /// An implementation of Vapor's `Client` protocol which applies OAuth 1-based authorization to all outgoing
    /// requests automatically.
    ///
    /// - Warning: Because a client secret is required to generate signatures for every outgoing request, unlike
    ///   in OAuth 2, the OAuth 1 parameters are retained by the client throughout its lifetime. **This is much
    ///   less secure!**
    public final class Client: Vapor.Client {
        /// The underlying `Client` used for all requests.
        public let client: Vapor.Client
        
        /// The `Logger` for all log messages related to this client.
        public let logger: Logger
        
        /// The OAuth 1 parameters used to compute per-request authorization.
        private let parameters: Parameters

        // See `Client.eventLoop`.
        public var eventLoop: EventLoop { self.client.eventLoop }
        
        /// Create a new OAuth 1-capable client which automatically calculates a signature for each
        /// outgoing request and correctly embeds it.
        ///
        /// - Parameters:
        ///   - client: The underlying `Client` to use for actually sending requests.
        ///   - logger: A logger to use for log messages related to the client.
        ///   - parameters: A set of OAuth 1 parameters containing the neceessary information (including sensitive
        ///     credentials such as a client secret) for signing requests. Credentials are retained in memory for
        ///     the lifetime of the client, due to the need to reuse them for each request.
        public init(client: Vapor.Client, logger: Logger, parameters: Parameters) {
            self.client = client
            self.logger = logger
            self.parameters = parameters
        }

        // See `Client.delegating(to:)`.
        public func delegating(to eventLoop: EventLoop) -> Vapor.Client {
            OAuth1.Client.init(client: self.client.delegating(to: eventLoop), logger: self.logger, parameters: self.parameters)
        }
        
        // See `Client.logging(to:)`.
        public func logging(to logger: Logger) -> Vapor.Client {
            OAuth1.Client.init(client: self.client, logger: logger, parameters: self.parameters)
        }
        
        // See `Client.send(_:)`.
        public func send(_ request: ClientRequest) -> EventLoopFuture<ClientResponse> {
            var finalRequest = request
            
            // Allow requests to override automatic OAuth authorization.
            if !finalRequest.headers.contains(name: .authorization) {
                let signature = OAuth1.generateSignature(for: request.url, method: request.method, body: request.body, using: self.parameters)

                finalRequest.headers.replaceOrAdd(name: .authorization, value: "OAuth \(signature)")
            }
            return self.client.send(finalRequest)
        }
    }
}

/// Something that is a sequence of individual bytes which can be compared to other like sequences.
public protocol ComparableCollection: Comparable, Collection where Element == UInt8 {}

extension ComparableCollection {
    public static func ==(lhs: Self, rhs: Self) -> Bool { zip(lhs, rhs).allSatisfy { $0 == $1 } } // Can this optimize to `memcmp()`?
    
    public static func <(lhs: Self, rhs: Self) -> Bool {
        for (l, r) in zip(lhs, rhs) where l != r { return l < r }
        return lhs.count < rhs.count // if we get here, all leading elements are equal, so count decides it
    }
}

extension String.UTF8View: ComparableCollection {}
extension Substring.UTF8View: ComparableCollection {}

extension StringProtocol {
    /// Returns the result of encoding `self` using the percent encoding rules specified by RFC 5849 § 3.6,
    /// which are stricter than the rules used by `URLComponents` or `URL`.
    fileprivate var rfc5849Encoded: String {
        self.addingPercentEncoding(withAllowedCharacters:
            .init(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
        )!
    }
}

extension URLComponents {
    /// Returns the result of constructing a URL string from _only_ the scheme, authority, and path components, using
    /// the semantics specified by RFC 5849 § 3.4.1.2 for case normalization and port number inclusion.
    fileprivate var rfc5849BaseString: String? {
        /// This list containly _only_ schemes and ports defined by the RFC. Do not add more entries to it!
        let knownSchemes: Set<String> = [
            "http:80",
            "https:443",
        ]
        
        var partial = URLComponents()
        partial.scheme = self.scheme?.lowercased()
        partial.user = self.user
        partial.password = self.password
        partial.host = self.host?.lowercased()
        partial.port = knownSchemes.contains("\(partial.scheme ?? ""):\(self.port ?? 0)") ? nil : self.port
        partial.path = self.path
        return partial.string
    }
}

extension Application {
    /// Get an `OAuth1Client` suitable for automatically calculating an OAuth 1 signature for each request.
    ///
    /// Uses the application's default `Client` and `Logger`.
    ///
    /// - Parameters:
    ///   - parameters: A set of OAuth 1 parameters containing the neceessary information (including sensitive
    ///     credentials such as a client secret) for signing requests. Credentials are retained in memory for
    ///     the lifetime of the client, due to the need to reuse them for each request.
    public func oauth1(parameters: OAuth1.Parameters) -> OAuth1.Client {
        OAuth1.Client(client: self.client, logger: self.logger, parameters: parameters)
    }
}

extension Request {
    /// Get an `OAuth1Client` suitable for automatically calculating an OAuth 1 signature for each request.
    ///
    /// Uses the request's default `Client` and `Logger`.
    ///
    /// - Parameters:
    /// - Parameters:
    ///   - parameters: A set of OAuth 1 parameters containing the neceessary information (including sensitive
    ///     credentials such as a client secret) for signing requests. Credentials are retained in memory for
    ///     the lifetime of the client, due to the need to reuse them for each request.
    public func oauth1(parameters: OAuth1.Parameters) -> OAuth1.Client {
        OAuth1.Client(client: self.client, logger: self.logger, parameters: parameters)
    }
}
