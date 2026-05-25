import XCTest

final class PracticeUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testPracticeHubUsesMatchPracticeInsteadOfMessages() {
        let app = launchPracticeApp()

        XCTAssertTrue(app.staticTexts["Practice"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Practice Saved"].waitForExistence(timeout: 8))
        XCTAssertFalse(app.staticTexts["Quick practice"].exists)
        XCTAssertFalse(app.staticTexts["My practice phrases"].exists)
        scrollUntilStaticTextExists("Practice by topic", in: app)
        XCTAssertFalse(app.staticTexts["Messages"].exists)
        XCTAssertFalse(app.descendants(matching: .any)["Practice.Messages.Contacts"].exists)
        XCTAssertFalse(app.descendants(matching: .any)["Practice.Messages.Thread"].exists)
    }

    func testPracticeSavedOpensSingleFourPairMatchRound() {
        let app = launchPracticeApp(extraArguments: ["--seed-returning-user-shelves"])

        tapStaticText("Practice Saved", in: app)

        XCTAssertTrue(app.staticTexts["Match the pairs"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Phrase"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["Need a hint?"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.staticTexts["0 of 4"].exists)
        XCTAssertFalse(app.staticTexts["1 / 10"].exists)
    }

    func testEssentialsTopicMatchRoundSheetDismissesWithSwipeDown() {
        let app = launchPracticeApp()

        scrollUntilStaticTextExists("Practice by topic", in: app)
        scrollUntilStaticTextIsHittable("Essentials", in: app)
        tapStaticText("Essentials", in: app)

        XCTAssertTrue(app.staticTexts["Match the pairs"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Phrase"].waitForExistence(timeout: 4))

        dragVertically(in: app, from: 0.58, to: 0.94)
        XCTAssertTrue(app.descendants(matching: .any)["Practice.Match.Root"].waitForNonExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Practice by topic"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Essentials"].exists)
    }

    func testPracticeSavedSourceStartsFromSavedTripItems() {
        let app = launchPracticeApp(extraArguments: ["--seed-returning-user-shelves"])

        XCTAssertTrue(app.staticTexts["Practice Saved"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["6 practice-ready"].exists)
        XCTAssertFalse(app.staticTexts["Quick practice"].exists)
        XCTAssertFalse(app.staticTexts["My practice phrases"].exists)

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

    private func scrollUntilStaticTextIsHittable(_ title: String, in app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        let text = app.staticTexts[title]
        for _ in 0..<5 {
            if text.waitForExistence(timeout: 1), text.isHittable {
                return
            }
            app.swipeUp()
        }

        XCTAssertTrue(text.waitForExistence(timeout: 1), file: file, line: line)
        XCTAssertTrue(text.isHittable, file: file, line: line)
    }

    private func dragVertically(in app: XCUIApplication, from startY: CGFloat, to endY: CGFloat) {
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: startY))
            .press(
                forDuration: 0.1,
                thenDragTo: app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: endY))
            )
    }
}
