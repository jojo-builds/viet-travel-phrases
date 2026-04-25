import SwiftUI

struct AppShellView: View {
    @State private var contentRoute: AppRoute
    @State private var isSearchPresented: Bool

    init(initialRoute: AppRoute = AppShellView.initialRoute) {
        _contentRoute = State(initialValue: initialRoute == .search ? .phrasePage : initialRoute)
        _isSearchPresented = State(initialValue: initialRoute == .search)
    }

    var body: some View {
        ZStack {
            PhraseListingView(
                page: .xinChao,
                onBackTapped: {},
                onSearchTapped: openSearch,
                onDetailTapped: openDetail
            )
            .allowsHitTesting(activeDetailPage == nil && !isSearchPresented)

            if let activeDetailPage {
                PhraseDetailView(
                    page: activeDetailPage,
                    onBackTapped: { contentRoute = .phrasePage },
                    onSearchTapped: openSearch
                )
                .transition(.opacity)
            }

            if isSearchPresented {
                SearchPageView(onClose: { isSearchPresented = false })
                    .transition(.opacity)
            }
        }
        .animation(.snappy(duration: 0.32), value: contentRoute)
        .animation(.snappy(duration: 0.32), value: isSearchPresented)
        .preferredColorScheme(.light)
    }

    private var activeDetailPage: PhraseDetailPage? {
        guard case .detailPage(let detailPageID) = contentRoute else {
            return nil
        }

        return PhraseDetailPage.page(withID: detailPageID)
    }

    private func openDetail(_ id: String) {
        contentRoute = .detailPage(id)
    }

    private func openSearch() {
        isSearchPresented = true
    }

    private static var initialRoute: AppRoute {
        let arguments = ProcessInfo.processInfo.arguments
        guard
            let flagIndex = arguments.firstIndex(of: "--detail-page"),
            arguments.indices.contains(arguments.index(after: flagIndex))
        else {
            return .phrasePage
        }

        return .detailPage(arguments[arguments.index(after: flagIndex)])
    }
}
