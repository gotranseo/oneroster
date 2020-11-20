import XCTest
@testable import OneRoster

final class OneRosterTests: XCTestCase {
    func testOauth() throws {
        guard let url = OneRosterAPI.Endpoint.getAllOrgs.fullUrl(
            baseUrl: "https://test.com/ims/oneroster/v1p1/",
            limit: 100,
            offset: 1515,
            filterString: "role%3D%27administrator%27%20OR%20role%3D%27student%27%20OR%20role%3D%27teacher%27"
        ) else {
            XCTFail("Could not generate URL")
            return
        }
        
        let oauthData = try OAuth(consumerKey: "client-id",
                                  consumerSecret: "client-secret",
                                  url: url).generate(nonce: "fake-nonce", timestamp: 10000000)
        
        let expectedSignature = "PGXnIZRR3UtXMvSR6c9GA7fAp6KqdnafYjsOvwsSjxE="
        let expectedSignatureEncoded = "PGXnIZRR3UtXMvSR6c9GA7fAp6KqdnafYjsOvwsSjxE%3D"
        let expectedUrl = "https://test.com/ims/oneroster/v1p1/orgs?limit=100&offset=1515&filter=role%3D%27administrator%27%20OR%20role%3D%27student%27%20OR%20role%3D%27teacher%27"
        let expectedHeaderString = "OAuth oauth_consumer_key=\"client-id\",oauth_nonce=\"fake-nonce\",oauth_signature=\"\(expectedSignatureEncoded)\",oauth_signature_method=\"HMAC-SHA256\",oauth_timestamp=\"10000000.0\",oauth_version=\"1.0\""
        
        XCTAssertEqual(oauthData.signature, expectedSignature)
        XCTAssertEqual(url.absoluteString, expectedUrl)
        XCTAssertEqual(oauthData.oauthHeaderString, expectedHeaderString)
    }

    static var allTests = [
        ("testOauth", testOauth),
    ]
}
