import Foundation

enum BrowseCollectionRoute: Hashable, Equatable, Identifiable {
    case category(String)
    case city(String)

    var id: String {
        switch self {
        case .category(let id):
            return "category.\(id)"
        case .city(let id):
            return "city.\(id)"
        }
    }
}

struct BrowseCollectionFocusRequest: Equatable {
    static let messageSectionScrollTargetID = "BrowseCollection.MessageSection"
    static let practiceEntryScrollTargetID = "BrowseCollection.PracticeEntry"

    let id: Int
    let route: BrowseCollectionRoute
    let target: Target

    enum Target: Equatable {
        case messageScenario(PracticeScenarioID)
        case practiceEntry

        var scrollTargetID: String {
            switch self {
            case .messageScenario:
                return BrowseCollectionFocusRequest.messageSectionScrollTargetID
            case .practiceEntry:
                return BrowseCollectionFocusRequest.practiceEntryScrollTargetID
            }
        }
    }
}

enum BrowseCollectionPracticeAction: Equatable {
    case addStarterPages([String])
    case practiceSource(String)
    case practiceMode(PracticeMode)
    case practiceScenario(PracticeScenarioID)
}

struct BrowseSearchPhraseItem: Identifiable, Equatable {
    let pageID: String
    let title: String
    let subtitle: String
    let symbolName: String
    let tintName: AccentTint
    let audioKey: String?
    var imageName: String? = nil

    var id: String { pageID }

    static func resolve(pageID: String) -> BrowseSearchPhraseItem? {
        if let item = PhraseCatalog.catalogItem(forOpenablePageID: pageID) {
            let detailPage = PhraseDetailPage.page(withID: item.pageID)
            return BrowseSearchPhraseItem(
                pageID: item.pageID,
                title: item.title,
                subtitle: item.subtitle,
                symbolName: item.symbolName,
                tintName: item.tintName,
                audioKey: item.playbackAudioKey,
                imageName: detailPage?.heroImageName
            )
        }

        if pageID == PhrasePage.xinChao.id {
            return BrowseSearchPhraseItem(
                pageID: PhrasePage.xinChao.id,
                title: PhrasePage.xinChao.title,
                subtitle: PhrasePage.xinChao.intentSummary,
                symbolName: "hand.wave.fill",
                tintName: .red,
                audioKey: PhrasePage.xinChao.quickSay.first?.playbackAudioKey,
                imageName: PhrasePageStyle.heroImageName
            )
        }

        if let page = PhraseDetailPage.page(withID: pageID) {
            return BrowseSearchPhraseItem(
                pageID: page.id,
                title: page.title,
                subtitle: page.englishTitle,
                symbolName: page.iconName,
                tintName: page.tintName,
                audioKey: page.playbackAudioKey,
                imageName: page.heroImageName
            )
        }

        return nil
    }

    static func fromSearchResult(_ result: PhraseSearchResult) -> BrowseSearchPhraseItem {
        if let item = resolve(pageID: result.pageID) {
            return item
        }

        return BrowseSearchPhraseItem(
            pageID: result.pageID,
            title: result.title,
            subtitle: result.subtitle,
            symbolName: "doc.text.magnifyingglass",
            tintName: .blue,
            audioKey: nil,
            imageName: nil
        )
    }
}

private struct CitySituationCardSpec {
    let id: String
    let title: String
    let subtitle: String
    let symbolName: String
    let tintName: AccentTint
    var preferredPageIDs: [String] = []
    let subcategoryIDs: [String]
}

private struct CityBrowseGroupSpec {
    let id: String
    let title: String
    let subtitle: String
    let symbolName: String
    let placeKinds: Set<String>
}

struct BrowseDestination: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let categoryIDs: [String]
    let symbolName: String
    let tintName: AccentTint
    let sampleQuery: String
    var preferredPageIDs: [String] = []

    var openablePageID: String? {
        if let preferredPageID = preferredPageIDs.compactMap(PhraseCatalog.canonicalPageID(forOpenablePageID:)).first {
            return preferredPageID
        }

        return BrowseSearchDestinations.firstOpenablePageID(categoryIDs: categoryIDs)
    }

    var items: [BrowseSearchPhraseItem] {
        BrowseSearchDestinations.items(categoryIDs: categoryIDs, limit: 4)
    }

    var itemCount: Int {
        BrowseSearchDestinations.itemCount(categoryIDs: categoryIDs)
    }

    var collectionRoute: BrowseCollectionRoute {
        .category(id)
    }
}

struct BrowseCityShortcut: Identifiable, Equatable {
    let id: String
    let title: String
    let query: String
    let symbolName: String
    let tintName: AccentTint

    var collectionRoute: BrowseCollectionRoute {
        id == "all-vietnam" ? .category("city-guides") : .city(id)
    }
}

struct SearchPrompt: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let query: String
    let symbolName: String
    let tintName: AccentTint
    var pageID: String?
}

struct SearchRecoveryAction: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let highlight: String
    let symbolName: String
    let tintName: AccentTint
    let categoryIDs: [String]
    var preferredPageIDs: [String] = []

    var openablePageID: String? {
        if let preferredPageID = preferredPageIDs.compactMap(PhraseCatalog.canonicalPageID(forOpenablePageID:)).first {
            return preferredPageID
        }

        return BrowseSearchDestinations.firstOpenablePageID(categoryIDs: categoryIDs)
    }
}

struct BrowseCollectionSubcategory: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let symbolName: String
    let tintName: AccentTint
    let phraseCount: Int
    let countUnit: String
    let imageName: String?
    let items: [BrowseSearchPhraseItem]
    let targetRoute: BrowseCollectionRoute?

    init(
        id: String,
        title: String,
        subtitle: String,
        symbolName: String,
        tintName: AccentTint,
        phraseCount: Int,
        countUnit: String = "phrase",
        imageName: String? = nil,
        items: [BrowseSearchPhraseItem],
        targetRoute: BrowseCollectionRoute? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.symbolName = symbolName
        self.tintName = tintName
        self.phraseCount = phraseCount
        self.countUnit = countUnit
        self.imageName = imageName
        self.items = items
        self.targetRoute = targetRoute
    }
}

struct BrowseCityNameAudioItem: Equatable {
    let title: String
    let subtitle: String
    let audioKey: String?
    let tintName: AccentTint
}

struct BrowseCollectionShelf: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let items: [BrowseSearchPhraseItem]
    let itemGroups: [[BrowseSearchPhraseItem]]
    let targetRoute: BrowseCollectionRoute?

    init(
        id: String,
        title: String,
        subtitle: String,
        items: [BrowseSearchPhraseItem],
        targetRoute: BrowseCollectionRoute? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.items = items
        self.itemGroups = Self.groupItems(items)
        self.targetRoute = targetRoute
    }

    private static func groupItems(_ items: [BrowseSearchPhraseItem]) -> [[BrowseSearchPhraseItem]] {
        stride(from: 0, to: items.count, by: 3).map { startIndex in
            Array(items[startIndex..<Swift.min(startIndex + 3, items.count)])
        }
    }
}

struct BrowseCollectionDescriptor: Identifiable, Equatable {
    static let messageSectionDisplayTitle = "Quick conversations"

    let route: BrowseCollectionRoute
    let title: String
    let subtitle: String
    let eyebrow: String
    let mastheadImageName: String
    let symbolName: String
    let tintName: AccentTint
    let subcategories: [BrowseCollectionSubcategory]
    let starterTitle: String
    let starterItems: [BrowseSearchPhraseItem]
    let practiceTitle: String
    let practiceSubtitle: String
    let practiceAction: BrowseCollectionPracticeAction
    let messageSectionTitle: String?
    let exploreShelves: [BrowseCollectionShelf]
    let cityHub: BrowseCityHub?

    init(
        route: BrowseCollectionRoute,
        title: String,
        subtitle: String,
        eyebrow: String,
        mastheadImageName: String,
        symbolName: String,
        tintName: AccentTint,
        subcategories: [BrowseCollectionSubcategory],
        starterTitle: String,
        starterItems: [BrowseSearchPhraseItem],
        practiceTitle: String,
        practiceSubtitle: String,
        practiceAction: BrowseCollectionPracticeAction,
        messageSectionTitle: String? = nil,
        exploreShelves: [BrowseCollectionShelf],
        cityHub: BrowseCityHub? = nil
    ) {
        self.route = route
        self.title = title
        self.subtitle = subtitle
        self.eyebrow = eyebrow
        self.mastheadImageName = mastheadImageName
        self.symbolName = symbolName
        self.tintName = tintName
        self.subcategories = subcategories
        self.starterTitle = starterTitle
        self.starterItems = starterItems
        self.practiceTitle = practiceTitle
        self.practiceSubtitle = practiceSubtitle
        self.practiceAction = practiceAction
        self.messageSectionTitle = messageSectionTitle
        self.exploreShelves = exploreShelves
        self.cityHub = cityHub
    }

    var id: String { route.id }

    var browseMessageSectionTitle: String? {
        messageScenarioIDs.isEmpty ? nil : Self.messageSectionDisplayTitle
    }

    var messageScenarioIDs: [PracticeScenarioID] {
        guard let messageSectionTitle else {
            return []
        }

        return PracticeScenarioID.messageScenarioIDs(in: messageSectionTitle)
    }
}

struct BrowseCityHub: Equatable {
    let cityNameAudioItem: BrowseCityNameAudioItem?
    let introTitle: String
    let introText: String
    let situationTitle: String
    let situations: [BrowseCollectionSubcategory]
    let namesTitle: String
    let namesToKnowItems: [BrowseSearchPhraseItem]
    let quickPhrasesTitle: String
    let quickPhraseItems: [BrowseSearchPhraseItem]
    let browseTitle: String
    let browseGroups: [BrowseCollectionSubcategory]

    var cityBrowseFilters: [BrowseCollectionSubcategory] {
        Self.mergedCityFilters(from: browseGroups)
    }

    var cityBrowseAllItems: [BrowseSearchPhraseItem] {
        Self.uniquePhraseItems(cityBrowseFilters.flatMap(\.items))
    }

    private static func mergedCityFilters(from filters: [BrowseCollectionSubcategory]) -> [BrowseCollectionSubcategory] {
        var orderedKeys: [String] = []
        var mergedFilters: [String: BrowseCollectionSubcategory] = [:]

        for filter in filters where !filter.items.isEmpty {
            let key = cityFilterKey(for: filter)
            if let existing = mergedFilters[key] {
                let items = uniquePhraseItems(existing.items + filter.items)
                mergedFilters[key] = BrowseCollectionSubcategory(
                    id: existing.id,
                    title: existing.title,
                    subtitle: existing.subtitle,
                    symbolName: existing.symbolName,
                    tintName: existing.tintName,
                    phraseCount: max(existing.phraseCount, filter.phraseCount, items.count),
                    countUnit: existing.countUnit,
                    items: items,
                    targetRoute: existing.targetRoute
                )
            } else {
                orderedKeys.append(key)
                mergedFilters[key] = displayFilter(filter, for: key)
            }
        }

        return orderedKeys.compactMap { mergedFilters[$0] }
    }

    private static func displayFilter(
        _ filter: BrowseCollectionSubcategory,
        for key: String
    ) -> BrowseCollectionSubcategory {
        guard key == "neighborhoods", filter.title == "Streets" else {
            return filter
        }

        return BrowseCollectionSubcategory(
            id: filter.id,
            title: "Neighborhoods",
            subtitle: "Neighborhoods and streets",
            symbolName: "map.fill",
            tintName: filter.tintName,
            phraseCount: filter.phraseCount,
            countUnit: filter.countUnit,
            items: filter.items,
            targetRoute: filter.targetRoute
        )
    }

    private static func uniquePhraseItems(_ items: [BrowseSearchPhraseItem]) -> [BrowseSearchPhraseItem] {
        var seen = Set<String>()
        return items.filter { item in
            seen.insert(item.pageID).inserted
        }
    }

    private static func cityFilterKey(for filter: BrowseCollectionSubcategory) -> String {
        let text = "\(filter.id) \(filter.title) \(filter.subtitle)".lowercased()

        if text.contains(".browse.arrivals") {
            return "arrivals"
        }

        if text.contains(".browse.landmarks") {
            return "landmarks"
        }

        if text.contains(".browse.neighborhoods")
            || text.contains(".browse.streets") {
            return "neighborhoods"
        }

        if text.contains(".browse.restaurants") {
            return "restaurants"
        }

        if text.contains(".browse.cafes") {
            return "cafes"
        }

        if text.contains(".browse.dishes") {
            return "dishes"
        }

        if text.contains("arriv") {
            return "arrivals"
        }

        if text.contains("getting around") || text.contains("taxi") || text.contains("grab") || text.contains("drop-off") {
            return "getting-around"
        }

        if text.contains("neighborhood")
            || text.contains("district")
            || text.contains("quarter")
            || text.contains("old town")
            || text.contains("street") {
            return "neighborhoods"
        }

        if text.contains("landmark")
            || text.contains("places to visit")
            || text.contains("citadel")
            || text.contains("temple")
            || text.contains("museum")
            || text.contains("pagoda") {
            return "landmarks"
        }

        if text.contains("beach") || text.contains("nature") || text.contains("river") || text.contains("heritage") {
            return "beaches-nature"
        }

        if text.contains("tour") || text.contains("cruise") || text.contains("experience") || text.contains("show") {
            return "tours"
        }

        if text.contains("food") || text.contains("coffee") || text.contains("café") || text.contains("cafe") {
            return "food-coffee"
        }

        if text.contains("market") || text.contains("shopping") {
            return "markets"
        }

        if text.contains("help") || text.contains("bathroom") || text.contains("pharmacy") || text.contains("lost item") {
            return "help"
        }

        return filter.title.lowercased().replacingOccurrences(of: " ", with: "-")
    }
}

struct BrowseSearchCollectionMatch: Identifiable, Equatable {
    let descriptor: BrowseCollectionDescriptor

    var id: String { descriptor.id }
    var route: BrowseCollectionRoute { descriptor.route }
}

struct BrowseCityCollectionItem: Equatable {
    let pageID: String
    let title: String
    let subtitle: String
    let categoryIDs: [String]
    let symbolName: String
    let tintName: AccentTint
    let audioKey: String?
    let cityID: String
    let cityName: String
    let subcategoryID: String
    let subcategoryTitle: String
    let pageKind: String
    let placeKind: String
    let imageName: String?

    var phraseItem: BrowseSearchPhraseItem {
        BrowseSearchPhraseItem(
            pageID: pageID,
            title: title,
            subtitle: subtitle,
            symbolName: symbolName,
            tintName: tintName,
            audioKey: audioKey,
            imageName: imageName
        )
    }
}

enum BrowseSearchDestinations {
    static let situations: [BrowseDestination] = [
        BrowseDestination(
            id: "airport",
            title: "Airport",
            subtitle: "Arrival, passport, taxis, SIM cards",
            categoryIDs: ["airport-border-arrival", "transport", "phone-internet-power", "money-numbers-prices"],
            symbolName: "suitcase.rolling.fill",
            tintName: .red,
            sampleQuery: "airport taxi"
        ),
        BrowseDestination(
            id: "hotel",
            title: "Hotel",
            subtitle: "Check in, bags, rooms, checkout",
            categoryIDs: ["hotel-accommodation", "time-dates-booking", "local-services-everyday-tasks"],
            symbolName: "bell.fill",
            tintName: .orange,
            sampleQuery: "hotel check in",
            preferredPageIDs: ["viet-family-hotel-check-in", "viet-family-hotel-luggage"]
        ),
        BrowseDestination(
            id: "food",
            title: "Eating Out",
            subtitle: "Tables, ordering, allergies, paying",
            categoryIDs: ["food-drink", "money-numbers-prices"],
            symbolName: "menucard.fill",
            tintName: .orange,
            sampleQuery: "restaurant ordering",
            preferredPageIDs: [
                "viet-family-food-coffee-black",
                "viet-family-food-coffee-milk",
                "viet-family-ves-order-pho-bowl",
            ]
        ),
        BrowseDestination(
            id: "getting-around",
            title: "Getting Around",
            subtitle: "Taxi, walking, stops, maps",
            categoryIDs: ["transport", "directions-navigation"],
            symbolName: "scooter",
            tintName: .green,
            sampleQuery: "directions"
        ),
        BrowseDestination(
            id: "shopping",
            title: "Shopping",
            subtitle: "Prices, sizes, receipts, cards",
            categoryIDs: ["shopping", "money-numbers-prices", "local-services-everyday-tasks"],
            symbolName: "bag.fill",
            tintName: .orange,
            sampleQuery: "price"
        ),
        BrowseDestination(
            id: "everyday-services",
            title: "Everyday Needs",
            subtitle: "Bathroom, phone, laundry, water, rain",
            categoryIDs: ["local-services-everyday-tasks", "bathroom-personal-needs", "phone-internet-power"],
            symbolName: "wrench.and.screwdriver.fill",
            tintName: .teal,
            sampleQuery: "where is the bathroom"
        ),
        BrowseDestination(
            id: "tours-sights",
            title: "Tours & Sights",
            subtitle: "Tickets, entrances, guides, photos",
            categoryIDs: ["sightseeing-activities", "time-dates-booking", "directions-navigation"],
            symbolName: "ticket.fill",
            tintName: .orange,
            sampleQuery: "where can I buy tickets"
        ),
        BrowseDestination(
            id: "emergency",
            title: "Emergency",
            subtitle: "Help, health, safety, problems",
            categoryIDs: ["emergency-safety", "health-pharmacy", "problems-help"],
            symbolName: "cross.case.fill",
            tintName: .red,
            sampleQuery: "help now",
            preferredPageIDs: [
                "viet-phrase-emergency-5",
                "viet-family-v900-emer-safe-please-call-emergency-services",
                "viet-family-health-doctor",
                "viet-family-emergency-hospital",
                "viet-family-emergency-police-station",
            ]
        ),
        BrowseDestination(
            id: "local-greetings",
            title: "Respectful hellos",
            subtitle: "Choose the right hello for who you are speaking to",
            categoryIDs: ["local-greetings", "greetings", "polite-basics"],
            symbolName: "bubble.left.and.bubble.right.fill",
            tintName: .green,
            sampleQuery: "hello",
            preferredPageIDs: [PhrasePage.xinChao.id, "viet-phrase-hello-chao-anh"]
        ),
    ]

    static let menuGuides: [BrowseDestination] = [
        BrowseDestination(
            id: VietnameseMenuKind.food.routeID,
            title: "Food Menu",
            subtitle: "Khai vị, bowls, mains, lẩu, and regional specialties",
            categoryIDs: ["food-drink"],
            symbolName: "fork.knife",
            tintName: .orange,
            sampleQuery: "food menu dish names pho bun cha"
        ),
        BrowseDestination(
            id: VietnameseMenuKind.drink.routeID,
            title: "Drink Menu",
            subtitle: "Hot and iced coffee, teas, smoothies, juice, and bottled water",
            categoryIDs: ["food-drink"],
            symbolName: "cup.and.saucer.fill",
            tintName: .teal,
            sampleQuery: "drink menu coffee tea smoothie"
        ),
    ]

    static let startHere: [BrowseDestination] = [
        BrowseDestination(
            id: "essentials",
            title: "Essentials",
            subtitle: "Core phrases for any trip",
            categoryIDs: ["polite-basics", "greetings", "gratitude", "understanding-repair"],
            symbolName: "book.closed.fill",
            tintName: .teal,
            sampleQuery: "essentials",
            preferredPageIDs: [PhrasePage.xinChao.id, "viet-thank-you", "viet-family-repair-understand"]
        ),
        BrowseDestination(
            id: "first-day",
            title: "First day in Vietnam",
            subtitle: "Arrive, check in, get oriented",
            categoryIDs: ["airport-border-arrival", "hotel-accommodation", "transport", "directions-navigation"],
            symbolName: "calendar.badge.clock",
            tintName: .orange,
            sampleQuery: "first day",
            preferredPageIDs: ["viet-family-airport-immigration", "viet-family-hotel-check-in"]
        ),
    ]

    static let phraseFamilies: [BrowseDestination] = [
        BrowseDestination(
            id: "greetings",
            title: "Hello basics",
            subtitle: "Simple ways to start conversations.",
            categoryIDs: ["greetings", "local-greetings"],
            symbolName: "text.bubble.fill",
            tintName: .green,
            sampleQuery: "hello",
            preferredPageIDs: [PhrasePage.xinChao.id]
        ),
        BrowseDestination(
            id: "questions",
            title: "Questions",
            subtitle: "Ask for information with confidence.",
            categoryIDs: ["directions-navigation", "time-dates-booking", "understanding-repair"],
            symbolName: "questionmark",
            tintName: .orange,
            sampleQuery: "where is"
        ),
        BrowseDestination(
            id: "numbers-money",
            title: "Numbers & money",
            subtitle: "Count, pay, and handle prices.",
            categoryIDs: ["money-numbers-prices", "shopping"],
            symbolName: "dongsign.circle.fill",
            tintName: .green,
            sampleQuery: "how much"
        ),
        BrowseDestination(
            id: "polite-repair",
            title: "When You Don't Understand",
            subtitle: "Ask people to repeat, slow down, write it, or use English.",
            categoryIDs: ["understanding-repair", "polite-basics", "problems-help"],
            symbolName: "questionmark.bubble.fill",
            tintName: .green,
            sampleQuery: "i don't understand",
            preferredPageIDs: ["viet-family-repair-understand", "viet-family-repair-meaning"]
        ),
    ]

    static let cityShortcuts: [BrowseCityShortcut] = [
        BrowseCityShortcut(id: "hanoi", title: "Hanoi", query: "Hanoi", symbolName: "building.columns.fill", tintName: .green),
        BrowseCityShortcut(id: "hcmc", title: "Ho Chi Minh City", query: "Ho Chi Minh City", symbolName: "building.2.fill", tintName: .orange),
        BrowseCityShortcut(id: "danang", title: "Da Nang", query: "Da Nang", symbolName: "water.waves", tintName: .blue),
        BrowseCityShortcut(id: "hoian", title: "Hoi An", query: "Hoi An", symbolName: "house.lodge.fill", tintName: .orange),
        BrowseCityShortcut(id: "hue", title: "Hue", query: "Hue", symbolName: "building.columns", tintName: .green),
        BrowseCityShortcut(id: "all-vietnam", title: "All Vietnam", query: "Vietnam", symbolName: "star.fill", tintName: .orange),
    ]

    static var homepageCityShortcuts: [BrowseCityShortcut] {
        let preferredOrder = ["danang", "hoian", "hcmc", "hanoi", "hue"]
        return preferredOrder.compactMap { cityID in
            cityShortcuts.first { $0.id == cityID }
        }
    }

    static let suggestedNeeds: [SearchPrompt] = [
        SearchPrompt(
            id: "hello",
            title: "Warm ways to say hello",
            subtitle: "Xin chào, chào bạn, chào anh/chị",
            query: "hello",
            symbolName: "hand.wave.fill",
            tintName: .red,
            pageID: PhrasePage.xinChao.id
        ),
        SearchPrompt(
            id: "directions",
            title: "Ask for directions",
            subtitle: "How do I get there, take me here",
            query: "directions",
            symbolName: "signpost.right.fill",
            tintName: .orange
        ),
        SearchPrompt(
            id: "understand",
            title: "When you don't understand",
            subtitle: "What does it mean, please repeat, write it down",
            query: "what does that mean",
            symbolName: "questionmark.bubble.fill",
            tintName: .green,
            pageID: "viet-family-repair-meaning"
        ),
    ]

    static let focusedSuggestions: [SearchPrompt] = [
        SearchPrompt(id: "directions", title: "Ask for directions", subtitle: "How do I get there, take me here", query: "directions", symbolName: "signpost.right.fill", tintName: .orange),
        SearchPrompt(id: "hotel", title: "Hotel check-in", subtitle: "Arrive, reservation, payment", query: "hotel", symbolName: "bell.fill", tintName: .red),
    ]

    static let popularQueries: [SearchPrompt] = [
        SearchPrompt(id: "hotel", title: "Hotel check-in", subtitle: "Hotel desk phrases", query: "hotel", symbolName: "bell.fill", tintName: .orange),
        SearchPrompt(id: "taxi", title: "Airport taxi", subtitle: "Get to your destination", query: "airport taxi", symbolName: "car.fill", tintName: .green),
        SearchPrompt(id: "food", title: "Food allergies", subtitle: "Order safely", query: "food allergies", symbolName: "takeoutbag.and.cup.and.straw.fill", tintName: .red),
        SearchPrompt(id: "price", title: "Price", subtitle: "Ask and pay", query: "price", symbolName: "tag.fill", tintName: .green),
        SearchPrompt(id: "bathroom", title: "Bathroom", subtitle: "Find a restroom", query: "bathroom", symbolName: "figure.stand", tintName: .blue),
    ]

    static let focusedQueryChips = ["hotel", "taxi", "food", "directions", "thank you"]
    static let emptyRecoveryChips = ["train station", "ticket", "refund", "taxi", "lost item"]

    static let likelyNextPageIDs = [
        "viet-family-hotel-luggage",
        "viet-family-shopping-card",
        "viet-family-repair-understand",
    ]

    static let recoveryActions: [SearchRecoveryAction] = [
        SearchRecoveryAction(
            id: "help",
            title: "Ask for help",
            subtitle: "Get assistance in any situation.",
            highlight: "Bạn có thể giúp tôi không?",
            symbolName: "ellipsis.bubble",
            tintName: .red,
            categoryIDs: ["problems-help", "emergency-safety"],
            preferredPageIDs: ["viet-family-help-can-you-help"]
        ),
        SearchRecoveryAction(
            id: "transport",
            title: "Transportation",
            subtitle: "Phrases for trains, buses, taxis and getting around.",
            highlight: "Tàu, xe buýt, taxi và di chuyển",
            symbolName: "bus.fill",
            tintName: .green,
            categoryIDs: ["transport", "directions-navigation"],
            preferredPageIDs: ["viet-family-transport-destination", "viet-family-v500-dire-navi-where-is-the-train-station"]
        ),
        SearchRecoveryAction(
            id: "money",
            title: "Money & receipts",
            subtitle: "Payments, receipts, refunds, and billing questions.",
            highlight: "Thanh toán, hóa đơn, hoàn tiền",
            symbolName: "wallet.pass",
            tintName: .orange,
            categoryIDs: ["money-numbers-prices", "shopping"],
            preferredPageIDs: ["viet-family-service-receipt", "viet-family-shopping-pay-where"]
        ),
    ]

    static func firstOpenablePageID(categoryIDs: [String]) -> String? {
        categoryIDs.lazy
            .flatMap { categoryID in PhraseCatalog.items(selectedCategoryID: categoryID) }
            .filter(shouldSurfaceCatalogItemInBrowse)
            .compactMap { item in PhraseCatalog.canonicalPageID(forOpenablePageID: item.pageID) }
            .first
    }

    static func itemCount(categoryIDs: [String]) -> Int {
        let pageIDs = categoryIDs.flatMap { categoryID in
            PhraseCatalog.items(selectedCategoryID: categoryID)
                .filter(shouldSurfaceCatalogItemInBrowse)
                .map(\.pageID)
        }

        return Set(pageIDs).count
    }

    static func items(categoryIDs: [String], limit: Int) -> [BrowseSearchPhraseItem] {
        var seen = Set<String>()
        var resolvedItems: [BrowseSearchPhraseItem] = []

        for categoryID in categoryIDs {
            for item in PhraseCatalog.items(selectedCategoryID: categoryID) {
                guard shouldSurfaceCatalogItemInBrowse(item) else {
                    continue
                }

                guard seen.insert(item.pageID).inserted else {
                    continue
                }

                resolvedItems.append(
                    BrowseSearchPhraseItem(
                        pageID: item.pageID,
                        title: item.title,
                        subtitle: item.subtitle,
                        symbolName: item.symbolName,
                        tintName: item.tintName,
                        audioKey: item.playbackAudioKey
                    )
                )

                if resolvedItems.count >= limit {
                    return resolvedItems
                }
            }
        }

        return resolvedItems
    }

    static func phraseItems(for pageIDs: [String], limit: Int) -> [BrowseSearchPhraseItem] {
        pageIDs
            .compactMap(BrowseSearchPhraseItem.resolve(pageID:))
            .prefix(limit)
            .map { $0 }
    }

    static func searchResults(for query: String, limit: Int) -> [BrowseSearchPhraseItem] {
        let rawResults = PhraseSearchIndex.search(query, limit: max(limit * 3, limit))
        let allowsDerivedPlacePhrases = allowsDerivedPlacePhraseSearchResults(for: query)
        let filteredResults = rawResults.filter { result in
            allowsDerivedPlacePhrases || !isDerivedPlacePhrase(pageID: result.pageID)
        }
        let results = filteredResults.isEmpty ? rawResults : filteredResults

        return results
            .prefix(limit)
            .map(BrowseSearchPhraseItem.fromSearchResult)
    }

    static func collectionDescriptor(for route: BrowseCollectionRoute) -> BrowseCollectionDescriptor? {
        if let descriptor = collectionDescriptorCache[route] {
            return descriptor
        }

        let descriptor: BrowseCollectionDescriptor?
        switch route {
        case .category(let id):
            descriptor = makeCategoryDescriptor(id: id)
        case .city(let id):
            descriptor = makeCityDescriptor(id: id)
        }

        if let descriptor {
            collectionDescriptorCache[route] = descriptor
        }
        return descriptor
    }

    static var visibleCategoryCollectionRoutes: [BrowseCollectionRoute] {
        allCategoryDestinations.map { .category($0.id) }
    }

    static func matchingCollections(for query: String) -> [BrowseSearchCollectionMatch] {
        let normalizedQueries = (SearchQueryExpander.expandedQueries(for: query) + SearchQueryExpander.looseFallbackQueries(for: query))
            .map(normalize)
            .filter { !$0.isEmpty }
        guard !normalizedQueries.isEmpty else {
            return []
        }

        let cityRoutes = cityShortcuts
            .filter { city in
                city.id != "all-vietnam"
                    && collectionTextMatches(
                        queries: normalizedQueries,
                        text: "\(city.title) \(city.query) \(cityAliases[city.id, default: []].joined(separator: " "))"
                    )
            }
            .map(\.collectionRoute)

        let categoryRoutes = allCategoryDestinations
            .filter { destination in
                return collectionTextMatches(
                    queries: normalizedQueries,
                    text: "\(destination.title) \(destination.subtitle) \(destination.sampleQuery) \(destination.id) \(destination.categoryIDs.joined(separator: " ")) \(categorySearchAliases[destination.id, default: []].joined(separator: " "))"
                )
            }
            .map(\.collectionRoute)

        return uniqueRoutes(categoryRoutes + cityRoutes)
            .compactMap(searchCollectionDescriptor(for:))
            .map(BrowseSearchCollectionMatch.init(descriptor:))
    }

    static func matchingSituations(for query: String) -> [BrowseDestination] {
        let normalizedQueries = (SearchQueryExpander.expandedQueries(for: query) + SearchQueryExpander.looseFallbackQueries(for: query))
            .map(normalize)
            .filter { !$0.isEmpty }
        guard !normalizedQueries.isEmpty else {
            return []
        }

        return situations.filter { destination in
            let categoryText = destination.categoryIDs
                .compactMap { PhraseCatalog.category(withID: $0)?.title }
                .joined(separator: " ")

            let searchText = normalize("\(destination.title) \(destination.subtitle) \(destination.sampleQuery) \(categoryText)")
            return normalizedQueries.contains { normalizedQuery in
                searchText.contains(normalizedQuery)
                    || normalizedQuery.split(separator: " ").allSatisfy { searchText.contains($0) }
            }
        }
    }

    static func matchingCities(for query: String) -> [BrowseCityShortcut] {
        let normalizedQueries = (SearchQueryExpander.expandedQueries(for: query) + SearchQueryExpander.looseFallbackQueries(for: query))
            .map(normalize)
            .filter { !$0.isEmpty }
        guard !normalizedQueries.isEmpty else {
            return []
        }

        return cityShortcuts.filter { city in
            let searchText = normalize("\(city.title) \(city.query) \(cityAliases[city.id, default: []].joined(separator: " "))")
            return normalizedQueries.contains { searchText.contains($0) }
        }
    }

    private static func normalize(_ text: String) -> String {
        text
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static var collectionDescriptorCache: [BrowseCollectionRoute: BrowseCollectionDescriptor] = [:]
    private static var cityCollectionItemCache: [String: [BrowseCityCollectionItem]] = [:]

    private static var allCategoryDestinations: [BrowseDestination] {
        situations + menuGuides + startHere + phraseFamilies
    }

    private static func searchCollectionDescriptor(for route: BrowseCollectionRoute) -> BrowseCollectionDescriptor? {
        switch route {
        case .category(let id):
            return searchCategoryDescriptor(id: id)
        case .city(let id):
            return searchCityDescriptor(id: id)
        }
    }

    private static func searchCategoryDescriptor(id: String) -> BrowseCollectionDescriptor? {
        if let kind = VietnameseMenuKind.kind(forRouteID: id) {
            return VietnameseMenuCatalog.descriptor(for: kind)
        }

        guard let destination = allCategoryDestinations.first(where: { $0.id == id }) else {
            return nil
        }

        let title = collectionTitle(for: id, fallback: destination.title)
        return BrowseCollectionDescriptor(
            route: .category(id),
            title: title,
            subtitle: collectionSubtitle(for: id, fallback: destination.subtitle),
            eyebrow: "SPEAKLOCAL VIETNAM",
            mastheadImageName: mastheadImageName(for: .category(id)),
            symbolName: destination.symbolName,
            tintName: destination.tintName,
            subcategories: [],
            starterTitle: starterTitle(for: id),
            starterItems: [],
            practiceTitle: messageEntryTitle(for: title),
            practiceSubtitle: practiceSubtitle(for: title),
            practiceAction: .addStarterPages([]),
            messageSectionTitle: categoryMessageSectionTitle(for: id, title: title),
            exploreShelves: []
        )
    }

    private static func searchCityDescriptor(id: String) -> BrowseCollectionDescriptor? {
        guard let city = cityShortcuts.first(where: { $0.id == id }) else {
            return nil
        }

        let title = city.title == "Ho Chi Minh City" ? "Saigon" : city.title
        return BrowseCollectionDescriptor(
            route: .city(id),
            title: title,
            subtitle: citySubtitle(for: id),
            eyebrow: "SPEAKLOCAL VIETNAM",
            mastheadImageName: mastheadImageName(for: .city(id)),
            symbolName: city.symbolName,
            tintName: city.tintName,
            subcategories: [],
            starterTitle: "Names to know",
            starterItems: [],
            practiceTitle: cityPracticeTitle(for: id, title: title),
            practiceSubtitle: cityPracticeSubtitle(for: id),
            practiceAction: cityPracticeAction(for: id),
            exploreShelves: []
        )
    }

    private static func makeCategoryDescriptor(id: String) -> BrowseCollectionDescriptor? {
        if let kind = VietnameseMenuKind.kind(forRouteID: id) {
            return VietnameseMenuCatalog.descriptor(for: kind)
        }

        if id == "city-guides" {
            return makeCountryHubDescriptor()
        }

        let destination = allCategoryDestinations.first { $0.id == id }
        let category = PhraseCatalog.category(withID: id)
        let categoryIDs = destination?.categoryIDs ?? [id]
        let entityContent = categoryEntityContent(
            for: id,
            tintName: destination?.tintName ?? category?.tintName ?? categoryEntityTint(for: id) ?? .green
        )

        guard destination != nil || category != nil || entityContent != nil else {
            return nil
        }

        let title = collectionTitle(for: id, fallback: destination?.title ?? category?.title ?? categoryEntityTitle(for: id) ?? "Browse")
        let tint = destination?.tintName ?? category?.tintName ?? categoryEntityTint(for: id) ?? .green
        let symbolName = destination?.symbolName ?? category?.symbolName ?? categoryEntitySymbolName(for: id) ?? "square.grid.2x2"
        let phraseStarterItems = starterItems(
            categoryIDs: categoryIDs,
            preferredPageIDs: destination?.preferredPageIDs ?? [],
            limit: 3
        )
        let practiceStarterItems = starterItems(
            categoryIDs: categoryIDs,
            preferredPageIDs: destination?.preferredPageIDs ?? [],
            limit: 8
        )
        let starterItems = entityContent?.starterItems ?? phraseStarterItems
        let baseSubcategories = entityContent?.subcategories ?? categorySubcategories(for: id, categoryIDs: categoryIDs, tintName: tint)
        let searchOnlySubcategories = VietSearchOnlyPhraseSurfacing.subcategories(for: id, tintName: tint)
        let subcategories = categoryEntitySubcategories(baseSubcategories, inserting: searchOnlySubcategories, for: id)
        let shelves = categoryExploreShelves(
            collectionID: id,
            categoryIDs: categoryIDs,
            excluding: (starterItems + phraseStarterItems).map(\.pageID)
        )

        return BrowseCollectionDescriptor(
            route: .category(id),
            title: title,
            subtitle: collectionSubtitle(for: id, fallback: destination?.subtitle ?? category?.title ?? categoryEntitySubtitle(for: id) ?? "Useful phrases for this travel moment."),
            eyebrow: "SPEAKLOCAL VIETNAM",
            mastheadImageName: mastheadImageName(for: .category(id)),
            symbolName: symbolName,
            tintName: tint,
            subcategories: subcategories,
            starterTitle: entityContent?.starterTitle ?? starterTitle(for: id),
            starterItems: starterItems,
            practiceTitle: messageEntryTitle(for: title),
            practiceSubtitle: practiceSubtitle(for: title),
            practiceAction: categoryPracticeAction(for: id, starterPageIDs: practiceStarterItems.map(\.pageID)),
            messageSectionTitle: categoryMessageSectionTitle(for: id, title: title),
            exploreShelves: shelves
        )
    }

    private static func makeCountryHubDescriptor() -> BrowseCollectionDescriptor? {
        let essentialItems = countryEssentialPhraseItems()

        return BrowseCollectionDescriptor(
            route: .category("city-guides"),
            title: "All Vietnam",
            subtitle: "Food, places, city names, culture, and phrases that make Vietnam easier to picture.",
            eyebrow: "SPEAKLOCAL VIETNAM",
            mastheadImageName: "HeroCountryVietnam",
            symbolName: "star.fill",
            tintName: .orange,
            subcategories: [],
            starterTitle: "Essential phrases",
            starterItems: essentialItems,
            practiceTitle: "Vietnam basics",
            practiceSubtitle: "Food, coffee, city names, places, and useful phrases before you land.",
            practiceAction: .addStarterPages(essentialItems.map(\.pageID)),
            exploreShelves: [],
            cityHub: BrowseCityHub(
                cityNameAudioItem: nil,
                introTitle: "Start here",
                introText: "Start with the foods, places, city names, and Vietnamese sounds that make the trip feel vivid before you land. Then use the phrase and audio layer when those names turn into real plans.",
                situationTitle: "Start here",
                situations: countryStartCards(),
                namesTitle: "Essential phrases",
                namesToKnowItems: essentialItems,
                quickPhrasesTitle: "",
                quickPhraseItems: [],
                browseTitle: "City guides",
                browseGroups: countryCityGuideCards()
            )
        )
    }

    private static func makeCityDescriptor(id: String) -> BrowseCollectionDescriptor? {
        guard let city = cityShortcuts.first(where: { $0.id == id }) else {
            return nil
        }

        let title = city.title == "Ho Chi Minh City" ? "Saigon" : city.title
        let cityItems = cityCollectionItems(for: id)
        let groupedItems = Dictionary(grouping: cityItems, by: \.subcategoryID)
        let orderedSubcategoryIDs = citySubcategoryOrder.filter { groupedItems[$0] != nil }
        let cityHub = cityHubDescriptor(for: id, title: title, city: city, cityItems: cityItems, groupedItems: groupedItems)
        let starterItems = cityHub.namesToKnowItems
        let subcategories = orderedSubcategoryIDs.map { subcategoryID in
            let rows = groupedItems[subcategoryID, default: []].filter(shouldSurfaceCityItemInBrowse)
            let title = rows.first?.subcategoryTitle ?? citySubcategoryTitles[subcategoryID] ?? "City phrases"
            return BrowseCollectionSubcategory(
                id: "\(id).\(subcategoryID)",
                title: citySubcategoryShortTitles[subcategoryID] ?? title,
                subtitle: title,
                symbolName: citySubcategorySymbols[subcategoryID] ?? "mappin.and.ellipse",
                tintName: city.tintName,
                phraseCount: rows.count,
                items: rows.prefix(4).map(\.phraseItem)
            )
        }
        let shelves = orderedSubcategoryIDs
            .filter { $0 != "arrivals-routes" }
            .prefix(3)
            .compactMap { subcategoryID -> BrowseCollectionShelf? in
                let rows = groupedItems[subcategoryID, default: []]
                    .filter(shouldSurfaceCityItemInBrowse)
                    .prefix(6)
                    .map(\.phraseItem)
                guard !rows.isEmpty else {
                    return nil
                }

                let title = citySubcategoryTitles[subcategoryID] ?? "Explore"
                return BrowseCollectionShelf(
                    id: "\(id).shelf.\(subcategoryID)",
                    title: title,
                    subtitle: "Useful \(city.title) phrases",
                    items: Array(rows)
                )
            }

        guard !starterItems.isEmpty || !subcategories.isEmpty else {
            return nil
        }

        return BrowseCollectionDescriptor(
            route: .city(id),
            title: title,
            subtitle: citySubtitle(for: id),
            eyebrow: "SPEAKLOCAL VIETNAM",
            mastheadImageName: mastheadImageName(for: .city(id)),
            symbolName: city.symbolName,
            tintName: city.tintName,
            subcategories: subcategories,
            starterTitle: cityHub.namesTitle,
            starterItems: starterItems,
            practiceTitle: cityPracticeTitle(for: id, title: title),
            practiceSubtitle: cityPracticeSubtitle(for: id),
            practiceAction: cityPracticeAction(for: id),
            exploreShelves: shelves,
            cityHub: cityHub
        )
    }

    private static func cityHubDescriptor(
        for cityID: String,
        title: String,
        city: BrowseCityShortcut,
        cityItems: [BrowseCityCollectionItem],
        groupedItems: [String: [BrowseCityCollectionItem]]
    ) -> BrowseCityHub {
        BrowseCityHub(
            cityNameAudioItem: cityNameAudioItem(for: cityID, city: city),
            introTitle: "Start here",
            introText: cityIntro(for: cityID),
            situationTitle: "Browse by",
            situations: citySituationCards(for: cityID, tintName: city.tintName, groupedItems: groupedItems),
            namesTitle: "Names to know",
            namesToKnowItems: cityNamesToKnowItems(for: cityID, cityItems: cityItems),
            quickPhrasesTitle: "Quick phrases",
            quickPhraseItems: cityQuickPhraseItems(for: cityID, cityItems: cityItems),
            browseTitle: "Browse by",
            browseGroups: cityBrowseGroups(for: cityID, tintName: city.tintName, groupedItems: groupedItems)
        )
    }

    private static func countryStartCards() -> [BrowseCollectionSubcategory] {
        let specs: [(String, String, String, String, AccentTint, BrowseCollectionRoute)] = [
            ("first-day", "First day in Vietnam", "Arrive, check in, get oriented", "calendar.badge.clock", .orange, .category("first-day")),
            ("airport", "Airport arrival", "Passport, baggage, SIM, pickup", "airplane.arrival", .red, .category("airport")),
            ("taxi-grab", "Taxi / Grab", "Pickup, destination, drop-off", "car.fill", .green, .category("getting-around")),
            ("food-drink", "Eating Out", "Order, allergies, pay", "menucard.fill", .orange, .category("food")),
            ("hotel", "Hotel", "Check in, room help, checkout", "bell.fill", .red, .category("hotel")),
            ("help", "Help", "Bathroom, pharmacy, lost item", "cross.case.fill", .red, .category("emergency")),
        ]

        return specs.map { id, title, subtitle, symbolName, tint, route in
            BrowseCollectionSubcategory(
                id: "country.start.\(id)",
                title: title,
                subtitle: subtitle,
                symbolName: symbolName,
                tintName: tint,
                phraseCount: 0,
                items: [],
                targetRoute: route
            )
        }
    }

    private static func countryCityGuideCards() -> [BrowseCollectionSubcategory] {
        cityShortcuts
            .filter { $0.id != "all-vietnam" }
            .map { city in
                BrowseCollectionSubcategory(
                    id: "country.city.\(city.id)",
                    title: city.title,
                    subtitle: citySubtitle(for: city.id),
                    symbolName: city.symbolName,
                    tintName: city.tintName,
                    phraseCount: 0,
                    items: [],
                    targetRoute: .city(city.id)
                )
            }
    }

    private static func countryEssentialPhraseItems() -> [BrowseSearchPhraseItem] {
        phraseItems(for: [
            PhrasePage.xinChao.id,
            "viet-thank-you",
            "viet-family-repair-understand",
            "viet-family-repair-english-help",
            "viet-family-bathroom-where",
        ], limit: 5)
    }

    private static func citySituationCards(
        for cityID: String,
        tintName: AccentTint,
        groupedItems: [String: [BrowseCityCollectionItem]]
    ) -> [BrowseCollectionSubcategory] {
        let specs: [CitySituationCardSpec] = {
            switch cityID {
            case "danang":
                return [
                    CitySituationCardSpec(id: "arriving", title: "Arriving", subtitle: "Airport, baggage, SIM, pickup", symbolName: "airplane.arrival", tintName: .red, preferredPageIDs: [
                        "viet-family-city-danang-place-airport",
                        "viet-family-city-danang-go-airport",
                        "viet-family-city-danang-where-airport",
                        "viet-phrase-airport-3",
                        "viet-phrase-airport-4",
                        "viet-phrase-hotel-9",
                    ], subcategoryIDs: ["arrivals-routes"]),
                    CitySituationCardSpec(id: "getting-around", title: "Getting around", subtitle: "Taxi, Grab, streets, drop-off", symbolName: "car.fill", tintName: .green, preferredPageIDs: [
                        "viet-phrase-hotel-9",
                        "viet-phrase-v900-phon-inte-powe-can-you-help-me-book-a-grab",
                        "viet-phrase-transport-stop-here-clearer",
                        "viet-family-city-danang-place-nguyen-van-linh-street",
                        "viet-family-city-danang-place-bach-dang-street",
                    ], subcategoryIDs: ["arrivals-routes", "neighborhoods-streets"]),
                    CitySituationCardSpec(id: "beach-day", title: "Beach day", subtitle: "My Khe, chairs, drinks, bathroom", symbolName: "beach.umbrella.fill", tintName: .blue, preferredPageIDs: [
                        "viet-family-city-danang-place-my-khe",
                        "viet-phrase-transport-stop-here-clearer",
                        "viet-phrase-ves-take-photo-for-me",
                        "viet-phrase-bath-1",
                    ], subcategoryIDs: ["landmarks-attractions", "food-coffee", "practical-help-near-places"]),
                    CitySituationCardSpec(id: "food-coffee", title: "Food & cafes", subtitle: "Restaurants, cafés, markets", symbolName: "cup.and.saucer.fill", tintName: .orange, preferredPageIDs: [
                        "viet-family-city-danang-place-nen",
                        "viet-family-city-danang-go-nen",
                        "viet-family-city-danang-reservation-nen",
                        "viet-family-city-danang-seafood-my-khe",
                        "viet-phrase-food-menu",
                    ], subcategoryIDs: ["food-coffee"]),
                    CitySituationCardSpec(id: "places", title: "Places to visit", subtitle: "Dragon Bridge, Marble Mountains, Bà Nà Hills", symbolName: "building.columns.fill", tintName: .blue, preferredPageIDs: [
                        "viet-family-city-danang-place-dragon-bridge",
                        "viet-family-city-danang-place-love-bridge",
                        "viet-family-city-danang-place-marble-mountains",
                        "viet-family-city-danang-place-ba-na-hills",
                        "viet-family-city-danang-place-linh-ung-pagoda",
                    ], subcategoryIDs: ["landmarks-attractions"]),
                    CitySituationCardSpec(id: "help", title: "Help", subtitle: "Bathroom, pharmacy, lost item", symbolName: "cross.case.fill", tintName: .red, preferredPageIDs: [
                        "viet-phrase-bath-1",
                        "viet-phrase-health-1",
                        "viet-phrase-help-need-help-direct",
                        "viet-phrase-emergency-3",
                        "viet-phrase-v500-prob-help-my-phone-is-missing",
                    ], subcategoryIDs: ["practical-help-near-places"]),
                ]
            case "hanoi":
                return [
                    CitySituationCardSpec(id: "arriving", title: "Arriving", subtitle: "Airport, baggage, pickup", symbolName: "airplane.arrival", tintName: .red, subcategoryIDs: ["arrivals-routes"]),
                    CitySituationCardSpec(id: "getting-around", title: "Getting around", subtitle: "Taxi, streets, drop-off", symbolName: "car.fill", tintName: .green, subcategoryIDs: ["arrivals-routes", "neighborhoods-streets"]),
                    CitySituationCardSpec(id: "old-quarter", title: "Old Quarter", subtitle: "Lake, streets, markets", symbolName: "map.fill", tintName: .green, subcategoryIDs: ["landmarks-attractions", "neighborhoods-streets", "shopping-markets"]),
                    CitySituationCardSpec(id: "food-coffee", title: "Food & cafes", subtitle: "Phở, bún chả, cafés", symbolName: "cup.and.saucer.fill", tintName: .orange, subcategoryIDs: ["food-coffee"]),
                    CitySituationCardSpec(id: "places", title: "Places to visit", subtitle: "Lake, temples, museums", symbolName: "building.columns.fill", tintName: .green, subcategoryIDs: ["landmarks-attractions"]),
                    CitySituationCardSpec(id: "help", title: "Help", subtitle: "Bathroom, pharmacy, lost item", symbolName: "cross.case.fill", tintName: .red, subcategoryIDs: ["practical-help-near-places"]),
                ]
            case "hcmc":
                return [
                    CitySituationCardSpec(id: "arriving", title: "Arriving", subtitle: "Airport, baggage, pickup", symbolName: "airplane.arrival", tintName: .red, subcategoryIDs: ["arrivals-routes"]),
                    CitySituationCardSpec(id: "getting-around", title: "Getting around", subtitle: "Taxi, Grab, streets, drop-off", symbolName: "car.fill", tintName: .green, subcategoryIDs: ["arrivals-routes", "neighborhoods-streets"]),
                    CitySituationCardSpec(id: "district-one", title: "District 1", subtitle: "Hotels, cafés, landmarks", symbolName: "building.2.fill", tintName: .orange, subcategoryIDs: ["landmarks-attractions", "neighborhoods-streets", "food-coffee"]),
                    CitySituationCardSpec(id: "food-coffee", title: "Food & cafes", subtitle: "Restaurants, cafés, markets", symbolName: "cup.and.saucer.fill", tintName: .orange, subcategoryIDs: ["food-coffee"]),
                    CitySituationCardSpec(id: "markets", title: "Markets", subtitle: "Shopping, prices, pickup", symbolName: "bag.fill", tintName: .orange, subcategoryIDs: ["shopping-markets"]),
                    CitySituationCardSpec(id: "help", title: "Help", subtitle: "Bathroom, pharmacy, lost item", symbolName: "cross.case.fill", tintName: .red, subcategoryIDs: ["practical-help-near-places"]),
                ]
            case "hoian":
                return [
                    CitySituationCardSpec(id: "arriving", title: "Arriving", subtitle: "Shuttle, hotel, baggage", symbolName: "airplane.arrival", tintName: .red, subcategoryIDs: ["arrivals-routes"]),
                    CitySituationCardSpec(id: "getting-around", title: "Getting around", subtitle: "Walking, taxi, pickup", symbolName: "car.fill", tintName: .green, subcategoryIDs: ["arrivals-routes", "neighborhoods-streets"]),
                    CitySituationCardSpec(id: "old-town", title: "Old Town", subtitle: "Lanterns, markets, river", symbolName: "house.lodge.fill", tintName: .orange, subcategoryIDs: ["landmarks-attractions", "shopping-markets"]),
                    CitySituationCardSpec(id: "food-coffee", title: "Food & cafes", subtitle: "Cao lầu, cafés, markets", symbolName: "cup.and.saucer.fill", tintName: .orange, subcategoryIDs: ["food-coffee"]),
                    CitySituationCardSpec(id: "shopping", title: "Shopping", subtitle: "Tailors, prices, pickup", symbolName: "bag.fill", tintName: .orange, subcategoryIDs: ["shopping-markets"]),
                    CitySituationCardSpec(id: "help", title: "Help", subtitle: "Bathroom, pharmacy, lost item", symbolName: "cross.case.fill", tintName: .red, subcategoryIDs: ["practical-help-near-places"]),
                ]
            case "hue":
                return [
                    CitySituationCardSpec(id: "arriving", title: "Arriving", subtitle: "Station, hotel, pickup", symbolName: "airplane.arrival", tintName: .red, subcategoryIDs: ["arrivals-routes"]),
                    CitySituationCardSpec(id: "getting-around", title: "Getting around", subtitle: "Taxi, streets, drop-off", symbolName: "car.fill", tintName: .green, subcategoryIDs: ["arrivals-routes", "neighborhoods-streets"]),
                    CitySituationCardSpec(id: "citadel", title: "Citadel", subtitle: "Tickets, gates, pickup", symbolName: "building.columns.fill", tintName: .green, subcategoryIDs: ["landmarks-attractions"]),
                    CitySituationCardSpec(id: "food", title: "Food", subtitle: "Bún bò Huế, markets, cafés", symbolName: "cup.and.saucer.fill", tintName: .orange, subcategoryIDs: ["food-coffee"]),
                    CitySituationCardSpec(id: "river-heritage", title: "River & heritage", subtitle: "Boats, pagodas, routes", symbolName: "water.waves", tintName: .blue, subcategoryIDs: ["landmarks-attractions"]),
                    CitySituationCardSpec(id: "help", title: "Help", subtitle: "Bathroom, pharmacy, lost item", symbolName: "cross.case.fill", tintName: .red, subcategoryIDs: ["practical-help-near-places"]),
                ]
            default:
                return [
                    CitySituationCardSpec(id: "arriving", title: "Arriving", subtitle: "Airport, baggage, pickup", symbolName: "airplane.arrival", tintName: .red, subcategoryIDs: ["arrivals-routes"]),
                    CitySituationCardSpec(id: "getting-around", title: "Getting around", subtitle: "Taxi, streets, drop-off", symbolName: "car.fill", tintName: .green, subcategoryIDs: ["arrivals-routes", "neighborhoods-streets"]),
                    CitySituationCardSpec(id: "food-coffee", title: "Food & cafes", subtitle: "Restaurants, cafés, markets", symbolName: "cup.and.saucer.fill", tintName: .orange, subcategoryIDs: ["food-coffee"]),
                    CitySituationCardSpec(id: "places", title: "Places to visit", subtitle: "Landmarks, streets, day trips", symbolName: "building.columns.fill", tintName: tintName, subcategoryIDs: ["landmarks-attractions", "neighborhoods-streets"]),
                    CitySituationCardSpec(id: "help", title: "Help", subtitle: "Bathroom, pharmacy, lost item", symbolName: "cross.case.fill", tintName: .red, subcategoryIDs: ["practical-help-near-places"]),
                ]
            }
        }()

        return specs.map { spec in
            let items = citySituationItems(for: spec, groupedItems: groupedItems)
            return BrowseCollectionSubcategory(
                id: "\(cityID).situation.\(spec.id)",
                title: spec.title,
                subtitle: spec.subtitle,
                symbolName: spec.symbolName,
                tintName: spec.tintName,
                phraseCount: max(items.count, spec.subcategoryIDs.reduce(0) { total, subcategoryID in
                    total + groupedItems[subcategoryID, default: []].count
                }),
                items: items,
                targetRoute: nil
            )
        }
    }

    private static func citySituationItems(
        for spec: CitySituationCardSpec,
        groupedItems: [String: [BrowseCityCollectionItem]]
    ) -> [BrowseSearchPhraseItem] {
        let preferredItems = pageItems(forOpenablePageIDs: spec.preferredPageIDs)
            .filter(shouldSurfacePhraseItemInBrowse)
        let fallbackItems = spec.subcategoryIDs
            .flatMap { groupedItems[$0, default: []] }
            .filter(shouldSurfaceCityItemInBrowse)
            .filter { !lowPriorityCityOverviewText($0.title, $0.subtitle) }
            .prefix(8)
            .map(\.phraseItem)

        return Array(uniquePhraseItems(preferredItems + fallbackItems).prefix(6))
    }

    private static func cityNamesToKnowItems(for cityID: String, cityItems: [BrowseCityCollectionItem]) -> [BrowseSearchPhraseItem] {
        let preferredIDs: [String] = {
            switch cityID {
            case "danang":
                return [
                    "city-danang-place-airport",
                    "city-danang-place-my-khe",
                    "city-danang-place-dragon-bridge",
                    "city-danang-place-ba-na-hills",
                    "city-danang-place-marble-mountains",
                    "city-danang-place-bach-dang-street",
                    "city-danang-place-nguyen-van-linh-street",
                    "city-danang-place-vo-nguyen-giap-street",
                ]
            default:
                return []
            }
        }()

        let preferredItems = pageItems(forPhraseIDs: preferredIDs)
        if !preferredItems.isEmpty {
            return preferredItems
        }

        return cityItems
            .filter { $0.pageID.contains("-place-") }
            .filter { !lowPriorityCityOverviewText($0.title, $0.subtitle) }
            .prefix(8)
            .map(\.phraseItem)
    }

    private static func cityQuickPhraseItems(for cityID: String, cityItems: [BrowseCityCollectionItem]) -> [BrowseSearchPhraseItem] {
        let preferredIDs: [String] = {
            switch cityID {
            case "danang":
                return [
                    "city-danang-to-airport",
                    "transport-stop-here-clearer",
                    "directions-8",
                    "ves-call-taxi-for-me",
                ]
            default:
                return []
            }
        }()

        var items = pageItems(forPhraseIDs: preferredIDs)
            .filter(shouldSurfacePhraseItemInBrowse)
        if let bathroom = BrowseSearchPhraseItem.resolve(pageID: "viet-family-bathroom-where") {
            items.append(bathroom)
        }

        if !items.isEmpty {
            return Array(uniquePhraseItems(items).prefix(5))
        }

        let fallback = cityItems
            .filter { $0.subcategoryID == "arrivals-routes" || $0.subcategoryID == "practical-help-near-places" }
            .filter(shouldSurfaceCityItemInBrowse)
            .filter { !lowPriorityCityOverviewText($0.title, $0.subtitle) }
            .prefix(5)
            .map(\.phraseItem)

        return Array(uniquePhraseItems(fallback).prefix(5))
    }

    private static func cityBrowseGroups(
        for cityID: String,
        tintName: AccentTint,
        groupedItems: [String: [BrowseCityCollectionItem]]
    ) -> [BrowseCollectionSubcategory] {
        let specs: [CityBrowseGroupSpec] = [
            CityBrowseGroupSpec(
                id: "landmarks",
                title: "Landmarks",
                subtitle: "Sights, temples, museums",
                symbolName: "building.columns.fill",
                placeKinds: ["landmark", "attraction", "museum"]
            ),
            CityBrowseGroupSpec(
                id: "restaurants",
                title: "Restaurants",
                subtitle: "Named dining stops",
                symbolName: "fork.knife",
                placeKinds: ["restaurant"]
            ),
            CityBrowseGroupSpec(
                id: "cafes",
                title: "Cafes",
                subtitle: "Coffee shops and tea stops",
                symbolName: "cup.and.saucer.fill",
                placeKinds: ["cafe"]
            ),
            CityBrowseGroupSpec(
                id: "dishes",
                title: "Food & drinks",
                subtitle: "Dishes, drinks, and sweets",
                symbolName: "takeoutbag.and.cup.and.straw.fill",
                placeKinds: ["dish", "drink", "dessert"]
            ),
            CityBrowseGroupSpec(
                id: "neighborhoods",
                title: "Neighborhoods",
                subtitle: "Areas and districts",
                symbolName: "map.fill",
                placeKinds: ["neighborhood"]
            ),
            CityBrowseGroupSpec(
                id: "streets",
                title: "Streets",
                subtitle: "Street names and drop-off",
                symbolName: "signpost.right.fill",
                placeKinds: ["street"]
            ),
            CityBrowseGroupSpec(
                id: "markets",
                title: "Markets",
                subtitle: "Markets and shopping stops",
                symbolName: "bag.fill",
                placeKinds: ["market"]
            ),
            CityBrowseGroupSpec(
                id: "beaches-nature",
                title: "Beaches & nature",
                subtitle: "Beaches, parks, rivers",
                symbolName: "water.waves",
                placeKinds: ["beach", "nature", "park", "river", "village"]
            ),
            CityBrowseGroupSpec(
                id: "tours",
                title: "Tours",
                subtitle: "Cruises, shows, day trips",
                symbolName: "ticket.fill",
                placeKinds: ["experience"]
            ),
            CityBrowseGroupSpec(
                id: "arrivals",
                title: "Arrivals",
                subtitle: "Airports, stations, ports",
                symbolName: "airplane.arrival",
                placeKinds: ["airport", "station", "port"]
            ),
        ]

        let entityRows = groupedItems.values.flatMap { $0 }
        return specs.compactMap { spec in
            let items = cityBrowseEntityItems(from: entityRows, matching: spec.placeKinds)
            guard !items.isEmpty else {
                return nil
            }

            return BrowseCollectionSubcategory(
                id: "\(cityID).browse.\(spec.id)",
                title: spec.title,
                subtitle: spec.subtitle,
                symbolName: spec.symbolName,
                tintName: tintName,
                phraseCount: items.count,
                items: items.map(\.phraseItem),
                targetRoute: nil
            )
        }
    }

    private static func cityBrowseEntityItems(
        from rows: [BrowseCityCollectionItem],
        matching placeKinds: Set<String>
    ) -> [BrowseCityCollectionItem] {
        rows
            .filter { item in
                isBrowseEntityPageKind(item.pageKind)
                    && placeKinds.contains(item.placeKind)
                    && !lowPriorityCityOverviewText(item.title, item.subtitle)
            }
            .sorted { left, right in
                if placeKindSortPriority(left) != placeKindSortPriority(right) {
                    return placeKindSortPriority(left) < placeKindSortPriority(right)
                }

                if entitySortPriority(left) != entitySortPriority(right) {
                    return entitySortPriority(left) < entitySortPriority(right)
                }

                if left.title.localizedCaseInsensitiveCompare(right.title) != .orderedSame {
                    return left.title.localizedCaseInsensitiveCompare(right.title) == .orderedAscending
                }

                return left.pageID < right.pageID
            }
    }

    private static func placeKindSortPriority(_ item: BrowseCityCollectionItem) -> Int {
        switch item.placeKind {
        case "airport":
            return 0
        case "station":
            return 1
        case "port":
            return 2
        default:
            return 10
        }
    }

    private static func isBrowseEntityPageKind(_ pageKind: String) -> Bool {
        ["place", "restaurant", "dish", "drink", "dessert"].contains(pageKind)
    }

    private static func entitySortPriority(_ item: BrowseCityCollectionItem) -> Int {
        switch item.pageKind {
        case "place":
            return 0
        case "restaurant":
            return 1
        case "drink":
            return 2
        case "dessert":
            return 3
        case "dish":
            return 4
        default:
            return 9
        }
    }

    private static func cityNameAudioItem(for cityID: String, city: BrowseCityShortcut) -> BrowseCityNameAudioItem {
        let vietnameseName = cityVietnameseName(for: cityID)
        return BrowseCityNameAudioItem(
            title: vietnameseName,
            subtitle: city.title,
            audioKey: AudioAssetManifest.main?.audioKey(forExactText: vietnameseName),
            tintName: city.tintName
        )
    }

    private static func cityVietnameseName(for cityID: String) -> String {
        switch cityID {
        case "danang":
            return "Đà Nẵng"
        case "hanoi":
            return "Hà Nội"
        case "hcmc":
            return "Sài Gòn"
        case "hoian":
            return "Hội An"
        case "hue":
            return "Huế"
        default:
            return cityShortcuts.first(where: { $0.id == cityID })?.title ?? cityID
        }
    }

    private static func pageItems(forPhraseIDs phraseIDs: [String]) -> [BrowseSearchPhraseItem] {
        phraseIDs.compactMap { phraseID in
            BrowseSearchPhraseItem.resolve(pageID: "viet-family-\(phraseID)")
        }
    }

    private static func pageItems(forOpenablePageIDs pageIDs: [String]) -> [BrowseSearchPhraseItem] {
        pageIDs.compactMap(BrowseSearchPhraseItem.resolve(pageID:))
    }

    private static func uniquePhraseItems(_ items: [BrowseSearchPhraseItem]) -> [BrowseSearchPhraseItem] {
        var seen = Set<String>()
        return items.filter { item in
            seen.insert(item.pageID).inserted
        }
    }

    private static func lowPriorityCityOverviewText(_ title: String, _ subtitle: String) -> Bool {
        let text = normalize("\(title) \(subtitle)")
        return text.contains("cang tien sa")
            || text.contains("tien sa port")
            || text.contains("atm near")
            || text.contains("eat near")
            || text.contains("reservation")
    }

    private static func cityCollectionItems(for cityID: String) -> [BrowseCityCollectionItem] {
        if let cachedItems = cityCollectionItemCache[cityID] {
            return cachedItems
        }

        let rows = (try? VietSQLiteLanguagePackRepository.bundled().loadBrowseCityCollectionItems(cityID: cityID, limit: 240))
            ?? fallbackCityCollectionItems(for: cityID)
        cityCollectionItemCache[cityID] = rows
        return rows
    }

    private static func fallbackCityCollectionItems(for cityID: String) -> [BrowseCityCollectionItem] {
        PhraseCatalog.items(selectedCategoryID: "city-guides")
            .filter { $0.pageID.contains("city-\(cityID)-") }
            .prefix(80)
            .map { item in
                let pageKind = item.pageID.contains("-place-") ? "place" : "phrase"
                return BrowseCityCollectionItem(
                    pageID: item.pageID,
                    title: item.title,
                    subtitle: item.subtitle,
                    categoryIDs: item.categoryIDs,
                    symbolName: item.symbolName,
                    tintName: item.tintName,
                    audioKey: item.audioKey,
                    cityID: cityID,
                    cityName: cityShortcuts.first(where: { $0.id == cityID })?.title ?? cityID,
                    subcategoryID: "arrivals-routes",
                    subcategoryTitle: "Arrivals and routes",
                    pageKind: pageKind,
                    placeKind: pageKind == "place" ? fallbackPlaceKind(for: item) : "",
                    imageName: BrowseSearchPhraseItem.resolve(pageID: item.pageID)?.imageName
                )
            }
    }

    private static func fallbackPlaceKind(for item: PhraseCatalogItem) -> String {
        let text = normalize("\(item.pageID) \(item.title) \(item.subtitle)")

        if text.contains("airport") {
            return "airport"
        }

        if text.contains("station") {
            return "station"
        }

        if text.contains("port") {
            return "port"
        }

        if text.contains("street") {
            return "street"
        }

        if text.contains("market") {
            return "market"
        }

        if text.contains("cafe") || text.contains("coffee") || text.contains("restaurant") {
            return "restaurant"
        }

        if text.contains("beach") {
            return "beach"
        }

        if text.contains("park") {
            return "park"
        }

        if text.contains("river") || text.contains("lake") {
            return "river"
        }

        return "landmark"
    }

    private static func categorySubcategories(
        for collectionID: String,
        categoryIDs: [String],
        tintName: AccentTint
    ) -> [BrowseCollectionSubcategory] {
        let specs = subcategorySpecs[collectionID] ?? categoryIDs.map { categoryID in
            CollectionSubcategorySpec(
                id: categoryID,
                title: PhraseCatalog.category(withID: categoryID)?.title ?? collectionTitle(for: categoryID, fallback: categoryID),
                subtitle: "Useful phrases",
                categoryIDs: [categoryID],
                terms: [],
                symbolName: PhraseCatalog.category(withID: categoryID)?.symbolName ?? "ellipsis.bubble"
            )
        }

        return specs.compactMap { spec in
            let rows = items(categoryIDs: spec.categoryIDs, matchingTerms: spec.terms, limit: 12)
            let phraseCount = spec.terms.isEmpty ? itemCount(categoryIDs: spec.categoryIDs) : rows.count

            guard phraseCount > 0 || !rows.isEmpty else {
                return nil
            }

            return BrowseCollectionSubcategory(
                id: "\(collectionID).\(spec.id)",
                title: spec.title,
                subtitle: spec.subtitle,
                symbolName: spec.symbolName,
                tintName: tintName,
                phraseCount: max(phraseCount, rows.count),
                imageName: subcategoryImageName(for: collectionID, specID: spec.id),
                items: rows
            )
        }
    }

    private static func categoryEntityContent(
        for collectionID: String,
        tintName: AccentTint
    ) -> (starterTitle: String, starterItems: [BrowseSearchPhraseItem], subcategories: [BrowseCollectionSubcategory])? {
        let specs = categoryEntityGroupSpecs(for: collectionID)
        guard !specs.isEmpty else {
            return nil
        }

        let allKinds = Set(specs.flatMap(\.placeKinds))
        let starterItems = categoryEntityStarterItems(
            for: collectionID,
            matching: allKinds,
            limit: 8
        )
        let entitySubcategories = specs.compactMap { spec -> BrowseCollectionSubcategory? in
            let totalCount = categoryEntityRows(matching: spec.placeKinds).count
            let items = categoryEntityItems(
                matching: spec.placeKinds,
                preferredPageIDs: spec.preferredPageIDs,
                limit: 12
            )

            guard totalCount > 0 || !items.isEmpty else {
                return nil
            }

            return BrowseCollectionSubcategory(
                id: "\(collectionID).entity.\(spec.id)",
                title: spec.title,
                subtitle: spec.subtitle,
                symbolName: spec.symbolName,
                tintName: tintName,
                phraseCount: max(totalCount, items.count),
                countUnit: "item",
                items: items
            )
        }
        let supplementalSubcategories = categoryEntitySupplementalPhraseSubcategories(
            for: collectionID,
            tintName: tintName
        )
        let subcategories = categoryEntitySubcategories(
            entitySubcategories,
            inserting: supplementalSubcategories,
            for: collectionID
        )

        guard !starterItems.isEmpty || !subcategories.isEmpty else {
            return nil
        }

        return (
            starterTitle: categoryEntityStarterTitle(for: collectionID),
            starterItems: starterItems.isEmpty ? Array(subcategories.flatMap(\.items).prefix(8)) : starterItems,
            subcategories: subcategories
        )
    }

    private static func categoryEntitySupplementalPhraseSubcategories(
        for collectionID: String,
        tintName: AccentTint
    ) -> [BrowseCollectionSubcategory] {
        switch collectionID {
        case "food", "food-coffee":
            let coffeeRows = foodCoffeePhraseRows()
            let dishRows = foodDishPhraseRows()
            let orderRows = foodOrderAdjustPhraseRows()
            let dietRows = foodDietPhraseRows()
            let payingRows = foodPayingPhraseRows()
            return [
                BrowseCollectionSubcategory(
                    id: "\(collectionID).phrases.coffee-drinks",
                    title: "Order drinks",
                    subtitle: "Coffee, tea, water, and adjustments",
                    symbolName: "cup.and.saucer.fill",
                    tintName: tintName,
                    phraseCount: coffeeRows.count,
                    items: coffeeRows
                ),
                BrowseCollectionSubcategory(
                    id: "\(collectionID).phrases.local-dishes",
                    title: "Order dishes",
                    subtitle: "Pho, banh mi, bun cha, and portions",
                    symbolName: "takeoutbag.and.cup.and.straw.fill",
                    tintName: tintName,
                    phraseCount: dishRows.count,
                    items: dishRows
                ),
                BrowseCollectionSubcategory(
                    id: "\(collectionID).phrases.order-adjust",
                    title: "Adjust the order",
                    subtitle: "Menu, portions, spice, ice, sugar",
                    symbolName: "menucard.fill",
                    tintName: tintName,
                    phraseCount: orderRows.count,
                    items: orderRows
                ),
                BrowseCollectionSubcategory(
                    id: "\(collectionID).phrases.allergies-diet",
                    title: "Allergies & diet",
                    subtitle: "Ingredients, peanuts, meat, spice",
                    symbolName: "exclamationmark.circle.fill",
                    tintName: tintName,
                    phraseCount: dietRows.count,
                    items: dietRows
                ),
                BrowseCollectionSubcategory(
                    id: "\(collectionID).phrases.paying",
                    title: "Paying",
                    subtitle: "Bill, card, cash, receipt",
                    symbolName: "dongsign.circle.fill",
                    tintName: tintName,
                    phraseCount: payingRows.count,
                    items: payingRows
                ),
            ].filter { !$0.items.isEmpty }
        default:
            return []
        }
    }

    private static func foodCoffeePhraseRows() -> [BrowseSearchPhraseItem] {
        let nounRows = foodNounItems([
            (
                pageID: "viet-family-food-coffee-black",
                title: "Cà phê đen",
                subtitle: "Black coffee",
                audioKey: "breakdown-authored-ca-phe-den-855822aaf3"
            ),
            (
                pageID: "viet-family-food-coffee-milk",
                title: "Cà phê sữa",
                subtitle: "Milk coffee",
                audioKey: "breakdown-authored-ca-phe-sua-617d03a211"
            ),
            (
                pageID: "viet-family-food-coffee-bac-xiu",
                title: "Bạc xỉu",
                subtitle: "Sweet milk coffee",
                audioKey: nil
            ),
        ])
        let followUpRows = pageItems(forOpenablePageIDs: [
            "viet-family-food-coffee-black",
            "viet-family-food-coffee-milk",
            "viet-family-food-coffee-bac-xiu",
            "viet-family-v900-food-drin-one-hot-coffee-please",
            "viet-family-food-bottled-water",
            "viet-family-service-water",
            "viet-family-v900-food-drin-one-sugarcane-juice-please",
            "viet-family-v900-food-drin-one-fresh-coconut-please",
        ])
        let matchingDrinkRows = items(
            categoryIDs: ["food-drink"],
            matchingTerms: ["coffee", "tea", "water", "drink"],
            limit: 12
        )

        return Array(uniquePhraseItems(nounRows + followUpRows + matchingDrinkRows).prefix(12))
    }

    private static func foodDishPhraseRows() -> [BrowseSearchPhraseItem] {
        let nounRows = foodNounItems([
            (
                pageID: "viet-family-ves-order-pho-bowl",
                title: "Phở",
                subtitle: "Vietnamese noodle soup",
                audioKey: "breakdown-v500-food-drin-id-like-a-bowl-of-ph-please-piece-7"
            ),
            (
                pageID: "viet-family-v500-food-drin-id-like-a-b-nh-m-please",
                title: "Bánh mì",
                subtitle: "Vietnamese sandwich",
                audioKey: nil
            ),
            (
                pageID: "viet-family-ves-order-bun-bo-hue-bowl",
                title: "Bún bò Huế",
                subtitle: "Hue beef noodle soup",
                audioKey: "audio-authored-bun-bo-hue-d24e6940ff"
            ),
            (
                pageID: "viet-family-ves-order-cao-lau-portion",
                title: "Cao lầu",
                subtitle: "Hoi An noodle dish",
                audioKey: nil
            ),
            (
                pageID: "viet-family-city-danang-place-banh-xeo",
                title: "Bánh xèo",
                subtitle: "Crispy savory pancake",
                audioKey: nil
            ),
        ])
        let followUpRows = pageItems(forOpenablePageIDs: [
            "viet-family-ves-order-pho-bowl",
            "viet-family-v500-food-drin-id-like-a-b-nh-m-please",
            "viet-family-ves-order-bun-bo-hue-bowl",
            "viet-family-ves-order-bun-cha-portion",
            "viet-family-ves-order-cao-lau-portion",
            "viet-family-city-danang-place-banh-xeo",
            "viet-family-city-hanoi-place-pho-bo",
            "viet-family-food-vegetarian",
            "viet-family-food-one-portion",
        ])

        return Array(uniquePhraseItems(nounRows + followUpRows).prefix(12))
    }

    private static func foodOrderAdjustPhraseRows() -> [BrowseSearchPhraseItem] {
        let preferredRows = pageItems(forOpenablePageIDs: [
            "viet-family-food-menu",
            "viet-family-food-one-portion",
            "viet-family-food-this-bowl",
            "viet-family-food-less-ice",
            "viet-family-food-no-sugar",
            "viet-family-food-not-spicy",
            "viet-family-food-more-herbs",
            "viet-family-food-pack-to-go",
            "viet-family-v900-food-drin-what-do-you-recommend",
            "viet-family-v900-food-drin-what-is-not-too-spicy",
        ])
        let fallbackRows = items(
            categoryIDs: ["food-drink"],
            matchingTerms: ["menu", "portion", "bowl", "order", "spicy", "ice", "sugar", "to go", "recommend"],
            limit: 12
        )

        return Array(uniquePhraseItems(preferredRows + fallbackRows).prefix(12))
    }

    private static func foodDietPhraseRows() -> [BrowseSearchPhraseItem] {
        let preferredRows = pageItems(forOpenablePageIDs: [
            "viet-family-food-peanut-allergy",
            "viet-family-food-vegetarian",
            "viet-family-food-has-peanuts",
            "viet-family-food-no-meat",
            "viet-family-food-without-this-ingredient",
            "viet-family-food-too-spicy-now",
            "viet-family-food-which-dish-safe",
            "viet-family-food-has-meat-in-it",
            "viet-family-v500-food-drin-does-this-contain-shrimp",
            "viet-family-v500-food-drin-i-am-allergic-to-shellfish",
        ])
        let fallbackRows = items(
            categoryIDs: ["food-drink", "health-pharmacy"],
            matchingTerms: ["allergy", "allergic", "vegetarian", "peanut", "meat", "ingredient", "spicy", "shrimp", "shellfish"],
            limit: 12
        )

        return Array(uniquePhraseItems(preferredRows + fallbackRows).prefix(12))
    }

    private static func foodPayingPhraseRows() -> [BrowseSearchPhraseItem] {
        let preferredRows = pageItems(forOpenablePageIDs: [
            "viet-family-food-pay-now",
            "viet-family-food-split-bill",
            "viet-family-shopping-card",
            "viet-family-service-receipt",
            "viet-family-money-cash-only",
            "viet-family-money-how-much",
        ])
        let fallbackRows = items(
            categoryIDs: ["money-numbers-prices", "food-drink"],
            matchingTerms: ["bill", "pay", "card", "cash", "receipt", "separately", "how much"],
            limit: 12
        )

        return Array(uniquePhraseItems(preferredRows + fallbackRows).prefix(12))
    }

    private static func categoryEntitySubcategories(
        _ entitySubcategories: [BrowseCollectionSubcategory],
        inserting supplementalSubcategories: [BrowseCollectionSubcategory],
        for collectionID: String
    ) -> [BrowseCollectionSubcategory] {
        guard !supplementalSubcategories.isEmpty else {
            return entitySubcategories
        }

        switch collectionID {
        case "food", "food-coffee":
            return supplementalSubcategories + entitySubcategories
        default:
            return entitySubcategories + supplementalSubcategories
        }
    }

    private static func categoryEntityStarterItems(
        for collectionID: String,
        matching placeKinds: Set<String>,
        limit: Int
    ) -> [BrowseSearchPhraseItem] {
        switch collectionID {
        case "food", "food-coffee":
            let coffeeRows = foodCoffeePhraseRows()
            let dishRows = foodDishPhraseRows()
            let nounForwardRows = Array(coffeeRows.prefix(3)) + Array(dishRows.prefix(5))
            return Array(uniquePhraseItems(nounForwardRows + coffeeRows + dishRows).prefix(limit))
        default:
            return categoryEntityItems(
                matching: placeKinds,
                preferredPageIDs: categoryEntityStarterPreferredPageIDs(for: collectionID),
                limit: limit
            )
        }
    }

    private static func categoryEntityRows(matching placeKinds: Set<String>) -> [BrowseCityCollectionItem] {
        let rows = cityShortcuts
            .filter { $0.id != "all-vietnam" }
            .flatMap { cityCollectionItems(for: $0.id) }

        return cityBrowseEntityItems(from: rows, matching: placeKinds)
    }

    private static func categoryEntityItems(
        matching placeKinds: Set<String>,
        preferredPageIDs: [String],
        limit: Int
    ) -> [BrowseSearchPhraseItem] {
        let preferredItems = pageItems(forOpenablePageIDs: preferredPageIDs)
        let fallbackItems = categoryEntityRows(matching: placeKinds).map(\.phraseItem)

        return Array(uniquePhraseItems(preferredItems + fallbackItems).prefix(limit))
    }

    private static func foodNounItems(
        _ specs: [(pageID: String, title: String, subtitle: String, audioKey: String?)]
    ) -> [BrowseSearchPhraseItem] {
        specs.compactMap { spec in
            guard let resolved = BrowseSearchPhraseItem.resolve(pageID: spec.pageID) else {
                return nil
            }

            return BrowseSearchPhraseItem(
                pageID: resolved.pageID,
                title: spec.title,
                subtitle: spec.subtitle,
                symbolName: resolved.symbolName,
                tintName: resolved.tintName,
                audioKey: spec.audioKey
            )
        }
    }

    private static func categoryExploreShelves(
        collectionID: String,
        categoryIDs: [String],
        excluding excludedPageIDs: [String]
    ) -> [BrowseCollectionShelf] {
        let excluded = Set(excludedPageIDs)
        return categoryIDs.compactMap { categoryID in
            let rows = PhraseCatalog.items(selectedCategoryID: categoryID)
                .filter(shouldSurfaceCatalogItemInBrowse)
                .filter { !excluded.contains($0.pageID) }
                .prefix(6)
                .map { item in
                    BrowseSearchPhraseItem(
                        pageID: item.pageID,
                        title: item.title,
                        subtitle: item.subtitle,
                        symbolName: item.symbolName,
                        tintName: item.tintName,
                        audioKey: item.playbackAudioKey
                    )
                }

            guard !rows.isEmpty else {
                return nil
            }

            let title = PhraseCatalog.category(withID: categoryID)?.title ?? collectionTitle(for: categoryID, fallback: categoryID)
            return BrowseCollectionShelf(
                id: "category.\(categoryID)",
                title: title,
                subtitle: "More useful phrases",
                items: Array(rows),
                targetRoute: categoryID == collectionID ? nil : .category(categoryID)
            )
        }
        .prefix(4)
        .map { $0 }
    }

    private static func starterItems(categoryIDs: [String], preferredPageIDs: [String], limit: Int) -> [BrowseSearchPhraseItem] {
        var seen = Set<String>()
        var rows: [BrowseSearchPhraseItem] = []

        for item in preferredPageIDs.compactMap(BrowseSearchPhraseItem.resolve(pageID:)) {
            guard shouldSurfacePhraseItemInBrowse(item) else {
                continue
            }

            guard seen.insert(item.pageID).inserted else {
                continue
            }
            rows.append(item)
            if rows.count >= limit {
                return rows
            }
        }

        for item in items(categoryIDs: categoryIDs, limit: limit * 3) {
            guard seen.insert(item.pageID).inserted else {
                continue
            }
            rows.append(item)
            if rows.count >= limit {
                return rows
            }
        }

        return rows
    }

    private static func items(categoryIDs: [String], matchingTerms terms: [String], limit: Int) -> [BrowseSearchPhraseItem] {
        let normalizedTerms = terms.map(normalize)
        var seen = Set<String>()
        var rows: [BrowseSearchPhraseItem] = []

        for categoryID in categoryIDs {
            for item in PhraseCatalog.items(selectedCategoryID: categoryID) {
                guard shouldSurfaceCatalogItemInBrowse(item) else {
                    continue
                }

                guard seen.insert(item.pageID).inserted else {
                    continue
                }

                if !normalizedTerms.isEmpty {
                    let haystack = normalize("\(item.title) \(item.subtitle) \(item.pageID)")
                    guard normalizedTerms.contains(where: { haystack.contains($0) }) else {
                        continue
                    }
                }

                rows.append(
                    BrowseSearchPhraseItem(
                        pageID: item.pageID,
                        title: item.title,
                        subtitle: item.subtitle,
                        symbolName: item.symbolName,
                        tintName: item.tintName,
                        audioKey: item.playbackAudioKey
                    )
                )

                if rows.count >= limit {
                    return rows
                }
            }
        }

        return rows
    }

    private static let derivedPlacePhraseCategoryID = "derived-place-phrases"

    private static let derivedPlacePhraseActionTokens: Set<String> = [
        "address",
        "atm",
        "direction",
        "directions",
        "drop",
        "eat",
        "find",
        "get",
        "go",
        "near",
        "nearby",
        "off",
        "pickup",
        "stop",
        "take",
        "taxi",
        "there",
        "to",
        "where",
    ]

    private static func shouldSurfaceCatalogItemInBrowse(_ item: PhraseCatalogItem) -> Bool {
        !item.categoryIDs.contains(derivedPlacePhraseCategoryID)
    }

    private static func shouldSurfaceCityItemInBrowse(_ item: BrowseCityCollectionItem) -> Bool {
        !item.categoryIDs.contains(derivedPlacePhraseCategoryID)
    }

    private static func shouldSurfacePhraseItemInBrowse(_ item: BrowseSearchPhraseItem) -> Bool {
        !isDerivedPlacePhrase(pageID: item.pageID)
    }

    private static func isDerivedPlacePhrase(pageID: String) -> Bool {
        PhraseCatalog.categoryIDs(forPageID: pageID).contains(derivedPlacePhraseCategoryID)
    }

    private static func allowsDerivedPlacePhraseSearchResults(for query: String) -> Bool {
        let tokens = Set(normalize(query).split(separator: " ").map(String.init))
        return !tokens.intersection(derivedPlacePhraseActionTokens).isEmpty
    }

    private static func mastheadImageName(for route: BrowseCollectionRoute) -> String {
        switch route {
        case .category(let id):
            return categoryMastheadImages[id] ?? "HeroVietnamMasthead"
        case .city(let id):
            return cityMastheadImages[id] ?? "HeroVietnamMasthead"
        }
    }

    private static func collectionTextMatches(query normalizedQuery: String, text: String) -> Bool {
        let searchText = normalize(text)
        return searchText.contains(normalizedQuery)
            || normalizedQuery.split(separator: " ").allSatisfy { searchText.contains($0) }
    }

    private static func collectionTextMatches(queries normalizedQueries: [String], text: String) -> Bool {
        normalizedQueries.contains { collectionTextMatches(query: $0, text: text) }
    }

    private static func uniqueRoutes(_ routes: [BrowseCollectionRoute]) -> [BrowseCollectionRoute] {
        var seen = Set<BrowseCollectionRoute>()
        return routes.filter { route in
            seen.insert(route).inserted
        }
    }

    private static func cityPracticeAction(for cityID: String) -> BrowseCollectionPracticeAction {
        switch cityID {
        case "hcmc":
            return .practiceMode(.hcmcCity)
        case "hanoi":
            return .practiceMode(.hanoiBucketList)
        case "danang":
            return .practiceMode(.danangCity)
        case "hoian":
            return .practiceMode(.hoianCity)
        case "hue":
            return .practiceMode(.hueCity)
        default:
            return .addStarterPages([])
        }
    }

    private static func collectionTitle(for id: String, fallback: String) -> String {
        switch id {
        case "getting-around":
            return "Getting Around"
        case "local-greetings":
            return "Local Greetings"
        case "city-guides":
            return "All Vietnam"
        case "food-coffee":
            return "Food & Cafes"
        case "landmarks-attractions":
            return "Landmarks"
        case "neighborhoods-streets":
            return "Streets & Neighborhoods"
        default:
            return fallback
        }
    }

    private static func collectionSubtitle(for id: String, fallback: String) -> String {
        switch id {
        case "airport":
            return "Arrival, passport, bags, taxis, SIM cards, and airport help."
        case "hotel":
            return "Check in, leave bags, fix room issues, ask breakfast times, and check out."
        case "food":
            return "Restaurant and cafe phrases for tables, ordering, allergies, and paying."
        case "shopping":
            return "Ask prices, sizes, receipts, returns, and payment questions."
        case "getting-around":
            return "Taxis, buses, walking directions, stops, maps, and addresses."
        case "emergency":
            return "Calm help, health, safety, and problem-solving phrases."
        case "everyday-services":
            return "The practical trip phrases for bathrooms, water, laundry, phone help, rain, and small service counters."
        case "tours-sights":
            return "Tickets, entrances, meeting points, guides, photos, and tour details."
        case "local-greetings":
            return "Relationship-aware hellos and warm local openers."
        case "city-guides":
            return "City phrases for arrival, landmarks, streets, food, and everyday help."
        case "food-coffee":
            return "Restaurants, cafes, markets, and local dishes by city."
        case "landmarks-attractions":
            return "Landmarks, markets, museums, beaches, and nature stops before phrase depth."
        case "neighborhoods-streets":
            return "Neighborhood and street names first, then directions and drop-off phrases."
        default:
            return fallback
        }
    }

    private static func categoryEntityTitle(for id: String) -> String? {
        switch id {
        case "food-coffee":
            return "Food & Cafes"
        case "landmarks-attractions":
            return "Landmarks"
        case "neighborhoods-streets":
            return "Streets & Neighborhoods"
        default:
            return nil
        }
    }

    private static func categoryEntitySubtitle(for id: String) -> String? {
        switch id {
        case "food-coffee":
            return "Restaurants, cafes, markets, and local dishes by city."
        case "landmarks-attractions":
            return "Landmarks, markets, museums, beaches, and nature stops before phrase depth."
        case "neighborhoods-streets":
            return "Neighborhood and street names first, then directions and drop-off phrases."
        default:
            return nil
        }
    }

    private static func categoryEntitySymbolName(for id: String) -> String? {
        switch id {
        case "food-coffee":
            return "cup.and.saucer.fill"
        case "landmarks-attractions":
            return "building.columns.fill"
        case "neighborhoods-streets":
            return "signpost.right.fill"
        default:
            return nil
        }
    }

    private static func categoryEntityTint(for id: String) -> AccentTint? {
        switch id {
        case "food-coffee":
            return .orange
        case "landmarks-attractions", "neighborhoods-streets":
            return .green
        default:
            return nil
        }
    }

    private static func starterTitle(for id: String) -> String {
        switch id {
        case "airport":
            return "Good first phrases"
        case "food":
            return "Start at the table"
        case "hotel":
            return "At the hotel desk"
        default:
            return "Start here"
        }
    }

    private static func categoryMessageSectionTitle(for id: String, title: String) -> String? {
        switch id {
        case "airport":
            return "Airport"
        case "hotel":
            return "Hotel"
        case "food":
            return "Food"
        case "getting-around", "transport":
            return "Getting Around"
        case "shopping":
            return "Shopping"
        case "emergency":
            return "Emergency"
        case "local-greetings", "greetings":
            return "Local Greetings"
        default:
            return PracticeScenarioID.messageSectionTitles.contains(title) ? title : nil
        }
    }

    private static func practiceSubtitle(for title: String) -> String {
        if title == "Shopping" {
            return "Prices, sizes, payment, and returns."
        }
        if title == "Emergency" {
            return "Ask for help calmly."
        }

        return "A quick \(title.lowercased()) conversation."
    }

    private static func categoryPracticeAction(for id: String, starterPageIDs: [String]) -> BrowseCollectionPracticeAction {
        switch id {
        case "airport":
            return .practiceSource("topic:airport")
        default:
            return .addStarterPages(starterPageIDs)
        }
    }

    private static func messageEntryTitle(for title: String) -> String {
        "\(title) messages"
    }

    private static func cityPracticeTitle(for id: String, title: String) -> String {
        switch id {
        case "danang":
            return "Da Nang day"
        case "hanoi":
            return "Hanoi day"
        case "hcmc":
            return "Saigon day"
        case "hoian":
            return "Hoi An day"
        case "hue":
            return "Hue day"
        default:
            return "\(title) messages"
        }
    }

    private static func cityPracticeSubtitle(for id: String) -> String {
        switch id {
        case "danang":
            return "Beach roads, bridge names, seafood, markets, and mountain trips."
        case "hanoi":
            return "Old Quarter lanes, lakes, coffee, temple courtyards, and northern food."
        case "hcmc":
            return "District 1, markets, coffee, river lights, and late food."
        case "hoian":
            return "Lantern streets, river boats, old houses, markets, and villages."
        case "hue":
            return "Imperial gates, river pagodas, tomb roads, incense, and local food."
        default:
            return "Food, places, city names, and useful phrases before you land."
        }
    }

    private static func citySubtitle(for id: String) -> String {
        switch id {
        case "hcmc":
            return "Start with Saigon's airport, District 1, markets, cafes, and fast-moving street life."
        case "hanoi":
            return "Old Quarter lanes, lakes, northern food, coffee stops, and calm cultural landmarks."
        case "danang":
            return "Beach mornings, Han River nights, seafood markets, Son Tra, and central Vietnam day trips."
        case "hoian":
            return "Ancient Town walks, lantern streets, tailor stops, cafes, markets, and countryside routes."
        case "hue":
            return "Imperial gates, royal tombs, Perfume River rides, garden houses, and central dishes."
        default:
            return "Arrivals, food, places, streets, and practical help."
        }
    }

    private static func cityIntro(for id: String) -> String {
        switch id {
        case "hcmc":
            return "Saigon comes alive through District 1, coffee, markets, river lights, old civic buildings, and late food in the same long day."
        case "hanoi":
            return "Hanoi comes into focus through shaded lakes, old lanes, temple courtyards, coffee shops, northern dishes, and streets that carry the city one turn at a time."
        case "danang":
            return "Da Nang is the central Vietnam city for beach time, seafood, river bridges, and easy day trips. A first day can move from the airport to My Khe, across the Han River after dark, then toward Son Tra, Marble Mountains, Hoi An, or Ba Na Hills. Learn these names before you land so maps, drivers, and saved plans feel familiar."
        case "hoian":
            return "Hoi An comes into focus through yellow walls, lantern streets, river boats, old houses, tailor stops, markets, beaches, and villages beyond the Ancient Town."
        case "hue":
            return "Hue opens as Vietnam's old royal capital with living rituals: imperial gates, river pagodas, tomb roads, garden houses, markets, incense, and deeply local food."
        default:
            return "Start with the foods, places, city names, and Vietnamese sounds that make the trip feel vivid before you land."
        }
    }

    private struct CollectionSubcategorySpec {
        let id: String
        let title: String
        let subtitle: String
        let categoryIDs: [String]
        let terms: [String]
        let symbolName: String
    }

    private static func subcategoryImageName(for collectionID: String, specID: String) -> String? {
        subcategoryCardImages["\(collectionID).\(specID)"]
    }

    private struct CategoryEntityGroupSpec {
        let id: String
        let title: String
        let subtitle: String
        let symbolName: String
        let placeKinds: Set<String>
        let preferredPageIDs: [String]
    }

    private static func categoryEntityGroupSpecs(for collectionID: String) -> [CategoryEntityGroupSpec] {
        switch collectionID {
        case "food", "food-coffee":
            return [
                CategoryEntityGroupSpec(
                    id: "places-to-eat-drink",
                    title: "Places to eat & drink",
                    subtitle: "Restaurants, cafés, and markets",
                    symbolName: "fork.knife",
                    placeKinds: ["restaurant", "cafe", "market"],
                    preferredPageIDs: [
                        "viet-phrase-city-danang-place-nen",
                        "viet-phrase-city-hcmc-place-anan-saigon",
                        "viet-phrase-city-hanoi-place-bun-cha-huong-lien",
                        "viet-phrase-city-hoian-place-morning-glory-hoi-an",
                        "viet-phrase-city-hanoi-place-giang-cafe",
                        "viet-phrase-city-hoian-place-faifo-coffee",
                        "viet-phrase-city-hoian-place-reaching-out-tea-house",
                        "viet-phrase-city-hcmc-place-ben-thanh-market",
                        "viet-phrase-city-danang-place-con-market",
                        "viet-phrase-city-danang-place-han-market",
                    ]
                ),
            ]
        case "landmarks-attractions":
            return [
                CategoryEntityGroupSpec(
                    id: "landmarks",
                    title: "Landmarks",
                    subtitle: "Sights and famous places",
                    symbolName: "building.columns.fill",
                    placeKinds: ["landmark", "attraction"],
                    preferredPageIDs: [
                        "viet-phrase-city-danang-place-dragon-bridge",
                        "viet-phrase-city-hanoi-place-hoan-kiem",
                        "viet-phrase-city-danang-place-ba-na-hills",
                        "viet-phrase-city-hue-place-imperial-city",
                    ]
                ),
                CategoryEntityGroupSpec(
                    id: "temples-museums",
                    title: "Temples & museums",
                    subtitle: "Cultural stops",
                    symbolName: "building.columns",
                    placeKinds: ["temple", "museum", "pagoda"],
                    preferredPageIDs: [
                        "viet-phrase-city-danang-place-linh-ung-pagoda",
                        "viet-phrase-city-hcmc-place-war-remnants-museum",
                    ]
                ),
                CategoryEntityGroupSpec(
                    id: "markets",
                    title: "Markets",
                    subtitle: "Markets worth hearing",
                    symbolName: "bag.fill",
                    placeKinds: ["market"],
                    preferredPageIDs: [
                        "viet-phrase-city-hcmc-place-ben-thanh-market",
                        "viet-phrase-city-danang-place-con-market",
                        "viet-phrase-city-hanoi-place-dong-xuan-market",
                    ]
                ),
                CategoryEntityGroupSpec(
                    id: "nature",
                    title: "Beaches & nature",
                    subtitle: "Water, parks, and day trips",
                    symbolName: "water.waves",
                    placeKinds: ["beach", "nature", "park", "river", "village"],
                    preferredPageIDs: [
                        "viet-phrase-city-danang-place-my-khe",
                        "viet-phrase-city-danang-place-marble-mountains",
                        "viet-phrase-city-hue-place-perfume-river",
                    ]
                ),
                CategoryEntityGroupSpec(
                    id: "tours",
                    title: "Tours",
                    subtitle: "Cruises, shows, and day trips",
                    symbolName: "ticket.fill",
                    placeKinds: ["experience"],
                    preferredPageIDs: [
                        "viet-phrase-city-danang-place-han-river-cruise",
                        "viet-phrase-city-hoian-place-cam-thanh-basket-boat",
                        "viet-phrase-city-hue-place-perfume-river-dragon-boat",
                    ]
                ),
            ]
        case "neighborhoods-streets":
            return [
                CategoryEntityGroupSpec(
                    id: "neighborhoods",
                    title: "Neighborhoods",
                    subtitle: "Areas and districts",
                    symbolName: "map.fill",
                    placeKinds: ["neighborhood"],
                    preferredPageIDs: [
                        "viet-phrase-city-hcmc-place-district-one",
                        "viet-phrase-city-hoian-place-old-town",
                        "viet-phrase-city-hanoi-place-old-quarter",
                    ]
                ),
                CategoryEntityGroupSpec(
                    id: "streets",
                    title: "Streets",
                    subtitle: "Street names and drop-off",
                    symbolName: "signpost.right.fill",
                    placeKinds: ["street"],
                    preferredPageIDs: [
                        "viet-phrase-city-danang-place-bach-dang-street",
                        "viet-phrase-city-danang-place-nguyen-van-linh-street",
                        "viet-phrase-city-hcmc-place-bui-vien-street",
                    ]
                ),
            ]
        case "getting-around":
            return [
                CategoryEntityGroupSpec(
                    id: "streets",
                    title: "Streets",
                    subtitle: "Street names and drop-off",
                    symbolName: "signpost.right.fill",
                    placeKinds: ["street"],
                    preferredPageIDs: [
                        "viet-phrase-city-danang-place-bach-dang-street",
                        "viet-phrase-city-danang-place-nguyen-van-linh-street",
                        "viet-phrase-city-hcmc-place-bui-vien-street",
                    ]
                ),
                CategoryEntityGroupSpec(
                    id: "airports-stations",
                    title: "Stations",
                    subtitle: "Airports, train stations, ports",
                    symbolName: "tram.fill",
                    placeKinds: ["airport", "station", "port"],
                    preferredPageIDs: [
                        "viet-phrase-city-danang-place-airport",
                        "viet-phrase-city-hanoi-place-airport",
                        "viet-phrase-city-hue-place-train-station",
                    ]
                ),
                CategoryEntityGroupSpec(
                    id: "neighborhoods",
                    title: "Neighborhoods",
                    subtitle: "Areas and districts",
                    symbolName: "map.fill",
                    placeKinds: ["neighborhood"],
                    preferredPageIDs: [
                        "viet-phrase-city-hcmc-place-district-one",
                        "viet-phrase-city-hanoi-place-old-quarter",
                        "viet-phrase-city-hoian-place-old-town",
                    ]
                ),
            ]
        default:
            return []
        }
    }

    private static func categoryEntityStarterPreferredPageIDs(for collectionID: String) -> [String] {
        switch collectionID {
        case "food", "food-coffee":
            return [
                "viet-family-food-coffee-black",
                "viet-family-food-coffee-milk",
                "viet-family-food-coffee-bac-xiu",
                "viet-family-ves-order-pho-bowl",
                "viet-family-v500-food-drin-id-like-a-b-nh-m-please",
                "viet-family-ves-order-bun-bo-hue-bowl",
                "viet-family-city-danang-place-banh-xeo",
            ]
        case "landmarks-attractions":
            return [
                "viet-phrase-city-danang-place-dragon-bridge",
                "viet-phrase-city-hanoi-place-hoan-kiem",
                "viet-phrase-city-hcmc-place-ben-thanh-market",
                "viet-phrase-city-danang-place-ba-na-hills",
                "viet-phrase-city-danang-place-my-khe",
                "viet-phrase-city-hue-place-imperial-city",
                "viet-phrase-city-hoian-place-old-town",
            ]
        case "neighborhoods-streets":
            return [
                "viet-phrase-city-hcmc-place-district-one",
                "viet-phrase-city-hoian-place-old-town",
                "viet-phrase-city-hanoi-place-old-quarter",
                "viet-phrase-city-danang-place-bach-dang-street",
                "viet-phrase-city-danang-place-nguyen-van-linh-street",
                "viet-phrase-city-hcmc-place-bui-vien-street",
            ]
        case "getting-around":
            return [
                "viet-phrase-city-danang-place-bach-dang-street",
                "viet-phrase-city-danang-place-airport",
                "viet-phrase-city-hanoi-place-airport",
                "viet-phrase-city-hcmc-place-district-one",
                "viet-phrase-city-hoian-place-old-town",
            ]
        default:
            return []
        }
    }

    private static func categoryEntityStarterTitle(for collectionID: String) -> String {
        switch collectionID {
        case "food", "food-coffee":
            return "Quick orders"
        case "landmarks-attractions":
            return "Places to know"
        default:
            return "Names to know"
        }
    }

    private static let subcategorySpecs: [String: [CollectionSubcategorySpec]] = [
        "airport": [
            CollectionSubcategorySpec(id: "arrival", title: "Arrival", subtitle: "Get oriented after landing", categoryIDs: ["airport-border-arrival"], terms: ["arrival", "tourism", "passport"], symbolName: "airplane.arrival"),
            CollectionSubcategorySpec(id: "baggage", title: "Baggage", subtitle: "Bags, tags, and lost luggage", categoryIDs: ["airport-border-arrival"], terms: ["bag", "baggage", "luggage"], symbolName: "suitcase.fill"),
            CollectionSubcategorySpec(id: "transport", title: "Transport", subtitle: "Taxi, bus, and pickup", categoryIDs: ["transport", "directions-navigation"], terms: ["taxi", "bus", "pickup"], symbolName: "car.fill"),
            CollectionSubcategorySpec(id: "sim-card", title: "SIM card", subtitle: "SIM, eSIM, data, and Wi-Fi", categoryIDs: ["airport-border-arrival", "phone-internet-power"], terms: ["sim", "esim", "data", "wi-fi", "wifi", "internet"], symbolName: "simcard.fill"),
            CollectionSubcategorySpec(id: "cash", title: "Cash", subtitle: "ATM, cash, cards, and exchange", categoryIDs: ["airport-border-arrival", "money-numbers-prices", "transport"], terms: ["atm", "cash", "card", "money", "exchange", "pay"], symbolName: "banknote.fill"),
        ],
        "hotel": [
            CollectionSubcategorySpec(id: "check-in", title: "Check-in", subtitle: "Reservations and arrival", categoryIDs: ["hotel-accommodation"], terms: ["reservation", "check", "room"], symbolName: "person.crop.circle.badge.checkmark"),
            CollectionSubcategorySpec(id: "luggage", title: "Luggage", subtitle: "Bags before or after your stay", categoryIDs: ["hotel-accommodation"], terms: ["luggage", "bag"], symbolName: "suitcase.fill"),
            CollectionSubcategorySpec(id: "room-help", title: "Room help", subtitle: "Fix room issues politely", categoryIDs: ["hotel-accommodation", "problems-help"], terms: ["room", "quiet", "hot", "help"], symbolName: "bed.double.fill"),
            CollectionSubcategorySpec(id: "checkout", title: "Checkout", subtitle: "Breakfast, bills, and leaving", categoryIDs: ["hotel-accommodation", "time-dates-booking"], terms: ["checkout", "breakfast", "bill"], symbolName: "rectangle.portrait.and.arrow.right"),
        ],
        "food": [
            CollectionSubcategorySpec(id: "ordering", title: "Ordering", subtitle: "Ask for food clearly", categoryIDs: ["food-drink"], terms: ["menu", "order", "water", "food"], symbolName: "menucard.fill"),
            CollectionSubcategorySpec(id: "allergies", title: "Allergies", subtitle: "Ingredients and diet needs", categoryIDs: ["food-drink", "health-pharmacy"], terms: ["allergy", "allergic", "vegetarian", "spicy"], symbolName: "exclamationmark.circle.fill"),
            CollectionSubcategorySpec(id: "paying", title: "Paying", subtitle: "Bills, cards, and cash", categoryIDs: ["money-numbers-prices", "food-drink"], terms: ["bill", "pay", "card", "cash"], symbolName: "dongsign.circle.fill"),
            CollectionSubcategorySpec(id: "drinks", title: "Coffee & drinks", subtitle: "Coffee, tea, and water", categoryIDs: ["food-drink"], terms: ["coffee", "tea", "water", "drink"], symbolName: "cup.and.saucer.fill"),
        ],
        "first-day": [
            CollectionSubcategorySpec(id: "airport", title: "Airport", subtitle: "Arrival, bags, and SIM cards", categoryIDs: ["airport-border-arrival"], terms: [], symbolName: "airplane.arrival"),
            CollectionSubcategorySpec(id: "hotel", title: "Hotel", subtitle: "Check-in and luggage", categoryIDs: ["hotel-accommodation"], terms: [], symbolName: "bed.double.fill"),
            CollectionSubcategorySpec(id: "transport", title: "Transport", subtitle: "Pickup, taxis, and directions", categoryIDs: ["transport", "directions-navigation"], terms: [], symbolName: "car.fill"),
        ],
        "questions": [
            CollectionSubcategorySpec(id: "directions", title: "Directions", subtitle: "Ask how to get there", categoryIDs: ["directions-navigation"], terms: [], symbolName: "location.north.fill"),
            CollectionSubcategorySpec(id: "time", title: "Time", subtitle: "Dates, booking, and hours", categoryIDs: ["time-dates-booking"], terms: [], symbolName: "calendar"),
            CollectionSubcategorySpec(id: "clarify", title: "Clarify", subtitle: "Repeat, slow down, or write it", categoryIDs: ["understanding-repair"], terms: [], symbolName: "questionmark.bubble.fill"),
        ],
        "numbers-money": [
            CollectionSubcategorySpec(id: "payment", title: "Payment", subtitle: "Cards, cash, and QR", categoryIDs: ["money-numbers-prices"], terms: [], symbolName: "creditcard.fill"),
            CollectionSubcategorySpec(id: "shopping", title: "Shopping", subtitle: "Prices, sizes, and receipts", categoryIDs: ["shopping"], terms: [], symbolName: "bag.fill"),
        ],
        "shopping": [
            CollectionSubcategorySpec(id: "prices", title: "Prices", subtitle: "Ask costs and compare", categoryIDs: ["shopping", "money-numbers-prices"], terms: ["price", "cost", "much"], symbolName: "tag.fill"),
            CollectionSubcategorySpec(id: "sizes", title: "Sizes", subtitle: "Sizes, colors, and fit", categoryIDs: ["shopping"], terms: ["size", "color", "fit"], symbolName: "tshirt.fill"),
            CollectionSubcategorySpec(id: "payment", title: "Payment", subtitle: "Cards, cash, and QR", categoryIDs: ["shopping", "money-numbers-prices"], terms: ["pay", "card", "cash", "qr"], symbolName: "creditcard.fill"),
            CollectionSubcategorySpec(id: "receipts", title: "Receipts", subtitle: "Receipts and returns", categoryIDs: ["shopping", "local-services-everyday-tasks"], terms: ["receipt", "return", "exchange"], symbolName: "receipt.fill"),
        ],
        "getting-around": [
            CollectionSubcategorySpec(id: "taxi", title: "Taxi", subtitle: "Pickup and destination", categoryIDs: ["transport"], terms: ["taxi", "ride", "pickup"], symbolName: "car.fill"),
            CollectionSubcategorySpec(id: "bus-train", title: "Bus & train", subtitle: "Stops, tickets, routes", categoryIDs: ["transport"], terms: ["bus", "train", "ticket"], symbolName: "bus.fill"),
            CollectionSubcategorySpec(id: "directions", title: "Directions", subtitle: "Ask how to get there", categoryIDs: ["directions-navigation"], terms: ["where", "direction", "left", "right"], symbolName: "arrow.triangle.turn.up.right.diamond.fill"),
            CollectionSubcategorySpec(id: "maps", title: "Maps", subtitle: "Streets, addresses, and places", categoryIDs: ["directions-navigation"], terms: ["address", "street", "map"], symbolName: "map.fill"),
        ],
        "emergency": [
            CollectionSubcategorySpec(id: "help", title: "Help", subtitle: "Ask for calm assistance", categoryIDs: ["problems-help", "emergency-safety"], terms: ["help", "need"], symbolName: "ellipsis.bubble.fill"),
            CollectionSubcategorySpec(id: "health", title: "Health", subtitle: "Clinic and pharmacy needs", categoryIDs: ["health-pharmacy"], terms: ["doctor", "pharmacy", "medicine"], symbolName: "cross.case.fill"),
            CollectionSubcategorySpec(id: "safety", title: "Safety", subtitle: "Safer travel moments", categoryIDs: ["emergency-safety"], terms: ["safe", "police", "emergency"], symbolName: "shield.fill"),
            CollectionSubcategorySpec(id: "problems", title: "Problems", subtitle: "Lost items, billing, and help", categoryIDs: ["problems-help"], terms: ["lost", "problem", "manager"], symbolName: "wrench.and.screwdriver.fill"),
        ],
        "polite-repair": [
            CollectionSubcategorySpec(id: "clarify", title: "Clarify", subtitle: "Repeat, slow down, or write it", categoryIDs: ["understanding-repair"], terms: [], symbolName: "questionmark.bubble.fill"),
            CollectionSubcategorySpec(id: "polite-basics", title: "Polite basics", subtitle: "Please, sorry, and thank you", categoryIDs: ["polite-basics"], terms: [], symbolName: "hand.wave.fill"),
            CollectionSubcategorySpec(id: "get-help", title: "Get help", subtitle: "Ask for backup when stuck", categoryIDs: ["problems-help"], terms: [], symbolName: "ellipsis.bubble.fill"),
        ],
    ]

    private static let subcategoryCardImages: [String: String] = [
        "airport.arrival": "HeroCityHcmcPlaceTanSonNhatAirport",
        "airport.baggage": "HeroCityHanoiPlaceNoiBaiAirport",
        "airport.transport": "HeroCityDanangPlaceCentralBusStation",
        "airport.sim-card": "HeroCityHcmcPlaceNguyenHueWalkingStreet",
        "airport.cash": "HeroCityHcmcPlaceBenThanhMarket",
        "hotel.check-in": "HeroCityHcmcPlaceRexHotelRooftop",
        "hotel.luggage": "HeroCityHanoiPlaceNoiBaiAirport",
        "hotel.room-help": "HomeScenarioHotel",
        "hotel.checkout": "HeroCityHcmcPlaceDongKhoiStreet",
        "food.ordering": "BackdropMenuFoodBunRieuCua",
        "food.allergies": "HeroMenuFoodGoiCuonChay",
        "food.paying": "HeroCityHcmcPlaceBenThanhMarket",
        "food.drinks": "BackdropMenuDrinkCaPheSuaDa",
        "first-day.airport": "HeroCityHcmcPlaceTanSonNhatAirport",
        "first-day.hotel": "HeroCityHcmcPlaceRexHotelRooftop",
        "first-day.transport": "HeroCityDanangPlaceCentralBusStation",
        "questions.directions": "HeroCityDanangPlaceDragonBridge",
        "questions.time": "HeroCityHanoiPlaceTrainStreet",
        "questions.clarify": "HeroCityHanoiPlaceTheNoteCoffee",
        "numbers-money.payment": "HeroCityHcmcPlaceBenThanhMarket",
        "numbers-money.shopping": "HeroCityHanoiPlaceDongXuanMarket",
        "shopping.prices": "HeroCityHcmcPlaceBenThanhMarket",
        "shopping.sizes": "HeroCityHcmcPlaceRussianMarket",
        "shopping.payment": "HeroCityHanoiPlaceTrangTienPlaza",
        "shopping.receipts": "HeroCityHanoiPlaceDongXuanMarket",
        "getting-around.taxi": "HeroCityHcmcPlaceBachDangWaterbusStation",
        "getting-around.bus-train": "HeroCityDanangPlaceCentralBusStation",
        "getting-around.directions": "HeroCityDanangPlaceDragonBridge",
        "getting-around.maps": "HeroCityHoianPlaceTranPhuStreet",
        "emergency.help": "HeroCityHcmcPlacePasteurStreet",
        "emergency.health": "HeroCityHcmcPlaceLeVanTamPark",
        "emergency.safety": "HeroCityHcmcPlaceBuiVienStreet",
        "emergency.problems": "HeroCityHanoiPlaceNoiBaiAirport",
        "polite-repair.clarify": "HeroCityHanoiPlaceTheNoteCoffee",
        "polite-repair.polite-basics": "HeroCityHanoiPlaceDinhCafe",
        "polite-repair.get-help": "HeroCityHcmcPlacePasteurStreet",
    ]

    private static let categoryMastheadImages: [String: String] = [
        "airport": "HeroCategoryAirport",
        "hotel": "HeroCategoryHotel",
        "food": "HeroCategoryFood",
        "shopping": "HeroCategoryNumbersMoney",
        "everyday-services": "HeroCategoryEssentials",
        "tours-sights": "HeroCategoryQuestions",
        "getting-around": "HeroCategoryGettingAround",
        "first-day": "HeroCategoryFirstDay",
        "city-guides": "HeroCountryVietnam",
        "emergency": "HeroCategoryEmergency",
        "local-greetings": "HeroCategoryGreetings",
        "essentials": "HeroCategoryEssentials",
        "greetings": "HeroCategoryGreetings",
        "questions": "HeroCategoryQuestions",
        "numbers-money": "HeroCategoryNumbersMoney",
        "polite-repair": "HeroCategoryPoliteRepair",
        "food-coffee": "HeroCategoryFood",
        VietnameseMenuKind.food.routeID: "HeroVietnameseFoodMenu",
        VietnameseMenuKind.drink.routeID: "HeroVietnameseDrinkMenu",
        "landmarks-attractions": "HeroCategoryGettingAround",
        "neighborhoods-streets": "HeroCategoryGettingAround",
    ]

    private static let categorySearchAliases: [String: [String]] = [
        "airport": [
            "airport arrival",
            "baggage claim",
            "buy sim card",
            "airport atm",
            "airport pickup",
        ],
        "hotel": [
            "hotel reservation",
            "hotel booking",
            "check in hotel",
            "booked online",
            "hotel passport",
        ],
        "food": [
            "eating out",
            "restaurant phrases",
            "cafe phrases",
            "table at restaurant",
            "order food",
            "pay at restaurant",
            "no peanuts",
            "peanut allergy",
            "does this have peanuts",
            "does this contain",
            "ingredient question",
            "restaurant ordering",
        ],
        VietnameseMenuKind.food.routeID: [
            "food menu",
            "dish menu",
            "dish names",
            "vietnamese menu",
            "vietnamese food menu",
            "pho",
            "bun cha",
            "banh mi",
            "seafood",
            "vegetarian dishes",
        ],
        VietnameseMenuKind.drink.routeID: [
            "drink menu",
            "drink names",
            "vietnamese drink menu",
            "vietnamese drinks",
            "coffee",
            "iced coffee",
            "tea",
            "smoothie",
            "sugarcane juice",
        ],
        "getting-around": [
            "driver cannot find me",
            "driver can not find me",
            "grab pickup",
            "taxi pickup",
            "pickup point",
            "call taxi",
            "call driver",
        ],
        "everyday-services": [
            "bathroom",
            "public bathroom",
            "where can I print",
            "laundry service",
            "buy shampoo",
            "phone charger",
            "wifi password",
            "data top up",
        ],
        "tours-sights": [
            "buy tickets",
            "where is the entrance",
            "meeting point",
            "tour guide",
            "take photos",
            "book a tour",
        ],
        "emergency": [
            "lost passport",
            "passport missing",
            "passport problem",
            "report lost passport",
            "lost phone",
            "missing wallet",
            "stolen card",
            "need police",
            "need doctor",
            "nearest hospital",
        ],
        "polite-repair": [
            "i do not understand",
            "i don't understand",
            "speak slower",
            "say that again",
            "write it down",
            "do you speak english",
        ],
    ]

    private static let cityMastheadImages: [String: String] = [
        "hanoi": "HeroCityHanoi",
        "hcmc": "HeroCityHcmc",
        "danang": "HeroCityDanang",
        "hoian": "HeroCityHoian",
        "hue": "HeroCityHue",
    ]

    private static let cityAliases: [String: [String]] = [
        "hcmc": ["saigon", "ho chi minh", "ho chi minh city", "hcmc"],
        "hanoi": ["ha noi", "hà nội", "old quarter", "hoan kiem"],
        "danang": ["da nang", "đà nẵng", "dragon bridge", "my khe"],
        "hoian": ["hoi an", "hội an", "old town", "lantern"],
        "hue": ["huế", "hue", "imperial city", "citadel"],
    ]

    private static let citySubcategoryOrder = [
        "arrivals-routes",
        "landmarks-attractions",
        "neighborhoods-streets",
        "food-coffee",
        "shopping-markets",
        "practical-help-near-places",
    ]

    private static let citySubcategoryTitles: [String: String] = [
        "arrivals-routes": "Arrivals and routes",
        "landmarks-attractions": "Landmarks and attractions",
        "neighborhoods-streets": "Neighborhoods and streets",
        "food-coffee": "Food and cafes",
        "shopping-markets": "Shopping and markets",
        "practical-help-near-places": "Practical help near places",
    ]

    private static let citySubcategoryShortTitles: [String: String] = [
        "arrivals-routes": "Arrivals",
        "landmarks-attractions": "Landmarks",
        "neighborhoods-streets": "Streets",
        "food-coffee": "Food",
        "shopping-markets": "Markets",
        "practical-help-near-places": "Help",
    ]

    private static let citySubcategorySymbols: [String: String] = [
        "arrivals-routes": "arrow.up.right.circle.fill",
        "landmarks-attractions": "building.columns.fill",
        "neighborhoods-streets": "signpost.right.fill",
        "food-coffee": "cup.and.saucer.fill",
        "shopping-markets": "bag.fill",
        "practical-help-near-places": "ellipsis.bubble.fill",
    ]
}
