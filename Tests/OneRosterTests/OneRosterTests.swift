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

import Vapor
import XCTest
import XCTVapor
@testable import OneRoster

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
final class OneRosterTests: XCTestCase {
    func testEndpointRequestUrls() throws {
        XCTAssertEqual(OneRosterAPI.Endpoint.getAllOrgs.makeRequestUrl(from: .init(string: "https://test.com")!)?.absoluteString, "https://test.com/ims/oneroster/v1p1/orgs")
        XCTAssertEqual(OneRosterAPI.Endpoint.getAllOrgs.makeRequestUrl(from: .init(string: "https://test.com/ims/")!)?.absoluteString, "https://test.com/ims/ims/oneroster/v1p1/orgs")
        XCTAssertEqual(OneRosterAPI.Endpoint.getAllOrgs.makeRequestUrl(from: .init(string: "https://test.com/ims/oneroster/v1p1")!)?.absoluteString, "https://test.com/ims/oneroster/v1p1/orgs")
    }
    
    func testOauth1() throws {
        guard let url = OneRosterAPI.Endpoint.getAllOrgs.makeRequestUrl(
            from: .init(string: "https://test.com/ims/oneroster/v1p1/")!,
            limit: 100,
            offset: 1515,
            filterString: "role%3D%27administrator%27%20OR%20role%3D%27student%27%20OR%20role%3D%27teacher%27"
        ) else {
            XCTFail("Could not generate URL")
            return
        }
        
        let expectedUrl = "https://test.com/ims/oneroster/v1p1/orgs?limit=100&offset=1515&filter=role%3D%27administrator%27%20OR%20role%3D%27student%27%20OR%20role%3D%27teacher%27"

        XCTAssertEqual(url.absoluteString, expectedUrl)
        
        let expectedSignatureEncoded = "03DqhuWFnTlc3WxDYEOVKYxM5xQyRGfJ4x6zqQjYQnM%3D"
        let expectedHeaderString = "OAuth oauth_consumer_key=\"client-id\", oauth_nonce=\"fake-nonce\", oauth_signature=\"\(expectedSignatureEncoded)\", oauth_signature_method=\"HMAC-SHA256\", oauth_timestamp=\"10000000\", oauth_version=\"1.0\""
        
        let oauthClient = OAuth1.Client(client: FakeClient(), logger: .init(label: ""), parameters: .init(clientId: "client-id", clientSecret: "client-secret", timestamp: Date(timeIntervalSince1970: 10000000.0), nonce: "fake-nonce"))
        let headerString = "OAuth \(oauthClient.generateAuthorizationHeader(for: .init(method: .GET, url: .init(string: url.absoluteString), headers: [:], body: nil)))"
        
        XCTAssertEqual(headerString, expectedHeaderString)
    }
    
    func testMultiObjectRequest() async throws {
        let app = Application(.testing)
        
        defer { app.shutdown() }
        app.get("ims", "oneroster", "v1p1", "orgs") { (req: Request) -> Response in
            let allOrgs: [OrgsResponse.InnerType] = [
                .init(sourcedId: "1", status: .active, dateLastModified: "\(Date())", metadata: nil, name: "A", type: .district, identifier: nil, parent: nil, children: nil),
                .init(sourcedId: "2", status: .active, dateLastModified: "\(Date())", metadata: nil, name: "B", type: .district, identifier: nil, parent: nil, children: nil),
                .init(sourcedId: "3", status: .active, dateLastModified: "\(Date())", metadata: nil, name: "C", type: .district, identifier: nil, parent: nil, children: nil),
                .init(sourcedId: "4", status: .active, dateLastModified: "\(Date())", metadata: nil, name: "D", type: .district, identifier: nil, parent: nil, children: nil),
            ]
            let limit: Int = req.query["limit"] ?? 100
            let offset: Int = req.query["offset"] ?? allOrgs.startIndex
            //let filter: String? = req.query["filter"]
            let response = Response(status: .ok)
            var links: [HTTPHeaders.Link] = []
            var urlComponents = try XCTUnwrap(URLComponents(string: req.url.string))
            
            if allOrgs.indices.contains(offset + limit), offset + limit != allOrgs.indices.last, offset != allOrgs.startIndex,
               let offsetItemIdx = urlComponents.queryItems?.firstIndex(where: { $0.name == "offset" })
            {
                urlComponents.queryItems?[offsetItemIdx] = .init(name: "offset", value: "\(offset + limit)")
                links.append(.init(uri: urlComponents.url!.absoluteString, relation: .next, attributes: [:]))
            }
            if let offsetItemIdx = urlComponents.queryItems?.firstIndex(where: { $0.name == "offset" }) {
                urlComponents.queryItems?[offsetItemIdx] = .init(name: "offset", value: "\(allOrgs.startIndex)")
                links.append(.init(uri: urlComponents.url!.absoluteString, relation: .first, attributes: [:]))
                urlComponents.queryItems?[offsetItemIdx] = .init(name: "offset", value: "\(Array(stride(from: allOrgs.startIndex, to: allOrgs.endIndex, by: limit)).last ?? allOrgs.startIndex)")
                links.append(.init(uri: urlComponents.url!.absoluteString, relation: .last, attributes: [:]))
            }
            if !links.isEmpty {
                response.headers.links = links
            }
            
            try response.content.encode(OrgsResponse(orgs: .init(allOrgs[(offset ..< (offset + limit)).clamped(to: allOrgs.startIndex ..< allOrgs.endIndex)])), as: .json)
            return response
        }
        
        try app.start()
        
        let response: [Org] = try await app.oneRoster(baseUrl: .init(string: "http://localhost:8080")!).request(.getAllOrgs, as: OrgsResponse.self)
        
        XCTAssertEqual(response.count, 4)
    }
}

extension OrgsResponse: Content {}

/// Throwaway definition that allows creating an `OAuth1.Client` without actually using it.
private final class FakeClient: Vapor.Client {
    var eventLoop: EventLoop { fatalError() }
    func delegating(to eventLoop: EventLoop) -> Client { self }
    func logging(to logger: Logger) -> Client { self }
    func send(_ request: ClientRequest) -> EventLoopFuture<ClientResponse> { fatalError() }
}
