import XCTest
import CoreGraphics
import SwiftUI
import UIKit
@testable import SpeakLocalNative

final class AppChromeTests: XCTestCase {
    func testSystemTabsMapRoutesToAppleTabBarDestinations() {
        XCTAssertEqual(AppSystemTab(route: .home), .home)
        XCTAssertEqual(AppSystemTab(route: .browse), .browse)
        XCTAssertEqual(AppSystemTab(route: .browseCollection(.category("hotel"))), .browse)
        XCTAssertEqual(AppSystemTab(route: .phrasePage), .browse)
        XCTAssertEqual(AppSystemTab(route: .detailPage("viet-phrase-hello-chao-anh")), .browse)
        XCTAssertEqual(AppSystemTab(route: .saved), .saved)
        XCTAssertEqual(AppSystemTab(route: .practice), .practice)
        XCTAssertEqual(AppSystemTab(route: .search), .search)
    }

    func testPrimarySystemTabsUseStableAppleSFSymbolsAndLabels() {
        XCTAssertEqual(DockItemKind.home.symbolName, "house.fill")
        XCTAssertEqual(DockItemKind.home.title, "Home")
        XCTAssertEqual(DockItemKind.browse.symbolName, "square.grid.2x2")
        XCTAssertEqual(DockItemKind.browse.title, "Browse")
        XCTAssertEqual(DockItemKind.saved.symbolName, "heart")
        XCTAssertEqual(DockItemKind.saved.title, "Saved")
        XCTAssertEqual(DockItemKind.practice.symbolName, "square.grid.2x2.fill")
        XCTAssertEqual(DockItemKind.practice.title, "Practice")
    }

    func testPlayableAudioTintsUseOneConsistentActionColor() {
        let expected = rgbaComponents(for: AccentTint.red.audioColor)

        for tint in [AccentTint.orange, .green, .blue, .purple, .teal] {
            let actual = rgbaComponents(for: tint.audioColor)
            XCTAssertEqual(actual.red, expected.red, accuracy: 0.001, "\(tint) red")
            XCTAssertEqual(actual.green, expected.green, accuracy: 0.001, "\(tint) green")
            XCTAssertEqual(actual.blue, expected.blue, accuracy: 0.001, "\(tint) blue")
            XCTAssertEqual(actual.alpha, expected.alpha, accuracy: 0.001, "\(tint) alpha")
        }
    }

    func testOnlyTopAdminAndAppSpecificChromeStayLayeredAboveContent() {
        XCTAssertLessThanOrEqual(AppChromeLayout.topSeparationHeight, 120)
        XCTAssertLessThan(
            AppChromeLayout.topSeparationHeight,
            AppChromeLayout.pinnedAudioSpeedRevealY + AppChromeLayout.topAdminControlSize
        )
        XCTAssertFalse(AppChromeLayout.chromeSeparationAllowsHitTesting)
        XCTAssertGreaterThan(AppChromeLayout.searchPageLayerZIndex, AppChromeLayout.contentPageLayerZIndex)
        XCTAssertGreaterThan(AppChromeLayout.chromeSeparationLayerZIndex, AppChromeLayout.searchPageLayerZIndex)
        XCTAssertGreaterThan(AppChromeLayout.menuSectionBackdropLayerZIndex, AppChromeLayout.chromeSeparationLayerZIndex)
        XCTAssertLessThan(AppChromeLayout.menuSectionBackdropLayerZIndex, AppChromeLayout.topAdminHitTestLayerZIndex)
        XCTAssertGreaterThan(AppChromeLayout.topAdminHitTestLayerZIndex, AppChromeLayout.chromeSeparationLayerZIndex)
        XCTAssertGreaterThan(AppChromeLayout.topAdminControlLayerZIndex, AppChromeLayout.topAdminHitTestLayerZIndex)
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
        XCTAssertLessThanOrEqual(AppChromeLayout.topAdminControlSize, 48)
        XCTAssertEqual(AppChromeLayout.topAdminControlCornerRadius, AppChromeLayout.topAdminControlSize / 2)
        XCTAssertEqual(AudioSpeedControlMetrics.topAdmin.controlHeight, AppChromeLayout.topAdminControlSize)
        XCTAssertLessThan(AudioSpeedControlMetrics.topAdmin.controlHeight, AudioSpeedControlMetrics.regular.controlHeight)
        XCTAssertGreaterThanOrEqual(
            AppChromeLayout.topAdminHitTestEnvelopeHeight,
            AppChromeLayout.topAdminTopPadding + AppChromeLayout.topAdminControlSize
        )
    }

    func testMenuSectionChromeFitsBelowTopAdminRow() {
        let stackedChromeHeight = AppChromeLayout.topAdminTopPadding
            + AppChromeLayout.topAdminControlSize
            + AppChromeLayout.menuSectionChromeRowSpacing
            + AppChromeLayout.menuSectionChromeHeight

        XCTAssertLessThanOrEqual(stackedChromeHeight, AppChromeLayout.topAdminHitTestEnvelopeHeight)
        XCTAssertLessThanOrEqual(stackedChromeHeight, AppChromeLayout.topSeparationHeight)
        XCTAssertGreaterThan(AppChromeLayout.menuSectionJumpClearance, stackedChromeHeight)
    }

    func testMenuSectionBackdropFadeStartsAtSectionRowAndExtendsBehindContent() {
        let sectionRowY = AppChromeLayout.topAdminTopPadding
            + AppChromeLayout.topAdminControlSize
            + AppChromeLayout.menuSectionChromeRowSpacing
        let sectionRowBottomY = sectionRowY + AppChromeLayout.menuSectionChromeHeight

        XCTAssertEqual(AppChromeLayout.menuSectionBackdropTopOffset, sectionRowY)
        XCTAssertGreaterThan(AppChromeLayout.menuSectionBackdropHeight, AppChromeLayout.menuSectionChromeHeight)
        XCTAssertGreaterThan(
            AppChromeLayout.menuSectionBackdropTopOffset + AppChromeLayout.menuSectionBackdropHeight,
            sectionRowBottomY + 32
        )
        XCTAssertFalse(AppChromeLayout.menuSectionBackdropAllowsHitTesting)
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

    func testHomeCityRailUsesCompactStableImageMetrics() {
        XCTAssertEqual(HomeLayout.cityCardWidth, 118)
        XCTAssertEqual(HomeLayout.cityCardHeight, 178)
        XCTAssertEqual(HomeLayout.cityImageHeight, 122)
        XCTAssertLessThan(HomeLayout.cityImageHeight, HomeLayout.cityCardHeight)
    }

    func testHomeMessageRailUsesStableCircleContactMetrics() {
        XCTAssertEqual(HomeLayout.messageAvatarSize, 82)
        XCTAssertEqual(HomeLayout.messageContactWidth, 104)
        XCTAssertGreaterThan(HomeLayout.messageContactWidth, HomeLayout.messageAvatarSize)
        XCTAssertGreaterThanOrEqual(HomeLayout.messageRailHeight, HomeLayout.messageAvatarSize + 44)
    }

    func testBrowseMessageRailUsesScreenEdgeViewport() {
        let viewportWidth: CGFloat = 390
        let contentColumnWidth = viewportWidth - (BrowseCollectionMessageLayout.rowViewportHorizontalBleed * 2)

        XCTAssertEqual(BrowseCollectionMessageLayout.avatarSize, 88)
        XCTAssertEqual(BrowseCollectionMessageLayout.contactWidth, 104)
        XCTAssertEqual(BrowseCollectionMessageLayout.rowViewportHorizontalBleed, 20)
        XCTAssertEqual(BrowseCollectionMessageLayout.rowContentHorizontalInset, 21)
        XCTAssertEqual(BrowseCollectionMessageLayout.rowViewportWidth(contentColumnWidth: contentColumnWidth), viewportWidth)
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

    func testHomePhraseShelvesDoNotRepeatVisibleEnglishSubtitles() throws {
        for shelf in HomePageLinkRegistry.homepagePhraseShelfSnapshots {
            var pageIDByNormalizedSubtitle: [String: String] = [:]

            for item in shelf.items {
                let normalizedSubtitle = item.subtitle
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .lowercased()

                if let existingPageID = pageIDByNormalizedSubtitle[normalizedSubtitle] {
                    XCTFail(
                        "\(shelf.id) repeats visible English subtitle '\(item.subtitle)' for \(existingPageID) and \(item.pageID)"
                    )
                } else {
                    pageIDByNormalizedSubtitle[normalizedSubtitle] = item.pageID
                }
            }
        }
    }

    func testHomeMoneyShoppingShelfShowsOneHowMuchCard() throws {
        let shelf = try XCTUnwrap(
            HomePageLinkRegistry.homepagePhraseShelfSnapshots.first { $0.id == "money-shopping" }
        )
        let pageIDs = shelf.items.map(\.pageID)
        let howMuchItems = shelf.items.filter { $0.subtitle == "How much is this?" }

        XCTAssertEqual(pageIDs.first, "viet-phrase-price-1")
        XCTAssertTrue(pageIDs.contains("viet-phrase-v500-shop-can-you-lower-the-price"))
        XCTAssertFalse(pageIDs.contains("viet-phrase-money-how-much-common"))
        XCTAssertEqual(howMuchItems.map(\.pageID), ["viet-phrase-price-1"])
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

    func testBrowseSituationCardsReserveReadableTextWidth() {
        XCTAssertEqual(BrowsePageLayout.situationIconSize, 48)
        XCTAssertGreaterThanOrEqual(BrowsePageLayout.situationCardMinHeight, 132)
        XCTAssertGreaterThanOrEqual(
            BrowsePageLayout.situationCardTitleContentWidth(cardWidth: 176),
            124
        )
    }

    func testBrowseCityHeroImageFadeIsStrongEnoughToHideImagePanelSeam() {
        XCTAssertGreaterThanOrEqual(BrowsePageLayout.cityHeroImageFadeHeight, 132)
    }

    func testBrowseCityRoutesUseShortNativeDissolveTransition() {
        XCTAssertTrue(BrowseCollectionNativeTransition.usesCityDissolve(for: .city("danang")))
        XCTAssertFalse(BrowseCollectionNativeTransition.usesCityDissolve(for: .category("airport")))
        XCTAssertLessThanOrEqual(BrowseCollectionNativeTransition.cityDissolveDuration, 0.24)
    }

    func testBrowseCityHeroCardKeepsImageAndCopyAreasStable() {
        XCTAssertEqual(
            BrowsePageLayout.cityHeroImageHeight + BrowsePageLayout.cityHeroCopyAreaHeight,
            BrowsePageLayout.cityHeroCardHeight
        )
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

    func testPinnedAudioSpeedChromeCanAppearOnHomeWithoutBackButton() {
        XCTAssertTrue(
            PinnedAudioSpeedChromePolicy.canShowPinnedControl(
                on: .home,
                hasStaticBackButton: false,
                isSearchPresented: false
            )
        )
        XCTAssertFalse(
            PinnedAudioSpeedChromePolicy.canShowPinnedControl(
                on: .browse,
                hasStaticBackButton: false,
                isSearchPresented: false
            )
        )
        XCTAssertFalse(
            PinnedAudioSpeedChromePolicy.canShowPinnedControl(
                on: .home,
                hasStaticBackButton: false,
                isSearchPresented: true
            )
        )
    }

    func testPinnedAudioSpeedChromeStateUsesHomePlayerAnchor() {
        let visibleHomePlayer = PhraseAudioPlayerAnchor(
            route: .home,
            frame: CGRect(x: 24, y: 210, width: 344, height: 108)
        )
        let offscreenHomePlayer = PhraseAudioPlayerAnchor(
            route: .home,
            frame: CGRect(x: 24, y: -118, width: 344, height: 108)
        )

        XCTAssertEqual(
            PinnedAudioSpeedChromePolicy.state(for: [visibleHomePlayer], currentRoute: .home),
            .hidden
        )
        XCTAssertEqual(
            PinnedAudioSpeedChromePolicy.state(for: [offscreenHomePlayer], currentRoute: .home),
            PinnedAudioSpeedChromeState(route: .home, isVisible: true)
        )
    }

    func testPinnedAudioSpeedChromeAppearsWithVietnameseMenuSectionChrome() {
        for kind in [VietnameseMenuKind.food, .drink] {
            let route = AppRoute.browseCollection(.category(kind.routeID))

            XCTAssertTrue(
                PinnedAudioSpeedChromePolicy.shouldShowPinnedControl(
                    chromeState: .hidden,
                    currentRoute: route,
                    hasStaticBackButton: true,
                    isSearchPresented: false,
                    isMenuSectionChromeVisible: true
                ),
                "\(kind.routeID) should show speed control above the pinned section menu"
            )
            XCTAssertFalse(
                PinnedAudioSpeedChromePolicy.shouldShowPinnedControl(
                    chromeState: .hidden,
                    currentRoute: route,
                    hasStaticBackButton: true,
                    isSearchPresented: false,
                    isMenuSectionChromeVisible: false
                ),
                "\(kind.routeID) should wait until the section menu is pinned"
            )
            XCTAssertFalse(
                PinnedAudioSpeedChromePolicy.shouldShowPinnedControl(
                    chromeState: .hidden,
                    currentRoute: route,
                    hasStaticBackButton: true,
                    isSearchPresented: true,
                    isMenuSectionChromeVisible: true
                ),
                "\(kind.routeID) should not show speed control while search is presented"
            )
        }
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

    func testSavedLaunchArgumentOpensSavedPage() {
        XCTAssertEqual(
            AppShellView.initialRoute(for: ["SpeakLocalNative", "--saved"]),
            .saved
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

    func testDetailLaunchArgumentOpensVietnameseMenuItems() {
        XCTAssertEqual(
            AppShellView.initialRoute(for: ["SpeakLocalNative", "--detail-page", "viet-menu-food-pho-bo"]),
            .detailPage("viet-menu-food-pho-bo")
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

    func testSearchPageResultsUseSystemTabBarScaleBottomClearance() {
        XCTAssertGreaterThanOrEqual(SearchPageLayout.resultsBottomClearance, 40)
        XCTAssertLessThanOrEqual(SearchPageLayout.resultsBottomClearance, 64)
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
        XCTAssertTrue(navigation.showsStaticBackButton)

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .home)
        XCTAssertEqual(navigation.forwardStack, [.browse])
        XCTAssertFalse(navigation.showsStaticBackButton)

        navigation.goForward()

        XCTAssertEqual(navigation.currentRoute, .browse)
        XCTAssertEqual(navigation.browseScrollToTopTrigger, 2)
        XCTAssertTrue(navigation.forwardStack.isEmpty)
        XCTAssertTrue(navigation.showsStaticBackButton)
    }

    func testHomeCollectionBackChainReturnsToHomeInsteadOfBrowse() {
        var navigation = AppShellNavigationState()

        navigation.openHomeBrowseCollection(.city("danang"))

        XCTAssertEqual(navigation.currentRoute, .browseCollection(.city("danang")))
        XCTAssertEqual(navigation.backPreviewRoute, .home)
        XCTAssertTrue(navigation.showsStaticBackButton)

        navigation.openDetail("viet-phrase-city-danang-place-dragon-bridge")
        XCTAssertEqual(navigation.backPreviewRoute, .browseCollection(.city("danang")))
        XCTAssertTrue(navigation.showsStaticBackButton)

        navigation.goBack()
        XCTAssertEqual(navigation.currentRoute, .browseCollection(.city("danang")))
        XCTAssertEqual(navigation.backPreviewRoute, .home)
        XCTAssertTrue(navigation.showsStaticBackButton)

        navigation.goBack()
        XCTAssertEqual(navigation.currentRoute, .home)
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-phrase-city-danang-place-dragon-bridge"), .browseCollection(.city("danang"))])
        XCTAssertFalse(navigation.showsStaticBackButton)
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

    func testBackFromSearchPhraseResultRestoresSearchPage() {
        var navigation = AppShellNavigationState()

        navigation.openSearch()
        navigation.openDetail("viet-phrase-hello-chao-anh")

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-hello-chao-anh"))
        XCTAssertEqual(navigation.backPreviewRoute, .search)

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .search)
        XCTAssertTrue(navigation.isSearchPresented)
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-phrase-hello-chao-anh")])
    }

    func testBackFromSearchCollectionResultRestoresSearchPage() {
        var navigation = AppShellNavigationState()

        navigation.openSearch()
        navigation.openBrowseCollectionFromSearch(.category("hotel"))

        XCTAssertEqual(navigation.currentRoute, .browseCollection(.category("hotel")))
        XCTAssertEqual(navigation.backPreviewRoute, .search)

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .search)
        XCTAssertTrue(navigation.isSearchPresented)
        XCTAssertEqual(navigation.forwardStack, [.browseCollection(.category("hotel"))])
    }

    func testDuplicateCurrentDetailDoesNotRequestTopScroll() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-phrase-hello-chao-anh"))

        navigation.openDetail("viet-phrase-hello-chao-anh")

        XCTAssertEqual(navigation.detailPath, ["viet-phrase-hello-chao-anh"])
        XCTAssertEqual(navigation.detailScrollToTopTrigger, 0)
    }

    func testOpeningCurrentDetailFromSearchClosesSearch() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-phrase-hello-chao-anh"))

        navigation.openSearch()
        navigation.openDetail("viet-phrase-hello-chao-anh")

        XCTAssertFalse(navigation.isSearchPresented)
        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-hello-chao-anh"))
        XCTAssertEqual(navigation.detailPath, ["viet-phrase-hello-chao-anh"])
        XCTAssertTrue(navigation.forwardStack.isEmpty)
        XCTAssertEqual(navigation.detailScrollToTopRoute, .detailPage("viet-phrase-hello-chao-anh"))
        XCTAssertEqual(navigation.detailScrollToTopTrigger, 1)
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

    func testOpeningDetailFromSearchCanBackReturnToSearch() {
        var navigation = AppShellNavigationState()

        navigation.openSearch()
        navigation.openDetail("viet-family-repair-meaning")

        XCTAssertFalse(navigation.isSearchPresented)
        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-repair-3"))
        XCTAssertEqual(navigation.backPreviewRoute, .search)
        XCTAssertEqual(navigation.detailPath, ["viet-phrase-repair-3"])
        XCTAssertTrue(navigation.forwardStack.isEmpty)
        XCTAssertEqual(navigation.detailScrollToTopTrigger, 1)

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .search)
        XCTAssertTrue(navigation.isSearchPresented)
        XCTAssertEqual(navigation.forwardStack, [.detailPage("viet-phrase-repair-3")])

        navigation.goForward()

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-repair-3"))
        XCTAssertTrue(navigation.forwardStack.isEmpty)
    }

    func testOpeningBrowseCollectionFromSearchCanBackReturnToSearchThenBrowse() {
        var navigation = AppShellNavigationState()

        navigation.openBrowse()
        navigation.openSearch()
        navigation.openBrowseCollectionFromSearch(.category("hotel"))

        XCTAssertFalse(navigation.isSearchPresented)
        XCTAssertEqual(navigation.currentRoute, .browseCollection(.category("hotel")))
        XCTAssertEqual(navigation.backPreviewRoute, .search)
        XCTAssertEqual(navigation.browseCollectionPath, [.category("hotel")])
        XCTAssertTrue(navigation.forwardStack.isEmpty)

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .search)
        XCTAssertTrue(navigation.isSearchPresented)
        XCTAssertEqual(navigation.forwardStack, [.browseCollection(.category("hotel"))])

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .browse)
        XCTAssertEqual(navigation.forwardStack, [.browseCollection(.category("hotel")), .search])

        navigation.goForward()

        XCTAssertEqual(navigation.currentRoute, .search)
        XCTAssertEqual(navigation.forwardStack, [.browseCollection(.category("hotel"))])
    }

    func testOpeningHomeCollectionFromSearchCanBackReturnToSearchThenHomeRoute() {
        var navigation = AppShellNavigationState()

        navigation.openHomeBrowseCollection(.city("danang"))
        navigation.openSearch()
        navigation.openBrowseCollectionFromSearch(.category("hotel"))

        XCTAssertFalse(navigation.isSearchPresented)
        XCTAssertEqual(navigation.currentRoute, .browseCollection(.category("hotel")))
        XCTAssertEqual(navigation.backPreviewRoute, .search)
        XCTAssertEqual(navigation.browseCollectionPath, [.city("danang"), .category("hotel")])
        XCTAssertTrue(navigation.forwardStack.isEmpty)

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .search)
        XCTAssertTrue(navigation.isSearchPresented)
        XCTAssertEqual(navigation.forwardStack, [.browseCollection(.category("hotel"))])

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .browseCollection(.city("danang")))
        XCTAssertEqual(navigation.forwardStack, [.browseCollection(.category("hotel")), .search])

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .home)
        XCTAssertEqual(navigation.forwardStack, [
            .browseCollection(.category("hotel")),
            .search,
            .browseCollection(.city("danang")),
        ])
    }

    func testOpeningCollectionFromDetailSearchCanBackReturnToSearchThenDetail() {
        var navigation = AppShellNavigationState(initialRoute: .detailPage("viet-phrase-hello-chao-anh"))

        navigation.openSearch()
        navigation.openBrowseCollectionFromSearch(.category("hotel"))

        XCTAssertFalse(navigation.isSearchPresented)
        XCTAssertEqual(navigation.currentRoute, .browseCollection(.category("hotel")))
        XCTAssertEqual(navigation.detailPath, [])
        XCTAssertEqual(navigation.backPreviewRoute, .search)
        XCTAssertTrue(navigation.forwardStack.isEmpty)

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .search)
        XCTAssertTrue(navigation.isSearchPresented)
        XCTAssertEqual(navigation.forwardStack, [.browseCollection(.category("hotel"))])

        navigation.goBack()

        XCTAssertEqual(navigation.currentRoute, .detailPage("viet-phrase-hello-chao-anh"))
        XCTAssertEqual(navigation.detailPath, ["viet-phrase-hello-chao-anh"])
        XCTAssertEqual(navigation.forwardStack, [.browseCollection(.category("hotel")), .search])
    }

    func testBrowseSearchDestinationsResolveToCanonicalPages() {
        guard let hotel = BrowseSearchDestinations.situations.first(where: { $0.id == "hotel" }) else {
            XCTFail("Expected hotel Browse destination")
            return
        }

        XCTAssertNotNil(hotel.openablePageID)
        XCTAssertTrue(BrowseSearchDestinations.situations.allSatisfy { $0.openablePageID != nil })
        XCTAssertFalse(BrowseSearchDestinations.situations.contains { $0.id == VietnameseMenuKind.food.routeID })
        XCTAssertFalse(BrowseSearchDestinations.situations.contains { $0.id == VietnameseMenuKind.drink.routeID })
        XCTAssertEqual(BrowseSearchDestinations.menuGuides.map(\.title), ["Food Menu", "Drink Menu"])
        XCTAssertEqual(BrowseSearchDestinations.menuGuides.map(\.id), [VietnameseMenuKind.food.routeID, VietnameseMenuKind.drink.routeID])
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
        XCTAssertEqual(hotel.messageScenarioIDs, [.hotelCheckInHelp, .hotelRoomHelp, .hotelBagsTaxi, .hotelWifiCheckout, .hotelRoomSupplies])
        XCTAssertEqual(hotel.mastheadImageName, "HeroCategoryHotel")

        XCTAssertEqual(shopping.messageSectionTitle, "Shopping")
        XCTAssertEqual(shopping.browseMessageSectionTitle, "Quick conversations")
        XCTAssertEqual(shopping.messageScenarioIDs, [.shoppingMarketPrice, .shoppingSizeGift, .shoppingReceiptHelp, .shoppingPayCard, .shoppingMarketProduce])

        XCTAssertEqual(hanoi.route, .city("hanoi"))
        XCTAssertEqual(hanoi.practiceAction, .practiceMode(.hanoiBucketList))
        XCTAssertNil(hanoi.messageSectionTitle)
        XCTAssertNil(hanoi.browseMessageSectionTitle)
        XCTAssertFalse(hanoi.subcategories.isEmpty)
        XCTAssertFalse(hanoi.starterItems.isEmpty)
        XCTAssertNotNil(hanoi.cityHub)
        XCTAssertEqual(hanoi.cityHub?.introTitle, "Start here")
        XCTAssertTrue(hanoi.cityHub?.introText.contains("Old Quarter") == true)
        XCTAssertEqual(hanoi.cityHub?.situationTitle, "Browse by")
        XCTAssertEqual(hanoi.cityHub?.browseTitle, "Browse by")
        XCTAssertEqual(hanoi.cityHub?.namesTitle, "Names to know")
        XCTAssertEqual(hanoi.cityHub?.cityBrowseFilters.first?.title, "Landmarks")
        XCTAssertFalse((hanoi.cityHub?.cityBrowseAllItems ?? []).isEmpty)
    }

    func testCityCollectionsExposeNounImageInventoryWithoutSituationRows() {
        let danang = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .city("danang")))
        let cityHub = try! XCTUnwrap(danang.cityHub)
        let filterTitles = cityHub.cityBrowseFilters.map(\.title)
        let allItems = cityHub.cityBrowseAllItems

        XCTAssertTrue(filterTitles.contains("Landmarks"), "filters: \(filterTitles)")
        XCTAssertTrue(filterTitles.contains("Markets"), "filters: \(filterTitles)")
        XCTAssertTrue(filterTitles.contains("Restaurants"), "filters: \(filterTitles)")
        XCTAssertTrue(filterTitles.contains("Cafes"), "filters: \(filterTitles)")
        XCTAssertTrue(filterTitles.contains("Dishes"), "filters: \(filterTitles)")
        XCTAssertFalse(filterTitles.contains("Help"))
        XCTAssertFalse(filterTitles.contains("Getting around"))
        XCTAssertGreaterThanOrEqual(allItems.count, 25, "items: \(allItems.map(\.pageID))")
        XCTAssertFalse(allItems.contains { $0.pageID == "viet-family-bathroom-where" })
        XCTAssertTrue(
            allItems.allSatisfy { $0.imageName != nil },
            "City noun rows should carry hero image metadata so the city page can render menu-style thumbnails."
        )
    }

    func testBrowseCategoryMessageSectionsMirrorMessagesHubGroups() {
        let expectations: [(String, String, [PracticeScenarioID])] = [
            ("airport", "Airport", [.danangFirstDay, .airportPassportControl, .airportSimCash, .airportWifiPower, .airportBaggageProblem]),
            ("hotel", "Hotel", [.hotelCheckInHelp, .hotelRoomHelp, .hotelBagsTaxi, .hotelWifiCheckout, .hotelRoomSupplies]),
            ("food", "Food", [.foodAllergyHelp, .restaurantOrderingPayment, .danangDay, .foodCoffeeOrder, .foodMenuItems]),
            ("getting-around", "Getting Around", [.taxiGrabPickup, .taxiRouteHelp, .driverProblemHelp, .walkingDirectionsHelp, .taxiFareComfort]),
            ("shopping", "Shopping", [.shoppingMarketPrice, .shoppingSizeGift, .shoppingReceiptHelp, .shoppingPayCard, .shoppingMarketProduce]),
            ("emergency", "Emergency", [.pharmacyHelp, .emergencyLostPassport, .emergencyLostBag, .emergencyDoctorHelp, .emergencyCallHelp]),
            ("local-greetings", "Local Greetings", [.localGreetingMarket, .localGreetingHotel, .localGreetingRespect, .localThanksSorry, .localSmallTalk]),
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
        XCTAssertEqual(
            airport.exploreShelves.first { $0.title == "Phone, Internet & Power" }?.targetRoute,
            .category("phone-internet-power")
        )
        XCTAssertEqual(
            airport.exploreShelves.first { $0.title == "Payment & numbers" }?.targetRoute,
            .category("money-numbers-prices")
        )

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

    func testHotelExploreShelfHeadersCanRouteToTheirCategories() {
        let hotel = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("hotel")))

        XCTAssertFalse(hotel.exploreShelves.isEmpty)
        XCTAssertTrue(hotel.exploreShelves.allSatisfy { shelf in
            guard let targetRoute = shelf.targetRoute else {
                return false
            }

            return targetRoute != .category("hotel")
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
        XCTAssertEqual(danang.subtitle, "Beach roads, river bridges, markets, Son Tra, and easy central Vietnam day trips.")
        XCTAssertEqual(danang.mastheadImageName, "HeroCityDanang")
        XCTAssertEqual(danang.starterTitle, "Names to know")
        XCTAssertEqual(danang.practiceTitle, "Da Nang day")
        XCTAssertEqual(danang.practiceSubtitle, "Airport pickup, beach drop-off, food, and a ride back.")
        XCTAssertFalse(danang.practiceSubtitle.localizedCaseInsensitiveContains("phrase loop"))
        XCTAssertEqual(cityHub.introTitle, "Start here")
        XCTAssertTrue(cityHub.introText.contains("airport to beach"))
        XCTAssertTrue(cityHub.introText.contains("exact side of town"))

        XCTAssertEqual(
            cityHub.situations.map(\.title),
            ["Arriving", "Getting around", "Beach day", "Food & cafes", "Places to visit", "Help"]
        )
        XCTAssertTrue(cityHub.situations.allSatisfy { $0.targetRoute == nil })
        XCTAssertTrue(cityHub.situations.allSatisfy { !$0.items.isEmpty })
        XCTAssertEqual(cityHub.cityNameAudioItem?.title, "Đà Nẵng")
        XCTAssertEqual(cityHub.cityNameAudioItem?.subtitle, "Da Nang")
        XCTAssertNotNil(AudioAssetManifest.main?.url(for: cityHub.cityNameAudioItem?.audioKey))
        XCTAssertEqual(cityHub.situations.first(where: { $0.title == "Food & cafes" })?.subtitle, "Restaurants, cafés, markets")
        XCTAssertEqual(cityHub.situations.first(where: { $0.title == "Places to visit" })?.subtitle, "Dragon Bridge, Marble Mountains, Bà Nà Hills")
        XCTAssertTrue(cityHub.situations.first(where: { $0.title == "Arriving" })?.items.contains { $0.pageID == "viet-phrase-airport-3" } == true)
        XCTAssertTrue(cityHub.situations.first(where: { $0.title == "Getting around" })?.items.contains { $0.pageID == "viet-phrase-city-danang-place-nguyen-van-linh-street" } == true)
        XCTAssertTrue(cityHub.situations.first(where: { $0.title == "Beach day" })?.items.contains { $0.pageID == "viet-phrase-city-danang-place-my-khe" } == true)
        XCTAssertTrue(cityHub.situations.first(where: { $0.title == "Food & cafes" })?.items.contains { $0.pageID == "viet-phrase-city-danang-place-nen" } == true)
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
        XCTAssertEqual(Array(cityHub.cityBrowseFilters.map(\.title).prefix(4)), ["Landmarks", "Restaurants", "Cafes", "Dishes"])
        XCTAssertTrue(cityHub.cityBrowseFilters.contains { $0.title == "Restaurants" })
        XCTAssertTrue(cityHub.cityBrowseFilters.contains { $0.title == "Cafes" })
        XCTAssertTrue(cityHub.cityBrowseFilters.contains { $0.title == "Dishes" })
        XCTAssertFalse(cityHub.cityBrowseFilters.contains { $0.title == "Getting around" })
        XCTAssertFalse(cityHub.cityBrowseFilters.contains { $0.title == "Quick phrases" })
        XCTAssertTrue(cityHub.cityBrowseAllItems.first?.pageID.contains("-place-") == true)
        XCTAssertTrue(cityHub.cityBrowseAllItems.contains { $0.pageID == "viet-phrase-city-danang-place-dragon-bridge" })
        XCTAssertFalse(cityHub.cityBrowseAllItems.contains { $0.pageID == "viet-phrase-ves-call-taxi-for-me" })
        XCTAssertEqual(Set(cityHub.cityBrowseAllItems.map(\.pageID)).count, cityHub.cityBrowseAllItems.count)
    }

    func testCityHubAndSearchDoNotTreatDerivedPlacePhrasesAsBrowseInventory() {
        let danang = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .city("danang")))
        let cityHub = try! XCTUnwrap(danang.cityHub)

        let citySurfaceItems = cityHub.situations.flatMap(\.items)
            + cityHub.namesToKnowItems
            + cityHub.quickPhraseItems
            + cityHub.browseGroups.flatMap(\.items)
            + cityHub.cityBrowseAllItems
        assertNoDerivedPlacePhraseRows(citySurfaceItems, context: "Da Nang city surface")

        let entityOnlyResults = BrowseSearchDestinations.searchResults(for: "Dragon Bridge", limit: 10)
        XCTAssertEqual(entityOnlyResults.first?.pageID, "viet-phrase-city-danang-place-dragon-bridge")
        assertNoDerivedPlacePhraseRows(entityOnlyResults, context: "Dragon Bridge entity-only search")

        let actionResults = BrowseSearchDestinations.searchResults(for: "where is Dragon Bridge", limit: 10)
        XCTAssertEqual(actionResults.first?.pageID, "viet-phrase-city-danang-place-dragon-bridge")
        assertNoDerivedPlacePhraseRows(actionResults, context: "Dragon Bridge action search")
        XCTAssertFalse(actionResults.contains { $0.pageID == "viet-phrase-city-danang-where-dragon-bridge" })
    }

    func testEntityDetailPagesHideGeneratedPlaceTemplateRows() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()

        let baNa = try repository.loadPhraseDetailPage(pageID: "viet-phrase-city-danang-place-ba-na-hills")
        let baNaRows = baNa.sections.flatMap(\.phrases)
        XCTAssertTrue(baNaRows.contains { $0.id == "taxi-1" })
        XCTAssertTrue(baNaRows.contains { $0.detailPageID == "viet-phrase-v500-time-date-book-two-tickets-please" })
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
        XCTAssertFalse(baNaRows.contains { $0.detailPageID == "viet-phrase-ves-take-me-to-ba-na-hills" })
        XCTAssertFalse(baNaRows.contains { $0.english.localizedCaseInsensitiveContains("Ba Na Hills") && $0.id != "city-danang-place-ba-na-hills" })
        XCTAssertFalse(baNaRows.contains { $0.english.localizedCaseInsensitiveContains("ATM near Ba Na Hills") })
        XCTAssertFalse(baNaRows.contains { $0.english.localizedCaseInsensitiveContains("Eat near Ba Na Hills") })

        let dragonBridge = try repository.loadPhraseDetailPage(pageID: "viet-phrase-city-danang-place-dragon-bridge")
        let dragonRows = dragonBridge.sections.flatMap(\.phrases)
        XCTAssertTrue(dragonRows.contains { $0.id == "v500-tran-please-stop-right-here" })
        XCTAssertTrue(dragonRows.contains { $0.id == "directions-8" })
        XCTAssertFalse(dragonRows.contains { $0.detailPageID == "viet-phrase-ves-drop-near-dragon-bridge" })
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

            XCTAssertGreaterThanOrEqual(cityHub.browseGroups.count, 8, "\(descriptor.title) should expose an even noun-first Browse grid")
            XCTAssertTrue(groupTitles.contains("Landmarks"), "\(descriptor.title) should expose landmark nouns")
            XCTAssertTrue(groupTitles.contains("Streets"), "\(descriptor.title) should expose street-name nouns")
            XCTAssertTrue(groupTitles.contains("Restaurants"), "\(descriptor.title) should expose restaurant nouns")
            XCTAssertTrue(groupTitles.contains("Cafes"), "\(descriptor.title) should expose cafe nouns")
            XCTAssertTrue(groupTitles.contains("Dishes"), "\(descriptor.title) should expose dish nouns")
            XCTAssertTrue(groupTitles.contains("Markets"), "\(descriptor.title) should expose market nouns")

            for disallowedTitle in disallowedBrowseGroupTitles {
                XCTAssertFalse(groupTitles.contains(disallowedTitle), "\(descriptor.title) Browse groups should be entities, not broad action lanes")
            }

            for group in cityHub.browseGroups {
                XCTAssertFalse(group.items.isEmpty, "\(descriptor.title) \(group.title) should drill into entity rows")
                XCTAssertTrue(group.items.allSatisfy { $0.pageID.contains("-place-") }, "\(descriptor.title) \(group.title) should start with noun/entity pages: \(group.items.map(\.pageID))")
                XCTAssertTrue(group.items.allSatisfy { $0.imageName != nil }, "\(descriptor.title) \(group.title) noun rows should carry image metadata")
                XCTAssertFalse(group.items.contains { item in
                    item.title.localizedCaseInsensitiveContains("ở đâu")
                        || item.subtitle.localizedCaseInsensitiveContains("where is")
                        || item.subtitle.localizedCaseInsensitiveContains("go to")
                        || item.subtitle.localizedCaseInsensitiveContains("near here")
                }, "\(descriptor.title) \(group.title) should not start with long-tail question/route phrase rows")
            }
        }
    }

    func testGenericFoodCollectionStartsWithCoffeeAndDishNounsBeforePlaces() {
        let food = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("food")))

        XCTAssertEqual(food.title, "Eating Out")
        XCTAssertEqual(food.starterTitle, "Quick orders")
        XCTAssertEqual(
            food.subcategories.map(\.title),
            ["Order drinks", "Order dishes", "Adjust the order", "Allergies & diet", "Paying", "Places to eat & drink"]
        )

        let starterIDs = food.starterItems.map(\.pageID)
        XCTAssertEqual(
            Array(starterIDs.prefix(4)),
            [
                "viet-phrase-coffee-2",
                "viet-phrase-coffee-1",
                "viet-phrase-coffee-3",
                "viet-phrase-ves-order-pho-bowl",
            ]
        )
        XCTAssertEqual(Array(food.starterItems.prefix(4).map(\.title)), ["Cà phê đen", "Cà phê sữa", "Bạc xỉu", "Phở"])
        XCTAssertEqual(food.starterItems.first?.subtitle, "Black coffee")
        XCTAssertEqual(food.starterItems.first?.audioKey, "breakdown-authored-ca-phe-den-855822aaf3")
        XCTAssertTrue(starterIDs.contains("viet-phrase-ves-order-pho-bowl"))
        XCTAssertTrue(starterIDs.contains("viet-phrase-vpe-one-item-please-cho-toi-mot-banh-xeo"))
        XCTAssertFalse(starterIDs.prefix(6).contains { $0.contains("-place-") })

        for subcategory in food.subcategories {
            XCTAssertFalse(subcategory.items.isEmpty, "Food \(subcategory.title) should drill into useful rows")
            if subcategory.title == "Order drinks" {
                XCTAssertEqual(subcategory.countUnit, "phrase")
                XCTAssertEqual(subcategory.items.first?.pageID, "viet-phrase-coffee-2")
                XCTAssertEqual(subcategory.items.first?.title, "Cà phê đen")
                XCTAssertTrue(subcategory.items.contains { $0.pageID == "viet-phrase-coffee-2" })
                XCTAssertTrue(subcategory.items.contains { $0.pageID == "viet-phrase-vpe-one-item-please-cho-toi-mot-ca-phe-it-duong" })
                XCTAssertFalse(subcategory.items.prefix(6).contains { $0.pageID.contains("-place-") })
            } else if subcategory.title == "Order dishes" {
                XCTAssertEqual(subcategory.countUnit, "phrase")
                XCTAssertGreaterThanOrEqual(subcategory.items.count, 10)
                XCTAssertEqual(subcategory.items.first?.title, "Phở")
                XCTAssertTrue(subcategory.items.contains { $0.pageID == "viet-phrase-vpe-one-item-please-cho-toi-mot-banh-xeo" })
                XCTAssertFalse(subcategory.items.prefix(8).contains { $0.pageID.contains("-place-") })
            } else if subcategory.title == "Places to eat & drink" {
                XCTAssertEqual(subcategory.countUnit, "item")
                XCTAssertTrue(subcategory.items.contains { $0.pageID == "viet-phrase-city-danang-place-nen" })
                XCTAssertTrue(subcategory.items.contains { $0.pageID == "viet-phrase-city-hanoi-place-giang-cafe" })
                XCTAssertTrue(subcategory.items.contains { $0.pageID == "viet-phrase-city-hcmc-place-ben-thanh-market" })
                assertEntityFirstBrowseRows(subcategory.items, context: "food \(subcategory.title)")
            } else {
                XCTAssertFalse(subcategory.items.prefix(6).contains { $0.pageID.contains("-place-") })
            }
        }
    }

    func testVietnameseMenuCollectionsUseCsvBackedInventory() {
        let food = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category(VietnameseMenuKind.food.routeID)))
        let drinks = try! XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category(VietnameseMenuKind.drink.routeID)))

        XCTAssertEqual(VietnameseMenuCatalog.items(for: .food).count, 269)
        XCTAssertEqual(VietnameseMenuCatalog.items(for: .drink).count, 86)

        XCTAssertEqual(food.title, "Food Menu")
        XCTAssertEqual(food.mastheadImageName, "HeroVietnameseFoodMenu")
        XCTAssertEqual(food.starterTitle, "Popular dishes")
        XCTAssertEqual(food.starterItems.first?.pageID, "viet-menu-food-pho-bo")
        XCTAssertEqual(food.starterItems.first?.title, "Phở bò")
        XCTAssertEqual(food.subcategories.first?.title, "Noodle soups")
        XCTAssertEqual(food.subcategories.first?.phraseCount, 26)

        XCTAssertEqual(drinks.title, "Drink Menu")
        XCTAssertEqual(drinks.mastheadImageName, "HeroVietnameseDrinkMenu")
        XCTAssertEqual(drinks.starterTitle, "Popular drinks")
        XCTAssertEqual(drinks.starterItems.first?.pageID, "viet-menu-drink-ca-phe-sua-da")
        XCTAssertEqual(drinks.starterItems.first?.title, "Cà phê sữa đá")
        XCTAssertEqual(drinks.subcategories.first?.title, "Coffee")
        XCTAssertEqual(drinks.subcategories.first?.phraseCount, 14)
    }

    func testVietnameseMenuSectionsExposeFullVerticalInventory() {
        let foodSections = VietnameseMenuCatalog.sections(for: .food)
        let drinkSections = VietnameseMenuCatalog.sections(for: .drink)

        XCTAssertEqual(foodSections.map(\.id), [
            "popular",
            "noodle-soups",
            "dry-noodles-and-vermicelli",
            "rice-and-sticky-rice",
            "rolls-appetizers-and-street-snacks",
            "banh-mi-bread-and-buns",
            "pork",
            "chicken-and-duck",
            "beef-and-goat",
            "seafood",
            "vegetarian",
            "soups-hot-pots-and-family-style",
            "desserts-and-sweets",
        ])
        XCTAssertEqual(foodSections.first?.items.map(\.itemID), ["food-pho-bo", "food-pho-ga", "food-bun-bo-hue", "food-bun-rieu-cua", "food-hu-tieu-nam-vang"])
        XCTAssertEqual(foodSections.first?.featuredImageName, "HeroMenuFoodPhoBo")
        XCTAssertEqual(foodSections.first { $0.id == "seafood" }?.featuredImageName, "HeroMenuFoodTomRangMuoi")
        XCTAssertEqual(foodSections.dropFirst().reduce(0) { $0 + $1.itemCount }, 269)

        XCTAssertEqual(drinkSections.map(\.id), [
            "popular",
            "coffee",
            "tea",
            "smoothies",
            "juices-and-fresh-drinks",
            "water-soda-and-other-drinks",
        ])
        XCTAssertEqual(drinkSections.first?.items.map(\.itemID), ["drink-ca-phe-sua-da", "drink-ca-phe-den-da", "drink-bac-xiu", "drink-ca-phe-trung", "drink-ca-phe-cot-dua"])
        XCTAssertEqual(drinkSections.first?.featuredImageName, "HeroMenuDrinkCaPheSuaDa")
        XCTAssertEqual(drinkSections.first { $0.id == "tea" }?.featuredImageName, "HeroMenuDrinkTraDa")
        XCTAssertEqual(drinkSections.dropFirst().reduce(0) { $0 + $1.itemCount }, 86)
    }

    func testVietnameseMenuDetailPagesUseHandwrittenSourceCopy() {
        let pho = try! XCTUnwrap(PhraseDetailPage.page(withID: "viet-menu-food-pho-bo"))
        let bunBoHue = try! XCTUnwrap(PhraseDetailPage.page(withID: "viet-menu-food-bun-bo-hue"))
        let coffee = try! XCTUnwrap(PhraseDetailPage.page(withID: "viet-menu-drink-ca-phe-sua-da"))
        let eggCoffee = try! XCTUnwrap(PhraseDetailPage.page(withID: "viet-menu-drink-ca-phe-trung"))

        XCTAssertEqual(pho.title, "Phở bò")
        XCTAssertEqual(pho.englishTitle, "Beef noodle soup")
        XCTAssertEqual(pho.pronunciation, "fuh baw")
        XCTAssertEqual(pho.heroImageName, "HeroMenuFoodPhoBo")
        XCTAssertEqual(pho.sections.map(\.id), ["what-it-is", "usually-includes", "how-to-enjoy", "useful-phrases", "how-locals-order", "worth-knowing", "common-options", "order-line"])
        XCTAssertTrue(pho.sections.first?.body.contains("clear, fragrant broth") == true)
        XCTAssertTrue(pho.sections.first { $0.id == "how-to-enjoy" }?.body.contains("Taste the broth first") == true)
        XCTAssertTrue(pho.sections.first { $0.id == "how-locals-order" }?.body.contains("shops may ask which cut you want") == true)
        XCTAssertEqual(pho.sections.first { $0.id == "how-locals-order" }?.phrases, [])
        XCTAssertTrue(pho.sections.first { $0.id == "worth-knowing" }?.body.contains("signature noodle soups") == true)
        XCTAssertEqual(pho.sections.first { $0.id == "usually-includes" }?.presentation, .menuChips)
        XCTAssertEqual(pho.sections.first { $0.id == "usually-includes" }?.chips, ["beef broth", "rice noodles", "sliced beef", "herbs", "lime"])
        XCTAssertEqual(pho.sections.first { $0.id == "usually-includes" }?.breakdown, [])
        XCTAssertEqual(pho.sections.first { $0.id == "common-options" }?.presentation, .menuChips)
        XCTAssertEqual(pho.sections.first { $0.id == "common-options" }?.chips, ["extra herbs", "chili", "bean sprouts", "less spicy", "no MSG"])
        XCTAssertEqual(pho.sections.first { $0.id == "common-options" }?.breakdown, [])
        XCTAssertEqual(pho.sections.first { $0.id == "order-line" }?.presentation, .plainText)
        XCTAssertTrue(pho.sections.first { $0.id == "order-line" }?.body.contains("Cho tôi một tô phở bò.") == true)
        XCTAssertEqual(pho.sections.first { $0.id == "order-line" }?.phrases, [])

        let bunBoHueLocalOrder = try! XCTUnwrap(bunBoHue.sections.first { $0.id == "how-locals-order" })
        XCTAssertTrue(bunBoHueLocalOrder.body.contains("ask for less spicy by saying ít cay"))
        XCTAssertEqual(bunBoHueLocalOrder.inlineDefinitions, [
            PhraseInlineDefinition(id: "menu-inline-it-cay", vietnamese: "ít cay", english: "less spicy")
        ])
        XCTAssertFalse(bunBoHueLocalOrder.body.localizedCaseInsensitiveContains("it cay"))
        XCTAssertEqual(bunBoHueLocalOrder.phrases, [])

        XCTAssertEqual(coffee.title, "Cà phê sữa đá")
        XCTAssertEqual(coffee.englishTitle, "Vietnamese iced milk coffee")
        XCTAssertEqual(coffee.heroImageName, "HeroMenuDrinkCaPheSuaDa")
        XCTAssertTrue(coffee.sections.first?.body.contains("robusta bitterness") == true)
        XCTAssertTrue(coffee.sections.first { $0.id == "how-locals-order" }?.body.contains("less sweet") == true)
        XCTAssertTrue(coffee.sections.first { $0.id == "worth-knowing" }?.body.contains("condensed milk gives the body") == true)
        XCTAssertEqual(coffee.sections.first { $0.id == "useful-phrases" }?.phrases.map(\.vietnamese), ["Làm ơn bớt đường đi", "Không đường nhé", "Ít đá thôi", "Làm ơn đừng có đá", "Tính tiền giúp tôi"])
        XCTAssertTrue(coffee.sections.first { $0.id == "useful-phrases" }?.phrases.allSatisfy { $0.playbackAudioKey != nil } == true)
        XCTAssertEqual(coffee.practiceCTALabel, "Practice ordering this")
        XCTAssertFalse(coffee.showsCatalogExplore)

        XCTAssertEqual(eggCoffee.title, "Cà phê trứng")
        XCTAssertTrue(eggCoffee.sections.first?.body.contains("fresh milk was scarce") == true)
        XCTAssertTrue(eggCoffee.sections.first { $0.id == "usually-includes" }?.chips.contains("egg cream") == true)
        XCTAssertTrue(eggCoffee.sections.first { $0.id == "worth-knowing" }?.body.contains("Nguyễn Văn Giảng") == true)
        XCTAssertTrue(eggCoffee.sections.first { $0.id == "worth-knowing" }?.body.contains("1946") == true)
    }

    func testVietnameseFoodMenuCopyHighlightsFoodSaucesAndCorrectIngredients() {
        let bunBoXao = try! XCTUnwrap(PhraseDetailPage.page(withID: "viet-menu-food-bun-bo-xao"))
        let bunDau = try! XCTUnwrap(PhraseDetailPage.page(withID: "viet-menu-food-bun-dau-mam-tom"))
        let bunChaCa = try! XCTUnwrap(PhraseDetailPage.page(withID: "viet-menu-food-bun-cha-ca"))
        let supCua = try! XCTUnwrap(PhraseDetailPage.page(withID: "viet-menu-food-sup-cua"))
        let banhMiBoKho = try! XCTUnwrap(PhraseDetailPage.page(withID: "viet-menu-food-banh-mi-bo-kho"))
        let boKhoBanhMi = try! XCTUnwrap(PhraseDetailPage.page(withID: "viet-menu-food-bo-kho-banh-mi"))
        let caRiDe = try! XCTUnwrap(PhraseDetailPage.page(withID: "viet-menu-food-ca-ri-de"))

        XCTAssertTrue(bunBoXao.sections.first?.body.contains("nước chấm") == true)
        XCTAssertTrue(bunBoXao.sections.first { $0.id == "worth-knowing" }?.body.contains("fish sauce balanced with lime") == true)
        XCTAssertEqual(bunBoXao.sections.first { $0.id == "usually-includes" }?.chips, ["rice vermicelli", "stir-fried beef", "fresh herbs", "nước chấm", "peanuts or fried shallots"])
        XCTAssertFalse(bunBoXao.sections.first { $0.id == "usually-includes" }?.chips.contains("egg noodles") == true)

        XCTAssertTrue(bunDau.sections.first?.body.contains("shrimp-paste sauce") == true)
        XCTAssertEqual(bunDau.sections.first { $0.id == "usually-includes" }?.chips, ["rice vermicelli", "fried tofu", "fresh herbs", "mắm tôm", "pork optional"])

        XCTAssertTrue(bunChaCa.sections.first?.body.contains("fish cakes") == true)
        XCTAssertEqual(bunChaCa.sections.first { $0.id == "usually-includes" }?.chips, ["rice vermicelli", "fish cakes", "fresh herbs", "nước chấm or light broth", "fried shallots"])
        XCTAssertFalse(bunChaCa.sections.first?.body.localizedCaseInsensitiveContains("grilled pork") == true)
        XCTAssertFalse(bunChaCa.sections.first { $0.id == "worth-knowing" }?.body.localizedCaseInsensitiveContains("Hanoi") == true)

        XCTAssertTrue(supCua.sections.first?.body.contains("thick crab soup") == true)
        XCTAssertEqual(supCua.sections.first { $0.id == "usually-includes" }?.chips, ["crab soup", "egg ribbons", "corn or asparagus", "cilantro", "pepper"])
        XCTAssertFalse(supCua.sections.first { $0.id == "usually-includes" }?.chips.contains("rice paper") == true)

        XCTAssertTrue(banhMiBoKho.sections.first?.body.contains("beef stew served with bread") == true)
        XCTAssertEqual(banhMiBoKho.sections.first { $0.id == "usually-includes" }?.chips, ["baguette", "beef stew", "carrots", "herbs", "spiced broth"])
        XCTAssertFalse(banhMiBoKho.sections.first?.body.localizedCaseInsensitiveContains("sandwich with") == true)
        XCTAssertTrue(banhMiBoKho.sections.first { $0.id == "order-line" }?.body.contains("I’d like one order of beef stew with bread.") == true)
        XCTAssertEqual(banhMiBoKho.sections.first { $0.id == "order-line" }?.phrases, [])

        XCTAssertTrue(boKhoBanhMi.sections.first?.body.contains("beef stew served with bread") == true)
        XCTAssertEqual(boKhoBanhMi.sections.first { $0.id == "usually-includes" }?.chips, ["beef stew", "baguette", "carrots", "herbs", "spiced broth"])
        XCTAssertTrue(boKhoBanhMi.sections.first { $0.id == "order-line" }?.body.contains("I’d like one order of beef stew with bread.") == true)
        XCTAssertFalse(boKhoBanhMi.sections.first { $0.id == "order-line" }?.body.localizedCaseInsensitiveContains("sandwich") == true)

        XCTAssertTrue(caRiDe.sections.first?.body.contains("goat curry") == true)
        XCTAssertEqual(caRiDe.sections.first { $0.id == "usually-includes" }?.chips, ["goat", "curry broth", "potato or taro", "coconut milk or richness", "bread or noodles"])
        XCTAssertFalse(caRiDe.sections.first { $0.id == "usually-includes" }?.chips.contains("fish") == true)
    }

    func testVietnameseMenuCulturalCopyOverridesSpecificMenuRows() {
        func item(_ id: String) -> VietnameseMenuItem {
            VietnameseMenuCatalog.allItems.first { $0.itemID == id }!
        }

        let thitKhoTau = item("food-thit-kho-tau")
        XCTAssertTrue(thitKhoTau.atAGlance.contains("coconut water"))
        XCTAssertTrue(thitKhoTau.goodToKnow.contains("family-meal food"))
        XCTAssertTrue(thitKhoTau.guideWorthKnowing.contains("Tết tables"))
        XCTAssertEqual(thitKhoTau.usuallyIncludes, ["pork belly", "eggs", "coconut water", "fish sauce caramel", "black pepper"])

        let caKhoTo = item("food-ca-kho-to")
        XCTAssertTrue(caKhoTo.atAGlance.contains("fish sauce, caramelized sugar"))
        XCTAssertTrue(caKhoTo.goodToKnow.contains("fish-sauce caramel"))
        XCTAssertTrue(caKhoTo.guideWorthKnowing.contains("clay pot matters"))
        XCTAssertTrue(caKhoTo.guideWorthKnowing.contains("plain rice"))

        let banhMiPate = item("food-banh-mi-pate")
        XCTAssertTrue(banhMiPate.guideWorthKnowing.contains("French colonial bread"))
        XCTAssertTrue(banhMiPate.guideHowLocalsOrder.contains("fast, cheap, portable"))

        let comTam = item("food-com-tam-bi-cha-suon")
        XCTAssertTrue(comTam.guideWorthKnowing.contains("broken rice grains from milling"))
        XCTAssertTrue(comTam.guideHowLocalsOrder.contains("without the fried-egg add-on"))

        let banhBao = item("food-banh-bao")
        XCTAssertTrue(banhBao.atAGlance.contains("soft steamed bun"))
        XCTAssertTrue(banhBao.goodToKnow.contains("Do not ask for this toasted"))
        XCTAssertFalse(banhBao.atAGlance.localizedCaseInsensitiveContains("crisp baguette"))

        let chaCa = item("food-cha-ca-la-vong")
        XCTAssertTrue(chaCa.atAGlance.contains("Hanoi-style turmeric fish"))
        XCTAssertTrue(chaCa.usuallyIncludes.contains("dill"))
        XCTAssertTrue(chaCa.guideWorthKnowing.contains("Dill is not a garnish"))

        let cheBaMau = item("food-che-ba-mau")
        XCTAssertTrue(cheBaMau.atAGlance.contains("three-color dessert cup"))
        XCTAssertEqual(cheBaMau.usuallyIncludes, ["mung beans", "red beans", "pandan jelly", "coconut milk", "crushed ice"])

        let traBiDao = item("drink-tra-bi-dao")
        XCTAssertTrue(traBiDao.atAGlance.contains("winter melon tea"))
        XCTAssertTrue(traBiDao.goodToKnow.contains("not peach"))
        XCTAssertFalse(traBiDao.usuallyIncludes.contains("peach"))

        let ruouDe = item("drink-ruou-de")
        XCTAssertTrue(ruouDe.travelerCaution?.contains("Alcoholic") == true)
        XCTAssertTrue(ruouDe.guideWorthKnowing.contains("rice-spirit culture"))
    }

    func testVietnameseMenuGuideCopyAuditFindsNoMissingOrGenericGuideFields() {
        XCTAssertEqual(VietnameseMenuCatalog.guideCopyAuditFailures(), [])
    }

    func testVietnameseMenuItemsAreHandwrittenReviewedAndUseTextOnlyOrderLines() {
        XCTAssertEqual(VietnameseMenuCatalog.allItems.count, 355)

        for item in VietnameseMenuCatalog.allItems {
            XCTAssertEqual(item.editorialReview?.status, "handwritten-reviewed", "\(item.itemID) should be individually reviewed")
            XCTAssertEqual(item.guideOrderLine.audioPolicy, "text-only", "\(item.itemID) order line should stay text-only")
            XCTAssertGreaterThanOrEqual(item.guideHowLocalsOrder.split(separator: " ").count, 18, "\(item.itemID) should include a specific How locals order note")

            let detail = try! XCTUnwrap(PhraseDetailPage.page(withID: item.detailPageID))
            let localOrder = try! XCTUnwrap(detail.sections.first { $0.id == "how-locals-order" })
            XCTAssertEqual(localOrder.title, "How locals order")
            XCTAssertTrue(localOrder.body.contains(item.guideHowLocalsOrder), "\(item.itemID) should show How locals order copy")
            XCTAssertEqual(localOrder.phrases, [], "\(item.itemID) How locals order must stay text-only")

            let orderLine = try! XCTUnwrap(detail.sections.first { $0.id == "order-line" })
            XCTAssertTrue(orderLine.body.contains(item.guideOrderLine.vietnamese), "\(item.itemID) order line should show Vietnamese text")
            XCTAssertEqual(orderLine.phrases, [], "\(item.itemID) order line must not create one-off audio rows")
            XCTAssertFalse(detail.sections.contains { $0.id == "standard-way" }, "\(item.itemID) should not render a quick-say audio section")
        }
    }

    func testVietnameseMenuHelperPhrasesAreReusableAndAudioBacked() {
        let manifest = try! XCTUnwrap(AudioAssetManifest.main)
        XCTAssertGreaterThanOrEqual(VietnameseMenuCatalog.helperPhrases.filter(\.isReady).count, 10)

        for helper in VietnameseMenuCatalog.helperPhrases where helper.isReady {
            let audioKey = try! XCTUnwrap(helper.audioKey, "\(helper.id) should declare an audio key")
            XCTAssertTrue(
                manifest.hasPlayableEntry(for: audioKey, matchingText: helper.vietnamese),
                "\(helper.id) audio should exactly match \(helper.vietnamese)"
            )
        }

        for item in VietnameseMenuCatalog.allItems {
            let detail = try! XCTUnwrap(PhraseDetailPage.page(withID: item.detailPageID))
            for phrase in detail.sections.first(where: { $0.id == "useful-phrases" })?.phrases ?? [] {
                XCTAssertNotNil(phrase.playbackAudioKey, "\(item.itemID) helper \(phrase.id) should be playable")
            }
        }
    }

    func testVietnameseMenuItemsUseUniqueImageAssetNames() {
        let items = VietnameseMenuCatalog.allItems
        let imageNames = items.map(\.menuImageName)
        let backdropImageNames = items.map(\.menuBackdropImageName)

        XCTAssertEqual(items.count, 355)
        XCTAssertEqual(Set(imageNames).count, items.count)
        XCTAssertEqual(Set(backdropImageNames).count, items.count)
        XCTAssertEqual(VietnameseMenuImages.assetName(forItemID: "food-pho-bo"), "HeroMenuFoodPhoBo")
        XCTAssertEqual(VietnameseMenuImages.assetName(forItemID: "drink-ca-phe-sua-da"), "HeroMenuDrinkCaPheSuaDa")
        XCTAssertEqual(VietnameseMenuImages.backdropAssetName(forItemID: "food-pho-bo"), "BackdropMenuFoodPhoBo")
        XCTAssertEqual(VietnameseMenuImages.backdropAssetName(forItemID: "drink-ca-phe-sua-da"), "BackdropMenuDrinkCaPheSuaDa")
    }

    func testVietnameseMenuImageAssetsExistForEveryItem() {
        for item in VietnameseMenuCatalog.allItems {
            XCTAssertNotNil(UIImage(named: item.menuImageName), "Missing menu image asset for \(item.itemID): \(item.menuImageName)")
            XCTAssertNotNil(UIImage(named: item.menuBackdropImageName), "Missing menu backdrop image asset for \(item.itemID): \(item.menuBackdropImageName)")
        }
    }

    func testVietnameseMenuDetailPagesUsePhotoBackdropImages() {
        for item in VietnameseMenuCatalog.allItems {
            let detail = try! XCTUnwrap(PhraseDetailPage.page(withID: item.detailPageID))
            XCTAssertEqual(detail.heroImageName, item.menuBackdropImageName, "\(item.itemID) detail should use the portrait backdrop asset")
            XCTAssertTrue(
                PhrasePhotoBackdropLayout.supportsListingPage(pageID: detail.id, heroImageName: detail.heroImageName),
                "\(item.itemID) detail should use the photo backdrop layout"
            )
        }
    }

    func testVietnameseMenuItemsHavePlayableNameAudio() throws {
        let manifest = try XCTUnwrap(AudioAssetManifest.main)

        for item in VietnameseMenuCatalog.allItems {
            let audioKey = try XCTUnwrap(
                manifest.audioKey(forExactText: item.vietnameseItem),
                "\(item.itemID) missing menu-name audio for \(item.vietnameseItem)"
            )
            XCTAssertTrue(
                manifest.hasPlayableEntry(for: audioKey, matchingText: item.vietnameseItem),
                "\(item.itemID) menu-name audio is not playable for \(item.vietnameseItem)"
            )

            let detail = try XCTUnwrap(PhraseDetailPage.page(withID: item.detailPageID))
            XCTAssertEqual(detail.playbackAudioKey, audioKey, "\(item.itemID) detail page should play its menu-name audio")
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
            ["First day in Vietnam", "Airport arrival", "Taxi / Grab", "Eating Out", "Hotel", "Help"]
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

    func testInactiveBrowsePageHidesAfterOpeningCityCollection() {
        let presentation = AppInteractiveNavigationPresentation.presentation(
            route: .browse,
            currentRoute: .browseCollection(.city("danang")),
            backPreviewRoute: .browse,
            forwardPreviewRoute: nil,
            drag: nil,
            width: 400
        )

        XCTAssertEqual(presentation.opacity, 0, accuracy: 0.001)
        XCTAssertEqual(presentation.horizontalOffset, 0, accuracy: 0.001)
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

    private func rgbaComponents(for color: Color) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        XCTAssertTrue(uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha))
        return (red, green, blue, alpha)
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

    func testSavedMenuItemsPersistAsTripItems() {
        let store = LocalUserIntentStore(defaults: defaults)

        store.toggleSavedPage("viet-menu-drink-ca-phe-sua-da")

        XCTAssertEqual(store.savedPageIDs, ["viet-menu-drink-ca-phe-sua-da"])
        XCTAssertTrue(store.isPageSaved("viet-menu-drink-ca-phe-sua-da"))
        XCTAssertTrue(store.practicePageIDs.isEmpty)
    }

    func testSavedTripSnapshotGroupsMenuItemsAndPhrases() {
        let snapshot = SavedTripSnapshot.make(
            savedPageIDs: [
                "viet-menu-drink-ca-phe-sua-da",
                "viet-menu-food-pho-bo",
                "viet-thank-you",
            ],
            practiceReadyCount: 3
        )

        XCTAssertEqual(snapshot.totalItemCount, 3)
        XCTAssertEqual(snapshot.practiceReadyCount, 3)
        XCTAssertEqual(snapshot.railItems.map(\.id), ["all", "phrases", "food", "drinks"])
        XCTAssertEqual(snapshot.sections.map(\.kind), [.phrases, .food, .drinks])
        XCTAssertEqual(snapshot.sections.first(where: { $0.kind == .drinks })?.items.first?.title, "Cà phê sữa đá")
        XCTAssertEqual(snapshot.sections.first(where: { $0.kind == .food })?.items.first?.imageName, "HeroMenuFoodPhoBo")
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
