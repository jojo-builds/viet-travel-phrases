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
        guard hasRecoveryIntent(in: normalizedQuery) else {
            return uniqueQueries(queries)
        }

        for rule in recoverableObjectRules where rule.matches(normalizedQuery) {
            queries.append(contentsOf: rule.recoveryQueries)
        }

        return uniqueQueries(queries)
    }

    private struct RecoverableObjectRule {
        let matchTerms: [String]
        let recoveryQueries: [String]

        func matches(_ normalizedQuery: String) -> Bool {
            let tokens = Set(normalizedQuery.split(separator: " ").map(String.init))

            return matchTerms.contains { term in
                term.contains(" ") ? normalizedQuery.contains(term) : tokens.contains(term)
            }
        }
    }

    private static let recoverableObjectRules: [RecoverableObjectRule] = [
        RecoverableObjectRule(
            matchTerms: ["passport", "ho chieu"],
            recoveryQueries: [
                "lost passport",
                "passport missing",
                "do not have passport",
                "report lost passport",
            ]
        ),
        RecoverableObjectRule(
            matchTerms: ["phone", "telephone", "mobile"],
            recoveryQueries: [
                "lost phone",
                "phone missing",
                "my phone is missing",
                "someone took my phone",
            ]
        ),
        RecoverableObjectRule(
            matchTerms: ["wallet"],
            recoveryQueries: [
                "lost wallet",
                "wallet missing",
                "my wallet is missing",
                "someone took my wallet",
            ]
        ),
        RecoverableObjectRule(
            matchTerms: ["bag", "bags", "baggage", "luggage", "suitcase"],
            recoveryQueries: [
                "lost luggage",
                "missing bag",
                "my suitcase is missing",
                "lost baggage",
            ]
        ),
    ]

    private static let recoveryIntentTerms: Set<String> = [
        "forgot",
        "forget",
        "forgotten",
        "left",
        "lost",
        "missing",
        "misplaced",
        "quen",
    ]

    private static let recoveryIntentPhrases = [
        "do not have",
        "dont have",
        "don t have",
        "cannot find",
        "can not find",
        "can t find",
        "left behind",
        "khong co",
    ]

    private static func hasRecoveryIntent(in normalizedQuery: String) -> Bool {
        let tokens = Set(normalizedQuery.split(separator: " ").map(String.init))

        if !tokens.isDisjoint(with: recoveryIntentTerms) {
            return true
        }

        return recoveryIntentPhrases.contains { normalizedQuery.contains($0) }
    }

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
