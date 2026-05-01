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
            openSearch(in: app, iteration: iteration)
            openHome(in: app, iteration: iteration)
        }
    }

    func testDetailSearchHomeSearchRoundTripKeepsChromeResponsive() {
        let app = XCUIApplication()
        app.launchArguments = ["--detail-page", "viet-phrase-hello-chao-anh"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))

        openSearch(in: app, iteration: 1)
        openHome(in: app, iteration: 1)
        assertHomeVisible(in: app)

        openSearch(in: app, iteration: 2)
        XCTAssertTrue(app.staticTexts["Search"].waitForExistence(timeout: 2))
    }

    private func openSearch(in app: XCUIApplication, iteration: Int) {
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
    }

    private func openHome(in app: XCUIApplication, iteration: Int) {
        let homeButton = app.buttons["AppChrome.SearchHomeButton"]
        XCTAssertTrue(
            homeButton.waitForExistence(timeout: 2),
            "Search home button did not become tappable before iteration \(iteration)."
        )
        homeButton.tap()
        assertHomeVisible(in: app)
    }

    private func assertHomeVisible(in app: XCUIApplication) {
        XCTAssertTrue(app.staticTexts["Start speaking now"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["AppChrome.SearchButton"].waitForExistence(timeout: 2))
    }
}
