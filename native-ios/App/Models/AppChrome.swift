import Combine
import Foundation

enum AppRoute: Equatable {
    case home
    case browse
    case browseCollection(BrowseCollectionRoute)
    case phrasePage
    case saved
    case practice
    case detailPage(String)
    case search
}

enum DockItemKind: Equatable, Hashable {
    case home
    case browse
    case saved
    case practice

    var symbolName: String {
        switch self {
        case .home:
            return "house.fill"
        case .browse:
            return "square.grid.2x2"
        case .saved:
            return "heart"
        case .practice:
            return "square.grid.2x2.fill"
        }
    }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .browse:
            return "Browse"
        case .saved:
            return "Saved"
        case .practice:
            return "Practice"
        }
    }
}

enum AppSystemTab: Hashable {
    case home
    case browse
    case saved
    case practice
    case search

    init(route: AppRoute) {
        switch route {
        case .home:
            self = .home
        case .browse, .browseCollection, .phrasePage, .detailPage:
            self = .browse
        case .saved:
            self = .saved
        case .practice:
            self = .practice
        case .search:
            self = .search
        }
    }
}

// MARK: - Local User Intent State

enum UserIntentSource: String, Codable, Equatable {
    case home
    case search
    case article
    case browse
    case practice
    case launch
}

struct RecentPhrasePage: Codable, Equatable, Identifiable {
    let pageID: String
    let openedAt: Date
    let source: UserIntentSource

    var id: String { pageID }
}

final class LocalUserIntentStore: ObservableObject {
    @Published private(set) var recentPages: [RecentPhrasePage]
    @Published private(set) var savedPageIDs: [String]
    @Published private(set) var practicePageIDs: [String]

    private let defaults: UserDefaults
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private enum Key {
        static let recentPages = "SpeakLocal.LocalIntent.recentPages.v1"
        static let savedPageIDs = "SpeakLocal.LocalIntent.savedPageIDs.v1"
        static let practicePageIDs = "SpeakLocal.LocalIntent.practicePageIDs.v1"
    }

    init(defaults: UserDefaults = .standard, launchArguments: [String] = ProcessInfo.processInfo.arguments) {
        self.defaults = defaults

#if DEBUG
        if launchArguments.contains("--reset-demo-state") {
            defaults.removeObject(forKey: Key.recentPages)
            defaults.removeObject(forKey: Key.savedPageIDs)
            defaults.removeObject(forKey: Key.practicePageIDs)
        }
#endif

        let loadedRecentPages = Self.load([RecentPhrasePage].self, key: Key.recentPages, defaults: defaults) ?? []
        let loadedSavedPageIDs = Self.load([String].self, key: Key.savedPageIDs, defaults: defaults) ?? []
        let loadedPracticePageIDs = Self.load([String].self, key: Key.practicePageIDs, defaults: defaults) ?? []

        recentPages = Self.canonicalizedRecentPages(loadedRecentPages)
        savedPageIDs = Self.canonicalizedPageIDs(loadedSavedPageIDs)
        practicePageIDs = Self.canonicalizedPageIDs(loadedPracticePageIDs)

#if DEBUG
        if launchArguments.contains("--seed-returning-user-shelves") {
            recentPages = Self.returningUserShelfSeedRecentPages
            savedPageIDs = Self.returningUserShelfSeedSavedPageIDs
            practicePageIDs = Self.returningUserShelfSeedPracticePageIDs
            persist(recentPages, key: Key.recentPages)
            persist(savedPageIDs, key: Key.savedPageIDs)
            persist(practicePageIDs, key: Key.practicePageIDs)
        }
#endif

        if recentPages != loadedRecentPages {
            persist(recentPages, key: Key.recentPages)
        }
        if savedPageIDs != loadedSavedPageIDs {
            persist(savedPageIDs, key: Key.savedPageIDs)
        }
        if practicePageIDs != loadedPracticePageIDs {
            persist(practicePageIDs, key: Key.practicePageIDs)
        }
    }

    var recentPageIDs: [String] {
        recentPages.map(\.pageID)
    }

    var hasReturningUserState: Bool {
        !recentPages.isEmpty || !savedPageIDs.isEmpty || !practicePageIDs.isEmpty
    }

    func recordOpenedPage(_ pageID: String, source: UserIntentSource) {
        guard let canonicalPageID = PhraseCatalog.canonicalPageID(forOpenablePageID: pageID) else {
            return
        }

        var pages = recentPages.filter { page in
            Self.canonicalPageID(forOpenablePageID: page.pageID) != canonicalPageID
        }
        pages.insert(
            RecentPhrasePage(pageID: canonicalPageID, openedAt: Date(), source: source),
            at: 0
        )
        recentPages = Array(pages.prefix(Self.maxRecentPages))
        persist(recentPages, key: Key.recentPages)
    }

    func isPageSaved(_ pageID: String) -> Bool {
        containsCanonicalID(savedPageIDs, pageID: pageID)
    }

    func isPageInPractice(_ pageID: String) -> Bool {
        containsCanonicalID(practicePageIDs, pageID: pageID)
    }

    func toggleSavedPage(_ pageID: String) {
        savedPageIDs = toggledCanonicalIDs(savedPageIDs, pageID: pageID)
        persist(savedPageIDs, key: Key.savedPageIDs)
    }

    func togglePracticePage(_ pageID: String) {
        practicePageIDs = toggledCanonicalIDs(practicePageIDs, pageID: pageID)
        persist(practicePageIDs, key: Key.practicePageIDs)
    }

    func addPracticePages(_ pageIDs: [String]) {
        var seen = Set<String>()
        let existing = Self.canonicalizedPageIDs(practicePageIDs)
        let added = pageIDs.compactMap { pageID in
            Self.canonicalPageID(forOpenablePageID: pageID)
        }
        let merged = (added + existing).filter { pageID in
            seen.insert(pageID).inserted
        }

        practicePageIDs = merged
        persist(practicePageIDs, key: Key.practicePageIDs)
    }

    private func toggledCanonicalIDs(_ ids: [String], pageID: String) -> [String] {
        guard let canonicalPageID = Self.canonicalPageID(forOpenablePageID: pageID) else {
            return ids
        }

        let filteredIDs = ids.filter { id in
            Self.canonicalPageID(forOpenablePageID: id) != canonicalPageID
        }

        if filteredIDs.count != ids.count {
            return filteredIDs
        }

        return [canonicalPageID] + Self.canonicalizedPageIDs(ids)
    }

    private func persist<T: Encodable>(_ value: T, key: String) {
        guard let data = try? encoder.encode(value) else {
            return
        }

        defaults.set(data, forKey: key)
    }

    private static func load<T: Decodable>(_ type: T.Type, key: String, defaults: UserDefaults) -> T? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }

        return try? JSONDecoder().decode(type, from: data)
    }

    private func containsCanonicalID(_ ids: [String], pageID: String) -> Bool {
        guard let canonicalPageID = Self.canonicalPageID(forOpenablePageID: pageID) else {
            return false
        }

        return ids.contains { id in
            Self.canonicalPageID(forOpenablePageID: id) == canonicalPageID
        }
    }

    private static func canonicalizedRecentPages(_ pages: [RecentPhrasePage]) -> [RecentPhrasePage] {
        var seenPageIDs = Set<String>()
        var canonicalPages: [RecentPhrasePage] = []

        for page in pages {
            guard let canonicalPageID = canonicalPageID(forOpenablePageID: page.pageID) else {
                continue
            }
            guard seenPageIDs.insert(canonicalPageID).inserted else {
                continue
            }

            canonicalPages.append(
                RecentPhrasePage(
                    pageID: canonicalPageID,
                    openedAt: page.openedAt,
                    source: page.source
                )
            )
        }

        return Array(canonicalPages.prefix(maxRecentPages))
    }

    private static func canonicalizedPageIDs(_ pageIDs: [String]) -> [String] {
        var seenPageIDs = Set<String>()
        var canonicalPageIDs: [String] = []

        for pageID in pageIDs {
            guard let canonicalPageID = canonicalPageID(forOpenablePageID: pageID) else {
                continue
            }
            guard seenPageIDs.insert(canonicalPageID).inserted else {
                continue
            }

            canonicalPageIDs.append(canonicalPageID)
        }

        return canonicalPageIDs
    }

    private static func canonicalPageID(forOpenablePageID pageID: String) -> String? {
        PhraseCatalog.canonicalPageID(forOpenablePageID: pageID)
    }

    private static let maxRecentPages = 12

#if DEBUG
    private static let returningUserShelfSeedRecentPages: [RecentPhrasePage] = [
        RecentPhrasePage(pageID: "viet-phrase-hello-chao-anh", openedAt: Date(timeIntervalSinceReferenceDate: 800_000_000), source: .home),
        RecentPhrasePage(pageID: "viet-phrase-polite-2", openedAt: Date(timeIntervalSinceReferenceDate: 799_999_000), source: .search),
    ]

    private static let returningUserShelfSeedSavedPageIDs = LocalUserIntentStore.canonicalizedPageIDs([
        "viet-phrase-polite-2",
        "viet-phrase-problems-2",
        "viet-menu-drink-ca-phe-sua-da",
        "viet-menu-drink-ca-phe-den-da",
        "viet-menu-drink-nuoc-mia",
        "viet-menu-drink-tra-da",
    ])

    private static let returningUserShelfSeedPracticePageIDs = LocalUserIntentStore.canonicalizedPageIDs([
        "viet-phrase-problems-2",
        "viet-phrase-polite-2",
        "viet-phrase-hello-chao-anh",
        "viet-phrase-hello-chao-chi",
        "viet-phrase-hello-chao-em",
    ])
#endif
}

// MARK: - Saved Trip

enum SavedTripSectionKind: String, CaseIterable, Equatable, Identifiable {
    case phrases
    case food
    case drinks
    case places
    case cities

    var id: String { rawValue }

    var title: String {
        switch self {
        case .phrases:
            return "Phrases"
        case .food:
            return "Food"
        case .drinks:
            return "Drinks"
        case .places:
            return "Places"
        case .cities:
            return "Cities"
        }
    }

    var singularLabel: String {
        switch self {
        case .phrases:
            return "Phrase"
        case .food:
            return "Food"
        case .drinks:
            return "Drink"
        case .places:
            return "Place"
        case .cities:
            return "City"
        }
    }

    var symbolName: String {
        switch self {
        case .phrases:
            return "text.bubble.fill"
        case .food:
            return "fork.knife"
        case .drinks:
            return "cup.and.saucer.fill"
        case .places:
            return "mappin.and.ellipse"
        case .cities:
            return "building.2.fill"
        }
    }

    var tintName: AccentTint {
        switch self {
        case .phrases:
            return .red
        case .food:
            return .orange
        case .drinks:
            return .teal
        case .places:
            return .green
        case .cities:
            return .blue
        }
    }
}

struct SavedTripItem: Identifiable, Equatable {
    let pageID: String
    let title: String
    let subtitle: String
    let symbolName: String
    let tintName: AccentTint
    let audioKey: String?
    let imageName: String?
    let kind: SavedTripSectionKind

    var id: String { pageID }

    var categoryLabel: String {
        kind.singularLabel
    }
}

struct SavedTripSection: Identifiable, Equatable {
    let kind: SavedTripSectionKind
    let items: [SavedTripItem]

    var id: String { kind.id }
    var title: String { kind.title }
    var symbolName: String { kind.symbolName }
    var tintName: AccentTint { kind.tintName }
    var countLabel: String { "\(items.count) \(items.count == 1 ? "item" : "items")" }
    var featuredImageName: String? { items.first(where: { $0.imageName != nil })?.imageName }
}

struct SavedTripRailItem: Identifiable, Equatable {
    let id: String
    let title: String
    let countLabel: String
    let symbolName: String
    let tintName: AccentTint
    let imageName: String?
}

struct SavedTripSnapshot: Equatable {
    let sections: [SavedTripSection]
    let practiceReadyCount: Int

    var totalItemCount: Int {
        sections.reduce(0) { $0 + $1.items.count }
    }

    var railItems: [SavedTripRailItem] {
        guard totalItemCount > 0 else {
            return []
        }

        return [
            SavedTripRailItem(
                id: "all",
                title: "All",
                countLabel: "\(totalItemCount) \(totalItemCount == 1 ? "item" : "items")",
                symbolName: "heart.fill",
                tintName: .red,
                imageName: sections.lazy.flatMap(\.items).first(where: { $0.imageName != nil })?.imageName
            ),
        ] + sections.map { section in
            SavedTripRailItem(
                id: section.id,
                title: section.title,
                countLabel: section.countLabel,
                symbolName: section.symbolName,
                tintName: section.tintName,
                imageName: section.featuredImageName
            )
        }
    }

    static func make(savedPageIDs: [String], practiceReadyCount: Int = 0) -> SavedTripSnapshot {
        var seenPageIDs = Set<String>()
        let items = savedPageIDs.compactMap { pageID -> SavedTripItem? in
            guard let item = SavedTripResolver.item(for: pageID) else {
                return nil
            }
            guard seenPageIDs.insert(item.pageID).inserted else {
                return nil
            }

            return item
        }

        let sections = SavedTripSectionKind.allCases.compactMap { kind -> SavedTripSection? in
            let sectionItems = items.filter { $0.kind == kind }
            guard !sectionItems.isEmpty else {
                return nil
            }

            return SavedTripSection(kind: kind, items: sectionItems)
        }

        return SavedTripSnapshot(
            sections: sections,
            practiceReadyCount: practiceReadyCount
        )
    }

    static func load(savedPageIDs: [String]) throws -> SavedTripSnapshot {
        let practiceItems = try SavedTripPracticeCatalog.items(for: savedPageIDs)
        return make(savedPageIDs: savedPageIDs, practiceReadyCount: practiceItems.count)
    }
}

struct SavedTripPracticeItem: Identifiable, Equatable {
    let pageID: String
    let vietnamese: String
    let english: String
    let audioKey: String?
    let symbolName: String
    let tintName: AccentTint
    let imageName: String?
    let kind: SavedTripSectionKind

    var id: String { pageID }
}

enum SavedTripPracticeCatalog {
    static func items(for savedPageIDs: [String]) throws -> [SavedTripPracticeItem] {
        var repository: VietSQLiteLanguagePackRepository?
        var seenPageIDs = Set<String>()
        var seenVietnamese = Set<String>()
        var seenEnglish = Set<String>()
        var items: [SavedTripPracticeItem] = []

        func phraseRepository() throws -> VietSQLiteLanguagePackRepository {
            if let repository {
                return repository
            }

            let loadedRepository = try VietSQLiteLanguagePackRepository.bundled()
            repository = loadedRepository
            return loadedRepository
        }

        func append(_ item: SavedTripPracticeItem?) {
            guard let item else {
                return
            }
            guard item.vietnamese.count <= 54, item.english.count <= 70 else {
                return
            }
            guard item.vietnamese.split(separator: " ").count <= 9,
                  item.english.split(separator: " ").count <= 11
            else {
                return
            }
            guard seenPageIDs.insert(item.pageID).inserted,
                  seenVietnamese.insert(item.vietnamese.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)).inserted,
                  seenEnglish.insert(item.english.lowercased()).inserted
            else {
                return
            }

            items.append(item)
        }

        for pageID in savedPageIDs {
            if let menuItem = SavedTripResolver.menuPracticeItem(for: pageID) {
                append(menuItem)
                continue
            }

            let candidates = try phraseRepository().loadPracticeCandidates(pageIDs: [pageID], limit: 4)
            append(candidates.compactMap(SavedTripResolver.practiceItem(for:)).first)
        }

        return items
    }
}

private enum SavedTripResolver {
    static func item(for pageID: String) -> SavedTripItem? {
        if let menuItem = VietnameseMenuCatalog.detailItem(withPageID: pageID),
           let kind = savedKind(for: menuItem.kind) {
            return SavedTripItem(
                pageID: menuItem.detailPageID,
                title: menuItem.vietnameseItem,
                subtitle: menuItem.englishTranslation,
                symbolName: kind.symbolName,
                tintName: menuItem.kind?.tintName ?? kind.tintName,
                audioKey: AudioAssetManifest.main?.audioKey(forExactText: menuItem.vietnameseItem),
                imageName: menuItem.menuImageName,
                kind: kind
            )
        }

        guard let item = BrowseSearchPhraseItem.resolve(pageID: pageID) else {
            return nil
        }

        return SavedTripItem(
            pageID: item.pageID,
            title: item.title,
            subtitle: item.subtitle,
            symbolName: item.symbolName,
            tintName: item.tintName,
            audioKey: item.audioKey,
            imageName: item.imageName,
            kind: .phrases
        )
    }

    static func menuPracticeItem(for pageID: String) -> SavedTripPracticeItem? {
        guard let menuItem = VietnameseMenuCatalog.detailItem(withPageID: pageID),
              let kind = savedKind(for: menuItem.kind)
        else {
            return nil
        }

        return SavedTripPracticeItem(
            pageID: menuItem.detailPageID,
            vietnamese: menuItem.vietnameseItem.trimmingCharacters(in: .whitespacesAndNewlines),
            english: menuItem.englishTranslation.trimmingCharacters(in: .whitespacesAndNewlines),
            audioKey: AudioAssetManifest.main?.audioKey(forExactText: menuItem.vietnameseItem),
            symbolName: kind.symbolName,
            tintName: menuItem.kind?.tintName ?? kind.tintName,
            imageName: menuItem.menuImageName,
            kind: kind
        )
    }

    static func practiceItem(for candidate: PracticeCandidate) -> SavedTripPracticeItem? {
        let vietnamese = candidate.vietnamese.trimmingCharacters(in: .whitespacesAndNewlines)
        let english = candidate.english.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !vietnamese.isEmpty, !english.isEmpty else {
            return nil
        }

        return SavedTripPracticeItem(
            pageID: candidate.pageID,
            vietnamese: vietnamese,
            english: english,
            audioKey: candidate.playableAudioKey,
            symbolName: candidate.symbolName,
            tintName: candidate.tintName,
            imageName: nil,
            kind: .phrases
        )
    }

    private static func savedKind(for menuKind: VietnameseMenuKind?) -> SavedTripSectionKind? {
        switch menuKind {
        case .food:
            return .food
        case .drink:
            return .drinks
        case nil:
            return nil
        }
    }
}
