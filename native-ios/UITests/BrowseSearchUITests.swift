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

        openDock("Practice", in: app)
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
        XCTAssertTrue(app.buttons["BrowseCollection.CityFilter.hanoi.browse.landmarks"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.buttons["BrowseCollection.MessagesEntry.city.hanoi"].exists)
    }

    func testBrowsePracticeBackReturnsToCollectionPracticeFocus() {
        let app = launchApp(arguments: ["--browse-category", "first-day"])
        let practiceEntryID = "BrowseCollection.PracticeEntry.category.first-day"

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.first-day"].waitForExistence(timeout: 4))
        tapWhenComfortablyVisible(identifier: practiceEntryID, app: app)

        XCTAssertTrue(app.staticTexts["Match the pairs"].waitForExistence(timeout: 5))
        closePractice(app)
        XCTAssertTrue(app.descendants(matching: .any)["Practice.Match.Root"].waitForNonExistence(timeout: 4))

        XCTAssertTrue(app.descendants(matching: .any)["BrowseCollection.category.first-day"].waitForExistence(timeout: 4))
        let practiceEntry = app.buttons.matching(identifier: practiceEntryID).firstMatch
        XCTAssertTrue(practiceEntry.waitForExistence(timeout: 3))
        XCTAssertTrue(
            waitUntilHittable(practiceEntry, timeout: 3),
            "Back from Browse-launched practice should restore the collection near the practice entry that opened it."
        )
        XCTAssertFalse(app.descendants(matching: .any)["Practice.Match.Root"].exists)
    }

    func testBrowsePracticeOpensAsSheetOverCurrentCollection() {
        let app = launchApp(arguments: ["--browse-category", "first-day"])
        let practiceEntryID = "BrowseCollection.PracticeEntry.category.first-day"

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.first-day"].waitForExistence(timeout: 4))
        tapWhenComfortablyVisible(identifier: practiceEntryID, app: app)

        let roundTitle = app.staticTexts["Match the pairs"].firstMatch
        XCTAssertTrue(roundTitle.waitForExistence(timeout: 5))
        XCTAssertTrue(
            app.descendants(matching: .any)["BrowseCollection.category.first-day"].exists,
            "Practice should float over the current Browse collection instead of replacing it."
        )
        XCTAssertFalse(
            app.tabBars.firstMatch.exists && app.tabBars.firstMatch.isHittable,
            "Browse-launched practice should hide the bottom tab bar while the practice sheet is open."
        )
        XCTAssertFalse(
            app.descendants(matching: .any)["Practice.Match.Hub"].exists,
            "Browse-launched practice should skip the full Practice hub while opening a direct round."
        )

        closePractice(app)

        XCTAssertTrue(app.descendants(matching: .any)["Practice.Match.Root"].waitForNonExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.first-day"].waitForExistence(timeout: 3))
    }

    func testBrowsePracticeOverlayKeepsCollectionInPlaceThroughDismissal() {
        let app = launchApp(arguments: ["--browse-category", "first-day"])
        let practiceEntryID = "BrowseCollection.PracticeEntry.category.first-day"
        let roundTitle = app.staticTexts["Match the pairs"].firstMatch

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.first-day"].waitForExistence(timeout: 4))
        tapWhenComfortablyVisible(identifier: practiceEntryID, app: app)

        XCTAssertTrue(roundTitle.waitForExistence(timeout: 5))
        XCTAssertTrue(app.descendants(matching: .any)["BrowseCollection.category.first-day"].exists)

        closePractice(app)
        XCTAssertTrue(app.descendants(matching: .any)["Practice.Match.Root"].waitForNonExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.first-day"].waitForExistence(timeout: 4))

        let practiceEntry = app.buttons.matching(identifier: practiceEntryID).firstMatch
        XCTAssertTrue(practiceEntry.waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.first-day"].exists)
    }

    func testSavedPracticeOpensAsSheetOverSavedTrip() {
        let app = launchApp(arguments: ["--saved", "--reset-demo-state", "--seed-returning-user-shelves"])

        XCTAssertTrue(waitForSavedRoot(in: app, timeout: 8))
        let startPracticeText = app.staticTexts["Start Practicing"]
        XCTAssertTrue(startPracticeText.waitForExistence(timeout: 8))
        startPracticeText.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()

        XCTAssertTrue(app.staticTexts["Match the pairs"].waitForExistence(timeout: 5))
        XCTAssertTrue(savedRootExists(in: app))
        XCTAssertFalse(
            app.tabBars.firstMatch.exists && app.tabBars.firstMatch.isHittable,
            "Saved-launched practice should hide the bottom tab bar while the practice sheet is open."
        )
        XCTAssertFalse(
            app.descendants(matching: .any)["Practice.Match.Hub"].exists,
            "Saved-launched practice should skip the full Practice hub while opening a direct round."
        )

        closePractice(app)
        XCTAssertTrue(app.descendants(matching: .any)["Practice.Match.Root"].waitForNonExistence(timeout: 4))
        XCTAssertTrue(waitForSavedRoot(in: app, timeout: 4))
    }

    func testFoodCollectionUsesPracticeMomentsAfterNounRows() {
        let app = launchApp(arguments: ["--browse-category", "food"])
        let messageSection = app.descendants(matching: .any)["BrowseCollection.Messages.category.food"]

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.food"].waitForExistence(timeout: 4))
        scrollUntilExists(messageSection, app: app)

        XCTAssertTrue(messageSection.waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Practice moments"].exists)
        XCTAssertFalse(app.buttons["BrowseCollection.PracticeEntry.category.food"].exists)
    }

    func testFoodCollectionStartsWithCoffeeNounRows() {
        let app = launchApp(arguments: ["--browse-category", "food"])

        XCTAssertTrue(app.staticTexts["Eating Out"].waitForExistence(timeout: 4))
        let coffeeRow = app.buttons.matching(identifier: "BrowseCollection.Row.viet-phrase-coffee-2").firstMatch
        XCTAssertTrue(coffeeRow.waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["12 phrases"].exists)

        let placeRow = app.buttons.matching(identifier: "BrowseCollection.Row.viet-phrase-city-danang-place-nen").firstMatch
        if placeRow.exists {
            XCTAssertLessThan(coffeeRow.frame.minY, placeRow.frame.minY)
        }
    }

    func testVietnameseFoodMenuSectionRailScrollsToCategory() {
        let app = launchApp(arguments: ["--browse-category", "vietnamese-food-menu"])

        XCTAssertTrue(app.staticTexts["Food Menu"].waitForExistence(timeout: 4))
        let popularRail = app.buttons["VietnameseMenu.SectionRail.popular"]
        let scrollAnchor: XCUIElement
        if popularRail.waitForExistence(timeout: 2) {
            scrollAnchor = popularRail
        } else {
            scrollAnchor = app.buttons["VietnameseMenu.SectionRail.noodles-and-bowls"]
            XCTAssertTrue(scrollAnchor.waitForExistence(timeout: 2))
        }

        tapHorizontalCard(app.buttons["VietnameseMenu.SectionRail.noodles-and-bowls"], app: app, scrollAnchor: scrollAnchor)

        let sectionTitle = app.staticTexts["VietnameseMenu.SectionTitle.noodles-and-bowls"]
        XCTAssertTrue(sectionTitle.waitForExistence(timeout: 3))
        assertElementClearsTopAdminChrome(
            sectionTitle,
            app: app,
            message: "Food Menu section jumps should leave the section title below the top admin chrome."
        )
        XCTAssertTrue(app.buttons["VietnameseMenu.Row.food-pho-bo"].waitForExistence(timeout: 3))
    }

    func testVietnameseMenuSectionHeadersHideCountsAndHelperSubtitles() {
        let food = launchApp(arguments: ["--browse-category", "vietnamese-food-menu"])

        XCTAssertTrue(food.staticTexts["Food Menu"].waitForExistence(timeout: 4))
        tapHorizontalCard(food.buttons["VietnameseMenu.SectionRail.noodles-and-bowls"], app: food, scrollAnchor: food.buttons["VietnameseMenu.SectionRail.popular"])
        XCTAssertTrue(food.staticTexts["VietnameseMenu.SectionTitle.noodles-and-bowls"].waitForExistence(timeout: 3))
        XCTAssertFalse(food.staticTexts["26"].exists)
        XCTAssertFalse(food.staticTexts["48"].exists)
        food.terminate()

        let drinks = launchApp(arguments: ["--browse-category", "vietnamese-drink-menu"])

        XCTAssertTrue(drinks.staticTexts["Drink Menu"].waitForExistence(timeout: 4))
        tapHorizontalCard(drinks.buttons["VietnameseMenu.SectionRail.coffee"], app: drinks, scrollAnchor: drinks.buttons["VietnameseMenu.SectionRail.popular"])
        XCTAssertTrue(drinks.staticTexts["VietnameseMenu.SectionTitle.coffee"].waitForExistence(timeout: 3))
        XCTAssertFalse(drinks.staticTexts["14"].exists)
        XCTAssertFalse(drinks.staticTexts["iced, black, milk"].exists)
        drinks.terminate()
    }

    func testVietnameseMenuRowSaveAddsItemToSavedTrip() {
        let app = launchApp(arguments: ["--browse-category", "vietnamese-drink-menu", "--reset-demo-state"])

        XCTAssertTrue(app.staticTexts["Drink Menu"].waitForExistence(timeout: 4))
        tapHorizontalCard(
            app.buttons["VietnameseMenu.SectionRail.coffee"],
            app: app,
            scrollAnchor: app.buttons["VietnameseMenu.SectionRail.popular"]
        )
        XCTAssertTrue(app.staticTexts["VietnameseMenu.SectionTitle.coffee"].waitForExistence(timeout: 3))

        let saveButton = app.buttons["VietnameseMenu.Save.viet-menu-drink-ca-phe-sua-nong"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 3))
        tapWhenVisible(saveButton, app: app)
        XCTAssertEqual(saveButton.label, "Remove from Saved")

        openDock("Saved", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))

        let savedCoffee = app.buttons["SavedTrip.Row.viet-menu-drink-ca-phe-sua-nong"]
        scrollUntilHittable(savedCoffee, app: app)
        XCTAssertTrue(app.staticTexts["Cà phê sữa nóng"].exists)
        XCTAssertTrue(app.staticTexts["Hot Vietnamese milk coffee"].exists)
    }

    func testSavedTripUnsaveRemovesSavedMenuItem() {
        let pageID = "viet-menu-drink-ca-phe-sua-nong"
        let app = launchApp(arguments: ["--browse-category", "vietnamese-drink-menu", "--reset-demo-state"])

        XCTAssertTrue(app.staticTexts["Drink Menu"].waitForExistence(timeout: 4))
        tapHorizontalCard(
            app.buttons["VietnameseMenu.SectionRail.coffee"],
            app: app,
            scrollAnchor: app.buttons["VietnameseMenu.SectionRail.popular"]
        )
        XCTAssertTrue(app.staticTexts["VietnameseMenu.SectionTitle.coffee"].waitForExistence(timeout: 3))

        let menuSaveButton = app.buttons["VietnameseMenu.Save.\(pageID)"]
        XCTAssertTrue(menuSaveButton.waitForExistence(timeout: 3))
        tapWhenVisible(menuSaveButton, app: app)
        XCTAssertEqual(menuSaveButton.label, "Remove from Saved")

        openDock("Saved", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))

        let savedCoffee = app.buttons["SavedTrip.Row.\(pageID)"]
        scrollUntilHittable(savedCoffee, app: app)
        XCTAssertTrue(app.staticTexts["Cà phê sữa nóng"].exists)

        let unsaveButton = app.buttons["SavedTrip.Unsave.\(pageID)"]
        XCTAssertTrue(unsaveButton.waitForExistence(timeout: 2))
        tapWhenVisible(unsaveButton, app: app)

        XCTAssertTrue(savedCoffee.waitForNonExistence(timeout: 3))
        XCTAssertTrue(unsaveButton.waitForNonExistence(timeout: 3))
    }

    func testCityHeaderSaveAddsCityToSavedTrip() {
        let cityPageID = "browse-city-hoian"
        let app = launchApp(arguments: ["--browse-city", "hoian", "--reset-demo-state"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.hoian"].waitForExistence(timeout: 4))

        let saveButton = app.buttons["BrowseCollection.HeaderSave.\(cityPageID)"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 3))
        tapWhenVisible(saveButton, app: app)
        XCTAssertEqual(saveButton.label, "Remove from Saved")

        openDock("Saved", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))

        let savedCity = app.buttons["SavedTrip.Row.\(cityPageID)"]
        scrollUntilHittable(savedCity, app: app)
        XCTAssertTrue(app.staticTexts["Hoi An"].exists)
        XCTAssertTrue(
            app.staticTexts
                .matching(NSPredicate(format: "label CONTAINS[c] %@", "Ancient Town walks"))
                .firstMatch
                .exists
        )
    }

    func testVietnameseMenuTopSectionPillAppearsAfterInPageRailScrollsOff() {
        let app = launchApp(arguments: ["--browse-category", "vietnamese-food-menu"])

        XCTAssertTrue(app.staticTexts["Food Menu"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.descendants(matching: .any)["VietnameseMenu.TopSectionPill"].exists)

        for _ in 0..<4 where !app.descendants(matching: .any)["VietnameseMenu.TopSectionPill"].exists {
            app.swipeUp()
            RunLoop.current.run(until: Date().addingTimeInterval(0.18))
        }

        let sectionPill = app.descendants(matching: .any)["VietnameseMenu.TopSectionPill"]
        XCTAssertTrue(sectionPill.waitForExistence(timeout: 2))
        XCTAssertTrue(app.descendants(matching: .any)["TopAdmin.SpeedChip"].waitForExistence(timeout: 2))
        sectionPill.tap()

        let noodlesAndBowls = app.buttons["VietnameseMenu.TopSectionMenu.noodles-and-bowls"]
        if noodlesAndBowls.waitForExistence(timeout: 2) {
            noodlesAndBowls.tap()
        } else {
            app.buttons["Noodles & bowls"].tap()
        }

        XCTAssertTrue(app.staticTexts["VietnameseMenu.SectionTitle.noodles-and-bowls"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["VietnameseMenu.Row.food-pho-bo"].waitForExistence(timeout: 3))
    }

    func testVietnameseMenuTopSectionPillJumpsToSeafood() {
        let app = launchApp(arguments: ["--browse-category", "vietnamese-food-menu"])

        XCTAssertTrue(app.staticTexts["Food Menu"].waitForExistence(timeout: 4))

        for _ in 0..<4 where !app.descendants(matching: .any)["VietnameseMenu.TopSectionPill"].exists {
            app.swipeUp()
            RunLoop.current.run(until: Date().addingTimeInterval(0.18))
        }

        let sectionPill = app.descendants(matching: .any)["VietnameseMenu.TopSectionPill"]
        XCTAssertTrue(sectionPill.waitForExistence(timeout: 2))
        sectionPill.tap()

        let seafood = app.buttons["VietnameseMenu.TopSectionMenu.seafood"]
        if seafood.waitForExistence(timeout: 2) {
            seafood.tap()
        } else {
            app.buttons["Seafood"].tap()
        }

        XCTAssertTrue(app.staticTexts["VietnameseMenu.SectionTitle.seafood"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["VietnameseMenu.Row.food-ca-kho-to"].waitForExistence(timeout: 3))
    }

    func testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections() {
        let app = launchApp(arguments: ["--browse-category", "vietnamese-food-menu"])

        XCTAssertTrue(app.staticTexts["Food Menu"].waitForExistence(timeout: 4))

        let sectionPill = app.descendants(matching: .any)["VietnameseMenu.TopSectionPill"]
        for _ in 0..<4 where !sectionPill.exists {
            app.swipeUp()
            RunLoop.current.run(until: Date().addingTimeInterval(0.18))
        }
        XCTAssertTrue(sectionPill.waitForExistence(timeout: 2))

        sectionPill.tap()
        XCTAssertTrue(app.buttons["VietnameseMenu.TopSectionMenu.grilled-and-braised-meats"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.buttons["VietnameseMenu.TopSectionMenu.pork"].exists)
        XCTAssertFalse(app.buttons["VietnameseMenu.TopSectionMenu.beef-and-goat"].exists)
        app.buttons["VietnameseMenu.TopSectionMenu.noodles-and-bowls"].tap()
        XCTAssertTrue(waitForTopSectionPill(sectionPill, value: "Noodles & bowls", timeout: 3))

        assertVietnameseMenuTopSectionJump(
            in: app,
            sectionPill: sectionPill,
            sectionID: "seafood",
            sectionTitle: "Seafood",
            expectedRowID: "food-ca-kho-to"
        )
        assertVietnameseMenuTopSectionJump(
            in: app,
            sectionPill: sectionPill,
            sectionID: "grilled-and-braised-meats",
            sectionTitle: "Grilled & braised meats",
            expectedRowID: "food-thit-kho-trung"
        )
        assertVietnameseMenuTopSectionJump(
            in: app,
            sectionPill: sectionPill,
            sectionID: "soups-and-hot-pots",
            sectionTitle: "Soups & hot pots",
            expectedRowID: "food-bo-nhung-dam"
        )
    }

    func testVietnameseMenuTopSectionPillSurvivesSequentialBreakTest() {
        let app = launchApp(arguments: ["--browse-category", "vietnamese-food-menu"])

        XCTAssertTrue(app.staticTexts["Food Menu"].waitForExistence(timeout: 4))

        let sectionPill = app.descendants(matching: .any)["VietnameseMenu.TopSectionPill"]
        for _ in 0..<4 where !sectionPill.exists {
            app.swipeUp()
            RunLoop.current.run(until: Date().addingTimeInterval(0.18))
        }
        XCTAssertTrue(sectionPill.waitForExistence(timeout: 2))

        let targets: [(id: String, title: String, rowID: String)] = [
            ("popular", "Popular dishes", "food-pho-bo"),
            ("starters-and-snacks", "Starters & snacks", "food-goi-cuon"),
            ("noodles-and-bowls", "Noodles & bowls", "food-pho-bo"),
            ("rice-plates-and-clay-pots", "Rice plates & clay pots", "food-com-tam-suon"),
            ("banh-mi-and-buns", "Bánh mì & buns", "food-banh-mi-dac-biet"),
            ("seafood", "Seafood", "food-ca-kho-to"),
            ("grilled-and-braised-meats", "Grilled & braised meats", "food-thit-kho-trung"),
            ("soups-and-hot-pots", "Soups & hot pots", "food-bo-nhung-dam"),
            ("vegetarian-and-chay", "Vegetarian & chay", "food-pho-chay"),
            ("sweets", "Sweets", "food-che-ba-mau"),
        ]

        let startedAt = Date()
        for target in targets.dropFirst() {
            assertVietnameseMenuTopSectionJump(
                in: app,
                sectionPill: sectionPill,
                sectionID: target.id,
                sectionTitle: target.title,
                expectedRowID: target.rowID
            )
        }

        XCTAssertLessThan(
            Date().timeIntervalSince(startedAt),
            90,
            "Sequentially selecting every Food Menu section should remain responsive."
        )
    }

    func testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive() {
        let app = launchApp(arguments: ["--browse-category", "vietnamese-food-menu"])

        XCTAssertTrue(app.staticTexts["Food Menu"].waitForExistence(timeout: 4))

        let sectionPill = app.descendants(matching: .any)["VietnameseMenu.TopSectionPill"]
        let startedAt = Date()
        for _ in 0..<8 where !sectionPill.exists {
            fastSwipeUp(app)
            RunLoop.current.run(until: Date().addingTimeInterval(0.08))
        }
        XCTAssertLessThan(Date().timeIntervalSince(startedAt), 24)

        XCTAssertTrue(sectionPill.waitForExistence(timeout: 2))
        sectionPill.tap()

        let seafood = app.buttons["VietnameseMenu.TopSectionMenu.seafood"]
        if seafood.waitForExistence(timeout: 2) {
            seafood.tap()
        } else {
            app.buttons["Seafood"].tap()
        }

        XCTAssertTrue(app.staticTexts["VietnameseMenu.SectionTitle.seafood"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["VietnameseMenu.Row.food-ca-kho-to"].waitForExistence(timeout: 3))
    }

    func testVietnameseMenuDetailPhotoBackdropHidesAndRestoresContent() {
        assertPhotoBackdropHidesAndRestoresContent(
            pageID: "viet-menu-food-pho-dac-biet",
            title: "Phở đặc biệt",
            launchArguments: ["--detail-page", "viet-menu-food-pho-dac-biet"]
        )

        assertPhotoBackdropHidesAndRestoresContent(
            pageID: "viet-menu-drink-ca-phe-sua-da",
            title: "Cà phê sữa đá",
            launchArguments: ["--detail-page", "viet-menu-drink-ca-phe-sua-da"]
        )
    }

    func testCityNounDetailPhotoBackdropHidesAndRestoresContent() {
        assertPhotoBackdropHidesAndRestoresContent(
            pageID: "viet-phrase-city-danang-place-dragon-bridge",
            title: "Cầu Rồng",
            launchArguments: ["--detail-page", "viet-phrase-city-danang-place-dragon-bridge"]
        )
    }

    func testDetailHeroAndParagraphTextCanBeCopiedWithoutRootWideSelection() {
        assertVisibleTextOffersCopy(
            title: "Chào anh",
            launchArguments: ["--detail-page", "viet-phrase-hello-chao-anh"]
        )
        assertVisibleTextOffersCopy(
            title: "Cầu Rồng",
            launchArguments: ["--detail-page", "viet-phrase-city-danang-place-dragon-bridge"]
        )
        assertVisibleTextOffersCopy(
            title: "Phở bò",
            launchArguments: ["--detail-page", "viet-menu-food-pho-bo"]
        )
        assertVisibleTextOffersCopy(
            title: "Dragon Bridge is the landmark most visitors notice first: a dragon-shaped span over the Han River, bright at night, and useful for understanding how Da Nang's center connects toward the beach.",
            launchArguments: ["--detail-page", "viet-phrase-city-danang-place-dragon-bridge"]
        )
    }

    func testCityNounDetailPhotoBackdropImageTapTogglesImmersiveFromInitialPosition() {
        let pageID = "viet-phrase-city-danang-place-dragon-bridge"
        let app = launchApp(arguments: ["--detail-page", pageID])
        let content = app.descendants(matching: .any)["PhraseArticle.PhotoBackdrop.Content.\(pageID)"]

        XCTAssertTrue(app.staticTexts["Cầu Rồng"].waitForExistence(timeout: 4))
        XCTAssertTrue(content.waitForExistence(timeout: 2))

        tapCityNounHeroMasthead(app)
        XCTAssertTrue(content.waitForNonExistence(timeout: 2))

        tapCityNounHeroMasthead(app)
        XCTAssertTrue(content.waitForExistence(timeout: 2))
    }

    func testCityHubPhotoBackdropImageTapTogglesImmersiveFromInitialPosition() {
        let app = launchApp(arguments: ["--browse-city", "danang"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Browse by"].waitForExistence(timeout: 2))

        tapPhotoBackdropImage(app)
        XCTAssertTrue(app.staticTexts["Browse by"].waitForNonExistence(timeout: 2))

        tapPhotoBackdropImage(app)
        XCTAssertTrue(app.staticTexts["Browse by"].waitForExistence(timeout: 2))
    }

    func testVietnameseFoodMenuCategoryPhotoBackdropImageTapTogglesImmersiveFromInitialPosition() {
        let app = launchApp(arguments: ["--browse-category", "vietnamese-food-menu"])
        let content = app.descendants(matching: .any)["VietnameseMenu.PhotoBackdrop.Content.vietnamese-food-menu"]

        XCTAssertTrue(app.staticTexts["Food Menu"].waitForExistence(timeout: 4))
        XCTAssertTrue(content.waitForExistence(timeout: 3))

        tapPhotoBackdropImage(app)
        XCTAssertTrue(content.waitForNonExistence(timeout: 2))

        tapPhotoBackdropImage(app)
        XCTAssertTrue(content.waitForExistence(timeout: 2))
    }

    func testVietnameseDrinkMenuCategoryPhotoBackdropImageTapTogglesImmersiveFromInitialPosition() {
        let app = launchApp(arguments: ["--browse-category", "vietnamese-drink-menu"])
        let content = app.descendants(matching: .any)["VietnameseMenu.PhotoBackdrop.Content.vietnamese-drink-menu"]

        XCTAssertTrue(app.staticTexts["Drink Menu"].waitForExistence(timeout: 4))
        XCTAssertTrue(content.waitForExistence(timeout: 3))

        tapPhotoBackdropImage(app)
        XCTAssertTrue(content.waitForNonExistence(timeout: 2))

        tapPhotoBackdropImage(app)
        XCTAssertTrue(content.waitForExistence(timeout: 2))
    }

    func testVietnameseMenuDetailUsesMenuChipsInsteadOfBreakdownMath() {
        let app = launchApp(arguments: ["--detail-page", "viet-menu-food-pho-bo"])

        XCTAssertTrue(app.staticTexts["Phở bò"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["What it is"].waitForExistence(timeout: 2))
        for _ in 0..<6 where !app.staticTexts["MenuDetail.Chip.usually-includes.beef-broth"].exists {
            app.swipeUp()
        }

        XCTAssertTrue(app.staticTexts["MenuDetail.Chip.usually-includes.beef-broth"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["MenuDetail.Chip.usually-includes.rice-noodles"].exists)
        XCTAssertFalse(app.buttons["Breakdown.Audio.include-0-beef-broth"].exists)

        for _ in 0..<6 where !app.staticTexts["Worth knowing"].exists {
            app.swipeUp()
        }
        XCTAssertTrue(app.staticTexts["Worth knowing"].waitForExistence(timeout: 2))

        for _ in 0..<6 where !app.staticTexts["MenuDetail.Chip.common-options.less-spicy"].exists {
            app.swipeUp()
        }
        XCTAssertTrue(app.staticTexts["MenuDetail.Chip.common-options.less-spicy"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["MenuDetail.Chip.common-options.no-msg"].exists)
        XCTAssertFalse(app.buttons["Breakdown.Audio.option-0-extra-herbs"].exists)

        XCTAssertFalse(app.buttons["Breakdown.Audio.quick-say-0"].exists)
    }

    func testDaNangCityCollectionRendersTravelModeHub() {
        let app = launchApp(arguments: ["--browse-city", "danang"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Beach mornings, Han River nights, seafood markets, Son Tra, and central Vietnam day trips."].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Start here"].waitForExistence(timeout: 2))
        XCTAssertTrue(matchingStaticText(app: app, containing: "beach time").waitForExistence(timeout: 2))
        XCTAssertTrue(matchingStaticText(app: app, containing: "saved plans").waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Play phrase audio"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Browse by"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["BrowseCollection.CityFilter.danang.browse.landmarks"].waitForExistence(timeout: 2))
        tapWhenVisible(app.buttons["BrowseCollection.CityFilter.danang.browse.landmarks"], app: app)
        XCTAssertTrue(app.buttons["BrowseCollection.CityFilter.danang.browse.landmarks"].isSelected)
        XCTAssertTrue(app.descendants(matching: .any)["BrowseCollection.CityGroup.danang.browse.landmarks"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["Names to know"].exists)
        XCTAssertFalse(app.staticTexts["Browse Da Nang"].exists)
        XCTAssertFalse(app.staticTexts["Da Nang day"].exists)
        XCTAssertFalse(app.staticTexts["Common moments"].exists)
        XCTAssertFalse(app.staticTexts["Quick phrases"].exists)
        XCTAssertFalse(app.staticTexts["Say first"].exists)
        XCTAssertFalse(app.staticTexts["Start in Da Nang"].exists)
        XCTAssertFalse(app.staticTexts["City phrases in a quick practice loop."].exists)
    }

    func testDaNangCityRowSaveAddsItemToSavedTrip() {
        let app = launchApp(arguments: ["--browse-city", "danang", "--reset-demo-state"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 4))
        let landmarksFilter = app.buttons["BrowseCollection.CityFilter.danang.browse.landmarks"]
        XCTAssertTrue(landmarksFilter.waitForExistence(timeout: 2))
        tapWhenVisible(landmarksFilter, app: app)

        let pageID = "viet-phrase-city-danang-place-ba-na-hills"
        let saveButton = app.buttons["BrowseCollection.Save.\(pageID)"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 3))
        let landmarksGroup = app.descendants(matching: .any)["BrowseCollection.CityGroup.danang.browse.landmarks"]
        XCTAssertTrue(landmarksGroup.waitForExistence(timeout: 3))
        let cityCard = app.buttons["BrowseCollection.Row.\(pageID)"]
        scrollHorizontalCardUntilVisible(cityCard, app: app, scrollAnchor: landmarksGroup)
        tapVisibleCenter(of: saveButton, in: app)
        XCTAssertEqual(saveButton.label, "Remove from Saved")

        openDock("Saved", in: app)
        XCTAssertTrue(app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 3))

        let savedPlace = app.buttons["SavedTrip.Row.\(pageID)"]
        scrollUntilHittable(savedPlace, app: app)
        XCTAssertTrue(app.staticTexts["Bà Nà Hills"].exists)
        XCTAssertTrue(app.staticTexts["Ba Na Hills"].exists)
    }

    func testCityFilterSelectionStaysOnCollection() {
        let app = launchApp(arguments: ["--browse"])
        let filterID = "BrowseCollection.CityFilter.danang.browse.landmarks"

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))
        tapWhenComfortablyVisible(identifier: "Browse.City.danang", app: app)
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 5))
        tapWhenComfortablyVisible(identifier: filterID, app: app)
        XCTAssertTrue(app.buttons[filterID].isSelected)
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].exists)
        XCTAssertFalse(app.staticTexts["BrowseCollection.Title.category.getting-around"].exists)
    }

    func testBrowseCityCardNativeDissolveKeepsDestinationBodyMounted() {
        let app = launchApp(arguments: ["--browse"])

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))
        tapWhenComfortablyVisible(identifier: "Browse.City.danang", app: app)
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 3))
        XCTAssertTrue(
            app.staticTexts["Browse by"].waitForExistence(timeout: 0.2),
            "City-card native dissolve should mount the destination body immediately."
        )
    }

    func testCityBrowseCardSelectionJumpsToMatchingSection() {
        let app = launchApp(arguments: ["--browse-city", "danang"])
        let targetFilterID = "BrowseCollection.CityFilter.danang.browse.landmarks"
        let targetGroupID = "BrowseCollection.CityGroup.danang.browse.landmarks"

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 4))
        let targetFilter = app.buttons[targetFilterID]
        XCTAssertTrue(targetFilter.waitForExistence(timeout: 2))

        tapWhenComfortablyVisible(identifier: targetFilterID, app: app)
        RunLoop.current.run(until: Date().addingTimeInterval(0.45))

        XCTAssertTrue(targetFilter.isSelected)
        let targetGroup = app.descendants(matching: .any)[targetGroupID]
        XCTAssertTrue(targetGroup.waitForExistence(timeout: 2))
        XCTAssertTrue(
            targetGroup.frame.intersects(app.windows.firstMatch.frame),
            "Selecting a Browse by city card should jump down to its matching noun section."
        )
    }

    func testHoiAnBrowseByRestaurantCardJumpsToMatchingSection() {
        let app = launchApp(arguments: ["--browse-city", "hoian"])
        let targetFilterID = "BrowseCollection.CityFilter.hoian.browse.restaurants"
        let targetGroup = app.descendants(matching: .any)["BrowseCollection.CityGroup.hoian.browse.restaurants"]

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.hoian"].waitForExistence(timeout: 4))
        let targetFilter = app.buttons[targetFilterID]
        XCTAssertTrue(targetFilter.waitForExistence(timeout: 2))

        tapWhenComfortablyVisible(identifier: targetFilterID, app: app)
        RunLoop.current.run(until: Date().addingTimeInterval(0.45))

        XCTAssertTrue(targetFilter.isSelected)
        XCTAssertTrue(targetGroup.waitForExistence(timeout: 2))
        XCTAssertTrue(
            targetGroup.frame.intersects(app.windows.firstMatch.frame),
            "Selecting a Hoi An Browse by card should jump down to its matching noun section."
        )
        assertElementClearsTopAdminChrome(
            targetGroup,
            app: app,
            message: "Hoi An Browse by jumps should leave the noun-group label below the top admin chrome."
        )
    }

    func testCityBrowseCardJumpClearsTopAdminChrome() {
        let app = launchApp(arguments: ["--browse-city", "danang"])
        let targetFilterID = "BrowseCollection.CityFilter.danang.browse.landmarks"
        let targetGroup = app.descendants(matching: .any)["BrowseCollection.CityGroup.danang.browse.landmarks"]

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 4))
        tapWhenComfortablyVisible(identifier: targetFilterID, app: app)

        XCTAssertTrue(targetGroup.waitForExistence(timeout: 3))
        assertElementClearsTopAdminChrome(
            targetGroup,
            app: app,
            message: "City Browse by jumps should leave the noun-group label below the top admin chrome."
        )
    }

    func testBrowseCityTopSectionPillJumpsToNounGroup() {
        let app = launchApp(arguments: ["--browse-city", "danang"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 4))

        for _ in 0..<7 where !app.descendants(matching: .any)["BrowseCollection.TopSectionPill"].exists {
            app.swipeUp()
            RunLoop.current.run(until: Date().addingTimeInterval(0.18))
        }

        let sectionPill = app.descendants(matching: .any)["BrowseCollection.TopSectionPill"]
        XCTAssertTrue(sectionPill.waitForExistence(timeout: 2))
        XCTAssertTrue(app.descendants(matching: .any)["TopAdmin.SpeedChip"].waitForExistence(timeout: 2))
        sectionPill.tap()

        let restaurants = app.buttons["BrowseCollection.TopSectionMenu.danang.browse.restaurants"]
        if restaurants.waitForExistence(timeout: 2) {
            restaurants.tap()
        } else {
            app.buttons["Restaurants"].tap()
        }

        XCTAssertTrue(waitForTopSectionPill(sectionPill, value: "Restaurants", timeout: 3))
        XCTAssertTrue(app.descendants(matching: .any)["BrowseCollection.CityGroup.danang.browse.restaurants"].waitForExistence(timeout: 3))
    }

    func testCaptureBrowseCityHeroFadeProofForAllCityCards() {
        let app = launchApp(arguments: ["--browse"])

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))
        scrollUntilComfortablyVisible(app.buttons["Browse.City.danang"], app: app)
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

    func testBrowseCollectionTopSectionPillJumpsToAirportSubcategory() {
        let app = launchApp(arguments: ["--browse-category", "airport"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.descendants(matching: .any)["BrowseCollection.TopSectionPill"].exists)

        for _ in 0..<6 where !app.descendants(matching: .any)["BrowseCollection.TopSectionPill"].exists {
            app.swipeUp()
            RunLoop.current.run(until: Date().addingTimeInterval(0.18))
        }

        let sectionPill = app.descendants(matching: .any)["BrowseCollection.TopSectionPill"]
        XCTAssertTrue(sectionPill.waitForExistence(timeout: 2))
        XCTAssertTrue(app.descendants(matching: .any)["TopAdmin.SpeedChip"].waitForExistence(timeout: 2))
        sectionPill.tap()

        let simCard = app.buttons["BrowseCollection.TopSectionMenu.airport.sim-card"]
        if simCard.waitForExistence(timeout: 2) {
            simCard.tap()
        } else {
            app.buttons["SIM card"].tap()
        }

        XCTAssertTrue(waitForTopSectionPill(sectionPill, value: "SIM card", timeout: 3))
        XCTAssertTrue(app.staticTexts["SIM card phrases"].waitForExistence(timeout: 3))
        XCTAssertTrue(matchingStaticText(app: app, text: "SIM").waitForExistence(timeout: 2))
    }

    func testRepresentativeCategorySubcategoryJumpsClearTopAdminChrome() {
        let cases = [
            (
                routeID: "essentials",
                firstFilterID: "BrowseCollection.Subcategory.essentials.polite-basics",
                targetFilterID: "BrowseCollection.Subcategory.essentials.gratitude",
                sectionTitle: "Gratitude phrases"
            ),
            (
                routeID: "questions",
                firstFilterID: "BrowseCollection.Subcategory.questions.directions",
                targetFilterID: "BrowseCollection.Subcategory.questions.clarify",
                sectionTitle: "Clarify phrases"
            ),
        ]

        for testCase in cases {
            let app = launchApp(arguments: ["--browse-category", testCase.routeID])

            XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.\(testCase.routeID)"].waitForExistence(timeout: 4))
            let firstFilter = app.buttons[testCase.firstFilterID]
            XCTAssertTrue(firstFilter.waitForExistence(timeout: 2))

            tapHorizontalCard(
                app.buttons[testCase.targetFilterID],
                app: app,
                scrollAnchor: firstFilter
            )

            let sectionTitle = app.staticTexts[testCase.sectionTitle]
            XCTAssertTrue(sectionTitle.waitForExistence(timeout: 3))
            assertElementClearsTopAdminChrome(
                sectionTitle,
                app: app,
                message: "\(testCase.routeID) subcategory jumps should leave the section label below the top admin chrome."
            )

            app.terminate()
        }
    }

    func testAirportCollectionKeepsFirstSectionCloseToSubcategoryRail() {
        let app = launchApp(arguments: ["--browse-category", "airport"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 4))
        let arrivalFilter = app.buttons["BrowseCollection.Subcategory.airport.arrival"]
        let arrivalTitle = app.staticTexts["Arrival phrases"]

        XCTAssertTrue(arrivalFilter.waitForExistence(timeout: 3))
        XCTAssertTrue(arrivalTitle.waitForExistence(timeout: 3))
        XCTAssertLessThanOrEqual(
            arrivalTitle.frame.minY - arrivalFilter.frame.maxY,
            96,
            "The first phrase section should sit under the subcategory rail with normal section spacing, not a screen-sized blank gap."
        )
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
        let collectionTitle = app.staticTexts["BrowseCollection.Title.category.polite-repair"]
        for attempt in 0..<2 where !collectionTitle.exists {
            scrollUntilComfortablyVisible(lowerBrowseCard, app: app)
            lowerBrowseCard.tap()
            if !collectionTitle.waitForExistence(timeout: attempt == 0 ? 2 : 4) {
                app.swipeDown()
            }
        }

        XCTAssertTrue(collectionTitle.waitForExistence(timeout: 2))

        app.buttons["Go back"].tap()

        XCTAssertTrue(lowerBrowseCard.waitForExistence(timeout: 3))
        XCTAssertTrue(lowerBrowseCard.isHittable, "Back should return to the card area that opened the collection, not the top of Browse.")
        XCTAssertTrue(
            isVerticallyClearOfChrome(lowerBrowseCard, in: app),
            "Back should return the originating Browse card above the bottom chrome, not partially under it."
        )
    }

    func testFastDoubleBackFromBrowseDetailRestoresBrowseRootContent() {
        let app = launchApp(arguments: ["--browse"])

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))
        let lowerBrowseCard = app.buttons["Browse.PhraseFamily.polite-repair"]
        let collectionTitle = app.staticTexts["BrowseCollection.Title.category.polite-repair"]
        for attempt in 0..<2 where !collectionTitle.exists {
            scrollUntilComfortablyVisible(lowerBrowseCard, app: app)
            lowerBrowseCard.tap()
            if !collectionTitle.waitForExistence(timeout: attempt == 0 ? 2 : 4) {
                app.swipeDown()
            }
        }

        XCTAssertTrue(collectionTitle.waitForExistence(timeout: 2))
        let firstCollectionRow = app.buttons
            .matching(NSPredicate(format: "identifier BEGINSWITH %@", "BrowseCollection.Row."))
            .firstMatch
        scrollUntilHittable(firstCollectionRow, app: app)
        firstCollectionRow.tap()

        XCTAssertTrue(app.buttons["TopAdmin.BackButton"].waitForExistence(timeout: 4))
        XCTAssertFalse(collectionTitle.waitForExistence(timeout: 1))

        let backButton = app.buttons["TopAdmin.BackButton"]
        backButton.tap()
        RunLoop.current.run(until: Date().addingTimeInterval(0.12))
        if backButton.waitForExistence(timeout: 1) {
            backButton.tap()
        }

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))
        let topBrowseCard = app.buttons["Browse.Situation.hotel"]
        XCTAssertTrue(topBrowseCard.waitForExistence(timeout: 2))
        XCTAssertTrue(
            isVerticallyClearOfChrome(topBrowseCard, in: app),
            "Fast detail back/back should restore actual Browse content, not leave an empty photo sheet."
        )
        XCTAssertFalse(collectionTitle.exists)
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))
    }

    func testBackFromBrowseDetailRestoresBrowseRootContent() {
        let app = launchApp(arguments: ["--browse-category", "airport"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 4))
        let firstAirportRow = app.buttons["BrowseCollection.Row.viet-phrase-v900-airp-bord-arri-where-is-the-arrivals-hall"]
        XCTAssertTrue(firstAirportRow.waitForExistence(timeout: 3))
        firstAirportRow.tap()

        XCTAssertTrue(app.staticTexts["Where is the arrivals hall?"].waitForExistence(timeout: 4))
        app.buttons["TopAdmin.BackButton"].tap()
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 3))
        app.buttons["TopAdmin.BackButton"].tap()

        let hotelCard = app.staticTexts["Hotel"]
        XCTAssertTrue(hotelCard.waitForExistence(timeout: 3))
        XCTAssertTrue(
            isVerticallyClearOfChrome(hotelCard, in: app),
            "Back from detail through a Browse collection should restore visible Browse cards, not leave a blank photo sheet."
        )
        XCTAssertTrue(systemTabHost(in: app).waitForExistence(timeout: 2))
    }

    func testCaptureRepresentativeHeroImagesForProductionReview() {
        let pages: [(label: String, arguments: [String], title: String, requiredText: String)] = [
            ("saigon-city", ["--browse-city", "hcmc"], "Saigon", "Browse by"),
            ("greetings-category", ["--browse-category", "greetings"], "Greetings", "Simple ways to start speaking."),
            ("ben-thanh-market", ["--detail-page", "viet-family-city-hcmc-place-ben-thanh-market"], "Chợ Bến Thành", "The First Market Name To Know"),
            ("anan-saigon", ["--detail-page", "viet-family-city-hcmc-place-anan-saigon"], "Anăn Sài Gòn", "Modern Vietnamese Inside Market Streets"),
        ]

        for page in pages {
            let app = launchApp(arguments: page.arguments)

            XCTAssertTrue(app.staticTexts[page.title].waitForExistence(timeout: 8), "\(page.title) did not render.")
            XCTAssertTrue(matchingStaticText(app: app, text: page.requiredText).waitForExistence(timeout: 4), "\(page.requiredText) did not render on \(page.label).")
            captureHeroImageProofIfRequested(app: app, name: "\(page.label)-top.png")

            app.terminate()
        }
    }

    func testCaptureV22CityPageProductionProof() {
        let pages: [(label: String, pageID: String, title: String, heading: String, cardText: String)] = [
            (
                "01-danang-international-terminal",
                "viet-family-city-danang-place-international-terminal",
                "Nhà ga quốc tế Đà Nẵng",
                "Land, Then Find The Ride",
                "SIM card"
            ),
            (
                "02-danang-dong-dinh-museum",
                "viet-family-city-danang-place-dong-dinh-museum",
                "Bảo tàng Đồng Đình",
                "A Small Museum Under Trees",
                "Bán đảo Sơn Trà"
            ),
            (
                "03-hcmc-pasteur-street",
                "viet-family-city-hcmc-place-pasteur-street",
                "Đường Pasteur",
                "A Street Of Doorways",
                "Đến Quận 1"
            ),
            (
                "04-hanoi-loading-t-cafe",
                "viet-family-city-hanoi-place-loading-t-cafe",
                "Loading T Cafe",
                "Find The Upstairs Room",
                "Cà phê trứng"
            ),
            (
                "05-danang-lotte-mart",
                "viet-family-city-danang-place-lotte-mart",
                "Lotte Mart Đà Nẵng",
                "Cool Aisles, Easy Errands",
                "Sunscreen"
            ),
            (
                "06-danang-3d-art-in-paradise",
                "viet-family-city-danang-place-3d-art-in-paradise",
                "Bảo tàng 3D Art in Paradise Đà Nẵng",
                "Indoor 3D Photo Museum",
                "Bảo tàng Mỹ thuật Đà Nẵng"
            ),
            (
                "07-hanoi-bun-cha",
                "viet-family-city-hanoi-place-bun-cha",
                "Bún chả ở Hà Nội",
                "Smoke First, Then The Table",
                "Bún chả Hương Liên"
            ),
            (
                "08-hcmc-ben-thanh-market",
                "viet-family-city-hcmc-place-ben-thanh-market",
                "Chợ Bến Thành",
                "The First Market Name To Know",
                "Chợ An Đông"
            ),
            (
                "09-hue-bach-ma-national-park",
                "viet-family-city-hue-place-bach-ma-national-park",
                "Vườn quốc gia Bạch Mã",
                "Mountain Weather Leads",
                "Đầm Lập An"
            ),
            (
                "10-hoian-ancient-town-ticket-booth",
                "viet-family-city-hoian-place-ancient-town-ticket-booth",
                "Quầy vé phố cổ Hội An",
                "Ancient Town Ticket Booth",
                "Phố cổ Hội An"
            ),
        ]

        for page in pages {
            let app = launchApp(arguments: ["--detail-page", page.pageID])

            XCTAssertTrue(app.staticTexts[page.title].waitForExistence(timeout: 8), "\(page.title) did not render.")
            XCTAssertTrue(matchingStaticText(app: app, text: page.heading).waitForExistence(timeout: 4), "\(page.heading) did not render on \(page.label).")
            XCTAssertTrue(matchingStaticText(app: app, text: "Useful Phrases").waitForExistence(timeout: 4), "Useful Phrases did not render on \(page.label).")
            captureV22CityPageProof(app: app, name: "\(page.label)-top.png")

            smallSwipeUp(app)
            smallSwipeUp(app)
            captureV22CityPageProof(app: app, name: "\(page.label)-scrolled.png")

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

        let field = nativeSearchField(in: app)
        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 3))
        XCTAssertTrue(field.waitForExistence(timeout: 2))

        field.tap()
        field.typeText("taxi")

        XCTAssertTrue(app.staticTexts["Results for taxi"].waitForExistence(timeout: 3))
    }

    func testSearchTabDoesNotAutoFocusSystemSearchField() {
        let app = XCUIApplication()
        app.launch()

        openDock("Search", in: app)

        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 3))
        XCTAssertTrue(nativeSearchField(in: app).waitForExistence(timeout: 2))
        XCTAssertFalse(
            app.keyboards.firstMatch.waitForExistence(timeout: 0.5),
            "Tapping the bottom Search tab should open discovery/results without flashing keyboard focus."
        )
    }

    func testSearchTapOutsideFieldReturnsToDiscoveryContent() {
        let app = launchApp()
        openSearch(in: app)

        let field = searchField(in: app)
        XCTAssertTrue(field.waitForExistence(timeout: 3))
        field.tap()

        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Quick suggestions"].waitForExistence(timeout: 2))

        let title = app.staticTexts["Search.Title"]
        XCTAssertTrue(title.waitForExistence(timeout: 2))
        title.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()

        XCTAssertTrue(waitForKeyboardDismissal(in: app))
        XCTAssertTrue(app.staticTexts["Suggested needs"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["Quick suggestions"].exists)
    }

    func testSearchCloseButtonDismissesKeyboardWithoutLeavingSearch() {
        let app = launchApp()
        openSearch(in: app)

        let field = searchField(in: app)
        XCTAssertTrue(field.waitForExistence(timeout: 3))
        field.tap()

        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 2))
        tapSystemSearchCloseButton(near: field, in: app)

        XCTAssertTrue(waitForKeyboardDismissal(in: app))
        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Suggested needs"].waitForExistence(timeout: 2))
    }

    func testSearchQueryLaunchShowsResultsWithoutKeyboard() {
        let app = XCUIApplication()
        app.launchArguments = ["--search-query", "hotel"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Results for hotel"].waitForExistence(timeout: 4))
        XCTAssertEqual(app.keyboards.count, 0)
    }

    func testSearchQueryLaunchPrioritizesExactMenuDrinkResult() {
        let app = launchApp(arguments: ["--search-query", "Cà phê sữa đá"])
        let resultRows = searchResultRows(in: app)
        let firstResult = resultRows.firstMatch

        XCTAssertTrue(app.staticTexts["Results for Cà phê sữa đá"].waitForExistence(timeout: 4))
        XCTAssertTrue(firstResult.waitForExistence(timeout: 3))
        XCTAssertEqual(firstResult.identifier, "SearchResult.viet-menu-drink-ca-phe-sua-da")
    }

    func testSearchNeverFramesNoMatchAsExactPhraseSearch() {
        let app = launchApp(arguments: ["--search-query", "zzzzzz"])

        XCTAssertTrue(app.staticTexts["Search nearby phrases"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.staticTexts["No exact phrase yet"].exists)
    }

    func testSearchRecoveryCardsAndRelatedChipsStayInteractive() {
        var app = launchApp(arguments: ["--search-query", "zzzzzz"])

        XCTAssertTrue(app.staticTexts["Search nearby phrases"].waitForExistence(timeout: 4))
        tapWhenVisible(app.buttons["Search.Recovery.help"], app: app)

        XCTAssertTrue(app.buttons["TopAdmin.BackButton"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Break it down"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.staticTexts["Search nearby phrases"].exists)

        app.terminate()

        app = launchApp(arguments: ["--search-query", "hotel"])
        XCTAssertTrue(app.staticTexts["Results for hotel"].waitForExistence(timeout: 4))
        tapWhenVisible(app.buttons["Search.Filter.Categories"], app: app)
        XCTAssertTrue(app.staticTexts["Related searches"].waitForExistence(timeout: 3))

        let lateCheckoutChip = app.buttons["Search.Chip.late-checkout"]
        scrollUntilHittable(lateCheckoutChip, app: app)
        lateCheckoutChip.tap()

        XCTAssertTrue(app.staticTexts["Results for late checkout"].waitForExistence(timeout: 4))
        XCTAssertEqual(searchFieldValue(in: app), "late checkout")
    }

    func testSearchFieldUsesLoosePhrasebookResultsForNoisyKnownTokens() {
        let app = launchApp()
        openSearch(in: app)

        let field = searchField(in: app)
        XCTAssertTrue(field.waitForExistence(timeout: 4))
        field.tap()
        field.typeText("asdf bridge random")

        XCTAssertTrue(app.staticTexts["Results for asdf bridge random"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Dragon Bridge"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.staticTexts["No exact phrase yet"].exists)
    }

    func testSearchResultInteractionKeepsQueryVisibleInField() {
        let app = launchApp()
        openSearch(in: app)

        let field = searchField(in: app)
        XCTAssertTrue(field.waitForExistence(timeout: 4))
        field.tap()
        field.typeText("hotel")

        XCTAssertTrue(app.staticTexts["Results for hotel"].waitForExistence(timeout: 4))
        XCTAssertEqual(searchFieldValue(in: app), "hotel")

        app.staticTexts["Results for hotel"]
            .coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            .tap()

        XCTAssertTrue(app.staticTexts["Results for hotel"].waitForExistence(timeout: 3))
        XCTAssertEqual(
            searchFieldValue(in: app),
            "hotel",
            "Interacting with search results should dismiss typing focus without clearing or hiding the visible query."
        )
    }

    func testBackFromSearchResultRestoresResultScrollPosition() {
        let app = launchApp(arguments: ["--search-query", "hotel"])
        let resultRows = searchResultRows(in: app)
        let targetResult = resultRows.element(boundBy: 8)

        XCTAssertTrue(app.staticTexts["Results for hotel"].waitForExistence(timeout: 4))
        scrollUntilHittable(targetResult, app: app)
        let targetIdentifier = targetResult.identifier
        targetResult.tap()

        XCTAssertTrue(app.buttons["TopAdmin.BackButton"].waitForExistence(timeout: 4))
        tapWhenVisible(app.buttons["TopAdmin.BackButton"], app: app)

        XCTAssertTrue(app.staticTexts["Results for hotel"].waitForExistence(timeout: 3))
        XCTAssertTrue(
            waitUntilAnyButtonHittable(identifier: targetIdentifier, in: app, timeout: 4),
            "Back from a Search result should restore the Search results near the row that opened the detail page."
        )
        XCTAssertEqual(
            searchFieldValue(in: app),
            "hotel",
            "Back from a real Search result should preserve the visible query in the search field."
        )
    }

    func testProgressiveSearchTypingAndDeletingKeepsFieldResponsive() {
        let app = launchApp()
        openSearch(in: app)

        let field = searchField(in: app)

        XCTAssertTrue(field.waitForExistence(timeout: 4))
        field.tap()

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

    func testBrowseCompactSearchFocusesFieldForTyping() {
        let app = launchApp(arguments: ["--browse"])
        let startHere = app.staticTexts["Start here"]
        let phraseFamilies = app.staticTexts["Phrase families"]
        let compactSearch = app.buttons["Browse.CompactSearch"]

        scrollUntilExists(startHere, app: app)
        scrollUntilExists(phraseFamilies, app: app)
        scrollUntilExists(compactSearch, app: app)

        XCTAssertEqual(compactSearch.label, "Search")
        XCTAssertLessThan(startHere.frame.minY, phraseFamilies.frame.minY)
        XCTAssertLessThan(phraseFamilies.frame.minY, compactSearch.frame.minY)

        tapWhenVisible(compactSearch, app: app)

        let field = searchField(in: app)
        XCTAssertTrue(app.staticTexts["Search.Title"].waitForExistence(timeout: 3))
        XCTAssertTrue(field.waitForExistence(timeout: 2))

        field.tap()
        field.typeText("hotel")

        XCTAssertTrue(app.staticTexts["Results for hotel"].waitForExistence(timeout: 3))
    }

    func testFocusedSearchSuggestionKeepsKeyboardUsable() {
        let app = launchApp()
        openSearch(in: app)

        let field = searchField(in: app)
        XCTAssertTrue(field.waitForExistence(timeout: 3))
        field.tap()

        tapWhenVisible(app.buttons["Search.Chip.hotel"], app: app)

        XCTAssertTrue(app.staticTexts["Results for hotel"].waitForExistence(timeout: 3))

        searchField(in: app).tap()
        searchField(in: app).typeText(XCUIKeyboardKey.delete.rawValue)

        XCTAssertTrue(app.staticTexts["Results for hote"].waitForExistence(timeout: 3))
    }

    func testSearchFilterResetsWhenQueryChanges() {
        let app = launchApp(arguments: ["--search-query", "hanoi", "--search-focused"])

        let field = searchField(in: app)
        XCTAssertTrue(field.waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons["Search.Filter.Cities"].waitForExistence(timeout: 3))

        app.buttons["Search.Filter.Cities"].coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        field.tap()
        field.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 5))
        field.typeText("hotel")

        XCTAssertTrue(app.staticTexts["Results for hotel"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Search.Collection.category.hotel"].waitForExistence(timeout: 3))
    }

    private func launchApp(arguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = arguments
        app.launch()
        return app
    }

    private func waitForSavedRoot(in app: XCUIApplication, timeout: TimeInterval) -> Bool {
        let photoBackdropContent = app.descendants(matching: .any)["Saved.PhotoBackdrop.Content"]
        if photoBackdropContent.waitForExistence(timeout: timeout) {
            return true
        }

        return app.descendants(matching: .any)["SavedPagesView"].waitForExistence(timeout: 1)
    }

    private func savedRootExists(in app: XCUIApplication) -> Bool {
        app.descendants(matching: .any)["Saved.PhotoBackdrop.Content"].exists
            || app.descendants(matching: .any)["SavedPagesView"].exists
    }

    private func closePractice(_ app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        let closeButton = app.buttons["Close practice"].firstMatch
        XCTAssertTrue(closeButton.waitForExistence(timeout: 3), file: file, line: line)
        app.coordinate(
            withNormalizedOffset: CGVector(
                dx: closeButton.frame.midX / app.frame.width,
                dy: closeButton.frame.midY / app.frame.height
            )
        )
        .tap()
    }

    private func openSearch(in app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        openDock("Search", in: app, file: file, line: line)
    }

    private func openDock(_ title: String, in app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        let tab = systemTab(title, in: app)
        if tab.waitForExistence(timeout: 3), tab.isHittable {
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

    private func matchingStaticText(app: XCUIApplication, containing text: String) -> XCUIElement {
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", text)
        return app.staticTexts.matching(predicate).firstMatch
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
        case "Practice":
            normalizedX = 0.66
        case "Search":
            normalizedX = 0.82
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

    private func nativeSearchField(in app: XCUIApplication) -> XCUIElement {
        app.searchFields["Search Vietnamese phrases"]
    }

    private func searchFieldValue(in app: XCUIApplication) -> String {
        String(describing: searchField(in: app).value ?? "")
    }

    private func searchResultRows(in app: XCUIApplication) -> XCUIElementQuery {
        app.buttons.matching(
            NSPredicate(
                format: "identifier BEGINSWITH %@ AND NOT identifier BEGINSWITH %@",
                "SearchResult.",
                "SearchResult.Audio."
            )
        )
    }

    private func waitForKeyboardDismissal(in app: XCUIApplication, timeout: TimeInterval = 2) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if app.keyboards.count == 0 {
                return true
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        }
        return app.keyboards.count == 0
    }

    private func tapSystemSearchCloseButton(
        near field: XCUIElement,
        in app: XCUIApplication,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(field.exists, "Search field must exist before tapping the native close button.", file: file, line: line)

        let closeX = min(
            app.frame.maxX - 38,
            field.frame.maxX + max(44, (app.frame.maxX - field.frame.maxX) * 0.55)
        )
        let closeY = field.frame.midY
        app.coordinate(
            withNormalizedOffset: CGVector(
                dx: closeX / max(app.frame.width, 1),
                dy: closeY / max(app.frame.height, 1)
            )
        )
        .tap()
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

    private func assertPhotoBackdropHidesAndRestoresContent(
        pageID: String,
        title: String,
        launchArguments: [String],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let app = launchApp(arguments: launchArguments)
        let contentIdentifier = "PhraseArticle.PhotoBackdrop.Content.\(pageID)"
        let legacyLightboxButtonIdentifier = "PhraseArticle.HeroImageButton.\(pageID)"

        XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 4), file: file, line: line)
        XCTAssertFalse(app.buttons[legacyLightboxButtonIdentifier].exists, file: file, line: line)
        XCTAssertTrue(app.descendants(matching: .any)[contentIdentifier].waitForExistence(timeout: 3), file: file, line: line)
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 2), file: file, line: line)

        for _ in 0..<4 where app.descendants(matching: .any)[contentIdentifier].exists {
            app.swipeDown()
            RunLoop.current.run(until: Date().addingTimeInterval(0.55))
        }

        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.18)).tap()
        XCTAssertFalse(
            app.descendants(matching: .any)[contentIdentifier].waitForExistence(timeout: 1),
            "Photo backdrop content should hide in immersive mode.",
            file: file,
            line: line
        )
        XCTAssertFalse(tabBar.exists && tabBar.isHittable, "Photo backdrop immersive mode should hide the bottom admin bar.", file: file, line: line)

        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.18)).tap()
        XCTAssertTrue(
            app.descendants(matching: .any)[contentIdentifier].waitForExistence(timeout: 2),
            "Tapping the immersive photo should restore the content sheet.",
            file: file,
            line: line
        )
        XCTAssertTrue(tabBar.waitForExistence(timeout: 2), file: file, line: line)
        XCTAssertTrue(tabBar.isHittable, "Restoring the content sheet should restore the bottom admin bar.", file: file, line: line)

        for _ in 0..<2 {
            app.swipeDown()
            RunLoop.current.run(until: Date().addingTimeInterval(0.55))
        }
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.18)).tap()
        XCTAssertFalse(app.descendants(matching: .any)[contentIdentifier].waitForExistence(timeout: 1), file: file, line: line)
        XCTAssertFalse(tabBar.exists && tabBar.isHittable, "Photo backdrop immersive mode should hide the bottom admin bar.", file: file, line: line)
        app.swipeUp()
        XCTAssertTrue(
            app.descendants(matching: .any)[contentIdentifier].waitForExistence(timeout: 2),
            "Swiping upward should restore the content sheet.",
            file: file,
            line: line
        )
        XCTAssertTrue(tabBar.waitForExistence(timeout: 2), file: file, line: line)
        XCTAssertTrue(tabBar.isHittable, "Swiping upward should restore the bottom admin bar.", file: file, line: line)

        app.terminate()
    }

    private func assertVisibleTextOffersCopy(
        title: String,
        launchArguments: [String],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let app = launchApp(arguments: launchArguments)
        let text = visibleTextElement(title, in: app)

        XCTAssertTrue(text.waitForExistence(timeout: 5), "\(title) should render before checking copy affordance.", file: file, line: line)
        text.press(forDuration: 1.1)

        XCTAssertTrue(
            copyMenuItem(in: app).waitForExistence(timeout: 2),
            "Long-pressing \(title) should show the system Copy action.",
            file: file,
            line: line
        )

        app.terminate()
    }

    private func copyMenuItem(in app: XCUIApplication) -> XCUIElement {
        let menuItem = app.menuItems["Copy"]
        if menuItem.exists {
            return menuItem
        }

        return app.buttons["Copy"]
    }

    private func visibleTextElement(_ title: String, in app: XCUIApplication) -> XCUIElement {
        if title.count <= 128 {
            let staticText = app.staticTexts[title].firstMatch
            if staticText.exists {
                return staticText
            }
        }

        let exactPredicate = NSPredicate(format: "label == %@", title)
        let matchingTextView = app.textViews.matching(exactPredicate).firstMatch
        if matchingTextView.exists {
            return matchingTextView
        }

        let containsPredicate = NSPredicate(format: "label CONTAINS[c] %@", title)
        let textView = app.textViews.matching(containsPredicate).firstMatch
        if textView.exists {
            return textView
        }

        return app.descendants(matching: .any).matching(containsPredicate).firstMatch
    }

    private func tapCityNounHeroMasthead(_ app: XCUIApplication) {
        tapPhotoBackdropImage(app)
    }

    private func tapPhotoBackdropImage(_ app: XCUIApplication) {
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.88, dy: 0.18)).tap()
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

    private func fastSwipeUp(_ app: XCUIApplication) {
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.74))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.24))
        start.press(forDuration: 0.03, thenDragTo: end)
    }

    private func assertVietnameseMenuTopSectionJump(
        in app: XCUIApplication,
        sectionPill: XCUIElement,
        sectionID: String,
        sectionTitle: String,
        expectedRowID: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(sectionPill.waitForExistence(timeout: 2), file: file, line: line)
        sectionPill.tap()

        let menuButton = app.buttons["VietnameseMenu.TopSectionMenu.\(sectionID)"]
        if menuButton.waitForExistence(timeout: 2) {
            menuButton.tap()
        } else {
            app.buttons[sectionTitle].tap()
        }

        XCTAssertTrue(
            waitForTopSectionPill(sectionPill, value: sectionTitle, timeout: 3),
            "Top section pill should match the chosen \(sectionTitle) section.",
            file: file,
            line: line
        )
        XCTAssertTrue(
            app.staticTexts["VietnameseMenu.SectionTitle.\(sectionID)"].waitForExistence(timeout: 3),
            file: file,
            line: line
        )
        XCTAssertTrue(
            app.buttons["VietnameseMenu.Row.\(expectedRowID)"].waitForExistence(timeout: 3),
            file: file,
            line: line
        )
    }

    private func waitForTopSectionPill(_ sectionPill: XCUIElement, value: String, timeout: TimeInterval) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)

        while Date() < deadline {
            if sectionPill.exists, sectionPill.value as? String == value {
                return true
            }

            RunLoop.current.run(until: Date().addingTimeInterval(0.05))
        }

        return false
    }

    private func edgeSwipeBack(_ app: XCUIApplication) {
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.5))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.62, dy: 0.5))
        start.press(forDuration: 0.05, thenDragTo: end)
    }

    private func edgeSwipeForward(_ app: XCUIApplication) {
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.5))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.38, dy: 0.5))
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

    private func scrollUntilExists(_ element: XCUIElement, app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        for _ in 0..<8 {
            if element.waitForExistence(timeout: 1) {
                return
            }
            app.swipeUp()
        }

        XCTFail("Element did not exist after scrolling: \(element)", file: file, line: line)
    }

    private func waitUntilHittable(_ element: XCUIElement, timeout: TimeInterval) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)

        while Date() < deadline {
            if element.exists, element.isHittable {
                return true
            }

            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        }

        return element.exists && element.isHittable
    }

    private func waitUntilAnyButtonHittable(identifier: String, in app: XCUIApplication, timeout: TimeInterval) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        let matches = app.buttons.matching(NSPredicate(format: "identifier == %@", identifier))

        while Date() < deadline {
            if matches.allElementsBoundByIndex.contains(where: { $0.exists && $0.isHittable }) {
                return true
            }

            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        }

        return matches.allElementsBoundByIndex.contains(where: { $0.exists && $0.isHittable })
    }

    private func scrollUntilComfortablyVisible(_ element: XCUIElement, app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        for _ in 0..<10 {
            if element.waitForExistence(timeout: 1),
               isComfortablyVisible(element, in: app),
               isVerticallyClearOfChrome(element, in: app) {
                return
            }

            if element.exists {
                let appFrame = app.windows.firstMatch.frame
                let frame = element.frame
                if frame.minY >= appFrame.maxY - 140 {
                    smallSwipeUp(app)
                    continue
                }
                if frame.maxY <= appFrame.minY + 120 {
                    app.swipeDown()
                    continue
                }
            }

            smallSwipeUp(app)
        }

        XCTFail("Element was not comfortably visible: \(element)", file: file, line: line)
    }

    private func isVerticallyClearOfChrome(_ element: XCUIElement, in app: XCUIApplication) -> Bool {
        let frame = element.frame
        let appFrame = app.windows.firstMatch.frame

        guard !frame.isNull, !frame.isInfinite, !frame.isEmpty else {
            return false
        }

        return frame.minY >= appFrame.minY + 24
            && frame.maxY <= appFrame.maxY - 140
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
                if isComfortablyVisible(element, in: app) || hasUsableVisibleTapFrame(element, in: app) {
                    tapVisibleCenter(of: element, in: app)
                    return
                }
            }

            let appFrame = app.windows.firstMatch.frame
            let anchorFrame: CGRect
            if let scrollAnchor, scrollAnchor.exists {
                anchorFrame = scrollAnchor.frame
            } else {
                anchorFrame = .null
            }
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

    private func hasUsableVisibleTapFrame(_ element: XCUIElement, in app: XCUIApplication) -> Bool {
        let frame = element.frame
        let appFrame = app.windows.firstMatch.frame.insetBy(dx: 8, dy: 8)

        guard !frame.isNull, !frame.isInfinite, !frame.isEmpty else {
            return false
        }

        let visibleFrame = frame.intersection(appFrame)
        guard !visibleFrame.isNull, !visibleFrame.isEmpty else {
            return false
        }

        return visibleFrame.width >= min(72, frame.width * 0.45)
            && visibleFrame.height >= min(44, frame.height * 0.5)
    }

    private func tapVisibleCenter(of element: XCUIElement, in app: XCUIApplication) {
        let appFrame = app.windows.firstMatch.frame
        let visibleFrame = element.frame.intersection(appFrame)
        let tapFrame = visibleFrame.isNull || visibleFrame.isEmpty ? element.frame : visibleFrame
        app.coordinate(
            withNormalizedOffset: CGVector(
                dx: tapFrame.midX / max(appFrame.width, 1),
                dy: tapFrame.midY / max(appFrame.height, 1)
            )
        )
        .tap()
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

    private func assertElementClearsTopAdminChrome(
        _ element: XCUIElement,
        app: XCUIApplication,
        message: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let backButton = app.buttons["TopAdmin.BackButton"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 2), file: file, line: line)
        XCTAssertGreaterThan(
            element.frame.minY,
            backButton.frame.maxY + 16,
            message,
            file: file,
            line: line
        )
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

    private func captureV22CityPageProof(app: XCUIApplication, name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)

        let directory = ProcessInfo.processInfo.environment["SPEAKLOCAL_V22_CITY_PAGE_PROOF_DIR"]
            ?? "/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-pages/docs/design/city-pages/screenshots/v2-2-500-story-production-2026-05-27"

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
