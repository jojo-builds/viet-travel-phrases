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

enum BrowseCollectionPracticeAction: Equatable {
    case addStarterPages([String])
    case practiceMode(PracticeMode)
}

struct BrowseSearchPhraseItem: Identifiable, Equatable {
    let pageID: String
    let title: String
    let subtitle: String
    let symbolName: String
    let tintName: AccentTint
    let audioKey: String?

    var id: String { pageID }

    static func resolve(pageID: String) -> BrowseSearchPhraseItem? {
        if let item = PhraseCatalog.catalogItem(forOpenablePageID: pageID) {
            return BrowseSearchPhraseItem(
                pageID: item.pageID,
                title: item.title,
                subtitle: item.subtitle,
                symbolName: item.symbolName,
                tintName: item.tintName,
                audioKey: item.playbackAudioKey
            )
        }

        if pageID == PhrasePage.xinChao.id {
            return BrowseSearchPhraseItem(
                pageID: PhrasePage.xinChao.id,
                title: PhrasePage.xinChao.title,
                subtitle: PhrasePage.xinChao.intentSummary,
                symbolName: "hand.wave.fill",
                tintName: .red,
                audioKey: PhrasePage.xinChao.quickSay.first?.playbackAudioKey
            )
        }

        if let page = PhraseDetailPage.page(withID: pageID) {
            return BrowseSearchPhraseItem(
                pageID: page.id,
                title: page.title,
                subtitle: page.englishTitle,
                symbolName: page.iconName,
                tintName: page.tintName,
                audioKey: page.playbackAudioKey
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
            audioKey: nil
        )
    }
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
    let items: [BrowseSearchPhraseItem]
    let targetRoute: BrowseCollectionRoute?

    init(
        id: String,
        title: String,
        subtitle: String,
        symbolName: String,
        tintName: AccentTint,
        phraseCount: Int,
        items: [BrowseSearchPhraseItem],
        targetRoute: BrowseCollectionRoute? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.symbolName = symbolName
        self.tintName = tintName
        self.phraseCount = phraseCount
        self.items = items
        self.targetRoute = targetRoute
    }
}

struct BrowseCollectionShelf: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let items: [BrowseSearchPhraseItem]
    let itemGroups: [[BrowseSearchPhraseItem]]

    init(id: String, title: String, subtitle: String, items: [BrowseSearchPhraseItem]) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.items = items
        self.itemGroups = Self.groupItems(items)
    }

    private static func groupItems(_ items: [BrowseSearchPhraseItem]) -> [[BrowseSearchPhraseItem]] {
        stride(from: 0, to: items.count, by: 3).map { startIndex in
            Array(items[startIndex..<Swift.min(startIndex + 3, items.count)])
        }
    }
}

struct BrowseCollectionDescriptor: Identifiable, Equatable {
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
        self.exploreShelves = exploreShelves
        self.cityHub = cityHub
    }

    var id: String { route.id }
}

struct BrowseCityHub: Equatable {
    let situationTitle: String
    let situations: [BrowseCollectionSubcategory]
    let namesTitle: String
    let namesToKnowItems: [BrowseSearchPhraseItem]
    let quickPhrasesTitle: String
    let quickPhraseItems: [BrowseSearchPhraseItem]
    let browseTitle: String
    let browseGroups: [BrowseCollectionSubcategory]
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

    var phraseItem: BrowseSearchPhraseItem {
        BrowseSearchPhraseItem(
            pageID: pageID,
            title: title,
            subtitle: subtitle,
            symbolName: symbolName,
            tintName: tintName,
            audioKey: audioKey
        )
    }
}

enum BrowseSearchDestinations {
    static let situations: [BrowseDestination] = [
        BrowseDestination(
            id: "airport",
            title: "Airport",
            subtitle: "Arrival, passport, taxis, SIM cards",
            categoryIDs: ["airport-border-arrival", "transport", "phone-internet-power"],
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
            title: "Food",
            subtitle: "Order, allergies, water, pay",
            categoryIDs: ["food-drink", "money-numbers-prices"],
            symbolName: "takeoutbag.and.cup.and.straw.fill",
            tintName: .orange,
            sampleQuery: "food allergies",
            preferredPageIDs: [
                "viet-family-food-need-table",
                "viet-family-food-menu",
                "viet-family-service-water",
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
                "viet-family-vpe-take-me-place-cho-toi-den-don-cong-an",
            ]
        ),
        BrowseDestination(
            id: "local-greetings",
            title: "Local greetings",
            subtitle: "Relationship-aware hellos",
            categoryIDs: ["local-greetings", "greetings", "polite-basics"],
            symbolName: "bubble.left.and.bubble.right.fill",
            tintName: .green,
            sampleQuery: "hello",
            preferredPageIDs: [PhrasePage.xinChao.id, "viet-phrase-hello-chao-anh"]
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
            title: "Greetings",
            subtitle: "Say hello and start conversations.",
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
            title: "Polite repair",
            subtitle: "Fix misunderstandings politely.",
            categoryIDs: ["understanding-repair", "polite-basics", "problems-help"],
            symbolName: "heart",
            tintName: .red,
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
            .compactMap { item in PhraseCatalog.canonicalPageID(forOpenablePageID: item.pageID) }
            .first
    }

    static func itemCount(categoryIDs: [String]) -> Int {
        let pageIDs = categoryIDs.flatMap { categoryID in
            PhraseCatalog.items(selectedCategoryID: categoryID).map(\.pageID)
        }

        return Set(pageIDs).count
    }

    static func items(categoryIDs: [String], limit: Int) -> [BrowseSearchPhraseItem] {
        var seen = Set<String>()
        var resolvedItems: [BrowseSearchPhraseItem] = []

        for categoryID in categoryIDs {
            for item in PhraseCatalog.items(selectedCategoryID: categoryID) {
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
        PhraseSearchIndex.search(query)
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

    static func matchingCollections(for query: String) -> [BrowseSearchCollectionMatch] {
        let normalizedQuery = normalize(query)
        guard !normalizedQuery.isEmpty else {
            return []
        }

        let cityRoutes = cityShortcuts
            .filter { city in
                city.id != "all-vietnam"
                    && collectionTextMatches(query: normalizedQuery, text: "\(city.title) \(city.query) \(cityAliases[city.id, default: []].joined(separator: " "))")
            }
            .map(\.collectionRoute)

        let categoryRoutes = allCategoryDestinations
            .filter { destination in
                return collectionTextMatches(
                    query: normalizedQuery,
                    text: "\(destination.title) \(destination.subtitle) \(destination.sampleQuery) \(destination.id) \(destination.categoryIDs.joined(separator: " "))"
                )
            }
            .map(\.collectionRoute)

        return uniqueRoutes(categoryRoutes + cityRoutes)
            .compactMap(searchCollectionDescriptor(for:))
            .map(BrowseSearchCollectionMatch.init(descriptor:))
    }

    static func matchingSituations(for query: String) -> [BrowseDestination] {
        let normalizedQuery = normalize(query)
        guard !normalizedQuery.isEmpty else {
            return []
        }

        return situations.filter { destination in
            let categoryText = destination.categoryIDs
                .compactMap { PhraseCatalog.category(withID: $0)?.title }
                .joined(separator: " ")

            let searchText = normalize("\(destination.title) \(destination.subtitle) \(destination.sampleQuery) \(categoryText)")
            return searchText.contains(normalizedQuery)
                || normalizedQuery.split(separator: " ").allSatisfy { searchText.contains($0) }
        }
    }

    static func matchingCities(for query: String) -> [BrowseCityShortcut] {
        let normalizedQuery = normalize(query)
        guard !normalizedQuery.isEmpty else {
            return []
        }

        return cityShortcuts.filter { city in
            normalize("\(city.title) \(city.query)").contains(normalizedQuery)
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
        situations + startHere + phraseFamilies
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
            practiceTitle: "Practice \(title)",
            practiceSubtitle: practiceSubtitle(for: title),
            practiceAction: .addStarterPages([]),
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
        if id == "city-guides" {
            return makeCountryHubDescriptor()
        }

        let destination = allCategoryDestinations.first { $0.id == id }
        let category = PhraseCatalog.category(withID: id)

        guard destination != nil || category != nil else {
            return nil
        }

        let categoryIDs = destination?.categoryIDs ?? [id]
        let title = collectionTitle(for: id, fallback: destination?.title ?? category?.title ?? "Browse")
        let tint = destination?.tintName ?? category?.tintName ?? .green
        let symbolName = destination?.symbolName ?? category?.symbolName ?? "square.grid.2x2"
        let starterItems = starterItems(
            categoryIDs: categoryIDs,
            preferredPageIDs: destination?.preferredPageIDs ?? [],
            limit: 3
        )
        let subcategories = categorySubcategories(for: id, categoryIDs: categoryIDs, tintName: tint)
        let shelves = categoryExploreShelves(categoryIDs: categoryIDs, excluding: starterItems.map(\.pageID))

        return BrowseCollectionDescriptor(
            route: .category(id),
            title: title,
            subtitle: collectionSubtitle(for: id, fallback: destination?.subtitle ?? category?.title ?? "Useful phrase pages for this travel moment."),
            eyebrow: "SPEAKLOCAL VIETNAM",
            mastheadImageName: mastheadImageName(for: .category(id)),
            symbolName: symbolName,
            tintName: tint,
            subcategories: subcategories,
            starterTitle: starterTitle(for: id),
            starterItems: starterItems,
            practiceTitle: "Practice \(title)",
            practiceSubtitle: practiceSubtitle(for: title),
            practiceAction: .addStarterPages(starterItems.map(\.pageID)),
            exploreShelves: shelves
        )
    }

    private static func makeCountryHubDescriptor() -> BrowseCollectionDescriptor? {
        let essentialItems = countryEssentialPhraseItems()

        return BrowseCollectionDescriptor(
            route: .category("city-guides"),
            title: "All Vietnam",
            subtitle: "Everyday phrases for cities, food, transport, hotels, and help.",
            eyebrow: "SPEAKLOCAL VIETNAM",
            mastheadImageName: "HeroNeutralMasthead",
            symbolName: "star.fill",
            tintName: .orange,
            subcategories: [],
            starterTitle: "Essential phrases",
            starterItems: essentialItems,
            practiceTitle: "Practice Vietnam basics",
            practiceSubtitle: "Arrival, taxi, food, hotel, and help.",
            practiceAction: .addStarterPages(essentialItems.map(\.pageID)),
            exploreShelves: [],
            cityHub: BrowseCityHub(
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
            let rows = groupedItems[subcategoryID, default: []]
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
                let rows = groupedItems[subcategoryID, default: []].prefix(6).map(\.phraseItem)
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
            situationTitle: "What are you doing?",
            situations: citySituationCards(for: cityID, tintName: city.tintName),
            namesTitle: "Names to know",
            namesToKnowItems: cityNamesToKnowItems(for: cityID, cityItems: cityItems),
            quickPhrasesTitle: "Quick phrases",
            quickPhraseItems: cityQuickPhraseItems(for: cityID, cityItems: cityItems),
            browseTitle: "Browse \(title)",
            browseGroups: cityBrowseGroups(for: cityID, tintName: city.tintName, groupedItems: groupedItems)
        )
    }

    private static func countryStartCards() -> [BrowseCollectionSubcategory] {
        let specs: [(String, String, String, String, AccentTint, BrowseCollectionRoute)] = [
            ("first-day", "First day in Vietnam", "Arrive, check in, get oriented", "calendar.badge.clock", .orange, .category("first-day")),
            ("airport", "Airport arrival", "Passport, baggage, SIM, pickup", "airplane.arrival", .red, .category("airport")),
            ("taxi-grab", "Taxi / Grab", "Pickup, destination, drop-off", "car.fill", .green, .category("getting-around")),
            ("food-drink", "Food & drink", "Order, ask, pay", "takeoutbag.and.cup.and.straw.fill", .orange, .category("food")),
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

    private static func citySituationCards(for cityID: String, tintName: AccentTint) -> [BrowseCollectionSubcategory] {
        let specs: [(String, String, String, String, AccentTint, BrowseCollectionRoute)] = {
            switch cityID {
            case "danang":
                return [
                    ("arriving", "Arriving", "Airport, baggage, SIM, pickup", "airplane.arrival", .red, .category("airport")),
                    ("getting-around", "Getting around", "Taxi, Grab, streets, drop-off", "car.fill", .green, .category("getting-around")),
                    ("beach-day", "Beach day", "My Khe, chairs, drinks, bathroom", "beach.umbrella.fill", .blue, .category("getting-around")),
                    ("food-coffee", "Food & coffee", "Restaurants, cafés, markets", "cup.and.saucer.fill", .orange, .category("food")),
                    ("places", "Places to visit", "Dragon Bridge, Marble Mountains, Bà Nà Hills", "building.columns.fill", .blue, .category("city-guides")),
                    ("help", "Help", "Bathroom, pharmacy, lost item", "cross.case.fill", .red, .category("emergency")),
                ]
            case "hanoi":
                return [
                    ("arriving", "Arriving", "Airport, baggage, pickup", "airplane.arrival", .red, .category("airport")),
                    ("getting-around", "Getting around", "Taxi, streets, drop-off", "car.fill", .green, .category("getting-around")),
                    ("old-quarter", "Old Quarter", "Lake, streets, markets", "map.fill", .green, .category("city-guides")),
                    ("food-coffee", "Food & coffee", "Phở, bún chả, cafés", "cup.and.saucer.fill", .orange, .category("food")),
                    ("places", "Places to visit", "Lake, temples, museums", "building.columns.fill", .green, .category("city-guides")),
                    ("help", "Help", "Bathroom, pharmacy, lost item", "cross.case.fill", .red, .category("emergency")),
                ]
            case "hcmc":
                return [
                    ("arriving", "Arriving", "Airport, baggage, pickup", "airplane.arrival", .red, .category("airport")),
                    ("getting-around", "Getting around", "Taxi, Grab, streets, drop-off", "car.fill", .green, .category("getting-around")),
                    ("district-one", "District 1", "Hotels, cafés, landmarks", "building.2.fill", .orange, .category("city-guides")),
                    ("food-coffee", "Food & coffee", "Restaurants, cafés, markets", "cup.and.saucer.fill", .orange, .category("food")),
                    ("markets", "Markets", "Shopping, prices, pickup", "bag.fill", .orange, .category("shopping")),
                    ("help", "Help", "Bathroom, pharmacy, lost item", "cross.case.fill", .red, .category("emergency")),
                ]
            case "hoian":
                return [
                    ("arriving", "Arriving", "Shuttle, hotel, baggage", "airplane.arrival", .red, .category("airport")),
                    ("getting-around", "Getting around", "Walking, taxi, pickup", "car.fill", .green, .category("getting-around")),
                    ("old-town", "Old Town", "Lanterns, markets, river", "house.lodge.fill", .orange, .category("city-guides")),
                    ("food-coffee", "Food & coffee", "Cao lầu, cafés, markets", "cup.and.saucer.fill", .orange, .category("food")),
                    ("shopping", "Shopping", "Tailors, prices, pickup", "bag.fill", .orange, .category("shopping")),
                    ("help", "Help", "Bathroom, pharmacy, lost item", "cross.case.fill", .red, .category("emergency")),
                ]
            case "hue":
                return [
                    ("arriving", "Arriving", "Station, hotel, pickup", "airplane.arrival", .red, .category("airport")),
                    ("getting-around", "Getting around", "Taxi, streets, drop-off", "car.fill", .green, .category("getting-around")),
                    ("citadel", "Citadel", "Tickets, gates, pickup", "building.columns.fill", .green, .category("city-guides")),
                    ("food", "Food", "Bún bò Huế, markets, cafés", "cup.and.saucer.fill", .orange, .category("food")),
                    ("river-heritage", "River & heritage", "Boats, pagodas, routes", "water.waves", .blue, .category("city-guides")),
                    ("help", "Help", "Bathroom, pharmacy, lost item", "cross.case.fill", .red, .category("emergency")),
                ]
            default:
                return [
                    ("arriving", "Arriving", "Airport, baggage, pickup", "airplane.arrival", .red, .category("airport")),
                    ("getting-around", "Getting around", "Taxi, streets, drop-off", "car.fill", .green, .category("getting-around")),
                    ("food-coffee", "Food & coffee", "Restaurants, cafés, markets", "cup.and.saucer.fill", .orange, .category("food")),
                    ("places", "Places to visit", "Landmarks, streets, day trips", "building.columns.fill", tintName, .category("city-guides")),
                    ("help", "Help", "Bathroom, pharmacy, lost item", "cross.case.fill", .red, .category("emergency")),
                ]
            }
        }()

        return specs.map { id, title, subtitle, symbolName, tint, route in
            BrowseCollectionSubcategory(
                id: "\(cityID).situation.\(id)",
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
                    "city-danang-get-off-my-khe",
                    "city-danang-where-dragon-bridge",
                    "ves-call-taxi-for-me",
                ]
            default:
                return []
            }
        }()

        var items = pageItems(forPhraseIDs: preferredIDs)
        if let bathroom = BrowseSearchPhraseItem.resolve(pageID: "viet-family-bathroom-where") {
            items.append(bathroom)
        }

        if !items.isEmpty {
            return Array(uniquePhraseItems(items).prefix(5))
        }

        let fallback = cityItems
            .filter { $0.subcategoryID == "arrivals-routes" || $0.subcategoryID == "practical-help-near-places" }
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
        let specs: [(String, String, String, String, BrowseCollectionRoute)] = [
            ("arrivals-routes", "Arrivals", "Airport, station, pickup", "airplane.arrival", .category("airport")),
            ("getting-around", "Getting around", "Taxi, Grab, directions", "car.fill", .category("getting-around")),
            ("landmarks-attractions", "Landmarks", "Places, tickets, photos", "building.columns.fill", .category("city-guides")),
            ("neighborhoods-streets", "Streets", "Street names and drop-off", "signpost.right.fill", .category("getting-around")),
            ("food-coffee", "Food & coffee", "Restaurants, cafés, markets", "cup.and.saucer.fill", .category("food")),
            ("shopping-markets", "Markets", "Shopping, prices, pickup", "bag.fill", .category("shopping")),
            ("practical-help-near-places", "Help", "Bathroom, pharmacy, lost item", "cross.case.fill", .category("emergency")),
        ]

        return specs.compactMap { subcategoryID, label, subtitle, symbolName, route in
            let rows = groupedItems[subcategoryID, default: []]
            guard !rows.isEmpty || ["getting-around"].contains(subcategoryID) else {
                return nil
            }

            return BrowseCollectionSubcategory(
                id: "\(cityID).browse.\(subcategoryID)",
                title: label,
                subtitle: subtitle,
                symbolName: symbolName,
                tintName: tintName,
                phraseCount: rows.count,
                items: rows.prefix(4).map(\.phraseItem),
                targetRoute: route
            )
        }
    }

    private static func pageItems(forPhraseIDs phraseIDs: [String]) -> [BrowseSearchPhraseItem] {
        phraseIDs.compactMap { phraseID in
            BrowseSearchPhraseItem.resolve(pageID: "viet-family-\(phraseID)")
        }
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

        let rows = (try? VietSQLiteLanguagePackRepository.bundled().loadBrowseCityCollectionItems(cityID: cityID, limit: 120))
            ?? fallbackCityCollectionItems(for: cityID)
        cityCollectionItemCache[cityID] = rows
        return rows
    }

    private static func fallbackCityCollectionItems(for cityID: String) -> [BrowseCityCollectionItem] {
        PhraseCatalog.items(selectedCategoryID: "city-guides")
            .filter { $0.pageID.contains("city-\(cityID)-") }
            .prefix(80)
            .map { item in
                BrowseCityCollectionItem(
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
                    subcategoryTitle: "Arrivals and routes"
                )
            }
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
                subtitle: "Useful phrase pages",
                categoryIDs: [categoryID],
                terms: [],
                symbolName: PhraseCatalog.category(withID: categoryID)?.symbolName ?? "ellipsis.bubble"
            )
        }

        return specs.compactMap { spec in
            let rows = items(categoryIDs: spec.categoryIDs, matchingTerms: spec.terms, limit: 4)
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
                items: rows
            )
        }
    }

    private static func categoryExploreShelves(categoryIDs: [String], excluding excludedPageIDs: [String]) -> [BrowseCollectionShelf] {
        let excluded = Set(excludedPageIDs)
        return categoryIDs.compactMap { categoryID in
            let rows = PhraseCatalog.items(selectedCategoryID: categoryID)
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
                items: Array(rows)
            )
        }
        .prefix(4)
        .map { $0 }
    }

    private static func starterItems(categoryIDs: [String], preferredPageIDs: [String], limit: Int) -> [BrowseSearchPhraseItem] {
        var seen = Set<String>()
        var rows: [BrowseSearchPhraseItem] = []

        for item in preferredPageIDs.compactMap(BrowseSearchPhraseItem.resolve(pageID:)) {
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

        if rows.isEmpty, !terms.isEmpty {
            return items(categoryIDs: categoryIDs, limit: limit)
        }

        return rows
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
            return "Order clearly, ask about ingredients, handle spice, and pay."
        case "shopping":
            return "Ask prices, sizes, receipts, returns, and payment questions."
        case "getting-around":
            return "Taxis, buses, walking directions, stops, maps, and addresses."
        case "emergency":
            return "Calm help, health, safety, and problem-solving phrases."
        case "local-greetings":
            return "Relationship-aware hellos and warm local openers."
        case "city-guides":
            return "City phrases for arrival, landmarks, streets, food, and everyday help."
        default:
            return fallback
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

    private static func practiceSubtitle(for title: String) -> String {
        if title == "Shopping" {
            return "Practice prices, sizes, payment, and returns."
        }
        if title == "Emergency" {
            return "Practice asking for help calmly."
        }

        return "Practice a quick \(title.lowercased()) conversation."
    }

    private static func cityPracticeTitle(for id: String, title: String) -> String {
        switch id {
        case "danang":
            return "Practice a Da Nang day"
        case "hanoi":
            return "Practice a Hanoi day"
        case "hcmc":
            return "Practice a Saigon day"
        case "hoian":
            return "Practice a Hoi An day"
        case "hue":
            return "Practice a Hue day"
        default:
            return "Practice \(title)"
        }
    }

    private static func cityPracticeSubtitle(for id: String) -> String {
        switch id {
        case "danang":
            return "Airport pickup, beach drop-off, food, and a ride back."
        case "hanoi":
            return "Airport pickup, Old Quarter, food, and a ride back."
        case "hcmc":
            return "Airport pickup, District 1, coffee, and a ride back."
        case "hoian":
            return "Hotel pickup, Old Town, food, and a ride back."
        case "hue":
            return "Station pickup, the Citadel, food, and a ride back."
        default:
            return "Arrival, food, places, and getting back."
        }
    }

    private static func citySubtitle(for id: String) -> String {
        switch id {
        case "hcmc":
            return "Airport arrivals, District 1 rides, markets, cafés, and first-day help."
        case "hanoi":
            return "Airport arrivals, Old Quarter streets, food, landmarks, and everyday help."
        case "danang":
            return "Airport arrivals, beach rides, river landmarks, markets, and day trips."
        case "hoian":
            return "Old Town walks, lantern streets, cafés, markets, and rides back."
        case "hue":
            return "Citadel visits, river rides, food stops, heritage routes, and practical help."
        default:
            return "Arrivals, food, places, streets, and practical help."
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

    private static let subcategorySpecs: [String: [CollectionSubcategorySpec]] = [
        "airport": [
            CollectionSubcategorySpec(id: "arrival", title: "Arrival", subtitle: "Get oriented after landing", categoryIDs: ["airport-border-arrival"], terms: ["arrival", "tourism", "passport"], symbolName: "airplane.arrival"),
            CollectionSubcategorySpec(id: "baggage", title: "Baggage", subtitle: "Bags, tags, and lost luggage", categoryIDs: ["airport-border-arrival"], terms: ["bag", "baggage", "luggage"], symbolName: "suitcase.fill"),
            CollectionSubcategorySpec(id: "transport", title: "Transport", subtitle: "Taxi, bus, and pickup", categoryIDs: ["transport", "directions-navigation"], terms: ["taxi", "bus", "pickup"], symbolName: "car.fill"),
            CollectionSubcategorySpec(id: "sim-cash", title: "SIM & cash", subtitle: "Phone, data, and money", categoryIDs: ["phone-internet-power", "money-numbers-prices"], terms: ["sim", "data", "cash", "atm"], symbolName: "simcard.fill"),
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
            CollectionSubcategorySpec(id: "drinks", title: "Drinks", subtitle: "Coffee, tea, and water", categoryIDs: ["food-drink"], terms: ["coffee", "tea", "water", "drink"], symbolName: "cup.and.saucer.fill"),
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
    ]

    private static let categoryMastheadImages: [String: String] = [
        "airport": "BrowseCollectionAirport",
        "hotel": "BrowseCollectionHotel",
        "food": "BrowseCollectionFood",
        "shopping": "BrowseCollectionShopping",
        "getting-around": "BrowseCollectionAirport",
        "first-day": "BrowseCollectionHanoi",
        "city-guides": "BrowseCollectionHanoi",
        "emergency": "HeroVietnamMasthead",
        "local-greetings": "HeroVietnamMasthead",
        "essentials": "HeroVietnamMasthead",
        "greetings": "HeroVietnamMasthead",
        "questions": "HeroVietnamMasthead",
        "numbers-money": "BrowseCollectionShopping",
        "polite-repair": "HeroVietnamMasthead",
    ]

    private static let cityMastheadImages: [String: String] = [
        "hanoi": "BrowseCollectionHanoi",
        "hcmc": "HeroNeutralMasthead",
        "danang": "HeroNeutralMasthead",
        "hoian": "HeroNeutralMasthead",
        "hue": "HeroNeutralMasthead",
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
        "food-coffee": "Food and coffee",
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
