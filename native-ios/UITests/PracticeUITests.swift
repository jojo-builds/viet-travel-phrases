import XCTest

final class PracticeUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testPracticeHubUsesMatchPracticeInsteadOfMessages() {
        let app = launchPracticeApp()

        XCTAssertTrue(app.staticTexts["Practice"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Quick practice"].waitForExistence(timeout: 8))
        scrollUntilStaticTextExists("Practice by topic", in: app)
        XCTAssertFalse(app.staticTexts["Messages"].exists)
        XCTAssertFalse(app.descendants(matching: .any)["Practice.Messages.Contacts"].exists)
        XCTAssertFalse(app.descendants(matching: .any)["Practice.Messages.Thread"].exists)
    }

    func testQuickPracticeOpensSingleFourPairMatchRound() {
        let app = launchPracticeApp()

        tapStaticText("Quick practice", in: app)

        XCTAssertTrue(app.staticTexts["Match the pairs"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Phrase"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["Need a hint?"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.staticTexts["0 of 4"].exists)
        XCTAssertFalse(app.staticTexts["1 / 10"].exists)
    }

    func testPracticeSavedSourceStartsFromSavedTripItems() {
        let app = launchPracticeApp(extraArguments: ["--seed-returning-user-shelves"])

        XCTAssertTrue(app.staticTexts["Practice Saved"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["6 practice-ready"].exists)
        XCTAssertTrue(app.staticTexts["My practice phrases"].exists)
        XCTAssertTrue(app.staticTexts["5 practice-ready"].exists)

        tapStaticText("Practice Saved", in: app)

        XCTAssertTrue(app.staticTexts["Match the pairs"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Phrase"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.staticTexts["1 / 10"].exists)
    }

    func testLegacyPracticeScenarioLaunchFallsBackToMatchRound() {
        let app = launchPracticeApp(extraArguments: ["--practice-scenario", "danangFirstDay"])

        XCTAssertTrue(app.staticTexts["Match the pairs"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.descendants(matching: .any)["Practice.Messages.Thread"].exists)
    }

    private func launchPracticeApp(extraArguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["--practice", "--reset-demo-state"] + extraArguments
        app.launch()
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 8))
        return app
    }

    private func tapStaticText(_ title: String, in app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        let text = app.staticTexts[title]
        XCTAssertTrue(text.waitForExistence(timeout: 8), file: file, line: line)
        text.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    private func scrollUntilStaticTextExists(_ title: String, in app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        let text = app.staticTexts[title]
        for _ in 0..<5 {
            if text.waitForExistence(timeout: 1) {
                return
            }
            app.swipeUp()
        }

        XCTFail("Static text did not appear: \(title)", file: file, line: line)
    }
}
