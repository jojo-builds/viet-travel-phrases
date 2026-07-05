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
        capturePracticeProof(app: app, name: "saved-round-start.png")
        assertPracticeRoundHeaderClearsNativeSheetTopEdge(in: app)
        XCTAssertTrue(app.buttons["Need a hint?"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.staticTexts["0 of 4"].exists)
        XCTAssertFalse(app.staticTexts["1 / 10"].exists)
    }

    func testPracticeTopicWalkthroughHandlesWrongPairHintCompletionNextAndPreviousRound() {
        let app = launchPracticeApp()

        scrollUntilStaticTextExists("Practice by topic", in: app)
        scrollUntilStaticTextIsHittable("Essentials", in: app)
        tapStaticText("Essentials", in: app)

        XCTAssertTrue(app.staticTexts["Match the pairs"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Phrase"].waitForExistence(timeout: 4))
        capturePracticeProof(app: app, name: "topic-essentials-round-start.png")

        performWrongPairAttempt(in: app)
        tapWhenHittable(app.buttons["Practice.Match.Hint"], app: app)
        XCTAssertTrue(app.staticTexts["One pair is softly highlighted."].waitForExistence(timeout: 2))
        capturePracticeProof(app: app, name: "topic-essentials-hint-after-wrong-pair.png")

        completeCurrentMatchRound(in: app)
        assertPracticeCompletionVisible(in: app)
        capturePracticeProof(app: app, name: "topic-essentials-complete.png")

        tapWhenHittable(app.buttons["Practice.Match.Continue"], app: app)
        assertPracticeRoundVisible(in: app, afterContinueScreenshotName: "topic-essentials-after-next-round-tap.png")
        capturePracticeProof(app: app, name: "topic-essentials-second-round-before-previous.png")
        XCTAssertTrue(app.buttons["Practice.Match.PreviousRound"].waitForExistence(timeout: 2))
        assertElementFullyVisible(app.buttons["Practice.Match.PreviousRound"], in: app)
        tapWhenHittable(app.buttons["Practice.Match.PreviousRound"], app: app)
        assertPracticeRoundVisible(in: app, afterContinueScreenshotName: "topic-essentials-after-previous-round-tap.png")
        XCTAssertTrue(app.staticTexts["Phrase"].waitForExistence(timeout: 3))
        capturePracticeProof(app: app, name: "topic-essentials-returned-previous-round.png")

        tapWhenHittable(app.buttons["Practice.Match.TopicPicker"], app: app)
        XCTAssertTrue(app.buttons["Practice.Match.TopicOption.topic:first-day"].waitForExistence(timeout: 3))
        capturePracticeProof(app: app, name: "topic-picker-open.png")
        tapWhenHittable(app.buttons["Practice.Match.TopicOption.topic:first-day"], app: app)
        XCTAssertTrue(app.staticTexts["First day"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Match the pairs"].waitForExistence(timeout: 3))
        capturePracticeProof(app: app, name: "topic-picker-switched-first-day.png")
    }

    func testFoodPracticeWalkthroughCyclesThroughPhraseImageListenAndAudioImageRounds() {
        let app = launchPracticeApp(extraArguments: ["--practice-mode", "hoianCity"])

        XCTAssertTrue(app.staticTexts["Eating Out"].waitForExistence(timeout: 4))
        assertPracticeModeBadge("Phrase", in: app)
        capturePracticeProof(app: app, name: "food-round-01-phrase-start.png")
        completeCurrentMatchRound(in: app)
        assertPracticeCompletionVisible(in: app)
        capturePracticeProof(app: app, name: "food-round-01-phrase-complete.png")

        continueToMode("Image", in: app, screenshotName: "food-round-02-image-start.png")
        completeCurrentMatchRound(in: app)
        assertPracticeCompletionVisible(in: app)
        capturePracticeProof(app: app, name: "food-round-02-image-complete.png")

        continueToMode("Listen", in: app, screenshotName: "food-round-03-listen-start.png")
        XCTAssertTrue(app.buttons.matching(identifierPrefix: "Practice.Match.AudioPrompt.").count > 0)
        completeCurrentMatchRound(in: app)
        assertPracticeCompletionVisible(in: app)
        capturePracticeProof(app: app, name: "food-round-03-listen-complete.png")

        continueToMode("Audio + Image", in: app, screenshotName: "food-round-04-audio-image-start.png")
        XCTAssertTrue(app.buttons.matching(identifierPrefix: "Practice.Match.AudioPrompt.").count > 0)
        completeCurrentMatchRound(in: app)
        assertPracticeCompletionVisible(in: app)
        capturePracticeProof(app: app, name: "food-round-04-audio-image-complete.png")
    }

    func testDirectPracticeModeLaunchesCompleteFirstRoundForMappedSources() {
        let modes: [(rawValue: String, expectedSource: String, screenshotName: String)] = [
            ("hcmcCity", "First day", "direct-mode-hcmc-complete.png"),
            ("hanoiBucketList", "Essentials", "direct-mode-hanoi-complete.png"),
            ("danangCity", "First day", "direct-mode-danang-complete.png"),
            ("hueCity", "Essentials", "direct-mode-hue-complete.png"),
        ]

        for mode in modes {
            let app = launchPracticeApp(extraArguments: ["--practice-mode", mode.rawValue])

            XCTAssertTrue(app.staticTexts[mode.expectedSource].waitForExistence(timeout: 5), mode.rawValue)
            assertPracticeRoundVisible(in: app, afterContinueScreenshotName: "\(mode.rawValue)-round-open-failed.png")
            completeCurrentMatchRound(in: app)
            assertPracticeCompletionVisible(in: app)
            capturePracticeProof(app: app, name: mode.screenshotName)
            app.terminate()
        }
    }

    func testTopicPickerSourcesOpenAndCompleteFocusedRounds() {
        let topics: [(optionID: String, title: String, screenshotName: String)] = [
            ("topic:airport", "Airport", "topic-airport-complete.png"),
            ("topic:taxi-directions", "Taxi & directions", "topic-taxi-directions-complete.png"),
            ("topic:shopping-markets", "Shopping & markets", "topic-shopping-markets-complete.png"),
            ("topic:emergency", "Emergency", "topic-emergency-complete.png"),
            ("topic:danang-city", "Da Nang", "topic-danang-complete.png"),
        ]

        for topic in topics {
            let app = launchPracticeApp(extraArguments: ["--practice-mode", "hueCity"])

            XCTAssertTrue(app.staticTexts["Essentials"].waitForExistence(timeout: 5), topic.optionID)
            assertPracticeRoundVisible(in: app, afterContinueScreenshotName: "\(topic.optionID)-base-open-failed.png")
            tapWhenHittable(app.buttons["Practice.Match.TopicPicker"], app: app)
            tapWhenHittable(app.buttons["Practice.Match.TopicOption.\(topic.optionID)"], app: app)
            XCTAssertTrue(app.staticTexts[topic.title].waitForExistence(timeout: 4), topic.optionID)
            assertPracticeRoundVisible(in: app, afterContinueScreenshotName: "\(topic.optionID)-round-open-failed.png")
            completeCurrentMatchRound(in: app)
            assertPracticeCompletionVisible(in: app)
            capturePracticeProof(app: app, name: topic.screenshotName)
            app.terminate()
        }
    }

    func testSavedPracticeWalkthroughCompletesRoundAndShowsSummaryAudioAndSaveControls() {
        let app = launchPracticeApp(extraArguments: ["--seed-returning-user-shelves"])

        tapStaticText("Practice Saved", in: app)
        XCTAssertTrue(app.staticTexts["Practice Saved"].waitForExistence(timeout: 4))
        capturePracticeProof(app: app, name: "saved-round-start.png")

        completeCurrentMatchRound(in: app)
        assertPracticeCompletionVisible(in: app)
        XCTAssertTrue(app.buttons.matching(identifierPrefix: "Practice.Match.Complete.Audio.").count >= 4)

        let saveButtons = app.buttons.matching(identifierPrefix: "Practice.Match.Complete.Save.").allElementsBoundByIndex
        XCTAssertGreaterThanOrEqual(saveButtons.count, 4)
        let firstSaveButton = saveButtons[0]
        let originalLabel = firstSaveButton.label
        tapWhenHittable(firstSaveButton, app: app)
        XCTAssertNotEqual(firstSaveButton.label, originalLabel)
        capturePracticeProof(app: app, name: "saved-round-complete-summary-save-toggle.png")
    }

    func testHomeQuickPracticeCallerCompletesRoundAndReturnsToHomePracticeRail() {
        let app = launchApp(extraArguments: ["--home", "--reset-demo-state"])
        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.staticTexts["Browse.Title"].exists)
        let quickPractice = app.buttons["Home.PracticeStarter.quick"]
        scrollUntilElementIsHittable(quickPractice, in: app)
        capturePracticeProof(app: app, name: "home-practice-rail-quick-visible.png")

        tapWhenHittable(quickPractice, app: app)
        assertPracticeRoundVisible(in: app, afterContinueScreenshotName: "home-quick-practice-open-failed.png")
        capturePracticeProof(app: app, name: "home-quick-practice-open.png")
        completeCurrentMatchRound(in: app)
        assertPracticeCompletionVisible(in: app)
        capturePracticeProof(app: app, name: "home-quick-practice-complete.png")

        tapWhenHittable(app.buttons["Close practice"].firstMatch, app: app)
        XCTAssertTrue(app.descendants(matching: .any)["HomePracticeStarterRail"].waitForExistence(timeout: 4))
    }

    func testBrowseFirstDayPracticeCallerCompletesRoundAndReturnsToCollection() {
        let app = launchApp(extraArguments: ["--browse-category", "first-day", "--reset-demo-state"])
        let practiceEntry = app.buttons["BrowseCollection.PracticeEntry.category.first-day"]
        scrollUntilElementIsHittable(practiceEntry, in: app)
        XCTAssertTrue(app.staticTexts["First day practice"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["First day in Vietnam messages"].exists)
        capturePracticeProof(app: app, name: "browse-first-day-practice-entry.png")

        tapWhenHittable(practiceEntry, app: app)
        assertPracticeRoundVisible(in: app, afterContinueScreenshotName: "browse-first-day-practice-open-failed.png")
        capturePracticeProof(app: app, name: "browse-first-day-practice-open.png")
        completeCurrentMatchRound(in: app)
        assertPracticeCompletionVisible(in: app)
        capturePracticeProof(app: app, name: "browse-first-day-practice-complete.png")

        tapWhenHittable(app.buttons["Close practice"].firstMatch, app: app)
        XCTAssertTrue(app.buttons["BrowseCollection.PracticeEntry.category.first-day"].waitForExistence(timeout: 4))
    }

    func testPracticeTopicHeaderClearsBottomChromeOnLaunch() {
        let app = launchPracticeApp()
        let topicHeader = app.staticTexts["Practice by topic"]
        let firstDayTopic = app.staticTexts["First day"]
        let eatingOutTopic = app.staticTexts["Eating Out"]
        let tabBar = app.tabBars.firstMatch

        XCTAssertTrue(topicHeader.waitForExistence(timeout: 8))
        XCTAssertTrue(firstDayTopic.waitForExistence(timeout: 4))
        XCTAssertTrue(eatingOutTopic.waitForExistence(timeout: 4))
        XCTAssertTrue(tabBar.waitForExistence(timeout: 4))
        XCTAssertLessThanOrEqual(
            topicHeader.frame.maxY,
            tabBar.frame.minY - 10,
            "The first Practice topic header should not be clipped by the bottom chrome on launch."
        )
        XCTAssertLessThanOrEqual(
            firstDayTopic.frame.maxY,
            tabBar.frame.minY - 10,
            "The first two Practice topic rows should be visible above the bottom chrome on launch."
        )
        XCTAssertLessThanOrEqual(
            eatingOutTopic.frame.maxY,
            tabBar.frame.minY - 10,
            "The first three Practice topic rows should be visible above the bottom chrome on launch."
        )
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
        completeCurrentMatchRound(in: app)
        assertPracticeCompletionVisible(in: app)
        capturePracticeProof(app: app, name: "legacy-scenario-fallback-complete.png")
    }

    private func launchPracticeApp(extraArguments: [String] = []) -> XCUIApplication {
        launchApp(extraArguments: ["--practice", "--reset-demo-state", "--enable-practice-layout-probes"] + extraArguments)
    }

    private func launchApp(extraArguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = extraArguments
        app.launch()
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

    private func scrollUntilElementIsHittable(
        _ element: XCUIElement,
        in app: XCUIApplication,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        for _ in 0..<8 {
            if element.waitForExistence(timeout: 1),
               element.isHittable,
               isElementFullyVisible(element, in: app) {
                return
            }
            app.swipeUp()
        }

        XCTAssertTrue(element.waitForExistence(timeout: 1), file: file, line: line)
        XCTAssertTrue(element.isHittable, file: file, line: line)
        XCTAssertTrue(isElementFullyVisible(element, in: app), file: file, line: line)
    }

    private func isElementFullyVisible(_ element: XCUIElement, in app: XCUIApplication) -> Bool {
        let frame = element.frame
        let windowFrame = app.windows.firstMatch.frame.insetBy(dx: 0, dy: 8)
        guard !frame.isEmpty, !windowFrame.isEmpty else {
            return false
        }

        return frame.minY >= windowFrame.minY
            && frame.maxY <= windowFrame.maxY
            && frame.midX >= windowFrame.minX
            && frame.midX <= windowFrame.maxX
    }

    private func dragVertically(in app: XCUIApplication, from startY: CGFloat, to endY: CGFloat) {
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: startY))
            .press(
                forDuration: 0.1,
                thenDragTo: app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: endY))
            )
    }

    private func performWrongPairAttempt(in app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        let prompts = waitForMatchCardIDs(prefix: "Practice.Match.Card.prompt:", in: app, file: file, line: line)
        let answers = waitForMatchCardIDs(prefix: "Practice.Match.Card.answer:", in: app, file: file, line: line)
        guard let promptPairID = prompts.first,
              let wrongAnswerPairID = answers.first(where: { $0 != promptPairID })
        else {
            XCTFail("Could not find a mismatched prompt/answer pair.", file: file, line: line)
            return
        }

        tapWhenHittable(matchCard(prefix: "Practice.Match.Card.prompt:", pairID: promptPairID, in: app), app: app, file: file, line: line)
        tapWhenHittable(matchCard(prefix: "Practice.Match.Card.answer:", pairID: wrongAnswerPairID, in: app), app: app, file: file, line: line)
        XCTAssertFalse(app.staticTexts["Nice match!"].exists, file: file, line: line)
        RunLoop.current.run(until: Date().addingTimeInterval(0.75))
        XCTAssertTrue(matchCard(prefix: "Practice.Match.Card.prompt:", pairID: promptPairID, in: app).exists, file: file, line: line)
    }

    private func completeCurrentMatchRound(in app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        let pairIDs = waitForMatchCardIDs(prefix: "Practice.Match.Card.prompt:", in: app, file: file, line: line)

        for pairID in pairIDs {
            tapWhenHittable(matchCard(prefix: "Practice.Match.Card.prompt:", pairID: pairID, in: app), app: app, file: file, line: line)
            tapWhenHittable(matchCard(prefix: "Practice.Match.Card.answer:", pairID: pairID, in: app), app: app, file: file, line: line)
        }
    }

    private func waitForMatchCardIDs(
        prefix: String,
        in app: XCUIApplication,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> [String] {
        for _ in 0..<20 {
            let ids = app.descendants(matching: .any)
                .matching(identifierPrefix: prefix)
                .allElementsBoundByIndex
                .map(\.identifier)
                .filter { $0.hasPrefix(prefix) }
                .map { String($0.dropFirst(prefix.count)) }

            if ids.count >= 4 {
                return Array(ids.prefix(4))
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.25))
        }

        print("Practice card lookup failed for prefix \(prefix). Visible tree:\n\(app.debugDescription)")
        XCTFail("Expected four match cards for prefix \(prefix).", file: file, line: line)
        return []
    }

    private func matchCard(prefix: String, pairID: String, in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)["\(prefix)\(pairID)"]
    }

    private func assertPracticeCompletionVisible(in app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(app.staticTexts["Nice match!"].waitForExistence(timeout: 4), file: file, line: line)
        XCTAssertTrue(app.staticTexts["You matched all 4 pairs."].waitForExistence(timeout: 2), file: file, line: line)
        let continueButton = app.buttons["Practice.Match.Continue"]
        XCTAssertTrue(continueButton.waitForExistence(timeout: 2), file: file, line: line)
        XCTAssertLessThanOrEqual(
            continueButton.frame.maxY,
            app.windows.firstMatch.frame.maxY - 12,
            "Next round should be fully visible above the bottom edge.",
            file: file,
            line: line
        )
    }

    private func assertPracticeRoundVisible(
        in app: XCUIApplication,
        afterContinueScreenshotName: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard app.staticTexts["Match the pairs"].waitForExistence(timeout: 4) else {
            capturePracticeProof(app: app, name: afterContinueScreenshotName)
            print("Practice round did not reappear. Visible tree:\n\(app.debugDescription)")
            XCTFail("Expected Match the pairs to appear after continuing to the next round.", file: file, line: line)
            return
        }

        assertElementFullyVisible(app.buttons["Practice.Match.Close"], in: app, file: file, line: line)
        assertElementFullyVisible(app.buttons["Practice.Match.TopicPicker"], in: app, file: file, line: line)
        assertElementFullyVisible(app.buttons["Practice.Match.Hint"], in: app, file: file, line: line)
    }

    private func assertPracticeRoundHeaderClearsNativeSheetTopEdge(
        in app: XCUIApplication,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let topBoundary = app.descendants(matching: .any)["Practice.Match.SheetTopBoundary"]
        XCTAssertTrue(topBoundary.waitForExistence(timeout: 2), file: file, line: line)

        let minimumHeaderInset: CGFloat = 48
        let header = app.descendants(matching: .any)["Practice.Match.HeaderControls"]
        XCTAssertTrue(header.waitForExistence(timeout: 2), file: file, line: line)
        XCTAssertGreaterThanOrEqual(
            header.frame.minY,
            topBoundary.frame.maxY + minimumHeaderInset,
            "Practice sheet header should clear the native sheet top edge as a full cluster.",
            file: file,
            line: line
        )

        let controls = [
            app.buttons["Practice.Match.PreviousRound"],
            app.buttons["Practice.Match.TopicPicker"],
            app.buttons["Practice.Match.Close"],
        ]

        for control in controls {
            XCTAssertTrue(control.waitForExistence(timeout: 2), file: file, line: line)
            XCTAssertGreaterThanOrEqual(
                control.frame.minY,
                topBoundary.frame.maxY + minimumHeaderInset,
                "Practice sheet header controls should sit fully below the native sheet top edge.",
                file: file,
                line: line
            )
        }
    }

    private func assertElementFullyVisible(
        _ element: XCUIElement,
        in app: XCUIApplication,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(element.waitForExistence(timeout: 2), file: file, line: line)
        XCTAssertGreaterThanOrEqual(element.frame.minY, app.windows.firstMatch.frame.minY + 8, file: file, line: line)
        XCTAssertLessThanOrEqual(element.frame.maxY, app.windows.firstMatch.frame.maxY - 8, file: file, line: line)
    }

    private func continueToMode(
        _ mode: String,
        in app: XCUIApplication,
        screenshotName: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        tapWhenHittable(app.buttons["Practice.Match.Continue"], app: app, file: file, line: line)
        assertPracticeModeBadge(mode, in: app, file: file, line: line)
        capturePracticeProof(app: app, name: screenshotName)
    }

    private func assertPracticeModeBadge(
        _ mode: String,
        in app: XCUIApplication,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let badge = app.staticTexts[mode]
        XCTAssertTrue(badge.waitForExistence(timeout: 4), "Expected Practice mode badge \(mode).", file: file, line: line)
    }

    private func tapWhenHittable(
        _ element: XCUIElement,
        app: XCUIApplication,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        for _ in 0..<8 {
            if element.waitForExistence(timeout: 1), element.isHittable {
                element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
                return
            }
            app.swipeUp()
        }

        XCTAssertTrue(element.waitForExistence(timeout: 1), file: file, line: line)
        XCTAssertTrue(element.isHittable, file: file, line: line)
    }

    private func capturePracticeProof(app: XCUIApplication, name: String) {
        let environment = ProcessInfo.processInfo.environment
        let path = environment["SPEAKLOCAL_PRACTICE_AUDIT_PROOF_DIR"]
            ?? environment["TEST_RUNNER_SPEAKLOCAL_PRACTICE_AUDIT_PROOF_DIR"]
        guard let path, !path.isEmpty else {
            return
        }

        let directory = URL(fileURLWithPath: path, isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: directory.appendingPathComponent(name))
    }
}

private extension XCUIElementQuery {
    func matching(identifierPrefix prefix: String) -> XCUIElementQuery {
        matching(NSPredicate(format: "identifier BEGINSWITH %@", prefix))
    }
}
