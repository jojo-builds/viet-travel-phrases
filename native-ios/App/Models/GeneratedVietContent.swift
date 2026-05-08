import Foundation

struct PhraseSearchScoredResult {
    let result: PhraseSearchResult
    let score: Int
}

struct GeneratedVietCatalog {
    let metadata: GeneratedVietCatalogMetadata
    let scenarios: [GeneratedVietScenario]
    let families: [GeneratedVietFamily]
    let phrases: [GeneratedVietPhrase]

    func scenario(withID id: String) -> GeneratedVietScenario? {
        scenarios.first { $0.id == id }
    }

    func family(withPageID pageID: String) -> GeneratedVietFamily? {
        families.first { $0.pageID == pageID }
    }

    func family(withID id: String) -> GeneratedVietFamily? {
        families.first { $0.id == id }
    }

    func phrase(withID id: String) -> GeneratedVietPhrase? {
        phrases.first { $0.id == id }
    }
}

struct GeneratedVietCatalogMetadata {
    let phraseCount: Int
    let basePhraseCount: Int
    let cityPhraseCount: Int
    let familyCount: Int
    let scenarioCount: Int
}

struct GeneratedVietScenario: Equatable {
    let id: String
    let title: String
    let symbolName: String
    let tintName: String
}

struct GeneratedVietFamily: Equatable {
    let id: String
    let pageID: String
    let scenarioID: String
    let familyTitle: String
    let summary: String
    let primaryPhraseID: String
    let accessTier: String
    let phraseIDs: [String]
}

struct GeneratedVietPhrase: Equatable {
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

enum SearchQueryExpander {
    static func expandedQueries(for query: String) -> [String] {
        let normalizedQuery = normalize(query)
        guard !normalizedQuery.isEmpty else {
            return []
        }

        var queries = [query]

        queries.append(contentsOf: spellingAndSpacingVariants(for: normalizedQuery))

        for rule in recoverableObjectRules where rule.matches(normalizedQuery) {
            queries.append(contentsOf: rule.recoveryQueries)
        }

        for rule in intentExpansionRules where rule.matches(normalizedQuery) {
            queries.append(contentsOf: rule.expandedQueries)
        }

        return uniqueQueries(queries)
    }

    private struct RecoverableObjectRule {
        let matchTerms: [String]
        let intentTerms: [String]
        let recoveryQueries: [String]

        func matches(_ normalizedQuery: String) -> Bool {
            guard SearchQueryExpander.matchesAny(intentTerms, in: normalizedQuery) else {
                return false
            }

            return SearchQueryExpander.matchesAny(matchTerms, in: normalizedQuery)
        }
    }

    private struct IntentExpansionRule {
        let matchTerms: [String]
        let expandedQueries: [String]

        func matches(_ normalizedQuery: String) -> Bool {
            SearchQueryExpander.matchesAny(matchTerms, in: normalizedQuery)
        }
    }

    private static func matchesAny(_ terms: [String], in normalizedQuery: String) -> Bool {
        let tokens = Set(normalizedQuery.split(separator: " ").map(String.init))

        return terms.contains { term in
            term.contains(" ") ? normalizedQuery.contains(term) : tokens.contains(term)
        }
    }

    private static func spellingAndSpacingVariants(for normalizedQuery: String) -> [String] {
        var variants: [String] = []

        let replacements: [(String, String)] = [
            ("pass port", "passport"),
            ("resturant", "restaurant"),
            ("restaraunt", "restaurant"),
            ("resteraunt", "restaurant"),
            ("rest room", "restroom"),
            ("ride share", "rideshare"),
            ("pick up", "pickup"),
            ("cant", "cannot"),
            ("can t", "cannot"),
            ("dont", "do not"),
            ("don t", "do not"),
            ("im ", "i am "),
            ("i m ", "i am "),
        ]

        for (misspelling, correction) in replacements where normalizedQuery.contains(misspelling) {
            variants.append(normalizedQuery.replacingOccurrences(of: misspelling, with: correction))
        }

        return variants
    }

    private static let recoveryIntentTerms: [String] = [
        "forgot",
        "forget",
        "forgotten",
        "left",
        "lost",
        "missing",
        "misplaced",
        "stolen",
        "took",
        "gone",
        "quen",
    ]

    private static let recoveryIntentPhrases = [
        "do not have",
        "dont have",
        "don t have",
        "cannot find",
        "can not find",
        "can t find",
        "cant find",
        "where is",
        "left behind",
        "khong co",
    ]

    private static var recoveryIntentTriggers: [String] {
        recoveryIntentTerms + recoveryIntentPhrases
    }

    private static var travelDocumentSupportIntentTriggers: [String] {
        recoveryIntentTriggers + [
            "new",
            "replacement",
            "replace",
            "replacing",
            "renew",
            "renewal",
            "get",
            "obtain",
            "need",
            "help",
        ]
    }

    private static let recoverableObjectRules: [RecoverableObjectRule] = [
        RecoverableObjectRule(
            matchTerms: ["passport", "ho chieu"],
            intentTerms: travelDocumentSupportIntentTriggers,
            recoveryQueries: [
                "lost passport",
                "passport missing",
                "do not have passport",
                "report lost passport",
                "help report a lost passport",
            ]
        ),
        RecoverableObjectRule(
            matchTerms: ["phone", "telephone", "mobile"],
            intentTerms: recoveryIntentTriggers,
            recoveryQueries: [
                "lost phone",
                "phone missing",
                "my phone is missing",
                "someone took my phone",
                "help cancel my card",
            ]
        ),
        RecoverableObjectRule(
            matchTerms: ["wallet", "card", "credit card", "bank card"],
            intentTerms: recoveryIntentTriggers,
            recoveryQueries: [
                "lost wallet",
                "wallet missing",
                "lost credit card",
                "cancel my card",
                "someone took my wallet",
            ]
        ),
        RecoverableObjectRule(
            matchTerms: ["bag", "bags", "baggage", "luggage", "suitcase"],
            intentTerms: recoveryIntentTriggers,
            recoveryQueries: [
                "lost luggage",
                "missing bag",
                "my suitcase is missing",
                "lost baggage",
                "baggage claim",
                "airport help",
            ]
        ),
    ]

    private static let intentExpansionRules: [IntentExpansionRule] = [
        IntentExpansionRule(
            matchTerms: ["bathroom", "toilet", "restroom", "wc", "nha ve sinh", "nhà vệ sinh"],
            expandedQueries: [
                "where is the bathroom",
                "where is the nearest restroom",
                "can I use the bathroom",
                "bathroom",
            ]
        ),
        IntentExpansionRule(
            matchTerms: ["peanut", "peanuts", "allergy", "allergic", "shellfish", "seafood", "pork", "garlic", "msg", "monosodium", "ingredient", "ingredients", "spicy", "no peanuts", "cannot eat", "can t eat", "cant eat"],
            expandedQueries: [
                "does this have peanuts",
                "does it have peanuts",
                "peanut allergy",
                "no peanuts",
                "food allergies",
                "does this contain",
                "ingredient question",
                "restaurant ordering",
            ]
        ),
        IntentExpansionRule(
            matchTerms: ["taxi", "cab", "grab", "ride", "rideshare", "driver", "pickup", "pick up", "car"],
            expandedQueries: [
                "taxi pickup",
                "grab pickup point",
                "where is the pickup point",
                "please call the driver",
                "are you my driver",
                "call a taxi",
                "transport",
                "getting around",
            ]
        ),
        IntentExpansionRule(
            matchTerms: ["reservation", "booking", "booked", "confirmation", "check in", "checkin", "check-in", "hotel"],
            expandedQueries: [
                "I have a reservation",
                "I have a booking",
                "I booked online",
                "hotel check in",
                "booking code",
                "here is my passport for check-in",
                "hotel",
            ]
        ),
        IntentExpansionRule(
            matchTerms: ["understand", "meaning", "mean", "confused", "what does"],
            expandedQueries: [
                "I don't understand",
                "what does that mean",
                "do you speak English",
                "communication repair",
            ]
        ),
        IntentExpansionRule(
            matchTerms: ["slower", "slow"],
            expandedQueries: [
                "speak a little slower",
                "could you speak a little slower please",
            ]
        ),
        IntentExpansionRule(
            matchTerms: ["repeat", "again"],
            expandedQueries: [
                "please say that again",
                "can you repeat the last part",
            ]
        ),
        IntentExpansionRule(
            matchTerms: ["write"],
            expandedQueries: [
                "please write it down",
                "please write the address",
                "please write the price",
            ]
        ),
        IntentExpansionRule(
            matchTerms: ["english"],
            expandedQueries: [
                "do you speak English",
            ]
        ),
        IntentExpansionRule(
            matchTerms: ["doctor", "hospital", "medicine", "pharmacy", "sick", "hurt", "pain", "fever", "emergency", "police", "help"],
            expandedQueries: [
                "please help me",
                "call emergency help",
                "I need a doctor",
                "where is the nearest hospital",
                "nearest hospital",
                "where is the pharmacy",
                "do you have this medicine",
                "emergency",
            ]
        ),
        IntentExpansionRule(
            matchTerms: ["bill", "check", "receipt", "pay", "payment", "card", "cash", "qr", "refund", "money", "atm", "change"],
            expandedQueries: [
                "bill please",
                "can I pay by card",
                "receipt",
                "where is the ATM",
                "cash",
                "money",
                "payment",
            ]
        ),
        IntentExpansionRule(
            matchTerms: ["airport", "flight", "baggage", "luggage", "sim", "data", "wifi", "atm"],
            expandedQueries: [
                "airport arrival",
                "where is baggage claim",
                "where can I buy a SIM card",
                "where is the ATM",
                "where is the pickup area",
                "airport",
            ]
        ),
    ]

    private static func uniqueQueries(_ queries: [String]) -> [String] {
        var seen = Set<String>()

        return queries.compactMap { query in
            let normalized = normalize(query)
            guard !normalized.isEmpty, seen.insert(normalized).inserted else {
                return nil
            }

            return query
        }
    }

    private static func normalize(_ value: String) -> String {
        value
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .lowercased()
            .unicodeScalars
            .map { scalar in
                CharacterSet.alphanumerics.contains(scalar) ? String(scalar) : " "
            }
            .joined()
            .split(separator: " ")
            .joined(separator: " ")
    }
}

enum GeneratedVietContent {
    static let catalog: GeneratedVietCatalog? = nil
    static var tierOnePageIDs: Set<String> { [] }
    static var scenarioCategories: [PhraseCategory] { [] }

    static func searchPriority(forFamilyID familyID: String) -> SearchPriorityTier? {
        nil
    }

    static func canonicalPageID(
        for family: GeneratedVietFamily,
        primaryPhrase: GeneratedVietPhrase?
    ) -> String {
        family.pageID
    }

    static func catalogItems(excludingPageIDs excludedPageIDs: Set<String>) -> [PhraseCatalogItem] {
        []
    }

    static func hasDetailPage(withID id: String) -> Bool {
        false
    }

    static func detailPage(withID id: String) -> PhraseDetailPage? {
        nil
    }

    static func search(_ query: String) -> [PhraseSearchScoredResult] {
        []
    }
}
