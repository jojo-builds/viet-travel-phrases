import XCTest

final class PracticeUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testScenarioModeReadsAsMessagesThread() {
        let app = XCUIApplication()
        app.launchArguments = ["--practice", "--reset-practice-message-threads"]
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["Messages"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.descendants(matching: .any)["Practice.Messages.Contacts"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Airport"].exists)
        XCTAssertTrue(app.staticTexts["Hotel"].exists)
        XCTAssertTrue(app.staticTexts["Food"].exists)
        XCTAssertTrue(app.buttons["Practice.Message.Contact.danangFirstDay"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["Practice.Message.Contact.airportPassportControl"].exists)
        XCTAssertTrue(app.buttons["Practice.Message.Contact.airportSimCash"].exists)
        XCTAssertTrue(app.staticTexts["Airport Baggage"].exists)
        XCTAssertTrue(app.staticTexts["Passport Control"].exists)
        XCTAssertTrue(app.staticTexts["SIM & Cash"].exists)
        XCTAssertTrue(app.staticTexts["Hotel Check-In"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["Practice.Message.Contact.UnreadDot.danangFirstDay"].exists)
        XCTAssertFalse(app.staticTexts["Practice.Message.Contact.Preview.danangFirstDay"].exists)
        XCTAssertFalse(app.staticTexts["follow-up"].exists)
        XCTAssertFalse(app.staticTexts["Travel Stories"].exists)
        XCTAssertFalse(app.buttons["Start story"].exists)

        openScenario(identifier: "Practice.Message.Contact.danangFirstDay", title: "Airport Baggage", in: app)

        XCTAssertTrue(app.buttons["Practice.Story.Send"].firstMatch.waitForExistence(timeout: 3))
        XCTAssertFalse(waitForStaticText(containing: "Moment", in: app, timeout: 0.5))
        XCTAssertFalse(app.buttons["Practice.Story.Next"].exists)
        XCTAssertFalse(app.descendants(matching: .any)["Practice.Story.Panel"].exists)
        XCTAssertFalse(app.buttons["AppChrome.Dock.Messages"].isHittable)
        XCTAssertTrue(waitForStaticText(containing: "Xin chào", in: app, timeout: 3))
        XCTAssertEqual(app.textFields.count, 0)
        XCTAssertEqual(app.secureTextFields.count, 0)

        dismissMessagesThread(in: app)
        XCTAssertTrue(app.descendants(matching: .any)["Practice.Messages.Thread"].waitForNonExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Messages"].waitForExistence(timeout: 4))

        openScenario(identifier: "Practice.Message.Contact.danangFirstDay", title: "Airport Baggage", in: app)

        XCTAssertFalse(app.staticTexts["Check fit"].exists)
        XCTAssertFalse(app.staticTexts["Good fit for this moment"].exists)
        XCTAssertFalse(app.staticTexts["Review missed"].exists)
        XCTAssertFalse(app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "incorrect")).element.exists)

        tapFirstStoryChoice(in: app)
        tapButton("Practice.Story.Send", in: app)

        XCTAssertFalse(waitForStaticText(containing: "Lối này", in: app, timeout: 0.35))
        XCTAssertTrue(waitForStaticText(containing: "Xin chào", in: app, timeout: 3))
        XCTAssertTrue(waitForStaticText(containing: "Khu lấy hành lý", in: app, timeout: 3))
        XCTAssertTrue(waitForStaticText(containing: "Cho tôi xem thẻ hành lý", in: app, timeout: 3))
        XCTAssertTrue(app.buttons["Practice.Story.Send"].firstMatch.waitForExistence(timeout: 5))

        tapFirstStoryChoice(in: app)
        tapButton("Practice.Story.Send", in: app)

        XCTAssertFalse(waitForStaticText(containing: "Lối này", in: app, timeout: 0.35))
        XCTAssertTrue(waitForStaticText(containing: "Đây là thẻ hành lý", in: app, timeout: 3))
        XCTAssertTrue(waitForStaticText(containing: "Băng chuyền số 4", in: app, timeout: 3))
        XCTAssertEqual(app.keyboards.count, 0)
        XCTAssertFalse(app.buttons["Practice.Story.Next"].exists)

        XCTAssertTrue(waitForStaticText(containing: "Bạn cần tìm cửa ra hay điểm đón xe?", in: app, timeout: 5))
        XCTAssertTrue(app.buttons["Practice.Story.Send"].firstMatch.waitForExistence(timeout: 5))
    }

    func testMessagesHubCanMarkThreadUnread() {
        let app = XCUIApplication()
        app.launchArguments = ["--practice", "--reset-practice-message-threads"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Messages"].waitForExistence(timeout: 4))
        openScenario(identifier: "Practice.Message.Contact.danangFirstDay", title: "Airport Baggage", in: app)
        dismissMessagesThread(in: app)
        XCTAssertFalse(app.descendants(matching: .any)["Practice.Message.Contact.UnreadDot.danangFirstDay"].exists)

        let airportThread = app.buttons["Practice.Message.Contact.danangFirstDay"].firstMatch
        XCTAssertTrue(airportThread.waitForExistence(timeout: 4))
        airportThread.press(forDuration: 1.0)
        XCTAssertTrue(app.buttons["Mark Unread"].waitForExistence(timeout: 4))
        app.buttons["Mark Unread"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["Practice.Message.Contact.UnreadDot.danangFirstDay"].waitForExistence(timeout: 4))
    }

    func testAudioMessageLongPressShowsPhraseActions() {
        let app = launchPracticeApp(scenarioID: "danangFirstDay", title: "Airport Baggage")
        tapFirstStoryChoice(in: app)
        tapButton("Practice.Story.Send", in: app)

        let travelerPhrase = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "Lấy hành lý")).firstMatch
        XCTAssertTrue(travelerPhrase.waitForExistence(timeout: 4))
        travelerPhrase.press(forDuration: 1.0)

        XCTAssertTrue(app.buttons["Save to Saved Phrases"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["Open Details"].exists)
    }

    func testAdaptedMarketPriceMessageShowsAudioAndPhraseActions() {
        let app = launchPracticeApp(scenarioID: "shoppingMarketPrice", title: "Market Price")
        tapFirstStoryChoice(in: app)
        tapButton("Practice.Story.Send", in: app)

        XCTAssertTrue(waitForStaticText(containing: "Cái này đẹp", in: app, timeout: 5))

        tapFirstStoryChoice(in: app)
        tapButton("Practice.Story.Send", in: app)

        let priceAudioButton = app.buttons.matching(
            NSPredicate(format: "identifier BEGINSWITH %@", "Practice.Story.Audio.shopping-market-price:traveler:")
        ).firstMatch
        XCTAssertTrue(priceAudioButton.waitForExistence(timeout: 4))

        let travelerPhrase = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "Giá tốt nhất là bao nhiêu")).firstMatch
        XCTAssertTrue(travelerPhrase.waitForExistence(timeout: 4))
        travelerPhrase.press(forDuration: 1.0)

        XCTAssertTrue(app.buttons["Save to Saved Phrases"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["Open Details"].exists)
    }

    func testMessageComposerDefaultsFirstOptionIntoSelectionBar() {
        let app = launchPracticeApp(scenarioID: "danangFirstDay", title: "Airport Baggage")
        let selectedPhrase = app.staticTexts["Practice.Story.SelectedPhrase"].firstMatch
        let firstChoice = app.buttons["Practice.Story.Choice.airport-story-opening:viet-phrase-airport-2:0"].firstMatch
        let sendButton = app.buttons["Practice.Story.Send"].firstMatch

        XCTAssertTrue(selectedPhrase.waitForExistence(timeout: 4))
        XCTAssertEqual(selectedPhrase.label, "Lấy hành lý ở đâu?")
        XCTAssertTrue(firstChoice.waitForExistence(timeout: 4))
        XCTAssertEqual(firstChoice.value as? String, "Selected")
        XCTAssertTrue(sendButton.waitForExistence(timeout: 4))
        XCTAssertTrue(sendButton.isEnabled)
    }

    func testMessageComposerFocusesSelectedChoiceAtLeadingEdge() {
        let app = launchPracticeApp(scenarioID: "danangFirstDay", title: "Airport Baggage")
        let composer = app.descendants(matching: .any)["Practice.Story.Composer"].firstMatch
        XCTAssertTrue(composer.waitForExistence(timeout: 4))

        let choices = app.buttons.matching(
            NSPredicate(format: "identifier BEGINSWITH %@", "Practice.Story.Choice.airport-story-opening:")
        )
        let secondChoice = choices.element(boundBy: 1)
        let thirdChoice = choices.element(boundBy: 2)
        XCTAssertTrue(secondChoice.waitForExistence(timeout: 4))
        XCTAssertTrue(thirdChoice.waitForExistence(timeout: 4))

        secondChoice.tap()
        waitForSelectedChoiceFocus(secondChoice, in: app)

        if !thirdChoice.isHittable {
            composer.coordinate(withNormalizedOffset: CGVector(dx: 0.86, dy: 0.84))
                .press(
                    forDuration: 0.05,
                    thenDragTo: composer.coordinate(withNormalizedOffset: CGVector(dx: 0.22, dy: 0.84))
                )
        }

        XCTAssertTrue(thirdChoice.isHittable, "Third message choice should be reachable before selection.")
        thirdChoice.tap()
        waitForSelectedChoiceFocus(thirdChoice, in: app)
    }

    func testMessageThreadPersistsThroughHubAndPhrasePageRoundTrip() {
        let app = launchPracticeApp(scenarioID: "danangFirstDay", title: "Airport Baggage")
        let firstTravelerMessage = app.staticTexts["Practice.Story.Text.traveler.airport-story-opening:traveler:airport-story-opening:viet-phrase-airport-2:0.vietnamese"]
        let secondStepChoice = app.buttons.matching(
            NSPredicate(format: "identifier BEGINSWITH %@", "Practice.Story.Choice.airport-story-baggage-belt:")
        ).firstMatch

        tapFirstStoryChoice(in: app)
        tapButton("Practice.Story.Send", in: app)

        XCTAssertTrue(firstTravelerMessage.waitForExistence(timeout: 4))

        firstTravelerMessage.press(forDuration: 1.0)
        XCTAssertTrue(app.buttons["Open Details"].waitForExistence(timeout: 4))
        app.buttons["Open Details"].tap()

        XCTAssertTrue(app.buttons["TopAdmin.BackButton"].waitForExistence(timeout: 5))
        app.buttons["TopAdmin.BackButton"].tap()

        XCTAssertTrue(app.descendants(matching: .any)["Practice.Messages.Thread"].waitForExistence(timeout: 5))
        XCTAssertTrue(secondStepChoice.waitForExistence(timeout: 5))

        dismissMessagesThread(in: app)
        openScenario(identifier: "Practice.Message.Contact.danangFirstDay", title: "Airport Baggage", in: app)
        XCTAssertTrue(secondStepChoice.waitForExistence(timeout: 5))
    }

    func testScenarioModeProofScreenshots() {
        guard let proofDirectoryURL else {
            return
        }

        let app = launchPracticeApp()
        XCTAssertTrue(app.staticTexts["Messages"].waitForExistence(timeout: 4))
        capture(app: app, directoryURL: proofDirectoryURL, name: "messages-hub.png")
        app.terminate()

        for proofScenario in proofScenarios {
            let scenarioApp = launchPracticeApp(scenarioID: proofScenario.id, title: proofScenario.title)
            capture(app: scenarioApp, directoryURL: proofDirectoryURL, name: "\(proofScenario.slug)-start.png")
            completeScenario(app: scenarioApp, directoryURL: proofDirectoryURL, slug: proofScenario.slug)
            scenarioApp.terminate()
        }
    }

    private let proofScenarios: [(id: String, title: String, slug: String)] = [
        ("danangFirstDay", "Airport Baggage", "airport-baggage"),
        ("hotelCheckInHelp", "Hotel Check-In", "hotel-check-in"),
        ("taxiGrabPickup", "Grab Pickup", "grab-pickup"),
        ("pharmacyHelp", "Pharmacy Visit", "pharmacy-visit"),
        ("danangDay", "Beach Snacks", "beach-snacks"),
        ("restaurantOrderingPayment", "Restaurant Table", "restaurant-table"),
    ]

    private var proofDirectoryURL: URL? {
        let environmentPath = ProcessInfo.processInfo.environment["SPEAKLOCAL_PRACTICE_SCENARIO_PROOF_DIR"]
        if let environmentPath, !environmentPath.isEmpty {
            return URL(fileURLWithPath: environmentPath, isDirectory: true)
        }

        if let filePath = try? String(contentsOfFile: "/tmp/speaklocal-practice-scenario-proof-dir", encoding: .utf8)
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !filePath.isEmpty {
            return URL(fileURLWithPath: filePath, isDirectory: true)
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
        app.launchArguments = ["--practice", "--reset-practice-message-threads"]
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
        let backButton = app.descendants(matching: .any)["Practice.Messages.Back"].firstMatch
        XCTAssertTrue(backButton.waitForExistence(timeout: 4), "Messages back button did not appear.")
        backButton.tap()
        XCTAssertTrue(app.descendants(matching: .any)["Practice.Messages.Thread"].waitForNonExistence(timeout: 4))
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

    private func completeScenario(app: XCUIApplication, directoryURL: URL, slug: String) {
        for stepIndex in 1...10 {
            if app.staticTexts["Conversation complete"].exists {
                break
            }

            XCTAssertTrue(
                app.buttons["Practice.Story.Send"].firstMatch.waitForExistence(timeout: 6),
                "\(slug) step \(stepIndex) send button did not appear."
            )
            capture(app: app, directoryURL: directoryURL, name: "\(slug)-step-\(stepIndex)-prompt.png")
            tapFirstStoryChoice(in: app)
            tapButton("Practice.Story.Send", in: app)
            waitBriefly(0.35)
            capture(app: app, directoryURL: directoryURL, name: "\(slug)-step-\(stepIndex)-after-send.png")

            waitBriefly(2.4)
            if app.staticTexts["Conversation complete"].exists {
                capture(app: app, directoryURL: directoryURL, name: "\(slug)-complete.png")
                return
            }

            XCTAssertTrue(
                app.buttons["Practice.Story.Send"].firstMatch.waitForExistence(timeout: 6),
                "\(slug) step \(stepIndex) did not advance to the next prompt."
            )
            capture(app: app, directoryURL: directoryURL, name: "\(slug)-step-\(stepIndex)-after-reply.png")
        }

        XCTAssertTrue(app.staticTexts["Conversation complete"].waitForExistence(timeout: 4), "\(slug) did not complete.")
        XCTAssertFalse(app.staticTexts["That is correct"].exists)
        capture(app: app, directoryURL: directoryURL, name: "\(slug)-complete.png")
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

    private func waitForSelectedChoiceFocus(
        _ choice: XCUIElement,
        in app: XCUIApplication,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let deadline = Date().addingTimeInterval(4)
        repeat {
            if choice.exists,
               choice.value as? String == "Selected",
               choice.frame.minX >= app.frame.minX + 8,
               choice.frame.minX <= app.frame.minX + 36,
               choice.frame.maxX <= app.frame.maxX - 8 {
                return
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        } while Date() < deadline

        XCTFail("Selected message choice did not focus at the leading edge.", file: file, line: line)
    }

    private func capture(app: XCUIApplication, directoryURL: URL, name: String) {
        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: directoryURL.appendingPathComponent(name))
    }
}
