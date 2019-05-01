import XCTest
@testable import OneRoster

final class OneRosterTests: XCTestCase {
    func testOauth() throws {
        let oauthData = try OAuth(clientId: "client-id",
                                  clientSecret: "client-secret",
                                  baseUrl: "https://test.com/ims/oneroster/v1p1/",
                                  endpoint: .getAllOrgs,
                                  limit: 100,
                                  offset: 1515).generate(nonce: "fake-nonce", timestamp: 10000000)
        
        let expectedSignature = "ONJ%2FjQwnt6+dosTnICfxqbE6F2945oZz0sDJipo64ZY%3D"
        let expectedUrl = "https://test.com/ims/oneroster/v1p1/orgs?limit=100&offset=1515"
        let expectedHeaderString = "OAuth oauth_consumer_key=\"client-id\", oauth_nonce=\"fake-nonce\", oauth_signature=\"ONJ%2FjQwnt6+dosTnICfxqbE6F2945oZz0sDJipo64ZY%3D\", oauth_signature_method=\"HMAC-SHA256\", oauth_timestamp=\"10000000.0\", oauth_version=\"1.0\""
        
        XCTAssertEqual(oauthData.signature, expectedSignature)
        XCTAssertEqual(oauthData.fullUrl, expectedUrl)
        XCTAssertEqual(oauthData.oauthHeaderString, expectedHeaderString)
    }

    static var allTests = [
        ("testOauth", testOauth),
    ]
}
