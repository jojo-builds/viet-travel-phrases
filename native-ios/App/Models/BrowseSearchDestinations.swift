import Foundation

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
}

struct BrowseCityShortcut: Identifiable, Equatable {
    let id: String
    let title: String
    let query: String
    let symbolName: String
    let tintName: AccentTint
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
            sampleQuery: "food allergies"
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
            sampleQuery: "help now"
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
        BrowseCityShortcut(id: "ho-chi-minh-city", title: "Ho Chi Minh City", query: "Ho Chi Minh City", symbolName: "building.2.fill", tintName: .orange),
        BrowseCityShortcut(id: "da-nang", title: "Da Nang", query: "Da Nang", symbolName: "water.waves", tintName: .blue),
        BrowseCityShortcut(id: "hoi-an", title: "Hoi An", query: "Hoi An", symbolName: "house.lodge.fill", tintName: .orange),
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
}
