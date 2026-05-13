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
            return "text.bubble.fill"
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
            return "Messages"
        }
    }
}

enum SearchPresentation: Equatable {
    case collapsedIsland
    case expandedField
}

struct AppChrome: Equatable {
    let route: AppRoute

    var primaryDockItems: [DockItemKind] {
        switch route {
        case .home, .browse, .browseCollection, .phrasePage, .saved, .practice, .detailPage:
            return [.home, .browse, .saved, .practice]
        case .search:
            return [.home]
        }
    }

    var selectedDockItem: DockItemKind {
        switch route {
        case .home, .search:
            return .home
        case .browse, .browseCollection, .phrasePage, .detailPage:
            return .browse
        case .saved:
            return .saved
        case .practice:
            return .practice
        }
    }

    var searchPresentation: SearchPresentation {
        switch route {
        case .home, .browse, .browseCollection, .phrasePage, .saved, .practice, .detailPage:
            return .collapsedIsland
        case .search:
            return .expandedField
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
