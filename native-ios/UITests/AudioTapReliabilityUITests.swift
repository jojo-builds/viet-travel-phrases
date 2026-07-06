import XCTest

final class AudioTapReliabilityUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testBreakdownAudioCardsStayResponsiveAcrossTargetPages() {
        verifyBreakdownAudioCard(
            pageID: "viet-family-food-coffee-black",
            title: "Cho tôi cà phê đen đá",
            audioIdentifier: "Breakdown.Audio.viet-phrase-coffee-2:breakdown:breakdown:chunk-1",
            audioLabel: "Play cho",
            repetitions: 20
        )
        verifyBreakdownAudioCard(
            pageID: "viet-phrase-polite-1",
            title: "Xin chào",
            audioIdentifier: "Breakdown.Audio.xin",
            audioLabel: "Play Xin",
            repetitions: 8
        )
        verifyBreakdownAudioCard(
            pageID: "viet-phrase-hotel-quiet-room",
            title: "Cho tôi phòng yên tĩnh được không?",
            audioIdentifier: "Breakdown.Audio.viet-phrase-hotel-quiet-room:breakdown:breakdown:chunk-1",
            audioLabel: "Play cho",
            repetitions: 8
        )
    }

    func testRowAudioButtonsStayResponsiveAcrossSearchMenuAndSaved() {
        verifyRowAudioButton(
            launchArguments: ["--search-query", "Cà phê sữa đá"],
            readyText: "Results for Cà phê sữa đá",
            audioIdentifier: "SearchResult.Audio.viet-menu-drink-ca-phe-sua-da",
            fallbackLabel: "Play phrase audio",
            stableText: "Cà phê sữa đá",
            repetitions: 8
        )

        verifyRowAudioButton(
            launchArguments: ["--browse-category", "vietnamese-drink-menu"],
            readyText: "Drink Menu",
            sectionRailIdentifier: "VietnameseMenu.SectionRail.coffee",
            sectionReadyIdentifier: "VietnameseMenu.SectionTitle.coffee",
            audioIdentifier: "VietnameseMenu.Audio.viet-menu-drink-ca-phe-sua-da",
            fallbackLabel: "Play phrase audio",
            stableText: "Drink Menu",
            repetitions: 8
        )

        verifySavedRowAudioButton()
    }

    private func verifyBreakdownAudioCard(
        pageID: String,
        title: String,
        audioIdentifier: String,
        audioLabel: String,
        repetitions: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let app = XCUIApplication()
        app.launchArguments = [
            "--detail-page", pageID,
            "--detail-scroll", "first-breakdown",
        ]
        app.launch()

        let audioButton = makeElementHittable(
            primary: app.descendants(matching: .any)[audioIdentifier],
            fallback: app.buttons[audioLabel],
            app: app,
            file: file,
            line: line
        )
        captureProofIfRequested(app: app, name: "\(pageID)-breakdown.png")

        for _ in 0..<repetitions {
            audioButton.tap()
            usleep(120_000)
        }
        captureProofIfRequested(app: app, name: "\(pageID)-after-taps.png")

        XCTAssertTrue(app.staticTexts[title].exists || audioButton.exists, file: file, line: line)
        XCTAssertTrue(waitForSystemChrome(in: app, timeout: 2), file: file, line: line)
    }

    private func verifyRowAudioButton(
        launchArguments: [String],
        readyText: String,
        sectionRailIdentifier: String? = nil,
        sectionReadyIdentifier: String? = nil,
        audioIdentifier: String,
        fallbackLabel: String,
        stableText: String,
        repetitions: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let app = XCUIApplication()
        app.launchArguments = launchArguments
        app.launch()

        XCTAssertTrue(app.staticTexts[readyText].waitForExistence(timeout: 5), file: file, line: line)

        if let sectionRailIdentifier {
            let sectionRail = makeElementHittable(
                primary: app.buttons[sectionRailIdentifier],
                fallback: app.descendants(matching: .any)[sectionRailIdentifier],
                app: app,
                file: file,
                line: line
            )
            sectionRail.tap()

            if let sectionReadyIdentifier {
                XCTAssertTrue(
                    app.staticTexts[sectionReadyIdentifier].waitForExistence(timeout: 3),
                    file: file,
                    line: line
                )
            }
        }

        let audioButton = makeElementHittable(
            primary: app.descendants(matching: .any)[audioIdentifier],
            fallback: app.buttons[fallbackLabel],
            app: app,
            file: file,
            line: line
        )

        for _ in 0..<repetitions {
            audioButton.tap()
            usleep(120_000)
        }

        XCTAssertTrue(app.staticTexts[stableText].waitForExistence(timeout: 2), file: file, line: line)
        XCTAssertTrue(waitForSystemChrome(in: app, timeout: 2), file: file, line: line)
    }

    private func verifySavedRowAudioButton(file: StaticString = #filePath, line: UInt = #line) {
        let app = XCUIApplication()
        app.launchArguments = ["--saved", "--reset-demo-state", "--seed-returning-user-shelves"]
        app.launch()

        XCTAssertTrue(savedRootExists(in: app), file: file, line: line)

        let savedAudio = app.buttons
            .matching(NSPredicate(format: "identifier BEGINSWITH %@", "SavedTrip.Audio."))
            .firstMatch
        let audioButton = makeElementHittable(
            primary: savedAudio,
            fallback: app.buttons["Play phrase audio"],
            app: app,
            file: file,
            line: line
        )

        for _ in 0..<8 {
            audioButton.tap()
            usleep(120_000)
        }

        XCTAssertTrue(savedRootExists(in: app), file: file, line: line)
        XCTAssertTrue(waitForSystemChrome(in: app, timeout: 2), file: file, line: line)
    }

    private func systemTab(_ title: String, in app: XCUIApplication) -> XCUIElement {
        let tabBarButton = app.tabBars.buttons[title]
        if tabBarButton.exists {
            return tabBarButton
        }

        return app.buttons[title]
    }

    private func waitForSystemChrome(in app: XCUIApplication, timeout: TimeInterval) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if app.descendants(matching: .any)["Tab Bar"].exists {
                return true
            }

            for title in ["Home", "Browse", "Saved", "Practice", "Search"] where systemTab(title, in: app).exists {
                return true
            }

            if app.textFields.firstMatch.exists {
                return true
            }

            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        }

        return false
    }

    private func savedRootExists(in app: XCUIApplication) -> Bool {
        app.descendants(matching: .any)["Saved.PhotoBackdrop.Content"].waitForExistence(timeout: 4)
            || app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 1)
    }

    private func makeElementHittable(
        primary: XCUIElement,
        fallback: XCUIElement,
        app: XCUIApplication,
        file: StaticString,
        line: UInt
    ) -> XCUIElement {
        for attempt in 0..<12 {
            if primary.waitForExistence(timeout: 0.7), primary.isHittable {
                return primary
            }

            if fallback.waitForExistence(timeout: 0.7), fallback.isHittable {
                return fallback
            }

            let startOffset = attempt.isMultiple(of: 2)
                ? CGVector(dx: 0.5, dy: 0.58)
                : CGVector(dx: 0.5, dy: 0.24)
            let endOffset = attempt.isMultiple(of: 2)
                ? CGVector(dx: 0.5, dy: 0.14)
                : CGVector(dx: 0.5, dy: 0.72)
            let start = app.coordinate(withNormalizedOffset: startOffset)
            let end = app.coordinate(withNormalizedOffset: endOffset)
            start.press(forDuration: 0.05, thenDragTo: end)
        }

        XCTFail("Element was not hittable: \(primary) or \(fallback)", file: file, line: line)
        return primary
    }

    private func captureProofIfRequested(app: XCUIApplication, name: String) {
        let sentinelPath = "/tmp/speaklocal-audio-proof-enabled"
        let environmentPath = ProcessInfo.processInfo.environment["SPEAKLOCAL_AUDIO_PROOF_DIR"]
        guard
            FileManager.default.fileExists(atPath: sentinelPath) || environmentPath?.isEmpty == false,
            let directoryURL = proofDirectoryURL(environmentPath: environmentPath)
        else {
            return
        }

        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        let screenshotURL = directoryURL.appendingPathComponent(name)
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: screenshotURL)
    }

    private func proofDirectoryURL(environmentPath: String?) -> URL? {
        if let environmentPath, !environmentPath.isEmpty {
            return URL(fileURLWithPath: environmentPath, isDirectory: true)
        }

        let testFileURL = URL(fileURLWithPath: #filePath)
        let repoRootURL = testFileURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()

        return repoRootURL
            .appendingPathComponent("docs/task-results/assets/TASK-NATIVE-AUDIO-TAP-RELIABILITY-001", isDirectory: true)
    }
}
