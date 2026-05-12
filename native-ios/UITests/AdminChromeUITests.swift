import XCTest

final class AdminChromeUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testHomeAndSearchIslandCanSwitchRepeatedly() {
        let app = XCUIApplication()
        app.launch()

        assertHomeVisible(in: app)

        for iteration in 1...8 {
            openSearch(in: app, expectedOrigin: "Home", iteration: iteration)
            openOrigin(in: app, title: "Home", iteration: iteration)
            assertHomeVisible(in: app)
        }
    }

    func testPrimaryTabsPreserveSearchOriginIcon() {
        let app = XCUIApplication()
        app.launch()

        assertHomeVisible(in: app)

        openSearch(in: app, expectedOrigin: "Home", iteration: 1)
        openOrigin(in: app, title: "Home", iteration: 1)
        assertHomeVisible(in: app)

        openDock("Browse", in: app)
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
        openSearch(in: app, expectedOrigin: "Browse", iteration: 2)
        openOrigin(in: app, title: "Browse", iteration: 2)
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))

        openDock("Saved", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))
        openSearch(in: app, expectedOrigin: "Saved", iteration: 3)
        openOrigin(in: app, title: "Saved", iteration: 3)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))

        openDock("Messages", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))
        openSearch(in: app, expectedOrigin: "Messages", iteration: 4)
        openOrigin(in: app, title: "Messages", iteration: 4)
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))
    }

    func testDockDragGestureCommitsTabUnderFinger() {
        let app = XCUIApplication()
        app.launch()

        assertHomeVisible(in: app)

        let homeButton = app.buttons["AppChrome.Dock.Home"]
        let practiceButton = app.buttons["AppChrome.Dock.Messages"]
        XCTAssertTrue(homeButton.waitForExistence(timeout: 2))
        XCTAssertTrue(practiceButton.waitForExistence(timeout: 2))

        homeButton.press(forDuration: 0.18, thenDragTo: practiceButton)
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))

        let browseButton = app.buttons["AppChrome.Dock.Browse"]
        XCTAssertTrue(browseButton.waitForExistence(timeout: 2))
        practiceButton.press(forDuration: 0.18, thenDragTo: browseButton)
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
    }

    func testDockTapRunsLensFlightAndCommitsDestination() {
        let app = XCUIApplication()
        app.launch()

        assertHomeVisible(in: app)

        let practiceButton = app.buttons["AppChrome.Dock.Messages"]
        XCTAssertTrue(practiceButton.waitForExistence(timeout: 2))

        practiceButton.tap()
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))
        captureProofIfRequested(app: app, name: "dock-tap-home-to-practice-settled.png")
    }

    func testDetailSearchOriginRoundTripKeepsChromeResponsive() {
        let app = XCUIApplication()
        app.launchArguments = ["--detail-page", "viet-phrase-hello-chao-anh"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))

        openSearch(in: app, expectedOrigin: "Browse", iteration: 1)
        openOrigin(in: app, title: "Browse", iteration: 1)
        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 3))

        openSearch(in: app, expectedOrigin: "Browse", iteration: 2)
        XCTAssertTrue(app.staticTexts["Search"].waitForExistence(timeout: 2))
    }

    func testDetailPagePinsAudioSpeedControlAfterPlayerScrollsOffscreen() {
        let app = launchApp(arguments: ["--detail-page", "viet-phrase-polite-1"])
        XCTAssertTrue(app.staticTexts["Xin chào"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.descendants(matching: .any)["PinnedAudioSpeedControl"].exists)
        capturePinnedAudioProofIfRequested(app: app, name: "player-visible.png")

        for _ in 0..<4 where !app.descendants(matching: .any)["PinnedAudioSpeedControl"].exists {
            app.swipeUp()
        }

        let pinnedSpeedControl = app.descendants(matching: .any)["PinnedAudioSpeedControl"]
        XCTAssertTrue(
            pinnedSpeedControl.waitForExistence(timeout: 2),
            "Pinned speed control should appear once the main player scrolls above the top chrome."
        )
        XCTAssertTrue(app.buttons["Go back"].exists, "Back button should remain in the top admin area.")
        XCTAssertTrue(app.descendants(matching: .any)["0.5x"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["0.75x"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["1.0x"].exists)
        assertPinnedSpeedControlFloatsInTopAdmin(pinnedSpeedControl: pinnedSpeedControl)
        assertTopAdminControlsShareRow(app: app, pinnedSpeedControl: pinnedSpeedControl)
        capturePinnedAudioProofIfRequested(app: app, name: "pinned-speed-control.png")
    }

    func testBottomChromeControlsWinEdgeBiasedTapsOverDenseDetailContent() {
        verifyDockTapFromDenseDetail("Browse", point: .center) { app in
            XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
        }
        verifyDockTapFromDenseDetail("Browse", point: .leadingEdge) { app in
            XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
        }
        verifyDockTapFromDenseDetail("Browse", point: .trailingEdge) { app in
            XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
        }
        verifyDockTapFromDenseDetail("Home", point: .trailingEdge) { app in
            XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        }
        verifyDockTapFromDenseDetail("Saved", point: .leadingEdge) { app in
            XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))
        }
        verifyDockTapFromDenseDetail("Messages", point: .bottomEdge) { app in
            XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))
        }

        let app = launchDenseDetail()
        tapChrome(app.buttons["AppChrome.SearchButton"], point: .topEdge)
        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.textFields["AppChrome.SearchField"].waitForExistence(timeout: 2))
    }

    func testBottomChromeGradientProofScreenshots() {
        var app = launchApp(arguments: ["--detail-page", "viet-phrase-hello-chao-anh"])
        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))
        captureProofIfRequested(app: app, name: "detail-bottom-chrome.png")

        app = launchApp()
        assertHomeVisible(in: app)
        captureProofIfRequested(app: app, name: "home-bottom-chrome.png")
        openDock("Saved", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))
        captureProofIfRequested(app: app, name: "saved-bottom-chrome.png")

        app = launchApp(arguments: ["--browse"])
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 5))
        captureProofIfRequested(app: app, name: "browse-bottom-chrome.png")

        app = launchApp(arguments: ["--search"])
        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 5))
        captureProofIfRequested(app: app, name: "search-bottom-chrome.png")

        app = launchApp(arguments: ["--practice"])
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 5))
        captureProofIfRequested(app: app, name: "practice-bottom-chrome.png")
    }

    func testHomeLiquidGlassRedesignProofScreenshots() {
        let app = launchApp()
        assertHomeVisible(in: app)
        XCTAssertTrue(app.staticTexts["Start speaking now"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Test phrase cards"].exists)
        XCTAssertFalse(app.descendants(matching: .any)["Home.SearchEntry"].exists)
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-liquid-top.png")

        for _ in 0..<3 where !app.staticTexts["Keep going"].exists {
            app.swipeUp()
        }
        XCTAssertTrue(app.staticTexts["Explore by city"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Keep going"].waitForExistence(timeout: 3))
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-liquid-mid.png")

        for _ in 0..<3 where !app.staticTexts["Messages"].exists {
            app.swipeUp()
        }
        XCTAssertTrue(app.staticTexts["Messages"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["HomeScenario.danangFirstDay"].exists)
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-liquid-lower.png")

        for _ in 0..<5 where !app.staticTexts["Tip"].exists {
            app.swipeUp()
        }
        XCTAssertTrue(app.staticTexts["Tip"].waitForExistence(timeout: 3))
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-liquid-bottom.png")
    }

    func testHomeUseNowTwoRowCarouselProofScreenshots() {
        let app = launchApp()
        assertHomeVisible(in: app)

        for _ in 0..<3 where !app.staticTexts["Use now"].exists {
            app.swipeUp()
        }

        XCTAssertTrue(app.staticTexts["Use now"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["HomeQuick.viet-phrase-polite-1"].waitForExistence(timeout: 3))
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-use-now-two-row-start.png")
    }

    func testHomeMessageCirclesStayVisibleAcrossRail() {
        let app = launchApp()
        assertHomeVisible(in: app)

        scrollToHomeScenarioRail(in: app)
        assertHomeScenarioContactVisible(app: app, id: "danangFirstDay")
        assertHomeScenarioContactVisible(app: app, id: "hotelCheckInHelp")
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-liquid-message-circles-visible.png")

        revealHomeScenario(app: app, id: "taxiGrabPickup")
        assertHomeScenarioContactVisible(app: app, id: "taxiGrabPickup")
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-liquid-message-circles-taxi.png")

        XCTAssertTrue(app.staticTexts["Grab Pickup"].exists)
    }

    func testHomeExploreByCityShowsAllCityGuides() {
        let app = launchApp()
        assertHomeVisible(in: app)

        scrollToHomeCityRail(in: app)
        assertHomeCityVisible(app: app, id: "danang")
        assertHomeCityVisible(app: app, id: "hoian")
        assertHomeCityVisible(app: app, id: "hcmc")
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-liquid-cities-first.png")

        revealHomeCity(app: app, id: "hanoi")
        assertHomeCityVisible(app: app, id: "hanoi")
        revealHomeCity(app: app, id: "hue")
        assertHomeCityVisible(app: app, id: "hue")
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-liquid-cities-all.png")
    }

    func testSearchChromeMorphHomeAndBrowseProofScreenshots() {
        let app = launchApp()
        assertHomeVisible(in: app)
        captureSearchMorphProofIfRequested(app: app, name: "home-collapsed.png")

        openSearch(in: app, expectedOrigin: "Home", iteration: 1)
        captureSearchMorphProofIfRequested(app: app, name: "home-search-expanded.png")
        tapSearchOrigin(in: app, title: "Home", iteration: 1)
        captureSearchMorphProofIfRequested(app: app, name: "home-return-immediate.png")
        XCTAssertTrue(
            app.textFields["AppChrome.SearchField"].waitForNonExistence(timeout: 2),
            "Search field stayed visible after tapping Home origin for proof."
        )
        captureSearchMorphProofIfRequested(app: app, name: "home-return-final.png")
        assertHomeVisible(in: app)

        openDock("Browse", in: app)
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
        captureSearchMorphProofIfRequested(app: app, name: "browse-collapsed.png")

        openSearch(in: app, expectedOrigin: "Browse", iteration: 2)
        captureSearchMorphProofIfRequested(app: app, name: "browse-search-expanded.png")
        tapSearchOrigin(in: app, title: "Browse", iteration: 2)
        captureSearchMorphProofIfRequested(app: app, name: "browse-return-immediate.png")
        XCTAssertTrue(
            app.textFields["AppChrome.SearchField"].waitForNonExistence(timeout: 2),
            "Search field stayed visible after tapping Browse origin for proof."
        )
        captureSearchMorphProofIfRequested(app: app, name: "browse-return-final.png")
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
    }

    func testBottomChromeForegroundMorphProofScreenshots() {
        let app = launchApp()
        assertHomeVisible(in: app)
        captureForegroundMorphProofIfRequested(app: app, name: "home-selected-lens.png")

        openSearch(in: app, expectedOrigin: "Home", iteration: 1)
        captureForegroundMorphProofIfRequested(app: app, name: "home-search-origin-and-field.png")

        tapSearchOrigin(in: app, title: "Home", iteration: 1)
        XCTAssertTrue(app.textFields["AppChrome.SearchField"].waitForNonExistence(timeout: 2))
        captureForegroundMorphProofIfRequested(app: app, name: "home-returned-lens.png")

        openDock("Saved", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))
        captureForegroundMorphProofIfRequested(app: app, name: "saved-selected-lens.png")
    }

    private func openSearch(in app: XCUIApplication, expectedOrigin: String, iteration: Int) {
        let searchButton = app.buttons["AppChrome.SearchButton"]
        XCTAssertTrue(
            searchButton.waitForExistence(timeout: 2),
            "Search island did not become tappable before iteration \(iteration)."
        )
        searchButton.tap()

        XCTAssertTrue(
            app.textFields["AppChrome.SearchField"].waitForExistence(timeout: 2),
            "Search field did not appear after tapping search on iteration \(iteration)."
        )
        XCTAssertTrue(
            app.buttons["AppChrome.SearchOriginButton.\(expectedOrigin)"].waitForExistence(timeout: 2),
            "Search origin did not preserve \(expectedOrigin) before iteration \(iteration)."
        )
        XCTAssertLessThan(
            app.buttons["AppChrome.SearchOriginButton.\(expectedOrigin)"].frame.midX,
            app.textFields["AppChrome.SearchField"].frame.midX,
            "Search origin should remain to the left of the search field during the foreground morph."
        )
    }

    private func openOrigin(in app: XCUIApplication, title: String, iteration: Int) {
        tapSearchOrigin(in: app, title: title, iteration: iteration)
        XCTAssertTrue(
            app.textFields["AppChrome.SearchField"].waitForNonExistence(timeout: 2),
            "Search field stayed visible after tapping \(title) origin on iteration \(iteration)."
        )
    }

    private func tapSearchOrigin(in app: XCUIApplication, title: String, iteration: Int) {
        let originButton = app.buttons["AppChrome.SearchOriginButton.\(title)"]
        XCTAssertTrue(
            originButton.waitForExistence(timeout: 2),
            "Search \(title) origin did not become tappable before iteration \(iteration)."
        )
        originButton.tap()
    }

    private func openDock(_ title: String, in app: XCUIApplication) {
        let dockButton = app.buttons["AppChrome.Dock.\(title)"]
        XCTAssertTrue(dockButton.waitForExistence(timeout: 2), "\(title) dock button was not available.")
        dockButton.tap()
    }

    private func assertHomeVisible(in app: XCUIApplication) {
        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["AppChrome.SearchButton"].waitForExistence(timeout: 2))
    }

    private func assertPinnedSpeedControlFloatsInTopAdmin(pinnedSpeedControl: XCUIElement) {
        XCTAssertLessThan(
            pinnedSpeedControl.frame.minY,
            120,
            "Pinned speed control should float in the top admin layer instead of creating scroll layout space."
        )
    }

    private func assertTopAdminControlsShareRow(
        app: XCUIApplication,
        pinnedSpeedControl: XCUIElement
    ) {
        let backButton = app.buttons["TopAdmin.BackButton"]
        XCTAssertTrue(backButton.exists, "Expected the top admin back button to be visible.")

        XCTAssertEqual(
            backButton.frame.midY,
            pinnedSpeedControl.frame.midY,
            accuracy: 2,
            "Top admin back button and speed control should share the same row."
        )
        XCTAssertLessThanOrEqual(
            pinnedSpeedControl.frame.height,
            48,
            "Pinned speed control should use the compact top-admin height."
        )

        let forwardButton = app.buttons["TopAdmin.ForwardButton"]
        if forwardButton.exists {
            XCTAssertEqual(
                forwardButton.frame.midY,
                pinnedSpeedControl.frame.midY,
                accuracy: 2,
                "Top admin forward button and speed control should share the same row."
            )
        }
    }

    private func scrollToHomeScenarioRail(in app: XCUIApplication) {
        for _ in 0..<5 where !app.staticTexts["Messages"].exists {
            app.swipeUp()
        }
        XCTAssertTrue(app.staticTexts["Messages"].waitForExistence(timeout: 3))

        let firstContact = app.buttons["HomeScenario.danangFirstDay"]
        for _ in 0..<5 where !firstContact.frame.intersects(app.frame) {
            app.swipeUp()
        }
        XCTAssertTrue(
            firstContact.waitForExistence(timeout: 3) && firstContact.frame.intersects(app.frame),
            "Expected the first message contact to be visible after scrolling to the rail."
        )
    }

    private func revealHomeScenario(app: XCUIApplication, id: String) {
        let targetButton = app.buttons["HomeScenario.\(id)"]
        for _ in 0..<5 where !targetButton.frame.intersects(app.frame) {
            let hotelContact = app.buttons["HomeScenario.hotelCheckInHelp"]
            if hotelContact.exists && hotelContact.frame.intersects(app.frame) {
                hotelContact.swipeLeft()
            } else {
                app.swipeLeft()
            }
        }
        XCTAssertTrue(
            targetButton.frame.intersects(app.frame),
            "Expected HomeScenario.\(id) to be visible after dragging the scenario rail."
        )
    }

    private func assertHomeScenarioContactVisible(
        app: XCUIApplication,
        id: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let button = app.buttons["HomeScenario.\(id)"]

        XCTAssertTrue(button.waitForExistence(timeout: 3), "Missing message contact \(id).", file: file, line: line)
        XCTAssertTrue(button.frame.intersects(app.frame), "Message contact \(id) is not visible.", file: file, line: line)
        XCTAssertGreaterThan(button.frame.width, 72, "Message contact \(id) should keep a tappable circle width.", file: file, line: line)
        XCTAssertGreaterThan(button.frame.height, 100, "Message contact \(id) should include avatar and label.", file: file, line: line)
    }

    private func scrollToHomeCityRail(in app: XCUIApplication) {
        for _ in 0..<6 where !app.staticTexts["Explore by city"].exists {
            app.swipeUp()
        }
        XCTAssertTrue(app.staticTexts["Explore by city"].waitForExistence(timeout: 3))

        let daNangCard = app.buttons["HomeCity.danang"]
        for _ in 0..<5 where !daNangCard.frame.intersects(app.frame) {
            app.swipeUp()
        }
        XCTAssertTrue(
            daNangCard.waitForExistence(timeout: 3) && daNangCard.frame.intersects(app.frame),
            "Expected the first city card to be visible after scrolling to the city rail."
        )
    }

    private func revealHomeCity(app: XCUIApplication, id: String) {
        let targetCard = app.buttons["HomeCity.\(id)"]
        for _ in 0..<6 where !targetCard.frame.intersects(app.frame) {
            if let visibleCard = ["hcmc", "hoian", "danang", "hanoi"]
                .map({ app.buttons["HomeCity.\($0)"] })
                .first(where: { $0.exists && $0.frame.intersects(app.frame) }) {
                visibleCard.swipeLeft()
            } else {
                app.swipeLeft()
            }
        }
        XCTAssertTrue(
            targetCard.frame.intersects(app.frame),
            "Expected HomeCity.\(id) to be visible after dragging the city rail."
        )
    }

    private func assertHomeCityVisible(
        app: XCUIApplication,
        id: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let card = app.buttons["HomeCity.\(id)"]
        XCTAssertTrue(card.waitForExistence(timeout: 3), "Missing home city card \(id).", file: file, line: line)
        XCTAssertTrue(card.frame.intersects(app.frame), "Home city card \(id) is not visible.", file: file, line: line)
        XCTAssertGreaterThan(card.frame.width, 120, "Home city card \(id) should keep its card width.", file: file, line: line)
        XCTAssertGreaterThan(card.frame.height, 120, "Home city card \(id) should keep its card height.", file: file, line: line)
    }

    private func verifyDockTapFromDenseDetail(
        _ title: String,
        point: ChromeTapPoint,
        assertion: (XCUIApplication) -> Void
    ) {
        let app = launchDenseDetail()
        tapChrome(app.buttons["AppChrome.Dock.\(title)"], point: point)
        assertion(app)
        XCTAssertFalse(app.staticTexts["Hello, older brother / slightly older man"].isHittable)
    }

    private func launchDenseDetail() -> XCUIApplication {
        let app = launchApp(arguments: ["--detail-page", "viet-phrase-hello-chao-anh"])
        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))
        return app
    }

    private func launchApp(arguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.terminate()
        app.launchArguments = arguments
        app.launch()
        return app
    }

    private enum ChromeTapPoint {
        case center
        case leadingEdge
        case trailingEdge
        case topEdge
        case bottomEdge

        var offset: CGVector {
            switch self {
            case .center:
                return CGVector(dx: 0.5, dy: 0.5)
            case .leadingEdge:
                return CGVector(dx: 0.08, dy: 0.5)
            case .trailingEdge:
                return CGVector(dx: 0.92, dy: 0.5)
            case .topEdge:
                return CGVector(dx: 0.5, dy: 0.12)
            case .bottomEdge:
                return CGVector(dx: 0.5, dy: 0.88)
            }
        }
    }

    private func tapChrome(_ element: XCUIElement, point: ChromeTapPoint) {
        XCTAssertTrue(element.waitForExistence(timeout: 2), "\(element) was not available.")
        element.coordinate(withNormalizedOffset: point.offset).tap()
    }

    private func captureProofIfRequested(app: XCUIApplication, name: String) {
        let sentinelPath = "/tmp/speaklocal-bottom-chrome-proof-enabled"
        let environmentPath = ProcessInfo.processInfo.environment["SPEAKLOCAL_BOTTOM_CHROME_PROOF_DIR"]
        guard
            FileManager.default.fileExists(atPath: sentinelPath) || environmentPath?.isEmpty == false,
            let directoryURL = proofDirectoryURL(environmentPath: environmentPath)
        else {
            return
        }

        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: directoryURL.appendingPathComponent(name))
    }

    private func captureSearchMorphProofIfRequested(app: XCUIApplication, name: String) {
        let sentinelPath = "/tmp/speaklocal-search-chrome-morph-proof-enabled"
        let environmentPath = ProcessInfo.processInfo.environment["SPEAKLOCAL_SEARCH_CHROME_MORPH_PROOF_DIR"]
        guard
            FileManager.default.fileExists(atPath: sentinelPath) || environmentPath?.isEmpty == false,
            let directoryURL = proofDirectoryURL(
                environmentPath: environmentPath,
                taskID: "TASK-NATIVE-SEARCH-CHROME-MORPH-001"
            )
        else {
            return
        }

        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: directoryURL.appendingPathComponent(name))
    }

    private func captureForegroundMorphProofIfRequested(app: XCUIApplication, name: String) {
        let sentinelPath = "/tmp/speaklocal-bottom-chrome-foreground-morph-proof-enabled"
        guard
            FileManager.default.fileExists(atPath: sentinelPath),
            let directoryURL = proofDirectoryURL(
                environmentPath: nil,
                taskID: "TASK-NATIVE-BOTTOM-CHROME-FOREGROUND-MORPH-001"
            )
        else {
            return
        }

        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: directoryURL.appendingPathComponent(name))
    }

    private func capturePinnedAudioProofIfRequested(app: XCUIApplication, name: String) {
        let sentinelPath = "/tmp/speaklocal-pinned-audio-speed-proof-enabled"
        let environmentPath = ProcessInfo.processInfo.environment["SPEAKLOCAL_PINNED_AUDIO_SPEED_PROOF_DIR"]
        guard
            FileManager.default.fileExists(atPath: sentinelPath) || environmentPath?.isEmpty == false,
            let directoryURL = proofDirectoryURL(
                environmentPath: environmentPath,
                taskID: "TASK-NATIVE-PINNED-AUDIO-SPEED-001"
            )
        else {
            return
        }

        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: directoryURL.appendingPathComponent(name))
    }

    private func captureHomeLiquidGlassProofIfRequested(app: XCUIApplication, name: String) {
        let sentinelPath = "/tmp/speaklocal-home-liquid-glass-proof-enabled"
        let environmentPath = ProcessInfo.processInfo.environment["SPEAKLOCAL_HOME_LIQUID_GLASS_PROOF_DIR"]
        guard
            FileManager.default.fileExists(atPath: sentinelPath) || environmentPath?.isEmpty == false,
            let directoryURL = proofDirectoryURL(
                environmentPath: environmentPath,
                taskID: "TASK-HOME-LIQUID-GLASS-REDESIGN-001"
            )
        else {
            return
        }

        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: directoryURL.appendingPathComponent(name))
    }

    private func proofDirectoryURL(environmentPath: String?) -> URL? {
        proofDirectoryURL(
            environmentPath: environmentPath,
            taskID: "TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001"
        )
    }

    private func proofDirectoryURL(environmentPath: String?, taskID: String) -> URL? {
        if let environmentPath, !environmentPath.isEmpty {
            return URL(fileURLWithPath: environmentPath, isDirectory: true)
        }

        let testFileURL = URL(fileURLWithPath: #filePath)
        let repoRootURL = testFileURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()

        return repoRootURL
            .appendingPathComponent("docs/task-results/assets/\(taskID)", isDirectory: true)
    }
}
