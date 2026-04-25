import SwiftUI

struct AppShellView: View {
    @State private var detailPath: [String]
    @State private var isSearchPresented: Bool

    init(initialRoute: AppRoute = AppShellView.initialRoute) {
        if case .detailPage(let detailPageID) = initialRoute {
            _detailPath = State(initialValue: [detailPageID])
        } else {
            _detailPath = State(initialValue: [])
        }

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
            .allowsHitTesting(detailPath.isEmpty && !isSearchPresented)

            if let activeDetailPage {
                PhraseDetailView(
                    page: activeDetailPage,
                    onBackTapped: goBack,
                    onSearchTapped: openSearch,
                    onDetailTapped: openDetail
                )
                .transition(.opacity)
            }

            if isSearchPresented {
                SearchPageView(
                    onClose: { isSearchPresented = false },
                    onOpenDetail: openDetailFromSearch
                )
                    .transition(.opacity)
            }
        }
        .animation(.snappy(duration: 0.32), value: detailPath)
        .animation(.snappy(duration: 0.32), value: isSearchPresented)
        .preferredColorScheme(.light)
    }

    private var activeDetailPage: PhraseDetailPage? {
        guard let detailPageID = detailPath.last else {
            return nil
        }

        return PhraseDetailPage.page(withID: detailPageID)
    }

    private func openDetail(_ id: String) {
        guard PhraseDetailPage.page(withID: id) != nil else {
            return
        }

        guard detailPath.last != id else {
            return
        }

        detailPath.append(id)
    }

    private func openDetailFromSearch(_ id: String) {
        isSearchPresented = false
        openDetail(id)
    }

    private func goBack() {
        guard !detailPath.isEmpty else {
            return
        }

        detailPath.removeLast()
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
