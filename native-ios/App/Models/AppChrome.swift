import Combine
import Foundation

enum AppRoute: Equatable {
    case home
    case phrasePage
    case saved
    case detailPage(String)
    case search
}

enum DockItemKind: Equatable, Hashable {
    case home
    case browse
    case saved

    var symbolName: String {
        switch self {
        case .home:
            return "house.fill"
        case .browse:
            return "square.grid.2x2"
        case .saved:
            return "heart"
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
        case .home, .phrasePage, .saved, .detailPage:
            return [.home, .browse, .saved]
        case .search:
            return [.home]
        }
    }

    var selectedDockItem: DockItemKind {
        switch route {
        case .home, .search:
            return .home
        case .phrasePage, .detailPage:
            return .browse
        case .saved:
            return .saved
        }
    }

    var searchPresentation: SearchPresentation {
        switch route {
        case .home, .phrasePage, .saved, .detailPage:
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

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        recentPages = Self.load([RecentPhrasePage].self, key: Key.recentPages, defaults: defaults) ?? []
        savedPageIDs = Self.load([String].self, key: Key.savedPageIDs, defaults: defaults) ?? []
        practicePageIDs = Self.load([String].self, key: Key.practicePageIDs, defaults: defaults) ?? []
    }

    var recentPageIDs: [String] {
        recentPages.map(\.pageID)
    }

    var hasReturningUserState: Bool {
        !recentPages.isEmpty || !savedPageIDs.isEmpty || !practicePageIDs.isEmpty
    }

    func recordOpenedPage(_ pageID: String, source: UserIntentSource) {
        guard PhraseCatalog.isOpenablePageID(pageID) else {
            return
        }

        var pages = recentPages.filter { $0.pageID != pageID }
        pages.insert(
            RecentPhrasePage(pageID: pageID, openedAt: Date(), source: source),
            at: 0
        )
        recentPages = Array(pages.prefix(Self.maxRecentPages))
        persist(recentPages, key: Key.recentPages)
    }

    func isPageSaved(_ pageID: String) -> Bool {
        savedPageIDs.contains(pageID)
    }

    func isPageInPractice(_ pageID: String) -> Bool {
        practicePageIDs.contains(pageID)
    }

    func toggleSavedPage(_ pageID: String) {
        savedPageIDs = toggledCanonicalIDs(savedPageIDs, pageID: pageID)
        persist(savedPageIDs, key: Key.savedPageIDs)
    }

    func togglePracticePage(_ pageID: String) {
        practicePageIDs = toggledCanonicalIDs(practicePageIDs, pageID: pageID)
        persist(practicePageIDs, key: Key.practicePageIDs)
    }

    private func toggledCanonicalIDs(_ ids: [String], pageID: String) -> [String] {
        guard PhraseCatalog.isOpenablePageID(pageID) else {
            return ids
        }

        if ids.contains(pageID) {
            return ids.filter { $0 != pageID }
        }

        return [pageID] + ids
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

    private static let maxRecentPages = 12
}
