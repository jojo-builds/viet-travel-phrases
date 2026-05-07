import XCTest

final class PracticeUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testScenarioModeReadsAsGuidedRehearsal() {
        let app = XCUIApplication()
        app.launchArguments = ["--practice"]
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["SCENARIO MODE"].waitForExistence(timeout: 4))

        let startButton = app.buttons["Start scene"].firstMatch
        XCTAssertTrue(startButton.waitForExistence(timeout: 4))
        startButton.tap()

        XCTAssertTrue(app.staticTexts["Moment 1 of 2"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["You hear"].exists)
        XCTAssertTrue(app.staticTexts["Best quick reply"].exists)
        XCTAssertTrue(app.staticTexts["More ways to say it"].exists)
        XCTAssertTrue(app.staticTexts["If unsure"].exists)

        XCTAssertFalse(app.staticTexts["Check fit"].exists)
        XCTAssertFalse(app.staticTexts["Good fit for this moment"].exists)
        XCTAssertFalse(app.staticTexts["Review missed"].exists)
        XCTAssertFalse(app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "incorrect")).element.exists)

        let continueButton = app.buttons["Next moment"].firstMatch
        XCTAssertTrue(continueButton.waitForExistence(timeout: 3))
        continueButton.tap()

        XCTAssertTrue(app.staticTexts["Moment 2 of 2"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Finish scene"].waitForExistence(timeout: 3))
    }

    func testScenarioModeProofScreenshots() {
        guard let proofDirectoryURL else {
            return
        }

        var app = launchPracticeApp()
        XCTAssertTrue(app.staticTexts["SCENARIO MODE"].waitForExistence(timeout: 4))
        capture(app: app, directoryURL: proofDirectoryURL, name: "scenario-mode-hub.png")

        startPrimaryScenario(in: app)
        XCTAssertTrue(app.staticTexts["Moment 1 of 2"].waitForExistence(timeout: 4))
        capture(app: app, directoryURL: proofDirectoryURL, name: "taxi-grab-moment-1.png")

        tapButton("Next moment", in: app)
        XCTAssertTrue(app.staticTexts["Moment 2 of 2"].waitForExistence(timeout: 3))
        capture(app: app, directoryURL: proofDirectoryURL, name: "taxi-grab-moment-2.png")

        tapButton("Finish scene", in: app)
        XCTAssertTrue(app.staticTexts["Scene complete"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.staticTexts["That is correct"].exists)
        app.swipeDown()
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
            .appendingPathComponent("docs/task-results/assets/TASK-PRACTICE-SCENARIO-REHEARSAL-001", isDirectory: true)
    }

    private func launchPracticeApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["--practice"]
        app.launch()
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 8))
        return app
    }

    private func startPrimaryScenario(in app: XCUIApplication) {
        tapButton("Start scene", in: app)
    }

    private func openScenario(identifier: String, title: String, in app: XCUIApplication) {
        XCTAssertTrue(app.staticTexts["SCENARIO MODE"].waitForExistence(timeout: 4))
        app.swipeUp()

        let scenarioButton = app.buttons[identifier].firstMatch
        XCTAssertTrue(scenarioButton.waitForExistence(timeout: 4), "\(title) scenario did not appear.")
        scenarioButton.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.82)).tap()

        XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 4))
        if !app.staticTexts["Moment 1 of 2"].waitForExistence(timeout: 2) {
            app.swipeUp()
        }
        XCTAssertTrue(app.staticTexts["Moment 1 of 2"].waitForExistence(timeout: 4))
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
