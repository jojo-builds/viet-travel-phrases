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
        XCTAssertEqual(chrome.selectedDockItem, .browse)
        XCTAssertEqual(chrome.searchPresentation, .collapsedIsland)
    }

    func testHomeChromeUsesHomeSelectedDockWithSearchIsland() {
        let chrome = AppChrome(route: .home)

        XCTAssertEqual(chrome.primaryDockItems, [.home, .browse, .saved])
        XCTAssertEqual(chrome.selectedDockItem, .home)
        XCTAssertEqual(chrome.searchPresentation, .collapsedIsland)
    }

    func testSavedChromeUsesSavedSelectedDockWithSearchIsland() {
        let chrome = AppChrome(route: .saved)

        XCTAssertEqual(chrome.primaryDockItems, [.home, .browse, .saved])
        XCTAssertEqual(chrome.selectedDockItem, .saved)
        XCTAssertEqual(chrome.searchPresentation, .collapsedIsland)
    }

    func testSearchPageChromeExpandsSearchAndShrinksDock() {
        let chrome = AppChrome(route: .search)

        XCTAssertEqual(chrome.primaryDockItems, [.home])
        XCTAssertEqual(chrome.selectedDockItem, .home)
        XCTAssertEqual(chrome.searchPresentation, .expandedField)
    }

    func testSearchLaunchArgumentOpensSearchPage() {
        XCTAssertEqual(
            AppShellView.initialRoute(for: ["SpeakLocalNative", "--search"]),
            .search
        )
    }

    func testDefaultLaunchStartsAtHome() {
        XCTAssertEqual(
            AppShellView.initialRoute(for: ["SpeakLocalNative"]),
            .home
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
            .home
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
        XCTAssertEqual(chrome.selectedDockItem, .browse)
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

    func testOpeningRootFromCatalogUsesSQLiteCanonicalDetailRoute() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-hello-anh"))

        navigation.openDetail(PhrasePage.xinChao.id)

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-polite-1"))
        XCTAssertEqual(navigation.detailPath, ["viet-hello-anh", "viet-phrase-polite-1"])
        XCTAssertEqual(navigation.rootScrollToTopTrigger, 0)
        XCTAssertEqual(navigation.detailScrollToTopTrigger, 1)
    }

    func testHomeOpensDetailAndBackReturnsHome() {
        var navigation = AppShellNavigationState()

        navigation.openDetail("viet-hello-anh")

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-hello-anh"))
        XCTAssertEqual(navigation.detailPath, ["viet-hello-anh"])

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .home)
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-hello-anh")])
    }

    func testOpeningPhraseRootFromHomeCanReturnHomeFromSQLiteCanonicalDetail() {
        var navigation = AppShellNavigationState()

        navigation.openDetail(PhrasePage.xinChao.id)

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-polite-1"))
        XCTAssertEqual(navigation.detailPath, ["viet-phrase-polite-1"])

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .home)
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-phrase-polite-1")])
    }

    func testOpeningSavedRouteCanReturnHome() {
        var navigation = AppShellNavigationState()

        navigation.openSaved()

        XCTAssertEqual(navigation.currentRoute, .saved)
        XCTAssertTrue(navigation.detailPath.isEmpty)
        XCTAssertEqual(navigation.savedScrollToTopTrigger, 1)

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .home)
        XCTAssertEqual(navigation.forwardStack, [.saved])
    }

    func testOpeningHomeFromSearchClearsHistoryToHome() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-hello-anh"))
        navigation.openSearch()

        navigation.openHome()

        XCTAssertEqual(navigation.currentRoute, .home)
        XCTAssertTrue(navigation.detailPath.isEmpty)
        XCTAssertFalse(navigation.isSearchPresented)
        XCTAssertTrue(navigation.forwardStack.isEmpty)
        XCTAssertEqual(navigation.homeScrollToTopTrigger, 1)
    }

    func testRepeatedDetailSearchHomeSearchFlowDoesNotTrapBackNavigation() {
        var navigation = AppShellNavigationState()

        navigation.openDetail("viet-hello-anh")
        navigation.openSearch()
        XCTAssertEqual(navigation.currentRoute, .search)
        XCTAssertEqual(navigation.backPreviewRoute, .detailPage("viet-phrase-hello-chao-anh"))

        navigation.openHome()
        XCTAssertEqual(navigation.currentRoute, .home)
        XCTAssertTrue(navigation.detailPath.isEmpty)
        XCTAssertTrue(navigation.forwardStack.isEmpty)

        navigation.openSearch()
        XCTAssertEqual(navigation.currentRoute, .search)
        XCTAssertEqual(navigation.backPreviewRoute, .home)

        navigation.goBack()
        XCTAssertEqual(navigation.currentRoute, .home)
        XCTAssertTrue(navigation.detailPath.isEmpty)
        XCTAssertEqual(navigation.forwardStack, [.search])
    }

    func testBackPreviewRouteUsesActualBackDestination() {
        var navigation = AppShellNavigationState()

        XCTAssertNil(navigation.backPreviewRoute)

        navigation.openSaved()
        XCTAssertEqual(navigation.backPreviewRoute, .home)

        navigation.openDetail("viet-hello-anh")
        XCTAssertEqual(navigation.backPreviewRoute, .saved)

        navigation.openDetail("viet-hello-chi")
        XCTAssertEqual(navigation.backPreviewRoute, .detailPage("viet-hello-anh"))
    }

    func testSearchBackPreviewUsesRouteBelowSearch() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-hello-anh"))
        navigation.openSearch()

        XCTAssertEqual(navigation.backPreviewRoute, .detailPage("viet-hello-anh"))

        var homeSearchNavigation = AppShellNavigationState()
        homeSearchNavigation.openSearch()

        XCTAssertEqual(homeSearchNavigation.backPreviewRoute, .home)
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

        XCTAssertEqual(navigation.currentRoute, .home)
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
        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-repair-3"))
        XCTAssertEqual(navigation.detailPath, ["viet-phrase-repair-3"])
        XCTAssertTrue(navigation.forwardStack.isEmpty)
        XCTAssertEqual(navigation.detailScrollToTopTrigger, 1)

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .home)
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-phrase-repair-3")])

        navigation.goForward()

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-repair-3"))
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

// MARK: - Local User Intent Store Tests

final class LocalUserIntentStoreTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        suiteName = "LocalUserIntentStoreTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        suiteName = nil
        super.tearDown()
    }

    func testFreshStoreHasNoReturningUserShelves() {
        let store = LocalUserIntentStore(defaults: defaults)

        XCTAssertTrue(store.recentPageIDs.isEmpty)
        XCTAssertTrue(store.savedPageIDs.isEmpty)
        XCTAssertTrue(store.practicePageIDs.isEmpty)
        XCTAssertFalse(store.hasReturningUserState)
    }

    func testRecentPagesUseCanonicalIDsAndMoveReopenedPageToFront() {
        let store = LocalUserIntentStore(defaults: defaults)

        store.recordOpenedPage("viet-hello-anh", source: .home)
        store.recordOpenedPage("viet-thank-you", source: .search)
        store.recordOpenedPage("viet-hello-anh", source: .article)
        store.recordOpenedPage("missing-page", source: .article)

        XCTAssertEqual(store.recentPageIDs, ["viet-hello-anh", "viet-phrase-polite-2"])
        XCTAssertEqual(store.recentPages.first?.source, .article)
    }

    func testSavedAndPracticeIDsPersistPrivatelyInUserDefaults() {
        let store = LocalUserIntentStore(defaults: defaults)

        store.toggleSavedPage("viet-family-repair-understand")
        store.togglePracticePage("viet-family-repair-understand")

        let restoredStore = LocalUserIntentStore(defaults: defaults)

        XCTAssertEqual(restoredStore.savedPageIDs, ["viet-phrase-problems-2"])
        XCTAssertEqual(restoredStore.practicePageIDs, ["viet-phrase-problems-2"])
        XCTAssertTrue(restoredStore.hasReturningUserState)
    }
}
