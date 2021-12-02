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
    override static func setUp() {
        XCTAssertTrue(isLoggingConfigured)
        if ProcessInfo.processInfo.environment["SWIFT_DETERMINISTIC_HASHING"]?.isEmpty ?? true {
            print("WARNING: Without deterministic hashing, the OAuth 1 tests will probably fail!")
        }
    }
    
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
        let expectedHeaderString = #"OAuth oauth_signature_method="HMAC-SHA256", oauth_signature="\#(expectedSignatureEncoded)", oauth_consumer_key="client-id", oauth_timestamp="10000000", oauth_version="1.0", oauth_nonce="fake-nonce""#
        
        let oauthSignature = OAuth1.generateSignature(for: url, method: .GET, body: nil, using: .init(clientId: "client-id", clientSecret: "client-secret", timestamp: Date(timeIntervalSince1970: 10000000.0), nonce: "fake-nonce"))
        let headerString = "OAuth \(oauthSignature)"
        
        XCTAssertEqual(headerString, expectedHeaderString)
    }
    
    func testMultiObjectRequest() throws {
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
        
        let response: [Org] = try app.eventLoopGroup.performWithTask { try await app.oneRoster(baseUrl: .init(string: "http://localhost:8080")!).request(.getAllOrgs, as: OrgsResponse.self) }.wait()
        
        XCTAssertEqual(response.count, 4)
    }
}

extension OrgsResponse: Content {}

let isLoggingConfigured: Bool = {
    var env = Environment.testing
    try! LoggingSystem.bootstrap(from: &env)
    return true
}()
