import XCTest

final class PracticeUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testScenarioModeReadsAsMessagesThread() {
        let app = XCUIApplication()
        app.launchArguments = ["--practice"]
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["Messages"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.descendants(matching: .any)["Practice.Messages.Contacts"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["Practice.Message.Contact.danangFirstDay"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Airport Staff"].exists)
        XCTAssertTrue(app.staticTexts["Hotel Desk"].exists)
        XCTAssertFalse(app.staticTexts["follow-up"].exists)
        XCTAssertFalse(app.staticTexts["Travel Stories"].exists)
        XCTAssertFalse(app.buttons["Start story"].exists)

        openScenario(identifier: "Practice.Message.Contact.danangFirstDay", title: "Airport Staff", in: app)

        XCTAssertTrue(app.buttons["Practice.Story.Send"].firstMatch.waitForExistence(timeout: 3))
        XCTAssertFalse(waitForStaticText(containing: "Moment", in: app, timeout: 0.5))
        XCTAssertFalse(app.buttons["Practice.Story.Next"].exists)
        XCTAssertFalse(app.descendants(matching: .any)["Practice.Story.Panel"].exists)
        XCTAssertFalse(app.buttons["AppChrome.Dock.Messages"].isHittable)
        XCTAssertTrue(waitForStaticText(containing: "Bạn cần tìm gì?", in: app, timeout: 3))
        XCTAssertEqual(app.textFields.count, 0)
        XCTAssertEqual(app.secureTextFields.count, 0)

        dismissMessagesThread(in: app)
        XCTAssertTrue(app.descendants(matching: .any)["Practice.Messages.Thread"].waitForNonExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Messages"].waitForExistence(timeout: 4))

        openScenario(identifier: "Practice.Message.Contact.danangFirstDay", title: "Airport Staff", in: app)

        XCTAssertFalse(app.staticTexts["Check fit"].exists)
        XCTAssertFalse(app.staticTexts["Good fit for this moment"].exists)
        XCTAssertFalse(app.staticTexts["Review missed"].exists)
        XCTAssertFalse(app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "incorrect")).element.exists)

        tapFirstStoryChoice(in: app)
        tapButton("Practice.Story.Send", in: app)

        XCTAssertFalse(waitForStaticText(containing: "Lối này", in: app, timeout: 0.35))
        XCTAssertTrue(waitForStaticText(containing: "Lấy hành lý ở đâu?", in: app, timeout: 3))
        XCTAssertTrue(waitForStaticText(containing: "Lối này", in: app, timeout: 3))
        XCTAssertEqual(app.keyboards.count, 0)
        XCTAssertFalse(app.buttons["Practice.Story.Next"].exists)

        XCTAssertTrue(waitForStaticText(containing: "Bạn đi xe công nghệ hả?", in: app, timeout: 5))
        XCTAssertTrue(app.buttons["Practice.Story.Send"].firstMatch.waitForExistence(timeout: 5))
    }

    func testScenarioModeProofScreenshots() {
        guard let proofDirectoryURL else {
            return
        }

        var app = launchPracticeApp()
        XCTAssertTrue(app.staticTexts["Messages"].waitForExistence(timeout: 4))
        capture(app: app, directoryURL: proofDirectoryURL, name: "messages-hub.png")

        openScenario(identifier: "Practice.Message.Contact.danangFirstDay", title: "Airport Staff", in: app)
        capture(app: app, directoryURL: proofDirectoryURL, name: "airport-staff-conversation-start.png")

        tapFirstStoryChoice(in: app)
        tapButton("Practice.Story.Send", in: app)
        waitBriefly(0.25)
        capture(app: app, directoryURL: proofDirectoryURL, name: "airport-staff-waiting-for-reply.png")
        XCTAssertFalse(waitForStaticText(containing: "Lối này", in: app, timeout: 0.1))
        XCTAssertTrue(waitForStaticText(containing: "Lấy hành lý ở đâu?", in: app, timeout: 3))
        XCTAssertTrue(waitForStaticText(containing: "Lối này", in: app, timeout: 3))
        capture(app: app, directoryURL: proofDirectoryURL, name: "airport-staff-after-send.png")

        XCTAssertTrue(app.buttons["Practice.Story.Send"].firstMatch.waitForExistence(timeout: 5))
        for _ in 0..<4 {
            tapFirstStoryChoice(in: app)
            tapButton("Practice.Story.Send", in: app)
            if app.staticTexts["Conversation complete"].waitForExistence(timeout: 4) {
                break
            }
            XCTAssertTrue(app.buttons["Practice.Story.Send"].firstMatch.waitForExistence(timeout: 5))
        }
        XCTAssertTrue(app.staticTexts["Conversation complete"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.staticTexts["That is correct"].exists)
        capture(app: app, directoryURL: proofDirectoryURL, name: "conversation-complete.png")
        dismissMessagesThread(in: app)
        XCTAssertTrue(app.staticTexts["Messages"].waitForExistence(timeout: 4))
        app.terminate()

        app = launchPracticeApp(scenarioID: "hotelCheckInHelp", title: "Hotel Desk")
        capture(app: app, directoryURL: proofDirectoryURL, name: "hotel-desk-conversation.png")
        app.terminate()

        app = launchPracticeApp(scenarioID: "restaurantOrderingPayment", title: "Server")
        capture(app: app, directoryURL: proofDirectoryURL, name: "server-conversation.png")
        app.terminate()

        app = launchPracticeApp(scenarioID: "taxiGrabPickup", title: "Driver")
        capture(app: app, directoryURL: proofDirectoryURL, name: "driver-conversation.png")
        app.terminate()

        app = launchPracticeApp(scenarioID: "pharmacyHelp", title: "Pharmacist")
        capture(app: app, directoryURL: proofDirectoryURL, name: "pharmacist-conversation.png")
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
            .appendingPathComponent("docs/task-results/assets/TASK-PRACTICE-TRAVEL-STORIES-001", isDirectory: true)
    }

    private func launchPracticeApp(scenarioID: String? = nil, title: String? = nil) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["--practice"]
        if let scenarioID {
            app.launchArguments += ["--practice-scenario", scenarioID]
        }
        app.launch()
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 8))
        if let title {
            XCTAssertTrue(app.descendants(matching: .any)["Practice.Messages.Thread"].waitForExistence(timeout: 8))
            XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 4))
        }
        return app
    }

    private func openScenario(identifier: String, title: String, in app: XCUIApplication) {
        XCTAssertTrue(app.staticTexts["Messages"].waitForExistence(timeout: 4))

        let scenarioQuery = app.buttons.matching(identifier: identifier)
        let scenarioButton = scenarioQuery.firstMatch
        for _ in 0..<7 where !scenarioButton.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(scenarioButton.waitForExistence(timeout: 4), "\(title) scenario did not appear.")
        enabledHittableElement(in: scenarioQuery, label: "\(title) scenario", preferLast: false).tap()

        XCTAssertTrue(app.descendants(matching: .any)["Practice.Messages.Thread"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 4))
    }

    private func dismissMessagesThread(in app: XCUIApplication) {
        let backButton = app.buttons["Practice.Messages.Back"].firstMatch.exists
            ? app.buttons["Practice.Messages.Back"].firstMatch
            : app.buttons["Back to Messages"].firstMatch
        XCTAssertTrue(backButton.waitForExistence(timeout: 4), "Messages back button did not appear.")
        backButton.tap()
    }

    private func tapButton(_ label: String, in app: XCUIApplication) {
        let button: XCUIElement
        if label.hasPrefix("Practice.Story.") {
            let query = app.buttons.matching(identifier: label)
            XCTAssertTrue(query.firstMatch.waitForExistence(timeout: 4), "\(label) button did not appear.")
            button = enabledHittableElement(in: query, label: label, preferLast: true)
        } else {
            button = app.buttons[label].firstMatch
            XCTAssertTrue(button.waitForExistence(timeout: 4), "\(label) button did not appear.")
            waitUntilEnabled(button, label: label)
        }
        button.tap()
    }

    private func waitUntilEnabled(_ element: XCUIElement, label: String) {
        let enabledPredicate = NSPredicate(format: "isEnabled == true")
        expectation(for: enabledPredicate, evaluatedWith: element)
        waitForExpectations(timeout: 2)
        XCTAssertTrue(element.isEnabled, "\(label) was not enabled.")
    }

    private func tapFirstStoryChoice(in app: XCUIApplication) {
        let predicate = NSPredicate(format: "identifier BEGINSWITH %@", "Practice.Story.Choice.")
        let query = app.buttons.matching(predicate)
        XCTAssertTrue(query.firstMatch.waitForExistence(timeout: 4), "Story choice did not appear.")
        let chip = enabledHittableElement(in: query, label: "Story choice", preferLast: false)
        chip.tap()
    }

    private func enabledHittableElement(in query: XCUIElementQuery, label: String, preferLast: Bool) -> XCUIElement {
        let deadline = Date().addingTimeInterval(4)
        repeat {
            let matchingElements = query.allElementsBoundByIndex.filter { $0.exists && $0.isHittable && $0.isEnabled }
            if let element = preferLast ? matchingElements.last : matchingElements.first {
                return element
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        } while Date() < deadline

        XCTFail("\(label) did not become enabled and hittable.")
        return query.firstMatch
    }

    private func waitForStaticText(containing text: String, in app: XCUIApplication, timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", text)
        return app.staticTexts.containing(predicate).element.waitForExistence(timeout: timeout)
    }

    private func waitBriefly(_ seconds: TimeInterval) {
        RunLoop.current.run(until: Date().addingTimeInterval(seconds))
    }

    private func capture(app: XCUIApplication, directoryURL: URL, name: String) {
        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: directoryURL.appendingPathComponent(name))
    }
}
