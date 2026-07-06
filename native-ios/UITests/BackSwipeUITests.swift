import XCTest

final class BackSwipeUITests: XCTestCase {
    func testEdgeSwipeReturnsFromDirectDetailToHome() {
        let app = XCUIApplication()
        app.launchArguments = ["--detail-page", "viet-hello-anh"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 5))

        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.5))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.38, dy: 0.5))
        start.press(forDuration: 0.05, thenDragTo: end)

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.staticTexts["Hello, older brother / slightly older man"].isHittable)
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))
    }

    func testRightEdgeSwipeRestoresForwardPageAfterBackSwipe() {
        let app = XCUIApplication()
        app.launchArguments = ["--detail-page", "viet-hello-anh"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))

        let backStart = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.5))
        let backEnd = app.coordinate(withNormalizedOffset: CGVector(dx: 0.38, dy: 0.5))
        backStart.press(forDuration: 0.05, thenDragTo: backEnd)

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Go forward"].waitForExistence(timeout: 2))

        let forwardStart = app.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.5))
        let forwardEnd = app.coordinate(withNormalizedOffset: CGVector(dx: 0.62, dy: 0.5))
        forwardStart.press(forDuration: 0.05, thenDragTo: forwardEnd)

        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 3))
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))
    }

    func testTopForwardButtonRestoresForwardPageAfterBackButton() {
        let app = XCUIApplication()
        app.launchArguments = ["--detail-page", "viet-hello-anh"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))

        let backButton = app.buttons["TopAdmin.BackButton"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 3))
        backButton.tap()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))

        let forwardButton = app.buttons["TopAdmin.ForwardButton"]
        XCTAssertTrue(forwardButton.waitForExistence(timeout: 3))
        forwardButton.tap()

        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 3))
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))
    }

    func testBrowseBackSwipeKeepsHomeSearchChromeUsable() {
        let app = XCUIApplication()
        app.launchArguments = ["--browse"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 5))

        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.5))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.38, dy: 0.5))
        start.press(forDuration: 0.05, thenDragTo: end)

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))

        systemTabCoordinate("Search", in: app).tap()

        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 3))
        XCTAssertTrue(searchField(in: app).waitForExistence(timeout: 2))
    }

    func testBrowseRootOpenedFromHomeShowsBackButton() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 5))

        systemTabCoordinate("Browse", in: app).tap()

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
        XCTAssertTrue(
            app.buttons["TopAdmin.BackButton"].waitForExistence(timeout: 2),
            "Browse was opened from Home, so the visible back button should match the existing back-swipe route."
        )
    }

    func testHomeCityCardBackButtonReturnsHome() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 5))

        let daNangCard = app.buttons["HomeCity.danang"]
        scrollUntilHittable(daNangCard, in: app)
        daNangCard.tap()

        XCTAssertTrue(app.descendants(matching: .any)["BrowseCollection.city.danang"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["TopAdmin.BackButton"].waitForExistence(timeout: 2))

        app.buttons["Go back"].tap()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        let restoredDaNangCard = app.buttons["HomeCity.danang"]
        XCTAssertTrue(
            restoredDaNangCard.waitForExistence(timeout: 3) && restoredDaNangCard.frame.intersects(app.frame),
            "Back from a Home city card should restore the Home scroll position around Explore by city instead of jumping to the top."
        )
        XCTAssertFalse(app.staticTexts["Browse.Title"].exists)
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))
    }

    func testHomeCityCardBackSwipeReturnsHomePosition() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 5))

        let daNangCard = app.buttons["HomeCity.danang"]
        scrollUntilHittable(daNangCard, in: app)
        daNangCard.tap()

        XCTAssertTrue(app.descendants(matching: .any)["BrowseCollection.city.danang"].waitForExistence(timeout: 5))

        edgeSwipeBack(in: app)

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        assertVisible(
            app.buttons["HomeCity.danang"],
            in: app,
            message: "Back swipe from a Home city card should restore the city shelf."
        )
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))
    }

    func testHomePhraseBackSwipeReturnsHomePosition() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 5))

        let firstDayHeader = app.staticTexts["First Day in Vietnam"]
        let airportPhrase = app.buttons["HomeQuick.viet-phrase-airport-1"]
        scrollUntilVisible(firstDayHeader, in: app)
        scrollUntilHittable(airportPhrase, in: app)
        let originalPhraseMidY = airportPhrase.frame.midY
        airportPhrase.tap()

        XCTAssertTrue(
            app.descendants(matching: .any)["PhraseArticle.viet-phrase-airport-1"].waitForExistence(timeout: 5),
            "Tapping a Home phrase card should open its detail/article page."
        )

        edgeSwipeBack(in: app)

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        let restoredAirportPhrase = app.buttons["HomeQuick.viet-phrase-airport-1"]
        XCTAssertTrue(restoredAirportPhrase.waitForExistence(timeout: 3))
        XCTAssertLessThan(
            abs(restoredAirportPhrase.frame.midY - originalPhraseMidY),
            72,
            "Back swipe from a Home listing card should preserve the same viewport focus."
        )
        assertVisible(
            firstDayHeader,
            in: app,
            message: "Back swipe from a Home phrase should restore the phrase shelf it came from."
        )
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))
    }

    func testHomeShelfHeaderBackButtonPreservesViewportPosition() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 5))

        let firstDayHeader = app.staticTexts["First Day in Vietnam"]
        scrollUntilVisible(firstDayHeader, in: app)
        XCTAssertTrue(firstDayHeader.isHittable)
        let originalMidY = firstDayHeader.frame.midY

        firstDayHeader.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()

        XCTAssertTrue(app.descendants(matching: .any)["BrowseCollection.category.first-day"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["TopAdmin.BackButton"].waitForExistence(timeout: 2))

        app.buttons["Go back"].tap()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        let restoredHeader = app.staticTexts["First Day in Vietnam"]
        XCTAssertTrue(restoredHeader.waitForExistence(timeout: 3))

        let restoredMidY = restoredHeader.frame.midY
        XCTAssertLessThan(
            abs(restoredMidY - originalMidY),
            120,
            "Back from a Home shelf header should restore the same viewport focus instead of moving the shelf title to the top."
        )
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))
    }

    func testHomePracticeBackChainReturnsHomePosition() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 5))

        let quickPractice = app.buttons["Home.PracticeStarter.quick"]
        scrollUntilHittable(quickPractice, in: app)
        quickPractice.tap()

        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 5))
        let closePractice = app.buttons["Close practice"].firstMatch
        XCTAssertTrue(
            closePractice.waitForExistence(timeout: 5),
            "Home practice starter should open a dismissible practice flow."
        )
        XCTAssertFalse(
            app.tabBars.firstMatch.exists && app.tabBars.firstMatch.isHittable,
            "Home practice should hide the bottom tab bar while the practice sheet is open."
        )
        XCTAssertFalse(
            app.descendants(matching: .any)["Practice.Match.Hub"].exists,
            "Home practice should open the direct round card instead of showing the Practice page underneath."
        )

        app.coordinate(withNormalizedOffset: CGVector(dx: 0.84, dy: 0.34)).tap()
        XCTAssertTrue(app.descendants(matching: .any)["Practice.Match.Root"].waitForNonExistence(timeout: 4))
        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        assertVisible(
            app.descendants(matching: .any)["HomePracticeStarterRail"],
            in: app,
            message: "Back from Home practice should restore the Practice shelf."
        )
    }

    func testHomePracticePoolOpensDirectRoundWithoutPracticeHubFallback() {
        let app = XCUIApplication()
        app.launchArguments = ["--seed-returning-user-shelves"]
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 5))

        let quickPractice = app.buttons["Home.PracticeStarter.quick"]
        scrollUntilHittable(quickPractice, in: app)

        let practicePool = app.buttons["Home.PracticeStarter.practice"]
        let practiceRail = app.descendants(matching: .any)["HomePracticeStarterRail"]
        for _ in 0..<3 where !isComfortablyHittable(practicePool, in: app) {
            practiceRail.swipeLeft()
        }
        XCTAssertTrue(practicePool.waitForExistence(timeout: 3))
        XCTAssertTrue(isComfortablyHittable(practicePool, in: app))
        practicePool.tap()

        XCTAssertTrue(app.staticTexts["Match the pairs"].waitForExistence(timeout: 5))
        XCTAssertFalse(
            app.descendants(matching: .any)["Practice.Match.Hub"].exists,
            "Home Practice pool should open the direct round without exposing the Practice hub."
        )
        XCTAssertFalse(
            app.descendants(matching: .any)["Practice.Match.Topic.essentials"].exists,
            "Practice topics should stay out of the Home-launched practice sheet."
        )

        dragVertically(in: app, from: 0.58, to: 0.94)
        XCTAssertTrue(app.descendants(matching: .any)["Practice.Match.Root"].waitForNonExistence(timeout: 4))
        XCTAssertFalse(app.descendants(matching: .any)["Practice.Match.Hub"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
    }

    func testHomeSituationBackButtonReturnsHomePosition() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 5))

        let arrivalSituation = app.buttons["HomeSituation.arrival"]
        scrollUntilHittable(arrivalSituation, in: app)
        arrivalSituation.tap()

        XCTAssertTrue(app.descendants(matching: .any)["BrowseCollection.category.airport"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["TopAdmin.BackButton"].waitForExistence(timeout: 2))

        app.buttons["Go back"].tap()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        assertVisible(
            app.buttons["HomeSituation.arrival"],
            in: app,
            message: "Back from a Home situation should restore the situation shelf."
        )
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))
    }

    func testHomeBrowseTabBackButtonReturnsScrolledHomePosition() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 5))

        let daNangCard = app.buttons["HomeCity.danang"]
        scrollUntilHittable(daNangCard, in: app)

        systemTabCoordinate("Browse", in: app).tap()

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["TopAdmin.BackButton"].waitForExistence(timeout: 2))

        app.buttons["Go back"].tap()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        assertVisible(
            app.buttons["HomeCity.danang"],
            in: app,
            message: "Back from a one-level Browse tab tap should restore the scrolled Home position."
        )
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
        case "Practice":
            normalizedX = 0.66
        case "Search":
            normalizedX = 0.82
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

    private func edgeSwipeBack(in app: XCUIApplication) {
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.5))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.38, dy: 0.5))
        start.press(forDuration: 0.05, thenDragTo: end)
    }

    private func scrollUntilVisible(
        _ element: XCUIElement,
        in app: XCUIApplication,
        maxSwipes: Int = 8,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        for _ in 0..<maxSwipes where !element.exists || !element.frame.intersects(app.frame) {
            app.swipeUp()
        }

        assertVisible(element, in: app, file: file, line: line)
    }

    private func scrollUntilHittable(
        _ element: XCUIElement,
        in app: XCUIApplication,
        maxSwipes: Int = 8,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        for _ in 0..<maxSwipes where !isComfortablyHittable(element, in: app) {
            if element.exists, element.frame.maxY < app.frame.minY + 24 {
                app.swipeDown()
            } else {
                app.swipeUp()
            }
        }

        for _ in 0..<maxSwipes where !isComfortablyHittable(element, in: app) {
            app.swipeDown()
        }

        XCTAssertTrue(element.waitForExistence(timeout: 3), "Expected element to exist.", file: file, line: line)
        XCTAssertTrue(element.isHittable, "Expected element to be hittable.", file: file, line: line)
        XCTAssertTrue(
            isComfortablyVisible(element, in: app),
            "Expected element to be fully visible above the tab bar before tapping.",
            file: file,
            line: line
        )
    }

    private func dragVertically(in app: XCUIApplication, from startY: CGFloat, to endY: CGFloat) {
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: startY))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: endY))
        start.press(forDuration: 0.05, thenDragTo: end)
    }

    private func isComfortablyHittable(_ element: XCUIElement, in app: XCUIApplication) -> Bool {
        element.exists && element.isHittable && isComfortablyVisible(element, in: app)
    }

    private func isComfortablyVisible(_ element: XCUIElement, in app: XCUIApplication) -> Bool {
        guard element.exists else {
            return false
        }

        let frame = element.frame
        let comfortableBottom = app.frame.maxY - 120
        return frame.minY >= app.frame.minY + 24 && frame.maxY <= comfortableBottom
    }

    private func assertVisible(
        _ element: XCUIElement,
        in app: XCUIApplication,
        message: String = "Expected element to be visible.",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(element.waitForExistence(timeout: 3), message, file: file, line: line)
        if element.exists {
            XCTAssertTrue(element.frame.intersects(app.frame), message, file: file, line: line)
        }
    }
}
