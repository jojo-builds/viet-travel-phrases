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

        XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 5), file: file, line: line)

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

        XCTAssertTrue(app.staticTexts[title].exists, file: file, line: line)
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2), file: file, line: line)
    }

    private func systemTab(_ title: String, in app: XCUIApplication) -> XCUIElement {
        let tabBarButton = app.tabBars.buttons[title]
        if tabBarButton.exists {
            return tabBarButton
        }

        return app.buttons[title]
    }

    private func systemTabHost(in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)["Tab Bar"]
    }

    private func makeElementHittable(
        primary: XCUIElement,
        fallback: XCUIElement,
        app: XCUIApplication,
        file: StaticString,
        line: UInt
    ) -> XCUIElement {
        for _ in 0..<12 {
            if primary.waitForExistence(timeout: 0.7), primary.isHittable {
                return primary
            }

            if fallback.waitForExistence(timeout: 0.7), fallback.isHittable {
                return fallback
            }

            let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.58))
            let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.14))
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
