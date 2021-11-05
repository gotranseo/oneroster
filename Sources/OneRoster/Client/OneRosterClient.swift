//
//  OneRosterClient.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation
import Crypto
import Vapor
import Logging

public struct OneRosterClient {
    public let baseUrl: URL
    public let client: Client
    public let logger: Logger

    public init(baseUrl: URL, client: Client, logger: Logger) {
        self.baseUrl = baseUrl
        self.client = client
        self.logger = logger
    }
    
    /// To use OAuth, specify an `OAuth1.Client` or `OAuth2.Client` when creating the `OneRosterClient`.
    public func request<T: OneRosterResponse>(
        _ endpoint: OneRosterAPI.Endpoint, as type: T.Type = T.self, filter: String? = nil
    ) async throws -> T {
        self.logger.info("[OneRoster] Start request \(T.self) from \(self.baseUrl) @ \(endpoint.endpoint)")
        
        guard let fullUrl = endpoint.makeRequestUrl(from: self.baseUrl, filterString: filter) else {
            self.logger.error("[OneRoster] Unable to generate request URL!") // this should really never happen
            throw Abort(.internalServerError, reason: "Failed to generate OneRoster request URL")
        }
        
        let response = try await self.client.get(.init(string: fullUrl.absoluteString))
        
        guard response.status == .ok else {
            throw OneRosterError(from: response)
        }
        
        // response content type will be JSON, so the configured default JSON decoder will be used
        return try response.content.decode(T.self)
    }
    
    public func request<T: OneRosterResponse>(
        _ endpoint: OneRosterAPI.Endpoint, as type: T.Type = T.self,
         offset: Int = 0, limit: Int = 100, filter: String? = nil
    ) async throws -> [T.InnerType] {
        precondition(T.dataKey != nil, "Multiple-item request must be for a type with a data key")
        
        self.logger.info("[OneRoster] Start request [\(T.InnerType.self)][\(offset)..<+\(limit)] from \(self.baseUrl) @ \(endpoint.endpoint)")
        
        // OneRoster implementations are not strictly required by the 1.1 spec to provide the `X-Total-Count` response
        // header, nor next/last URLs in the `Link` header (per OneRoster 1.1 v2.0, § 3.4.1). For any given response, we
        // try to determine whether or not we're done based on the following algorithm:
        //
        // 1. If the implementation provides a `rel="last"` link, and it matches the most recent request, assume we're
        //    done.
        // 2. Otherwise, if the implementation provides a `rel="next"` link, assume we're not done and use that as the
        //    next request, _UNLESS_ the link matches the last request made, in which case assume we're done to avoid
        //    accidental loops.
        // 3. Otherwise, if the implementation returned zero results for the current request, assume we're done.
        // 4. Otherwise, if the implementation provided an `X-Total-Count` header, and we've accumulated at least that
        //    many results, adjusted for the offset of the first request made, assume we're done.
        // 5. Otherwise, if we've made more than 10,000 requests as part of the current request series, assume we're
        //    caught in a loop caused by faulty results from the implementation (such as sending rel="next" links which
        //    actually point backwards) and return an error.
        // 6. Otherwise, add the limit to the last offset and use the result as the current offset in the next request.
        var results: [T.InnerType] = []
        var currentOffset = offset
        var nextUrl = endpoint.makeRequestUrl(from: self.baseUrl, limit: limit, offset: currentOffset, filterString: filter)
        
        for n in 0 ..< 10_000 {
            guard let fullUrl = nextUrl else {
                self.logger.error("[OneRoster] Unable to generate request URL!") // this should really never happen
                throw Abort(.internalServerError, reason: "Failed to generate OneRoster request URL")
            }
            self.logger.info("[OneRoster] Starting request \(n + 1)...")
            
            let response = try await self.client.get(.init(string: fullUrl.absoluteString))
            guard response.status == .ok else { throw OneRosterError(from: response) }
            let currentResults = try response.content.decode(T.self).oneRosterDataKey! // already checked that the type has a dataKey
            
            results.append(contentsOf: currentResults)
            
            if n == 0, let totalCountHeader = response.headers.first(name: "x-total-count") {
                self.logger.info("[OneRoster] Server reported a total count: \(totalCountHeader)")
            }
            
            let links = Dictionary(grouping: (response.headers.links ?? []), by: { $0.relation })
            
            if let lastLink = links[.last]?.first, let lastUrl = URL(string: lastLink.uri, relativeTo: fullUrl),
               let lastComponents = URLComponents(url: lastUrl, resolvingAgainstBaseURL: true),
               let lastUrlCanonical = lastComponents.url, lastUrlCanonical == fullUrl
            {
                self.logger.debug("[OneRoster] \"last\" link matches current request, assuming done.")
                return results
            }
            else if let nextLink = links[.next]?.first, let likelyNextUrl = URL(string: nextLink.uri, relativeTo: fullUrl),
                    let nextComponents = URLComponents(url: likelyNextUrl, resolvingAgainstBaseURL: true)
            {
                if let nextUrlCanonical = nextComponents.url, nextUrlCanonical == fullUrl {
                    // Looks like a repeat, bail.
                    self.logger.warning("[OneRoster] Next URL from endpoint matches last request made, stopping here.")
                    return results
                }
                if let nextOffsetString = nextComponents.queryItems?.first(where: { $0.name == "offset" })?.value,
                   let nextOffset = Int(nextOffsetString)
                {
                    currentOffset = nextOffset
                }
                self.logger.debug("[OneRoster] Using provided \"next\" URL.")
                nextUrl = likelyNextUrl
            }
            else if currentResults.isEmpty {
                self.logger.debug("[OneRoster] No results returned and no \"next\" link provided, assuming done.")
                return results
            }
            else if let totalCountHeader = response.headers.first(name: "x-total-count"),
                    let totalCount = Int(totalCountHeader),
                    (results.count + offset) >= totalCount
            {
                self.logger.debug("[OneRoster] Current adjusted total \(results.count) + \(offset) >= reported total \(totalCount), assuming done.")
                return results
            }
            else
            {
                self.logger.debug("[OneRoster] Preparing for next request by manually adding limit to offset.")
                currentOffset += limit
                nextUrl = endpoint.makeRequestUrl(from: self.baseUrl, limit: limit, offset: currentOffset, filterString: filter)
            }
        }
        self.logger.error("[OneRoster] Made 10,000 requests and still haven't finished! We're probably caught in a loop.")
        throw Abort(.internalServerError, reason: "OneRoster request loop failed to terminate")
    }
}

extension URLComponents {
    /// Add a `URLQueryItem` with the given name and value to the `queryItems` component.
    ///
    /// The `queryItems` array is created if it is currently `nil`.
    public mutating func appendQueryItem(name: String, value: String? = nil) {
        self.queryItems = (self.queryItems ?? []) + [URLQueryItem(name: name, value: value)]
    }

    /// Add a `URLQueryItem` with the given percent-encoded name and value to the `percentEncodedQueryItems` component.
    ///
    /// The `percentEncodedQueryItems` array is created if it is currently `nil`.
//    public mutating func appendPercentEncodedQueryItem(name: String, value: String? = nil) {
//        self.percentEncodedQueryItems = (self.percentEncodedQueryItems ?? []) + [URLQueryItem(name: name, value: value)]
//    }
}

extension OneRosterAPI.Endpoint {
    func makeRequestUrl(from baseUrl: URL, limit: Int? = nil, offset: Int? = nil, filterString: String? = nil) -> URL? {
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else {
            return nil
        }

        // Setting `URLComponents.queryItems` to an empty array results in a URL with a `?` appended to it even
        // if there are never any query items added to the array, e.g. `https://localhost/?`. This is not really
        // canonical form (although by RFC the `?` by itself has no semantic effect), so we use the helpers
        // instead to ensure an array is only set when needed.
        
        if let limit = limit {
            components.appendQueryItem(name: "limit", value: "\(limit)")
        }
        if let offset = offset {
            components.appendQueryItem(name: "offset", value: "\(offset)")
        }
        if let filterString = filterString, let encoded = filterString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
            components.appendQueryItem(name: "filter", value: encoded)
        }
        
        guard var paramUrl = components.url else {
            return nil
        }
        
        if paramUrl.pathComponents.suffix(3) != ["ims", "oneroster", "v1p1"] {
            paramUrl.appendPathComponent("ims", isDirectory: true)
            paramUrl.appendPathComponent("oneroster", isDirectory: true)
            paramUrl.appendPathComponent("v1p1", isDirectory: true)
        }
        paramUrl.appendPathComponent(self.endpoint, isDirectory: false)
        
        return paramUrl
    }
}
