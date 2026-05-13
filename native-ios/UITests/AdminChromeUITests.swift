import XCTest

final class AdminChromeUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testHomeAndSearchSystemTabCanSwitchRepeatedly() {
        let app = XCUIApplication()
        app.launch()

        assertHomeVisible(in: app)

        for iteration in 1...8 {
            openSearch(in: app, iteration: iteration)
            openDock("Home", in: app)
            assertHomeVisible(in: app)
        }
    }

    func testPrimarySystemTabsRemainReachableAroundSearch() {
        let app = XCUIApplication()
        app.launch()

        assertHomeVisible(in: app)

        openSearch(in: app, iteration: 1)
        openDock("Home", in: app)
        assertHomeVisible(in: app)

        openDock("Browse", in: app)
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
        openSearch(in: app, iteration: 2)
        openDock("Browse", in: app)
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))

        openDock("Saved", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))
        openSearch(in: app, iteration: 3)
        openDock("Saved", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))

        openDock("Messages", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))
        openSearch(in: app, iteration: 4)
        openDock("Messages", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))
    }

    func testSystemTabTapsCommitDestinations() {
        let app = XCUIApplication()
        app.launch()

        assertHomeVisible(in: app)

        openDock("Messages", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))

        openDock("Browse", in: app)
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
    }

    func testSystemTabTapCommitsDestination() {
        let app = XCUIApplication()
        app.launch()

        assertHomeVisible(in: app)

        openDock("Messages", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))
        captureProofIfRequested(app: app, name: "system-tab-home-to-messages-settled.png")
    }

    func testDetailSearchOriginRoundTripKeepsChromeResponsive() {
        let app = XCUIApplication()
        app.launchArguments = ["--detail-page", "viet-phrase-hello-chao-anh"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))

        openSearch(in: app, iteration: 1)
        openDock("Browse", in: app)
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))

        openSearch(in: app, iteration: 2)
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

    func testHomeUseNowPinsAudioSpeedControlAfterPlayerScrollsOffscreen() {
        let app = launchApp(arguments: ["--reset-demo-state"])
        assertHomeVisible(in: app)
        XCTAssertTrue(app.staticTexts["Use now"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.descendants(matching: .any)["HomeFeaturedPhrase.viet-polite-hello"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.descendants(matching: .any)["PinnedAudioSpeedControl"].exists)
        capturePinnedAudioProofIfRequested(app: app, name: "home-use-now-player-visible.png")

        for _ in 0..<4 where !app.descendants(matching: .any)["PinnedAudioSpeedControl"].exists {
            app.swipeUp()
        }

        let pinnedSpeedControl = app.descendants(matching: .any)["PinnedAudioSpeedControl"]
        XCTAssertTrue(
            pinnedSpeedControl.waitForExistence(timeout: 2),
            "Pinned speed control should appear once the Home Use Now player scrolls above the top chrome."
        )
        XCTAssertFalse(app.buttons["TopAdmin.BackButton"].exists, "Home should show the speed pill without adding a Back button.")
        XCTAssertTrue(app.descendants(matching: .any)["0.5x"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["0.75x"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["1.0x"].exists)
        assertPinnedSpeedControlFloatsInTopAdmin(pinnedSpeedControl: pinnedSpeedControl)
        XCTAssertLessThanOrEqual(
            pinnedSpeedControl.frame.height,
            48,
            "Home pinned speed control should use the same compact top-admin height as listing pages."
        )
        capturePinnedAudioProofIfRequested(app: app, name: "home-use-now-pinned-speed-control.png")

        for _ in 0..<5 where app.descendants(matching: .any)["PinnedAudioSpeedControl"].exists {
            app.swipeDown()
        }

        XCTAssertTrue(app.descendants(matching: .any)["HomeFeaturedPhrase.viet-polite-hello"].waitForExistence(timeout: 3))
        XCTAssertFalse(
            app.descendants(matching: .any)["PinnedAudioSpeedControl"].exists,
            "Pinned speed control should go away once the Home Use Now player returns into view."
        )
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
        openSearch(in: app, iteration: 1)
        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 3))
        XCTAssertTrue(searchField(in: app).waitForExistence(timeout: 2))
    }

    func testSystemTabChromeProofScreenshots() {
        var app = launchApp(arguments: ["--detail-page", "viet-phrase-hello-chao-anh"])
        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))
        captureProofIfRequested(app: app, name: "detail-system-tab-chrome.png")

        app = launchApp()
        assertHomeVisible(in: app)
        captureProofIfRequested(app: app, name: "home-system-tab-chrome.png")
        openDock("Saved", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))
        captureProofIfRequested(app: app, name: "saved-system-tab-chrome.png")

        app = launchApp(arguments: ["--browse"])
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 5))
        captureProofIfRequested(app: app, name: "browse-system-tab-chrome.png")

        app = launchApp(arguments: ["--search"])
        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 5))
        captureProofIfRequested(app: app, name: "search-system-tab-chrome.png")

        app = launchApp(arguments: ["--practice"])
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 5))
        captureProofIfRequested(app: app, name: "practice-system-tab-chrome.png")
    }

    func testHomeLiquidGlassRedesignProofScreenshots() {
        let app = launchApp(arguments: ["--reset-demo-state"])
        assertHomeVisible(in: app)
        XCTAssertFalse(app.staticTexts["Start speaking now"].exists)
        XCTAssertFalse(app.staticTexts["Offline phrases, audio, and local ways to say it."].exists)
        XCTAssertTrue(app.staticTexts["Use now"].exists)
        XCTAssertTrue(app.buttons["HomeShelf.Header.category.essentials"].exists)
        XCTAssertFalse(app.staticTexts["Test phrase cards"].exists)
        XCTAssertFalse(app.staticTexts["Larger listen cards for common moments"].exists)
        XCTAssertFalse(app.descendants(matching: .any)["Home.SearchEntry"].exists)
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-liquid-top.png")

        for _ in 0..<3 where !app.staticTexts["First hour in Vietnam"].exists {
            app.swipeUp()
        }
        XCTAssertTrue(app.staticTexts["First hour in Vietnam"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["HomeShelf.Header.category.first-day"].exists)
        XCTAssertFalse(app.buttons["HomeShelf.More.first-hour"].exists)
        XCTAssertFalse(app.staticTexts["Keep going"].exists)
        XCTAssertFalse(app.staticTexts["Saved for later"].exists)
        XCTAssertFalse(app.staticTexts["Message list"].exists)
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-liquid-mid.png")

        for _ in 0..<3 where !app.staticTexts["Explore by city"].exists {
            app.swipeUp()
        }
        XCTAssertTrue(app.staticTexts["Explore by city"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["HomeShelf.Header.category.city-guides"].exists)
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-liquid-city.png")

        for _ in 0..<3 where !app.staticTexts["Food & coffee"].exists {
            app.swipeUp()
        }
        XCTAssertTrue(app.buttons["HomeShelf.Header.category.food"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.buttons["HomeShelf.More.food-coffee"].exists)

        let scenarioRail = app.descendants(matching: .any)["HomeScenarioRail"]
        for _ in 0..<3 where !scenarioRail.exists {
            app.swipeUp()
        }
        XCTAssertTrue(scenarioRail.waitForExistence(timeout: 3))
        for _ in 0..<2 where !app.buttons["HomeScenario.danangFirstDay"].exists {
            app.swipeUp()
        }
        XCTAssertTrue(app.buttons["HomeScenario.danangFirstDay"].exists)
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-liquid-lower.png")

        for _ in 0..<5 where !app.staticTexts["Who are you speaking to?"].exists {
            app.swipeUp()
        }
        XCTAssertTrue(app.staticTexts["Who are you speaking to?"].waitForExistence(timeout: 3))
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-liquid-bottom.png")
    }

    func testHomeUseNowLargeCardsProofScreenshots() {
        let app = launchApp(arguments: ["--reset-demo-state"])
        assertHomeVisible(in: app)

        for _ in 0..<3 where !app.staticTexts["Use now"].exists {
            app.swipeUp()
        }

        XCTAssertTrue(app.staticTexts["Use now"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["HomeShelf.Header.category.essentials"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["HomeFeaturedPhrase.viet-polite-hello"].waitForExistence(timeout: 3))
        captureHomeLiquidGlassProofIfRequested(app: app, name: "home-use-now-large-card-start.png")
    }

    func testHomeMessageCirclesStayVisibleAcrossRail() {
        let app = launchApp(arguments: ["--reset-demo-state"])
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
        let app = launchApp(arguments: ["--reset-demo-state"])
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

    func testSystemSearchTabHomeAndBrowseProofScreenshots() {
        let app = launchApp()
        assertHomeVisible(in: app)
        captureSearchMorphProofIfRequested(app: app, name: "home-collapsed.png")

        openSearch(in: app, iteration: 1)
        captureSearchMorphProofIfRequested(app: app, name: "home-search-expanded.png")
        openDock("Home", in: app)
        captureSearchMorphProofIfRequested(app: app, name: "home-return-immediate.png")
        captureSearchMorphProofIfRequested(app: app, name: "home-return-final.png")
        assertHomeVisible(in: app)

        openDock("Browse", in: app)
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
        captureSearchMorphProofIfRequested(app: app, name: "browse-collapsed.png")

        openSearch(in: app, iteration: 2)
        captureSearchMorphProofIfRequested(app: app, name: "browse-search-expanded.png")
        openDock("Browse", in: app)
        captureSearchMorphProofIfRequested(app: app, name: "browse-return-immediate.png")
        captureSearchMorphProofIfRequested(app: app, name: "browse-return-final.png")
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
    }

    func testSystemTabSelectionProofScreenshots() {
        let app = launchApp()
        assertHomeVisible(in: app)
        captureForegroundMorphProofIfRequested(app: app, name: "home-system-tab-selected.png")

        openSearch(in: app, iteration: 1)
        captureForegroundMorphProofIfRequested(app: app, name: "home-system-search-selected.png")

        openDock("Home", in: app)
        captureForegroundMorphProofIfRequested(app: app, name: "home-returned-system-tab.png")

        openDock("Saved", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))
        captureForegroundMorphProofIfRequested(app: app, name: "saved-system-tab-selected.png")
    }

    func testFocusedSystemSearchFieldAcceptsTyping() {
        let app = launchApp()
        assertHomeVisible(in: app)

        openSearch(in: app, iteration: 1)
        let searchField = searchField(in: app)
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.tap()
        searchField.typeText("hotel")
        XCTAssertTrue(app.staticTexts["Results for hotel"].waitForExistence(timeout: 3))
        captureFocusedSearchChromeProofIfRequested(app: app, name: "focused-system-search-results.png")
    }

    private func openSearch(in app: XCUIApplication, iteration: Int) {
        openDock("Search", in: app)

        XCTAssertTrue(
            app.staticTexts["Search.Title"].waitForExistence(timeout: 3) || app.staticTexts["Search"].waitForExistence(timeout: 1),
            "Search page did not appear after tapping the system search tab on iteration \(iteration)."
        )
    }

    private func openOrigin(in app: XCUIApplication, title: String, iteration: Int) {
        tapSearchOrigin(in: app, title: title, iteration: iteration)
    }

    private func tapSearchOrigin(in app: XCUIApplication, title: String, iteration: Int) {
        openDock(title, in: app)
    }

    private func openDock(_ title: String, in app: XCUIApplication) {
        let dockButton = systemTab(title, in: app)
        if dockButton.waitForExistence(timeout: 2) {
            dockButton.tap()
        } else {
            systemTabCoordinate(title, in: app).tap()
        }
    }

    private func assertHomeVisible(in app: XCUIApplication) {
        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))
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

    private func systemTabCoordinate(_ title: String, in app: XCUIApplication) -> XCUICoordinate {
        let normalizedX: CGFloat
        switch title {
        case "Home":
            normalizedX = 0.14
        case "Browse":
            normalizedX = 0.31
        case "Saved":
            normalizedX = 0.49
        case "Messages":
            normalizedX = 0.66
        case "Search":
            normalizedX = 0.88
        default:
            normalizedX = 0.5
        }

        return app.coordinate(withNormalizedOffset: CGVector(dx: normalizedX, dy: 0.94))
    }

    private func searchField(in app: XCUIApplication) -> XCUIElement {
        let promptedSearchField = app.searchFields["Search Vietnamese phrases"]
        if promptedSearchField.exists {
            return promptedSearchField
        }

        let anySearchField = app.searchFields.firstMatch
        if anySearchField.exists {
            return anySearchField
        }

        return app.textFields["Search Vietnamese phrases"]
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
        let scenarioRail = app.descendants(matching: .any)["HomeScenarioRail"]
        for _ in 0..<5 where !scenarioRail.exists {
            app.swipeUp()
        }
        XCTAssertTrue(scenarioRail.waitForExistence(timeout: 3))

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
        let scenarioRail = app.descendants(matching: .any)["HomeScenarioRail"]
        for _ in 0..<5 where !targetButton.frame.intersects(app.frame) {
            if scenarioRail.exists && scenarioRail.frame.intersects(app.frame) {
                dragRailLeft(scenarioRail)
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
        let cityRail = app.descendants(matching: .any)["HomeCityRail"]
        for _ in 0..<6 where !targetCard.frame.intersects(app.frame) {
            if cityRail.exists && cityRail.frame.intersects(app.frame) {
                dragRailLeft(cityRail)
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

    private func dragRailLeft(_ rail: XCUIElement) {
        let start = rail.coordinate(withNormalizedOffset: CGVector(dx: 0.88, dy: 0.5))
        let end = rail.coordinate(withNormalizedOffset: CGVector(dx: 0.12, dy: 0.5))
        start.press(forDuration: 0.05, thenDragTo: end)
    }

    private func verifyDockTapFromDenseDetail(
        _ title: String,
        point: ChromeTapPoint,
        assertion: (XCUIApplication) -> Void
    ) {
        let app = launchDenseDetail()
        openDock(title, in: app)
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

    private func captureFocusedSearchChromeProofIfRequested(app: XCUIApplication, name: String) {
        let sentinelPath = "/tmp/speaklocal-focused-search-chrome-proof-enabled"
        let environmentPath = ProcessInfo.processInfo.environment["SPEAKLOCAL_FOCUSED_SEARCH_CHROME_PROOF_DIR"]
        guard
            FileManager.default.fileExists(atPath: sentinelPath) || environmentPath?.isEmpty == false,
            let directoryURL = proofDirectoryURL(
                environmentPath: environmentPath,
                taskID: "TASK-NATIVE-FOCUSED-SEARCH-CHROME-001"
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
