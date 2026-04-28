import Foundation

struct GeneratedVietCatalog: Decodable {
    let metadata: GeneratedVietCatalogMetadata
    let scenarios: [GeneratedVietScenario]
    let families: [GeneratedVietFamily]
    let phrases: [GeneratedVietPhrase]

    func scenario(withID id: String) -> GeneratedVietScenario? {
        scenarios.first { $0.id == id }
    }

    func family(withPageID pageID: String) -> GeneratedVietFamily? {
        families.first { family in
            GeneratedVietContent.canonicalPageID(
                for: family,
                primaryPhrase: phrase(withID: family.primaryPhraseID)
            ) == pageID
        }
    }

    func family(withID id: String) -> GeneratedVietFamily? {
        families.first { $0.id == id }
    }

    func phrase(withID id: String) -> GeneratedVietPhrase? {
        phrases.first { $0.id == id }
    }

    func phrases(for family: GeneratedVietFamily) -> [GeneratedVietPhrase] {
        family.phraseIDs.compactMap(phrase(withID:))
    }
}

struct GeneratedVietCatalogMetadata: Decodable {
    let source: String
    let phraseCount: Int
    let familyCount: Int
    let scenarioCount: Int
}

struct GeneratedVietScenario: Decodable, Equatable {
    let id: String
    let title: String
    let symbolName: String
    let tintName: String
}

struct GeneratedVietFamily: Decodable, Equatable {
    let id: String
    let pageID: String
    let scenarioID: String
    let familyTitle: String
    let summary: String
    let primaryPhraseID: String
    let accessTier: String
    let phraseIDs: [String]
}

struct GeneratedVietPhrase: Decodable, Equatable {
    let id: String
    let familyID: String
    let scenarioID: String
    let audioKey: String
    let englishText: String
    let targetText: String
    let canonicalTargetText: String
    let pronunciation: String
    let accessTier: String
    let variantRole: String
    let context: String
    let youMayHear: String
    let searchAliases: [String]
    let warningNoteType: String
    let audioStatus: String
    let emoji: String
    let notes: String
}

struct PhraseSearchScoredResult {
    let result: PhraseSearchResult
    let score: Int
}

enum SearchPriorityTier: Int, Comparable {
    case deepCatalog = 0
    case supporting = 1
    case tier1 = 2
    case anchor = 3

    static func < (lhs: SearchPriorityTier, rhs: SearchPriorityTier) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var scoreBoost: Int {
        switch self {
        case .deepCatalog:
            return 0
        case .supporting:
            return 25
        case .tier1:
            return 60
        case .anchor:
            return 90
        }
    }

    var requiresAuthoredListing: Bool {
        self == .tier1 || self == .anchor
    }
}

enum SearchTextMatcher {
    static func matchesAllTokens(_ tokens: [String], in normalizedText: String) -> Bool {
        let indexedTokens = Set(searchTokens(in: normalizedText))

        return tokens.allSatisfy { token in
            indexedTokens.contains(token) || indexedTokens.contains { $0.hasPrefix(token) }
        }
    }

    private static func searchTokens(in normalizedText: String) -> [String] {
        normalizedText
            .unicodeScalars
            .split { !CharacterSet.alphanumerics.contains($0) }
            .map(String.init)
    }
}

private struct GeneratedVietCatalogIndex {
    let phrasesByID: [String: GeneratedVietPhrase]
    let scenariosByID: [String: GeneratedVietScenario]
    let phrasesByFamilyID: [String: [GeneratedVietPhrase]]
    let familiesByScenarioID: [String: [GeneratedVietFamily]]
    let familiesByCanonicalPageID: [String: GeneratedVietFamily]
    let canonicalPageIDsByFamilyID: [String: String]

    init(catalog: GeneratedVietCatalog) {
        let phrasesByID = Dictionary(uniqueKeysWithValues: catalog.phrases.map { ($0.id, $0) })
        let scenariosByID = Dictionary(uniqueKeysWithValues: catalog.scenarios.map { ($0.id, $0) })
        let groupedPhrases = Dictionary(grouping: catalog.phrases, by: \.familyID)
        let groupedFamilies = Dictionary(grouping: catalog.families, by: \.scenarioID)
        var familiesByCanonicalPageID: [String: GeneratedVietFamily] = [:]
        var canonicalPageIDsByFamilyID: [String: String] = [:]

        for family in catalog.families {
            let primaryPhrase = phrasesByID[family.primaryPhraseID]
            let canonicalPageID = GeneratedVietContent.canonicalPageID(
                for: family,
                primaryPhrase: primaryPhrase
            )

            familiesByCanonicalPageID[canonicalPageID] = family
            canonicalPageIDsByFamilyID[family.id] = canonicalPageID
        }

        self.phrasesByID = phrasesByID
        self.scenariosByID = scenariosByID
        self.phrasesByFamilyID = groupedPhrases
        self.familiesByScenarioID = groupedFamilies
        self.familiesByCanonicalPageID = familiesByCanonicalPageID
        self.canonicalPageIDsByFamilyID = canonicalPageIDsByFamilyID
    }
}

private struct GeneratedBreakdownPiece {
    let vietnamese: String
    let english: String
}

private final class PhraseDetailPageCacheBox {
    let page: PhraseDetailPage

    init(_ page: PhraseDetailPage) {
        self.page = page
    }
}

enum GeneratedVietContent {
    static let catalog: GeneratedVietCatalog? = loadCatalog()
    private static let catalogIndex: GeneratedVietCatalogIndex? = catalog.map(GeneratedVietCatalogIndex.init)
    private static let detailPageCache = NSCache<NSString, PhraseDetailPageCacheBox>()

    static var tierOnePageIDs: Set<String> {
        guard let catalog, let catalogIndex else {
            return [PhrasePage.xinChao.id]
        }

        var pageIDs: Set<String> = [PhrasePage.xinChao.id]

        for family in catalog.families {
            guard let primaryPhrase = catalogIndex.phrasesByID[family.primaryPhraseID] else {
                continue
            }

            let priority = searchPriority(for: family, primaryPhrase: primaryPhrase)
            guard priority.requiresAuthoredListing else {
                continue
            }

            pageIDs.insert(catalogIndex.canonicalPageIDsByFamilyID[family.id] ?? family.pageID)
        }

        return pageIDs
    }

    static func searchPriority(forFamilyID familyID: String) -> SearchPriorityTier? {
        guard
            let catalog,
            let catalogIndex,
            let family = catalog.family(withID: familyID),
            let primaryPhrase = catalogIndex.phrasesByID[family.primaryPhraseID]
        else {
            return nil
        }

        return searchPriority(for: family, primaryPhrase: primaryPhrase)
    }

    static func canonicalPageID(
        for family: GeneratedVietFamily,
        primaryPhrase: GeneratedVietPhrase?
    ) -> String {
        if let designedPageID = designedFamilyPageIDs[family.id] {
            return designedPageID
        }

        return family.pageID
    }

    static var scenarioCategories: [PhraseCategory] {
        guard let catalog else {
            return []
        }

        return catalog.scenarios.map { scenario in
            PhraseCategory(
                id: scenario.id,
                title: scenario.title,
                symbolName: scenario.symbolName,
                tintName: AccentTint(rawValue: scenario.tintName) ?? .gray
            )
        }
    }

    static func catalogItems(excludingPageIDs excludedPageIDs: Set<String>) -> [PhraseCatalogItem] {
        guard let catalog, let catalogIndex else {
            return []
        }

        return catalog.families.compactMap { family in
            guard let primaryPhrase = catalogIndex.phrasesByID[family.primaryPhraseID] else {
                return nil
            }

            let pageID = catalogIndex.canonicalPageIDsByFamilyID[family.id] ?? family.pageID
            guard !excludedPageIDs.contains(pageID) else {
                return nil
            }

            let scenario = catalogIndex.scenariosByID[family.scenarioID]

            return PhraseCatalogItem(
                pageID: pageID,
                title: primaryPhrase.targetText,
                subtitle: primaryPhrase.englishText,
                categoryIDs: [family.scenarioID],
                symbolName: scenario?.symbolName ?? "text.bubble.fill",
                tintName: AccentTint(rawValue: scenario?.tintName ?? "") ?? .gray,
                audioKey: primaryPhrase.audioKey
            )
        }
    }

    static func hasDetailPage(withID id: String) -> Bool {
        guard let catalogIndex, let family = catalogIndex.familiesByCanonicalPageID[id] else {
            return false
        }

        return catalogIndex.canonicalPageIDsByFamilyID[family.id] == family.pageID
    }

    static func detailPage(withID id: String) -> PhraseDetailPage? {
        let cacheKey = id as NSString
        if let cachedPage = detailPageCache.object(forKey: cacheKey)?.page {
            return cachedPage
        }

        guard
            let catalogIndex,
            let family = catalogIndex.familiesByCanonicalPageID[id],
            let primaryPhrase = catalogIndex.phrasesByID[family.primaryPhraseID]
        else {
            return nil
        }

        guard catalogIndex.canonicalPageIDsByFamilyID[family.id] == family.pageID else {
            return nil
        }

        let scenario = catalogIndex.scenariosByID[family.scenarioID]
        let familyPhrases = catalogIndex.phrasesByFamilyID[family.id] ?? []
        let phraseOptions = familyPhrases.map { phrase in
            PhraseOption(
                id: phrase.id,
                vietnamese: phrase.targetText,
                english: phrase.englishText,
                pronunciation: phrase.pronunciation,
                symbolName: "speaker.wave.2.fill",
                tintName: AccentTint(rawValue: scenario?.tintName ?? "") ?? .red,
                detailPageID: nil,
                audioKey: phrase.audioKey
            )
        }
        let exploreNextOptions = exploreNextOptions(
            for: family,
            excludingPageID: id,
            catalogIndex: catalogIndex
        )
        let sections = detailSections(
            family: family,
            primaryPhrase: primaryPhrase,
            phraseOptions: phraseOptions,
            scenario: scenario,
            exploreNextOptions: exploreNextOptions
        )

        let page = PhraseDetailPage(
            id: id,
            title: primaryPhrase.targetText,
            englishTitle: primaryPhrase.englishText,
            pronunciation: primaryPhrase.pronunciation,
            summary: family.summary,
            iconName: scenario?.symbolName ?? "text.bubble.fill",
            tintName: AccentTint(rawValue: scenario?.tintName ?? "") ?? .gray,
            sections: sections,
            examples: [],
            audioKey: primaryPhrase.audioKey
        )

        detailPageCache.setObject(PhraseDetailPageCacheBox(page), forKey: cacheKey)
        return page
    }

    static func search(_ query: String) -> [PhraseSearchScoredResult] {
        let normalizedQuery = normalize(query)
        guard !normalizedQuery.isEmpty, let catalog, let catalogIndex else {
            return []
        }

        let tokens = normalizedQuery
            .split(separator: " ")
            .map(String.init)

        return catalog.families.compactMap { family -> PhraseSearchScoredResult? in
            guard let primaryPhrase = catalogIndex.phrasesByID[family.primaryPhraseID] else {
                return nil
            }

            let phrases = catalogIndex.phrasesByFamilyID[family.id] ?? []
            let haystack = normalize(searchText(family: family, phrases: phrases))
            guard SearchTextMatcher.matchesAllTokens(tokens, in: haystack) else {
                return nil
            }

            let identityHaystack = normalize(searchIdentityText(
                family: family,
                primaryPhrase: primaryPhrase,
                phrases: phrases
            ))
            let pageID = catalogIndex.canonicalPageIDsByFamilyID[family.id] ?? family.pageID
            let score = searchScore(
                title: primaryPhrase.targetText,
                englishTitle: primaryPhrase.englishText,
                pronunciation: primaryPhrase.pronunciation,
                haystack: haystack,
                normalizedQuery: normalizedQuery,
                priority: searchPriority(for: family, primaryPhrase: primaryPhrase),
                priorityMatchesQuery: SearchTextMatcher.matchesAllTokens(tokens, in: identityHaystack)
            )

            return PhraseSearchScoredResult(
                result: PhraseSearchResult(
                    pageID: pageID,
                    title: primaryPhrase.targetText,
                    subtitle: primaryPhrase.englishText
                ),
                score: score
            )
        }
    }

    private static let designedFamilyPageIDs: [String: String] = [
        "polite-hello": PhrasePage.xinChao.id,
        "polite-thank-you": "viet-thank-you",
        "polite-excuse-me": "viet-excuse-sorry",
        "v500-poli-basi-excuse-me": "viet-excuse-sorry",
        "polite-goodbye": "viet-goodbye",
        "social-how-are-you": "viet-how-are-you",
    ]

    private static func searchPriority(
        for family: GeneratedVietFamily,
        primaryPhrase: GeneratedVietPhrase
    ) -> SearchPriorityTier {
        if designedFamilyPageIDs[family.id] == PhrasePage.xinChao.id {
            return .anchor
        }

        if family.accessTier == "starter", primaryPhrase.variantRole == "say-first" {
            return .tier1
        }

        if family.accessTier == "starter" {
            return .supporting
        }

        return .deepCatalog
    }

    private static func searchScore(
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

        if pronunciation == normalizedQuery {
            score += 90
        }

        if title.contains(normalizedQuery) {
            score += 70
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

    private static func loadCatalog() -> GeneratedVietCatalog? {
        guard let url = Bundle.main.url(forResource: "viet-phrase-catalog", withExtension: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(GeneratedVietCatalog.self, from: data)
        } catch {
            assertionFailure("Unable to load generated Viet catalog: \(error)")
            return nil
        }
    }

    private static func atGlanceText(
        family: GeneratedVietFamily,
        primaryPhrase: GeneratedVietPhrase,
        isExpandedListing: Bool
    ) -> String {
        if isExpandedListing {
            return family.summary
        }

        if primaryPhrase.context.isEmpty {
            return family.summary
        }

        return "\(family.summary) \(primaryPhrase.context)"
    }

    private static func waysText(for phrases: [PhraseOption]) -> String {
        if phrases.count <= 1 {
            return "Use the phrase above when it matches the moment, then move to nearby phrases if you need to continue."
        }

        return "Start with the first row, then choose a nearby version when the tone, setting, or level of politeness changes."
    }

    private static func detailSections(
        family: GeneratedVietFamily,
        primaryPhrase: GeneratedVietPhrase,
        phraseOptions: [PhraseOption],
        scenario: GeneratedVietScenario?,
        exploreNextOptions: [PhraseOption]
    ) -> [PhraseDetailSection] {
        let isExpandedListing = searchPriority(
            for: family,
            primaryPhrase: primaryPhrase
        ).requiresAuthoredListing
        var sections = [
            PhraseDetailSection(
                id: "at-glance",
                title: "At a glance",
                body: atGlanceText(
                    family: family,
                    primaryPhrase: primaryPhrase,
                    isExpandedListing: isExpandedListing
                )
            ),
            PhraseDetailSection(
                id: "breakdown",
                title: "Break it down",
                body: breakdownLeadInText(primaryPhrase),
                breakdown: breakdownTokens(for: primaryPhrase)
            ),
        ]

        if phraseOptions.count > 1 {
            sections.append(
                PhraseDetailSection(
                    id: "ways-to-say",
                    title: "Ways to say it",
                    body: waysText(for: phraseOptions),
                    phrases: phraseOptions
                )
            )
        }

        if isExpandedListing {
            sections.append(
                PhraseDetailSection(
                    id: "why-it-matters",
                    title: "Why it matters",
                    body: whyItMattersText(family: family, primaryPhrase: primaryPhrase, scenario: scenario)
                )
            )
            sections.append(
                PhraseDetailSection(
                    id: "when-to-use",
                    title: "Use it when",
                    body: useItWhenText(family: family, primaryPhrase: primaryPhrase)
                )
            )

            if !primaryPhrase.youMayHear.isEmpty {
                sections.append(
                    PhraseDetailSection(
                        id: "you-may-hear",
                        title: "You may hear",
                        body: "A local may answer with: \(primaryPhrase.youMayHear)"
                    )
                )
            }

            sections.append(
                PhraseDetailSection(
                    id: "traveler-tip",
                    title: "Traveler tip",
                    body: travelerTipText(family: family, primaryPhrase: primaryPhrase, scenario: scenario)
                )
            )
            sections.append(
                PhraseDetailSection(
                    id: "explore-next",
                    title: "Explore next",
                    body: exploreNextText(scenario),
                    phrases: exploreNextOptions
                )
            )

            return sections
        }

        sections.append(
            PhraseDetailSection(
                id: "when-to-use",
                title: "When to use it",
                body: whenToUseText(primaryPhrase)
            )
        )
        sections.append(
            PhraseDetailSection(
                id: "explore-next",
                title: "Explore next",
                body: exploreNextText(scenario),
                phrases: exploreNextOptions
            )
        )

        return sections
    }

    private static func whyItMattersText(
        family: GeneratedVietFamily,
        primaryPhrase: GeneratedVietPhrase,
        scenario: GeneratedVietScenario?
    ) -> String {
        switch family.scenarioID {
        case "understanding-repair":
            return "This phrase gives you a graceful reset when the conversation is moving too fast. It keeps the moment cooperative before the conversation gets more complicated."
        case "emergency-safety", "health-pharmacy", "problems-help":
            return "This phrase puts the urgent need first, so the other person can react quickly before the conversation gets more complicated."
        case "transport", "directions-navigation":
            return "This phrase turns a vague travel moment into a specific next step. Use it with a map, address, or gesture before the conversation gets more complicated."
        case "airport-border-arrival", "hotel-accommodation":
            return "This phrase helps staff route you to the next counter, room, or service without a long explanation before the conversation gets more complicated."
        case "money-numbers-prices", "shopping", "food-drink":
            return "This phrase makes the transaction clear early, before price, quantity, or preference details make the conversation more complicated."
        default:
            let scenarioName = scenario?.title.lowercased() ?? "travel"
            return "This is a practical \(scenarioName) phrase because it says the need plainly before the conversation gets more complicated."
        }
    }

    private static func useItWhenText(
        family: GeneratedVietFamily,
        primaryPhrase: GeneratedVietPhrase
    ) -> String {
        if !primaryPhrase.context.isEmpty {
            return primaryPhrase.context
        }

        return family.summary
    }

    private static func travelerTipText(
        family: GeneratedVietFamily,
        primaryPhrase: GeneratedVietPhrase,
        scenario: GeneratedVietScenario?
    ) -> String {
        if let warningText = warningText(for: primaryPhrase.warningNoteType) {
            return warningText
        }

        switch family.scenarioID {
        case "airport-border-arrival":
            return "Keep your passport, boarding pass, or baggage tag visible while you say it. Staff can often answer by pointing."
        case "transport", "directions-navigation":
            return "Show the place on your phone as you speak. The phrase lands faster when the other person can see the destination."
        case "hotel-accommodation":
            return "Say the phrase at the desk first, then show the room number or booking screen if the staff member needs context."
        case "food-drink":
            return "Point to the menu item while you say it, especially when tone marks or dish names are hard to pronounce."
        case "money-numbers-prices", "shopping":
            return "If the answer is a number, ask them to type it or show it on a calculator so you can confirm the price."
        case "understanding-repair":
            return "If repeating does not help, move to writing, pointing, or showing the exact name or number on your phone."
        case "health-pharmacy", "emergency-safety", "problems-help":
            return "Use the simplest version first, then show the affected item, location, or person so help can move faster."
        case "phone-internet-power":
            return "Show the phone screen while you say it. A visible error message can explain the problem faster than extra words."
        case "time-dates-booking":
            return "Confirm the time or date visually after they answer, especially for tickets, bookings, and wait times."
        default:
            let scenarioName = scenario?.title.lowercased() ?? "this situation"
            return "Use the phrase first, then point, show, or gesture to the detail that matters in \(scenarioName)."
        }
    }

    private static func warningText(for warningNoteType: String) -> String? {
        switch warningNoteType {
        case "":
            return nil
        case "safety":
            return "Keep the phrase direct and repeat it if needed. In a safety moment, clarity matters more than sounding polished."
        case "medical":
            return "Use this as the first sentence, then show symptoms, medication, or the affected area so the helper has something concrete."
        default:
            return nil
        }
    }

    private static func breakdownLeadInText(_ phrase: GeneratedVietPhrase) -> String {
        if phrase.targetText.hasSuffix(" ở đâu?") {
            return "This pattern asks where a place or service is. Swap the first part to ask about another airport stop."
        }

        if showingOwnershipBreakdownPieces(targetText: phrase.targetText, englishText: phrase.englishText) != nil {
            return "Use this when you are showing a document or item. The phrase points to it, names it, then marks it as yours."
        }

        if phrase.targetText.hasPrefix("Đây là ") {
            return "Use this when you need to identify what something is. The phrase points to the item first, then names it clearly."
        }

        if phrase.targetText.contains("không") {
            return "This pattern is built as a question. Keep the core phrase together so the meaning stays natural."
        }

        return "Use these cards to see how the phrase is built, then listen to the full version until the pieces feel connected."
    }

    private static func breakdownTokens(for phrase: GeneratedVietPhrase) -> [BreakdownToken] {
        let targetText = phrase.targetText
        let englishText = phrase.englishText

        if targetText.hasSuffix(" ở đâu?") {
            let subject = String(targetText.dropLast(" ở đâu?".count)).trimmed()
            let englishSubject = placeName(fromWhereQuestion: englishText)
            let subjectPieces = subjectBreakdownPieces(
                subject,
                englishSubject: englishSubject.isEmpty ? "place" : englishSubject
            )
            let subjectTokens = subjectPieces.enumerated().map { index, piece in
                let subjectAudioKey = subjectPieces.count == 1
                    ? "breakdown-\(phrase.familyID)-subject"
                    : "breakdown-\(phrase.familyID)-subject-\(index + 1)"

                return BreakdownToken(
                    id: "\(phrase.id)-subject-\(index + 1)",
                    vietnamese: piece.vietnamese,
                    english: piece.english,
                    audioKey: subjectAudioKey
                )
            }

            return subjectTokens + [
                BreakdownToken(
                    id: "\(phrase.id)-where",
                    vietnamese: "ở đâu?",
                    english: "where?",
                    audioKey: "breakdown-where"
                ),
                BreakdownToken(
                    id: "\(phrase.id)-full",
                    vietnamese: targetText,
                    english: englishText,
                    audioKey: phrase.audioKey
                ),
            ]
        }

        let words = targetText.split(separator: " ").map(String.init)
        guard words.count > 1 else {
            return [
                BreakdownToken(
                    id: "\(phrase.id)-full",
                    vietnamese: targetText,
                    english: englishText,
                    audioKey: phrase.audioKey
                ),
            ]
        }

        if let pieces = showingPhraseBreakdownPieces(targetText: targetText, englishText: englishText) {
            return breakdownTokens(from: pieces, phrase: phrase)
        }

        if words.contains(where: isNumberToken) {
            let pieces = words.enumerated().map { index, word in
                GeneratedBreakdownPiece(
                    vietnamese: word,
                    english: breakdownMeaning(
                        for: word,
                        fallback: englishFallbackPiece(from: englishText, at: index)
                    )
                )
            }

            return breakdownTokens(from: pieces, phrase: phrase)
        }

        return breakdownTokens(
            from: semanticBreakdownPieces(targetText: targetText, englishText: englishText),
            phrase: phrase
        )
    }

    private static func breakdownTokens(
        from pieces: [GeneratedBreakdownPiece],
        phrase: GeneratedVietPhrase
    ) -> [BreakdownToken] {
        pieces.enumerated().map { index, piece in
            BreakdownToken(
                id: "\(phrase.id)-piece-\(index + 1)",
                vietnamese: piece.vietnamese,
                english: piece.english,
                audioKey: "breakdown-\(phrase.id)-piece-\(index + 1)"
            )
        } + [
            BreakdownToken(
                id: "\(phrase.id)-full",
                vietnamese: phrase.targetText,
                english: phrase.englishText,
                audioKey: phrase.audioKey
            ),
        ]
    }

    private static func showingPhraseBreakdownPieces(
        targetText: String,
        englishText: String
    ) -> [GeneratedBreakdownPiece]? {
        if let ownershipPieces = showingOwnershipBreakdownPieces(
            targetText: targetText,
            englishText: englishText
        ) {
            return ownershipPieces
        }

        guard targetText.hasPrefix("Đây là ") else {
            return nil
        }

        let itemText = String(targetText.dropFirst("Đây là ".count)).trimmed()
        guard !itemText.isEmpty else {
            return nil
        }

        let itemPieces = semanticBreakdownPieces(
            targetText: itemText,
            englishText: showingItemLabel(from: englishText, ownsItem: false)
        )

        return [
            GeneratedBreakdownPiece(vietnamese: "Đây", english: "here / this"),
            GeneratedBreakdownPiece(vietnamese: "là", english: "is"),
        ] + itemPieces
    }

    private static func showingOwnershipBreakdownPieces(
        targetText: String,
        englishText: String
    ) -> [GeneratedBreakdownPiece]? {
        guard targetText.hasPrefix("Đây là "), targetText.hasSuffix(" của tôi") else {
            return nil
        }

        let itemText = String(
            targetText
                .dropFirst("Đây là ".count)
                .dropLast(" của tôi".count)
        ).trimmed()
        guard !itemText.isEmpty else {
            return nil
        }

        let itemPieces = semanticBreakdownPieces(
            targetText: itemText,
            englishText: showingItemLabel(from: englishText, ownsItem: true)
        )

        return [
            GeneratedBreakdownPiece(vietnamese: "Đây", english: "here / this"),
            GeneratedBreakdownPiece(vietnamese: "là", english: "is"),
        ] + itemPieces + [
            GeneratedBreakdownPiece(vietnamese: "của tôi", english: "my / mine"),
        ]
    }

    private static func showingItemLabel(from englishText: String, ownsItem: Bool) -> String {
        let prefixes = ownsItem
            ? ["Here is my", "This is my", "Here is the", "This is the", "Here is", "This is"]
            : ["Here is", "This is", "It is"]

        for prefix in prefixes {
            if let remainder = englishText.droppingCaseInsensitivePrefix(prefix), !remainder.isEmpty {
                return remainder
                    .trimmingCharacters(in: CharacterSet(charactersIn: " .?!"))
                    .lowercased()
            }
        }

        return englishText.lowercased()
    }

    private static func subjectBreakdownPieces(_ subject: String, englishSubject: String) -> [GeneratedBreakdownPiece] {
        let words = subject.split(separator: " ").map(String.init)

        guard words.count > 1 else {
            return [
                GeneratedBreakdownPiece(
                    vietnamese: subject,
                    english: breakdownMeaning(for: subject, fallback: englishSubject)
                ),
            ]
        }

        if subject == "Lấy hành lý" {
            return [
                GeneratedBreakdownPiece(vietnamese: "Lấy", english: "claim / collect"),
                GeneratedBreakdownPiece(vietnamese: "hành lý", english: "baggage"),
            ]
        }

        return semanticBreakdownPieces(targetText: subject, englishText: englishSubject)
    }

    private static func isNumberToken(_ token: String) -> Bool {
        let normalized = normalizedVietnameseKey(token)

        return normalized.allSatisfy(\.isNumber)
            || ["mot", "hai", "ba", "bon", "nam", "sau", "bay", "tam", "chin", "muoi"].contains(normalized)
    }

    private static func semanticBreakdownPieces(
        targetText: String,
        englishText: String
    ) -> [GeneratedBreakdownPiece] {
        let trimmedTarget = targetText.trimmed()
        var workingTarget = trimmedTarget.trimmingCharacters(in: CharacterSet(charactersIn: " .?!"))
        var suffixPieces: [GeneratedBreakdownPiece] = []

        let suffixes: [(vietnamese: String, english: String)] = [
            ("được không", "is it possible?"),
            ("đúng không", "right?"),
            ("phải không", "is that right?"),
            ("không", "question marker"),
        ]

        for suffix in suffixes {
            let suffixWithSpace = " \(suffix.vietnamese)"
            guard normalizedVietnameseKey(workingTarget).hasSuffix(normalizedVietnameseKey(suffix.vietnamese)) else {
                continue
            }

            if let range = workingTarget.range(of: suffixWithSpace, options: [.caseInsensitive, .backwards]) {
                workingTarget = String(workingTarget[..<range.lowerBound]).trimmed()
                suffixPieces.append(
                    GeneratedBreakdownPiece(
                        vietnamese: suffix.vietnamese + (trimmedTarget.hasSuffix("?") ? "?" : ""),
                        english: suffix.english
                    )
                )
                break
            }
        }

        let corePieces = chunkVietnamesePhrase(workingTarget)
            .enumerated()
            .map { index, chunk in
                GeneratedBreakdownPiece(
                    vietnamese: chunk,
                    english: breakdownMeaning(
                        for: chunk,
                        fallback: englishFallbackChunk(from: englishText, at: index)
                    )
                )
            }

        return corePieces + suffixPieces
    }

    private static func chunkVietnamesePhrase(_ phrase: String) -> [String] {
        var words = phrase
            .split(separator: " ")
            .map(String.init)
        var chunks: [String] = []

        while !words.isEmpty {
            let maxCandidateLength = min(3, words.count)
            var matchedChunk: String?

            for length in stride(from: maxCandidateLength, through: 2, by: -1) {
                let candidate = words.prefix(length).joined(separator: " ")
                if preferredBreakdownChunks.contains(normalizedVietnameseKey(candidate)) {
                    matchedChunk = candidate
                    break
                }
            }

            if let matchedChunk {
                chunks.append(matchedChunk)
                words.removeFirst(matchedChunk.split(separator: " ").count)
            } else {
                chunks.append(words.removeFirst())
            }
        }

        return chunks
    }

    private static let preferredBreakdownChunks: Set<String> = [
        "anh/chi",
        "anh chi",
        "bac si",
        "bac xiu",
        "bao lau",
        "bao nhieu",
        "buu dien",
        "ca phe",
        "ca phe den",
        "ca phe sua",
        "cam on",
        "cho hoi",
        "cho toi",
        "co ban",
        "co the",
        "cua toi",
        "dia chi",
        "dia diem",
        "dia diem cu",
        "dia diem moi",
        "da xay ra",
        "di bo",
        "di thang",
        "dien thoai",
        "de nhan phong",
        "duoc khong",
        "gan nhat",
        "giup toi",
        "hanh ly",
        "ho chieu",
        "khach san",
        "khong duong",
        "khong sao",
        "khong sao dau",
        "khu don",
        "lam on",
        "may lanh",
        "mat khau",
        "mua sim",
        "nha thuoc",
        "nha ve sinh",
        "nhan phong",
        "nhap canh",
        "noi lai",
        "nuoc suoi",
        "o dau",
        "re phai",
        "re trai",
        "say xe",
        "the hanh ly",
        "thi thuc",
        "thuc don",
        "tien mat",
        "tieng anh",
        "thit bo",
        "thit ga",
        "thit lon",
        "toi bi",
        "toi can",
        "toi co",
        "toi co the",
        "toi khong",
        "toi muon",
        "toi tra",
        "tra phong",
        "truong hop",
        "yen tinh",
        "xin chao",
        "xin loi",
        "xin vui long",
    ]

    private static func breakdownMeaning(for vietnamese: String, fallback: String) -> String {
        let normalized = normalizedVietnameseKey(vietnamese)

        let meanings = [
            "anh/chi": "you (polite)",
            "anh chi": "you (polite)",
            "lay": "claim / collect",
            "hanh ly": "baggage",
            "cong": "gate",
            "mua": "buy",
            "mua sim": "buy a SIM",
            "sim": "SIM card",
            "day": "here / this",
            "la": "is",
            "thi thuc": "visa",
            "la thi thuc cua toi": "is my visa",
            "ho chieu": "passport",
            "la ho chieu cua toi": "is my passport",
            "the hanh ly": "baggage tag",
            "la the hanh ly cua toi": "is my baggage tag",
            "cua toi": "my / mine",
            "cua": "of",
            "toi": "I / me",
            "toi bi": "I have / got",
            "toi can": "I need",
            "toi co": "I have",
            "toi co the": "can I",
            "toi khong": "I do not",
            "toi muon": "I want",
            "toi tra": "I pay",
            "ban": "you",
            "co": "have / yes",
            "co the": "can",
            "co ban": "do you sell",
            "khong": "not / no",
            "khong duong": "no sugar",
            "khong sao": "it is okay",
            "khong sao dau": "it is okay",
            "phai": "right / must",
            "dung": "correct",
            "sai": "wrong",
            "o": "at / in",
            "o dau": "where?",
            "den": "to / arrive",
            "di": "go",
            "di bo": "walk",
            "di thang": "go straight",
            "de": "to / for",
            "de nhan phong": "for check-in",
            "ve": "ticket",
            "xe": "vehicle",
            "dia chi": "address",
            "dia diem": "location",
            "dia diem cu": "old location",
            "dia diem moi": "new location",
            "cu": "old",
            "moi": "new",
            "chinh xac": "correct / exact",
            "tien": "money",
            "tien mat": "cash",
            "gia": "price",
            "bao nhieu": "how much",
            "bao lau": "how long",
            "giup": "help",
            "giup toi": "help me",
            "nhung gi": "what",
            "da xay ra": "happened",
            "xay ra": "happen",
            "xin": "please",
            "xin chao": "hello",
            "xin loi": "excuse me / sorry",
            "xin vui long": "please",
            "cho": "for",
            "cho hoi": "excuse me / may I ask",
            "cho toi": "can I have",
            "mot": "one",
            "hai": "two",
            "hay": "or",
            "bac si": "doctor",
            "bac xiu": "bạc xỉu coffee",
            "buu dien": "post office",
            "ca phe": "coffee",
            "ca phe den": "black coffee",
            "ca phe sua": "milk coffee",
            "cam on": "thank you",
            "cua hang": "shop",
            "dien thoai": "phone",
            "duoc khong": "is it possible?",
            "gan nhat": "nearest",
            "khach san": "hotel",
            "khu don": "pickup area",
            "lam on": "please",
            "may lanh": "air conditioning",
            "mat khau": "password",
            "nha thuoc": "pharmacy",
            "nha ve sinh": "bathroom",
            "nhan phong": "check in",
            "nhap canh": "immigration",
            "noi lai": "say again",
            "nuoc suoi": "bottled water",
            "phong": "room",
            "phong yen tinh": "quiet room",
            "re phai": "turn right",
            "re trai": "turn left",
            "say xe": "motion sickness",
            "thuc don": "menu",
            "thit bo": "beef",
            "thit ga": "chicken",
            "thit lon": "pork",
            "tieng anh": "English",
            "tra phong": "check out",
            "truong hop": "case / situation",
            "khan cap": "emergency",
            "yen tinh": "quiet",
        ]

        if normalized.allSatisfy(\.isNumber) {
            return vietnamese
        }

        return meanings[normalized] ?? fallback
    }

    private static func englishFallbackPiece(from englishText: String, at index: Int) -> String {
        let pieces = englishText
            .replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: ".", with: "")
            .split(separator: " ")
            .map { $0.lowercased() }

        guard pieces.indices.contains(index) else {
            return englishText
        }

        return pieces[index]
    }

    private static func englishFallbackChunk(from englishText: String, at index: Int) -> String {
        let pieces = englishText
            .replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: ".", with: "")
            .split(separator: " ")
            .map { $0.lowercased() }

        guard pieces.indices.contains(index) else {
            return englishText.lowercased()
        }

        return pieces[index]
    }

    private static func remainingEnglishLabel(after firstVietnamesePiece: String, in englishText: String) -> String {
        let trimmedEnglish = englishText.trimmed()
        let normalizedFirstPiece = normalizedVietnameseKey(firstVietnamesePiece)

        let removablePrefixesByVietnamese = [
            "day": ["here", "this"],
            "toi": ["i"],
            "ban": ["you"],
            "xin": ["please"],
            "la": ["is", "are"],
        ]

        for prefix in removablePrefixesByVietnamese[normalizedFirstPiece] ?? [] {
            if let remainder = trimmedEnglish.droppingCaseInsensitivePrefix(prefix) {
                return remainder
            }
        }

        if normalizedFirstPiece == "ban" {
            for prefix in ["can you", "could you", "do you", "are you", "will you"] {
                if let remainder = trimmedEnglish.droppingCaseInsensitivePrefix(prefix) {
                    return "\(prefix.split(separator: " ").first ?? "") \(remainder)".trimmed()
                }
            }
        }

        return trimmedEnglish
    }

    private static func normalizedVietnameseKey(_ value: String) -> String {
        value
            .trimmingCharacters(in: CharacterSet(charactersIn: ".,?!"))
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .lowercased()
            .replacingOccurrences(of: "đ", with: "d")
    }

    private static func whenToUseText(_ phrase: GeneratedVietPhrase) -> String {
        var parts = [phrase.context]

        if !phrase.youMayHear.isEmpty {
            parts.append("You may hear: \(phrase.youMayHear)")
        }

        if !phrase.warningNoteType.isEmpty {
            parts.append("Note: \(phrase.warningNoteType)")
        }

        return parts
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    private static func exploreNextText(_ scenario: GeneratedVietScenario?) -> String {
        guard let scenario else {
            return "Keep moving through nearby phrases when the next situation is related."
        }

        return "Stay in \(scenario.title.lowercased()) and move to the phrases a traveler is likely to need next."
    }

    private static func exploreNextOptions(
        for family: GeneratedVietFamily,
        excludingPageID pageID: String,
        catalogIndex: GeneratedVietCatalogIndex
    ) -> [PhraseOption] {
        let scenario = catalogIndex.scenariosByID[family.scenarioID]
        let tintName = AccentTint(rawValue: scenario?.tintName ?? "") ?? .gray
        let symbolName = scenario?.symbolName ?? "text.bubble.fill"

        return (catalogIndex.familiesByScenarioID[family.scenarioID] ?? [])
            .compactMap { relatedFamily -> PhraseOption? in
                guard
                    relatedFamily.id != family.id,
                    let phrase = catalogIndex.phrasesByID[relatedFamily.primaryPhraseID]
                else {
                    return nil
                }

                let relatedPageID = catalogIndex.canonicalPageIDsByFamilyID[relatedFamily.id] ?? relatedFamily.pageID
                guard relatedPageID != pageID else {
                    return nil
                }

                return PhraseOption(
                    id: phrase.id,
                    vietnamese: phrase.targetText,
                    english: phrase.englishText,
                    pronunciation: phrase.pronunciation,
                    symbolName: symbolName,
                    tintName: tintName,
                    detailPageID: relatedPageID,
                    audioKey: phrase.audioKey
                )
            }
            .prefix(8)
            .map { $0 }
    }

    private static func placeName(fromWhereQuestion englishText: String) -> String {
        var value = englishText.trimmed()
        let prefixes = [
            "Where is the ",
            "Where are the ",
            "Where is ",
            "Where are ",
        ]

        for prefix in prefixes where value.hasPrefix(prefix) {
            value.removeFirst(prefix.count)
            break
        }

        return value
            .trimmingCharacters(in: CharacterSet(charactersIn: " ?."))
            .trimmed()
    }

    private static func searchText(family: GeneratedVietFamily, phrases: [GeneratedVietPhrase]) -> String {
        let phraseText = phrases.flatMap { phrase in
            [
                phrase.englishText,
                phrase.targetText,
                phrase.canonicalTargetText,
                phrase.pronunciation,
                phrase.context,
                phrase.youMayHear,
            ] + phrase.searchAliases
        }

        return ([family.familyTitle, family.summary, family.scenarioID] + phraseText)
            .joined(separator: " ")
    }

    private static func searchIdentityText(
        family: GeneratedVietFamily,
        primaryPhrase: GeneratedVietPhrase,
        phrases: [GeneratedVietPhrase]
    ) -> String {
        let phraseText = phrases.flatMap { phrase in
            [
                phrase.englishText,
                phrase.targetText,
                phrase.canonicalTargetText,
                phrase.pronunciation,
            ] + phrase.searchAliases
        }

        return ([
            family.familyTitle,
            primaryPhrase.englishText,
            primaryPhrase.targetText,
            primaryPhrase.canonicalTargetText,
            primaryPhrase.pronunciation,
        ] + phraseText)
            .joined(separator: " ")
    }

    private static func normalize(_ value: String) -> String {
        value
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private extension String {
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func droppingCaseInsensitivePrefix(_ prefix: String) -> String? {
        guard let range = range(of: prefix, options: [.caseInsensitive, .anchored]) else {
            return nil
        }

        return String(self[range.upperBound...]).trimmed()
    }
}
