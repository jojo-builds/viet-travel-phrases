import XCTest

final class BackSwipeUITests: XCTestCase {
    func testEdgeSwipeReturnsFromDirectDetailToHome() {
        let app = XCUIApplication()
        app.launchArguments = ["--detail-page", "viet-hello-anh"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))

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
        for _ in 0..<5 where !daNangCard.isHittable {
            app.swipeUp()
        }

        XCTAssertTrue(daNangCard.waitForExistence(timeout: 3))
        daNangCard.tap()

        XCTAssertTrue(app.descendants(matching: .any)["BrowseCollection.city.danang"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["TopAdmin.BackButton"].waitForExistence(timeout: 2))

        app.buttons["Go back"].tap()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.staticTexts["Browse.Title"].exists)
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
}
