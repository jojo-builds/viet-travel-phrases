import XCTest
import CoreGraphics
@testable import SpeakLocalNative

final class AppChromeTests: XCTestCase {
    func testBottomChromeLayoutUsesNativeScaleIslandMetrics() {
        XCTAssertLessThan(AppChromeLayout.dockHorizontalPadding, 16)
        XCTAssertLessThanOrEqual(AppChromeLayout.dockVerticalPadding, 6)
        XCTAssertGreaterThanOrEqual(AppChromeLayout.searchIslandSize, 62)
        XCTAssertLessThanOrEqual(AppChromeLayout.searchIslandSize, 66)
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
        XCTAssertLessThanOrEqual(
            AppChromeLayout.bottomHitTestEnvelopeHeight,
            AppChromeLayout.searchIslandSize + AppChromeLayout.bottomVisibleHitSlop * 2
        )
        XCTAssertFalse(AppChromeLayout.chromeSeparationAllowsHitTesting)
    }

    func testBottomChromeGlassSurfacesHaveNativeBreathingRoom() {
        XCTAssertGreaterThanOrEqual(AppChromeLayout.bottomSpacing, 8)
        XCTAssertLessThanOrEqual(AppChromeLayout.bottomSpacing, 14)
        XCTAssertLessThanOrEqual(
            AppChromeLayout.dockMaximumContentWidth,
            AppDockSelectionLayout.contentWidth(itemCount: 4) + 36
        )
    }

    func testOuterChromeLayersUseSemanticOrdering() {
        XCTAssertGreaterThan(AppChromeLayout.searchPageLayerZIndex, AppChromeLayout.contentPageLayerZIndex)
        XCTAssertGreaterThan(AppChromeLayout.chromeSeparationLayerZIndex, AppChromeLayout.searchPageLayerZIndex)
        XCTAssertGreaterThan(AppChromeLayout.bottomChromeLayerZIndex, AppChromeLayout.chromeSeparationLayerZIndex)
        XCTAssertGreaterThan(AppChromeLayout.topAdminHitTestLayerZIndex, AppChromeLayout.bottomChromeLayerZIndex)
        XCTAssertGreaterThan(AppChromeLayout.topAdminControlLayerZIndex, AppChromeLayout.topAdminHitTestLayerZIndex)
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
        XCTAssertGreaterThanOrEqual(AppChromeLayout.dockSelectionWidth, AppChromeLayout.dockItemWidth * 1.25)
        XCTAssertLessThanOrEqual(AppChromeLayout.dockSelectionHeight, AppChromeLayout.searchIslandSize)
        XCTAssertGreaterThan(AppChromeLayout.dockSelectionPressedWidth, AppChromeLayout.dockSelectionWidth)
        XCTAssertGreaterThan(AppChromeLayout.dockSelectionPressedHeight, AppChromeLayout.dockSelectionHeight)
        XCTAssertGreaterThan(AppChromeLayout.dockSelectionPressedHeight, AppChromeLayout.searchIslandSize)
        XCTAssertGreaterThan(AppChromeLayout.dockItemForegroundZIndex, AppChromeLayout.dockSelectionLensZIndex)
        XCTAssertGreaterThanOrEqual(AppChromeLayout.dockSelectionMorphDuration, 0.30)
        XCTAssertLessThanOrEqual(AppChromeLayout.dockSelectionMorphDuration, 0.36)
        XCTAssertGreaterThan(AppChromeLayout.dockSelectionDragCommitDistance, 0)
        XCTAssertGreaterThan(AppChromeLayout.dockSelectionStretchFactor, 0)
        XCTAssertGreaterThan(AppChromeLayout.dockSelectionMaximumStretch, 0)
        XCTAssertGreaterThan(AppChromeLayout.dockSelectionLagFactor, 0)
        XCTAssertEqual(AppChromeLayout.dockSelectionTapActivationDelay, 0)
        XCTAssertGreaterThan(AppChromeLayout.dockSelectionTapTravelDelay, AppChromeLayout.dockSelectionTapActivationDelay)
        XCTAssertGreaterThan(AppChromeLayout.dockSelectionTapDeactivateDelay, 0)
    }

    func testDockSelectionDragMapsLocationsAcrossPrimaryTabs() {
        XCTAssertEqual(AppDockSelectionLayout.itemIndex(for: 4, itemCount: 4), 0)
        XCTAssertEqual(AppDockSelectionLayout.itemIndex(for: 64, itemCount: 4), 1)
        XCTAssertEqual(AppDockSelectionLayout.itemIndex(for: 128, itemCount: 4), 2)
        XCTAssertEqual(AppDockSelectionLayout.itemIndex(for: 224, itemCount: 4), 3)
        XCTAssertEqual(AppDockSelectionLayout.itemIndex(for: -40, itemCount: 4), 0)
        XCTAssertEqual(AppDockSelectionLayout.itemIndex(for: 600, itemCount: 4), 3)
    }

    func testDockSelectionDragMapsAcrossExpandedChromeTrack() {
        let expandedWidth = AppDockSelectionLayout.contentWidth(itemCount: 4) + 90
        let firstCenter = AppDockSelectionLayout.itemCenterX(index: 0, itemCount: 4, contentWidth: expandedWidth)
        let lastCenter = AppDockSelectionLayout.itemCenterX(index: 3, itemCount: 4, contentWidth: expandedWidth)

        XCTAssertEqual(firstCenter, AppChromeLayout.dockItemWidth / 2)
        XCTAssertEqual(lastCenter, expandedWidth - AppChromeLayout.dockItemWidth / 2)
        XCTAssertEqual(
            AppDockSelectionLayout.itemIndex(for: lastCenter, itemCount: 4, contentWidth: expandedWidth),
            3
        )

        let expandedLens = AppDockSelectionLayout.lensMetrics(
            selectedIndex: 0,
            activeIndex: 3,
            dragX: lastCenter,
            itemCount: 4,
            reduceMotion: true,
            contentWidth: expandedWidth
        )
        XCTAssertEqual(
            expandedLens.xOffset,
            lastCenter - AppChromeLayout.dockSelectionPressedWidth / 2
        )
        XCTAssertEqual(expandedLens.height, AppChromeLayout.dockSelectionPressedHeight)
    }

    func testDockSelectionTapFlightUsesSingleFluidTravelWindow() {
        let totalTapFlightDelay = AppChromeLayout.dockSelectionTapActivationDelay
            + AppChromeLayout.dockSelectionTapTravelDelay
            + AppChromeLayout.dockSelectionTapDeactivateDelay

        XCTAssertEqual(AppChromeLayout.dockSelectionTapActivationDelay, 0)
        XCTAssertLessThanOrEqual(AppChromeLayout.dockSelectionTapTravelDelay, 170_000_000)
        XCTAssertLessThanOrEqual(AppChromeLayout.dockSelectionTapDeactivateDelay, 90_000_000)
        XCTAssertLessThanOrEqual(totalTapFlightDelay, 260_000_000)
    }

    func testDockSelectionTouchDownMovesLensToTouchedItemImmediately() {
        let itemCount = 4
        let selectedIndex = 0
        let touchedIndex = 3
        let touchedCenter = AppDockSelectionLayout.itemCenterX(index: touchedIndex)
        let metrics = AppDockSelectionLayout.lensMetrics(
            selectedIndex: selectedIndex,
            activeIndex: touchedIndex,
            dragX: touchedCenter,
            itemCount: itemCount,
            reduceMotion: true
        )

        XCTAssertEqual(
            metrics.xOffset,
            touchedCenter - AppChromeLayout.dockSelectionPressedWidth / 2
        )
        XCTAssertEqual(metrics.width, AppChromeLayout.dockSelectionPressedWidth)
        XCTAssertEqual(metrics.height, AppChromeLayout.dockSelectionPressedHeight)
    }

    func testDockSelectionTapTravelDoesNotUseDragStretch() {
        let touchedCenter = AppDockSelectionLayout.itemCenterX(index: 3)
        let metrics = AppDockSelectionLayout.lensMetrics(
            selectedIndex: 0,
            activeIndex: 3,
            dragX: touchedCenter,
            itemCount: 4,
            reduceMotion: false,
            predictedDragX: touchedCenter,
            stretchesWithMotion: false
        )

        XCTAssertEqual(
            metrics.xOffset,
            touchedCenter - AppChromeLayout.dockSelectionPressedWidth / 2
        )
        XCTAssertEqual(metrics.width, AppChromeLayout.dockSelectionPressedWidth)
        XCTAssertEqual(metrics.height, AppChromeLayout.dockSelectionPressedHeight)
    }

    func testDockSelectionLensStretchesWhileDraggingAndSettlesWhenReducedMotion() {
        let selectedMetrics = AppDockSelectionLayout.lensMetrics(
            selectedIndex: 0,
            activeIndex: 0,
            dragX: nil,
            itemCount: 4,
            reduceMotion: false
        )
        XCTAssertEqual(selectedMetrics.width, AppChromeLayout.dockSelectionWidth)
        XCTAssertEqual(selectedMetrics.height, AppChromeLayout.dockSelectionHeight)
        XCTAssertEqual(
            selectedMetrics.xOffset,
            AppDockSelectionLayout.itemCenterX(index: 0) - AppChromeLayout.dockSelectionWidth / 2
        )

        let draggedMetrics = AppDockSelectionLayout.lensMetrics(
            selectedIndex: 0,
            activeIndex: 3,
            dragX: AppDockSelectionLayout.itemCenterX(index: 3),
            itemCount: 4,
            reduceMotion: false
        )
        XCTAssertGreaterThan(draggedMetrics.width, AppChromeLayout.dockSelectionPressedWidth)
        XCTAssertGreaterThan(draggedMetrics.height, AppChromeLayout.dockSelectionPressedHeight)
        XCTAssertLessThanOrEqual(
            draggedMetrics.width,
            AppChromeLayout.dockSelectionPressedWidth + AppChromeLayout.dockSelectionMaximumStretch
        )

        let reducedMotionMetrics = AppDockSelectionLayout.lensMetrics(
            selectedIndex: 0,
            activeIndex: 3,
            dragX: AppDockSelectionLayout.itemCenterX(index: 3),
            itemCount: 4,
            reduceMotion: true
        )
        XCTAssertEqual(reducedMotionMetrics.width, AppChromeLayout.dockSelectionPressedWidth)
        XCTAssertEqual(reducedMotionMetrics.height, AppChromeLayout.dockSelectionPressedHeight)
        XCTAssertEqual(
            reducedMotionMetrics.xOffset,
            AppDockSelectionLayout.itemCenterX(index: 3) - AppChromeLayout.dockSelectionPressedWidth / 2
        )
    }

    func testSearchAndSelectedDockIconsUseDistinctForegroundMorphIDs() {
        XCTAssertNotEqual(AppChromeMorphID.searchIcon, AppChromeMorphID.dockItem(.home))
        XCTAssertNotEqual(AppChromeMorphID.searchIcon, AppChromeMorphID.dockItem(.browse))
        XCTAssertNotEqual(AppChromeMorphID.dockSelection, AppChromeMorphID.dock)
        XCTAssertNotEqual(AppChromeMorphID.dockSelection, AppChromeMorphID.search)
    }

    func testPinnedAudioTopAdminDoesNotReserveScrollClearance() {
        XCTAssertEqual(AppChromeLayout.pinnedAudioSpeedScrollClearance, 0)
        XCTAssertGreaterThanOrEqual(
            AppChromeLayout.topAdminHitTestEnvelopeHeight,
            AppChromeLayout.pinnedAudioSpeedRevealY
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

    func testSearchRowsPromotePlayablePhraseAudioToLeadingControl() throws {
        let xinChaoAudioKey = try XCTUnwrap(AudioAssetManifest.main?.audioKey(forExactText: "Xin chào"))

        XCTAssertTrue(SearchResultRowLayout.usesLeadingAudioControl(audioKey: xinChaoAudioKey))
        XCTAssertFalse(SearchResultRowLayout.usesLeadingAudioControl(audioKey: nil))

        let chaoResults = BrowseSearchDestinations.searchResults(for: "chao", limit: 5)
        XCTAssertTrue(
            chaoResults.contains { SearchResultRowLayout.usesLeadingAudioControl(audioKey: $0.audioKey) },
            "Search phrase rows with playable audio should render the speaker as the leading control."
        )
    }

    func testHomeSituationRowsUseStableCardMetrics() {
        XCTAssertEqual(HomeLayout.situationRowHeight, 96)
        XCTAssertEqual(HomeLayout.situationIconSize, 46)
        XCTAssertEqual(HomeLayout.situationImageWidth, 108)
        XCTAssertEqual(HomeLayout.situationImageHeight, 68)
        XCTAssertLessThan(HomeLayout.situationImageHeight, HomeLayout.situationRowHeight)
    }

    func testHomeMessageRailUsesStableCircleContactMetrics() {
        XCTAssertEqual(HomeLayout.messageAvatarSize, 82)
        XCTAssertEqual(HomeLayout.messageContactWidth, 104)
        XCTAssertGreaterThan(HomeLayout.messageContactWidth, HomeLayout.messageAvatarSize)
        XCTAssertGreaterThanOrEqual(HomeLayout.messageRailHeight, HomeLayout.messageAvatarSize + 44)
    }

    func testHomeUseNowShelfUsesLargeFeatureCardMetrics() {
        XCTAssertGreaterThanOrEqual(HomeLayout.featurePhraseCardWidth, 320)
        XCTAssertGreaterThanOrEqual(HomeLayout.featurePhraseCardHeight, 300)
        XCTAssertLessThanOrEqual(HomeLayout.featurePhraseCardWidth / HomeLayout.featurePhraseCardHeight, 1.12)
    }

    func testHomeUseNowShelfHasFriendlyStarterDepth() {
        XCTAssertGreaterThanOrEqual(HomeUseNowCatalog.starterIDs.count, 10)
        XCTAssertEqual(HomeUseNowCatalog.featureCardIDs.count, 6)
        XCTAssertTrue(HomeUseNowCatalog.starterIDs.contains(PhrasePage.xinChao.id))
        XCTAssertTrue(HomeUseNowCatalog.starterIDs.contains("viet-thank-you"))
        XCTAssertTrue(HomeUseNowCatalog.starterIDs.contains("viet-family-bathroom-where"))
        XCTAssertFalse(HomeUseNowCatalog.starterIDs.contains("viet-family-health-doctor"))
    }

    func testHomeFirstDayShelfUsesShortBeginnerPhrasePages() throws {
        XCTAssertEqual(HomeFirstDayShelfContent.title, "First Day in Vietnam")
        XCTAssertEqual(HomeFirstDayShelfContent.pageIDs.count, HomeFirstDayShelfContent.maximumCards)
        XCTAssertTrue(HomeFirstDayShelfContent.pageIDs.contains("viet-phrase-taxi-1"))
        XCTAssertFalse(HomeFirstDayShelfContent.pageIDs.contains("viet-phrase-v500-tran-please-take-me-to-this-hotel"))
        XCTAssertFalse(HomeFirstDayShelfContent.pageIDs.contains("viet-phrase-v500-airp-bord-arri-here-is-my-passport"))

        for pageID in HomeFirstDayShelfContent.pageIDs {
            let item = try XCTUnwrap(PhraseCatalog.catalogItem(forOpenablePageID: pageID))
            XCTAssertLessThanOrEqual(
                item.title.split(separator: " ").count,
                4,
                "\(pageID) should stay short enough for a beginner Home shelf."
            )
        }
        XCTAssertEqual(HomePageLinkRegistry.firstDayHomepagePageIDs, HomeFirstDayShelfContent.pageIDs)
    }

    func testHomeRecentlyViewedShelfUsesSixMostRecentCanonicalPages() throws {
        let expected = try HomeUseNowCatalog.starterIDs.prefix(6).map { pageID in
            try XCTUnwrap(PhraseCatalog.canonicalPageID(forOpenablePageID: pageID))
        }

        XCTAssertEqual(
            HomeRecentlyViewedContent.cardPageIDs(from: HomeUseNowCatalog.starterIDs),
            expected
        )
        XCTAssertEqual(HomeRecentlyViewedContent.maximumFeatureCards, 6)
    }

    func testHomeRecentlyViewedShelfSkipsDuplicatesAndMissingPages() throws {
        let thankYouID = try XCTUnwrap(PhraseCatalog.canonicalPageID(forOpenablePageID: "viet-thank-you"))
        let sorryID = try XCTUnwrap(PhraseCatalog.canonicalPageID(forOpenablePageID: "viet-excuse-sorry"))

        XCTAssertEqual(
            HomeRecentlyViewedContent.cardPageIDs(from: [
                "missing-page",
                "viet-thank-you",
                thankYouID,
                "viet-excuse-sorry",
            ]),
            [thankYouID, sorryID]
        )
    }

    func testHomepagePhraseCardsOpenBuiltOutListingPages() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        let issues = HomePageLinkRegistry.homepageListingPageIDs.compactMap {
            homepageListingPageIssue($0, manifest: manifest)
        }

        XCTAssertTrue(issues.isEmpty, "Homepage phrase cards should open built-out listing pages. Missing: \(issues.joined(separator: ", "))")
    }

    private func homepageListingPageIssue(_ pageID: String, manifest: AudioAssetManifest) -> String? {
        guard let canonicalPageID = PhraseCatalog.canonicalPageID(forOpenablePageID: pageID) else {
            return "\(pageID): no canonical page"
        }

        let article: PhraseArticlePage?
        if canonicalPageID == PhrasePage.xinChao.id {
            article = PhrasePage.xinChao.articleTemplate
        } else {
            article = PhraseDetailPage.page(withID: canonicalPageID)?.articleTemplate
        }

        guard let article else {
            return "\(pageID): no article"
        }

        let sectionIDs = Set(article.sections.map(\.id))
        guard sectionIDs.contains("breakdown") else {
            return "\(pageID): missing breakdown"
        }
        guard sectionIDs.contains("at-glance")
            || sectionIDs.contains("traveler-insight")
            || sectionIDs.contains("good-to-know")
            || sectionIDs.contains("when-to-use")
        else {
            return "\(pageID): missing guide section"
        }
        guard article.showsCatalogExplore else {
            return "\(pageID): catalog explore hidden"
        }
        guard manifest.url(for: article.playbackAudioKey) != nil else {
            return "\(pageID): missing hero audio"
        }
        guard article.sections.contains(where: { section in
            !section.phrases.isEmpty
                && (section.presentation == .phraseList || section.presentation == .horizontalPhraseCards)
        }) else {
            return "\(pageID): no phrase-list section"
        }

        return nil
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

    func testBrowseSituationCardsReserveReadableTextWidth() {
        XCTAssertEqual(BrowsePageLayout.situationIconSize, 48)
        XCTAssertGreaterThanOrEqual(BrowsePageLayout.situationCardMinHeight, 132)
        XCTAssertGreaterThanOrEqual(
            BrowsePageLayout.situationCardTitleContentWidth(cardWidth: 176),
            124
        )
    }

    func testDockGlassUsesBackingFillToPreventContentBleed() {
        XCTAssertGreaterThanOrEqual(AppChromeLayout.dockBackdropFillOpacity, 0.40)
        XCTAssertLessThanOrEqual(AppChromeLayout.dockBackdropFillOpacity, 0.50)
        XCTAssertGreaterThanOrEqual(AppChromeLayout.chromeControlBackdropFillOpacity, AppChromeLayout.dockBackdropFillOpacity)
        XCTAssertLessThanOrEqual(AppChromeLayout.chromeControlBackdropFillOpacity, 0.50)
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

    func testDockSelectionRouteChangePolicyLetsSelectedTabAnimationSettle() {
        XCTAssertFalse(
            AppDockInteractionPolicy.shouldResetSelectionLens(
                activeItem: .practice,
                newRoute: .practice
            )
        )
        XCTAssertFalse(
            AppDockInteractionPolicy.shouldResetSelectionLens(
                activeItem: .browse,
                newRoute: .browseCollection(.category("hotel"))
            )
        )
        XCTAssertTrue(
            AppDockInteractionPolicy.shouldResetSelectionLens(
                activeItem: .practice,
                newRoute: .browse
            )
        )
        XCTAssertTrue(
            AppDockInteractionPolicy.shouldResetSelectionLens(
                activeItem: .practice,
                newRoute: .search
            )
        )
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

    func testSearchPageUsesCompactHeaderForQueryResults() {
        let inactiveQueryMode = SearchPageLayout.headerMode(query: "hotel", isFieldFocused: false)
        let compactMode = SearchPageLayout.headerMode(query: "hotel", isFieldFocused: true)

        XCTAssertEqual(inactiveQueryMode, .compactResults)
        XCTAssertFalse(inactiveQueryMode.showsMasthead)

        XCTAssertEqual(compactMode, .compactResults)
        XCTAssertFalse(compactMode.showsMasthead)
        XCTAssertFalse(compactMode.showsSubtitle)
        XCTAssertEqual(
            compactMode.contentTopPadding(topMastheadBleed: 59),
            SearchPageLayout.focusedResultsTopPadding
        )
        XCTAssertLessThan(compactMode.titleSize, SearchPageHeaderMode.full.titleSize)
    }

    func testEmptyFocusedSearchKeepsFullDiscoveryHeader() {
        let mode = SearchPageLayout.headerMode(query: "", isFieldFocused: true)

        XCTAssertEqual(mode, .full)
        XCTAssertTrue(mode.showsMasthead)
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

    func testSavedDetourFromBrowseCollectionReturnsToCollection() {
        var navigation = AppShellNavigationState()

        navigation.openBrowse()
        navigation.openBrowseCollection(.category("airport"))
        navigation.openSaved()

        XCTAssertEqual(navigation.currentRoute, .saved)
        XCTAssertEqual(navigation.backPreviewRoute, .browseCollection(.category("airport")))

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .browseCollection(.category("airport")))
        XCTAssertEqual(navigation.browseCollectionPath, [.category("airport")])
        XCTAssertEqual(navigation.forwardStack, [.saved])

        navigation.goForward()
        XCTAssertEqual(navigation.currentRoute, .saved)

        navigation.goBack()
        XCTAssertEqual(navigation.currentRoute, .browseCollection(.category("airport")))
    }

    func testPracticeDetourFromBrowseCollectionReturnsToCollection() {
        var navigation = AppShellNavigationState()

        navigation.openBrowse()
        navigation.openBrowseCollection(.category("hotel"))
        navigation.openPractice()

        XCTAssertEqual(navigation.currentRoute, .practice)
        XCTAssertEqual(navigation.backPreviewRoute, .browseCollection(.category("hotel")))

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .browseCollection(.category("hotel")))
        XCTAssertEqual(navigation.browseCollectionPath, [.category("hotel")])
        XCTAssertEqual(navigation.forwardStack, [.practice])

        navigation.goForward()
        XCTAssertEqual(navigation.currentRoute, .practice)

        navigation.goBack()
        XCTAssertEqual(navigation.currentRoute, .browseCollection(.category("hotel")))
    }

    func testBackFromBrowseCollectionPreservesBrowseScrollPosition() {
        var navigation = AppShellNavigationState()

        navigation.openBrowse()
        let browseTopTriggerCount = navigation.browseScrollToTopTrigger

        navigation.openBrowseCollection(.category("first-day"))
        XCTAssertEqual(navigation.currentRoute, .browseCollection(.category("first-day")))

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .browse)
        XCTAssertEqual(navigation.browseScrollToTopTrigger, browseTopTriggerCount)
        XCTAssertEqual(navigation.forwardStack, [.browseCollection(.category("first-day"))])
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

    func testHomepageCityShortcutsExposeEveryCityGuide() {
        let homepageIDs = BrowseSearchDestinations.homepageCityShortcuts.map(\.id)
        let cityGuideIDs = BrowseSearchDestinations.cityShortcuts
            .map(\.id)
            .filter { $0 != "all-vietnam" }

        XCTAssertEqual(homepageIDs, ["danang", "hoian", "hcmc", "hanoi", "hue"])
        XCTAssertEqual(Set(homepageIDs), Set(cityGuideIDs))
    }

    func testBrowseCollectionDescriptorsExposeStarterRowsAndMessagePolicy() {
        let hotel = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("hotel")))
        let shopping = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("shopping")))
        let hanoi = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .city("hanoi")))

        XCTAssertEqual(hotel.route, .category("hotel"))
        XCTAssertEqual(hotel.title, "Hotel")
        XCTAssertFalse(hotel.subcategories.isEmpty)
        XCTAssertFalse(hotel.starterItems.isEmpty)
        XCTAssertEqual(hotel.messageSectionTitle, "Hotel")
        XCTAssertEqual(hotel.browseMessageSectionTitle, "Quick conversations")
        XCTAssertEqual(hotel.messageScenarioIDs, [.hotelCheckInHelp, .hotelRoomHelp, .hotelBagsTaxi, .hotelWifiCheckout])
        XCTAssertEqual(hotel.mastheadImageName, "HeroCategoryHotel")

        XCTAssertEqual(shopping.messageSectionTitle, "Shopping")
        XCTAssertEqual(shopping.browseMessageSectionTitle, "Quick conversations")
        XCTAssertEqual(shopping.messageScenarioIDs, [.shoppingMarketPrice, .shoppingSizeGift, .shoppingReceiptHelp, .shoppingPayCard])

        XCTAssertEqual(hanoi.route, .city("hanoi"))
        XCTAssertEqual(hanoi.practiceAction, .practiceMode(.hanoiBucketList))
        XCTAssertNil(hanoi.messageSectionTitle)
        XCTAssertNil(hanoi.browseMessageSectionTitle)
        XCTAssertFalse(hanoi.subcategories.isEmpty)
        XCTAssertFalse(hanoi.starterItems.isEmpty)
        XCTAssertNotNil(hanoi.cityHub)
        XCTAssertEqual(hanoi.cityHub?.situationTitle, "Common moments")
        XCTAssertEqual(hanoi.cityHub?.namesTitle, "Names to know")
    }

    func testBrowseCategoryMessageSectionsMirrorMessagesHubGroups() {
        let expectations: [(String, String, [PracticeScenarioID])] = [
            ("airport", "Airport", [.danangFirstDay, .airportPassportControl, .airportSimCash, .airportWifiPower]),
            ("hotel", "Hotel", [.hotelCheckInHelp, .hotelRoomHelp, .hotelBagsTaxi, .hotelWifiCheckout]),
            ("food", "Food", [.foodAllergyHelp, .restaurantOrderingPayment, .danangDay, .foodCoffeeOrder]),
            ("getting-around", "Getting Around", [.taxiGrabPickup, .taxiRouteHelp, .driverProblemHelp, .walkingDirectionsHelp]),
            ("shopping", "Shopping", [.shoppingMarketPrice, .shoppingSizeGift, .shoppingReceiptHelp, .shoppingPayCard]),
            ("emergency", "Emergency", [.pharmacyHelp, .emergencyLostPassport, .emergencyLostBag, .emergencyDoctorHelp]),
            ("local-greetings", "Local Greetings", [.localGreetingMarket, .localGreetingHotel, .localGreetingRespect, .localThanksSorry]),
        ]

        for (categoryID, sectionTitle, scenarioIDs) in expectations {
            let descriptor = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category(categoryID)))

            XCTAssertEqual(descriptor.messageSectionTitle, sectionTitle)
            XCTAssertEqual(descriptor.messageScenarioIDs, scenarioIDs)
            XCTAssertEqual(descriptor.messageScenarioIDs.map(\.messageSectionTitle), Array(repeating: sectionTitle, count: scenarioIDs.count))
        }
    }

    func testAirportCollectionSubcategoryFiltersExposeSimAndCashLanes() {
        let airport = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("airport")))

        XCTAssertEqual(
            airport.subcategories.map(\.title),
            ["Arrival", "Baggage", "Transport", "SIM card", "Cash"]
        )
        XCTAssertTrue(airport.subcategories.allSatisfy { !$0.items.isEmpty })
        XCTAssertTrue(airport.subcategories.allSatisfy { $0.phraseCount == $0.items.count })
        XCTAssertTrue(airport.exploreShelves.contains { $0.title == "Phone, Internet & Power" })
        XCTAssertTrue(airport.exploreShelves.contains { $0.title == "Payment & numbers" })

        let sim = try! XCTUnwrap(airport.subcategories.first { $0.title == "SIM card" })
        XCTAssertTrue(sim.items.contains { item in
            item.title.localizedCaseInsensitiveContains("SIM")
                || item.subtitle.localizedCaseInsensitiveContains("SIM")
        })
        XCTAssertFalse(sim.items.contains { $0.title.localizedCaseInsensitiveContains("ATM") })

        let cash = try! XCTUnwrap(airport.subcategories.first { $0.title == "Cash" })
        XCTAssertTrue(cash.items.contains { item in
            item.title.localizedCaseInsensitiveContains("ATM")
                || item.subtitle.localizedCaseInsensitiveContains("ATM")
                || item.title.localizedCaseInsensitiveContains("cash")
                || item.subtitle.localizedCaseInsensitiveContains("cash")
        })
    }

    func testClarificationCollectionUsesTravelerFacingFilterLabels() {
        let clarification = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("polite-repair")))

        XCTAssertEqual(clarification.title, "When You Don't Understand")
        XCTAssertEqual(
            clarification.subcategories.map(\.title),
            ["Clarify", "Polite basics", "Get help"]
        )
        XCTAssertTrue(clarification.subcategories.allSatisfy { !$0.items.isEmpty })
        XCTAssertFalse(clarification.subcategories.contains { subcategory in
            subcategory.title.localizedCaseInsensitiveContains("repair")
        })
    }

    func testQuestionAndMoneyCollectionsUseCompactTravelerFilters() {
        let questions = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("questions")))
        let numbersMoney = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("numbers-money")))
        let firstDay = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("first-day")))

        XCTAssertEqual(
            questions.subcategories.map(\.title),
            ["Directions", "Time", "Clarify"]
        )
        XCTAssertEqual(
            numbersMoney.subcategories.map(\.title),
            ["Payment", "Shopping"]
        )
        XCTAssertEqual(
            firstDay.subcategories.map(\.title),
            ["Airport", "Hotel", "Transport"]
        )

        let visibleLabels = questions.subcategories.map(\.title)
            + numbersMoney.subcategories.map(\.title)
            + firstDay.subcategories.map(\.title)
        XCTAssertFalse(visibleLabels.contains { $0.localizedCaseInsensitiveContains("repair") })
        XCTAssertTrue(visibleLabels.allSatisfy { $0.count <= 10 })
    }

    func testVisibleCategorySubcategoryFiltersArePopulated() {
        for route in BrowseSearchDestinations.visibleCategoryCollectionRoutes where route != .category("city-guides") {
            let descriptor = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: route))
            XCTAssertFalse(descriptor.subcategories.isEmpty, "\(route.id) should expose traveler filters")

            for subcategory in descriptor.subcategories {
                XCTAssertFalse(subcategory.items.isEmpty, "\(route.id) \(subcategory.title) filter should show phrase rows")
                XCTAssertGreaterThanOrEqual(
                    subcategory.phraseCount,
                    subcategory.items.count,
                    "\(route.id) \(subcategory.title) phrase count should cover the visible filter rows"
                )
            }
        }
    }

    func testDaNangCityDescriptorUsesTravelModeHubInsteadOfPhraseFeed() {
        let danang = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .city("danang")))
        let cityHub = try! XCTUnwrap(danang.cityHub)

        XCTAssertEqual(danang.title, "Da Nang")
        XCTAssertEqual(danang.subtitle, "Airport arrivals, beach rides, river landmarks, markets, and day trips.")
        XCTAssertEqual(danang.mastheadImageName, "HeroCityDanang")
        XCTAssertEqual(danang.starterTitle, "Names to know")
        XCTAssertEqual(danang.practiceTitle, "Da Nang day")
        XCTAssertEqual(danang.practiceSubtitle, "Airport pickup, beach drop-off, food, and a ride back.")
        XCTAssertFalse(danang.practiceSubtitle.localizedCaseInsensitiveContains("phrase loop"))

        XCTAssertEqual(
            cityHub.situations.map(\.title),
            ["Arriving", "Getting around", "Beach day", "Food & coffee", "Places to visit", "Help"]
        )
        XCTAssertTrue(cityHub.situations.allSatisfy { $0.targetRoute == nil })
        XCTAssertTrue(cityHub.situations.allSatisfy { !$0.items.isEmpty })
        XCTAssertEqual(cityHub.cityNameAudioItem?.title, "Đà Nẵng")
        XCTAssertEqual(cityHub.cityNameAudioItem?.subtitle, "Da Nang")
        XCTAssertNotNil(AudioAssetManifest.main?.url(for: cityHub.cityNameAudioItem?.audioKey))
        XCTAssertEqual(cityHub.situations.first(where: { $0.title == "Food & coffee" })?.subtitle, "Restaurants, cafés, markets")
        XCTAssertEqual(cityHub.situations.first(where: { $0.title == "Places to visit" })?.subtitle, "Dragon Bridge, Marble Mountains, Bà Nà Hills")
        XCTAssertTrue(cityHub.situations.first(where: { $0.title == "Arriving" })?.items.contains { $0.pageID == "viet-phrase-airport-3" } == true)
        XCTAssertTrue(cityHub.situations.first(where: { $0.title == "Getting around" })?.items.contains { $0.pageID == "viet-phrase-city-danang-place-nguyen-van-linh-street" } == true)
        XCTAssertTrue(cityHub.situations.first(where: { $0.title == "Beach day" })?.items.contains { $0.pageID == "viet-phrase-city-danang-place-my-khe" } == true)
        XCTAssertTrue(cityHub.situations.first(where: { $0.title == "Food & coffee" })?.items.contains { $0.pageID == "viet-phrase-city-danang-place-nen" } == true)
        XCTAssertTrue(cityHub.situations.first(where: { $0.title == "Places to visit" })?.items.contains { $0.pageID == "viet-phrase-city-danang-place-dragon-bridge" } == true)
        XCTAssertEqual(cityHub.namesToKnowItems.first?.pageID, "viet-phrase-city-danang-place-airport")
        XCTAssertTrue(cityHub.namesToKnowItems.contains { $0.pageID == "viet-phrase-city-danang-place-dragon-bridge" })
        XCTAssertTrue(cityHub.namesToKnowItems.contains { $0.pageID == "viet-phrase-city-danang-place-nguyen-van-linh-street" })
        XCTAssertFalse(cityHub.namesToKnowItems.contains { item in
            item.title.localizedCaseInsensitiveContains("Cảng Tiên Sa")
                || item.subtitle.localizedCaseInsensitiveContains("Tien Sa Port")
        })

        XCTAssertEqual(cityHub.quickPhrasesTitle, "Quick phrases")
        XCTAssertTrue(cityHub.quickPhraseItems.contains { $0.pageID == "viet-phrase-ves-call-taxi-for-me" })
        XCTAssertTrue(cityHub.quickPhraseItems.contains { item in
            item.title.localizedCaseInsensitiveContains("Nhà vệ sinh")
                || item.subtitle.localizedCaseInsensitiveContains("bathroom")
        })
        assertNoDerivedPlacePhraseRows(cityHub.quickPhraseItems, context: "Da Nang quick phrases")
        XCTAssertTrue(cityHub.browseGroups.contains { $0.title == "Landmarks" })
        XCTAssertTrue(cityHub.browseGroups.contains { $0.title == "Streets" })
        XCTAssertTrue(cityHub.browseGroups.allSatisfy { $0.targetRoute == nil })
    }

    func testCityHubAndSearchDoNotTreatDerivedPlacePhrasesAsBrowseInventory() {
        let danang = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .city("danang")))
        let cityHub = try! XCTUnwrap(danang.cityHub)

        let citySurfaceItems = cityHub.situations.flatMap(\.items)
            + cityHub.namesToKnowItems
            + cityHub.quickPhraseItems
            + cityHub.browseGroups.flatMap(\.items)
        assertNoDerivedPlacePhraseRows(citySurfaceItems, context: "Da Nang city surface")

        let entityOnlyResults = BrowseSearchDestinations.searchResults(for: "Dragon Bridge", limit: 10)
        XCTAssertEqual(entityOnlyResults.first?.pageID, "viet-phrase-city-danang-place-dragon-bridge")
        assertNoDerivedPlacePhraseRows(entityOnlyResults, context: "Dragon Bridge entity-only search")

        let actionResults = BrowseSearchDestinations.searchResults(for: "where is Dragon Bridge", limit: 10)
        XCTAssertTrue(
            actionResults.contains { $0.pageID == "viet-phrase-city-danang-where-dragon-bridge" },
            actionResults.map(\.pageID).joined(separator: "\n")
        )
    }

    func testEntityDetailPagesHideGeneratedPlaceTemplateRows() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()

        let baNa = try repository.loadPhraseDetailPage(pageID: "viet-phrase-city-danang-place-ba-na-hills")
        let baNaRows = baNa.sections.flatMap(\.phrases)
        XCTAssertTrue(baNaRows.contains { $0.detailPageID == "viet-phrase-ves-take-me-to-ba-na-hills" })
        assertNoDerivedPlacePhraseRows(baNaRows.map { phrase in
            BrowseSearchPhraseItem(
                pageID: phrase.detailPageID ?? phrase.id,
                title: phrase.vietnamese,
                subtitle: phrase.english,
                symbolName: phrase.symbolName,
                tintName: phrase.tintName,
                audioKey: phrase.audioKey
            )
        }, context: "Ba Na Hills detail")
        XCTAssertFalse(baNaRows.contains { $0.english.localizedCaseInsensitiveContains("ATM near Ba Na Hills") })
        XCTAssertFalse(baNaRows.contains { $0.english.localizedCaseInsensitiveContains("Eat near Ba Na Hills") })

        let dragonBridge = try repository.loadPhraseDetailPage(pageID: "viet-phrase-city-danang-place-dragon-bridge")
        let dragonRows = dragonBridge.sections.flatMap(\.phrases)
        XCTAssertTrue(dragonRows.contains { $0.detailPageID == "viet-phrase-ves-drop-near-dragon-bridge" })
        XCTAssertFalse(dragonRows.contains { $0.detailPageID == "viet-phrase-city-danang-go-dragon-bridge" })
        XCTAssertFalse(dragonRows.contains { $0.detailPageID == "viet-phrase-city-danang-where-dragon-bridge" })
    }

    func testCityBrowseGroupsAreEntityFirstAcrossCities() {
        let cityIDs = ["hanoi", "hcmc", "danang", "hoian", "hue"]
        let disallowedBrowseGroupTitles = ["Getting around", "Help"]

        for cityID in cityIDs {
            let descriptor = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .city(cityID)))
            let cityHub = try! XCTUnwrap(descriptor.cityHub)
            let groupTitles = cityHub.browseGroups.map(\.title)

            XCTAssertGreaterThanOrEqual(cityHub.browseGroups.count, 6, "\(descriptor.title) should expose an even noun-first Browse grid")
            XCTAssertTrue(groupTitles.contains("Landmarks"), "\(descriptor.title) should expose landmark nouns")
            XCTAssertTrue(groupTitles.contains("Streets"), "\(descriptor.title) should expose street-name nouns")
            XCTAssertTrue(groupTitles.contains("Food & coffee"), "\(descriptor.title) should expose restaurant/cafe/dish nouns")
            XCTAssertTrue(groupTitles.contains("Markets"), "\(descriptor.title) should expose market nouns")

            for disallowedTitle in disallowedBrowseGroupTitles {
                XCTAssertFalse(groupTitles.contains(disallowedTitle), "\(descriptor.title) Browse groups should be entities, not broad action lanes")
            }

            for group in cityHub.browseGroups {
                XCTAssertFalse(group.items.isEmpty, "\(descriptor.title) \(group.title) should drill into entity rows")
                XCTAssertTrue(group.items.allSatisfy { $0.pageID.contains("-place-") }, "\(descriptor.title) \(group.title) should start with noun/entity pages: \(group.items.map(\.pageID))")
                XCTAssertTrue(group.items.allSatisfy { $0.audioKey != nil }, "\(descriptor.title) \(group.title) noun rows should have playable audio keys")
                XCTAssertFalse(group.items.contains { item in
                    item.title.localizedCaseInsensitiveContains("ở đâu")
                        || item.subtitle.localizedCaseInsensitiveContains("where is")
                        || item.subtitle.localizedCaseInsensitiveContains("go to")
                        || item.subtitle.localizedCaseInsensitiveContains("near here")
                }, "\(descriptor.title) \(group.title) should not start with long-tail question/route phrase rows")
            }
        }
    }

    func testGenericFoodCollectionSurfacesCoffeeWithoutLosingEntityRows() {
        let food = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("food")))

        XCTAssertEqual(food.title, "Food & coffee")
        XCTAssertEqual(food.starterTitle, "Places, dishes, and coffee")
        XCTAssertEqual(
            food.subcategories.map(\.title),
            ["Restaurants", "Coffee shops", "Coffee & drinks", "Dishes to order", "Markets"]
        )
        XCTAssertTrue(food.starterItems.contains { $0.pageID == "viet-phrase-city-danang-place-nen" })
        XCTAssertTrue(food.starterItems.contains { $0.pageID == "viet-phrase-city-hanoi-place-giang-cafe" })
        XCTAssertTrue(food.starterItems.contains { $0.pageID == "viet-phrase-city-hue-place-bun-bo-city" })
        assertEntityFirstBrowseRows(food.starterItems, context: "food starter")

        for subcategory in food.subcategories {
            XCTAssertFalse(subcategory.items.isEmpty, "Food \(subcategory.title) should drill into entity rows")
            if subcategory.title == "Coffee & drinks" {
                XCTAssertEqual(subcategory.countUnit, "phrase")
                XCTAssertTrue(subcategory.items.contains { $0.pageID == "viet-phrase-coffee-1" })
                XCTAssertTrue(subcategory.items.contains { item in
                    item.title.localizedCaseInsensitiveContains("coffee")
                        || item.subtitle.localizedCaseInsensitiveContains("coffee")
                        || item.pageID.localizedCaseInsensitiveContains("coffee")
                })
            } else if subcategory.title == "Dishes to order" {
                XCTAssertEqual(subcategory.countUnit, "phrase")
                XCTAssertGreaterThanOrEqual(subcategory.items.count, 10)
                XCTAssertTrue(subcategory.items.contains { $0.pageID == "viet-phrase-ves-order-pho-bowl" })
                XCTAssertTrue(subcategory.items.contains { $0.pageID == "viet-phrase-vpe-one-item-please-cho-toi-mot-banh-xeo" })
            } else {
                assertEntityFirstBrowseRows(subcategory.items, context: "food \(subcategory.title)")
            }
        }
    }

    func testGenericLandmarkAndStreetCollectionsStartWithEntitiesBeforePhraseDepth() {
        let landmarks = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("landmarks-attractions")))
        let streets = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("neighborhoods-streets")))

        XCTAssertEqual(landmarks.starterTitle, "Places to know")
        XCTAssertTrue(landmarks.subcategories.map(\.title).contains("Landmarks"))
        XCTAssertTrue(landmarks.subcategories.map(\.title).contains("Markets"))
        XCTAssertTrue(landmarks.starterItems.contains { $0.pageID == "viet-phrase-city-danang-place-dragon-bridge" })
        XCTAssertTrue(landmarks.starterItems.contains { $0.pageID == "viet-phrase-city-hanoi-place-hoan-kiem" })
        assertEntityFirstBrowseRows(landmarks.starterItems, context: "landmarks starter")

        XCTAssertEqual(streets.starterTitle, "Names to know")
        XCTAssertEqual(streets.subcategories.map(\.title), ["Neighborhoods", "Streets"])
        XCTAssertTrue(streets.starterItems.contains { $0.pageID == "viet-phrase-city-danang-place-bach-dang-street" })
        assertEntityFirstBrowseRows(streets.starterItems, context: "streets starter")

        for subcategory in landmarks.subcategories + streets.subcategories {
            XCTAssertFalse(subcategory.items.isEmpty, "\(subcategory.title) should drill into entity rows")
            assertEntityFirstBrowseRows(subcategory.items, context: subcategory.title)
        }
    }

    private func assertEntityFirstBrowseRows(_ items: [BrowseSearchPhraseItem], context: String) {
        XCTAssertFalse(items.isEmpty, "\(context) should not be empty")
        XCTAssertTrue(
            items.allSatisfy { $0.pageID.contains("-place-") },
            "\(context) should show noun/entity pages before phrase depth: \(items.map(\.pageID))"
        )
        XCTAssertFalse(items.contains { item in
            item.title.localizedCaseInsensitiveContains("ở đâu")
                || item.title.localizedCaseInsensitiveContains("Cho tôi")
                || item.title.hasPrefix("Đi ")
                || item.subtitle.localizedCaseInsensitiveContains("where is")
                || item.subtitle.localizedCaseInsensitiveContains("please take")
                || item.subtitle.localizedCaseInsensitiveContains("near ")
                || item.subtitle.localizedCaseInsensitiveContains("please")
        }, "\(context) should not start with long-tail action phrase rows: \(items.map { "\($0.title) — \($0.subtitle)" })")
    }

    private func assertNoDerivedPlacePhraseRows(_ items: [BrowseSearchPhraseItem], context: String) {
        let derivedItems = items.filter { item in
            PhraseCatalog.categoryIDs(forPageID: item.pageID).contains("derived-place-phrases")
        }

        XCTAssertTrue(
            derivedItems.isEmpty,
            "\(context) should not surface generated place-template rows: \(derivedItems.map(\.pageID).joined(separator: "\n"))"
        )
    }

    func testBrowseCollectionMastheadsUseOwnedHeroArtForVisibleHubs() {
        let hanoi = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .city("hanoi")))
        let saigon = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .city("hcmc")))
        let danang = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .city("danang")))
        let hoian = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .city("hoian")))
        let hue = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .city("hue")))
        let airport = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("airport")))
        let hotel = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("hotel")))
        let food = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("food")))
        let greetings = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("greetings")))
        let questions = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("questions")))
        let numbersMoney = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("numbers-money")))
        let clarification = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("polite-repair")))
        let emergency = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("emergency")))

        XCTAssertEqual(hanoi.title, "Hanoi")
        XCTAssertEqual(hanoi.mastheadImageName, "HeroCityHanoi")
        XCTAssertEqual(saigon.title, "Saigon")
        XCTAssertEqual(saigon.mastheadImageName, "HeroCityHcmc")
        XCTAssertEqual(danang.title, "Da Nang")
        XCTAssertEqual(danang.mastheadImageName, "HeroCityDanang")
        XCTAssertEqual(hoian.title, "Hoi An")
        XCTAssertEqual(hoian.mastheadImageName, "HeroCityHoian")
        XCTAssertEqual(hue.title, "Hue")
        XCTAssertEqual(hue.mastheadImageName, "HeroCityHue")
        XCTAssertEqual(airport.mastheadImageName, "HeroCategoryAirport")
        XCTAssertEqual(hotel.mastheadImageName, "HeroCategoryHotel")
        XCTAssertEqual(food.mastheadImageName, "HeroCategoryFood")
        XCTAssertEqual(greetings.mastheadImageName, "HeroCategoryGreetings")
        XCTAssertEqual(questions.mastheadImageName, "HeroCategoryQuestions")
        XCTAssertEqual(numbersMoney.mastheadImageName, "HeroCategoryNumbersMoney")
        XCTAssertEqual(clarification.title, "When You Don't Understand")
        XCTAssertEqual(clarification.mastheadImageName, "HeroCategoryPoliteRepair")
        XCTAssertEqual(emergency.mastheadImageName, "HeroCategoryEmergency")
        XCTAssertFalse([hanoi, saigon, danang, hoian, hue, airport, hotel, food, greetings, questions, numbersMoney, clarification, emergency].contains { descriptor in
            descriptor.mastheadImageName == "HeroVietnamMasthead"
                || descriptor.mastheadImageName == "HeroNeutralMasthead"
                || descriptor.mastheadImageName.hasPrefix("BrowseCollection")
        })
    }

    func testAllVietnamDescriptorUsesCountryHubInsteadOfPhraseFeed() {
        let vietnam = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("city-guides")))
        let countryHub = try! XCTUnwrap(vietnam.cityHub)

        XCTAssertEqual(vietnam.title, "All Vietnam")
        XCTAssertEqual(vietnam.subtitle, "Everyday phrases for cities, food, transport, hotels, and help.")
        XCTAssertEqual(vietnam.mastheadImageName, "HeroCountryVietnam")
        XCTAssertEqual(vietnam.practiceTitle, "Vietnam basics")
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

    func testSearchCollectionMatchesUseIntentExpansions() {
        let lostPassportRoutes = BrowseSearchDestinations.matchingCollections(for: "I lost my passport").map(\.route)
        let noPeanutsRoutes = BrowseSearchDestinations.matchingCollections(for: "no peanuts").map(\.route)
        let rideProblemRoutes = BrowseSearchDestinations.matchingCollections(for: "driver can't find me").map(\.route)
        let hotelBookingRoutes = BrowseSearchDestinations.matchingCollections(for: "hotel reservation").map(\.route)

        XCTAssertTrue(lostPassportRoutes.contains(.category("emergency")), "\(lostPassportRoutes)")
        XCTAssertTrue(noPeanutsRoutes.contains(.category("food")), "\(noPeanutsRoutes)")
        XCTAssertTrue(rideProblemRoutes.contains(.category("getting-around")), "\(rideProblemRoutes)")
        XCTAssertTrue(hotelBookingRoutes.contains(.category("hotel")), "\(hotelBookingRoutes)")
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
