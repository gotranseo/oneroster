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

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Request {
    /// Get a `OneRosterClient` suitable for making OneRoster requests to the given base URL without authentication.
    ///
    /// Uses the request's default `Client` and `Logger`.
    ///
    /// - Important: The base URL is allowed to be either a true "base" (the root to which the OneRoster RESTful path
    ///   and version should be appended, i.e. <https://example.com/oneroster>) or the RESTful base (e.g.
    ///   <https://example.com/oneroster/ims/oneroster/v1p1>). The difference is detected based on the presence or
    ///   absence of the `/ims/oneroster/v1p1` path components at the end of the provided URL. If that suffix is
    ///   missing, it will be added for all OneRoster requests. **However**, if the suffix _is_ provided, it is stripped
    ///   for requests relating to authorization, such as OAuth 2 token grant requests.
    public func oneRoster(baseUrl: URL) -> OneRosterClient {
        return OneRosterClient(baseUrl: baseUrl, client: self.client, logger: self.logger)
    }
    
    /// Get a `OneRosterClient` suitable for making OneRoster requests to the given base URL using OAuth1 authentication
    /// with the given credentials.
    ///
    /// Indirectly uses the request's default `Client` and `Logger`.
    public func oauth1OneRoster(baseUrl: URL, clientId: String, clientSecret: String) -> OneRosterClient {
        return OneRosterClient(baseUrl: baseUrl, client: self.oauth1(parameters: .init(clientId: clientId, clientSecret: clientSecret)), logger: self.logger)
    }

    /// Get a `OneRosterClient` suitable for making OneRoster requests to the given base URL using OAuth2 authentication
    /// with the given credentials and scope (defaults to the "core read-only" scope).
    ///
    /// Indirectly uses the request's default `Client` and `Logger`.
    ///
    /// - Important: A base URL is used to construct the OAuth 2 endpoint for making token grant requests, _regardless_
    ///   of whether or not it has the OneRoster RESTful API path suffix. See `oneRoster(baseUrl:)` for more details.
    public func oauth2OneRoster(
        baseUrl: URL, clientId: String, clientSecret: String,
        scope: String = "https://purl.imsglobal.org/spec/or/v1p1/scope/roster-core.readonly"
    ) -> OneRosterClient {
        var providerUrl = baseUrl
        
        if providerUrl.pathComponents.suffix(3) == ["ims", "oneroster", "v1p1"] {
            providerUrl.deleteLastPathComponent()
            providerUrl.deleteLastPathComponent()
            providerUrl.deleteLastPathComponent()
        }
        return OneRosterClient(
            baseUrl: baseUrl,
            client: self.oauth2(parameters: { $0.eventLoop.makeSucceededFuture(.init(
                providerBaseUrl: providerUrl, clientId: clientId, clientSecret: clientSecret, scopes: scope
            )) }),
            logger: self.logger
        )
    }
}
