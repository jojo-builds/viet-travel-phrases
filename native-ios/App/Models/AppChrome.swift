import Foundation

enum AppRoute: Equatable {
    case phrasePage
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
        case .phrasePage, .detailPage:
            return [.home, .browse, .saved]
        case .search:
            return [.home]
        }
    }

    var searchPresentation: SearchPresentation {
        switch route {
        case .phrasePage, .detailPage:
            return .collapsedIsland
        case .search:
            return .expandedField
        }
    }
}
