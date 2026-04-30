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
