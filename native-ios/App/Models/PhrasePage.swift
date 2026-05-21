import Foundation

struct PhrasePage: Identifiable, Equatable {
    let id: String
    let destination: String
    let title: String
    let englishTitle: String
    let pronunciation: String
    let intentSummary: String
    let atGlance: String
    let quickSay: [PhraseOption]
    let situationalGreetingsLeadIn: String
    let situationalGreetings: [PhraseOption]
    let localGreetingsLeadIn: String
    let localGreetings: [PhraseOption]
    let breakdown: [BreakdownToken]
    let followUpsLeadIn: String
    let followUps: [PhraseOption]
    let culturalNote: String
    let exploreNext: [PhraseLink]

    var sectionTitles: [String] {
        [
            "At a glance",
            "Quick say",
            "Break it down",
            "Situational greetings",
            "How locals actually greet",
            "Common follow-ups",
            "Cultural note",
            "Explore next",
        ]
    }
}

struct PhraseOption: Identifiable, Equatable {
    let id: String
    let vietnamese: String
    let english: String
    let pronunciation: String
    let symbolName: String
    let tintName: AccentTint
    var detailPageID: String?
    var audioKey: String? = nil

    var playbackAudioKey: String? {
        let manifest = AudioAssetManifest.main

        if manifest?.hasPlayableEntry(for: audioKey, matchingText: vietnamese) == true {
            return audioKey
        }

        if manifest?.hasPlayableEntry(for: id, matchingText: vietnamese) == true {
            return id
        }

        return manifest?.audioKey(forExactText: vietnamese)
    }
}

struct BreakdownToken: Identifiable, Equatable {
    let id: String
    let vietnamese: String
    let english: String
    var audioKey: String? = nil

    var playbackAudioKey: String? {
        let manifest = AudioAssetManifest.main

        if manifest?.hasPlayableEntry(for: audioKey, matchingText: vietnamese) == true {
            return audioKey
        }

        return manifest?.audioKey(forExactText: vietnamese)
    }
}

struct PhraseLink: Identifiable, Equatable {
    let id: String
    let vietnamese: String
    let english: String
    let relation: String
    let symbolName: String
    let tintName: AccentTint
    var detailPageID: String?
}

struct PhraseDetailPage: Identifiable, Equatable {
    let id: String
    let title: String
    let englishTitle: String
    let pronunciation: String
    let summary: String
    let iconName: String
    let tintName: AccentTint
    var heroImageName: String? = nil
    let sections: [PhraseDetailSection]
    let examples: [PhraseOption]
    var audioKey: String? = nil
    var practiceCTALabel: String? = nil
    var showsCatalogExplore: Bool = true

    var playbackAudioKey: String? {
        let manifest = AudioAssetManifest.main

        if manifest?.hasPlayableEntry(for: audioKey, matchingText: title) == true {
            return audioKey
        }

        if let exactTitleKey = manifest?.audioKey(forExactText: title) {
            return exactTitleKey
        }

        return examples.first?.playbackAudioKey
    }
}

struct PhraseArticlePage: Identifiable, Equatable {
    let id: String
    let destination: String
    let title: String
    let englishTitle: String
    let pronunciation: String
    let summary: String
    let iconName: String
    let tintName: AccentTint
    var heroImageName: String? = nil
    let playbackAudioKey: String?
    let sections: [PhraseArticleSection]
    var practiceCTALabel: String? = nil
    var showsCatalogExplore: Bool = true
}

struct PhraseArticleSection: Identifiable, Equatable {
    let id: String
    let title: String
    let body: String
    let phrases: [PhraseOption]
    let breakdown: [BreakdownToken]
    var inlineDefinitions: [PhraseInlineDefinition] = []
    var chips: [String] = []
    let presentation: SectionPresentation
}

struct PhraseInlineDefinition: Identifiable, Equatable {
    let id: String
    let vietnamese: String
    let english: String

    init(id: String? = nil, vietnamese: String, english: String) {
        self.id = id ?? vietnamese.lowercased()
        self.vietnamese = vietnamese
        self.english = english
    }
}

enum SectionPresentation: String, Decodable, Equatable {
    case automatic
    case plainText = "plain-text"
    case phraseList = "phrase-list"
    case horizontalPhraseCards = "horizontal-phrase-cards"
    case relationshipShelf = "relationship-shelf"
    case breakdownStrip = "breakdown-strip"
    case menuChips = "menu-chips"
    case tipCallout = "tip-callout"
    case warningCallout = "warning-callout"

    func resolved(sectionID: String, hasPhrases: Bool, hasBreakdown: Bool) -> SectionPresentation {
        if hasPhrases, Self.relationshipShelfSectionIDs.contains(sectionID) {
            return .relationshipShelf
        }

        guard self == .automatic else {
            return self
        }

        if hasBreakdown {
            return .breakdownStrip
        }

        switch sectionID {
        case "breakdown":
            return .breakdownStrip
        case "standard-way", "quick-say", "ways-to-say", "relationship-forms", "pronoun-swap", "common-follow-ups", "explore-next":
            return hasPhrases ? .phraseList : .plainText
        case "natural-variations", "nearby-phrases", "situational-use", "common-situations":
            return hasPhrases ? .horizontalPhraseCards : .plainText
        case "watch-out", "good-to-know":
            return .tipCallout
        case "local-tip", "traveler-tip", "cultural-note":
            return .tipCallout
        default:
            return hasPhrases ? .phraseList : .plainText
        }
    }

    private static let relationshipShelfSectionIDs: Set<String> = [
        "relationship-words",
        "local-greetings",
        "pronoun-swap",
        "relationship-forms",
        "relationship-swaps",
    ]
}

struct PhraseDetailSection: Identifiable, Equatable {
    let id: String
    let title: String
    let body: String
    var phrases: [PhraseOption] = []
    var breakdown: [BreakdownToken] = []
    var inlineDefinitions: [PhraseInlineDefinition] = []
    var chips: [String] = []
    var presentation: SectionPresentation = .automatic

    var articleSection: PhraseArticleSection {
        let resolvedPresentation = presentation.resolved(
            sectionID: id,
            hasPhrases: !phrases.isEmpty,
            hasBreakdown: !breakdown.isEmpty
        )

        return PhraseArticleSection(
            id: id,
            title: articleTitle(forPresentation: resolvedPresentation),
            body: body,
            phrases: phrases,
            breakdown: breakdown,
            inlineDefinitions: inlineDefinitions,
            chips: chips,
            presentation: resolvedPresentation
        )
    }

    private func articleTitle(forPresentation presentation: SectionPresentation) -> String {
        switch id {
        case "standard-way":
            return "Quick say"
        case "nearby-phrases":
            return title == "Nearby phrases" ? "Useful next phrases" : title
        default:
            return title
        }
    }
}

struct PhraseSearchResult: Identifiable, Equatable {
    let pageID: String
    let title: String
    let subtitle: String

    var id: String { pageID }
}

struct PhraseCategory: Identifiable, Equatable {
    let id: String
    let title: String
    let symbolName: String
    let tintName: AccentTint
}

struct PhraseCatalogItem: Identifiable, Equatable {
    let pageID: String
    let title: String
    let subtitle: String
    let categoryIDs: [String]
    let symbolName: String
    let tintName: AccentTint
    var audioKey: String? = nil

    var id: String { pageID }
    var categoryID: String { categoryIDs.first ?? "greetings" }
    var playbackAudioKey: String? {
        let manifest = AudioAssetManifest.main

        if manifest?.hasPlayableEntry(for: audioKey, matchingText: title) == true {
            return audioKey
        }

        if let exactTitleAudioKey = manifest?.audioKey(forExactText: title) {
            return exactTitleAudioKey
        }

        if let audioKey, manifest?.url(for: audioKey) != nil {
            return audioKey
        }

        return nil
    }

    init(
        pageID: String,
        title: String,
        subtitle: String,
        categoryID: String,
        symbolName: String,
        tintName: AccentTint,
        audioKey: String? = nil
    ) {
        self.init(
            pageID: pageID,
            title: title,
            subtitle: subtitle,
            categoryIDs: [categoryID],
            symbolName: symbolName,
            tintName: tintName,
            audioKey: audioKey
        )
    }

    init(
        pageID: String,
        title: String,
        subtitle: String,
        categoryIDs: [String],
        symbolName: String,
        tintName: AccentTint,
        audioKey: String? = nil
    ) {
        self.pageID = pageID
        self.title = title
        self.subtitle = subtitle
        self.categoryIDs = categoryIDs
        self.symbolName = symbolName
        self.tintName = tintName
        self.audioKey = audioKey
    }
}

struct PhraseCatalogSection: Identifiable, Equatable {
    let category: PhraseCategory
    let items: [PhraseCatalogItem]

    var id: String { category.id }
}

enum AccentTint: String, Equatable {
    case red
    case orange
    case green
    case blue
    case purple
    case teal
    case gray
}

enum PhraseCatalog {
    static let allCategoryID = "all"

    static var categories: [PhraseCategory] {
        cache.categories
    }

    static func items(
        selectedCategoryID: String,
        excludingPageID: String? = nil
    ) -> [PhraseCatalogItem] {
        let selectedItems = selectedCategoryID == allCategoryID
            ? cache.allItems
            : cache.itemsByCategoryID[selectedCategoryID, default: []]

        guard let excludingPageID else {
            return selectedItems
        }

        let canonicalExcludedPageID = canonicalPageID(forOpenablePageID: excludingPageID) ?? excludingPageID
        return selectedItems.filter { item in
            item.pageID != canonicalExcludedPageID
        }
    }

    static func defaultCategoryID(forPageID pageID: String) -> String {
        let canonicalPageID = canonicalPageID(forOpenablePageID: pageID) ?? pageID
        return cache.defaultCategoryIDByPageID[canonicalPageID] ?? "greetings"
    }

    static func categoryIDs(forPageID pageID: String) -> [String] {
        let canonicalPageID = canonicalPageID(forOpenablePageID: pageID) ?? pageID
        return cache.itemsByPageID[canonicalPageID]?.categoryIDs ?? []
    }

    static func browseCategories(defaultCategoryID: String) -> [PhraseCategory] {
        let defaultCategory = category(withID: defaultCategoryID)
        let remainingCategories = cache.categories.filter { $0.id != defaultCategory?.id }

        return [defaultCategory].compactMap { $0 } + remainingCategories
    }

    static func browseSections(
        defaultCategoryID: String,
        excludingPageID: String? = nil
    ) -> [PhraseCatalogSection] {
        browseCategories(defaultCategoryID: defaultCategoryID)
            .compactMap { category in
                let categoryItems = items(
                    selectedCategoryID: category.id,
                    excludingPageID: excludingPageID
                )

                guard !categoryItems.isEmpty else {
                    return nil
                }

                return PhraseCatalogSection(category: category, items: categoryItems)
            }
    }

    static func category(withID id: String) -> PhraseCategory? {
        cache.categoriesByID[id]
    }

    static func isOpenablePageID(_ pageID: String) -> Bool {
        if VietSQLitePhraseGraphRuntime.canOpenPage(pageID) {
            return true
        }

        return pageID == PhrasePage.xinChao.id
            || VietnameseMenuCatalog.detailItem(withPageID: pageID) != nil
            || LocationMenuPicksCatalog.detailPage(withID: pageID) != nil
            || PhraseDetailPage.hasAuthoredPage(withID: pageID)
    }

    static func canonicalPageID(forOpenablePageID pageID: String) -> String? {
        if let sqliteCanonicalPageID = VietSQLitePhraseGraphRuntime.canonicalPageID(for: pageID) {
            return sqliteCanonicalPageID
        }

        guard isOpenablePageID(pageID) else {
            return nil
        }

        return pageID
    }

    static var allItems: [PhraseCatalogItem] {
        cache.allItems
    }

    static func catalogItem(forOpenablePageID pageID: String) -> PhraseCatalogItem? {
        let canonicalPageID = canonicalPageID(forOpenablePageID: pageID) ?? pageID
        return cache.itemsByPageID[canonicalPageID]
    }

    private static var cache = Cache()

#if DEBUG
    static func resetCacheForTesting() {
        cache = Cache()
    }
#endif

    private struct Cache {
        let categories: [PhraseCategory]
        let categoriesByID: [String: PhraseCategory]
        let allItems: [PhraseCatalogItem]
        let itemsByPageID: [String: PhraseCatalogItem]
        let itemsByCategoryID: [String: [PhraseCatalogItem]]
        let defaultCategoryIDByPageID: [String: String]

        init() {
            let sqliteSnapshot = VietSQLitePhraseGraphRuntime.catalogSnapshot()
            let scenarioCategories = sqliteSnapshot?.scenarioCategories ?? []
            let categories = baseCategories + scenarioCategories
            let categoriesByID = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })

            let allItems = Self.uniqueItems(sqliteSnapshot?.catalogItems ?? Self.makeStaticFallbackItems())
            var itemsByCategoryID: [String: [PhraseCatalogItem]] = [:]

            for item in allItems {
                for categoryID in item.categoryIDs {
                    itemsByCategoryID[categoryID, default: []].append(item)
                }
            }

            self.categories = categories
            self.categoriesByID = categoriesByID
            self.allItems = allItems
            self.itemsByPageID = Dictionary(uniqueKeysWithValues: allItems.map { ($0.pageID, $0) })
            self.itemsByCategoryID = itemsByCategoryID
            self.defaultCategoryIDByPageID = Dictionary(uniqueKeysWithValues: allItems.map { ($0.pageID, $0.categoryID) })
        }

        private static func makeStaticFallbackItems() -> [PhraseCatalogItem] {
            [rootItem] + PhraseDetailPage.all.map(catalogItem)
        }

        private static func uniqueItems(_ items: [PhraseCatalogItem]) -> [PhraseCatalogItem] {
            var seen = Set<String>()
            return items.filter { item in
                seen.insert(item.pageID).inserted
            }
        }
    }

    private static let baseCategories: [PhraseCategory] = [
        PhraseCategory(id: "greetings", title: "Greetings", symbolName: "hand.wave.fill", tintName: .red),
        PhraseCategory(id: "local-greetings", title: "Relationship greetings", symbolName: "person.2.fill", tintName: .blue),
        PhraseCategory(id: "politeness", title: "Polite", symbolName: "sparkles", tintName: .red),
        PhraseCategory(id: "attention", title: "Attention", symbolName: "bell.fill", tintName: .orange),
        PhraseCategory(id: "small-talk", title: "Small talk", symbolName: "bubble.left.and.bubble.right.fill", tintName: .green),
        PhraseCategory(id: "phone", title: "Phone", symbolName: "phone.fill", tintName: .green),
        PhraseCategory(id: "time", title: "Time", symbolName: "sun.max.fill", tintName: .blue),
        PhraseCategory(id: "meeting", title: "Meeting", symbolName: "hands.sparkles.fill", tintName: .teal),
        PhraseCategory(id: "gratitude", title: "Gratitude", symbolName: "heart.fill", tintName: .green),
        PhraseCategory(id: "repair", title: "Get unstuck", symbolName: "hand.raised.fill", tintName: .blue),
        PhraseCategory(id: "goodbyes", title: "Goodbyes", symbolName: "arrowshape.turn.up.left.fill", tintName: .purple),
    ]

    private static let rootItem = PhraseCatalogItem(
        pageID: PhrasePage.xinChao.id,
        title: PhrasePage.xinChao.title,
        subtitle: PhrasePage.xinChao.intentSummary,
        categoryIDs: ["greetings"],
        symbolName: "hand.wave.fill",
        tintName: .red,
        audioKey: PhrasePage.xinChao.quickSay.first?.playbackAudioKey
    )

    private static func catalogItem(for page: PhraseDetailPage) -> PhraseCatalogItem {
        PhraseCatalogItem(
            pageID: page.id,
            title: page.title,
            subtitle: page.englishTitle,
            categoryIDs: categoryIDs(for: page.id),
            symbolName: page.iconName,
            tintName: page.tintName,
            audioKey: page.playbackAudioKey
        )
    }

    private static func categoryIDs(for pageID: String) -> [String] {
        if let categoryIDs = AuthoredVietListingPages.categoryIDs(for: pageID) {
            return categoryIDs
        }

        if pageID.hasSuffix("-way-formal") || pageID.hasSuffix("-way-respectful") {
            return ["politeness", "greetings", "local-greetings"]
        }

        if pageID.hasSuffix("-way-attention") {
            return ["attention", "greetings", "local-greetings"]
        }

        if pageID.hasSuffix("-way-where-going")
            || pageID.hasSuffix("-way-eaten-yet")
            || pageID.hasSuffix("-way-how-are-you") {
            return ["small-talk", "greetings", "local-greetings"]
        }

        if pageID.hasSuffix("-way-soft") {
            return ["local-greetings", "greetings"]
        }

        if pageID.hasPrefix("viet-hello-") || pageID == "viet-local-greetings" {
            return ["local-greetings", "greetings"]
        }

        switch pageID {
        case "viet-respectful-hello":
            return ["politeness", "greetings"]
        case "viet-phone-hello":
            return ["phone", "greetings"]
        case "viet-time-greetings":
            return ["time", "greetings"]
        case "viet-how-are-you", "viet-where-going":
            return ["small-talk", "greetings"]
        case "viet-nice-to-meet-you":
            return ["meeting", "greetings"]
        case "viet-thank-you":
            return ["gratitude"]
        case "viet-excuse-sorry":
            return ["repair"]
        case "viet-goodbye":
            return ["goodbyes"]
        default:
            return ["greetings"]
        }
    }
}

extension PhrasePage {
    var articleTemplate: PhraseArticlePage {
        PhraseArticlePage(
            id: id,
            destination: destination,
            title: title,
            englishTitle: englishTitle,
            pronunciation: pronunciation,
            summary: intentSummary,
            iconName: "star.fill",
            tintName: .red,
            playbackAudioKey: quickSay.first?.playbackAudioKey,
            sections: [
                PhraseArticleSection(
                    id: "at-glance",
                    title: "At a glance",
                    body: atGlance,
                    phrases: [],
                    breakdown: [],
                    presentation: .plainText
                ),
                PhraseArticleSection(
                    id: "quick-say",
                    title: "Quick say",
                    body: "",
                    phrases: quickSay,
                    breakdown: [],
                    presentation: .phraseList
                ),
                PhraseArticleSection(
                    id: "breakdown",
                    title: "Break it down",
                    body: "",
                    phrases: [],
                    breakdown: breakdown,
                    presentation: .breakdownStrip
                ),
                PhraseArticleSection(
                    id: "situational-greetings",
                    title: "Situational greetings",
                    body: situationalGreetingsLeadIn,
                    phrases: situationalGreetings,
                    breakdown: [],
                    presentation: .horizontalPhraseCards
                ),
                PhraseArticleSection(
                    id: "local-greetings",
                    title: "How locals actually greet",
                    body: localGreetingsLeadIn,
                    phrases: localGreetings,
                    breakdown: [],
                    presentation: .phraseList
                ),
                PhraseArticleSection(
                    id: "common-follow-ups",
                    title: "Common follow-ups",
                    body: followUpsLeadIn,
                    phrases: followUps,
                    breakdown: [],
                    presentation: .phraseList
                ),
                PhraseArticleSection(
                    id: "cultural-note",
                    title: "Cultural note",
                    body: culturalNote,
                    phrases: [],
                    breakdown: [],
                    presentation: .tipCallout
                ),
            ]
        )
    }

    static let xinChao = PhrasePage(
        id: "viet-polite-hello",
        destination: "SpeakLocal Vietnam",
        title: "Xin chào",
        englishTitle: "Hello",
        pronunciation: "sin chow",
        intentSummary: "Hello (universal greeting)",
        atGlance: "For travelers, Xin chào is the most dependable hello. In everyday Vietnamese, greetings often depend on age, gender, and relationship, so the next step is learning when to use chào plus a relationship word.",
        quickSay: [
            PhraseOption(
                id: "polite-1",
                vietnamese: "Xin chào",
                english: "Hello / polite hello",
                pronunciation: "sin chow",
                symbolName: "speaker.wave.2.fill",
                tintName: .red,
                detailPageID: nil
            ),
            PhraseOption(
                id: "polite-5",
                vietnamese: "Chào",
                english: "Hi / hello (casual)",
                pronunciation: "chow",
                symbolName: "speaker.wave.2.fill",
                tintName: .orange,
                detailPageID: nil
            ),
        ],
        situationalGreetingsLeadIn: "Use these when the setting is more specific: a friend, a respectful adult, a phone call, or a time-of-day greeting.",
        situationalGreetings: [
            PhraseOption(
                id: "friend",
                vietnamese: "Chào bạn",
                english: "Hi, friend",
                pronunciation: "chow ban",
                symbolName: "person.2",
                tintName: .orange,
                detailPageID: nil
            ),
            PhraseOption(
                id: "formal",
                vietnamese: "Dạ, chào anh/chị",
                english: "Hello, formal and respectful",
                pronunciation: "yah chow anh chee",
                symbolName: "person.2.fill",
                tintName: .red,
                detailPageID: "viet-respectful-hello"
            ),
            PhraseOption(
                id: "phone",
                vietnamese: "Alô",
                english: "Hello on the phone",
                pronunciation: "ah-lo",
                symbolName: "phone",
                tintName: .green,
                detailPageID: "viet-phone-hello"
            ),
            PhraseOption(
                id: "morning",
                vietnamese: "Chào buổi sáng",
                english: "Good morning",
                pronunciation: "chow boo-ee sahng",
                symbolName: "sun.max",
                tintName: .blue,
                detailPageID: "viet-time-greetings"
            ),
            PhraseOption(
                id: "afternoon",
                vietnamese: "Chào buổi chiều",
                english: "Good afternoon",
                pronunciation: "chow boo-ee chee-ew",
                symbolName: "sun.horizon",
                tintName: .purple,
                detailPageID: "viet-time-greetings"
            ),
        ],
        localGreetingsLeadIn: "This is the most local pattern. Pick the relationship word when the person’s role is clear; stay with Xin chào when you are unsure.",
        localGreetings: [
            PhraseOption(id: "anh", vietnamese: "Chào anh", english: "Hello, older brother / slightly older man", pronunciation: "chow anh", symbolName: "person", tintName: .blue, detailPageID: "viet-hello-anh"),
            PhraseOption(id: "chi", vietnamese: "Chào chị", english: "Hello, older sister / slightly older woman", pronunciation: "chow chee", symbolName: "person", tintName: .red, detailPageID: "viet-hello-chi"),
            PhraseOption(id: "em", vietnamese: "Chào em", english: "Hello, younger sibling / someone younger", pronunciation: "chow em", symbolName: "person", tintName: .green, detailPageID: "viet-hello-em"),
            PhraseOption(id: "ong", vietnamese: "Chào ông", english: "Hello, grandfather / elderly man", pronunciation: "chow ohm", symbolName: "person", tintName: .purple, detailPageID: "viet-hello-ong"),
            PhraseOption(id: "ba", vietnamese: "Chào bà", english: "Hello, grandmother / elderly woman", pronunciation: "chow bah", symbolName: "person", tintName: .red, detailPageID: "viet-hello-ba"),
            PhraseOption(id: "chu", vietnamese: "Chào chú", english: "Hello, uncle / older man", pronunciation: "chow choo", symbolName: "person", tintName: .teal, detailPageID: "viet-hello-chu"),
            PhraseOption(id: "co", vietnamese: "Chào cô", english: "Hello, aunt / older woman", pronunciation: "chow koh", symbolName: "person", tintName: .red, detailPageID: "viet-hello-co"),
        ],
        breakdown: [
            BreakdownToken(id: "xin", vietnamese: "Xin", english: "polite ask", audioKey: "breakdown-xin"),
            BreakdownToken(id: "chao", vietnamese: "chào", english: "greet / hello", audioKey: "breakdown-chao"),
            BreakdownToken(id: "full", vietnamese: "Xin chào", english: "polite hello", audioKey: "polite-1"),
        ],
        followUpsLeadIn: "After hello, small talk often checks health, movement, or the social moment. Use these when the exchange has room to continue.",
        followUps: [
            PhraseOption(id: "how-are-you", vietnamese: "Bạn khỏe không?", english: "How are you?", pronunciation: "ban khweh khom", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: "viet-how-are-you"),
            PhraseOption(id: "where-going", vietnamese: "Đi đâu đấy?", english: "Where are you going?", pronunciation: "dee dow day", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: "viet-where-going"),
            PhraseOption(id: "nice-meet", vietnamese: "Rất vui được gặp bạn", english: "Nice to meet you", pronunciation: "zuht voo-ee duhk gap ban", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: "viet-nice-to-meet-you"),
        ],
        culturalNote: "Vietnamese greetings carry relationship information. Learning the pattern matters more than memorizing one perfect hello.",
        exploreNext: [
            PhraseLink(id: "polite-thank-you", vietnamese: "Cảm ơn", english: "Thank you", relation: "graceful exit", symbolName: "heart", tintName: .green, detailPageID: "viet-thank-you"),
            PhraseLink(id: "polite-sorry", vietnamese: "Xin lỗi", english: "Excuse me / sorry", relation: "attention getter", symbolName: "hand.raised", tintName: .blue, detailPageID: "viet-excuse-sorry"),
            PhraseLink(id: "goodbye", vietnamese: "Tạm biệt", english: "Goodbye", relation: "close conversation", symbolName: "sparkles", tintName: .purple, detailPageID: "viet-goodbye"),
        ]
    )
}

enum PhraseSearchIndex {
    static func search(_ query: String, limit: Int = 100) -> [PhraseSearchResult] {
        if let sqliteResults = VietSQLitePhraseGraphRuntime.search(query, limit: limit) {
            return sqliteResults
        }

        let normalizedQuery = normalize(query)
        guard !normalizedQuery.isEmpty else {
            return []
        }

        let tokens = normalizedQuery
            .split(separator: " ")
            .map(String.init)

        func uniqueTokens(for normalizedQueries: [String]) -> [String] {
            var seen = Set<String>()
            return normalizedQueries
                .flatMap { $0.split(separator: " ").map(String.init) }
                .filter { seen.insert($0).inserted }
        }

        func bestScore(
            title: String,
            englishTitle: String,
            pronunciation: String,
            haystack: String,
            identityHaystack: String,
            normalizedQueries: [String],
            priority: SearchPriorityTier
        ) -> Int {
            normalizedQueries
                .map { query in
                    let queryTokens = query.split(separator: " ").map(String.init)
                    return score(
                        title: title,
                        englishTitle: englishTitle,
                        pronunciation: pronunciation,
                        haystack: haystack,
                        normalizedQuery: query,
                        priority: priority,
                        priorityMatchesQuery: SearchTextMatcher.matchesAllTokens(queryTokens, in: identityHaystack)
                    )
                }
                .max() ?? 0
        }

        let rootResults = rootPages
            .compactMap { page -> (result: PhraseSearchResult, score: Int)? in
                let haystack = normalize(searchText(for: page))
                guard SearchTextMatcher.matchesAllTokens(tokens, in: haystack) else {
                    return nil
                }

                let identityHaystack = normalize(searchIdentityText(for: page))
                return (
                    PhraseSearchResult(
                        pageID: page.id,
                        title: page.title,
                        subtitle: page.intentSummary
                    ),
                    score(
                        title: page.title,
                        englishTitle: page.englishTitle,
                        pronunciation: page.pronunciation,
                        haystack: haystack,
                        normalizedQuery: normalizedQuery,
                        priority: .anchor,
                        priorityMatchesQuery: SearchTextMatcher.matchesAllTokens(tokens, in: identityHaystack)
                    )
                )
            }

        let designedResults = PhraseDetailPage.all
            .compactMap { page -> (result: PhraseSearchResult, score: Int)? in
                let haystack = normalize(searchText(for: page))
                guard SearchTextMatcher.matchesAllTokens(tokens, in: haystack) else {
                    return nil
                }

                let identityHaystack = normalize(searchIdentityText(for: page))
                return (
                    PhraseSearchResult(
                        pageID: page.id,
                        title: page.title,
                        subtitle: page.englishTitle
                    ),
                    score(
                        title: page.title,
                        englishTitle: page.englishTitle,
                        pronunciation: page.pronunciation,
                        haystack: haystack,
                        normalizedQuery: normalizedQuery,
                        priority: searchPriority(for: page),
                        priorityMatchesQuery: SearchTextMatcher.matchesAllTokens(tokens, in: identityHaystack)
                    )
                )
            }

        var candidateResults = rootResults + designedResults

        if candidateResults.count < 8 {
            let looseQueries = SearchQueryExpander.looseFallbackQueries(for: query)
                .map(normalize)
                .filter { !$0.isEmpty }
            let looseTokens = uniqueTokens(for: looseQueries)

            if !looseTokens.isEmpty {
                let looseRootResults = rootPages
                    .compactMap { page -> (result: PhraseSearchResult, score: Int)? in
                        let haystack = normalize(searchText(for: page))
                        guard SearchTextMatcher.matchesAnyToken(looseTokens, in: haystack) else {
                            return nil
                        }

                        let identityHaystack = normalize(searchIdentityText(for: page))
                        return (
                            PhraseSearchResult(
                                pageID: page.id,
                                title: page.title,
                                subtitle: page.intentSummary
                            ),
                            bestScore(
                                title: page.title,
                                englishTitle: page.englishTitle,
                                pronunciation: page.pronunciation,
                                haystack: haystack,
                                identityHaystack: identityHaystack,
                                normalizedQueries: looseQueries,
                                priority: .anchor
                            )
                        )
                    }

                let looseDesignedResults = PhraseDetailPage.all
                    .compactMap { page -> (result: PhraseSearchResult, score: Int)? in
                        let haystack = normalize(searchText(for: page))
                        guard SearchTextMatcher.matchesAnyToken(looseTokens, in: haystack) else {
                            return nil
                        }

                        let identityHaystack = normalize(searchIdentityText(for: page))
                        return (
                            PhraseSearchResult(
                                pageID: page.id,
                                title: page.title,
                                subtitle: page.englishTitle
                            ),
                            bestScore(
                                title: page.title,
                                englishTitle: page.englishTitle,
                                pronunciation: page.pronunciation,
                                haystack: haystack,
                                identityHaystack: identityHaystack,
                                normalizedQueries: looseQueries,
                                priority: searchPriority(for: page)
                            )
                        )
                    }

                candidateResults += looseRootResults + looseDesignedResults
            }
        }

        var bestByPageID: [String: (result: PhraseSearchResult, score: Int)] = [:]

        for scoredResult in candidateResults {
            let currentScore = bestByPageID[scoredResult.result.pageID]?.score ?? Int.min
            if scoredResult.score > currentScore {
                bestByPageID[scoredResult.result.pageID] = scoredResult
            }
        }

        return bestByPageID.values
            .sorted {
                if $0.score == $1.score {
                    return $0.result.title < $1.result.title
                }

                return $0.score > $1.score
            }
            .map(\.result)
            .prefix(limit)
            .map { $0 }
    }

    private static var rootPages: [PhrasePage] {
        [
            .xinChao,
        ]
    }

    private static let tierOneDesignedPageIDs: Set<String> = [
        "viet-family-repair-meaning",
        "viet-thank-you",
        "viet-excuse-sorry",
        "viet-goodbye",
        "viet-how-are-you",
    ]

    private static func searchPriority(for page: PhraseDetailPage) -> SearchPriorityTier {
        tierOneDesignedPageIDs.contains(page.id) ? .tier1 : .supporting
    }

    private static func score(
        title: String,
        englishTitle: String,
        pronunciation: String,
        haystack: String,
        normalizedQuery: String,
        priority: SearchPriorityTier,
        priorityMatchesQuery: Bool
    ) -> Int {
        let title = normalize(title)
        let englishTitle = normalize(englishTitle)
        let pronunciation = normalize(pronunciation)
        var score = priorityMatchesQuery ? priority.scoreBoost : 0

        if title == normalizedQuery {
            score += 120
        }

        if englishTitle == normalizedQuery {
            score += 110
        }

        if title.contains(normalizedQuery) {
            score += 70
        }

        if pronunciation == normalizedQuery {
            score += 90
        }

        if pronunciation.contains(normalizedQuery) {
            score += 45
        }

        if englishTitle.contains(normalizedQuery) {
            score += 35
        }

        if haystack.contains(normalizedQuery) {
            score += 10
        }

        return score
    }

    private static func searchText(for page: PhrasePage) -> String {
        let optionText = (page.quickSay + page.situationalGreetings + page.localGreetings + page.followUps)
            .flatMap { [$0.vietnamese, $0.english, $0.pronunciation] }
        let breakdownText = page.breakdown.flatMap { [$0.vietnamese, $0.english] }
        let exploreText = page.exploreNext.flatMap { [$0.vietnamese, $0.english, $0.relation] }

        return ([
            page.title,
            page.englishTitle,
            page.pronunciation,
            page.intentSummary,
            page.atGlance,
            page.situationalGreetingsLeadIn,
            page.localGreetingsLeadIn,
            page.followUpsLeadIn,
            page.culturalNote,
        ] + optionText + breakdownText + exploreText)
            .joined(separator: " ")
    }

    private static func searchIdentityText(for page: PhrasePage) -> String {
        let optionText = (page.quickSay + page.situationalGreetings + page.localGreetings + page.followUps)
            .flatMap { [$0.vietnamese, $0.english, $0.pronunciation] }
        let breakdownText = page.breakdown.flatMap { [$0.vietnamese, $0.english] }
        let exploreText = page.exploreNext.flatMap { [$0.vietnamese, $0.english, $0.relation] }

        return ([page.title, page.englishTitle, page.pronunciation] + optionText + breakdownText + exploreText)
            .joined(separator: " ")
    }

    private static func searchText(for page: PhraseDetailPage) -> String {
        let sectionText = page.sections.flatMap { section in
            [section.title, section.body]
                + section.phrases.flatMap { [$0.vietnamese, $0.english, $0.pronunciation] }
                + section.breakdown.flatMap { [$0.vietnamese, $0.english] }
        }

        let exampleText = page.examples.flatMap { [$0.vietnamese, $0.english, $0.pronunciation] }

        return ([page.title, page.englishTitle, page.pronunciation, page.summary] + sectionText + exampleText)
            .joined(separator: " ")
    }

    private static func searchIdentityText(for page: PhraseDetailPage) -> String {
        let sectionText = page.sections.flatMap { section in
            section.phrases.flatMap { [$0.vietnamese, $0.english, $0.pronunciation] }
                + section.breakdown.flatMap { [$0.vietnamese, $0.english] }
        }

        let exampleText = page.examples.flatMap { [$0.vietnamese, $0.english, $0.pronunciation] }

        return ([page.title, page.englishTitle, page.pronunciation] + sectionText + exampleText)
            .joined(separator: " ")
    }

    private static func normalize(_ value: String) -> String {
        let folded = value
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .lowercased()

        let searchable = folded.unicodeScalars
            .map { scalar in
                CharacterSet.alphanumerics.contains(scalar) ? String(scalar) : " "
            }
            .joined()

        return searchable
            .split(separator: " ")
            .joined(separator: " ")
    }
}

extension PhraseDetailPage {
    static let all: [PhraseDetailPage] = uniquePages(basePages + localGreetingWayPages)

    private static let pagesByID: [String: PhraseDetailPage] = Dictionary(
        uniqueKeysWithValues: all.map { ($0.id, $0) }
    )

    private static func uniquePages(_ pages: [PhraseDetailPage]) -> [PhraseDetailPage] {
        var seen = Set<String>()
        return pages.filter { page in
            seen.insert(page.id).inserted
        }
    }

    private static var basePages: [PhraseDetailPage] {
        [
        respectfulHello,
        phoneHello,
        ] + localGreetingRootPages + [
        timeGreetings,
        howAreYou,
        whereGoing,
        niceToMeetYou,
        thankYou,
        excuseSorry,
        goodbye,
        ]
    }

    private static var localGreetingRootPages: [PhraseDetailPage] {
        [
            helloAnh,
            helloChi,
            helloEm,
            helloOng,
            helloBa,
            helloChu,
            helloCo,
        ]
    }

    static func page(withID id: String) -> PhraseDetailPage? {
        if let sqlitePage = VietSQLitePhraseGraphRuntime.detailPage(withID: id) {
            return sqlitePage
        }

        if let menuPage = VietnameseMenuCatalog.detailPage(withID: id) {
            return menuPage
        }

        if let locationMenuPage = LocationMenuPicksCatalog.detailPage(withID: id) {
            return locationMenuPage
        }

        return pagesByID[id]
    }

    static func hasAuthoredPage(withID id: String) -> Bool {
        pagesByID[id] != nil
    }

    var articleTemplate: PhraseArticlePage {
        PhraseArticlePage(
            id: id,
            destination: "SpeakLocal Vietnam",
            title: title,
            englishTitle: englishTitle,
            pronunciation: pronunciation,
            summary: summary,
            iconName: iconName,
            tintName: tintName,
            heroImageName: heroImageName,
            playbackAudioKey: playbackAudioKey,
            sections: sections.map(\.articleSection),
            practiceCTALabel: practiceCTALabel,
            showsCatalogExplore: showsCatalogExplore
        )
    }

    private static func wayPageID(parentID: String, wayID: String) -> String {
        "\(parentID)-way-\(wayID)"
    }

    private static func linkedWays(for parentID: String, _ ways: [PhraseOption]) -> [PhraseOption] {
        ways.map { phrase in
            var linkedPhrase = phrase
            linkedPhrase.detailPageID = phrase.id == "standard"
                ? parentID
                : wayPageID(parentID: parentID, wayID: phrase.id)
            return linkedPhrase
        }
    }

    private static func localGreetingPage(
        id: String,
        title: String,
        englishTitle: String,
        pronunciation: String,
        summary: String,
        tintName: AccentTint,
        atGlance: String,
        waysLeadIn: String,
        ways: [PhraseOption],
        relationshipWord: String,
        relationshipMeaning: String,
        fullMeaning: String,
        whenToUse: String,
        localTip: String
    ) -> PhraseDetailPage {
        let displayedWays = linkedWays(for: id, ways)

        return PhraseDetailPage(
            id: id,
            title: title,
            englishTitle: englishTitle,
            pronunciation: pronunciation,
            summary: summary,
            iconName: "person.fill",
            tintName: tintName,
            sections: [
                PhraseDetailSection(id: "at-glance", title: "At a glance", body: atGlance),
                PhraseDetailSection(
                    id: "breakdown",
                    title: "Break it down",
                    body: "The same pattern powers most local greeting pages: chào does the greeting, and the relationship word tells the listener how you are placing them socially.",
                    breakdown: [
                        BreakdownToken(id: "chao", vietnamese: "Chào", english: "greet / hello", audioKey: "breakdown-chao"),
                        BreakdownToken(id: relationshipWord, vietnamese: relationshipWord, english: relationshipMeaning, audioKey: "breakdown-\(id)-relationship"),
                        BreakdownToken(id: "full", vietnamese: title, english: fullMeaning, audioKey: "breakdown-\(id)-full"),
                    ]
                ),
                PhraseDetailSection(
                    id: "ways-to-say",
                    title: "Ways to say it",
                    body: waysLeadIn,
                    phrases: displayedWays
                ),
                PhraseDetailSection(id: "when-to-use", title: "When to use it", body: whenToUse),
                PhraseDetailSection(id: "local-tip", title: "Local tip", body: localTip),
            ],
            examples: []
        )
    }

    static let helloAnh = PhraseDetailPage(
        id: "viet-hello-anh",
        title: "Chào anh",
        englishTitle: "Hello, older brother / slightly older man",
        pronunciation: "chow anh",
        summary: "Choose the warmer hello for a slightly older man, from standard polite to more local and casual.",
        iconName: "person.fill",
        tintName: .blue,
        sections: [
            PhraseDetailSection(
                id: "at-glance",
                title: "At a glance",
                body: "Anh literally means older brother, but in daily Vietnamese it is also the normal way to address a man who seems a little older than you. The greeting changes with respect level and setting, so Chào anh is only the center of a small phrase family."
            ),
            PhraseDetailSection(
                id: "breakdown",
                title: "Break it down",
                body: "The same pattern powers most local greeting pages: chào does the greeting, and the relationship word tells the listener how you are placing them socially.",
                breakdown: [
                    BreakdownToken(id: "chao", vietnamese: "Chào", english: "greet / hello", audioKey: "breakdown-chao"),
                    BreakdownToken(id: "anh", vietnamese: "anh", english: "older brother", audioKey: "breakdown-viet-hello-anh-relationship"),
                    BreakdownToken(id: "full", vietnamese: "Chào anh", english: "hello, older man", audioKey: "breakdown-viet-hello-anh-full"),
                ]
            ),
            PhraseDetailSection(
                id: "ways-to-say",
                title: "Ways to say it",
                body: "Pick the version that matches the setting: standard, formal, respectful, attention-getting, or local small talk.",
                phrases: linkedWays(for: "viet-hello-anh", [
                    PhraseOption(id: "standard", vietnamese: "Chào anh", english: "Standard everyday hello", pronunciation: "chow anh", symbolName: "speaker.wave.2.fill", tintName: .blue, detailPageID: nil),
                    PhraseOption(id: "formal", vietnamese: "Xin chào anh", english: "More formal / polished hello", pronunciation: "sin chow anh", symbolName: "speaker.wave.2.fill", tintName: .blue, detailPageID: nil),
                    PhraseOption(id: "respectful", vietnamese: "Dạ, chào anh", english: "Respectful and well-mannered", pronunciation: "yah chow anh", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
                    PhraseOption(id: "attention", vietnamese: "Anh ơi!", english: "Excuse me / hey, older brother", pronunciation: "anh oy", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
                    PhraseOption(id: "where-going", vietnamese: "Anh đi đâu đấy?", english: "Where are you going?", pronunciation: "anh dee dow day", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
                    PhraseOption(id: "eaten-yet", vietnamese: "Anh ăn cơm chưa?", english: "Have you eaten yet?", pronunciation: "anh un guhm chua", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
                ])
            ),
            PhraseDetailSection(
                id: "when-to-use",
                title: "When to use it",
                body: "Use Chào anh with a male shopkeeper, waiter, driver, host, guide, or new acquaintance who appears slightly older than you. Use Xin chào anh when you want a more formal tone, and Dạ, chào anh when you want to sound especially respectful."
            ),
            PhraseDetailSection(
                id: "local-tip",
                title: "Local tip",
                body: "Anh is not only for biological brothers. It can also be used for customer-service workers, slightly older men, and even a boyfriend or husband. If the man looks closer to your father or uncle’s age, switch to Chào chú. If he is elderly, Chào ông is more respectful."
            ),
        ],
        examples: []
    )

    static let helloChi = localGreetingPage(
        id: "viet-hello-chi",
        title: "Chào chị",
        englishTitle: "Hello, older sister / slightly older woman",
        pronunciation: "chow chee",
        summary: "Choose the warmer hello for a slightly older woman, from standard polite to warmer local forms.",
        tintName: .red,
        atGlance: "Chị literally means older sister, but it is also the common way to address a woman who seems a little older than you. Chào chị is the standard greeting, and the variations add formality, respect, attention, or local small talk.",
        waysLeadIn: "Pick the version that matches the setting: standard, formal, respectful, attention-getting, or local social greeting.",
        ways: [
            PhraseOption(id: "standard", vietnamese: "Chào chị", english: "Standard everyday hello", pronunciation: "chow chee", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "formal", vietnamese: "Xin chào chị", english: "More formal / polished hello", pronunciation: "sin chow chee", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "respectful", vietnamese: "Dạ, chào chị", english: "Respectful and well-mannered", pronunciation: "yah chow chee", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "attention", vietnamese: "Chị ơi!", english: "Excuse me / hey, older sister", pronunciation: "chee oy", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
            PhraseOption(id: "where-going", vietnamese: "Chị đi đâu đấy?", english: "Where are you going?", pronunciation: "chee dee dow day", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "eaten-yet", vietnamese: "Chị ăn cơm chưa?", english: "Have you eaten yet?", pronunciation: "chee un guhm chua", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ],
        relationshipWord: "chị",
        relationshipMeaning: "older sister",
        fullMeaning: "hello, older woman",
        whenToUse: "Use Chào chị with a female shopkeeper, server, driver, host, guide, or new acquaintance who appears slightly older than you. Xin chào chị sounds more formal, while Dạ, chào chị adds a respectful lift.",
        localTip: "Chị is not only for biological sisters. It is often warmer and more natural than a plain hello. If the woman looks closer to your aunt’s age, switch to Chào cô. If she is elderly, Chào bà is more respectful."
    )

    static let helloEm = localGreetingPage(
        id: "viet-hello-em",
        title: "Chào em",
        englishTitle: "Hello, younger sibling / someone younger",
        pronunciation: "chow em",
        summary: "Greet someone younger in Vietnam without sounding stiff or accidentally too familiar.",
        tintName: .green,
        atGlance: "Em means younger sibling or younger person. It can sound warm and natural when the person is clearly younger than you, but it needs a little care because it also marks the relationship as familiar.",
        waysLeadIn: "Use the softer versions when the relationship is friendly; stay more neutral when the setting is formal or the age gap is unclear.",
        ways: [
            PhraseOption(id: "standard", vietnamese: "Chào em", english: "Standard friendly hello", pronunciation: "chow em", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "formal", vietnamese: "Xin chào em", english: "More formal / polite hello", pronunciation: "sin chow em", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "soft", vietnamese: "Chào em nhé", english: "Soft friendly hello", pronunciation: "chow em nyeh", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "attention", vietnamese: "Em ơi!", english: "Excuse me / hey, younger person", pronunciation: "em oy", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
            PhraseOption(id: "how-are-you", vietnamese: "Em khỏe không?", english: "How are you?", pronunciation: "em khweh khom", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
            PhraseOption(id: "eaten-yet", vietnamese: "Em ăn cơm chưa?", english: "Have you eaten yet?", pronunciation: "em un guhm chua", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ],
        relationshipWord: "em",
        relationshipMeaning: "younger sibling / younger person",
        fullMeaning: "hello, younger person",
        whenToUse: "Use Chào em with a younger staff member, student, child, or younger acquaintance in a warm casual moment. Em ơi is common when calling for attention, especially in a shop or cafe.",
        localTip: "Do not use em for someone older than you. If the person is about your age, Chào bạn can be safer. If they are older, use Chào anh or Chào chị instead."
    )

    static let helloOng = localGreetingPage(
        id: "viet-hello-ong",
        title: "Chào ông",
        englishTitle: "Hello, grandfather / elderly man",
        pronunciation: "chow ohm",
        summary: "Greet an elderly man in Vietnam with clear respect.",
        tintName: .purple,
        atGlance: "Ông means grandfather or elderly man. It carries clear respect for age, so Chào ông is best when the person is truly elderly or in a formal respect-heavy moment.",
        waysLeadIn: "Use the respectful versions when speaking directly to an elderly man; local small-talk forms can sound warm when the relationship is friendly.",
        ways: [
            PhraseOption(id: "standard", vietnamese: "Chào ông", english: "Standard respectful hello", pronunciation: "chow ohm", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
            PhraseOption(id: "formal", vietnamese: "Xin chào ông", english: "Formal respectful hello", pronunciation: "sin chow ohm", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
            PhraseOption(id: "respectful", vietnamese: "Dạ, chào ông", english: "Very respectful hello", pronunciation: "yah chow ohm", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "attention", vietnamese: "Ông ơi!", english: "Excuse me / sir", pronunciation: "ohm oy", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
            PhraseOption(id: "how-are-you", vietnamese: "Ông khỏe không?", english: "How are you?", pronunciation: "ohm khweh khom", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
            PhraseOption(id: "eaten-yet", vietnamese: "Ông ăn cơm chưa?", english: "Have you eaten yet?", pronunciation: "ohm un guhm chua", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ],
        relationshipWord: "ông",
        relationshipMeaning: "grandfather / elderly man",
        fullMeaning: "hello, elderly man",
        whenToUse: "Use Chào ông when greeting an elderly man in a family, neighborhood, market, hotel, or service setting. Dạ, chào ông is the more respectful upgrade.",
        localTip: "For a man who is older but not elderly, Chào chú usually sounds more natural. For someone only slightly older, Chào anh is warmer and less distant."
    )

    static let helloBa = localGreetingPage(
        id: "viet-hello-ba",
        title: "Chào bà",
        englishTitle: "Hello, grandmother / elderly woman",
        pronunciation: "chow bah",
        summary: "Greet an elderly woman in Vietnam with warmth and respect.",
        tintName: .red,
        atGlance: "Bà means grandmother or elderly woman. Chào bà is respectful and direct, and it works best when the woman is clearly elderly or when you want to show extra deference.",
        waysLeadIn: "Use the respectful versions for elderly women; local small-talk forms can feel warmer when the moment is personal.",
        ways: [
            PhraseOption(id: "standard", vietnamese: "Chào bà", english: "Standard respectful hello", pronunciation: "chow bah", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "formal", vietnamese: "Xin chào bà", english: "Formal respectful hello", pronunciation: "sin chow bah", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "respectful", vietnamese: "Dạ, chào bà", english: "Very respectful hello", pronunciation: "yah chow bah", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "attention", vietnamese: "Bà ơi!", english: "Excuse me / ma'am", pronunciation: "bah oy", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
            PhraseOption(id: "how-are-you", vietnamese: "Bà khỏe không?", english: "How are you?", pronunciation: "bah khweh khom", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
            PhraseOption(id: "eaten-yet", vietnamese: "Bà ăn cơm chưa?", english: "Have you eaten yet?", pronunciation: "bah un guhm chua", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ],
        relationshipWord: "bà",
        relationshipMeaning: "grandmother / elderly woman",
        fullMeaning: "hello, elderly woman",
        whenToUse: "Use Chào bà when greeting an elderly woman in a family, neighborhood, market, hotel, or service setting. Dạ, chào bà is the extra respectful version.",
        localTip: "For a woman who is older but not elderly, Chào cô usually fits better. For someone only slightly older, Chào chị sounds more natural."
    )

    static let helloChu = localGreetingPage(
        id: "viet-hello-chu",
        title: "Chào chú",
        englishTitle: "Hello, uncle / older man",
        pronunciation: "chow choo",
        summary: "Greet an older adult man in Vietnam when anh feels too young and ông feels too old.",
        tintName: .teal,
        atGlance: "Chú means uncle or older man. It sits between anh and ông, so Chào chú is useful when the man is older than you but not elderly.",
        waysLeadIn: "Use these when the person feels like an uncle-aged adult rather than a slightly older brother or grandfather.",
        ways: [
            PhraseOption(id: "standard", vietnamese: "Chào chú", english: "Standard respectful hello", pronunciation: "chow choo", symbolName: "speaker.wave.2.fill", tintName: .teal, detailPageID: nil),
            PhraseOption(id: "formal", vietnamese: "Xin chào chú", english: "More formal / polished hello", pronunciation: "sin chow choo", symbolName: "speaker.wave.2.fill", tintName: .teal, detailPageID: nil),
            PhraseOption(id: "respectful", vietnamese: "Dạ, chào chú", english: "Respectful and well-mannered", pronunciation: "yah chow choo", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "attention", vietnamese: "Chú ơi!", english: "Excuse me / uncle", pronunciation: "choo oy", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
            PhraseOption(id: "where-going", vietnamese: "Chú đi đâu đấy?", english: "Where are you going?", pronunciation: "choo dee dow day", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "eaten-yet", vietnamese: "Chú ăn cơm chưa?", english: "Have you eaten yet?", pronunciation: "choo un guhm chua", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ],
        relationshipWord: "chú",
        relationshipMeaning: "uncle / older man",
        fullMeaning: "hello, older man",
        whenToUse: "Use Chào chú for an adult man older than you, especially if he feels closer to an uncle than an older brother. Dạ, chào chú is a good respectful version for service or family settings.",
        localTip: "If he is only slightly older, Chào anh may feel smoother. If he is elderly, Chào ông is more respectful."
    )

    static let helloCo = localGreetingPage(
        id: "viet-hello-co",
        title: "Chào cô",
        englishTitle: "Hello, aunt / older woman",
        pronunciation: "chow koh",
        summary: "Greet an older adult woman in Vietnam when chị feels too young and bà feels too old.",
        tintName: .red,
        atGlance: "Cô means aunt or older woman. It is also common for female teachers and adult women in respectful settings, so Chào cô is a useful middle point between chị and bà.",
        waysLeadIn: "Use these when the person feels like an aunt-aged adult rather than a slightly older sister or grandmother.",
        ways: [
            PhraseOption(id: "standard", vietnamese: "Chào cô", english: "Standard respectful hello", pronunciation: "chow koh", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "formal", vietnamese: "Xin chào cô", english: "More formal / polished hello", pronunciation: "sin chow koh", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "respectful", vietnamese: "Dạ, chào cô", english: "Respectful and well-mannered", pronunciation: "yah chow koh", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "attention", vietnamese: "Cô ơi!", english: "Excuse me / aunt", pronunciation: "koh oy", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
            PhraseOption(id: "where-going", vietnamese: "Cô đi đâu đấy?", english: "Where are you going?", pronunciation: "koh dee dow day", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "eaten-yet", vietnamese: "Cô ăn cơm chưa?", english: "Have you eaten yet?", pronunciation: "koh un guhm chua", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ],
        relationshipWord: "cô",
        relationshipMeaning: "aunt / older woman",
        fullMeaning: "hello, older woman",
        whenToUse: "Use Chào cô for an adult woman older than you, especially if she feels closer to an aunt than an older sister. It is also common for teachers and respectful service interactions.",
        localTip: "If she is only slightly older, Chào chị may feel smoother. If she is elderly, Chào bà is more respectful."
    )

    private static var localGreetingWayPages: [PhraseDetailPage] {
        localGreetingRootPages.flatMap { parent -> [PhraseDetailPage] in
            guard let ways = parent.sections.first(where: { $0.id == "ways-to-say" }) else {
                return []
            }

            return ways.phrases.compactMap { phrase in
                guard let childID = phrase.detailPageID else {
                    return nil
                }

                guard childID != parent.id else {
                    return nil
                }

                return localGreetingWayPage(parent: parent, phrase: phrase, id: childID)
            }
        }
    }

    private static func localGreetingWayPage(parent: PhraseDetailPage, phrase: PhraseOption, id: String) -> PhraseDetailPage {
        let copy = localGreetingWayCopy(parent: parent, phrase: phrase)
        var playablePhrase = phrase
        playablePhrase.detailPageID = nil

        return PhraseDetailPage(
            id: id,
            title: phrase.vietnamese,
            englishTitle: phrase.english,
            pronunciation: phrase.pronunciation,
            summary: copy.summary,
            iconName: phrase.symbolName,
            tintName: phrase.tintName,
            sections: [
                PhraseDetailSection(id: "at-glance", title: "At a glance", body: copy.atGlance),
                PhraseDetailSection(id: "how-it-fits", title: "How it fits", body: copy.howItFits),
                PhraseDetailSection(id: "when-to-use", title: "When to use it", body: copy.whenToUse),
            ],
            examples: [playablePhrase]
        )
    }

    private static func localGreetingWayCopy(
        parent: PhraseDetailPage,
        phrase: PhraseOption
    ) -> (summary: String, atGlance: String, howItFits: String, whenToUse: String) {
        switch phrase.id {
        case "standard":
            return (
                "The plain default form inside the \(parent.title) greeting family.",
                "\(phrase.vietnamese) is the clean everyday version. It keeps the relationship word, so it sounds more local than a generic Xin chào without adding extra formality.",
                "This is the center phrase for \(parent.title). The other versions add respect, attention, or small-talk flavor around this same relationship choice.",
                "Use it when the person’s age or role is clear and the moment is friendly, normal, or service-oriented."
            )
        case "formal":
            return (
                "A more polished version of \(parent.title) for formal or careful moments.",
                "Adding Xin makes the greeting more formal and slightly more distant. It is useful when you want to sound careful, polite, or professional.",
                "This still belongs to the \(parent.title) family, but Xin moves it closer to a formal introduction than a casual local greeting.",
                "Use it at reception desks, business-like introductions, hosted stays, or any moment where a plain chào feels too casual."
            )
        case "respectful":
            return (
                "The respectful upgrade for \(parent.title).",
                "Dạ at the front works like a small verbal bow. It signals respect before the greeting even starts.",
                "This keeps the same relationship word as \(parent.title), but adds an extra layer of deference.",
                "Use it with older adults, hosts, drivers, staff helping you, or anyone you want to treat with extra respect."
            )
        case "attention":
            return (
                "A natural attention-getter connected to \(parent.title).",
                "\(phrase.vietnamese) is closer to calling someone over than saying a formal hello. In Vietnam, getting someone’s attention often acts as the start of the greeting.",
                "The ơi ending turns the relationship word into a call: friendly, direct, and very common in shops, cafes, and casual service moments.",
                "Use it when you need someone’s attention. Keep your tone warm so it feels friendly instead of abrupt."
            )
        case "where-going":
            return (
                "A local social greeting that sounds like a question.",
                "\(phrase.vietnamese) literally asks where someone is going, but socially it can work like casual neighborly small talk.",
                "This moves beyond hello into the kind of light question locals may use when they already share a friendly moment.",
                "Use it with familiar people or when someone has already made the interaction casual. Avoid it as a first line with strangers."
            )
        case "eaten-yet":
            return (
                "A warm social check that can follow hello.",
                "\(phrase.vietnamese) literally asks whether the person has eaten. In social use, it can show care more than a need for meal details.",
                "This phrase belongs after the greeting. It turns \(parent.title) from a quick hello into a warmer local exchange.",
                "Use it with hosts, neighbors, family-style settings, or friendly people you already have rapport with."
            )
        case "how-are-you":
            return (
                "A friendly health check attached to the greeting.",
                "\(phrase.vietnamese) asks how the person is. It is useful when the greeting has room to become small talk.",
                "This is a follow-up path from \(parent.title), not just a replacement for hello.",
                "Use it with someone younger or familiar when the moment is relaxed enough for a short social exchange."
            )
        case "soft":
            return (
                "A softer friendly version of \(parent.title).",
                "The nhé ending softens the phrase and makes it feel warmer. It can sound friendly when speaking to someone younger.",
                "This keeps the same greeting structure, but changes the tone from plain to gentle.",
                "Use it in relaxed, friendly moments. Avoid it if the relationship is formal or the age dynamic is unclear."
            )
        default:
            return (
                "A focused phrase page from the \(parent.title) greeting family.",
                "\(phrase.vietnamese) is one of the usable forms connected to \(parent.title).",
                "It shares the same core relationship logic as the parent page, but teaches one exact phrase.",
                "Use it when its tone and setting match the moment."
            )
        }
    }

    static let respectfulHello = PhraseDetailPage(
        id: "viet-respectful-hello",
        title: "Dạ, chào anh/chị",
        englishTitle: "Respectful hello",
        pronunciation: "yah chow anh chee",
        summary: "A warmer, more local greeting when you want to sound polite to an adult, host, driver, or staff member.",
        iconName: "person.2.fill",
        tintName: .red,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "Dạ softens the greeting and shows respect. Anh and chị choose the relationship word for an adult man or woman."),
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use this at a hotel desk, shop counter, restaurant, homestay, or with someone helping you."),
            PhraseDetailSection(id: "good-to-know", title: "Good to know", body: "If you are unsure whether to use anh or chị, Xin chào is still safe. This phrase is for when you want to sound a little more natural."),
        ],
        examples: [
            PhraseOption(id: "respect-anh", vietnamese: "Dạ, chào anh", english: "Hello, sir / older brother", pronunciation: "yah chow anh", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "respect-chi", vietnamese: "Dạ, chào chị", english: "Hello, ma'am / older sister", pronunciation: "yah chow chee", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
        ]
    )

    static let phoneHello = PhraseDetailPage(
        id: "viet-phone-hello",
        title: "Alô",
        englishTitle: "Hello on the phone",
        pronunciation: "ah-lo",
        summary: "The natural way to answer or check a phone call in Vietnamese.",
        iconName: "phone.fill",
        tintName: .green,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "Alô is for calls. It is not the normal greeting when you walk into a shop or meet someone face to face."),
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use it when answering a call, calling a driver, or checking whether the other person can hear you."),
        ],
        examples: [
            PhraseOption(id: "phone-basic", vietnamese: "Alô", english: "Hello? / Can you hear me?", pronunciation: "ah-lo", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ]
    )

    static let localGreetings = PhraseDetailPage(
        id: "viet-local-greetings",
        title: "How locals greet",
        englishTitle: "Relationship-based greetings",
        pronunciation: "chow + relationship word",
        summary: "Vietnamese often swaps a plain hello for a greeting that names the relationship, age, or respect level.",
        iconName: "person.2",
        tintName: .blue,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "These forms can feel warmer than Xin chào because they show how you see the other person in the social moment."),
            PhraseDetailSection(id: "safe", title: "Safe default", body: "Use Xin chào when you are unsure. Try the local forms when the relationship is obvious or someone uses that form with you first."),
        ],
        examples: [
            PhraseOption(id: "friend", vietnamese: "Chào bạn", english: "Hi, friend / you", pronunciation: "chow ban", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
            PhraseOption(id: "anh", vietnamese: "Chào anh", english: "Hello, slightly older man", pronunciation: "chow anh", symbolName: "speaker.wave.2.fill", tintName: .blue, detailPageID: nil),
            PhraseOption(id: "chi", vietnamese: "Chào chị", english: "Hello, slightly older woman", pronunciation: "chow chee", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "em", vietnamese: "Chào em", english: "Hello, younger person", pronunciation: "chow em", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "ong", vietnamese: "Chào ông", english: "Hello, elderly man", pronunciation: "chow ohm", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
            PhraseOption(id: "ba", vietnamese: "Chào bà", english: "Hello, elderly woman", pronunciation: "chow bah", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "chu", vietnamese: "Chào chú", english: "Hello, uncle / older man", pronunciation: "chow choo", symbolName: "speaker.wave.2.fill", tintName: .teal, detailPageID: nil),
            PhraseOption(id: "co", vietnamese: "Chào cô", english: "Hello, aunt / older woman", pronunciation: "chow koh", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
        ]
    )

    static let timeGreetings = PhraseDetailPage(
        id: "viet-time-greetings",
        title: "Time-of-day greetings",
        englishTitle: "Good morning / afternoon",
        pronunciation: "chow boo-ee...",
        summary: "Useful greetings when you want a familiar English-style morning or afternoon greeting.",
        iconName: "sun.max.fill",
        tintName: .blue,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "These are understandable, but travelers should know that relationship greetings often sound more natural in everyday Vietnamese."),
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use them in polite service moments, lessons, hosted stays, or when the time of day is the point of the greeting."),
        ],
        examples: [
            PhraseOption(id: "morning", vietnamese: "Chào buổi sáng", english: "Good morning", pronunciation: "chow boo-ee sahng", symbolName: "speaker.wave.2.fill", tintName: .blue, detailPageID: nil),
            PhraseOption(id: "afternoon", vietnamese: "Chào buổi chiều", english: "Good afternoon", pronunciation: "chow boo-ee chee-ew", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
        ]
    )

    static let howAreYou = PhraseDetailPage(
        id: "viet-how-are-you",
        title: "Bạn khỏe không?",
        englishTitle: "How are you?",
        pronunciation: "ban khweh khom",
        summary: "A friendly follow-up after hello when the moment is social enough for small talk.",
        iconName: "bubble.left.and.bubble.right.fill",
        tintName: .purple,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "This is not always necessary in quick service moments. It works best when the exchange has room for friendliness."),
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use it with a host, teacher, guide, familiar staff member, or someone you are meeting socially."),
        ],
        examples: [
            PhraseOption(id: "how-are-you", vietnamese: "Bạn khỏe không?", english: "How are you?", pronunciation: "ban khweh khom", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
        ]
    )

    static let whereGoing = PhraseDetailPage(
        id: "viet-where-going",
        title: "Đi đâu đấy?",
        englishTitle: "Where are you going?",
        pronunciation: "dee dow day",
        summary: "A common casual question that can work as social small talk, not only a literal request for directions.",
        iconName: "figure.walk",
        tintName: .orange,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "The English translation can sound nosy. In Vietnamese, it can be a light neighborly greeting depending on tone and relationship."),
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use it when someone familiar asks first, or when you are practicing casual social language with someone friendly."),
        ],
        examples: [
            PhraseOption(id: "where-going", vietnamese: "Đi đâu đấy?", english: "Where are you going?", pronunciation: "dee dow day", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
        ]
    )

    static let niceToMeetYou = PhraseDetailPage(
        id: "viet-nice-to-meet-you",
        title: "Rất vui được gặp bạn",
        englishTitle: "Nice to meet you",
        pronunciation: "zuht voo-ee duhk gap ban",
        summary: "Make an introduction feel warm, polite, or more formal after the first hello.",
        iconName: "hands.sparkles.fill",
        tintName: .teal,
        sections: [
            PhraseDetailSection(
                id: "at-glance",
                title: "At a glance",
                body: "Vietnamese does not lean on Nice to meet you as often as English does. People may move straight from hello into a friendly question. Still, this phrase is polite, easy to understand, and useful when an introduction deserves a little warmth."
            ),
            PhraseDetailSection(
                id: "breakdown",
                title: "Break it down",
                body: "The phrase says you are very happy to meet the person. Swap the final pronoun when the person is older, younger, or in a more respectful role.",
                breakdown: [
                    BreakdownToken(id: "rat", vietnamese: "Rất", english: "very", audioKey: "audio-phrase-rat"),
                    BreakdownToken(id: "vui", vietnamese: "vui", english: "happy"),
                    BreakdownToken(id: "duoc-gap", vietnamese: "được gặp", english: "to meet", audioKey: "audio-phrase-duoc-gap"),
                    BreakdownToken(id: "ban", vietnamese: "bạn", english: "you / friend"),
                    BreakdownToken(id: "full", vietnamese: "Rất vui được gặp bạn", english: "Nice to meet you", audioKey: "audio-phrase-rat-vui-duoc-gap-ban"),
                ]
            ),
            PhraseDetailSection(
                id: "ways-to-say",
                title: "Ways to say it",
                body: "Use the standard form for most introductions, then shift the ending or tone when the relationship is clearer.",
                phrases: [
                    PhraseOption(id: "standard", vietnamese: "Rất vui được gặp bạn", english: "Standard nice to meet you", pronunciation: "zuht voo-ee duhk gap ban", symbolName: "speaker.wave.2.fill", tintName: .teal, detailPageID: nil, audioKey: "audio-phrase-rat-vui-duoc-gap-ban"),
                    PhraseOption(id: "older-man", vietnamese: "Rất vui được gặp anh", english: "Nice to meet you, older man", pronunciation: "zuht voo-ee duhk gap anh", symbolName: "speaker.wave.2.fill", tintName: .blue, detailPageID: nil),
                    PhraseOption(id: "older-woman", vietnamese: "Rất vui được gặp chị", english: "Nice to meet you, older woman", pronunciation: "zuht voo-ee duhk gap chee", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
                    PhraseOption(id: "formal-anh", vietnamese: "Rất hân hạnh được gặp anh", english: "Honored to meet you, older man", pronunciation: "zuht hun hanh duhk gap anh", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
                    PhraseOption(id: "formal-chi", vietnamese: "Rất hân hạnh được gặp chị", english: "Honored to meet you, older woman", pronunciation: "zuht hun hanh duhk gap chee", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
                    PhraseOption(id: "deep-respect-anh", vietnamese: "Vinh dự được gặp anh", english: "It is an honor to meet you, older man", pronunciation: "vinh zoo duhk gap anh", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
                    PhraseOption(id: "deep-respect-chi", vietnamese: "Vinh dự được gặp chị", english: "It is an honor to meet you, older woman", pronunciation: "vinh zoo duhk gap chee", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
                    PhraseOption(id: "friendly", vietnamese: "Vui quá!", english: "So happy! / How nice!", pronunciation: "voo-ee gwah", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
                    PhraseOption(id: "again", vietnamese: "Rất vui được gặp lại bạn", english: "Nice to see you again", pronunciation: "zuht voo-ee duhk gap lie ban", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
                ]
            ),
            PhraseDetailSection(
                id: "pronoun-refresher",
                title: "Pronoun refresher",
                body: "Use anh for a slightly older man, chị for a slightly older woman, chú for an uncle-aged man, cô for an aunt-aged woman, em for someone younger, and bạn for a peer or when you want a neutral friendly default."
            ),
            PhraseDetailSection(
                id: "when-to-use",
                title: "When to use it",
                body: "Use this after someone shares their name, when meeting a host, guide, teacher, classmate, coworker, or new friend. In quick service moments, a greeting plus thanks may be more natural than a full introduction phrase."
            ),
            PhraseDetailSection(
                id: "local-tip",
                title: "Local tip",
                body: "To make the exchange feel more natural, follow it with a light question like Bạn đến từ đâu? or Bạn ở đây lâu chưa? That moves the phrase from polite introduction into a real conversation."
            ),
        ],
        examples: [
            PhraseOption(id: "nice-meet", vietnamese: "Rất vui được gặp bạn", english: "Nice to meet you", pronunciation: "zuht voo-ee duhk gap ban", symbolName: "speaker.wave.2.fill", tintName: .teal, detailPageID: nil, audioKey: "audio-phrase-rat-vui-duoc-gap-ban"),
        ]
    )

    static let thankYou = PhraseDetailPage(
        id: "viet-thank-you",
        title: "Cảm ơn",
        englishTitle: "Thank you",
        pronunciation: "kahm uhn",
        summary: "A core phrase for keeping service moments and everyday help warm and simple.",
        iconName: "heart.fill",
        tintName: .green,
        sections: [
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use it anytime someone helps you, serves you, gives directions, or answers a question."),
            PhraseDetailSection(id: "upgrade", title: "A warmer version", body: "Cảm ơn nhiều means thank you very much. Save it for when someone went out of their way."),
        ],
        examples: [
            PhraseOption(id: "thank-you", vietnamese: "Cảm ơn", english: "Thank you", pronunciation: "kahm uhn", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "thank-you-many", vietnamese: "Cảm ơn nhiều", english: "Thank you very much", pronunciation: "kahm uhn nyew", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ]
    )

    static let excuseSorry = PhraseDetailPage(
        id: "viet-excuse-sorry",
        title: "Xin lỗi",
        englishTitle: "Excuse me / sorry",
        pronunciation: "sin loy",
        summary: "A flexible phrase for getting attention, passing by, or apologizing lightly.",
        iconName: "hand.raised.fill",
        tintName: .blue,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "Xin lỗi can mean sorry or excuse me, so it is one of the easiest ways for travelers to reset a small social moment."),
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use it before asking a question, when squeezing past someone, or after a small mistake."),
        ],
        examples: [
            PhraseOption(id: "excuse-sorry", vietnamese: "Xin lỗi", english: "Excuse me / sorry", pronunciation: "sin loy", symbolName: "speaker.wave.2.fill", tintName: .blue, detailPageID: nil),
        ]
    )

    static let goodbye = PhraseDetailPage(
        id: "viet-goodbye",
        title: "Tạm biệt",
        englishTitle: "Goodbye",
        pronunciation: "tahm bee-et",
        summary: "A clean way to close the exchange when leaving a shop, cafe, hotel desk, or social moment.",
        iconName: "sparkles",
        tintName: .purple,
        sections: [
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use this when leaving or ending a conversation politely."),
            PhraseDetailSection(id: "natural", title: "Natural exit", body: "A smile plus Cảm ơn can sometimes be enough after a service exchange. Tạm biệt is clearer when you want a real goodbye."),
        ],
        examples: [
            PhraseOption(id: "goodbye", vietnamese: "Tạm biệt", english: "Goodbye", pronunciation: "tahm bee-et", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
        ]
    )
}
