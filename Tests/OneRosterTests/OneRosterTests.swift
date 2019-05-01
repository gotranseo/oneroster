import XCTest
@testable import OneRoster
import Vapor

final class OneRosterTests: XCTestCase {
    func testExample() throws {
        let app = try Application()
        let client = try app.make(Client.self)
        

    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
