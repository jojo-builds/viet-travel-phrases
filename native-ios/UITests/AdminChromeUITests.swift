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

        openDock("Practice", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))
        openSearch(in: app, expectedOrigin: "Practice", iteration: 4)
        openOrigin(in: app, title: "Practice", iteration: 4)
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))
    }

    func testDetailSearchBrowseOriginRoundTripKeepsChromeResponsive() {
        let app = XCUIApplication()
        app.launchArguments = ["--detail-page", "viet-phrase-hello-chao-anh"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))

        openSearch(in: app, expectedOrigin: "Browse", iteration: 1)
        openOrigin(in: app, title: "Browse", iteration: 1)
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))

        openSearch(in: app, expectedOrigin: "Browse", iteration: 2)
        XCTAssertTrue(app.staticTexts["Search"].waitForExistence(timeout: 2))
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
    }

    private func openOrigin(in app: XCUIApplication, title: String, iteration: Int) {
        let originButton = app.buttons["AppChrome.SearchOriginButton.\(title)"]
        XCTAssertTrue(
            originButton.waitForExistence(timeout: 2),
            "Search \(title) origin did not become tappable before iteration \(iteration)."
        )
        originButton.tap()
        XCTAssertTrue(
            app.textFields["AppChrome.SearchField"].waitForNonExistence(timeout: 2),
            "Search field stayed visible after tapping \(title) origin on iteration \(iteration)."
        )
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
}
