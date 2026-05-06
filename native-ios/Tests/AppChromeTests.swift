import XCTest
import CoreGraphics
@testable import SpeakLocalNative

final class AppChromeTests: XCTestCase {
    func testBottomChromeLayoutUsesCompactIslandMetrics() {
        XCTAssertLessThan(AppChromeLayout.dockHorizontalPadding, 16)
        XCTAssertLessThan(AppChromeLayout.dockVerticalPadding, 5)
        XCTAssertLessThanOrEqual(AppChromeLayout.searchIslandSize, 53)
        XCTAssertLessThan(AppChromeLayout.bottomOffset, 14)
        XCTAssertEqual(AppChromeLayout.bottomSeparationHeight, 0)
        XCTAssertLessThanOrEqual(AppChromeLayout.topSeparationHeight, 120)
        XCTAssertLessThan(
            AppChromeLayout.topSeparationHeight,
            AppChromeLayout.pinnedAudioSpeedRevealY + AppChromeLayout.topAdminControlSize
        )
    }

    func testBottomChromeHitTestEnvelopeStaysLocalToChrome() {
        XCTAssertGreaterThanOrEqual(AppChromeLayout.bottomHitTestEnvelopeHeight, AppChromeLayout.searchIslandSize)
        XCTAssertGreaterThanOrEqual(
            AppChromeLayout.bottomHitTestEnvelopeHeight,
            AppChromeLayout.dockItemHeight + AppChromeLayout.dockVerticalPadding * 2
        )
        XCTAssertLessThan(AppChromeLayout.bottomHitTestEnvelopeHeight, 110)
        XCTAssertFalse(AppChromeLayout.chromeSeparationAllowsHitTesting)
    }

    func testSearchMorphUsesMatchedChromeMetrics() {
        XCTAssertEqual(AppChromeLayout.searchFieldHeight, AppChromeLayout.searchIslandSize)
        XCTAssertEqual(
            AppChromeLayout.dockItemHeight + AppChromeLayout.dockVerticalPadding * 2,
            AppChromeLayout.searchIslandSize
        )
        XCTAssertGreaterThanOrEqual(AppChromeLayout.searchMorphDuration, 0.38)
        XCTAssertLessThanOrEqual(AppChromeLayout.searchMorphDuration, 0.40)
    }

    func testSearchOriginAndDockShareMorphLayer() {
        XCTAssertGreaterThan(AppChromeLayout.searchOriginMorphZIndex, AppChromeLayout.searchMorphZIndex)
        XCTAssertGreaterThan(AppChromeLayout.searchMorphZIndex, AppChromeLayout.dockMorphZIndex)
    }

    func testSearchChromeMorphKeepsSearchGlassAboveReturningDock() {
        XCTAssertGreaterThan(AppChromeLayout.searchMorphZIndex, AppChromeLayout.dockMorphZIndex)
        XCTAssertGreaterThan(AppChromeLayout.searchOriginMorphZIndex, AppChromeLayout.searchMorphZIndex)
        XCTAssertGreaterThan(AppChromeLayout.keyboardDismissMorphZIndex, AppChromeLayout.searchOriginMorphZIndex)
        XCTAssertGreaterThan(AppChromeLayout.searchForegroundMorphZIndex, AppChromeLayout.keyboardDismissMorphZIndex)
    }

    func testDockSelectionLensUsesAppStoreStylePillMetrics() {
        XCTAssertGreaterThan(AppChromeLayout.dockSelectionWidth, AppChromeLayout.dockItemWidth)
        XCTAssertLessThanOrEqual(AppChromeLayout.dockSelectionHeight, AppChromeLayout.searchIslandSize)
        XCTAssertEqual(AppChromeLayout.dockSelectionCornerRadius, AppChromeLayout.dockSelectionHeight / 2)
    }

    func testSearchAndSelectedDockIconsUseDistinctForegroundMorphIDs() {
        XCTAssertNotEqual(AppChromeMorphID.searchIcon, AppChromeMorphID.dockItem(.home))
        XCTAssertNotEqual(AppChromeMorphID.searchIcon, AppChromeMorphID.dockItem(.browse))
        XCTAssertNotEqual(AppChromeMorphID.dockSelection, AppChromeMorphID.dock)
        XCTAssertNotEqual(AppChromeMorphID.dockSelection, AppChromeMorphID.search)
    }

    func testPinnedAudioTopAdminClearanceCoversBackdrop() {
        XCTAssertGreaterThanOrEqual(
            AppChromeLayout.pinnedAudioSpeedScrollClearance,
            AppChromeLayout.topAdminHitTestEnvelopeHeight
        )
        XCTAssertGreaterThan(
            AppChromeLayout.pinnedAudioSpeedScrollClearance,
            AppChromeLayout.pinnedAudioSpeedRevealY + AppChromeLayout.searchIslandSize
        )
        XCTAssertLessThanOrEqual(
            AppChromeLayout.pinnedAudioSpeedBackdropHeight,
            AppChromeLayout.topSeparationHeight
        )
    }

    func testTopAdminControlsUseCompactAlignedMetrics() {
        XCTAssertEqual(AppChromeLayout.topAdminControlSize, 47)
        XCTAssertLessThan(AppChromeLayout.topAdminControlSize, AppChromeLayout.searchIslandSize)
        XCTAssertEqual(AppChromeLayout.topAdminControlCornerRadius, AppChromeLayout.topAdminControlSize / 2)
        XCTAssertEqual(AudioSpeedControlMetrics.topAdmin.controlHeight, AppChromeLayout.topAdminControlSize)
        XCTAssertLessThan(AudioSpeedControlMetrics.topAdmin.controlHeight, AudioSpeedControlMetrics.regular.controlHeight)
        XCTAssertGreaterThanOrEqual(
            AppChromeLayout.topAdminHitTestEnvelopeHeight,
            AppChromeLayout.topAdminTopPadding + AppChromeLayout.topAdminControlSize
        )
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

    func testBreakdownCarouselKeepsMultiCardPeekWithoutSingleCardOverflow() {
        XCTAssertGreaterThan(
            BreakdownLayout.trailingPadding(tokenCount: 3),
            BreakdownLayout.trailingPadding(tokenCount: 1)
        )
        XCTAssertEqual(BreakdownLayout.trailingPadding(tokenCount: 1), BreakdownLayout.singleCardTrailingPadding)

        let longLeadingCardWidth = BreakdownLayout.cardWidth(longestTextCount: 80, index: 0, tokenCount: 3)
        let longFinalCardWidth = BreakdownLayout.cardWidth(longestTextCount: 80, index: 2, tokenCount: 3)

        XCTAssertEqual(longLeadingCardWidth, BreakdownLayout.nonFinalMaximumWidth)
        XCTAssertEqual(longFinalCardWidth, BreakdownLayout.finalMaximumWidth)
        XCTAssertLessThan(
            BreakdownLayout.nonFinalMaximumWidth,
            BreakdownLayout.finalMaximumWidth
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

    func testHomeSituationRowsUseStableCardMetrics() {
        XCTAssertEqual(HomeLayout.situationRowHeight, 96)
        XCTAssertEqual(HomeLayout.situationIconSize, 46)
        XCTAssertEqual(HomeLayout.situationImageWidth, 108)
        XCTAssertEqual(HomeLayout.situationImageHeight, 68)
        XCTAssertLessThan(HomeLayout.situationImageHeight, HomeLayout.situationRowHeight)
    }

    func testHomeScenarioCardsKeepStartButtonInsideCardBounds() {
        let verticalPadding = HomeLayout.scenarioCardPadding * 2
        let imageHeight = HomeLayout.scenarioCardImageHeight
        let sectionSpacing = HomeLayout.scenarioCardSpacing * 3
        let worstCaseTitleAndSubtitleHeight: CGFloat = 96
        let startButtonHeight = HomeLayout.scenarioStartButtonHeight
        let minimumHeight = verticalPadding
            + imageHeight
            + sectionSpacing
            + worstCaseTitleAndSubtitleHeight
            + startButtonHeight

        XCTAssertGreaterThanOrEqual(HomeLayout.scenarioCardHeight, minimumHeight)
    }

    func testBrowseNextShelfRowsUseStableFullWidthCardMetrics() {
        XCTAssertEqual(BrowsePageLayout.nextShelfRowHeight, 108)
        XCTAssertEqual(BrowsePageLayout.nextShelfIconSize, 48)
        XCTAssertEqual(BrowsePageLayout.nextShelfRowPadding, 14)
        XCTAssertGreaterThanOrEqual(
            BrowsePageLayout.nextShelfRowHeight,
            BrowsePageLayout.nextShelfIconSize + BrowsePageLayout.nextShelfRowPadding * 2
        )
    }

    func testPhrasePageChromeUsesSeparateSearchIsland() {
        let chrome = AppChrome(route: .phrasePage)

        XCTAssertEqual(chrome.primaryDockItems, [.home, .browse, .saved, .practice])
        XCTAssertEqual(chrome.selectedDockItem, .browse)
        XCTAssertEqual(chrome.searchPresentation, .collapsedIsland)
    }

    func testHomeChromeUsesHomeSelectedDockWithSearchIsland() {
        let chrome = AppChrome(route: .home)

        XCTAssertEqual(chrome.primaryDockItems, [.home, .browse, .saved, .practice])
        XCTAssertEqual(chrome.selectedDockItem, .home)
        XCTAssertEqual(chrome.searchPresentation, .collapsedIsland)
    }

    func testBrowseChromeUsesBrowseSelectedDockWithSearchIsland() {
        let chrome = AppChrome(route: .browse)

        XCTAssertEqual(chrome.primaryDockItems, [.home, .browse, .saved, .practice])
        XCTAssertEqual(chrome.selectedDockItem, .browse)
        XCTAssertEqual(chrome.searchPresentation, .collapsedIsland)
    }

    func testBrowseCollectionChromeUsesBrowseSelectedDockWithSearchIsland() {
        let chrome = AppChrome(route: .browseCollection(.category("hotel")))

        XCTAssertEqual(chrome.primaryDockItems, [.home, .browse, .saved, .practice])
        XCTAssertEqual(chrome.selectedDockItem, .browse)
        XCTAssertEqual(chrome.searchPresentation, .collapsedIsland)
    }

    func testSavedChromeUsesSavedSelectedDockWithSearchIsland() {
        let chrome = AppChrome(route: .saved)

        XCTAssertEqual(chrome.primaryDockItems, [.home, .browse, .saved, .practice])
        XCTAssertEqual(chrome.selectedDockItem, .saved)
        XCTAssertEqual(chrome.searchPresentation, .collapsedIsland)
    }

    func testPracticeChromeUsesPracticeSelectedDockWithSearchIsland() {
        let chrome = AppChrome(route: .practice)

        XCTAssertEqual(chrome.primaryDockItems, [.home, .browse, .saved, .practice])
        XCTAssertEqual(chrome.selectedDockItem, .practice)
        XCTAssertEqual(chrome.searchPresentation, .collapsedIsland)
    }

    func testSearchPageChromeExpandsSearchAndShrinksDock() {
        let chrome = AppChrome(route: .search)

        XCTAssertEqual(chrome.primaryDockItems, [.home])
        XCTAssertEqual(chrome.selectedDockItem, .home)
        XCTAssertEqual(chrome.searchPresentation, .expandedField)
    }

    func testSearchOriginIconTracksRouteBelowSearch() {
        var navigation = AppShellNavigationState()

        navigation.openSearch()
        XCTAssertEqual(navigation.searchOriginDockItem, .home)

        navigation.goBack()
        navigation.openBrowse()
        navigation.openSearch()

        XCTAssertEqual(navigation.searchOriginDockItem, .browse)

        navigation.goBack()
        navigation.openBrowseCollection(.category("hotel"))
        navigation.openSearch()

        XCTAssertEqual(navigation.searchOriginDockItem, .browse)

        navigation.goBack()
        navigation.openSaved()
        navigation.openSearch()

        XCTAssertEqual(navigation.searchOriginDockItem, .saved)

        navigation.goBack()
        navigation.openPractice()
        navigation.openSearch()

        XCTAssertEqual(navigation.searchOriginDockItem, .practice)
    }

    func testDetailSearchOriginUsesBrowseDockItem() {
        var navigation = AppShellNavigationState()

        navigation.openDetail("viet-phrase-hello-chao-anh")
        navigation.openSearch()

        XCTAssertEqual(navigation.searchOriginDockItem, .browse)
    }

    func testPlaybackSpeedPreferenceMapsToGlobalRates() {
        XCTAssertEqual(AudioPlaybackPreference.rate(for: "0.5x"), 0.5, accuracy: 0.001)
        XCTAssertEqual(AudioPlaybackPreference.rate(for: "0.75x"), 0.75, accuracy: 0.001)
        XCTAssertEqual(AudioPlaybackPreference.rate(for: "1.0x"), 1.0, accuracy: 0.001)
        XCTAssertEqual(AudioPlaybackPreference.rate(for: "stale-value"), 1.0, accuracy: 0.001)
        XCTAssertEqual(AudioPlaybackPreference.normalizedSpeed("stale-value"), AudioPlaybackPreference.defaultSpeed)
    }

    func testPinnedAudioSpeedChromeOnlyShowsForActiveOffscreenPlayer() {
        let currentRoute = AppRoute.detailPage("viet-phrase-polite-1")
        let activeVisiblePlayer = PhraseAudioPlayerAnchor(
            route: currentRoute,
            frame: CGRect(x: 40, y: 190, width: 320, height: 108)
        )
        let activeOffscreenPlayer = PhraseAudioPlayerAnchor(
            route: currentRoute,
            frame: CGRect(x: 40, y: -132, width: 320, height: 108)
        )
        let inactiveOffscreenPlayer = PhraseAudioPlayerAnchor(
            route: .detailPage("viet-phrase-hello-chao-anh"),
            frame: CGRect(x: 40, y: -132, width: 320, height: 108)
        )

        XCTAssertFalse(PinnedAudioSpeedChromePolicy.shouldShowPinnedControl(for: activeVisiblePlayer, currentRoute: currentRoute))
        XCTAssertTrue(PinnedAudioSpeedChromePolicy.shouldShowPinnedControl(for: activeOffscreenPlayer, currentRoute: currentRoute))
        XCTAssertFalse(PinnedAudioSpeedChromePolicy.shouldShowPinnedControl(for: inactiveOffscreenPlayer, currentRoute: currentRoute))
        XCTAssertFalse(PinnedAudioSpeedChromePolicy.shouldShowPinnedControl(for: nil, currentRoute: currentRoute))
    }

    func testPinnedAudioSpeedChromeStateIgnoresFrameDriftWithinSameVisibilityBand() {
        let currentRoute = AppRoute.detailPage("viet-phrase-polite-1")
        let justOffscreenPlayer = PhraseAudioPlayerAnchor(
            route: currentRoute,
            frame: CGRect(x: 40, y: -40, width: 320, height: 108)
        )
        let fartherOffscreenPlayer = PhraseAudioPlayerAnchor(
            route: currentRoute,
            frame: CGRect(x: 40, y: -240, width: 320, height: 108)
        )

        XCTAssertEqual(
            PinnedAudioSpeedChromePolicy.state(for: [justOffscreenPlayer], currentRoute: currentRoute),
            PinnedAudioSpeedChromePolicy.state(for: [fartherOffscreenPlayer], currentRoute: currentRoute)
        )
    }

    func testSQLiteCanonicalXinChaoRouteUsesDesignedRootArticle() {
        XCTAssertTrue(AppShellView.shouldRenderDesignedXinChaoPage(for: PhrasePage.xinChao.id))
        XCTAssertTrue(AppShellView.shouldRenderDesignedXinChaoPage(for: "viet-phrase-polite-1"))
        XCTAssertFalse(AppShellView.shouldRenderDesignedXinChaoPage(for: "viet-phrase-hello-chao-anh"))
    }

    func testSearchLaunchArgumentOpensSearchPage() {
        XCTAssertEqual(
            AppShellView.initialRoute(for: ["SpeakLocalNative", "--search"]),
            .search
        )
    }

    func testBrowseLaunchArgumentOpensBrowsePage() {
        XCTAssertEqual(
            AppShellView.initialRoute(for: ["SpeakLocalNative", "--browse"]),
            .browse
        )
    }

    func testBrowseCollectionLaunchArgumentsOpenCollectionPages() {
        XCTAssertEqual(
            AppShellView.initialRoute(for: ["SpeakLocalNative", "--browse-category", "hotel"]),
            .browseCollection(.category("hotel"))
        )
        XCTAssertEqual(
            AppShellView.initialRoute(for: ["SpeakLocalNative", "--browse-city", "hanoi"]),
            .browseCollection(.city("hanoi"))
        )
    }

    func testSearchQueryLaunchArgumentOpensSearchWithoutImplicitFocus() {
        let arguments = ["SpeakLocalNative", "--search-query", "hotel"]

        XCTAssertEqual(AppShellView.initialRoute(for: arguments), .search)
        XCTAssertEqual(AppShellView.initialSearchQuery(for: arguments), "hotel")
        XCTAssertFalse(AppShellView.initialSearchShouldFocus(for: arguments))
        XCTAssertTrue(AppShellView.initialSearchShouldFocus(for: arguments + ["--search-focused"]))
    }

    func testPracticeLaunchArgumentOpensPracticePage() {
        XCTAssertEqual(
            AppShellView.initialRoute(for: ["SpeakLocalNative", "--practice"]),
            .practice
        )
    }

    func testPracticeModeLaunchArgumentOpensRequestedCityPath() {
        let arguments = ["SpeakLocalNative", "--practice-mode", PracticeMode.hueCity.rawValue]

        XCTAssertEqual(AppShellView.initialRoute(for: arguments), .practice)
        XCTAssertEqual(AppShellView.initialPracticeMode(for: arguments), .hueCity)
    }

    func testPracticePlacementLaunchArgumentOpensPlacementContext() {
        let arguments = ["SpeakLocalNative", "--practice-placement"]

        XCTAssertEqual(AppShellView.initialRoute(for: arguments), .practice)
        XCTAssertEqual(AppShellView.initialPracticeEntryContext(for: arguments), .placement)
        XCTAssertNil(AppShellView.initialPracticeMode(for: arguments))
    }

    func testDetailScrollLaunchArgumentParsesArticleTarget() {
        XCTAssertEqual(
            AppShellView.initialDetailScrollTarget(for: ["SpeakLocalNative", "--detail-scroll", "catalog-explore"]),
            .catalogExplore
        )
        XCTAssertEqual(
            AppShellView.initialDetailScrollTarget(for: ["SpeakLocalNative", "--detail-scroll", "first-breakdown"]),
            .firstBreakdown
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
            AppShellView.initialRoute(for: ["SpeakLocalNative", "--search", "--detail-page", "viet-phrase-hello-chao-anh"]),
            .detailPage("viet-phrase-hello-chao-anh")
        )
    }

    func testDetailLaunchArgumentCanonicalizesLegacyAlias() {
        XCTAssertEqual(
            AppShellView.initialRoute(for: ["SpeakLocalNative", "--detail-page", "viet-hello-anh"]),
            .detailPage("viet-phrase-hello-chao-anh")
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

    func testPhraseRowNavigationSuppressesCanonicalSelfLinks() {
        XCTAssertNil(
            PhraseRowNavigation.destinationPageID(
                for: "viet-hello-anh",
                currentPageID: "viet-phrase-hello-chao-anh"
            )
        )
        XCTAssertEqual(
            PhraseRowNavigation.destinationPageID(
                for: "viet-phrase-hello-chao-chi",
                currentPageID: "viet-phrase-hello-chao-anh"
            ),
            "viet-phrase-hello-chao-chi"
        )
    }

    func testDetailPageChromeMatchesPhrasePageChrome() {
        let chrome = AppChrome(route: .detailPage("viet-local-greetings"))

        XCTAssertEqual(chrome.primaryDockItems, [.home, .browse, .saved, .practice])
        XCTAssertEqual(chrome.selectedDockItem, .browse)
        XCTAssertEqual(chrome.searchPresentation, .collapsedIsland)
    }

    func testForwardDetailNavigationRequestsTopScroll() {
        var navigation = AppShellNavigationState()

        navigation.openDetail("viet-phrase-hello-chao-anh")

        XCTAssertEqual(navigation.detailPath, ["viet-phrase-hello-chao-anh"])
        XCTAssertEqual(navigation.detailScrollToTopTrigger, 1)

        navigation.openDetail("viet-phrase-hello-chao-chi")

        XCTAssertEqual(navigation.detailPath, ["viet-phrase-hello-chao-anh", "viet-phrase-hello-chao-chi"])
        XCTAssertEqual(navigation.detailScrollToTopTrigger, 2)
    }

    func testOpeningRootFromCatalogUsesSQLiteCanonicalDetailRoute() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-phrase-hello-chao-anh"))

        navigation.openDetail(PhrasePage.xinChao.id)

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-polite-1"))
        XCTAssertEqual(navigation.detailPath, ["viet-phrase-hello-chao-anh", "viet-phrase-polite-1"])
        XCTAssertEqual(navigation.rootScrollToTopTrigger, 0)
        XCTAssertEqual(navigation.detailScrollToTopTrigger, 1)
    }

    func testHomeOpensDetailAndBackReturnsHome() {
        var navigation = AppShellNavigationState()

        navigation.openDetail("viet-phrase-hello-chao-anh")

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-hello-chao-anh"))
        XCTAssertEqual(navigation.detailPath, ["viet-phrase-hello-chao-anh"])

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .home)
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-phrase-hello-chao-anh")])
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

    func testOpeningBrowseRouteCanReturnHomeAndForwardAgain() {
        var navigation = AppShellNavigationState()

        navigation.openBrowse()

        XCTAssertEqual(navigation.currentRoute, .browse)
        XCTAssertTrue(navigation.detailPath.isEmpty)
        XCTAssertEqual(navigation.browseScrollToTopTrigger, 1)
        XCTAssertEqual(navigation.backPreviewRoute, .home)

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .home)
        XCTAssertEqual(navigation.forwardStack, [.browse])

        navigation.goForward()

        XCTAssertEqual(navigation.currentRoute, .browse)
        XCTAssertEqual(navigation.browseScrollToTopTrigger, 2)
        XCTAssertTrue(navigation.forwardStack.isEmpty)
    }

    func testHomeCollectionBackChainReturnsToHomeInsteadOfBrowse() {
        var navigation = AppShellNavigationState()

        navigation.openHomeBrowseCollection(.city("danang"))

        XCTAssertEqual(navigation.currentRoute, .browseCollection(.city("danang")))
        XCTAssertEqual(navigation.backPreviewRoute, .home)

        navigation.openDetail("viet-phrase-city-danang-place-dragon-bridge")
        XCTAssertEqual(navigation.backPreviewRoute, .browseCollection(.city("danang")))

        navigation.goBack()
        XCTAssertEqual(navigation.currentRoute, .browseCollection(.city("danang")))
        XCTAssertEqual(navigation.backPreviewRoute, .home)

        navigation.goBack()
        XCTAssertEqual(navigation.currentRoute, .home)
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-phrase-city-danang-place-dragon-bridge"), .browseCollection(.city("danang"))])
    }

    func testBrowseCollectionBackChainStillReturnsToBrowse() {
        var navigation = AppShellNavigationState()

        navigation.openBrowse()
        navigation.openBrowseCollection(.city("danang"))

        XCTAssertEqual(navigation.currentRoute, .browseCollection(.city("danang")))
        XCTAssertEqual(navigation.backPreviewRoute, .browse)

        navigation.goBack()
        XCTAssertEqual(navigation.currentRoute, .browse)
        XCTAssertEqual(navigation.forwardStack, [.browseCollection(.city("danang"))])
    }

    func testOpeningPracticeRouteCanReturnHome() {
        var navigation = AppShellNavigationState()

        navigation.openPractice()

        XCTAssertEqual(navigation.currentRoute, .practice)
        XCTAssertTrue(navigation.detailPath.isEmpty)
        XCTAssertEqual(navigation.practiceScrollToTopTrigger, 1)

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .home)
        XCTAssertEqual(navigation.forwardStack, [.practice])
    }

    func testOpeningHomeFromSearchClearsHistoryToHome() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-phrase-hello-chao-anh"))
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

        navigation.openDetail("viet-phrase-hello-chao-anh")
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

        navigation.openDetail("viet-phrase-hello-chao-anh")
        XCTAssertEqual(navigation.backPreviewRoute, .saved)

        navigation.openDetail("viet-phrase-hello-chao-chi")
        XCTAssertEqual(navigation.backPreviewRoute, .detailPage("viet-phrase-hello-chao-anh"))
    }

    func testSearchBackPreviewUsesRouteBelowSearch() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-phrase-hello-chao-anh"))
        navigation.openSearch()

        XCTAssertEqual(navigation.backPreviewRoute, .detailPage("viet-phrase-hello-chao-anh"))

        var homeSearchNavigation = AppShellNavigationState()
        homeSearchNavigation.openSearch()

        XCTAssertEqual(homeSearchNavigation.backPreviewRoute, .home)
    }

    func testDuplicateCurrentDetailDoesNotRequestTopScroll() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-phrase-hello-chao-anh"))

        navigation.openDetail("viet-phrase-hello-chao-anh")

        XCTAssertEqual(navigation.detailPath, ["viet-phrase-hello-chao-anh"])
        XCTAssertEqual(navigation.detailScrollToTopTrigger, 0)
    }

    func testEdgeSwipeBackPopsOneDetailPage() {
        var navigation = AppShellNavigationState()
        navigation.openDetail("viet-phrase-hello-chao-anh")
        navigation.openDetail("viet-phrase-hello-chao-chi")

        let handled = navigation.handleBackSwipe(
            startX: 18,
            translation: CGSize(width: 96, height: 8)
        )

        XCTAssertTrue(handled)
        XCTAssertEqual(navigation.detailPath, ["viet-phrase-hello-chao-anh"])
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-phrase-hello-chao-chi")])
    }

    func testBackSwipeIgnoresNonBackGestures() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-phrase-hello-chao-anh"))

        XCTAssertFalse(navigation.handleBackSwipe(startX: 80, translation: CGSize(width: 120, height: 0)))
        XCTAssertFalse(navigation.handleBackSwipe(startX: 18, translation: CGSize(width: -120, height: 0)))
        XCTAssertFalse(navigation.handleBackSwipe(startX: 18, translation: CGSize(width: 120, height: 96)))
        XCTAssertEqual(navigation.detailPath, ["viet-phrase-hello-chao-anh"])
    }

    func testBackSwipeClosesSearchBeforePoppingDetailPage() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-phrase-hello-chao-anh"))
        navigation.isSearchPresented = true

        let handled = navigation.handleBackSwipe(
            startX: 18,
            translation: CGSize(width: 96, height: 8)
        )

        XCTAssertTrue(handled)
        XCTAssertFalse(navigation.isSearchPresented)
        XCTAssertEqual(navigation.detailPath, ["viet-phrase-hello-chao-anh"])
        XCTAssertEqual(navigation.forwardStack, [.search])
    }

    func testEdgeSwipePoliciesStayNearScreenEdges() {
        XCTAssertLessThanOrEqual(AppBackSwipeGesturePolicy.edgeStartWidth, 44)
        XCTAssertLessThanOrEqual(AppForwardSwipeGesturePolicy.edgeStartWidth, 44)
    }

    func testEdgeSwipeCapturePoliciesTrackHorizontalMovementOnly() {
        XCTAssertTrue(AppBackSwipeGesturePolicy.canTrackBackSwipe(translation: CGSize(width: 96, height: 8)))
        XCTAssertTrue(AppForwardSwipeGesturePolicy.canTrackForwardSwipe(translation: CGSize(width: -96, height: 8)))

        XCTAssertFalse(AppBackSwipeGesturePolicy.canTrackBackSwipe(translation: CGSize(width: 96, height: 88)))
        XCTAssertFalse(AppForwardSwipeGesturePolicy.canTrackForwardSwipe(translation: CGSize(width: -96, height: 88)))
        XCTAssertFalse(AppBackSwipeGesturePolicy.canTrackBackSwipe(translation: CGSize(width: 48, height: 64)))
        XCTAssertFalse(AppForwardSwipeGesturePolicy.canTrackForwardSwipe(translation: CGSize(width: -48, height: 64)))
    }

    func testForwardStackRestoresAPoppedDetailPage() {
        var navigation = AppShellNavigationState()
        navigation.openDetail("viet-phrase-hello-chao-anh")
        navigation.openDetail("viet-phrase-hello-chao-chi")

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-hello-chao-anh"))
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-phrase-hello-chao-chi")])

        navigation.goForward()

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-hello-chao-chi"))
        XCTAssertTrue(navigation.forwardStack.isEmpty)
    }

    func testOpeningANewDetailAfterBackClearsForwardStack() {
        var navigation = AppShellNavigationState()
        navigation.openDetail("viet-phrase-hello-chao-anh")
        navigation.openDetail("viet-phrase-hello-chao-chi")
        navigation.goBack()

        navigation.openDetail("viet-phrase-hello-chao-em")

        XCTAssertEqual(navigation.detailPath, ["viet-phrase-hello-chao-anh", "viet-phrase-hello-chao-em"])
        XCTAssertTrue(navigation.forwardStack.isEmpty)
    }

    func testRenderedDetailPagesKeepOnlyActiveAndImmediateBackPage() {
        var navigation = AppShellNavigationState()
        navigation.openDetail("viet-phrase-hello-chao-anh")
        navigation.openDetail("viet-phrase-hello-chao-chi")
        navigation.openDetail("viet-phrase-hello-chao-em")
        navigation.openDetail("viet-phrase-hello-chao-ba")

        XCTAssertEqual(navigation.detailPath, [
            "viet-phrase-hello-chao-anh",
            "viet-phrase-hello-chao-chi",
            "viet-phrase-hello-chao-em",
            "viet-phrase-hello-chao-ba",
        ])
        XCTAssertEqual(navigation.renderedDetailPageIDs, [
            "viet-phrase-hello-chao-em",
            "viet-phrase-hello-chao-ba",
        ])

        navigation.goBack()

        XCTAssertEqual(navigation.renderedDetailPageIDs, [
            "viet-phrase-hello-chao-chi",
            "viet-phrase-hello-chao-em",
        ])
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-phrase-hello-chao-ba")])
    }

    func testRenderedDetailPagesKeepVisitIdentityForRevisitedPhrase() {
        var navigation = AppShellNavigationState()
        navigation.openDetail("viet-phrase-hello-chao-anh")
        navigation.openDetail("viet-phrase-hello-chao-chi")

        let originalRenderedPages = navigation.renderedDetailPages

        navigation.openDetail("viet-phrase-hello-chao-anh")

        XCTAssertEqual(navigation.detailPath, [
            "viet-phrase-hello-chao-anh",
            "viet-phrase-hello-chao-chi",
            "viet-phrase-hello-chao-anh",
        ])
        XCTAssertEqual(navigation.renderedDetailPageIDs, [
            "viet-phrase-hello-chao-chi",
            "viet-phrase-hello-chao-anh",
        ])
        XCTAssertNotEqual(originalRenderedPages.first?.id, navigation.renderedDetailPages.first?.id)
        XCTAssertEqual(navigation.renderedDetailPages.last?.id, "2-viet-phrase-hello-chao-anh")
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

    func testOpeningBrowseCollectionFromSearchClosesSearchAndKeepsBrowseHistory() {
        var navigation = AppShellNavigationState()

        navigation.openBrowse()
        navigation.openSearch()
        navigation.openBrowseCollection(.category("hotel"))

        XCTAssertFalse(navigation.isSearchPresented)
        XCTAssertEqual(navigation.currentRoute, .browseCollection(.category("hotel")))
        XCTAssertEqual(navigation.browseCollectionPath, [.category("hotel")])
        XCTAssertTrue(navigation.forwardStack.isEmpty)

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .browse)
        XCTAssertEqual(navigation.forwardStack, [.browseCollection(.category("hotel"))])

        navigation.goForward()

        XCTAssertEqual(navigation.currentRoute, .browseCollection(.category("hotel")))
        XCTAssertTrue(navigation.forwardStack.isEmpty)
    }

    func testBrowseSearchDestinationsResolveToCanonicalPages() {
        guard let hotel = BrowseSearchDestinations.situations.first(where: { $0.id == "hotel" }) else {
            XCTFail("Expected hotel Browse destination")
            return
        }

        XCTAssertNotNil(hotel.openablePageID)
        XCTAssertTrue(BrowseSearchDestinations.situations.allSatisfy { $0.openablePageID != nil })
        XCTAssertFalse(BrowseSearchDestinations.cityShortcuts.isEmpty)
        XCTAssertFalse(BrowseSearchDestinations.suggestedNeeds.isEmpty)
    }

    func testBrowseSearchDestinationsUseCanonicalCityIDs() {
        XCTAssertNotNil(BrowseSearchDestinations.cityShortcuts.first { $0.id == "hcmc" })
        XCTAssertNotNil(BrowseSearchDestinations.cityShortcuts.first { $0.id == "danang" })
        XCTAssertNotNil(BrowseSearchDestinations.cityShortcuts.first { $0.id == "hoian" })
        XCTAssertFalse(BrowseSearchDestinations.cityShortcuts.contains { $0.id == "ho-chi-minh-city" })
        XCTAssertFalse(BrowseSearchDestinations.cityShortcuts.contains { $0.id == "da-nang" })
        XCTAssertFalse(BrowseSearchDestinations.cityShortcuts.contains { $0.id == "hoi-an" })
    }

    func testBrowseCollectionDescriptorsExposeStarterRowsAndPracticePolicy() {
        let hotel = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("hotel")))
        let shopping = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("shopping")))
        let hanoi = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .city("hanoi")))

        XCTAssertEqual(hotel.route, .category("hotel"))
        XCTAssertEqual(hotel.title, "Hotel")
        XCTAssertFalse(hotel.subcategories.isEmpty)
        XCTAssertFalse(hotel.starterItems.isEmpty)
        XCTAssertEqual(hotel.practiceAction, .addStarterPages(hotel.starterItems.map(\.pageID)))
        XCTAssertTrue(hotel.mastheadImageName.hasPrefix("BrowseCollection"))

        XCTAssertEqual(shopping.practiceSubtitle, "Practice prices, sizes, payment, and returns.")
        XCTAssertFalse(shopping.practiceSubtitle.localizedCaseInsensitiveContains("quick practice loop"))

        XCTAssertEqual(hanoi.route, .city("hanoi"))
        XCTAssertEqual(hanoi.practiceAction, .practiceMode(.hanoiBucketList))
        XCTAssertFalse(hanoi.subcategories.isEmpty)
        XCTAssertFalse(hanoi.starterItems.isEmpty)
        XCTAssertNotNil(hanoi.cityHub)
        XCTAssertEqual(hanoi.cityHub?.situationTitle, "What are you doing?")
        XCTAssertEqual(hanoi.cityHub?.namesTitle, "Names to know")
    }

    func testDaNangCityDescriptorUsesTravelModeHubInsteadOfPhraseFeed() {
        let danang = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .city("danang")))
        let cityHub = try! XCTUnwrap(danang.cityHub)

        XCTAssertEqual(danang.title, "Da Nang")
        XCTAssertEqual(danang.subtitle, "Airport arrivals, beach rides, river landmarks, markets, and day trips.")
        XCTAssertEqual(danang.mastheadImageName, "HeroCityDanang")
        XCTAssertEqual(danang.starterTitle, "Names to know")
        XCTAssertEqual(danang.practiceTitle, "Practice a Da Nang day")
        XCTAssertEqual(danang.practiceSubtitle, "Airport pickup, beach drop-off, food, and a ride back.")
        XCTAssertFalse(danang.practiceSubtitle.localizedCaseInsensitiveContains("phrase loop"))

        XCTAssertEqual(
            cityHub.situations.map(\.title),
            ["Arriving", "Getting around", "Beach day", "Food & coffee", "Places to visit", "Help"]
        )
        XCTAssertTrue(cityHub.situations.allSatisfy { $0.targetRoute != nil })
        XCTAssertEqual(cityHub.situations.first(where: { $0.title == "Food & coffee" })?.subtitle, "Restaurants, cafés, markets")
        XCTAssertEqual(cityHub.situations.first(where: { $0.title == "Places to visit" })?.subtitle, "Dragon Bridge, Marble Mountains, Bà Nà Hills")
        XCTAssertEqual(cityHub.namesToKnowItems.first?.pageID, "viet-phrase-city-danang-place-airport")
        XCTAssertTrue(cityHub.namesToKnowItems.contains { $0.pageID == "viet-phrase-city-danang-place-dragon-bridge" })
        XCTAssertTrue(cityHub.namesToKnowItems.contains { $0.pageID == "viet-phrase-city-danang-place-nguyen-van-linh-street" })
        XCTAssertFalse(cityHub.namesToKnowItems.contains { item in
            item.title.localizedCaseInsensitiveContains("Cảng Tiên Sa")
                || item.subtitle.localizedCaseInsensitiveContains("Tien Sa Port")
        })

        XCTAssertEqual(cityHub.quickPhrasesTitle, "Quick phrases")
        XCTAssertEqual(cityHub.quickPhraseItems.first?.pageID, "viet-phrase-city-danang-to-airport")
        XCTAssertTrue(cityHub.quickPhraseItems.contains { $0.pageID == "viet-phrase-city-danang-get-off-my-khe" })
        XCTAssertTrue(cityHub.quickPhraseItems.contains { $0.pageID == "viet-phrase-ves-call-taxi-for-me" })
        XCTAssertTrue(cityHub.quickPhraseItems.contains { item in
            item.title.localizedCaseInsensitiveContains("Nhà vệ sinh")
                || item.subtitle.localizedCaseInsensitiveContains("bathroom")
        })
        XCTAssertTrue(cityHub.browseGroups.contains { $0.title == "Landmarks" })
        XCTAssertTrue(cityHub.browseGroups.contains { $0.title == "Streets" })
    }

    func testBrowseCollectionMastheadsUseOwnedHeroArtForVisibleHubs() {
        let saigon = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .city("hcmc")))
        let greetings = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("greetings")))
        let emergency = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("emergency")))

        XCTAssertEqual(saigon.title, "Saigon")
        XCTAssertEqual(saigon.mastheadImageName, "HeroCityHcmc")
        XCTAssertEqual(greetings.mastheadImageName, "HeroCategoryGreetings")
        XCTAssertEqual(emergency.mastheadImageName, "HeroCategoryEmergency")
        XCTAssertFalse([saigon, greetings, emergency].contains { descriptor in
            descriptor.mastheadImageName == "HeroVietnamMasthead"
                || descriptor.mastheadImageName == "HeroNeutralMasthead"
        })
    }

    func testAllVietnamDescriptorUsesCountryHubInsteadOfPhraseFeed() {
        let vietnam = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("city-guides")))
        let countryHub = try! XCTUnwrap(vietnam.cityHub)

        XCTAssertEqual(vietnam.title, "All Vietnam")
        XCTAssertEqual(vietnam.subtitle, "Everyday phrases for cities, food, transport, hotels, and help.")
        XCTAssertEqual(vietnam.mastheadImageName, "HeroCountryVietnam")
        XCTAssertEqual(vietnam.practiceTitle, "Practice Vietnam basics")
        XCTAssertEqual(vietnam.practiceSubtitle, "Arrival, taxi, food, hotel, and help.")
        XCTAssertTrue(vietnam.subcategories.isEmpty)
        XCTAssertTrue(vietnam.exploreShelves.isEmpty)

        XCTAssertEqual(countryHub.situationTitle, "Start here")
        XCTAssertEqual(
            countryHub.situations.map(\.title),
            ["First day in Vietnam", "Airport arrival", "Taxi / Grab", "Food & drink", "Hotel", "Help"]
        )
        XCTAssertTrue(countryHub.situations.allSatisfy { $0.targetRoute != nil })

        XCTAssertEqual(countryHub.browseTitle, "City guides")
        XCTAssertEqual(countryHub.browseGroups.map(\.title), ["Hanoi", "Ho Chi Minh City", "Da Nang", "Hoi An", "Hue"])
        XCTAssertTrue(countryHub.browseGroups.allSatisfy { $0.targetRoute != nil })

        XCTAssertEqual(countryHub.namesTitle, "Essential phrases")
        XCTAssertEqual(countryHub.namesToKnowItems.map(\.pageID), [
            "viet-phrase-polite-1",
            "viet-phrase-polite-2",
            "viet-phrase-problems-2",
            "viet-phrase-repair-english-help",
            "viet-phrase-bath-1",
        ])
        XCTAssertFalse(countryHub.namesToKnowItems.contains { item in
            item.title.localizedCaseInsensitiveContains("Anăn")
                || item.title.localizedCaseInsensitiveContains("Biển An Bàng")
                || item.subtitle.localizedCaseInsensitiveContains("near here")
        })
    }

    func testSearchStrongMatchesReturnBrowseCollectionsBeforePhraseRows() {
        let hotelCollections = BrowseSearchDestinations.matchingCollections(for: "hotel")
        let hanoiCollections = BrowseSearchDestinations.matchingCollections(for: "hanoi")

        XCTAssertEqual(hotelCollections.first?.route, .category("hotel"))
        XCTAssertEqual(hanoiCollections.first?.route, .city("hanoi"))
    }

    func testSearchCollectionMatchesStayLightweightWhileTyping() {
        let hotel = BrowseSearchDestinations.matchingCollections(for: "hotel").first?.descriptor
        let hanoi = BrowseSearchDestinations.matchingCollections(for: "hanoi").first?.descriptor

        XCTAssertEqual(hotel?.route, .category("hotel"))
        XCTAssertEqual(hanoi?.route, .city("hanoi"))
        XCTAssertEqual(hotel?.starterItems.count, 0)
        XCTAssertEqual(hotel?.subcategories.count, 0)
        XCTAssertEqual(hotel?.exploreShelves.count, 0)
        XCTAssertEqual(hanoi?.starterItems.count, 0)
        XCTAssertEqual(hanoi?.subcategories.count, 0)
        XCTAssertEqual(hanoi?.exploreShelves.count, 0)
    }

    func testSearchRanksStandalonePlacePageBeforeHelperPhrases() {
        let exactPlaceResults = BrowseSearchDestinations.searchResults(for: "Bà Nà Hills", limit: 5)
        let partialPlaceResults = BrowseSearchDestinations.searchResults(for: "hills", limit: 5)

        XCTAssertEqual(exactPlaceResults.first?.pageID, "viet-phrase-city-danang-place-ba-na-hills")
        XCTAssertEqual(partialPlaceResults.first?.pageID, "viet-phrase-city-danang-place-ba-na-hills")
    }

    func testForwardSwipeRestoresForwardRoute() {
        var navigation = AppShellNavigationState()
        navigation.openDetail("viet-phrase-hello-chao-anh")
        navigation.goBack()

        let handled = navigation.handleForwardSwipe(
            translation: CGSize(width: -96, height: 4)
        )

        XCTAssertTrue(handled)
        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-hello-chao-anh"))
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

    func testInteractivePresentationKeepsBackLayersVerticallyLocked() {
        let drag = AppInteractiveNavigationDrag(direction: .back, translation: 120, width: 400)
        let currentPresentation = AppInteractiveNavigationPresentation.presentation(
            route: .detailPage("viet-phrase-hello-chao-chi"),
            currentRoute: .detailPage("viet-phrase-hello-chao-chi"),
            backPreviewRoute: .detailPage("viet-phrase-hello-chao-anh"),
            forwardPreviewRoute: nil,
            drag: drag,
            width: 400
        )
        let backPresentation = AppInteractiveNavigationPresentation.presentation(
            route: .detailPage("viet-phrase-hello-chao-anh"),
            currentRoute: .detailPage("viet-phrase-hello-chao-chi"),
            backPreviewRoute: .detailPage("viet-phrase-hello-chao-anh"),
            forwardPreviewRoute: nil,
            drag: drag,
            width: 400
        )

        XCTAssertEqual(currentPresentation.scale, 1, accuracy: 0.001)
        XCTAssertEqual(backPresentation.scale, 1, accuracy: 0.001)
        XCTAssertEqual(currentPresentation.horizontalOffset, 120, accuracy: 0.001)
        XCTAssertEqual(backPresentation.horizontalOffset, 0, accuracy: 0.001)
    }

    func testInteractivePresentationKeepsForwardLayersVerticallyLocked() {
        let drag = AppInteractiveNavigationDrag(direction: .forward, translation: -120, width: 400)
        let currentPresentation = AppInteractiveNavigationPresentation.presentation(
            route: .detailPage("viet-phrase-hello-chao-anh"),
            currentRoute: .detailPage("viet-phrase-hello-chao-anh"),
            backPreviewRoute: .home,
            forwardPreviewRoute: .detailPage("viet-phrase-hello-chao-chi"),
            drag: drag,
            width: 400
        )
        let forwardPresentation = AppInteractiveNavigationPresentation.presentation(
            route: .detailPage("viet-phrase-hello-chao-chi"),
            currentRoute: .detailPage("viet-phrase-hello-chao-anh"),
            backPreviewRoute: .home,
            forwardPreviewRoute: .detailPage("viet-phrase-hello-chao-chi"),
            drag: drag,
            width: 400
        )

        XCTAssertEqual(currentPresentation.scale, 1, accuracy: 0.001)
        XCTAssertEqual(forwardPresentation.scale, 1, accuracy: 0.001)
        XCTAssertEqual(currentPresentation.horizontalOffset, -21.6, accuracy: 0.001)
        XCTAssertEqual(forwardPresentation.horizontalOffset, 280, accuracy: 0.001)
    }

    func testInteractiveNavigationCompletionTargetsAreDeterministic() {
        XCTAssertEqual(
            AppInteractiveNavigationGesture.completionTranslation(for: .back, width: 400),
            400,
            accuracy: 0.001
        )
        XCTAssertEqual(
            AppInteractiveNavigationGesture.completionTranslation(for: .forward, width: 400),
            -400,
            accuracy: 0.001
        )
        XCTAssertEqual(
            AppInteractiveNavigationGesture.cancellationTranslation,
            0,
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

        store.recordOpenedPage("viet-phrase-hello-chao-anh", source: .home)
        store.recordOpenedPage("viet-thank-you", source: .search)
        store.recordOpenedPage("viet-phrase-hello-chao-anh", source: .article)
        store.recordOpenedPage("missing-page", source: .article)

        XCTAssertEqual(store.recentPageIDs, ["viet-phrase-hello-chao-anh", "viet-phrase-polite-2"])
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

    func testSavedPagesDoNotAutomaticallyEnterPracticePool() {
        let store = LocalUserIntentStore(defaults: defaults)

        store.toggleSavedPage("viet-family-repair-understand")

        XCTAssertEqual(store.savedPageIDs, ["viet-phrase-problems-2"])
        XCTAssertTrue(store.practicePageIDs.isEmpty)
    }

    func testCategoryPracticeAddsCanonicalStarterPagesWithoutDuplicates() {
        let store = LocalUserIntentStore(defaults: defaults)

        store.togglePracticePage("viet-thank-you")
        store.addPracticePages([
            "viet-family-repair-understand",
            "missing-page",
            "viet-family-repair-understand",
        ])

        XCTAssertEqual(store.practicePageIDs, ["viet-phrase-problems-2", "viet-phrase-polite-2"])
    }
}
