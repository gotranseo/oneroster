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

/// A namespace for OAuth 2-related types.
public enum OAuth2 {
    /// A set of configuration and credential parameters for authorizing requests with OAuth 2.
    ///
    /// Currently only supports the parameters used by a `client_credentials` grant (RFC6749 § 4.4).
    public struct Parameters {
        /// The base URL of the OAuth 2 provider. Used to construct a token endpoint.
        public let providerBaseUrl: URL
        
        /// A public client identifier (i.e. a "username").
        public let clientId: String
        
        /// A private client secret (i.e. a "password").
        public let clientSecret: String
        
        /// The scope(s) to which an access token should apply, if granted.
        public let scopes: [String]
        
        /// Memberwise initializer with variadic scopes.
        public init(providerBaseUrl: URL, clientId: String, clientSecret: String, scopes: String...) {
            self.init(providerBaseUrl: providerBaseUrl, clientId: clientId, clientSecret: clientSecret, scopes: scopes)
        }

        /// Memberwise initializer.
        public init(providerBaseUrl: URL, clientId: String, clientSecret: String, scopes: [String]) {
            self.providerBaseUrl = providerBaseUrl
            self.clientId = clientId
            self.clientSecret = clientSecret
            self.scopes = scopes
        }
    }

    /// A request for an OAuth2 access token via the `client_credentials` grant type, as specified
    /// by RFC 6749 § 4.4.2.
    public struct ClientCredentialsGrantRequest: Content {
        /// Always `client_credentials`.
        public let grant_type: String
        
        /// Requested scope of grant. May specify multiple space-separated scopes.
        public let scope: String
        
        /// Memberwise initializer.
        public init(grant_type: String, scope: String) {
            self.grant_type = grant_type
            self.scope = scope
        }

        // See `Content.defaultContentType`.
        public static var defaultContentType: HTTPMediaType { .urlEncodedForm }
    }
    
    /// A generic success response to a request for an OAuth2 access token, as specified by RFC 6749 § 5.1.
    public struct GrantSuccessResponse: Content {
        /// The granted access token.
        public let access_token: String
        
        /// The type of the acess token. Must be `bearer` for `client_credentials` grants.
        public let token_type: String
        
        /// If present, the number of seconds until the acecss token expires.
        public let expires_in: Int?
        
        /// If present, a refresh token for refreshing expired access tokens. Should not be present
        /// for `client_credentials` grants.
        public let refresh_token: String?
        
        /// Scope granted to the access token, if any. May specify multiple space-separated scopes.
        public let scope: String?
        
        /// Memberwise initializer.
        public init(access_token: String, token_type: String, expires_in: Int?, refresh_token: String?, scope: String?) {
            self.access_token = access_token
            self.token_type = token_type
            self.expires_in = expires_in
            self.refresh_token = refresh_token
            self.scope = scope
        }
        
        // See `Content.defaultContentType`.
        public static var defaultContentType: HTTPMediaType { .json }
    }
    
    /// A generic failure response to a request for an OAuth2 access token, as specified by RFC 6749 § 5.2.
    public struct GrantErrorResponse: Content, Error {
        /// A predefined identifier specifying the reason for refusing the grant.
        ///
        /// - Note: Not defined by an enumeration because unfamiliar cases should not throw decoding errors.
        ///   RFC6749 is insufficiently explicit as to whether additional cases are valid.
        public let error: String // invalid_request, invalid_client, invalid_grant, unauthorized_client, unsupported_grant_type, invalid_scope
        
        /// If present, a human-readable description of the error condition.
        public let error_description: String?
        
        /// If present, a URI specifying where to send the user for additional information regarding the error.
        public let error_uri: String?
        
        /// Memberwise initializer.
        public init(error: String, error_description: String?, error_uri: String?) {
            self.error = error
            self.error_description = error_description
            self.error_uri = error_uri
        }
        
        // See `Content.defaultContentType`.
        public static var defaultContentType: HTTPMediaType { .json }
    }

    /// An implementation of Vapor's `Client` protocol which applies OAuth 2-based authorization to all outgoing
    /// requests automatically. Access tokens are requested as needed.
    public final class Client: Vapor.Client {
        /// The underlying `Client` used for all requests.
        public let client: Vapor.Client
        
        /// The `Logger` for all log messages related to this client.
        public let logger: Logger
        
        /// The callback used to request OAuth2 parameters (esp. sensitive credentials) when required.
        private let parametersCallback: (Client) -> EventLoopFuture<Parameters?>
        
        /// The most recently successfully requested access token, if any.
        public private(set) var cachedAccessToken: String?

        // See `Client.eventLoop`.
        public var eventLoop: EventLoop { self.client.eventLoop }
        
        /// Create a new OAuth 2-capable client which automatically requests an access token when needed
        /// and embeds the token in all outgoing requests.
        ///
        /// - Parameters:
        ///   - client: The underlying `Client` to use for actually sending requests.
        ///   - logger: A logger to use for log messages related to the client.
        ///   - parametersCallback: A closure which returns a future whose value is a set of OAuth 2 parameters containing
        ///     the neceessary information (including sensitive credentials such as a client secret) for obtaining access
        ///     tokens. The closure may be invoked more than once. Any credentials returned are retained in memory only
        ///     as long as required to make a request for an access token. The closure may return `nil` to indicate that
        ///     the appropriate parameters are no longer available.
        ///   - cachedAccessToken: An already-retrieved access token to use.
        public init(
            client: Vapor.Client,
            logger: Logger,
            parametersCallback: @escaping (Client) -> EventLoopFuture<Parameters?>,
            cachedAccessToken: String? = nil
        ) {
            self.client = client
            self.logger = logger
            self.parametersCallback = parametersCallback
            self.cachedAccessToken = cachedAccessToken
        }

        // See `Client.delegating(to:)`.
        public func delegating(to eventLoop: EventLoop) -> Vapor.Client {
            OAuth2.Client.init(
                client: self.client.delegating(to: eventLoop), logger: self.logger,
                parametersCallback: self.parametersCallback, cachedAccessToken: self.cachedAccessToken
            )
        }
        
        // See `Client.logging(to:)`.
        public func logging(to logger: Logger) -> Vapor.Client {
            OAuth2.Client.init(
                client: self.client, logger: logger,
                parametersCallback: self.parametersCallback, cachedAccessToken: self.cachedAccessToken
            )
        }
        
        // See `Client.send(_:)`.
        public func send(_ request: ClientRequest) -> EventLoopFuture<ClientResponse> {
            // Allow requests to override automatic OAuth authorization (but then why use an OAuth client at all, though?)
            if request.headers.contains(name: .authorization) {
                return self.client.send(request)
            } else if let cachedAccessToken = self.cachedAccessToken {
                var finalRequest = request
                finalRequest.headers.bearerAuthorization = .init(token: cachedAccessToken)
                return self.client.send(finalRequest)
            } else {
                return self.parametersCallback(self)
                    .unwrap(or: Abort(.unauthorized, reason: "No OAuth2 parameters available"))
                    .flatMap { self.requestGrant(clientId: $0.clientId, clientSecret: $0.clientSecret, from: $0.providerBaseUrl, scopes: $0.scopes) }
                    .flatMap {
                        // TODO: Is this thread-safe in practice if only one event loop is involved?
                        self.cachedAccessToken = $0.access_token
                        return self.send(request)
                    }
            }
        }

        /// Perform an actual OAuth 2 grant request. Return the raw success response.
        ///
        /// Does _not_ set `cachedAccessToken`.
        ///
        /// - Throws: Any error that the underlying `Client` may throw, a `GrantErrorResponse`, a decoding error,
        ///   or an unknown token type error.
        private func requestGrant(
            clientId: String,
            clientSecret: String,
            from baseUrl: URL,
            scopes: [String]
        ) -> EventLoopFuture<GrantSuccessResponse> {
            self.logger.info("[OAuth2] Requesting client_credentials grant")
            
            return self.client.post(.init(string: baseUrl.appendingPathComponent("token", isDirectory: false).absoluteString)) {
                let request = ClientCredentialsGrantRequest(grant_type: "client_credentials", scope: scopes.joined(separator: " "))
                
                $0.headers.basicAuthorization = .init(username: clientId, password: clientSecret)
                try $0.content.encode(request)
            }.flatMapThrowing { res in
                guard res.status == .ok else {
                    do {
                        let error = try res.content.decode(GrantErrorResponse.self)
                        
                        self.logger.notice("[OAuth2] Access token request failed: \(error)")
                        throw error
                    } catch {
                        self.logger.warning("[OAuth2] Access token request failed, and got an error trying to decode the response: \(error)")
                        throw Abort(res.status, reason: "[OAuth2] Access token request failed")
                    }
                }
                
                let response: GrantSuccessResponse
                
                do {
                    response = try res.content.decode(GrantSuccessResponse.self)
                } catch {
                    self.logger.warning("[OAuth2] Access token request succeeded, but got an error trying to decode the response: \(error)")
                    throw Abort(.internalServerError, reason: "[OAuth2] Access token request succeeded, but the response was invalid")
                }
                guard response.token_type == "bearer" else {
                    self.logger.warning("[OAuth2] Access token request returned unknown token type '\(response.token_type)'")
                    throw Abort(.internalServerError, reason: "[OAuth2] Access token request succeeded, but token type is unknown")
                }
                
                self.logger.info("[OAuth2] Received access token grant")
                return response
            }
        }
    }
}


extension Application {
    /// Get an `OAuth2Client` suitable for automatically obtaining access tokens as needed to fulfill each request.
    ///
    /// Uses the application's default `Client` and `Logger`.
    ///
    /// - Parameters:
    ///   - parameters: A closure which returns a future whose value is a set of OAuth 2 parameters containing the
    ///     neceessary information (including sensitive credentials such as a client secret) for obtaining access
    ///     tokens. The closure may be invoked more than once. Any credentials returned are retained in memory only
    ///     as long as required to make a request for an access token. The closure may return `nil` to indicate that
    ///     the appropriate parameters are no longer available.
    public func oauth2(parameters: @escaping (OAuth2.Client) -> EventLoopFuture<OAuth2.Parameters?>) -> OAuth2.Client {
        OAuth2.Client(client: self.client, logger: self.logger, parametersCallback: parameters)
    }
}

extension Request {
    /// Get an `OAuth2Client` suitable for automatically obtaining access tokens as needed to fulfill each request.
    ///
    /// Uses the request's default `Client` and `Logger`.
    ///
    /// - Parameters:
    ///   - parameters: A closure which returns a future whose value is a set of OAuth 2 parameters containing the
    ///     neceessary information (including sensitive credentials such as a client secret) for obtaining access
    ///     tokens. The closure may be invoked more than once. Any credentials returned are retained in memory only
    ///     as long as required to make a request for an access token. The closure may return `nil` to indicate that
    ///     the appropriate parameters are no longer available.
    public func oauth2(parameters: @escaping (OAuth2.Client) -> EventLoopFuture<OAuth2.Parameters?>) -> OAuth2.Client {
        OAuth2.Client(client: self.client, logger: self.logger, parametersCallback: parameters)
    }
}
