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

    func testBrowseCategoryCardOpensCollectionAndBackReturnsToBrowse() {
        let app = launchApp(arguments: ["--browse"])

        tapWhenVisible(app.buttons["Browse.Situation.hotel"], app: app)

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.hotel"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["AppChrome.Dock.Browse"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["AppChrome.SearchButton"].waitForExistence(timeout: 2))

        app.buttons["Go back"].tap()

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
    }

    func testSearchCategoryResultHandsOffToBrowseCollection() {
        let app = launchApp(arguments: ["--search-query", "hotel"])

        tapWhenVisible(app.buttons["Search.Collection.category.hotel"], app: app)

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.hotel"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["AppChrome.Dock.Browse"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["Search.Title"].exists)
    }

    func testSearchCityResultHandsOffToBrowseCollection() {
        let app = launchApp(arguments: ["--search-query", "hanoi"])

        tapWhenVisible(app.buttons["Search.Collection.city.hanoi"], app: app)

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.hanoi"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["AppChrome.Dock.Browse"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["Search.Title"].exists)
    }

    func testCityCollectionPracticeEntryOpensPractice() {
        let app = launchApp(arguments: ["--browse-city", "hanoi"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.hanoi"].waitForExistence(timeout: 4))
        tapWhenVisible(app.buttons["BrowseCollection.Practice.city.hanoi"], app: app)

        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 5))
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

    private func launchApp(arguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = arguments
        app.launch()
        return app
    }

    private func tapWhenVisible(_ element: XCUIElement, app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        for _ in 0..<5 {
            if element.waitForExistence(timeout: 1), element.isHittable {
                element.tap()
                return
            }
            app.swipeUp()
        }

        XCTFail("Element was not hittable: \(element)", file: file, line: line)
    }
}
