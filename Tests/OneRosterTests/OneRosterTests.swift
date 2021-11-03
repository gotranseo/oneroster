import XCTest
import XCTVapor
@testable import OneRoster

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
    
    func testSingleObjectRequest() async throws {
        let app = Application(.testing)
        
        app.get("ims", "oneroster", "v1p1", "orgs") { (req: Request) -> OrgsResponse in
            let allOrgs: [OrgsResponse.InnerType] = [
                .init(sourcedId: "1", status: .active, dateLastModified: "\(Date())", metadata: nil, name: "A", type: .district, identifier: nil, parent: nil, children: nil),
                .init(sourcedId: "2", status: .active, dateLastModified: "\(Date())", metadata: nil, name: "B", type: .district, identifier: nil, parent: nil, children: nil),
                .init(sourcedId: "3", status: .active, dateLastModified: "\(Date())", metadata: nil, name: "C", type: .district, identifier: nil, parent: nil, children: nil),
                .init(sourcedId: "4", status: .active, dateLastModified: "\(Date())", metadata: nil, name: "D", type: .district, identifier: nil, parent: nil, children: nil),
            ]
            let limit: Int = req.query["limit"] ?? 100
            let offset: Int = req.query["offset"] ?? allOrgs.startIndex
            //let filter: String? = req.query["filter"]
            
            return OrgsResponse(orgs: .init(allOrgs[(offset ..< (offset + limit)).clamped(to: allOrgs.startIndex ..< allOrgs.endIndex)]))
        }
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
