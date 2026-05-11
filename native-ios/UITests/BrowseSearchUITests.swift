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

    func testAdminDetoursFromBrowseCollectionBackReturnToCollection() {
        var app = launchApp(arguments: ["--browse-category", "airport"])
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 4))

        tapWhenVisible(app.buttons["AppChrome.Dock.Saved"], app: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))

        tapWhenVisible(app.buttons["TopAdmin.BackButton"], app: app)
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 3))

        app.terminate()

        app = launchApp(arguments: ["--browse-category", "hotel"])
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.hotel"].waitForExistence(timeout: 4))

        tapWhenVisible(app.buttons["AppChrome.Dock.Messages"], app: app)
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))

        tapWhenVisible(app.buttons["TopAdmin.BackButton"], app: app)
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.hotel"].waitForExistence(timeout: 3))
    }

    func testSearchCategoryResultHandsOffToBrowseCollection() {
        let app = launchApp(arguments: ["--search-query", "hotel"])

        tapWhenVisible(app.buttons["Search.Collection.category.hotel"], app: app)

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.hotel"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["AppChrome.Dock.Browse"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["Search.Title"].exists)
    }

    func testSearchOriginFromBrowseCollectionReturnsToCollection() {
        let app = launchApp(arguments: ["--browse-category", "hotel"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.hotel"].waitForExistence(timeout: 4))

        tapWhenVisible(app.buttons["AppChrome.SearchButton"], app: app)
        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 3))

        tapWhenVisible(app.buttons["AppChrome.SearchOriginButton.Browse"], app: app)

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.hotel"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.staticTexts["Browse.Title"].exists)
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
        XCTAssertTrue(app.otherElements["BrowseCollection.CityNamePlayer.Da Nang"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Play phrase audio"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Names to know"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Browse Da Nang"].waitForExistence(timeout: 2))
        app.swipeUp()
        XCTAssertTrue(app.buttons["BrowseCollection.CityCard.danang.browse.landmarks"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Practice a Da Nang day"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Airport pickup, beach drop-off, food, and a ride back."].waitForExistence(timeout: 2))
        app.swipeUp()
        XCTAssertTrue(app.staticTexts["Common moments"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["BrowseCollection.CityCard.danang.situation.arriving"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["BrowseCollection.CityCard.danang.situation.beach-day"].waitForExistence(timeout: 2))
        app.swipeUp()
        XCTAssertTrue(app.staticTexts["Quick phrases"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["Start in Da Nang"].exists)
        XCTAssertFalse(app.staticTexts["City phrases in a quick practice loop."].exists)
    }

    func testBackFromCityQuickPhraseRowPreservesCollectionScrollPosition() {
        let app = launchApp(arguments: ["--browse"])
        let quickPhraseRowID = "BrowseCollection.Row.viet-phrase-city-danang-to-airport"

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))
        tapWhenVisible(app.buttons["Browse.City.danang"], app: app)
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 4))
        tapWhenComfortablyVisible(identifier: quickPhraseRowID, app: app)

        XCTAssertTrue(app.staticTexts["Cho tôi đến sân bay Đà Nẵng"].waitForExistence(timeout: 5))

        app.buttons["TopAdmin.BackButton"].tap()

        let quickPhraseRow = app.buttons.matching(identifier: quickPhraseRowID).firstMatch
        XCTAssertTrue(quickPhraseRow.waitForExistence(timeout: 3))
        XCTAssertTrue(quickPhraseRow.isHittable, "Back should restore the city collection near the row that opened the detail page.")
        XCTAssertFalse(app.staticTexts["BrowseCollection.Title.city.danang"].isHittable)
    }

    func testDaNangSituationCardsRevealCityRowsInsteadOfGenericCategoryPages() {
        let cards: [(id: String, sectionTitle: String, expectedRowID: String)] = [
            ("arriving", "Arriving in Da Nang", "BrowseCollection.Row.viet-phrase-city-danang-place-airport"),
            ("getting-around", "Getting around in Da Nang", "BrowseCollection.Row.viet-phrase-city-danang-place-nguyen-van-linh-street"),
            ("beach-day", "Beach day in Da Nang", "BrowseCollection.Row.viet-phrase-city-danang-place-my-khe"),
            ("food-coffee", "Food & coffee in Da Nang", "BrowseCollection.Row.viet-phrase-city-danang-place-nen"),
            ("places", "Places to visit in Da Nang", "BrowseCollection.Row.viet-phrase-city-danang-place-dragon-bridge"),
            ("help", "Help in Da Nang", "BrowseCollection.Row.viet-phrase-bath-1"),
        ]

        for card in cards {
            let app = launchApp(arguments: ["--browse-city", "danang"])
            XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 4))
            if card.id == "arriving" {
                captureCityHubFlowProofIfRequested(name: "danang-top", app: app)
            }

            tapWhenComfortablyVisible(
                identifier: "BrowseCollection.CityCard.danang.situation.\(card.id)",
                app: app
            )

            XCTAssertTrue(app.staticTexts[card.sectionTitle].waitForExistence(timeout: 3), "\(card.sectionTitle) did not appear after tapping \(card.id).")
            if ["arriving", "food-coffee", "places"].contains(card.id) {
                captureCityHubFlowProofIfRequested(name: "danang-\(card.id)-selected", app: app)
            }
            XCTAssertTrue(
                app.buttons.matching(identifier: card.expectedRowID).firstMatch.waitForExistence(timeout: 2),
                "\(card.expectedRowID) did not appear inside \(card.sectionTitle) after tapping \(card.id)."
            )
            XCTAssertFalse(app.staticTexts["BrowseCollection.Title.category.airport"].exists, "\(card.id) should not navigate out to the generic Airport page.")
            XCTAssertFalse(app.staticTexts["BrowseCollection.Title.category.getting-around"].exists, "\(card.id) should not navigate out to the generic Getting around page.")

            app.terminate()
        }
    }

    func testAirportSubcategoryCardsFilterVisibleRows() {
        let app = launchApp(arguments: ["--browse-category", "airport"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 4))
        let arrivalFilter = app.buttons["BrowseCollection.Subcategory.airport.arrival"]
        XCTAssertTrue(arrivalFilter.waitForExistence(timeout: 2))

        tapHorizontalCard(app.buttons["BrowseCollection.Subcategory.airport.sim-card"], app: app, scrollAnchor: arrivalFilter)

        XCTAssertTrue(app.staticTexts["SIM card phrases"].waitForExistence(timeout: 3))
        XCTAssertTrue(matchingStaticText(app: app, text: "SIM").waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["Good first phrases"].exists)
    }

    func testAirportArrivalFilterFromBrowseRemainsInteractive() {
        let app = launchApp(arguments: ["--browse"])

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))
        tapWhenVisible(app.buttons["Browse.Situation.airport"], app: app)

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 4))

        let arrivalFilter = app.buttons["BrowseCollection.Subcategory.airport.arrival"]
        XCTAssertTrue(arrivalFilter.waitForExistence(timeout: 2))
        arrivalFilter.tap()

        XCTAssertTrue(app.staticTexts["Arrival phrases"].waitForExistence(timeout: 3))

        app.swipeUp()
        XCTAssertTrue(app.buttons["AppChrome.Dock.Browse"].waitForExistence(timeout: 2))

        app.buttons["Go back"].tap()
        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Browse.Situation.airport"].waitForExistence(timeout: 2))
    }

    func testBackFromBrowseCollectionPreservesBrowseScrollPosition() {
        let app = launchApp(arguments: ["--browse"])

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))

        let lowerBrowseCard = app.buttons["Browse.PhraseFamily.polite-repair"]
        tapWhenComfortablyVisible(identifier: "Browse.PhraseFamily.polite-repair", app: app)

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.polite-repair"].waitForExistence(timeout: 4))

        app.buttons["Go back"].tap()

        XCTAssertTrue(lowerBrowseCard.waitForExistence(timeout: 3))
        XCTAssertTrue(lowerBrowseCard.isHittable, "Back should return to the card area that opened the collection, not the top of Browse.")
    }

    func testCaptureRepresentativeHeroImagesForProductionReview() {
        let pages: [(label: String, arguments: [String], title: String, requiredText: String)] = [
            ("saigon-city", ["--browse-city", "hcmc"], "Saigon", "Names to know"),
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
        let app = launchApp()
        let searchButton = app.buttons["AppChrome.SearchButton"]
        XCTAssertTrue(searchButton.waitForExistence(timeout: 4))
        searchButton.tap()

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

    private func tapWhenComfortablyVisible(identifier: String, app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        for _ in 0..<7 {
            let element = app.buttons.matching(identifier: identifier).firstMatch
            if element.waitForExistence(timeout: 1) {
                let appFrame = app.windows.firstMatch.frame
                let frame = element.frame
                let topAdminHitTestClearance: CGFloat = 206
                let bottomChromeCenterClearance: CGFloat = 120
                let topSafeY = appFrame.minY + topAdminHitTestClearance
                let bottomSafeY = appFrame.maxY - bottomChromeCenterClearance

                if frame.minY >= bottomSafeY {
                    smallSwipeUp(app)
                    continue
                }

                if frame.maxY <= topSafeY {
                    app.swipeDown()
                    continue
                }

                let safeTapY = min(
                    max(topSafeY + 8, frame.minY + frame.height * 0.28),
                    bottomSafeY - 8
                )
                let normalizedY = frame.height > 0 ? max(0.12, min(0.88, (safeTapY - frame.minY) / frame.height)) : 0.2
                element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: normalizedY)).tap()
                return
            }
            app.swipeUp()
        }

        XCTFail("Element was not comfortably tappable: \(identifier)", file: file, line: line)
    }

    private func smallSwipeUp(_ app: XCUIApplication) {
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.76))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.58))
        start.press(forDuration: 0.04, thenDragTo: end)
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

    private func captureCityHubFlowProofIfRequested(name: String, app: XCUIApplication) {
        let directory = ProcessInfo.processInfo.environment["SPEAKLOCAL_CITY_HUB_FLOW_PROOF_DIR"] ??
            "/Users/jojolim/Developer/products/speaklocal/app-family/docs/task-results/assets/city-hub-flow-qa"

        RunLoop.current.run(until: Date().addingTimeInterval(0.45))
        let url = URL(fileURLWithPath: directory).appendingPathComponent("\(name).png")
        try? FileManager.default.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: url)
    }

    private func tapHorizontalCard(_ element: XCUIElement, app: XCUIApplication, scrollAnchor: XCUIElement? = nil, file: StaticString = #filePath, line: UInt = #line) {
        for _ in 0..<6 {
            if element.waitForExistence(timeout: 1) {
                let frame = element.frame
                let appFrame = app.windows.firstMatch.frame

                if !frame.isNull, !frame.isInfinite, !frame.isEmpty, frame.intersects(appFrame) {
                    element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
                    return
                }
            }

            let appFrame = app.windows.firstMatch.frame
            let anchorFrame = scrollAnchor?.frame ?? .null
            let yOffset: CGFloat
            if !anchorFrame.isNull, !anchorFrame.isInfinite, !anchorFrame.isEmpty {
                yOffset = max(0.08, min(0.92, anchorFrame.midY / appFrame.height))
            } else {
                yOffset = 0.51
            }

            let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.88, dy: yOffset))
            let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.18, dy: yOffset))
            start.press(forDuration: 0.05, thenDragTo: end)
        }

        XCTFail("Horizontal card was not hittable: \(element)", file: file, line: line)
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
