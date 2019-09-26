import XCTest
@testable import Tavern

final class TavernTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Tavern().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
