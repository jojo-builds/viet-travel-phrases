import XCTest

final class PracticeUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testPracticeHubUsesMatchPracticeInsteadOfMessages() {
        let app = launchPracticeApp()

        XCTAssertTrue(app.staticTexts["Practice"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["Practice.Match.Source.quick"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["Practice by topic"].exists)
        XCTAssertFalse(app.staticTexts["Messages"].exists)
        XCTAssertFalse(app.descendants(matching: .any)["Practice.Messages.Contacts"].exists)
        XCTAssertFalse(app.descendants(matching: .any)["Practice.Messages.Thread"].exists)
    }

    func testQuickPracticeOpensSingleFourPairMatchRound() {
        let app = launchPracticeApp()

        let quickButton = app.buttons["Practice.Match.Source.quick"]
        XCTAssertTrue(quickButton.waitForExistence(timeout: 8))
        quickButton.tap()

        XCTAssertTrue(app.staticTexts["Match all pairs"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["0 / 4"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["Xin chào"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["Cảm ơn"].exists)
        XCTAssertTrue(app.buttons["Hello"].exists)
        XCTAssertTrue(app.buttons["Thank you"].exists)
        XCTAssertFalse(app.staticTexts["1 / 10"].exists)
    }

    func testPracticeSavedSourceStartsFromSavedTripItems() {
        let app = launchPracticeApp(extraArguments: ["--seed-returning-user-shelves"])

        let savedPracticeButton = app.buttons["Practice.Match.Source.saved"]
        XCTAssertTrue(savedPracticeButton.waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["Practice Saved"].exists)
        XCTAssertTrue(app.staticTexts["6 practice-ready"].exists)
        XCTAssertFalse(app.buttons["Practice.Match.Source.practice"].exists)

        savedPracticeButton.tap()

        XCTAssertTrue(app.staticTexts["Match all pairs"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["0 / 4"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.staticTexts["1 / 10"].exists)
    }

    func testLegacyPracticeScenarioLaunchFallsBackToMatchRound() {
        let app = launchPracticeApp(extraArguments: ["--practice-scenario", "danangFirstDay"])

        XCTAssertTrue(app.staticTexts["Match all pairs"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.descendants(matching: .any)["Practice.Messages.Thread"].exists)
    }

    private func launchPracticeApp(extraArguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["--practice", "--reset-demo-state"] + extraArguments
        app.launch()
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 8))
        return app
    }
}
