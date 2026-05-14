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

    func testBrowseCityHeroTitlesShareTopAlignment() {
        let app = launchApp(arguments: ["--browse"])

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["Browse.City.hoian"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Browse.City.hcmc"].waitForExistence(timeout: 3))

        let hoiAnTitle = app.staticTexts["Hoi An"].firstMatch
        let saigonTitle = app.staticTexts["Saigon"].firstMatch

        XCTAssertTrue(hoiAnTitle.waitForExistence(timeout: 2))
        XCTAssertTrue(saigonTitle.waitForExistence(timeout: 2))
        XCTAssertEqual(
            hoiAnTitle.frame.minY,
            saigonTitle.frame.minY,
            accuracy: 2,
            "Browse city-card headings should start at the same height even when subtitle wrapping differs."
        )
    }

    func testBrowsePhraseFamilyCardsUseImageHeadlinesWithoutBodyCopy() {
        let app = launchApp(arguments: ["--browse"])

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))
        scrollUntilHittable(app.buttons["Browse.PhraseFamily.greetings"], app: app)

        XCTAssertTrue(app.buttons["Browse.PhraseFamily.greetings"].exists)
        XCTAssertTrue(app.buttons["Browse.PhraseFamily.questions"].exists)
        XCTAssertTrue(app.buttons["Browse.PhraseFamily.numbers-money"].exists)
        XCTAssertTrue(app.buttons["Browse.PhraseFamily.polite-repair"].exists)

        XCTAssertFalse(app.staticTexts["Say hello and start conversations."].exists)
        XCTAssertFalse(app.staticTexts["Ask for information with confidence."].exists)
        XCTAssertFalse(app.staticTexts["Count, pay, and handle prices."].exists)
        XCTAssertFalse(app.staticTexts["Ask people to repeat, slow down, write it, or use English."].exists)
        XCTAssertFalse(app.staticTexts["Alô"].exists)
    }

    func testBrowseCategoryCardOpensCollectionAndBackReturnsToBrowse() {
        let app = launchApp(arguments: ["--browse"])

        tapWhenVisible(app.buttons["Browse.Situation.hotel"], app: app)

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.hotel"].waitForExistence(timeout: 4))
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))

        app.buttons["Go back"].tap()

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 3))
    }

    func testAdminDetoursFromBrowseCollectionBackReturnToCollection() {
        var app = launchApp(arguments: ["--browse-category", "airport"])
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 4))

        openDock("Saved", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))

        tapWhenVisible(app.buttons["TopAdmin.BackButton"], app: app)
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 3))

        app.terminate()

        app = launchApp(arguments: ["--browse-category", "hotel"])
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.hotel"].waitForExistence(timeout: 4))

        openDock("Messages", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["PracticeView"].waitForExistence(timeout: 3))

        tapWhenVisible(app.buttons["TopAdmin.BackButton"], app: app)
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.hotel"].waitForExistence(timeout: 3))
    }

    func testSearchCategoryResultHandsOffToBrowseCollection() {
        let app = launchApp(arguments: ["--search-query", "hotel"])

        tapWhenVisible(app.buttons["Search.Collection.category.hotel"], app: app)

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.hotel"].waitForExistence(timeout: 4))
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["Search.Title"].exists)
    }

    func testBackFromSearchReturnsToBrowseCollection() {
        let app = launchApp(arguments: ["--browse-category", "hotel"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.hotel"].waitForExistence(timeout: 4))

        openSearch(in: app)
        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 3))

        tapWhenVisible(app.buttons["TopAdmin.BackButton"], app: app)

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.hotel"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.staticTexts["Browse.Title"].exists)
    }

    func testSearchCityResultHandsOffToBrowseCollection() {
        let app = launchApp(arguments: ["--search-query", "hanoi"])

        tapWhenVisible(app.buttons["Search.Collection.city.hanoi"], app: app)

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.hanoi"].waitForExistence(timeout: 4))
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["Search.Title"].exists)
    }

    func testCityCollectionHidesMessageEntry() {
        let app = launchApp(arguments: ["--browse-city", "hanoi"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.hanoi"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Browse by"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["BrowseCollection.CityFilter.all"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.buttons["BrowseCollection.MessagesEntry.city.hanoi"].exists)
    }

    func testBrowseMessageThreadBackReturnsToCollectionMessageFocus() {
        let app = launchApp(arguments: ["--browse-category", "airport"])
        let scenarioID = "BrowseCollection.Message.Contact.danangFirstDay"

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 4))
        tapWhenComfortablyVisible(identifier: scenarioID, app: app)

        XCTAssertTrue(app.descendants(matching: .any)["Practice.Messages.Thread"].waitForExistence(timeout: 5))
        tapWhenVisible(app.buttons["Practice.Messages.Back"], app: app)

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 4))
        let messageContact = app.buttons.matching(identifier: scenarioID).firstMatch
        XCTAssertTrue(messageContact.waitForExistence(timeout: 3))
        XCTAssertTrue(
            messageContact.isHittable,
            "Back from a Browse-launched message should restore the Airport page near the message contact that opened it."
        )
        XCTAssertFalse(app.descendants(matching: .any)["Practice.Messages.Thread"].exists)
    }

    func testBrowseMessageThreadEdgeSwipesBackAndForwardToSameThread() {
        let app = launchApp(arguments: ["--browse-category", "airport", "--reset-practice-message-threads"])
        let scenarioID = "BrowseCollection.Message.Contact.airportWifiPower"
        let thread = app.descendants(matching: .any)["Practice.Messages.Thread"]

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 4))
        tapWhenComfortablyVisible(identifier: scenarioID, app: app)

        XCTAssertTrue(thread.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Airport Wi-Fi"].waitForExistence(timeout: 4))

        edgeSwipeBack(app)

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 4))
        XCTAssertTrue(thread.waitForNonExistence(timeout: 4))

        let messageContact = app.buttons.matching(identifier: scenarioID).firstMatch
        XCTAssertTrue(messageContact.waitForExistence(timeout: 3))
        XCTAssertTrue(
            messageContact.isHittable,
            "Back swipe from Airport Wi-Fi should restore the Airport page near the exact message contact."
        )

        edgeSwipeForward(app)

        XCTAssertTrue(thread.waitForExistence(timeout: 5))
        XCTAssertTrue(
            app.staticTexts["Airport Wi-Fi"].waitForExistence(timeout: 4),
            "Forward swipe should reopen the Airport Wi-Fi thread, not the generic Messages hub."
        )
    }

    func testFoodMessageSectionUsesQuickConversationsLabel() {
        let app = launchApp(arguments: ["--browse-category", "food"])
        let scenarioID = "BrowseCollection.Message.Contact.foodAllergyHelp"

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.food"].waitForExistence(timeout: 4))
        scrollUntilHittable(app.buttons[scenarioID], app: app)

        XCTAssertTrue(app.staticTexts["Quick conversations"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["Food"].isHittable, "Food is the message-system grouping; the Browse section should explain the row content.")
    }

    func testFoodCollectionStartsWithCoffeeNounRows() {
        let app = launchApp(arguments: ["--browse-category", "food"])

        XCTAssertTrue(app.staticTexts["Food & coffee"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Coffee, dishes, and drinks"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Local dishes"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Order & adjust"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Black coffee, milk coffee, tea, and water"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Cà phê đen"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Black coffee"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["BrowseCollection.Row.viet-phrase-coffee-2"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["12 phrases"].exists)
        XCTAssertFalse(app.buttons["BrowseCollection.Row.viet-phrase-city-danang-place-nen"].exists)
    }

    func testVietnameseMenuDetailHeroImageOpensLightbox() {
        let app = launchApp(arguments: ["--detail-page", "viet-menu-food-pho-bo"])

        XCTAssertTrue(app.staticTexts["Phở bò"].waitForExistence(timeout: 4))
        tapWhenVisible(app.buttons["PhraseArticle.HeroImageButton.viet-menu-food-pho-bo"], app: app)

        XCTAssertTrue(app.images["PhraseArticle.HeroImageLightbox.Image.viet-menu-food-pho-bo"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["PhraseArticle.HeroImageLightbox.Close"].exists)

        tapWhenVisible(app.buttons["PhraseArticle.HeroImageLightbox.Close"], app: app)
        XCTAssertFalse(app.images["PhraseArticle.HeroImageLightbox.Image.viet-menu-food-pho-bo"].waitForExistence(timeout: 1))
    }

    func testDaNangCityCollectionRendersTravelModeHub() {
        let app = launchApp(arguments: ["--browse-city", "danang"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Airport arrivals, beach rides, river landmarks, markets, and day trips."].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Play phrase audio"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Browse by"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["BrowseCollection.CityFilter.all"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["BrowseCollection.CityFilter.danang.browse.arrivals"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["BrowseCollection.CityFilter.danang.browse.landmarks"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["BrowseCollection.CityFilter.danang.browse.streets"].waitForExistence(timeout: 2))
        tapWhenVisible(app.buttons["BrowseCollection.CityFilter.danang.browse.landmarks"], app: app)
        XCTAssertTrue(app.buttons["BrowseCollection.CityFilter.danang.browse.landmarks"].isSelected)
        XCTAssertFalse(app.buttons["BrowseCollection.Row.viet-phrase-city-danang-place-airport"].exists)
        XCTAssertFalse(app.staticTexts["Names to know"].exists)
        XCTAssertFalse(app.staticTexts["Browse Da Nang"].exists)
        XCTAssertFalse(app.staticTexts["Da Nang day"].exists)
        XCTAssertFalse(app.staticTexts["Common moments"].exists)
        XCTAssertFalse(app.staticTexts["Quick phrases"].exists)
        XCTAssertFalse(app.staticTexts["Start in Da Nang"].exists)
        XCTAssertFalse(app.staticTexts["City phrases in a quick practice loop."].exists)
    }

    func testCityFilterSelectionStaysOnCollection() {
        let app = launchApp(arguments: ["--browse"])
        let filterID = "BrowseCollection.CityFilter.danang.browse.landmarks"

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))
        tapWhenVisible(app.buttons["Browse.City.danang"], app: app)
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 4))
        tapWhenComfortablyVisible(identifier: filterID, app: app)
        XCTAssertTrue(app.buttons[filterID].isSelected)
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].exists)
        XCTAssertFalse(app.staticTexts["BrowseCollection.Title.category.getting-around"].exists)
    }

    func testCityFilterSelectionKeepsBrowseByStableAndPromotesSelectedPill() {
        let app = launchApp(arguments: ["--browse-city", "danang"])
        let targetFilterID = "BrowseCollection.CityFilter.danang.browse.landmarks"

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 4))
        let browseByTitle = app.staticTexts["Browse by"]
        let targetFilter = app.buttons[targetFilterID]
        XCTAssertTrue(browseByTitle.waitForExistence(timeout: 2))
        XCTAssertTrue(targetFilter.waitForExistence(timeout: 2))

        let stableBrowseByY = browseByTitle.frame.minY
        targetFilter.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        RunLoop.current.run(until: Date().addingTimeInterval(0.45))

        XCTAssertTrue(targetFilter.isSelected)
        XCTAssertEqual(
            browseByTitle.frame.minY,
            stableBrowseByY,
            accuracy: 3,
            "Changing city filters should not move the vertical Browse by section."
        )
        XCTAssertEqual(
            targetFilter.frame.minX,
            browseByTitle.frame.minX,
            accuracy: 24,
            "The selected city filter should animate to the leading filter position."
        )
    }

    func testCaptureBrowseCityHeroFadeProofForAllCityCards() {
        let app = launchApp(arguments: ["--browse"])

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))
        scrollUntilHittable(app.buttons["Browse.City.danang"], app: app)
        captureBrowseCityHeroFadeProofIfRequested(app: app, name: "city-rail-01-danang-hoian.png")

        let targets = [
            "Browse.City.hoian",
            "Browse.City.hcmc",
            "Browse.City.hanoi",
            "Browse.City.hue",
        ]

        var scrollAnchor = app.buttons["Browse.City.danang"]
        for (index, targetID) in targets.enumerated() {
            let target = app.buttons[targetID]
            scrollHorizontalCardUntilVisible(target, app: app, scrollAnchor: scrollAnchor)
            XCTAssertTrue(isComfortablyVisible(target, in: app), "\(targetID) should be comfortably visible for city hero fade review.")
            captureBrowseCityHeroFadeProofIfRequested(app: app, name: "city-rail-\(index + 2)-\(targetID.replacingOccurrences(of: "Browse.City.", with: "")).png")
            scrollAnchor = target
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
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))

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
            ("saigon-city", ["--browse-city", "hcmc"], "Saigon", "Browse by"),
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

    func testBrowseDoesNotRenderNextShelvesForReturningUsers() {
        let app = launchApp(arguments: ["--browse", "--seed-returning-user-shelves"])

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))

        let phraseFamilies = app.buttons["Browse.PhraseFamily.polite-repair"]
        scrollUntilHittable(phraseFamilies, app: app)

        XCTAssertFalse(app.staticTexts["Your next shelves"].exists)
        XCTAssertFalse(app.buttons["Browse.NextShelf.saved"].exists)
        XCTAssertFalse(app.buttons["Browse.NextShelf.practice"].exists)
        XCTAssertFalse(app.buttons["Browse.NextShelf.recent"].exists)
    }

    func testSearchTabOpensSystemSearchField() {
        let app = XCUIApplication()
        app.launch()

        openSearch(in: app)

        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 3))
        XCTAssertTrue(searchField(in: app).waitForExistence(timeout: 2))
    }

    func testSearchQueryLaunchShowsResultsWithoutKeyboard() {
        let app = XCUIApplication()
        app.launchArguments = ["--search-query", "hotel"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Results for hotel"].waitForExistence(timeout: 4))
        XCTAssertEqual(app.keyboards.count, 0)
    }

    func testProgressiveSearchTypingAndDeletingKeepsFieldResponsive() {
        let app = launchApp()
        openSearch(in: app)

        let field = searchField(in: app)

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

    private func openSearch(in app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        openDock("Search", in: app, file: file, line: line)
    }

    private func openDock(_ title: String, in app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        let tab = systemTab(title, in: app)
        if tab.waitForExistence(timeout: 3) {
            tab.tap()
        } else {
            systemTabCoordinate(title, in: app).tap()
        }
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

    private func edgeSwipeBack(_ app: XCUIApplication) {
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.5))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.38, dy: 0.5))
        start.press(forDuration: 0.05, thenDragTo: end)
    }

    private func edgeSwipeForward(_ app: XCUIApplication) {
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.5))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.62, dy: 0.5))
        start.press(forDuration: 0.05, thenDragTo: end)
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

    private func scrollHorizontalCardUntilVisible(_ element: XCUIElement, app: XCUIApplication, scrollAnchor: XCUIElement, file: StaticString = #filePath, line: UInt = #line) {
        for _ in 0..<8 {
            if element.waitForExistence(timeout: 1) {
                if isComfortablyVisible(element, in: app) {
                    return
                }
            }

            let appFrame = app.windows.firstMatch.frame
            let anchorFrame = scrollAnchor.frame
            let yOffset = max(0.08, min(0.92, anchorFrame.midY / appFrame.height))
            let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.88, dy: yOffset))
            let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.14, dy: yOffset))
            start.press(forDuration: 0.05, thenDragTo: end)
        }

        XCTFail("Horizontal card was not visible: \(element)", file: file, line: line)
    }

    private func isComfortablyVisible(_ element: XCUIElement, in app: XCUIApplication) -> Bool {
        let frame = element.frame
        let appFrame = app.windows.firstMatch.frame

        guard !frame.isNull, !frame.isInfinite, !frame.isEmpty else {
            return false
        }

        return frame.minX >= appFrame.minX + 8
            && frame.maxX <= appFrame.maxX - 8
            && frame.intersects(appFrame)
    }

    private func captureBrowseCityHeroFadeProofIfRequested(app: XCUIApplication, name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)

        guard let directory = ProcessInfo.processInfo.environment["SPEAKLOCAL_CITY_HERO_FADE_PROOF_DIR"], !directory.isEmpty else {
            return
        }

        let fileURL = URL(fileURLWithPath: directory)
            .appendingPathComponent(name)
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
