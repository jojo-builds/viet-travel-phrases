import XCTest

final class BrowseSearchUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testBrowseLaunchShowsDedicatedBrowsePage() {
        let app = XCUIApplication()
        app.launchArguments = ["--browse"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Choose a real travel situation."].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Browse.Situation.hotel"].waitForExistence(timeout: 2))
    }

    func testSearchOpensWithoutKeyboardUntilFieldTap() {
        let app = XCUIApplication()
        app.launch()

        let searchButton = app.buttons["AppChrome.SearchButton"]
        XCTAssertTrue(searchButton.waitForExistence(timeout: 4))
        searchButton.tap()

        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.textFields["AppChrome.SearchField"].waitForExistence(timeout: 2))
        XCTAssertEqual(app.keyboards.count, 0)

        app.textFields["AppChrome.SearchField"].tap()
        XCTAssertTrue(app.keyboards.element.waitForExistence(timeout: 3))
    }

    func testSearchQueryLaunchShowsResultsWithoutKeyboard() {
        let app = XCUIApplication()
        app.launchArguments = ["--search-query", "hotel"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Results for hotel"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.textFields["AppChrome.SearchField"].waitForExistence(timeout: 2))
        XCTAssertEqual(app.keyboards.count, 0)
    }
}
