import XCTest

final class BackSwipeUITests: XCTestCase {
    func testEdgeSwipeReturnsFromChaoAnhToXinChao() {
        let app = XCUIApplication()
        app.launchArguments = ["--detail-page", "viet-hello-anh"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Hello, older brother / slightly older man"].isHittable)

        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.5))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.38, dy: 0.5))
        start.press(forDuration: 0.05, thenDragTo: end)

        let rootSubtitle = app.staticTexts["Hello (universal greeting)"]
        XCTAssertTrue(rootSubtitle.waitForExistence(timeout: 2))
        XCTAssertTrue(rootSubtitle.isHittable)
        XCTAssertFalse(app.staticTexts["Hello, older brother / slightly older man"].isHittable)
    }

    func testRightEdgeSwipeRestoresForwardPageAfterBackSwipe() {
        let app = XCUIApplication()
        app.launchArguments = ["--detail-page", "viet-hello-anh"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Chào anh"].waitForExistence(timeout: 5))

        let backStart = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.5))
        let backEnd = app.coordinate(withNormalizedOffset: CGVector(dx: 0.38, dy: 0.5))
        backStart.press(forDuration: 0.05, thenDragTo: backEnd)

        XCTAssertTrue(app.staticTexts["Hello (universal greeting)"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Go forward"].waitForExistence(timeout: 2))

        let forwardStart = app.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.5))
        let forwardEnd = app.coordinate(withNormalizedOffset: CGVector(dx: 0.62, dy: 0.5))
        forwardStart.press(forDuration: 0.05, thenDragTo: forwardEnd)

        XCTAssertTrue(app.staticTexts["Hello, older brother / slightly older man"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Hello, older brother / slightly older man"].isHittable)
    }

}
