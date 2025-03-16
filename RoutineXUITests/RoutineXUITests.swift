import XCTest

final class RoutineXUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    @MainActor
    func testExample() throws {}

    @MainActor
    func testLaunchPerformance() throws {}
}
