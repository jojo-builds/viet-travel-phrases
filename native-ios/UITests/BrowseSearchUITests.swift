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

    func testDaNangCityCollectionRendersTravelModeHub() {
        let app = launchApp(arguments: ["--browse-city", "danang"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Airport arrivals, beach rides, river landmarks, markets, and day trips."].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["What are you doing?"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["BrowseCollection.CityCard.danang.situation.arriving"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["BrowseCollection.CityCard.danang.situation.beach-day"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Practice a Da Nang day"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Airport pickup, beach drop-off, food, and a ride back."].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Names to know"].waitForExistence(timeout: 2))
        app.swipeUp()
        XCTAssertTrue(app.staticTexts["Quick phrases"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Browse Da Nang"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["Start in Da Nang"].exists)
        XCTAssertFalse(app.staticTexts["City phrases in a quick practice loop."].exists)
    }

    func testCaptureRepresentativeHeroImagesForProductionReview() {
        let pages: [(label: String, arguments: [String], title: String, requiredText: String)] = [
            ("saigon-city", ["--browse-city", "hcmc"], "Saigon", "What are you doing?"),
            ("greetings-category", ["--browse-category", "greetings"], "Greetings", "Start here"),
            ("ben-thanh-market", ["--detail-page", "viet-family-city-hcmc-place-ben-thanh-market"], "Chợ Bến Thành", "About"),
            ("anan-saigon", ["--detail-page", "viet-family-city-hcmc-place-anan-saigon"], "Anăn Sài Gòn", "About"),
        ]

        for page in pages {
            let app = launchApp(arguments: page.arguments)

            XCTAssertTrue(app.staticTexts[page.title].waitForExistence(timeout: 8), "\(page.title) did not render.")
            XCTAssertTrue(matchingStaticText(app: app, text: page.requiredText).waitForExistence(timeout: 4), "\(page.requiredText) did not render on \(page.label).")
            captureHeroImageProofIfRequested(app: app, name: "\(page.label)-top.png")

            app.terminate()
        }
    }

    func testBrowseNextShelvesUseUniformCardFrames() {
        let app = launchApp(arguments: ["--browse", "--seed-returning-user-shelves"])

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))

        let savedRow = app.buttons["Browse.NextShelf.saved"]
        let practiceRow = app.buttons["Browse.NextShelf.practice"]
        let recentRow = app.buttons["Browse.NextShelf.recent"]

        scrollUntilHittable(recentRow, app: app)

        XCTAssertTrue(savedRow.exists)
        XCTAssertTrue(practiceRow.exists)
        XCTAssertTrue(recentRow.exists)

        let rowFrames = [savedRow.frame, practiceRow.frame, recentRow.frame]
        for frame in rowFrames {
            XCTAssertGreaterThan(frame.width, 300)
            XCTAssertEqual(frame.height, rowFrames[0].height, accuracy: 1)
            XCTAssertEqual(frame.width, rowFrames[0].width, accuracy: 1)
        }

        captureBrowseNextShelvesProofIfRequested()
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

    func testProgressiveSearchTypingAndDeletingKeepsFieldResponsive() {
        let app = launchApp(arguments: ["--search"])
        let field = app.textFields["AppChrome.SearchField"]

        XCTAssertTrue(field.waitForExistence(timeout: 4))
        field.tap()
        XCTAssertTrue(app.keyboards.element.waitForExistence(timeout: 3))

        for query in ["h", "ho", "hot", "hote", "hotel"] {
            field.typeText(String(query.last!))
            XCTAssertTrue(app.staticTexts["Results for \(query)"].waitForExistence(timeout: 3))
        }

        for query in ["hote", "hot", "ho", "h"] {
            field.typeText(XCUIKeyboardKey.delete.rawValue)
            XCTAssertTrue(app.staticTexts["Results for \(query)"].waitForExistence(timeout: 3))
        }

        field.typeText("a")
        XCTAssertTrue(app.staticTexts["Results for ha"].waitForExistence(timeout: 3))
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

    private func scrollUntilHittable(_ element: XCUIElement, app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        for _ in 0..<8 {
            if element.waitForExistence(timeout: 1), element.isHittable {
                return
            }
            app.swipeUp()
        }

        XCTFail("Element was not hittable: \(element)", file: file, line: line)
    }

    private func captureBrowseNextShelvesProofIfRequested() {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "browse-next-shelves-uniform"
        attachment.lifetime = .keepAlways
        add(attachment)

        guard let directory = ProcessInfo.processInfo.environment["SPEAKLOCAL_BROWSE_NEXT_SHELVES_PROOF_DIR"], !directory.isEmpty else {
            return
        }

        let fileURL = URL(fileURLWithPath: directory)
            .appendingPathComponent("browse-next-shelves-uniform.png")
        try? FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try? screenshot.pngRepresentation.write(to: fileURL)
    }

    private func captureHeroImageProofIfRequested(app: XCUIApplication, name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)

        let directory = ProcessInfo.processInfo.environment["SPEAKLOCAL_HERO_IMAGE_PROOF_DIR"]
            ?? "/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/artifacts/TASK-VIET-HERO-IMAGE-PRODUCTION-001"

        let fileURL = URL(fileURLWithPath: directory)
            .appendingPathComponent(name)
        try? FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try? screenshot.pngRepresentation.write(to: fileURL)
    }

    private func matchingStaticText(app: XCUIApplication, text: String) -> XCUIElement {
        let exact = app.staticTexts[text]
        if exact.exists {
            return exact
        }
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", text)
        return app.staticTexts.matching(predicate).firstMatch
    }
}
