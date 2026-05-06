import XCTest

final class BackSwipeUITests: XCTestCase {
    func testEdgeSwipeReturnsFromDirectDetailToHome() {
        let app = XCUIApplication()
        app.launchArguments = ["--detail-page", "viet-hello-anh"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["AppChrome.Dock.Browse"].waitForExistence(timeout: 2))

        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.5))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.38, dy: 0.5))
        start.press(forDuration: 0.05, thenDragTo: end)

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.staticTexts["Hello, older brother / slightly older man"].isHittable)
        XCTAssertTrue(app.buttons["AppChrome.Dock.Home"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["AppChrome.SearchButton"].waitForExistence(timeout: 2))
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
        XCTAssertTrue(app.buttons["AppChrome.Dock.Browse"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["AppChrome.SearchButton"].waitForExistence(timeout: 2))
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
        XCTAssertTrue(app.buttons["AppChrome.Dock.Home"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["AppChrome.SearchButton"].waitForExistence(timeout: 2))

        app.buttons["AppChrome.SearchButton"].tap()

        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.textFields["AppChrome.SearchField"].waitForExistence(timeout: 2))
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

        app.buttons["Go back"].tap()

        XCTAssertTrue(app.descendants(matching: .any)["HomeView"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.staticTexts["Browse.Title"].exists)
        XCTAssertTrue(app.buttons["AppChrome.Dock.Home"].waitForExistence(timeout: 2))
    }
}
