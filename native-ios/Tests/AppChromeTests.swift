import XCTest
import CoreGraphics
@testable import SpeakLocalNative

final class AppChromeTests: XCTestCase {
    func testBottomChromeLayoutUsesCompactIslandMetrics() {
        XCTAssertLessThan(AppChromeLayout.dockHorizontalPadding, 16)
        XCTAssertLessThan(AppChromeLayout.dockVerticalPadding, 5)
        XCTAssertLessThan(AppChromeLayout.searchIslandSize, 64)
        XCTAssertLessThan(AppChromeLayout.bottomOffset, 14)
    }

    func testExploreCatalogUsesAppStoreStyleThreeRowGroups() {
        XCTAssertEqual(ExploreCatalogLayout.itemsPerGroup, 3)
        XCTAssertGreaterThan(ExploreCatalogLayout.fullGroupHeight, ExploreCatalogLayout.rowHeight * 3)
        XCTAssertLessThan(ExploreCatalogLayout.fullGroupHeight, 280)
        XCTAssertLessThan(
            ExploreCatalogLayout.groupHeight(for: 1),
            ExploreCatalogLayout.fullGroupHeight
        )
    }

    func testDetailRowsAllowReadableSubtitles() {
        XCTAssertGreaterThanOrEqual(DetailPhraseRowLayout.secondaryLineLimit, 2)
    }

    func testCatalogAndSearchRowsAllowReadableSubtitles() {
        XCTAssertGreaterThanOrEqual(ExploreCatalogLayout.rowSubtitleLineLimit, 2)
        XCTAssertGreaterThanOrEqual(ExploreCatalogLayout.rowHeight, 82)
        XCTAssertGreaterThanOrEqual(SearchResultRowLayout.subtitleLineLimit, 2)
    }

    func testPhrasePageChromeUsesSeparateSearchIsland() {
        let chrome = AppChrome(route: .phrasePage)

        XCTAssertEqual(chrome.primaryDockItems, [.home, .browse, .saved])
        XCTAssertEqual(chrome.searchPresentation, .collapsedIsland)
    }

    func testSearchPageChromeExpandsSearchAndShrinksDock() {
        let chrome = AppChrome(route: .search)

        XCTAssertEqual(chrome.primaryDockItems, [.home])
        XCTAssertEqual(chrome.searchPresentation, .expandedField)
    }

    func testSearchLaunchArgumentOpensSearchPage() {
        XCTAssertEqual(
            AppShellView.initialRoute(for: ["SpeakLocalNative", "--search"]),
            .search
        )
    }

    func testDetailLaunchArgumentTakesPriorityOverSearchShortcut() {
        XCTAssertEqual(
            AppShellView.initialRoute(for: ["SpeakLocalNative", "--search", "--detail-page", "viet-hello-anh"]),
            .detailPage("viet-hello-anh")
        )
    }

    func testStaleDetailLaunchArgumentFallsBackToSafeRoute() {
        XCTAssertEqual(
            AppShellView.initialRoute(for: ["SpeakLocalNative", "--detail-page", "missing-page"]),
            .phrasePage
        )
        XCTAssertEqual(
            AppShellView.initialRoute(for: ["SpeakLocalNative", "--search", "--detail-page", "missing-page"]),
            .search
        )
    }

    func testSearchPageResultsStayClearOfPinnedSearchChrome() {
        XCTAssertGreaterThan(
            SearchPageLayout.pinnedChromeZIndex,
            SearchPageLayout.resultsZIndex
        )
        XCTAssertGreaterThanOrEqual(
            SearchPageLayout.resultsBottomClearance,
            AppChromeLayout.searchFieldHeight + AppChromeLayout.searchIslandSize + AppChromeLayout.bottomSpacing
        )
    }

    func testDetailPageChromeMatchesPhrasePageChrome() {
        let chrome = AppChrome(route: .detailPage("viet-local-greetings"))

        XCTAssertEqual(chrome.primaryDockItems, [.home, .browse, .saved])
        XCTAssertEqual(chrome.searchPresentation, .collapsedIsland)
    }

    func testForwardDetailNavigationRequestsTopScroll() {
        var navigation = AppShellNavigationState()

        navigation.openDetail("viet-hello-anh")

        XCTAssertEqual(navigation.detailPath, ["viet-hello-anh"])
        XCTAssertEqual(navigation.detailScrollToTopTrigger, 1)

        navigation.openDetail("viet-hello-chi")

        XCTAssertEqual(navigation.detailPath, ["viet-hello-anh", "viet-hello-chi"])
        XCTAssertEqual(navigation.detailScrollToTopTrigger, 2)
    }

    func testOpeningRootFromCatalogClearsDetailsAndRequestsRootTopScroll() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-hello-anh"))

        navigation.openDetail(PhrasePage.xinChao.id)

        XCTAssertTrue(navigation.detailPath.isEmpty)
        XCTAssertEqual(navigation.rootScrollToTopTrigger, 1)
        XCTAssertEqual(navigation.detailScrollToTopTrigger, 0)
    }

    func testDuplicateCurrentDetailDoesNotRequestTopScroll() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-hello-anh"))

        navigation.openDetail("viet-hello-anh")

        XCTAssertEqual(navigation.detailPath, ["viet-hello-anh"])
        XCTAssertEqual(navigation.detailScrollToTopTrigger, 0)
    }

    func testEdgeSwipeBackPopsOneDetailPage() {
        var navigation = AppShellNavigationState()
        navigation.openDetail("viet-hello-anh")
        navigation.openDetail("viet-hello-chi")

        let handled = navigation.handleBackSwipe(
            startX: 18,
            translation: CGSize(width: 96, height: 8)
        )

        XCTAssertTrue(handled)
        XCTAssertEqual(navigation.detailPath, ["viet-hello-anh"])
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-hello-chi")])
    }

    func testBackSwipeIgnoresNonBackGestures() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-hello-anh"))

        XCTAssertFalse(navigation.handleBackSwipe(startX: 80, translation: CGSize(width: 120, height: 0)))
        XCTAssertFalse(navigation.handleBackSwipe(startX: 18, translation: CGSize(width: -120, height: 0)))
        XCTAssertFalse(navigation.handleBackSwipe(startX: 18, translation: CGSize(width: 120, height: 96)))
        XCTAssertEqual(navigation.detailPath, ["viet-hello-anh"])
    }

    func testBackSwipeClosesSearchBeforePoppingDetailPage() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-hello-anh"))
        navigation.isSearchPresented = true

        let handled = navigation.handleBackSwipe(
            startX: 18,
            translation: CGSize(width: 96, height: 8)
        )

        XCTAssertTrue(handled)
        XCTAssertFalse(navigation.isSearchPresented)
        XCTAssertEqual(navigation.detailPath, ["viet-hello-anh"])
        XCTAssertEqual(navigation.forwardStack, [.search])
    }

    func testEdgeSwipePoliciesStayNearScreenEdges() {
        XCTAssertLessThanOrEqual(AppBackSwipeGesturePolicy.edgeStartWidth, 44)
        XCTAssertLessThanOrEqual(AppForwardSwipeGesturePolicy.edgeStartWidth, 44)
    }

    func testForwardStackRestoresAPoppedDetailPage() {
        var navigation = AppShellNavigationState()
        navigation.openDetail("viet-hello-anh")
        navigation.openDetail("viet-hello-chi")

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-hello-anh"))
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-hello-chi")])

        navigation.goForward()

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-hello-chi"))
        XCTAssertTrue(navigation.forwardStack.isEmpty)
    }

    func testOpeningANewDetailAfterBackClearsForwardStack() {
        var navigation = AppShellNavigationState()
        navigation.openDetail("viet-hello-anh")
        navigation.openDetail("viet-hello-chi")
        navigation.goBack()

        navigation.openDetail("viet-hello-em")

        XCTAssertEqual(navigation.detailPath, ["viet-hello-anh", "viet-hello-em"])
        XCTAssertTrue(navigation.forwardStack.isEmpty)
    }

    func testRenderedDetailPagesKeepOnlyActiveAndImmediateBackPage() {
        var navigation = AppShellNavigationState()
        navigation.openDetail("viet-hello-anh")
        navigation.openDetail("viet-hello-chi")
        navigation.openDetail("viet-hello-em")
        navigation.openDetail("viet-hello-ba")

        XCTAssertEqual(navigation.detailPath, [
            "viet-hello-anh",
            "viet-hello-chi",
            "viet-hello-em",
            "viet-hello-ba",
        ])
        XCTAssertEqual(navigation.renderedDetailPageIDs, [
            "viet-hello-em",
            "viet-hello-ba",
        ])

        navigation.goBack()

        XCTAssertEqual(navigation.renderedDetailPageIDs, [
            "viet-hello-chi",
            "viet-hello-em",
        ])
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-hello-ba")])
    }

    func testRenderedDetailPagesKeepVisitIdentityForRevisitedPhrase() {
        var navigation = AppShellNavigationState()
        navigation.openDetail("viet-hello-anh")
        navigation.openDetail("viet-hello-chi")

        let originalRenderedPages = navigation.renderedDetailPages

        navigation.openDetail("viet-hello-anh")

        XCTAssertEqual(navigation.detailPath, [
            "viet-hello-anh",
            "viet-hello-chi",
            "viet-hello-anh",
        ])
        XCTAssertEqual(navigation.renderedDetailPageIDs, [
            "viet-hello-chi",
            "viet-hello-anh",
        ])
        XCTAssertNotEqual(originalRenderedPages.first?.id, navigation.renderedDetailPages.first?.id)
        XCTAssertEqual(navigation.renderedDetailPages.last?.id, "2-viet-hello-anh")
    }

    func testSearchBackCanBeForwardedLikeBrowserHistory() {
        var navigation = AppShellNavigationState()

        navigation.openSearch()
        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .phrasePage)
        XCTAssertEqual(navigation.forwardStack, [.search])

        navigation.goForward()

        XCTAssertEqual(navigation.currentRoute, .search)
        XCTAssertTrue(navigation.forwardStack.isEmpty)
    }

    func testOpeningDetailFromSearchClosesSearchAndStartsArticleRoute() {
        var navigation = AppShellNavigationState()

        navigation.openSearch()
        navigation.openDetail("viet-family-repair-meaning")

        XCTAssertFalse(navigation.isSearchPresented)
        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-family-repair-meaning"))
        XCTAssertEqual(navigation.detailPath, ["viet-family-repair-meaning"])
        XCTAssertTrue(navigation.forwardStack.isEmpty)
        XCTAssertEqual(navigation.detailScrollToTopTrigger, 1)

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .phrasePage)
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-family-repair-meaning")])

        navigation.goForward()

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-family-repair-meaning"))
        XCTAssertTrue(navigation.forwardStack.isEmpty)
    }

    func testForwardSwipeRestoresForwardRoute() {
        var navigation = AppShellNavigationState()
        navigation.openDetail("viet-hello-anh")
        navigation.goBack()

        let handled = navigation.handleForwardSwipe(
            translation: CGSize(width: -96, height: 4)
        )

        XCTAssertTrue(handled)
        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-hello-anh"))
        XCTAssertTrue(navigation.forwardStack.isEmpty)
    }

    func testForwardSwipeTrackingRequiresTrailingScreenEdge() {
        XCTAssertFalse(
            AppForwardSwipeGesturePolicy.canTrackForwardSwipe(
                startX: 240,
                containerWidth: 400,
                translation: CGSize(width: -96, height: 4)
            )
        )
        XCTAssertTrue(
            AppForwardSwipeGesturePolicy.canTrackForwardSwipe(
                startX: 384,
                containerWidth: 400,
                translation: CGSize(width: -96, height: 4)
            )
        )
    }

    func testInteractiveNavigationProgressIsClampedByDirection() {
        XCTAssertEqual(
            AppInteractiveNavigationGesture.progress(for: 200, direction: .back, width: 400),
            0.5,
            accuracy: 0.001
        )
        XCTAssertEqual(
            AppInteractiveNavigationGesture.progress(for: -100, direction: .forward, width: 400),
            0.25,
            accuracy: 0.001
        )
        XCTAssertEqual(
            AppInteractiveNavigationGesture.progress(for: 600, direction: .back, width: 400),
            1,
            accuracy: 0.001
        )
    }
}
