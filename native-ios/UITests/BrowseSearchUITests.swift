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
        XCTAssertTrue(app.buttons["BrowseCollection.CityFilter.hanoi.browse.landmarks"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.buttons["BrowseCollection.MessagesEntry.city.hanoi"].exists)
    }

    func testBrowsePracticeBackReturnsToCollectionPracticeFocus() {
        let app = launchApp(arguments: ["--browse-category", "airport"])
        let practiceEntryID = "BrowseCollection.PracticeEntry.category.airport"

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 4))
        tapWhenComfortablyVisible(identifier: practiceEntryID, app: app)

        XCTAssertTrue(app.staticTexts["Match the pairs"].waitForExistence(timeout: 5))
        tapWhenVisible(app.buttons["Close practice"], app: app)
        XCTAssertTrue(app.staticTexts["Match the pairs"].waitForNonExistence(timeout: 4))

        XCTAssertTrue(app.descendants(matching: .any)["BrowseCollection.category.airport"].waitForExistence(timeout: 4))
        let practiceEntry = app.buttons.matching(identifier: practiceEntryID).firstMatch
        XCTAssertTrue(practiceEntry.waitForExistence(timeout: 3))
        XCTAssertTrue(
            waitUntilHittable(practiceEntry, timeout: 3),
            "Back from Browse-launched practice should restore the Airport page near the practice entry that opened it."
        )
        XCTAssertFalse(app.staticTexts["Match the pairs"].exists)
    }

    func testBrowsePracticeEdgeSwipesBackAndForwardToSameRound() {
        let app = launchApp(arguments: ["--browse-category", "airport"])
        let practiceEntryID = "BrowseCollection.PracticeEntry.category.airport"
        let roundTitle = app.staticTexts["Match the pairs"]

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 4))
        tapWhenComfortablyVisible(identifier: practiceEntryID, app: app)

        XCTAssertTrue(roundTitle.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Match the pairs"].waitForExistence(timeout: 4))

        edgeSwipeBack(app)

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.airport"].waitForExistence(timeout: 4))
        XCTAssertTrue(roundTitle.waitForNonExistence(timeout: 4))

        let practiceEntry = app.buttons.matching(identifier: practiceEntryID).firstMatch
        XCTAssertTrue(practiceEntry.waitForExistence(timeout: 3))
        XCTAssertTrue(
            waitUntilHittable(practiceEntry, timeout: 3),
            "Back swipe from Airport practice should restore the Airport page near the practice entry."
        )

        edgeSwipeForward(app)

        XCTAssertTrue(roundTitle.waitForExistence(timeout: 5))
        XCTAssertTrue(
            app.staticTexts["Match the pairs"].waitForExistence(timeout: 4),
            "Forward swipe should reopen the active practice round, not the generic Practice hub."
        )
    }

    func testFoodCollectionShowsPracticeEntryInsteadOfMessageSection() {
        let app = launchApp(arguments: ["--browse-category", "food"])
        let practiceEntryID = "BrowseCollection.PracticeEntry.category.food"

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.category.food"].waitForExistence(timeout: 4))
        scrollUntilHittable(app.buttons[practiceEntryID], app: app)

        XCTAssertTrue(app.buttons[practiceEntryID].waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["Quick conversations"].exists)
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
            scrollAnchor = app.buttons["VietnameseMenu.SectionRail.noodle-soups"]
            XCTAssertTrue(scrollAnchor.waitForExistence(timeout: 2))
        }

        tapHorizontalCard(app.buttons["VietnameseMenu.SectionRail.seafood"], app: app, scrollAnchor: scrollAnchor)

        XCTAssertTrue(app.staticTexts["VietnameseMenu.SectionTitle.seafood"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["VietnameseMenu.Row.food-ca-kho-to"].waitForExistence(timeout: 3))
    }

    func testVietnameseMenuSectionHeadersHideCountsAndHelperSubtitles() {
        let food = launchApp(arguments: ["--browse-category", "vietnamese-food-menu"])

        XCTAssertTrue(food.staticTexts["Food Menu"].waitForExistence(timeout: 4))
        tapHorizontalCard(food.buttons["VietnameseMenu.SectionRail.noodle-soups"], app: food, scrollAnchor: food.buttons["VietnameseMenu.SectionRail.popular"])
        XCTAssertTrue(food.staticTexts["VietnameseMenu.SectionTitle.noodle-soups"].waitForExistence(timeout: 3))
        XCTAssertFalse(food.staticTexts["26"].exists)
        XCTAssertFalse(food.staticTexts["phở, bún, mì"].exists)
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
        XCTAssertTrue(app.descendants(matching: .any)["PinnedAudioSpeedControl"].waitForExistence(timeout: 2))
        sectionPill.tap()

        let noodleSoups = app.buttons["VietnameseMenu.TopSectionMenu.noodle-soups"]
        if noodleSoups.waitForExistence(timeout: 2) {
            noodleSoups.tap()
        } else {
            app.buttons["Noodle soups"].tap()
        }

        XCTAssertTrue(app.staticTexts["VietnameseMenu.SectionTitle.noodle-soups"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["VietnameseMenu.Row.food-pho-bo"].waitForExistence(timeout: 3))
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

        for _ in 0..<6 where !app.staticTexts["Cho tôi một tô phở bò."].exists {
            app.swipeUp()
        }
        XCTAssertTrue(app.staticTexts["Cho tôi một tô phở bò."].waitForExistence(timeout: 2))
    }

    func testDaNangCityCollectionRendersTravelModeHub() {
        let app = launchApp(arguments: ["--browse-city", "danang"])

        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Beach roads, river bridges, markets, Son Tra, and easy central Vietnam day trips."].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Start here"].waitForExistence(timeout: 2))
        XCTAssertTrue(matchingStaticText(app: app, containing: "airport to beach").waitForExistence(timeout: 2))
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

    func testBrowseCityCardNativeDissolveKeepsDestinationBodyMounted() {
        let app = launchApp(arguments: ["--browse"])

        XCTAssertTrue(app.staticTexts["Browse.Title"].waitForExistence(timeout: 4))
        tapWhenVisible(app.buttons["Browse.City.danang"], app: app)
        XCTAssertTrue(app.staticTexts["BrowseCollection.Title.city.danang"].waitForExistence(timeout: 1))
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

    func testBackFromSearchResultRestoresResultScrollPosition() {
        let app = launchApp(arguments: ["--search-query", "hotel"])
        let resultRows = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "SearchResult."))
        let targetResult = resultRows.element(boundBy: 8)

        XCTAssertTrue(app.staticTexts["Results for hotel"].waitForExistence(timeout: 4))
        scrollUntilHittable(targetResult, app: app)
        let targetIdentifier = targetResult.identifier
        targetResult.tap()

        XCTAssertTrue(app.buttons["TopAdmin.BackButton"].waitForExistence(timeout: 4))
        tapWhenVisible(app.buttons["TopAdmin.BackButton"], app: app)

        XCTAssertTrue(app.staticTexts["Results for hotel"].waitForExistence(timeout: 3))
        let restoredResult = app.buttons[targetIdentifier]
        XCTAssertTrue(restoredResult.waitForExistence(timeout: 3))
        XCTAssertTrue(
            restoredResult.isHittable,
            "Back from a Search result should restore the Search results near the row that opened the detail page."
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

        tapWhenVisible(app.buttons["Browse.CompactSearch"], app: app)

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

        tapWhenVisible(app.buttons["Search.Prompt.hotel"], app: app)

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
        case "Messages":
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
                if isComfortablyVisible(element, in: app) {
                    element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
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
