import XCTest
@testable import OneRoster

final class OneRosterTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(OneRoster().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
