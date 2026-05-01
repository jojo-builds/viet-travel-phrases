import XCTest

final class PracticeUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testWrongAnswerContinueAdvancesToNextPrompt() {
        let app = XCUIApplication()
        app.launchArguments = ["--practice-mode", "hanoiBucketList"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Prompt 1 of 8"].waitForExistence(timeout: 8))

        let optionButtons = app.buttons.allElementsBoundByIndex.filter { button in
            button.label.contains(",") && button.frame.minY > 420 && button.frame.minY < 790
        }
        XCTAssertGreaterThanOrEqual(optionButtons.count, 2)

        guard let wrongOption = optionButtons.first(where: { !$0.label.hasPrefix("Bún chả Hương Liên,") }) else {
            XCTFail("Expected at least one incorrect answer option")
            return
        }
        wrongOption.tap()

        let continueButton = app.buttons["Next"].firstMatch
        XCTAssertTrue(continueButton.waitForExistence(timeout: 3))
        continueButton.tap()

        XCTAssertTrue(app.staticTexts["Prompt 2 of 8"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.buttons["Practice.ContinueButton"].exists)
    }
}
