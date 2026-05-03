import XCTest

final class PracticeUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testLessFittingScenarioResponseShowsCalmFeedbackAndAdvances() {
        let app = XCUIApplication()
        app.launchArguments = ["--practice"]
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["SCENARIO MODE"].waitForExistence(timeout: 4))

        let startButton = app.buttons["Start travel rehearsal"].firstMatch
        XCTAssertTrue(startButton.waitForExistence(timeout: 4))
        startButton.tap()

        XCTAssertTrue(app.staticTexts["Step 1 of 2"].waitForExistence(timeout: 4))
        let alternateOption = app.buttons.containing(NSPredicate(format: "label CONTAINS %@", "Is this my car")).firstMatch
        XCTAssertTrue(alternateOption.waitForExistence(timeout: 4))
        alternateOption.tap()

        XCTAssertTrue(app.staticTexts["Better for another moment"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "incorrect")).element.exists)

        let continueButton = app.buttons["Next"].firstMatch
        XCTAssertTrue(continueButton.waitForExistence(timeout: 3))
        continueButton.tap()

        XCTAssertTrue(app.staticTexts["Step 2 of 2"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.buttons["Practice.ContinueButton"].exists)
    }

    func testScenarioModeProofScreenshots() {
        guard let proofDirectoryURL else {
            return
        }

        var app = launchPracticeApp()
        XCTAssertTrue(app.staticTexts["SCENARIO MODE"].waitForExistence(timeout: 4))
        capture(app: app, directoryURL: proofDirectoryURL, name: "scenario-mode-hub.png")

        startPrimaryScenario(in: app)
        XCTAssertTrue(app.staticTexts["Step 1 of 2"].waitForExistence(timeout: 4))
        capture(app: app, directoryURL: proofDirectoryURL, name: "taxi-grab-scenario.png")

        tapOption(containing: "Is this my car", in: app)
        XCTAssertTrue(app.staticTexts["Better for another moment"].waitForExistence(timeout: 3))
        app.swipeUp()
        capture(app: app, directoryURL: proofDirectoryURL, name: "soft-feedback-state.png")

        tapButton("Next", in: app)
        XCTAssertTrue(app.staticTexts["Step 2 of 2"].waitForExistence(timeout: 3))
        tapOption(containing: "Please follow the map", in: app)
        tapButton("Finish", in: app)
        XCTAssertTrue(app.staticTexts["Travel rehearsal complete"].waitForExistence(timeout: 4))
        capture(app: app, directoryURL: proofDirectoryURL, name: "completion-state.png")
        app.terminate()

        app = launchPracticeApp()
        openScenario(identifier: "Practice.Scenario.restaurantOrderingPayment", title: "Restaurant ordering", in: app)
        capture(app: app, directoryURL: proofDirectoryURL, name: "restaurant-scenario.png")
        app.terminate()

        app = launchPracticeApp()
        openScenario(identifier: "Practice.Scenario.hotelCheckInHelp", title: "Hotel check-in", in: app)
        capture(app: app, directoryURL: proofDirectoryURL, name: "hotel-airbnb-scenario.png")
        app.terminate()
    }

    private var proofDirectoryURL: URL? {
        let environmentPath = ProcessInfo.processInfo.environment["SPEAKLOCAL_PRACTICE_SCENARIO_PROOF_DIR"]
        if let environmentPath, !environmentPath.isEmpty {
            return URL(fileURLWithPath: environmentPath, isDirectory: true)
        }

        guard FileManager.default.fileExists(atPath: "/tmp/speaklocal-practice-scenario-proof-enabled") else {
            return nil
        }

        let testFileURL = URL(fileURLWithPath: #filePath)
        let repoRootURL = testFileURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()

        return repoRootURL
            .appendingPathComponent("docs/task-results/assets/TASK-PRACTICE-PERSONAL-QUEUE-NATIVE-001", isDirectory: true)
    }

    private func launchPracticeApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["--practice"]
        app.launch()
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 8))
        return app
    }

    private func startPrimaryScenario(in app: XCUIApplication) {
        tapButton("Start travel rehearsal", in: app)
    }

    private func openScenario(identifier: String, title: String, in app: XCUIApplication) {
        XCTAssertTrue(app.staticTexts["SCENARIO MODE"].waitForExistence(timeout: 4))
        app.swipeUp()

        let scenarioButton = app.buttons[identifier].firstMatch
        XCTAssertTrue(scenarioButton.waitForExistence(timeout: 4), "\(title) scenario did not appear.")
        scenarioButton.tap()

        XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Step 1 of 2"].waitForExistence(timeout: 4))
        app.swipeDown()
        XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 4))
    }

    private func tapOption(containing text: String, in app: XCUIApplication) {
        let option = app.buttons.containing(NSPredicate(format: "label CONTAINS %@", text)).firstMatch
        XCTAssertTrue(option.waitForExistence(timeout: 4), "Option containing \(text) did not appear.")
        option.tap()
    }

    private func tapButton(_ label: String, in app: XCUIApplication) {
        let button = app.buttons[label].firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 4), "\(label) button did not appear.")
        button.tap()
    }

    private func capture(app: XCUIApplication, directoryURL: URL, name: String) {
        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: directoryURL.appendingPathComponent(name))
    }
}
