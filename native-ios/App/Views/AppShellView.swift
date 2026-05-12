import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct AppShellView: View {
    @State private var navigation: AppShellNavigationState
    @State private var interactiveDrag: AppInteractiveNavigationDrag?
    @State private var dockDrag = AppDockInteractionState.inactive
    @State private var interactiveDragResolutionID = 0
    @State private var dockSelectionTapRequestID = 0
    @State private var searchQuery: String
    @State private var searchFocusRequestID = 0
    @State private var didApplyLaunchSearchFocus = false
    @State private var practiceStartRequestID = 0
    @State private var requestedPracticeMode: PracticeMode?
    @State private var requestedPracticeScenarioID: PracticeScenarioID?
    @State private var isPracticeThreadPresented = false
    @State private var pinnedAudioSpeedChromeState = PinnedAudioSpeedChromeState.hidden
    @State private var homePhraseHeroRoutePageID: String?
    @State private var homePhraseHeroMorphPageID: String?
    @State private var homePhraseHeroContentHoldPageID: String?
    @State private var homePhraseHeroMorphResetID = 0
    @StateObject private var intentStore = LocalUserIntentStore()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @FocusState private var isSearchFieldFocused: Bool
    @Namespace private var chromeNamespace
    private let launchPracticeMode: PracticeMode?
    private let launchPracticeEntryContext: PracticeEntryContext
    private let launchDetailScrollTarget: PhraseArticleInitialScrollTarget?
    private let launchSearchShouldFocus: Bool

    init(
        initialRoute: AppRoute = AppShellView.initialRoute,
        initialPracticeMode: PracticeMode? = AppShellView.initialPracticeMode,
        initialPracticeScenarioID: PracticeScenarioID? = AppShellView.initialPracticeScenarioID,
        initialPracticeEntryContext: PracticeEntryContext = AppShellView.initialPracticeEntryContext,
        initialDetailScrollTarget: PhraseArticleInitialScrollTarget? = AppShellView.initialDetailScrollTarget,
        initialSearchQuery: String = AppShellView.initialSearchQuery,
        initialSearchShouldFocus: Bool = AppShellView.initialSearchShouldFocus
    ) {
        _navigation = State(initialValue: AppShellNavigationState(initialRoute: initialRoute))
        _searchQuery = State(initialValue: initialSearchQuery)
        _requestedPracticeScenarioID = State(initialValue: initialPracticeScenarioID)
        self.launchPracticeMode = initialPracticeMode
        self.launchPracticeEntryContext = initialPracticeEntryContext
        self.launchDetailScrollTarget = initialDetailScrollTarget
        self.launchSearchShouldFocus = initialSearchShouldFocus
    }

    var body: some View {
        GeometryReader { proxy in
            let pageWidth = max(proxy.size.width, 1)

            ZStack {
                HomeView(
                    intentStore: intentStore,
                    scrollToTopTrigger: navigation.homeScrollToTopTrigger,
                    chromeNamespace: chromeNamespace,
                    isSearchActive: navigation.isSearchPresented,
                    heroMorphPageID: homePhraseHeroMorphPageID,
                    onSearchTapped: openSearch,
                    onOpenDetail: openDetailFromHome,
                    onOpenFeaturedDetail: openFeaturedDetailFromHome,
                    onOpenCollection: openBrowseCollectionFromHome,
                    onStartPractice: openPractice,
                    onBrowseAllTapped: openBrowseAll
                )
                .allowsHitTesting(navigation.currentRoute == .home && !isPreviewingForwardPage)
                .accessibilityHidden(navigation.currentRoute != .home)
                .navigationPageMotion(
                    route: .home,
                    currentRoute: navigation.currentRoute,
                    backPreviewRoute: navigation.backPreviewRoute,
                    forwardPreviewRoute: navigation.forwardPreviewRoute,
                    drag: interactiveDrag,
                    width: pageWidth
                )

                BrowsePageView(
                    intentStore: intentStore,
                    scrollToTopTrigger: navigation.browseScrollToTopTrigger,
                    onOpenDetail: openDetailFromBrowse,
                    onOpenCollection: openBrowseCollection,
                    onSearchTapped: openSearch,
                    onSearchQuery: openSearchQuery,
                    onSavedTapped: openSaved,
                    onPracticeTapped: openPractice
                )
                .allowsHitTesting(navigation.currentRoute == .browse && !isPreviewingForwardPage)
                .accessibilityHidden(navigation.currentRoute != .browse)
                .navigationPageMotion(
                    route: .browse,
                    currentRoute: navigation.currentRoute,
                    backPreviewRoute: navigation.backPreviewRoute,
                    forwardPreviewRoute: navigation.forwardPreviewRoute,
                    drag: interactiveDrag,
                    width: pageWidth
                )

                SavedPagesView(
                    intentStore: intentStore,
                    scrollToTopTrigger: navigation.savedScrollToTopTrigger,
                    onOpenDetail: openDetailFromSaved,
                    onBrowseTapped: openBrowseAll
                )
                .allowsHitTesting(navigation.currentRoute == .saved && !isPreviewingForwardPage)
                .accessibilityHidden(navigation.currentRoute != .saved)
                .navigationPageMotion(
                    route: .saved,
                    currentRoute: navigation.currentRoute,
                    backPreviewRoute: navigation.backPreviewRoute,
                    forwardPreviewRoute: navigation.forwardPreviewRoute,
                    drag: interactiveDrag,
                    width: pageWidth
                )

                PracticeView(
                    intentStore: intentStore,
                    initialMode: launchPracticeMode,
                    entryContext: launchPracticeEntryContext,
                    startRequest: practiceStartRequest,
                    isActive: navigation.currentRoute == .practice,
                    scrollToTopTrigger: navigation.practiceScrollToTopTrigger,
                    onOpenDetail: openDetailFromPractice,
                    onBrowseTapped: openBrowseAll,
                    onThreadPresentationChanged: { isPracticeThreadPresented = $0 }
                )
                .allowsHitTesting(navigation.currentRoute == .practice && !isPreviewingForwardPage)
                .accessibilityHidden(navigation.currentRoute != .practice)
                .navigationPageMotion(
                    route: .practice,
                    currentRoute: navigation.currentRoute,
                    backPreviewRoute: navigation.backPreviewRoute,
                    forwardPreviewRoute: navigation.forwardPreviewRoute,
                    drag: interactiveDrag,
                    width: pageWidth
                )

                PhraseListingView(
                    page: .xinChao,
                    scrollToTopTrigger: navigation.rootScrollToTopTrigger,
                    chromeNamespace: chromeNamespace,
                    isSearchActive: navigation.isSearchPresented,
                    showsChrome: false,
                    topChromeContentClearance: pinnedAudioSpeedScrollClearance,
                    isSaved: intentStore.isPageSaved(PhrasePage.xinChao.id),
                    heroMorphPageID: homePhraseHeroMorphPageID,
                    heroMorphContentHoldPageID: homePhraseHeroContentHoldPageID,
                    onBackTapped: {},
                    onSearchTapped: openSearch,
                    onToggleSaved: { intentStore.toggleSavedPage(PhrasePage.xinChao.id) },
                    onDetailTapped: openDetail
                )
                .allowsHitTesting(navigation.currentRoute == .phrasePage && !isPreviewingForwardPage)
                .accessibilityHidden(navigation.currentRoute != .phrasePage)
                .navigationPageMotion(
                    route: .phrasePage,
                    currentRoute: navigation.currentRoute,
                    backPreviewRoute: navigation.backPreviewRoute,
                    forwardPreviewRoute: navigation.forwardPreviewRoute,
                    drag: interactiveDrag,
                    width: pageWidth
                )

                browseCollectionPageStack(width: pageWidth)

                detailPageStack(width: pageWidth)

                if navigation.isSearchPresented {
                    SearchPageView(
                        query: $searchQuery,
                        isFieldFocused: isSearchFieldFocused,
                        chromeNamespace: chromeNamespace,
                        showsChrome: false,
                        onClose: closeSearch,
                        onOpenDetail: openDetailFromSearch,
                        onOpenCollection: openBrowseCollectionFromSearch,
                        onSearchQuery: openSearchQuery,
                        onBrowseTapped: openBrowse
                    )
                    .transition(AppPageTransition.searchMorph)
                    .zIndex(AppChromeLayout.searchPageLayerZIndex)
                    .navigationPageMotion(
                        route: .search,
                        currentRoute: navigation.currentRoute,
                        backPreviewRoute: navigation.backPreviewRoute,
                        forwardPreviewRoute: navigation.forwardPreviewRoute,
                        drag: interactiveDrag,
                        width: pageWidth
                    )
                }

                forwardPreviewPage(width: pageWidth)
            }
            .onPreferenceChange(PhraseAudioPlayerAnchorPreferenceKey.self) { anchors in
                let nextState = PinnedAudioSpeedChromePolicy.state(
                    for: anchors,
                    currentRoute: navigation.currentRoute
                )

                if nextState != pinnedAudioSpeedChromeState {
                    pinnedAudioSpeedChromeState = nextState
                }
            }
            .overlay(alignment: .leading) {
                if !isPracticeThreadPresented {
                    backSwipeCaptureEdge(width: pageWidth)
                }
            }
            .overlay(alignment: .trailing) {
                if !isPracticeThreadPresented {
                    forwardSwipeCaptureEdge(width: pageWidth)
                }
            }
            .overlay(alignment: .bottom) {
                if !isPracticeThreadPresented {
                    ChromeSeparationGradient(edge: .bottom)
                        .zIndex(AppChromeLayout.chromeSeparationLayerZIndex)
                }
            }
            .overlay(alignment: .bottom) {
                if !isPracticeThreadPresented {
                    bottomChromeHitTestEnvelope
                        .padding(.bottom, bottomChromePadding)
                        .offset(y: bottomChromeOffset)
                        .zIndex(AppChromeLayout.bottomChromeLayerZIndex)
                }
            }
            .overlay(alignment: .top) {
                if !isPracticeThreadPresented {
                    ChromeSeparationGradient(edge: .top)
                        .zIndex(AppChromeLayout.chromeSeparationLayerZIndex)
                }
            }
            .overlay(alignment: .top) {
                if showsTopAdminRow {
                    TopAdminHitTestEnvelope()
                        .zIndex(AppChromeLayout.topAdminHitTestLayerZIndex)
                }
            }
            .overlay(alignment: .top) {
                if showsTopAdminRow {
                    topAdminRow
                        .padding(.horizontal, AppChromeLayout.topAdminHorizontalPadding)
                        .padding(.top, AppChromeLayout.topAdminTopPadding)
                        .transition(.opacity)
                        .zIndex(AppChromeLayout.topAdminControlLayerZIndex)
                }
            }
            .onAppear {
                applyLaunchSearchFocusIfNeeded()
            }
            .onChange(of: navigation.isSearchPresented) { _, isPresented in
                if !isPresented {
                    cancelSearchFocus()
                }
            }
            .animation(.snappy(duration: 0.24), value: showsPinnedAudioSpeedControl)
        }
        .preferredColorScheme(.light)
    }

    private var practiceStartRequest: PracticeStartRequest? {
        if let requestedPracticeScenarioID {
            return PracticeStartRequest(id: practiceStartRequestID, scenarioID: requestedPracticeScenarioID)
        }

        if let requestedPracticeMode {
            return PracticeStartRequest(id: practiceStartRequestID, mode: requestedPracticeMode)
        }

        return nil
    }

    @ViewBuilder
    private func browseCollectionPageStack(width: CGFloat) -> some View {
        ForEach(Array(navigation.renderedBrowseCollections.enumerated()), id: \.element.id) { index, renderedCollection in
            let route = AppRoute.browseCollection(renderedCollection.route)
            let isActive = route == navigation.currentRoute

            if let descriptor = BrowseSearchDestinations.collectionDescriptor(for: renderedCollection.route) {
                BrowseCollectionPageView(
                    descriptor: descriptor,
                    scrollToTopTrigger: navigation.browseCollectionScrollToTopTrigger,
                    scrollToTopRoute: navigation.browseCollectionScrollToTopRoute,
                    onOpenDetail: openDetailFromBrowse,
                    onOpenCollection: openBrowseCollection,
                    onPractice: openPractice
                )
                .allowsHitTesting(isActive && !navigation.isSearchPresented && !isPreviewingForwardPage)
                .accessibilityHidden(!isActive || navigation.isSearchPresented)
                .transition(AppPageTransition.slideFromTrailing)
                .zIndex(Double(index + 6))
                .navigationPageMotion(
                    route: route,
                    currentRoute: navigation.currentRoute,
                    backPreviewRoute: navigation.backPreviewRoute,
                    forwardPreviewRoute: navigation.forwardPreviewRoute,
                    drag: interactiveDrag,
                    width: width
                )
            }
        }
    }

    @ViewBuilder
    private func detailPageStack(width: CGFloat) -> some View {
        ForEach(Array(navigation.renderedDetailPages.enumerated()), id: \.element.id) { index, renderedPage in
            let route = AppRoute.detailPage(renderedPage.pageID)
            let isActive = route == navigation.currentRoute

            if Self.shouldRenderDesignedXinChaoPage(for: renderedPage.pageID) {
                xinChaoListingView(
                    routePageID: renderedPage.pageID,
                    initialScrollTarget: launchDetailScrollTarget,
                    scrollToTopTrigger: navigation.detailScrollToTopTrigger,
                    scrollToTopRoute: navigation.detailScrollToTopRoute,
                    onBackTapped: goBack
                )
                .allowsHitTesting(isActive && !navigation.isSearchPresented && !isPreviewingForwardPage)
                .accessibilityHidden(!isActive || navigation.isSearchPresented)
                .transition(detailTransition(for: renderedPage.pageID))
                .zIndex(Double(index + 10))
                .navigationPageMotion(
                    route: route,
                    currentRoute: navigation.currentRoute,
                    backPreviewRoute: navigation.backPreviewRoute,
                    forwardPreviewRoute: navigation.forwardPreviewRoute,
                    drag: interactiveDrag,
                    width: width
                )
            } else if let detailPage = PhraseDetailPage.page(withID: renderedPage.pageID) {
                PhraseDetailView(
                    page: detailPage,
                    initialScrollTarget: launchDetailScrollTarget,
                    scrollToTopTrigger: navigation.detailScrollToTopTrigger,
                    scrollToTopRoute: navigation.detailScrollToTopRoute,
                    chromeNamespace: chromeNamespace,
                    isSearchActive: navigation.isSearchPresented,
                    showsChrome: false,
                    topChromeContentClearance: pinnedAudioSpeedScrollClearance,
                    isSaved: intentStore.isPageSaved(renderedPage.pageID),
                    heroMorphPageID: homePhraseHeroMorphPageID,
                    heroMorphContentHoldPageID: homePhraseHeroContentHoldPageID,
                    onBackTapped: goBack,
                    onSearchTapped: openSearch,
                    onToggleSaved: { intentStore.toggleSavedPage(renderedPage.pageID) },
                    onDetailTapped: openDetail
                )
                .allowsHitTesting(isActive && !navigation.isSearchPresented && !isPreviewingForwardPage)
                .accessibilityHidden(!isActive || navigation.isSearchPresented)
                .transition(detailTransition(for: renderedPage.pageID))
                .zIndex(Double(index + 10))
                .navigationPageMotion(
                    route: route,
                    currentRoute: navigation.currentRoute,
                    backPreviewRoute: navigation.backPreviewRoute,
                    forwardPreviewRoute: navigation.forwardPreviewRoute,
                    drag: interactiveDrag,
                    width: width
                )
            }
        }
    }

    private func detailTransition(for pageID: String) -> AnyTransition {
        isHomePhraseHeroRouteActive(for: pageID)
            ? AppPageTransition.phraseHeroMorph
            : AppPageTransition.slideFromTrailing
    }

    private func isHomePhraseHeroRouteActive(for pageID: String) -> Bool {
        guard let homePhraseHeroRoutePageID else {
            return false
        }

        let canonicalPageID = PhraseCatalog.canonicalPageID(forOpenablePageID: pageID) ?? pageID
        return homePhraseHeroRoutePageID == canonicalPageID
    }

    @ViewBuilder
    private func forwardPreviewPage(width: CGFloat) -> some View {
        if isPreviewingForwardPage, let route = navigation.forwardPreviewRoute {
            previewPage(for: route)
                .allowsHitTesting(false)
                .accessibilityHidden(true)
                .zIndex(300)
                .navigationPageMotion(
                    route: route,
                    currentRoute: navigation.currentRoute,
                    backPreviewRoute: navigation.backPreviewRoute,
                    forwardPreviewRoute: navigation.forwardPreviewRoute,
                    drag: interactiveDrag,
                    width: width
                )
        }
    }

    @ViewBuilder
    private func previewPage(for route: AppRoute) -> some View {
        switch route {
        case .home:
            HomeView(
                intentStore: intentStore,
                scrollToTopTrigger: 0,
                chromeNamespace: chromeNamespace,
                isSearchActive: navigation.isSearchPresented,
                onSearchTapped: openSearch,
                onOpenDetail: openDetailFromHome,
                onOpenFeaturedDetail: openFeaturedDetailFromHome,
                onOpenCollection: openBrowseCollectionFromHome,
                onStartPractice: openPractice,
                onBrowseAllTapped: openBrowseAll
            )
        case .browse:
            BrowsePageView(
                intentStore: intentStore,
                scrollToTopTrigger: 0,
                onOpenDetail: openDetailFromBrowse,
                onOpenCollection: openBrowseCollection,
                onSearchTapped: openSearch,
                onSearchQuery: openSearchQuery,
                onSavedTapped: openSaved,
                onPracticeTapped: openPractice
            )
        case .browseCollection(let collectionRoute):
            if let descriptor = BrowseSearchDestinations.collectionDescriptor(for: collectionRoute) {
                BrowseCollectionPageView(
                    descriptor: descriptor,
                    scrollToTopTrigger: 0,
                    scrollToTopRoute: nil,
                    onOpenDetail: openDetailFromBrowse,
                    onOpenCollection: openBrowseCollection,
                    onPractice: openPractice
                )
            }
        case .saved:
            SavedPagesView(
                intentStore: intentStore,
                scrollToTopTrigger: 0,
                onOpenDetail: openDetailFromSaved,
                onBrowseTapped: openBrowseAll
            )
        case .practice:
            PracticeView(
                intentStore: intentStore,
                startRequest: practiceStartRequest,
                isActive: false,
                scrollToTopTrigger: 0,
                onOpenDetail: openDetailFromPractice,
                onBrowseTapped: openBrowseAll
            )
        case .phrasePage:
            PhraseListingView(
                page: .xinChao,
                scrollToTopTrigger: navigation.rootScrollToTopTrigger,
                chromeNamespace: chromeNamespace,
                isSearchActive: navigation.isSearchPresented,
                showsChrome: false,
                topChromeContentClearance: pinnedAudioSpeedScrollClearance,
                isSaved: intentStore.isPageSaved(PhrasePage.xinChao.id),
                onBackTapped: {},
                onSearchTapped: openSearch,
                onToggleSaved: { intentStore.toggleSavedPage(PhrasePage.xinChao.id) },
                onDetailTapped: openDetail
            )
        case .detailPage(let detailPageID):
            if Self.shouldRenderDesignedXinChaoPage(for: detailPageID) {
                xinChaoListingView(
                    routePageID: detailPageID,
                    scrollToTopTrigger: 0,
                    onBackTapped: goBack
                )
            } else if let detailPage = PhraseDetailPage.page(withID: detailPageID) {
                PhraseDetailView(
                    page: detailPage,
                    scrollToTopTrigger: 0,
                    chromeNamespace: chromeNamespace,
                    isSearchActive: navigation.isSearchPresented,
                    showsChrome: false,
                    topChromeContentClearance: pinnedAudioSpeedScrollClearance,
                    isSaved: intentStore.isPageSaved(detailPageID),
                    onBackTapped: goBack,
                    onSearchTapped: openSearch,
                    onToggleSaved: { intentStore.toggleSavedPage(detailPageID) },
                    onDetailTapped: openDetail
                )
            }
        case .search:
            SearchPageView(
                query: $searchQuery,
                isFieldFocused: isSearchFieldFocused,
                chromeNamespace: chromeNamespace,
                showsChrome: false,
                onClose: closeSearch,
                onOpenDetail: openDetailFromSearch,
                onOpenCollection: openBrowseCollectionFromSearch,
                onSearchQuery: openSearchQuery,
                onBrowseTapped: openBrowse
            )
        }
    }

    @ViewBuilder
    private func xinChaoListingView(
        routePageID: String,
        initialScrollTarget: PhraseArticleInitialScrollTarget? = nil,
        scrollToTopTrigger: Int,
        scrollToTopRoute: AppRoute? = nil,
        onBackTapped: @escaping () -> Void
    ) -> some View {
        PhraseListingView(
            page: .xinChao,
            chromeRoute: .detailPage(routePageID),
            initialScrollTarget: initialScrollTarget,
            scrollToTopTrigger: scrollToTopTrigger,
            scrollToTopRoute: scrollToTopRoute,
            chromeNamespace: chromeNamespace,
            isSearchActive: navigation.isSearchPresented,
            showsChrome: false,
            topChromeContentClearance: pinnedAudioSpeedScrollClearance,
            isSaved: intentStore.isPageSaved(routePageID),
            heroMorphPageID: homePhraseHeroMorphPageID,
            heroMorphContentHoldPageID: homePhraseHeroContentHoldPageID,
            onBackTapped: onBackTapped,
            onSearchTapped: openSearch,
            onToggleSaved: { intentStore.toggleSavedPage(routePageID) },
            onDetailTapped: openDetail
        )
    }

    static func shouldRenderDesignedXinChaoPage(for pageID: String) -> Bool {
        let canonicalPageID = PhraseCatalog.canonicalPageID(forOpenablePageID: pageID) ?? pageID
        let canonicalXinChaoID = PhraseCatalog.canonicalPageID(forOpenablePageID: PhrasePage.xinChao.id) ?? PhrasePage.xinChao.id

        return pageID == PhrasePage.xinChao.id || canonicalPageID == canonicalXinChaoID
    }

    private var isPreviewingForwardPage: Bool {
        interactiveDrag?.direction == .forward && navigation.forwardPreviewRoute != nil
    }

    private var showsStaticBackButton: Bool {
        switch navigation.currentRoute {
        case .home, .browse, .search:
            return false
        case .practice:
            return navigation.hasExplicitBackHistory
        case .browseCollection, .phrasePage, .saved, .detailPage:
            return true
        }
    }

    private var showsPinnedAudioSpeedControl: Bool {
        guard showsStaticBackButton, !navigation.isSearchPresented else {
            return false
        }

        return pinnedAudioSpeedChromeState.route == navigation.currentRoute
            && pinnedAudioSpeedChromeState.isVisible
    }

    private var pinnedAudioSpeedScrollClearance: CGFloat {
        AppChromeLayout.pinnedAudioSpeedScrollClearance
    }

    private var showsTopAdminRow: Bool {
        !isPracticeThreadPresented
            && (showsStaticBackButton || showsPinnedAudioSpeedControl || navigation.canGoForward)
    }

    private var bottomChromePadding: CGFloat {
        isSearchFieldFocused ? 12 : AppChromeLayout.bottomPadding
    }

    private var bottomChromeOffset: CGFloat {
        isSearchFieldFocused ? 0 : AppChromeLayout.bottomOffset
    }

    private var bottomChromeHitTestEnvelope: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color(.systemBackground).opacity(0.001))
                .frame(maxWidth: .infinity)
                .frame(height: AppChromeLayout.bottomHitTestEnvelopeHeight)
                .contentShape(Rectangle())
                .onTapGesture {}
                .accessibilityHidden(true)

            staticBottomChrome
                .padding(.horizontal, AppChromeLayout.bottomOuterHorizontalPadding)
        }
        .frame(maxWidth: .infinity)
        .frame(height: AppChromeLayout.bottomHitTestEnvelopeHeight, alignment: .bottom)
        .contentShape(Rectangle())
    }

    private var topAdminRow: some View {
        Group {
            if #available(iOS 26.0, *) {
                GlassEffectContainer(spacing: 14) {
                    topAdminRowContent
                }
            } else {
                topAdminRowContent
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: AppChromeLayout.topAdminControlSize)
    }

    private var topAdminRowContent: some View {
        ZStack {
            HStack {
                if showsStaticBackButton {
                    staticBackButton
                } else {
                    topAdminPlaceholder
                }

                Spacer(minLength: 0)

                if navigation.canGoForward {
                    forwardButton
                } else {
                    topAdminPlaceholder
                }
            }

            if showsPinnedAudioSpeedControl {
                PinnedAudioSpeedControl()
                    .transition(.scale(scale: 0.94).combined(with: .opacity))
            }
        }
    }

    private var staticBackButton: some View {
        Button {
            goBack()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .semibold))
                .frame(width: AppChromeLayout.topAdminControlSize, height: AppChromeLayout.topAdminControlSize)
                .foregroundStyle(.primary)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .nativeGlass(in: Circle(), interactive: true)
        .accessibilityLabel("Go back")
        .accessibilityIdentifier("TopAdmin.BackButton")
    }

    @ViewBuilder
    private var staticBottomChrome: some View {
        AppShellBottomChrome(
            route: navigation.currentRoute,
            searchOriginDockItem: navigation.searchOriginDockItem,
            isSearchFieldFocused: isSearchFieldFocused,
            searchQuery: $searchQuery,
            searchFieldFocus: $isSearchFieldFocused,
            chromeNamespace: chromeNamespace,
            onOpenSearch: openSearch,
            onCloseSearch: closeSearch,
            onFocusSearchField: focusSearchField,
            onClearFocusedSearch: clearFocusedSearch,
            onCancelSearchFocus: cancelSearchFocus,
            onSelectDockItem: performDockAction
        )
    }

    @ViewBuilder
    private var staticBottomChromeGlassContent: some View {
        let isSearchRoute = navigation.currentRoute == .search
        let isKeyboardSearch = isSearchRoute && isSearchFieldFocused
        let chrome = AppChrome(route: navigation.currentRoute)

        HStack(spacing: AppChromeLayout.bottomSpacing) {
            if isSearchRoute {
                if !isKeyboardSearch {
                    searchOriginGlassShell(kind: navigation.searchOriginDockItem)
                }
            } else {
                dockCluster(chrome: chrome)
            }

            if isSearchRoute {
                searchFieldGlassShell
            } else {
                collapsedSearchButton
            }

            if isKeyboardSearch {
                searchDismissKeyboardGlassShell
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.snappy(duration: AppChromeLayout.searchMorphDuration), value: isSearchRoute)
        .animation(.snappy(duration: 0.34), value: isSearchFieldFocused)
    }

    @ViewBuilder
    private var searchRouteForegroundControls: some View {
        if navigation.currentRoute == .search {
            searchForegroundControls(
                isKeyboardSearch: isSearchFieldFocused,
                origin: navigation.searchOriginDockItem
            )
        }
    }

    @ViewBuilder
    private var staticBottomChromeContent: some View {
        let isSearchRoute = navigation.currentRoute == .search
        let isKeyboardSearch = isSearchRoute && isSearchFieldFocused
        let chrome = AppChrome(route: navigation.currentRoute)

        HStack(spacing: AppChromeLayout.bottomSpacing) {
            if isSearchRoute {
                if !isKeyboardSearch {
                    searchOriginFallbackButton(kind: navigation.searchOriginDockItem)
                }
            } else {
                dockCluster(chrome: chrome)
            }

            if isSearchRoute {
                searchFieldFallbackCluster
            } else {
                collapsedSearchButton
            }

            if isKeyboardSearch {
                searchDismissKeyboardFallbackButton
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.snappy(duration: AppChromeLayout.searchMorphDuration), value: isSearchRoute)
        .animation(.snappy(duration: 0.34), value: isSearchFieldFocused)
    }

    private func dockCluster(chrome: AppChrome) -> some View {
        GeometryReader { proxy in
            let itemCount = chrome.primaryDockItems.count
            let contentWidth = max(
                AppDockSelectionLayout.contentWidth(itemCount: itemCount),
                proxy.size.width - AppChromeLayout.dockHorizontalPadding * 2
            )
            let selectedIndex = chrome.primaryDockItems.firstIndex(of: chrome.selectedDockItem) ?? 0
            let activeItem = dockDrag.activeItem ?? chrome.selectedDockItem
            let activeIndex = chrome.primaryDockItems.firstIndex(of: activeItem)
            let isPressingDockSelection = dockDrag.dragX != nil
            let isDraggingDockSelection = dockDrag.didMoveBeyondTap
            let lensAnimation = dockSelectionLensAnimation(isFingerTracking: dockDrag.isFingerTracking)
            let lensMetrics = AppDockSelectionLayout.lensMetrics(
                selectedIndex: selectedIndex,
                activeIndex: activeIndex,
                dragX: dockDrag.dragX,
                itemCount: itemCount,
                reduceMotion: reduceMotion,
                contentWidth: contentWidth,
                predictedDragX: dockDrag.predictedDragX
            )

            ZStack(alignment: .leading) {
                AppShellDockSelectionLens(
                    width: lensMetrics.width,
                    height: lensMetrics.height,
                    isPressed: isPressingDockSelection,
                    isDragging: isDraggingDockSelection,
                    chromeNamespace: chromeNamespace
                )
                    .offset(x: lensMetrics.xOffset)
                    .animation(
                        lensAnimation,
                        value: lensMetrics
                    )
                    .zIndex(AppChromeLayout.dockSelectionLensZIndex)

                HStack(spacing: 0) {
                    ForEach(Array(chrome.primaryDockItems.enumerated()), id: \.element) { index, item in
                        Button {
                            performDockTapAction(item, chrome: chrome, contentWidth: contentWidth)
                        } label: {
                            AppShellDockItem(
                                kind: item,
                                selected: item == activeItem,
                                chromeNamespace: chromeNamespace,
                                isMorphSource: item == chrome.selectedDockItem
                            )
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(item.title)
                        .accessibilityIdentifier("AppChrome.Dock.\(item.title)")
                        .frame(width: AppChromeLayout.dockItemWidth, height: AppChromeLayout.dockItemHeight)
                        .contentShape(Rectangle())

                        if index < chrome.primaryDockItems.count - 1 {
                            Spacer(minLength: AppChromeLayout.dockItemSpacing)
                        }
                    }
                }
                .frame(width: contentWidth)
                .zIndex(AppChromeLayout.dockItemForegroundZIndex)
            }
            .frame(width: contentWidth, height: AppChromeLayout.dockItemHeight)
            .contentShape(Rectangle())
            .simultaneousGesture(
                dockSelectionGesture(chrome: chrome, contentWidth: contentWidth),
                including: .all
            )
            .padding(.horizontal, AppChromeLayout.dockHorizontalPadding)
            .padding(.vertical, AppChromeLayout.dockVerticalPadding)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(
                Color.white.opacity(AppChromeLayout.dockBackdropFillOpacity),
                in: RoundedRectangle(cornerRadius: AppChromeLayout.dockCornerRadius, style: .continuous)
            )
            .nativeGlass(cornerRadius: AppChromeLayout.dockCornerRadius)
            .appChromeGlassOutline(
                in: RoundedRectangle(cornerRadius: AppChromeLayout.dockCornerRadius, style: .continuous),
                prominence: 0.52
            )
            .nativeGlassMorphID(AppChromeMorphID.dock, namespace: chromeNamespace)
            .chromeMorph(AppChromeMorphID.dock, namespace: chromeNamespace, isSource: !navigation.isSearchPresented)
            .zIndex(AppChromeLayout.dockMorphZIndex)
        }
        .frame(height: AppChromeLayout.searchIslandSize)
        .layoutPriority(1)
    }

    private func dockSelectionGesture(chrome: AppChrome, contentWidth: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                updateDockSelectionDrag(value, chrome: chrome, contentWidth: contentWidth)
            }
            .onEnded { value in
                finishDockSelectionDrag(value, chrome: chrome, contentWidth: contentWidth)
            }
    }

    private func dockSelectionLensAnimation(isFingerTracking: Bool) -> Animation? {
        if isFingerTracking {
            return nil
        }

        return reduceMotion
            ? .easeOut(duration: 0.14)
            : .interactiveSpring(response: 0.24, dampingFraction: 0.78, blendDuration: 0.06)
    }

    private func updateDockSelectionDrag(_ value: DragGesture.Value, chrome: AppChrome, contentWidth: CGFloat) {
        guard let item = dockItem(for: value.location.x, chrome: chrome, contentWidth: contentWidth) else {
            return
        }

        dockSelectionTapRequestID += 1

        let previousItem = dockDrag.activeItem
        let startItem = dockDrag.startItem ?? chrome.selectedDockItem
        let didMoveBeyondTap = dockDrag.didMoveBeyondTap
            || abs(value.translation.width) >= AppChromeLayout.dockSelectionDragCommitDistance
        let activeItem = didMoveBeyondTap ? item : chrome.selectedDockItem
        let dragX = didMoveBeyondTap
            ? value.location.x
            : AppDockSelectionLayout.itemCenterX(
                index: chrome.primaryDockItems.firstIndex(of: chrome.selectedDockItem) ?? 0,
                itemCount: chrome.primaryDockItems.count,
                contentWidth: contentWidth
            )
        let predictedDragX = didMoveBeyondTap ? value.predictedEndLocation.x : dragX

        dockDrag = AppDockInteractionState(
            startItem: startItem,
            activeItem: activeItem,
            dragX: dragX,
            predictedDragX: predictedDragX,
            isFingerTracking: didMoveBeyondTap,
            didMoveBeyondTap: didMoveBeyondTap
        )

        if didMoveBeyondTap, previousItem != nil, previousItem != item {
            playDockCrossingHaptic()
        }
    }

    private func finishDockSelectionDrag(_ value: DragGesture.Value, chrome: AppChrome, contentWidth: CGFloat) {
        let shouldCommitDrag = dockDrag.didMoveBeyondTap
        let item = dockItem(for: value.location.x, chrome: chrome, contentWidth: contentWidth)

        guard shouldCommitDrag, let item else {
            withAnimation(
                reduceMotion
                ? .easeOut(duration: 0.14)
                : .interactiveSpring(response: 0.24, dampingFraction: 0.84, blendDuration: 0.06)
            ) {
                dockDrag = .inactive
            }
            return
        }

        dockSelectionTapRequestID += 1
        let requestID = dockSelectionTapRequestID
        let destinationIndex = chrome.primaryDockItems.firstIndex(of: item) ?? 0
        let destinationX = AppDockSelectionLayout.itemCenterX(
            index: destinationIndex,
            itemCount: chrome.primaryDockItems.count,
            contentWidth: contentWidth
        )

        withAnimation(.interactiveSpring(response: 0.20, dampingFraction: 0.80, blendDuration: 0.05)) {
            dockDrag = AppDockInteractionState(
                startItem: dockDrag.startItem ?? chrome.selectedDockItem,
                activeItem: item,
                dragX: destinationX,
                predictedDragX: destinationX,
                isFingerTracking: false,
                didMoveBeyondTap: true
            )
        }

        commitDockSelectionAction(item, requestID: requestID, deactivateDelay: AppChromeLayout.dockSelectionTapDeactivateDelay)
    }

    private func deactivateDockSelection(requestID: Int, delay: UInt64) {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: delay)
            guard requestID == dockSelectionTapRequestID else {
                return
            }

            withAnimation(.interactiveSpring(response: 0.22, dampingFraction: 0.86, blendDuration: 0.04)) {
                dockDrag = .inactive
            }
        }
    }

    private func commitDockSelectionAction(_ item: DockItemKind, requestID: Int, deactivateDelay: UInt64) {
        interactiveDragResolutionID += 1
        homePhraseHeroMorphResetID += 1
        homePhraseHeroRoutePageID = nil
        homePhraseHeroMorphPageID = nil
        homePhraseHeroContentHoldPageID = nil
        interactiveDrag = nil
        cancelSearchFocus()

        withAnimation(.snappy(duration: 0.30)) {
            switch item {
            case .home:
                navigation.openHome()
            case .browse:
                navigation.openBrowse()
            case .saved:
                navigation.openSaved()
            case .practice:
                navigation.openPractice()
            }
        }

        if item == .home {
            searchQuery = ""
        }

        deactivateDockSelection(requestID: requestID, delay: deactivateDelay)
    }

    private func performDockTapAction(_ item: DockItemKind, chrome: AppChrome, contentWidth: CGFloat) {
        guard item != chrome.selectedDockItem, !reduceMotion else {
            performDockAction(item)
            return
        }

        dockSelectionTapRequestID += 1
        let requestID = dockSelectionTapRequestID
        let sourceIndex = chrome.primaryDockItems.firstIndex(of: chrome.selectedDockItem) ?? 0
        let destinationIndex = chrome.primaryDockItems.firstIndex(of: item) ?? sourceIndex
        let sourceX = AppDockSelectionLayout.itemCenterX(
            index: sourceIndex,
            itemCount: chrome.primaryDockItems.count,
            contentWidth: contentWidth
        )
        let destinationX = AppDockSelectionLayout.itemCenterX(
            index: destinationIndex,
            itemCount: chrome.primaryDockItems.count,
            contentWidth: contentWidth
        )

        cancelSearchFocus()

        withAnimation(.interactiveSpring(response: 0.20, dampingFraction: 0.78, blendDuration: 0.04)) {
            dockDrag = AppDockInteractionState(
                startItem: chrome.selectedDockItem,
                activeItem: chrome.selectedDockItem,
                dragX: sourceX,
                predictedDragX: sourceX,
                isFingerTracking: false,
                didMoveBeyondTap: false
            )
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: AppChromeLayout.dockSelectionTapActivationDelay)
            guard requestID == dockSelectionTapRequestID else {
                return
            }

            playDockCrossingHaptic()
            withAnimation(.interactiveSpring(response: 0.24, dampingFraction: 0.76, blendDuration: 0.06)) {
                dockDrag = AppDockInteractionState(
                    startItem: chrome.selectedDockItem,
                    activeItem: item,
                    dragX: destinationX,
                    predictedDragX: destinationX,
                    isFingerTracking: false,
                    didMoveBeyondTap: true
                )
            }

            try? await Task.sleep(nanoseconds: AppChromeLayout.dockSelectionTapTravelDelay)
            guard requestID == dockSelectionTapRequestID else {
                return
            }

            commitDockSelectionAction(item, requestID: requestID, deactivateDelay: AppChromeLayout.dockSelectionTapDeactivateDelay)
        }
    }

    private func dockItem(for locationX: CGFloat, chrome: AppChrome, contentWidth: CGFloat) -> DockItemKind? {
        guard let index = AppDockSelectionLayout.itemIndex(
            for: locationX,
            itemCount: chrome.primaryDockItems.count,
            contentWidth: contentWidth
        ) else {
            return nil
        }

        return chrome.primaryDockItems[index]
    }

    private func playDockCrossingHaptic() {
        #if canImport(UIKit)
        guard !reduceMotion else {
            return
        }

        UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.55)
        #endif
    }

    private var collapsedSearchButton: some View {
        Button {
            openSearch()
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.title2.weight(.medium))
                .foregroundStyle(.primary)
                .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
                .contentShape(Circle())
                .chromeIconMorph(AppChromeMorphID.searchIcon, namespace: chromeNamespace, isSource: !navigation.isSearchPresented)
        }
        .buttonStyle(.plain)
        .background(
            Color.white.opacity(AppChromeLayout.chromeControlBackdropFillOpacity),
            in: Circle()
        )
        .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
        .appChromeGlassOutline(in: Circle(), prominence: 0.78)
        .nativeGlassMorphID(AppChromeMorphID.search, namespace: chromeNamespace)
        .chromeMorph(AppChromeMorphID.search, namespace: chromeNamespace, isSource: !navigation.isSearchPresented)
        .accessibilityLabel("Search")
        .accessibilityIdentifier("AppChrome.SearchButton")
        .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
        .contentShape(Circle())
        .zIndex(AppChromeLayout.searchMorphZIndex)
    }

    private func searchOriginGlassShell(kind _: DockItemKind) -> some View {
        Color.clear
            .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
            .contentShape(Circle())
            .background(
                Color.white.opacity(AppChromeLayout.chromeControlBackdropFillOpacity),
                in: Circle()
            )
            .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
            .appChromeGlassOutline(in: Circle(), prominence: 0.74)
            .nativeGlassMorphID(AppChromeMorphID.dock, namespace: chromeNamespace)
            .chromeMorph(AppChromeMorphID.dock, namespace: chromeNamespace, isSource: navigation.isSearchPresented)
            .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
            .contentShape(Circle())
            .allowsHitTesting(false)
            .accessibilityHidden(true)
            .zIndex(AppChromeLayout.searchOriginMorphZIndex)
    }

    private var searchFieldGlassShell: some View {
        Color.clear
            .frame(height: AppChromeLayout.searchFieldHeight)
            .frame(maxWidth: .infinity)
            .background(
                Color.white.opacity(AppChromeLayout.chromeControlBackdropFillOpacity),
                in: RoundedRectangle(cornerRadius: AppChromeLayout.searchIslandCornerRadius, style: .continuous)
            )
            .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
            .appChromeGlassOutline(
                in: RoundedRectangle(cornerRadius: AppChromeLayout.searchIslandCornerRadius, style: .continuous),
                prominence: 0.70
            )
            .nativeGlassMorphID(AppChromeMorphID.search, namespace: chromeNamespace)
            .chromeMorph(AppChromeMorphID.search, namespace: chromeNamespace, isSource: true)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
            .zIndex(AppChromeLayout.searchMorphZIndex)
    }

    private func searchForegroundControls(isKeyboardSearch: Bool, origin: DockItemKind) -> some View {
        HStack(spacing: AppChromeLayout.bottomSpacing) {
            if !isKeyboardSearch {
                searchOriginForegroundButton(kind: origin)
            }

            searchFieldForegroundCluster

            if isKeyboardSearch {
                searchDismissKeyboardForegroundButton
            }
        }
        .frame(maxWidth: .infinity)
        .compositingGroup()
        .zIndex(AppChromeLayout.searchForegroundMorphZIndex)
    }

    private func searchOriginForegroundButton(kind: DockItemKind) -> some View {
        Button {
            closeSearch()
        } label: {
            Image(systemName: kind.symbolName)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
                .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
                .contentShape(Circle())
                .chromeIconMorph(AppChromeMorphID.dockItem(kind), namespace: chromeNamespace, isSource: false)
                .accessibilityIdentifier("AppChrome.SearchForegroundOriginIcon.\(kind.title)")
        }
        .buttonStyle(.plain)
        .accessibilityLabel(kind.title)
        .accessibilityIdentifier("AppChrome.SearchOriginButton.\(kind.title)")
        .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
        .contentShape(Circle())
    }

    private var searchFieldForegroundCluster: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: AppChromeLayout.searchFieldIconSlotWidth)
                .chromeIconMorph(AppChromeMorphID.searchIcon, namespace: chromeNamespace, isSource: navigation.isSearchPresented)
                .accessibilityIdentifier("AppChrome.SearchForegroundSearchIcon")

            TextField("Search Vietnamese phrases", text: $searchQuery)
                .font(.body.weight(.semibold))
                .foregroundStyle(.primary)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($isSearchFieldFocused)
                .accessibilityIdentifier("AppChrome.SearchField")
                .layoutPriority(1)
        }
        .padding(.horizontal, AppChromeLayout.searchFieldHorizontalPadding)
        .frame(height: AppChromeLayout.searchFieldHeight)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(RoundedRectangle(cornerRadius: AppChromeLayout.searchIslandCornerRadius, style: .continuous))
        .onTapGesture {
            focusSearchField()
        }
    }

    private var searchDismissKeyboardGlassShell: some View {
        Color.clear
            .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
            .contentShape(Circle())
            .background(
                Color.white.opacity(AppChromeLayout.chromeControlBackdropFillOpacity),
                in: Circle()
            )
            .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
            .appChromeGlassOutline(in: Circle(), prominence: 0.74)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
            .zIndex(AppChromeLayout.keyboardDismissMorphZIndex)
    }

    private var searchDismissKeyboardForegroundButton: some View {
        Button {
            clearFocusedSearch()
        } label: {
            Image(systemName: "xmark")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
                .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(searchQuery.isEmpty ? "Dismiss keyboard" : "Clear search")
        .accessibilityIdentifier("AppChrome.SearchDismissKeyboardButton")
        .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
        .zIndex(AppChromeLayout.keyboardDismissMorphZIndex)
    }

    private func searchOriginFallbackButton(kind: DockItemKind) -> some View {
        Button {
            closeSearch()
        } label: {
            Image(systemName: kind.symbolName)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
                .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .background(
            Color.white.opacity(AppChromeLayout.chromeControlBackdropFillOpacity),
            in: Circle()
        )
        .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
        .appChromeGlassOutline(in: Circle(), prominence: 0.74)
        .accessibilityLabel(kind.title)
        .accessibilityIdentifier("AppChrome.SearchOriginButton.\(kind.title)")
        .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
        .contentShape(Circle())
        .zIndex(AppChromeLayout.searchOriginMorphZIndex)
    }

    private var searchFieldFallbackCluster: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: AppChromeLayout.searchFieldIconSlotWidth)

            TextField("Search Vietnamese phrases", text: $searchQuery)
                .font(.body.weight(.semibold))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($isSearchFieldFocused)
                .accessibilityIdentifier("AppChrome.SearchField")
        }
        .padding(.horizontal, AppChromeLayout.searchFieldHorizontalPadding)
        .frame(height: AppChromeLayout.searchFieldHeight)
        .frame(maxWidth: .infinity)
        .background(
            Color.white.opacity(AppChromeLayout.chromeControlBackdropFillOpacity),
            in: RoundedRectangle(cornerRadius: AppChromeLayout.searchIslandCornerRadius, style: .continuous)
        )
        .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
        .appChromeGlassOutline(
            in: RoundedRectangle(cornerRadius: AppChromeLayout.searchIslandCornerRadius, style: .continuous),
            prominence: 0.70
        )
        .zIndex(AppChromeLayout.searchMorphZIndex)
    }

    private var searchDismissKeyboardFallbackButton: some View {
        Button {
            clearFocusedSearch()
        } label: {
            Image(systemName: "xmark")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
                .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .background(
            Color.white.opacity(AppChromeLayout.chromeControlBackdropFillOpacity),
            in: Circle()
        )
        .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
        .appChromeGlassOutline(in: Circle(), prominence: 0.74)
        .accessibilityLabel(searchQuery.isEmpty ? "Dismiss keyboard" : "Clear search")
        .accessibilityIdentifier("AppChrome.SearchDismissKeyboardButton")
        .zIndex(AppChromeLayout.keyboardDismissMorphZIndex)
    }

    private var forwardButton: some View {
        Button {
            goForward()
        } label: {
            Image(systemName: "chevron.right")
                .font(.system(size: 20, weight: .semibold))
                .frame(width: AppChromeLayout.topAdminControlSize, height: AppChromeLayout.topAdminControlSize)
                .foregroundStyle(.primary)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .nativeGlass(in: Circle(), interactive: true)
        .accessibilityLabel("Go forward")
        .accessibilityIdentifier("TopAdmin.ForwardButton")
    }

    private var topAdminPlaceholder: some View {
        Color.clear
            .frame(width: AppChromeLayout.topAdminControlSize, height: AppChromeLayout.topAdminControlSize)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }

    @ViewBuilder
    private func backSwipeCaptureEdge(width: CGFloat) -> some View {
        if navigation.canNavigateBackWithSwipe {
            Rectangle()
                .fill(.clear)
                .frame(width: AppBackSwipeGesturePolicy.edgeStartWidth)
                .contentShape(Rectangle())
                .gesture(backSwipeGesture(width: width))
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private func forwardSwipeCaptureEdge(width: CGFloat) -> some View {
        if navigation.canGoForward {
            Rectangle()
                .fill(.clear)
                .frame(width: AppForwardSwipeGesturePolicy.edgeStartWidth)
                .contentShape(Rectangle())
                .gesture(forwardSwipeGesture(width: width))
                .accessibilityHidden(true)
        }
    }

    private func backSwipeGesture(width: CGFloat) -> some Gesture {
        DragGesture(
            minimumDistance: AppBackSwipeGesturePolicy.minimumDistance,
            coordinateSpace: .local
        )
        .onChanged { value in
            guard
                navigation.canNavigateBackWithSwipe,
                AppBackSwipeGesturePolicy.canTrackBackSwipe(translation: value.translation)
            else {
                if interactiveDrag?.direction == .back {
                    interactiveDrag = nil
                }
                return
            }

            updateInteractiveDrag(
                AppInteractiveNavigationDrag(
                    direction: .back,
                    translation: AppInteractiveNavigationGesture.clampedBackTranslation(
                        value.translation.width,
                        width: width
                    ),
                    width: width
                )
            )
        }
        .onEnded { value in
            let shouldNavigateBack = navigation.canNavigateBackWithSwipe && AppBackSwipeGesturePolicy.shouldCommitBackSwipe(
                translation: value.translation,
                predictedEndTranslation: value.predictedEndTranslation,
                width: width
            )

            if shouldNavigateBack {
                commitInteractiveSwipe(direction: .back, width: width)
            } else {
                cancelInteractiveDrag()
            }
        }
    }

    private func forwardSwipeGesture(width: CGFloat) -> some Gesture {
        DragGesture(
            minimumDistance: AppForwardSwipeGesturePolicy.minimumDistance,
            coordinateSpace: .local
        )
        .onChanged { value in
            guard
                navigation.canGoForward,
                AppForwardSwipeGesturePolicy.canTrackForwardSwipe(translation: value.translation)
            else {
                if interactiveDrag?.direction == .forward {
                    interactiveDrag = nil
                }
                return
            }

            updateInteractiveDrag(
                AppInteractiveNavigationDrag(
                    direction: .forward,
                    translation: AppInteractiveNavigationGesture.clampedForwardTranslation(
                        value.translation.width,
                        width: width
                    ),
                    width: width
                )
            )
        }
        .onEnded { value in
            let shouldNavigateForward = navigation.canGoForward && AppForwardSwipeGesturePolicy.shouldCommitForwardSwipe(
                translation: value.translation,
                predictedEndTranslation: value.predictedEndTranslation,
                width: width
            )

            if shouldNavigateForward {
                commitInteractiveSwipe(direction: .forward, width: width)
            } else {
                cancelInteractiveDrag()
            }
        }
    }

    private func openDetail(_ id: String) {
        openDetail(id, source: .article)
    }

    private func openDetailFromHome(_ id: String) {
        openDetail(id, source: .home)
    }

    private func openFeaturedDetailFromHome(_ id: String) {
        let morphPageID = HomeFeaturePhraseItem.resolve(pageID: id)?.morphPageID
            ?? PhraseCatalog.canonicalPageID(forOpenablePageID: id)
            ?? id

        cancelInteractiveChromeState()
        homePhraseHeroMorphResetID += 1
        let resetID = homePhraseHeroMorphResetID

        withoutRouteAnimation {
            homePhraseHeroRoutePageID = morphPageID
            homePhraseHeroMorphPageID = nil
            homePhraseHeroContentHoldPageID = morphPageID
        }

        withAnimation(HomePhraseHeroMorphTiming.navigationAnimation) {
            navigation.openDetail(id)
        }
        intentStore.recordOpenedPage(id, source: .home)
        revealHomePhraseHeroContent(after: resetID)
        clearHomePhraseHeroLaunch(after: resetID)
    }

    private func revealHomePhraseHeroContent(after resetID: Int) {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: HomePhraseHeroMorphTiming.articleRevealDelayNanoseconds)
            guard homePhraseHeroMorphResetID == resetID else {
                return
            }

            withAnimation(HomePhraseHeroMorphTiming.articleRevealAnimation) {
                homePhraseHeroContentHoldPageID = nil
            }
        }
    }

    private func clearHomePhraseHeroLaunch(after resetID: Int) {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: HomePhraseHeroMorphTiming.cleanupDelayNanoseconds)
            guard homePhraseHeroMorphResetID == resetID else {
                return
            }

            withoutRouteAnimation {
                homePhraseHeroRoutePageID = nil
                homePhraseHeroMorphPageID = nil
            }
        }
    }

    private func openDetailFromBrowse(_ id: String) {
        openDetail(id, source: .browse)
    }

    private func openDetailFromSaved(_ id: String) {
        openDetail(id, source: .home)
    }

    private func openDetailFromPractice(_ id: String) {
        openDetail(id, source: .practice)
    }

    private func openDetail(_ id: String, source: UserIntentSource) {
        cancelInteractiveChromeState()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openDetail(id)
        }
        intentStore.recordOpenedPage(id, source: source)
    }

    private func openDetailFromSearch(_ id: String) {
        openDetail(id, source: .search)
    }

    private func openBrowseCollection(_ route: BrowseCollectionRoute) {
        cancelInteractiveChromeState()
        cancelSearchFocus()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openBrowseCollection(route)
        }
    }

    private func openBrowseCollectionFromHome(_ route: BrowseCollectionRoute) {
        cancelInteractiveChromeState()
        cancelSearchFocus()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openHomeBrowseCollection(route)
        }
    }

    private func openBrowseCollectionFromSearch(_ route: BrowseCollectionRoute) {
        if navigation.searchOriginDockItem == .home {
            openBrowseCollectionFromHome(route)
        } else {
            openBrowseCollection(route)
        }
    }

    private func openBrowseAll() {
        openBrowse()
    }

    private func performDockAction(_ item: DockItemKind) {
        switch item {
        case .home:
            openHome()
        case .browse:
            openBrowse()
        case .saved:
            openSaved()
        case .practice:
            openPractice()
        }
    }

    private func openHome() {
        cancelInteractiveChromeState()
        cancelSearchFocus()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openHome()
        }
        searchQuery = ""
    }

    private func openBrowse() {
        cancelInteractiveChromeState()
        cancelSearchFocus()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openBrowse()
        }
    }

    private func openSaved() {
        cancelInteractiveChromeState()
        cancelSearchFocus()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openSaved()
        }
    }

    private func openPractice() {
        cancelInteractiveChromeState()
        cancelSearchFocus()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openPractice()
        }
    }

    private func openPractice(_ action: BrowseCollectionPracticeAction) {
        switch action {
        case .addStarterPages(let pageIDs):
            intentStore.addPracticePages(pageIDs)
            requestedPracticeMode = nil
            requestedPracticeScenarioID = nil
        case .practiceMode(let mode):
            practiceStartRequestID += 1
            requestedPracticeMode = mode
            requestedPracticeScenarioID = nil
        case .practiceScenario(let scenarioID):
            practiceStartRequestID += 1
            requestedPracticeMode = nil
            requestedPracticeScenarioID = scenarioID
        }

        openPractice()
    }

    private func goBack() {
        cancelInteractiveChromeState()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.goBack()
        }
    }

    private func goForward() {
        cancelInteractiveChromeState()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.goForward()
        }
    }

    private func openSearch() {
        openSearch(prefilledQuery: nil, focusField: false)
    }

    private func openSearchQuery(_ query: String) {
        openSearch(prefilledQuery: query, focusField: false)
    }

    private func openSearch(prefilledQuery: String?, focusField: Bool) {
        cancelInteractiveChromeState()
        if let prefilledQuery {
            searchQuery = prefilledQuery
        }

        if !focusField {
            cancelSearchFocus()
        }

        withAnimation(.snappy(duration: AppChromeLayout.searchMorphDuration)) {
            navigation.openSearch()
        }

        if focusField {
            focusSearchField()
        }
    }

    private func closeSearch() {
        cancelSearchFocus()
        cancelInteractiveChromeState()
        withAnimation(.snappy(duration: AppChromeLayout.searchMorphDuration)) {
            navigation.goBack()
        }
    }

    private func focusSearchField() {
        searchFocusRequestID += 1
        let requestID = searchFocusRequestID

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 220_000_000)

            guard requestID == searchFocusRequestID, navigation.isSearchPresented else {
                return
            }

            isSearchFieldFocused = true
        }
    }

    private func applyLaunchSearchFocusIfNeeded() {
        guard !didApplyLaunchSearchFocus else {
            return
        }
        didApplyLaunchSearchFocus = true

        guard launchSearchShouldFocus, navigation.isSearchPresented else {
            return
        }

        focusSearchField()
    }

    private func cancelSearchFocus() {
        searchFocusRequestID += 1
        isSearchFieldFocused = false
    }

    private func clearFocusedSearch() {
        searchQuery = ""
        cancelSearchFocus()
    }

    private func cancelInteractiveChromeState() {
        interactiveDragResolutionID += 1
        dockSelectionTapRequestID += 1
        homePhraseHeroMorphResetID += 1
        homePhraseHeroRoutePageID = nil
        homePhraseHeroMorphPageID = nil
        homePhraseHeroContentHoldPageID = nil
        interactiveDrag = nil
        dockDrag = .inactive
    }

    private func cancelInteractiveDrag() {
        guard let drag = interactiveDrag else {
            return
        }

        interactiveDragResolutionID += 1
        let requestID = interactiveDragResolutionID
        withAnimation(.interactiveSpring(response: 0.24, dampingFraction: 0.9)) {
            interactiveDrag = AppInteractiveNavigationDrag(
                direction: drag.direction,
                translation: AppInteractiveNavigationGesture.cancellationTranslation,
                width: drag.width
            )
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 180_000_000)
            guard requestID == interactiveDragResolutionID else {
                return
            }

            withoutRouteAnimation {
                interactiveDrag = nil
            }
        }
    }

    private func updateInteractiveDrag(_ drag: AppInteractiveNavigationDrag) {
        interactiveDragResolutionID += 1
        interactiveDrag = drag
    }

    private func commitInteractiveSwipe(direction: AppInteractiveNavigationDirection, width: CGFloat) {
        guard let drag = interactiveDrag, drag.direction == direction else {
            return
        }

        interactiveDragResolutionID += 1
        let requestID = interactiveDragResolutionID
        withAnimation(.easeOut(duration: 0.16)) {
            interactiveDrag = AppInteractiveNavigationDrag(
                direction: direction,
                translation: AppInteractiveNavigationGesture.completionTranslation(for: direction, width: width),
                width: drag.width
            )
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 160_000_000)
            guard requestID == interactiveDragResolutionID else {
                return
            }

            withoutRouteAnimation {
                switch direction {
                case .back:
                    navigation.goBack()
                case .forward:
                    navigation.goForward()
                }
                interactiveDrag = nil
            }
        }
    }

    private func withoutRouteAnimation(_ updates: () -> Void) {
        var transaction = Transaction(animation: nil)
        transaction.disablesAnimations = true
        withTransaction(transaction, updates)
    }

    static func initialRoute(for arguments: [String]) -> AppRoute {
        guard
            let flagIndex = arguments.firstIndex(of: "--detail-page"),
            arguments.indices.contains(arguments.index(after: flagIndex))
        else {
            return shortcutRoute(for: arguments)
        }

        let pageID = arguments[arguments.index(after: flagIndex)]
        guard let canonicalPageID = PhraseCatalog.canonicalPageID(forOpenablePageID: pageID) else {
            return shortcutRoute(for: arguments)
        }

        return .detailPage(canonicalPageID)
    }

    private static func shortcutRoute(for arguments: [String]) -> AppRoute {
        if let route = initialBrowseCollectionRoute(for: arguments) {
            return .browseCollection(route)
        }

        if arguments.contains("--browse") {
            return .browse
        }

        if arguments.contains("--practice")
            || arguments.contains("--practice-placement")
            || initialPracticeScenarioID(for: arguments) != nil
            || initialPracticeMode(for: arguments) != nil {
            return .practice
        }

        return arguments.contains("--search") || initialSearchQuery(for: arguments) != nil ? .search : .home
    }

    static func initialBrowseCollectionRoute(for arguments: [String]) -> BrowseCollectionRoute? {
        if
            let flagIndex = arguments.firstIndex(of: "--browse-category"),
            arguments.indices.contains(arguments.index(after: flagIndex)) {
            let id = arguments[arguments.index(after: flagIndex)].trimmingCharacters(in: .whitespacesAndNewlines)
            return id.isEmpty ? nil : .category(id)
        }

        if
            let flagIndex = arguments.firstIndex(of: "--browse-city"),
            arguments.indices.contains(arguments.index(after: flagIndex)) {
            let id = arguments[arguments.index(after: flagIndex)].trimmingCharacters(in: .whitespacesAndNewlines)
            return id.isEmpty ? nil : .city(id)
        }

        return nil
    }

    static func initialPracticeMode(for arguments: [String]) -> PracticeMode? {
        guard
            let flagIndex = arguments.firstIndex(of: "--practice-mode"),
            arguments.indices.contains(arguments.index(after: flagIndex))
        else {
            return nil
        }

        let rawMode = arguments[arguments.index(after: flagIndex)]
        guard let mode = PracticeMode(rawValue: rawMode), mode.isCityMode else {
            return nil
        }

        return mode
    }

    static func initialPracticeScenarioID(for arguments: [String]) -> PracticeScenarioID? {
        guard
            let flagIndex = arguments.firstIndex(of: "--practice-scenario"),
            arguments.indices.contains(arguments.index(after: flagIndex))
        else {
            return nil
        }

        return PracticeScenarioID(rawValue: arguments[arguments.index(after: flagIndex)])
    }

    static func initialPracticeEntryContext(for arguments: [String]) -> PracticeEntryContext {
        arguments.contains("--practice-placement") ? .placement : .standard
    }

    private static var initialPracticeMode: PracticeMode? {
        initialPracticeMode(for: ProcessInfo.processInfo.arguments)
    }

    private static var initialPracticeScenarioID: PracticeScenarioID? {
        initialPracticeScenarioID(for: ProcessInfo.processInfo.arguments)
    }

    private static var initialPracticeEntryContext: PracticeEntryContext {
        initialPracticeEntryContext(for: ProcessInfo.processInfo.arguments)
    }

    static func initialDetailScrollTarget(for arguments: [String]) -> PhraseArticleInitialScrollTarget? {
        guard
            let flagIndex = arguments.firstIndex(of: "--detail-scroll"),
            arguments.indices.contains(arguments.index(after: flagIndex))
        else {
            return nil
        }

        let rawTarget = arguments[arguments.index(after: flagIndex)]
        return PhraseArticleInitialScrollTarget(rawValue: rawTarget)
    }

    private static var initialDetailScrollTarget: PhraseArticleInitialScrollTarget? {
        initialDetailScrollTarget(for: ProcessInfo.processInfo.arguments)
    }

    static func initialSearchQuery(for arguments: [String]) -> String? {
        guard
            let flagIndex = arguments.firstIndex(of: "--search-query"),
            arguments.indices.contains(arguments.index(after: flagIndex))
        else {
            return nil
        }

        let query = arguments[arguments.index(after: flagIndex)].trimmingCharacters(in: .whitespacesAndNewlines)
        return query.isEmpty ? nil : query
    }

    private static var initialSearchQuery: String {
        initialSearchQuery(for: ProcessInfo.processInfo.arguments) ?? ""
    }

    static func initialSearchShouldFocus(for arguments: [String]) -> Bool {
        arguments.contains("--search-focused")
    }

    private static var initialSearchShouldFocus: Bool {
        initialSearchShouldFocus(for: ProcessInfo.processInfo.arguments)
    }

    private static var initialRoute: AppRoute {
        initialRoute(for: ProcessInfo.processInfo.arguments)
    }
}

private struct AppShellNavigationSnapshot: Equatable {
    var rootRoute: AppRoute
    var browseCollectionPath: [BrowseCollectionRoute]
    var detailPath: [String]
    var isSearchPresented: Bool

    var currentRoute: AppRoute {
        if isSearchPresented {
            return .search
        }

        if let detailPageID = detailPath.last {
            return .detailPage(detailPageID)
        }

        if let collectionRoute = browseCollectionPath.last {
            return .browseCollection(collectionRoute)
        }

        return rootRoute
    }
}

struct AppShellNavigationState: Equatable {
    var rootRoute: AppRoute
    var browseCollectionPath: [BrowseCollectionRoute]
    var detailPath: [String]
    var isSearchPresented: Bool
    var forwardStack: [AppRoute] = []
    private var backStack: [AppShellNavigationSnapshot] = []
    var homeScrollToTopTrigger = 0
    var browseScrollToTopTrigger = 0
    var rootScrollToTopTrigger = 0
    var savedScrollToTopTrigger = 0
    var practiceScrollToTopTrigger = 0
    var browseCollectionScrollToTopTrigger = 0
    var browseCollectionScrollToTopRoute: BrowseCollectionRoute?
    var detailScrollToTopTrigger = 0
    var detailScrollToTopRoute: AppRoute?

    init(initialRoute: AppRoute = .home) {
        rootRoute = .home
        browseCollectionPath = []
        detailPath = []
        isSearchPresented = false

        switch initialRoute {
        case .home:
            rootRoute = .home
        case .browse:
            rootRoute = .browse
        case .browseCollection(let route):
            rootRoute = .browse
            browseCollectionPath = [route]
        case .phrasePage:
            rootRoute = .phrasePage
        case .saved:
            rootRoute = .saved
        case .practice:
            rootRoute = .practice
        case .detailPage(let detailPageID):
            rootRoute = .home
            detailPath = [PhraseCatalog.canonicalPageID(forOpenablePageID: detailPageID) ?? detailPageID]
        case .search:
            rootRoute = .home
            isSearchPresented = true
        }
    }

    var currentRoute: AppRoute {
        if isSearchPresented {
            return .search
        }

        if let detailPageID = detailPath.last {
            return .detailPage(detailPageID)
        }

        if let collectionRoute = browseCollectionPath.last {
            return .browseCollection(collectionRoute)
        }

        return rootRoute
    }

    var forwardPreviewRoute: AppRoute? {
        forwardStack.last
    }

    var backPreviewRoute: AppRoute? {
        if isSearchPresented {
            return routeBelowSearch
        }

        if !detailPath.isEmpty {
            guard detailPath.count > 1 else {
                if let collectionRoute = browseCollectionPath.last {
                    return .browseCollection(collectionRoute)
                }

                return rootRoute
            }

            return .detailPage(detailPath[detailPath.count - 2])
        }

        if !browseCollectionPath.isEmpty {
            guard browseCollectionPath.count > 1 else {
                return rootRoute == .home ? .home : .browse
            }

            return .browseCollection(browseCollectionPath[browseCollectionPath.count - 2])
        }

        if let previousRoute = backStack.last?.currentRoute {
            return previousRoute
        }

        if rootRoute == .browse || rootRoute == .phrasePage || rootRoute == .saved || rootRoute == .practice {
            return .home
        }

        return nil
    }

    var searchOriginDockItem: DockItemKind {
        AppChrome(route: routeBelowSearch).selectedDockItem
    }

    var canGoForward: Bool {
        forwardPreviewRoute != nil
    }

    var hasExplicitBackHistory: Bool {
        !backStack.isEmpty
    }

    private var routeBelowSearch: AppRoute {
        if let detailPageID = detailPath.last {
            return .detailPage(detailPageID)
        }

        if let collectionRoute = browseCollectionPath.last {
            return .browseCollection(collectionRoute)
        }

        return rootRoute
    }

    var activeDetailPage: PhraseDetailPage? {
        guard let detailPageID = detailPath.last else {
            return nil
        }

        return PhraseDetailPage.page(withID: detailPageID)
    }

    var renderedDetailPages: [RenderedDetailPage] {
        let lowerBound = max(detailPath.count - 2, 0)

        return detailPath.enumerated()
            .filter { offset, _ in offset >= lowerBound }
            .map { offset, pageID in
                RenderedDetailPage(stackIndex: offset, pageID: pageID)
            }
    }

    var renderedDetailPageIDs: [String] {
        renderedDetailPages.map(\.pageID)
    }

    var renderedBrowseCollections: [RenderedBrowseCollection] {
        let lowerBound = max(browseCollectionPath.count - 2, 0)

        return browseCollectionPath.enumerated()
            .filter { offset, _ in offset >= lowerBound }
            .map { offset, route in
                RenderedBrowseCollection(stackIndex: offset, route: route)
            }
    }

    var canNavigateBackWithSwipe: Bool {
        isSearchPresented
            || !detailPath.isEmpty
            || !browseCollectionPath.isEmpty
            || !backStack.isEmpty
            || rootRoute == .browse
            || rootRoute == .phrasePage
            || rootRoute == .saved
            || rootRoute == .practice
    }

    private var currentSnapshot: AppShellNavigationSnapshot {
        AppShellNavigationSnapshot(
            rootRoute: rootRoute,
            browseCollectionPath: browseCollectionPath,
            detailPath: detailPath,
            isSearchPresented: isSearchPresented
        )
    }

    private mutating func recordCurrentRouteForBackHistory() {
        guard !isSearchPresented else {
            return
        }

        let snapshot = currentSnapshot
        guard backStack.last != snapshot else {
            return
        }

        backStack.append(snapshot)
    }

    private mutating func restore(_ snapshot: AppShellNavigationSnapshot) {
        rootRoute = snapshot.rootRoute
        browseCollectionPath = snapshot.browseCollectionPath
        detailPath = snapshot.detailPath
        isSearchPresented = snapshot.isSearchPresented
    }

    mutating func openDetail(_ id: String) {
        let canonicalPageID = PhraseCatalog.canonicalPageID(forOpenablePageID: id)

        if id == PhrasePage.xinChao.id && canonicalPageID == PhrasePage.xinChao.id {
            guard currentRoute != .phrasePage else {
                rootScrollToTopTrigger += 1
                return
            }

            detailPath.removeAll()
            browseCollectionPath.removeAll()
            isSearchPresented = false
            rootRoute = .phrasePage
            forwardStack.removeAll()
            rootScrollToTopTrigger += 1
            return
        }

        guard let canonicalPageID else {
            return
        }

        guard detailPath.last != canonicalPageID else {
            return
        }

        isSearchPresented = false
        forwardStack.removeAll()
        detailPath.append(canonicalPageID)
        detailScrollToTopRoute = .detailPage(canonicalPageID)
        detailScrollToTopTrigger += 1
    }

    mutating func openHome() {
        guard currentRoute != .home else {
            homeScrollToTopTrigger += 1
            return
        }

        recordCurrentRouteForBackHistory()
        rootRoute = .home
        browseCollectionPath.removeAll()
        detailPath.removeAll()
        isSearchPresented = false
        forwardStack.removeAll()
        homeScrollToTopTrigger += 1
    }

    mutating func openBrowse() {
        guard currentRoute != .browse else {
            browseScrollToTopTrigger += 1
            return
        }

        recordCurrentRouteForBackHistory()
        rootRoute = .browse
        browseCollectionPath.removeAll()
        detailPath.removeAll()
        isSearchPresented = false
        forwardStack.removeAll()
        browseScrollToTopTrigger += 1
    }

    mutating func openSaved() {
        guard currentRoute != .saved else {
            savedScrollToTopTrigger += 1
            return
        }

        recordCurrentRouteForBackHistory()
        rootRoute = .saved
        browseCollectionPath.removeAll()
        detailPath.removeAll()
        isSearchPresented = false
        forwardStack.removeAll()
        savedScrollToTopTrigger += 1
    }

    mutating func openPractice() {
        guard currentRoute != .practice else {
            practiceScrollToTopTrigger += 1
            return
        }

        recordCurrentRouteForBackHistory()
        rootRoute = .practice
        browseCollectionPath.removeAll()
        detailPath.removeAll()
        isSearchPresented = false
        forwardStack.removeAll()
        practiceScrollToTopTrigger += 1
    }

    mutating func openSearch() {
        guard !isSearchPresented else {
            return
        }

        isSearchPresented = true
        forwardStack.removeAll()
    }

    mutating func openBrowseCollection(_ route: BrowseCollectionRoute) {
        guard currentRoute != .browseCollection(route) else {
            browseCollectionScrollToTopRoute = route
            browseCollectionScrollToTopTrigger += 1
            isSearchPresented = false
            return
        }

        rootRoute = .browse
        detailPath.removeAll()
        isSearchPresented = false
        forwardStack.removeAll()

        if browseCollectionPath.last != route {
            browseCollectionPath.append(route)
        }
        browseCollectionScrollToTopRoute = route
        browseCollectionScrollToTopTrigger += 1
    }

    mutating func openHomeBrowseCollection(_ route: BrowseCollectionRoute) {
        guard currentRoute != .browseCollection(route) else {
            browseCollectionScrollToTopRoute = route
            browseCollectionScrollToTopTrigger += 1
            isSearchPresented = false
            return
        }

        rootRoute = .home
        detailPath.removeAll()
        isSearchPresented = false
        forwardStack.removeAll()

        if browseCollectionPath.last != route {
            browseCollectionPath.append(route)
        }
        browseCollectionScrollToTopRoute = route
        browseCollectionScrollToTopTrigger += 1
    }

    mutating func goBack() {
        if isSearchPresented {
            isSearchPresented = false
            forwardStack.append(.search)
            return
        }

        guard !detailPath.isEmpty else {
            if let currentCollection = browseCollectionPath.popLast() {
                forwardStack.append(.browseCollection(currentCollection))
                return
            }

            if let previousSnapshot = backStack.popLast() {
                forwardStack.append(currentRoute)
                restore(previousSnapshot)
                return
            }

            if rootRoute == .browse {
                rootRoute = .home
                forwardStack.append(.browse)
                homeScrollToTopTrigger += 1
            }
            if rootRoute == .phrasePage {
                rootRoute = .home
                forwardStack.append(.phrasePage)
                homeScrollToTopTrigger += 1
            }
            if rootRoute == .saved {
                rootRoute = .home
                forwardStack.append(.saved)
                homeScrollToTopTrigger += 1
            }
            if rootRoute == .practice {
                rootRoute = .home
                forwardStack.append(.practice)
                homeScrollToTopTrigger += 1
            }
            return
        }

        let currentDetailID = detailPath.removeLast()
        forwardStack.append(.detailPage(currentDetailID))
    }

    mutating func goForward() {
        guard let route = forwardStack.popLast() else {
            return
        }

        switch route {
        case .home:
            recordCurrentRouteForBackHistory()
            isSearchPresented = false
            browseCollectionPath.removeAll()
            detailPath.removeAll()
            rootRoute = .home
            homeScrollToTopTrigger += 1
        case .browse:
            recordCurrentRouteForBackHistory()
            isSearchPresented = false
            browseCollectionPath.removeAll()
            detailPath.removeAll()
            rootRoute = .browse
            browseScrollToTopTrigger += 1
        case .browseCollection(let route):
            isSearchPresented = false
            detailPath.removeAll()
            rootRoute = rootRoute == .home ? .home : .browse

            if browseCollectionPath.last != route {
                browseCollectionPath.append(route)
                browseCollectionScrollToTopRoute = route
                browseCollectionScrollToTopTrigger += 1
            }
        case .phrasePage:
            isSearchPresented = false
            browseCollectionPath.removeAll()
            detailPath.removeAll()
            rootRoute = .phrasePage
            rootScrollToTopTrigger += 1
        case .saved:
            recordCurrentRouteForBackHistory()
            isSearchPresented = false
            browseCollectionPath.removeAll()
            detailPath.removeAll()
            rootRoute = .saved
            savedScrollToTopTrigger += 1
        case .practice:
            recordCurrentRouteForBackHistory()
            isSearchPresented = false
            browseCollectionPath.removeAll()
            detailPath.removeAll()
            rootRoute = .practice
            practiceScrollToTopTrigger += 1
        case .detailPage(let detailPageID):
            guard let canonicalPageID = PhraseCatalog.canonicalPageID(forOpenablePageID: detailPageID) else {
                return
            }

            isSearchPresented = false

            if detailPath.last != canonicalPageID {
                detailPath.append(canonicalPageID)
                detailScrollToTopRoute = .detailPage(canonicalPageID)
                detailScrollToTopTrigger += 1
            }
        case .search:
            isSearchPresented = true
        }
    }

    mutating func handleBackSwipe(startX: CGFloat, translation: CGSize) -> Bool {
        guard
            canNavigateBackWithSwipe,
            AppBackSwipeGesturePolicy.isBackSwipe(startX: startX, translation: translation)
        else {
            return false
        }

        if isSearchPresented {
            goBack()
            return true
        }

        goBack()
        return true
    }

    mutating func handleForwardSwipe(translation: CGSize) -> Bool {
        guard
            canGoForward,
            AppForwardSwipeGesturePolicy.isForwardSwipe(translation: translation)
        else {
            return false
        }

        goForward()
        return true
    }
}

struct RenderedDetailPage: Identifiable, Equatable {
    let stackIndex: Int
    let pageID: String

    var id: String {
        "\(stackIndex)-\(pageID)"
    }
}

struct RenderedBrowseCollection: Identifiable, Equatable {
    let stackIndex: Int
    let route: BrowseCollectionRoute

    var id: String {
        "\(stackIndex)-\(route.id)"
    }
}

enum AppBackSwipeGesturePolicy {
    static let captureWidth: CGFloat = 32
    static let edgeStartWidth: CGFloat = 44
    static let minimumDistance: CGFloat = 18
    static let minimumHorizontalTranslation: CGFloat = 72
    static let maximumVerticalTranslation: CGFloat = 80

    static func canTrackBackSwipe(startX: CGFloat, translation: CGSize) -> Bool {
        guard startX >= 0, startX <= edgeStartWidth else {
            return false
        }

        return canTrackBackSwipe(translation: translation)
    }

    static func canTrackBackSwipe(translation: CGSize) -> Bool {
        guard translation.width > 0 else {
            return false
        }

        guard abs(translation.height) <= maximumVerticalTranslation else {
            return false
        }

        return translation.width > abs(translation.height) * 1.12
    }

    static func shouldCommitBackSwipe(
        startX: CGFloat,
        translation: CGSize,
        predictedEndTranslation: CGSize,
        width: CGFloat
    ) -> Bool {
        guard canTrackBackSwipe(startX: startX, translation: translation) else {
            return false
        }

        let distanceThreshold = min(maximumCommitDistance, width * commitProgress)
        return translation.width >= distanceThreshold || predictedEndTranslation.width >= distanceThreshold * 1.2
    }

    static func shouldCommitBackSwipe(
        translation: CGSize,
        predictedEndTranslation: CGSize,
        width: CGFloat
    ) -> Bool {
        guard canTrackBackSwipe(translation: translation) else {
            return false
        }

        let distanceThreshold = min(maximumCommitDistance, width * commitProgress)
        return translation.width >= distanceThreshold || predictedEndTranslation.width >= distanceThreshold * 1.2
    }

    static func isBackSwipe(startX: CGFloat, translation: CGSize) -> Bool {
        canTrackBackSwipe(startX: startX, translation: translation)
            && translation.width >= minimumHorizontalTranslation
    }

    private static let commitProgress: CGFloat = 0.28
    private static let maximumCommitDistance: CGFloat = 128
}

enum AppForwardSwipeGesturePolicy {
    static let captureWidth: CGFloat = 32
    static let edgeStartWidth: CGFloat = 44
    static let minimumDistance: CGFloat = 18
    static let minimumHorizontalTranslation: CGFloat = 72
    static let maximumVerticalTranslation: CGFloat = 80

    static func canTrackForwardSwipe(
        startX: CGFloat,
        containerWidth: CGFloat,
        translation: CGSize
    ) -> Bool {
        let trailingEdgeStart = max(containerWidth - edgeStartWidth, 0)

        guard startX >= trailingEdgeStart, startX <= containerWidth else {
            return false
        }

        return canTrackForwardSwipe(translation: translation)
    }

    static func canTrackForwardSwipe(translation: CGSize) -> Bool {
        guard translation.width < 0 else {
            return false
        }

        guard abs(translation.height) <= maximumVerticalTranslation else {
            return false
        }

        return abs(translation.width) > abs(translation.height) * 1.12
    }

    static func shouldCommitForwardSwipe(
        startX: CGFloat,
        containerWidth: CGFloat,
        translation: CGSize,
        predictedEndTranslation: CGSize,
        width: CGFloat
    ) -> Bool {
        guard canTrackForwardSwipe(
            startX: startX,
            containerWidth: containerWidth,
            translation: translation
        ) else {
            return false
        }

        let distanceThreshold = min(maximumCommitDistance, width * commitProgress)
        return abs(translation.width) >= distanceThreshold || abs(predictedEndTranslation.width) >= distanceThreshold * 1.2
    }

    static func shouldCommitForwardSwipe(
        translation: CGSize,
        predictedEndTranslation: CGSize,
        width: CGFloat
    ) -> Bool {
        guard canTrackForwardSwipe(translation: translation) else {
            return false
        }

        let distanceThreshold = min(maximumCommitDistance, width * commitProgress)
        return abs(translation.width) >= distanceThreshold || abs(predictedEndTranslation.width) >= distanceThreshold * 1.2
    }

    static func isForwardSwipe(translation: CGSize) -> Bool {
        canTrackForwardSwipe(translation: translation)
            && abs(translation.width) >= minimumHorizontalTranslation
    }

    private static let commitProgress: CGFloat = 0.28
    private static let maximumCommitDistance: CGFloat = 128
}

enum AppInteractiveNavigationDirection {
    case back
    case forward
}

struct AppInteractiveNavigationDrag: Equatable {
    let direction: AppInteractiveNavigationDirection
    let translation: CGFloat
    let width: CGFloat

    var progress: CGFloat {
        AppInteractiveNavigationGesture.progress(
            for: translation,
            direction: direction,
            width: width
        )
    }
}

enum AppInteractiveNavigationGesture {
    static func clampedBackTranslation(_ translation: CGFloat, width: CGFloat) -> CGFloat {
        min(max(translation, 0), width)
    }

    static func clampedForwardTranslation(_ translation: CGFloat, width: CGFloat) -> CGFloat {
        max(min(translation, 0), -width)
    }

    static func progress(
        for translation: CGFloat,
        direction: AppInteractiveNavigationDirection,
        width: CGFloat
    ) -> CGFloat {
        let usableWidth = max(width, 1)

        switch direction {
        case .back:
            return min(max(translation / usableWidth, 0), 1)
        case .forward:
            return min(max(abs(translation) / usableWidth, 0), 1)
        }
    }

    static func completionTranslation(
        for direction: AppInteractiveNavigationDirection,
        width: CGFloat
    ) -> CGFloat {
        switch direction {
        case .back:
            return max(width, 1)
        case .forward:
            return -max(width, 1)
        }
    }

    static var cancellationTranslation: CGFloat {
        0
    }
}

struct AppInteractiveNavigationPresentation: Equatable {
    let horizontalOffset: CGFloat
    let opacity: Double
    let scale: CGFloat
    let brightness: Double
    let shadowOpacity: Double
    let shadowXOffset: CGFloat

    static func presentation(
        route: AppRoute,
        currentRoute: AppRoute,
        backPreviewRoute: AppRoute?,
        forwardPreviewRoute: AppRoute?,
        drag: AppInteractiveNavigationDrag?,
        width: CGFloat
    ) -> AppInteractiveNavigationPresentation {
        let isCurrentRoute = route == currentRoute
        guard let drag else {
            return AppInteractiveNavigationPresentation(
                horizontalOffset: 0,
                opacity: isCurrentRoute ? 1 : 0,
                scale: 1,
                brightness: 0,
                shadowOpacity: 0,
                shadowXOffset: 0
            )
        }

        let progress = drag.progress
        let isForwardPreviewRoute = route == forwardPreviewRoute && drag.direction == .forward
        let isBackPreviewRoute = route == backPreviewRoute && drag.direction == .back

        switch drag.direction {
        case .back:
            return AppInteractiveNavigationPresentation(
                horizontalOffset: isCurrentRoute ? drag.translation : 0,
                opacity: (isCurrentRoute || isBackPreviewRoute) ? 1 : 0,
                scale: 1,
                brightness: isCurrentRoute ? 0 : -Double(0.035 * (1 - progress)),
                shadowOpacity: isCurrentRoute ? Double(0.16 * progress) : 0,
                shadowXOffset: -8
            )
        case .forward:
            let horizontalOffset: CGFloat
            if isForwardPreviewRoute {
                horizontalOffset = max(0, width + drag.translation)
            } else {
                horizontalOffset = isCurrentRoute ? drag.translation * 0.18 : 0
            }

            return AppInteractiveNavigationPresentation(
                horizontalOffset: horizontalOffset,
                opacity: (isCurrentRoute || isForwardPreviewRoute) ? 1 : 0,
                scale: 1,
                brightness: isCurrentRoute ? -Double(0.035 * progress) : 0,
                shadowOpacity: (isCurrentRoute || isForwardPreviewRoute) ? Double(0.16 * progress) : 0,
                shadowXOffset: isForwardPreviewRoute ? -8 : 6
            )
        }
    }
}

enum AppPageTransition {
    static let slideFromTrailing = AnyTransition.asymmetric(
        insertion: .move(edge: .trailing).combined(with: .opacity),
        removal: .move(edge: .trailing).combined(with: .opacity)
    )

    static let searchMorph = AnyTransition.asymmetric(
        insertion: .opacity.combined(with: .scale(scale: 0.985, anchor: .bottom)),
        removal: .opacity.combined(with: .scale(scale: 0.985, anchor: .bottom))
    )

    static let phraseHeroMorph = AnyTransition.asymmetric(
        insertion: .opacity.animation(HomePhraseHeroMorphTiming.pageFadeAnimation),
        removal: .opacity.animation(HomePhraseHeroMorphTiming.pageFadeAnimation)
    )
}

enum HomePhraseHeroMorphTiming {
    static let navigationAnimation: Animation = .timingCurve(0.22, 1, 0.36, 1, duration: 0.68)
    static let pageFadeAnimation: Animation = .easeInOut(duration: 0.68)
    static let articleRevealDelayNanoseconds: UInt64 = 320_000_000
    static let articleRevealAnimation: Animation = .easeOut(duration: 0.18)
    static let cleanupDelayNanoseconds: UInt64 = 1_120_000_000
}

private struct AppDockInteractionState: Equatable {
    var startItem: DockItemKind?
    var activeItem: DockItemKind?
    var dragX: CGFloat?
    var predictedDragX: CGFloat?
    var isFingerTracking: Bool
    var didMoveBeyondTap: Bool

    static let inactive = AppDockInteractionState(
        startItem: nil,
        activeItem: nil,
        dragX: nil,
        predictedDragX: nil,
        isFingerTracking: false,
        didMoveBeyondTap: false
    )
}

private struct AppShellBottomChrome: View {
    let route: AppRoute
    let searchOriginDockItem: DockItemKind
    let isSearchFieldFocused: Bool
    @Binding var searchQuery: String
    let searchFieldFocus: FocusState<Bool>.Binding
    let chromeNamespace: Namespace.ID
    let onOpenSearch: () -> Void
    let onCloseSearch: () -> Void
    let onFocusSearchField: () -> Void
    let onClearFocusedSearch: () -> Void
    let onCancelSearchFocus: () -> Void
    let onSelectDockItem: (DockItemKind) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var dockDrag = AppDockInteractionState.inactive
    @State private var dockSelectionTapRequestID = 0

    var body: some View {
        chromeBody
            .onChange(of: route) { _, _ in
                resetDockInteraction()
            }
    }

    @ViewBuilder
    private var chromeBody: some View {
        if #available(iOS 26.0, *) {
            ZStack {
                GlassEffectContainer(spacing: AppChromeLayout.bottomSpacing) {
                    staticBottomChromeGlassContent
                }
                .frame(maxWidth: .infinity)

                searchRouteForegroundControls
            }
            .frame(maxWidth: .infinity)
        } else {
            staticBottomChromeContent
        }
    }

    @ViewBuilder
    private var staticBottomChromeGlassContent: some View {
        HStack(spacing: AppChromeLayout.bottomSpacing) {
            if isSearchRoute {
                if !isKeyboardSearch {
                    searchOriginGlassShell(kind: searchOriginDockItem)
                }
            } else {
                dockCluster(chrome: chrome)
            }

            if isSearchRoute {
                searchFieldGlassShell
            } else {
                collapsedSearchButton
            }

            if isKeyboardSearch {
                searchDismissKeyboardGlassShell
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.snappy(duration: AppChromeLayout.searchMorphDuration), value: isSearchRoute)
        .animation(.snappy(duration: 0.30), value: isSearchFieldFocused)
    }

    @ViewBuilder
    private var searchRouteForegroundControls: some View {
        if isSearchRoute {
            searchForegroundControls(
                isKeyboardSearch: isKeyboardSearch,
                origin: searchOriginDockItem
            )
        }
    }

    @ViewBuilder
    private var staticBottomChromeContent: some View {
        HStack(spacing: AppChromeLayout.bottomSpacing) {
            if isSearchRoute {
                if !isKeyboardSearch {
                    searchOriginFallbackButton(kind: searchOriginDockItem)
                }
            } else {
                dockCluster(chrome: chrome)
            }

            if isSearchRoute {
                searchFieldFallbackCluster
            } else {
                collapsedSearchButton
            }

            if isKeyboardSearch {
                searchDismissKeyboardFallbackButton
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.snappy(duration: AppChromeLayout.searchMorphDuration), value: isSearchRoute)
        .animation(.snappy(duration: 0.30), value: isSearchFieldFocused)
    }

    private var isSearchRoute: Bool {
        route == .search
    }

    private var isKeyboardSearch: Bool {
        isSearchRoute && isSearchFieldFocused
    }

    private var chrome: AppChrome {
        AppChrome(route: route)
    }

    private func dockCluster(chrome: AppChrome) -> some View {
        GeometryReader { proxy in
            let itemCount = chrome.primaryDockItems.count
            let baseContentWidth = AppDockSelectionLayout.contentWidth(itemCount: itemCount)
            let minimumSurfaceWidth = baseContentWidth + AppChromeLayout.dockHorizontalPadding * 2
            let maximumSurfaceWidth = AppChromeLayout.dockMaximumContentWidth + AppChromeLayout.dockHorizontalPadding * 2
            let surfaceWidth = min(max(minimumSurfaceWidth, proxy.size.width), maximumSurfaceWidth)
            let contentWidth = max(baseContentWidth, surfaceWidth - AppChromeLayout.dockHorizontalPadding * 2)
            let selectedIndex = chrome.primaryDockItems.firstIndex(of: chrome.selectedDockItem) ?? 0
            let activeItem = dockDrag.activeItem ?? chrome.selectedDockItem
            let activeIndex = chrome.primaryDockItems.firstIndex(of: activeItem)
            let isPressingDockSelection = dockDrag.dragX != nil
            let isDraggingDockSelection = dockDrag.didMoveBeyondTap
            let lensAnimation = dockSelectionLensAnimation(isFingerTracking: dockDrag.isFingerTracking)
            let lensMetrics = AppDockSelectionLayout.lensMetrics(
                selectedIndex: selectedIndex,
                activeIndex: activeIndex,
                dragX: dockDrag.dragX,
                itemCount: itemCount,
                reduceMotion: reduceMotion,
                contentWidth: contentWidth,
                predictedDragX: dockDrag.predictedDragX
            )
            let dockShape = RoundedRectangle(cornerRadius: AppChromeLayout.dockCornerRadius, style: .continuous)

            ZStack(alignment: .leading) {
                AppShellDockSelectionLens(
                    width: lensMetrics.width,
                    height: lensMetrics.height,
                    isPressed: isPressingDockSelection,
                    isDragging: isDraggingDockSelection,
                    chromeNamespace: chromeNamespace
                )
                .offset(x: lensMetrics.xOffset)
                .animation(lensAnimation, value: lensMetrics)
                .zIndex(AppChromeLayout.dockSelectionLensZIndex)

                HStack(spacing: 0) {
                    ForEach(Array(chrome.primaryDockItems.enumerated()), id: \.element) { index, item in
                        Button {
                            performDockTapAction(item, chrome: chrome, contentWidth: contentWidth)
                        } label: {
                            AppShellDockItem(
                                kind: item,
                                selected: item == activeItem,
                                chromeNamespace: chromeNamespace,
                                isMorphSource: item == chrome.selectedDockItem
                            )
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(item.title)
                        .accessibilityIdentifier("AppChrome.Dock.\(item.title)")
                        .frame(width: AppChromeLayout.dockItemWidth, height: AppChromeLayout.dockItemHeight)
                        .contentShape(Rectangle())

                        if index < chrome.primaryDockItems.count - 1 {
                            Spacer(minLength: AppChromeLayout.dockItemSpacing)
                        }
                    }
                }
                .frame(width: contentWidth)
                .zIndex(AppChromeLayout.dockItemForegroundZIndex)
            }
            .frame(width: contentWidth, height: AppChromeLayout.dockItemHeight)
            .contentShape(Rectangle())
            .simultaneousGesture(
                dockSelectionGesture(chrome: chrome, contentWidth: contentWidth),
                including: .all
            )
            .padding(.horizontal, AppChromeLayout.dockHorizontalPadding)
            .padding(.vertical, AppChromeLayout.dockVerticalPadding)
            .frame(width: surfaceWidth, height: AppChromeLayout.searchIslandSize)
            .background(
                Color.white.opacity(AppChromeLayout.dockBackdropFillOpacity),
                in: dockShape
            )
            .nativeGlass(in: dockShape)
            .appChromeGlassOutline(in: dockShape, prominence: 0.28)
            .nativeGlassMorphID(AppChromeMorphID.dock, namespace: chromeNamespace)
            .chromeMorph(AppChromeMorphID.dock, namespace: chromeNamespace, isSource: !isSearchRoute)
            .contentShape(dockShape)
            .frame(maxWidth: .infinity, alignment: .center)
            .zIndex(AppChromeLayout.dockMorphZIndex)
        }
        .frame(height: AppChromeLayout.searchIslandSize)
        .layoutPriority(1)
    }

    private func dockSelectionGesture(chrome: AppChrome, contentWidth: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                updateDockSelectionDrag(value, chrome: chrome, contentWidth: contentWidth)
            }
            .onEnded { value in
                finishDockSelectionDrag(value, chrome: chrome, contentWidth: contentWidth)
            }
    }

    private func dockSelectionLensAnimation(isFingerTracking: Bool) -> Animation? {
        if isFingerTracking {
            return nil
        }

        return reduceMotion
            ? .easeOut(duration: 0.14)
            : .interactiveSpring(response: 0.24, dampingFraction: 0.78, blendDuration: 0.06)
    }

    private func updateDockSelectionDrag(_ value: DragGesture.Value, chrome: AppChrome, contentWidth: CGFloat) {
        guard let item = dockItem(for: value.location.x, chrome: chrome, contentWidth: contentWidth) else {
            return
        }

        dockSelectionTapRequestID += 1

        let previousItem = dockDrag.activeItem
        let startItem = dockDrag.startItem ?? chrome.selectedDockItem
        let didMoveBeyondTap = dockDrag.didMoveBeyondTap
            || abs(value.translation.width) >= AppChromeLayout.dockSelectionDragCommitDistance
        let activeItem = didMoveBeyondTap ? item : chrome.selectedDockItem
        let dragX = didMoveBeyondTap
            ? value.location.x
            : AppDockSelectionLayout.itemCenterX(
                index: chrome.primaryDockItems.firstIndex(of: chrome.selectedDockItem) ?? 0,
                itemCount: chrome.primaryDockItems.count,
                contentWidth: contentWidth
            )
        let predictedDragX = didMoveBeyondTap ? value.predictedEndLocation.x : dragX

        dockDrag = AppDockInteractionState(
            startItem: startItem,
            activeItem: activeItem,
            dragX: dragX,
            predictedDragX: predictedDragX,
            isFingerTracking: didMoveBeyondTap,
            didMoveBeyondTap: didMoveBeyondTap
        )

        if didMoveBeyondTap, previousItem != nil, previousItem != item {
            playDockCrossingHaptic()
        }
    }

    private func finishDockSelectionDrag(_ value: DragGesture.Value, chrome: AppChrome, contentWidth: CGFloat) {
        let shouldCommitDrag = dockDrag.didMoveBeyondTap
        let item = dockItem(for: value.location.x, chrome: chrome, contentWidth: contentWidth)

        guard shouldCommitDrag, let item else {
            withAnimation(
                reduceMotion
                ? .easeOut(duration: 0.14)
                : .interactiveSpring(response: 0.24, dampingFraction: 0.84, blendDuration: 0.06)
            ) {
                dockDrag = .inactive
            }
            return
        }

        dockSelectionTapRequestID += 1
        let requestID = dockSelectionTapRequestID
        let destinationIndex = chrome.primaryDockItems.firstIndex(of: item) ?? 0
        let destinationX = AppDockSelectionLayout.itemCenterX(
            index: destinationIndex,
            itemCount: chrome.primaryDockItems.count,
            contentWidth: contentWidth
        )

        withAnimation(.interactiveSpring(response: 0.20, dampingFraction: 0.80, blendDuration: 0.05)) {
            dockDrag = AppDockInteractionState(
                startItem: dockDrag.startItem ?? chrome.selectedDockItem,
                activeItem: item,
                dragX: destinationX,
                predictedDragX: destinationX,
                isFingerTracking: false,
                didMoveBeyondTap: true
            )
        }

        commitDockSelectionAction(item, requestID: requestID, deactivateDelay: AppChromeLayout.dockSelectionTapDeactivateDelay)
    }

    private func deactivateDockSelection(requestID: Int, delay: UInt64) {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: delay)
            guard requestID == dockSelectionTapRequestID else {
                return
            }

            withAnimation(.interactiveSpring(response: 0.22, dampingFraction: 0.86, blendDuration: 0.04)) {
                dockDrag = .inactive
            }
        }
    }

    private func commitDockSelectionAction(_ item: DockItemKind, requestID: Int, deactivateDelay: UInt64) {
        onSelectDockItem(item)
        deactivateDockSelection(requestID: requestID, delay: deactivateDelay)
    }

    private func performDockTapAction(_ item: DockItemKind, chrome: AppChrome, contentWidth: CGFloat) {
        guard item != chrome.selectedDockItem, !reduceMotion else {
            onSelectDockItem(item)
            return
        }

        dockSelectionTapRequestID += 1
        let requestID = dockSelectionTapRequestID
        let sourceIndex = chrome.primaryDockItems.firstIndex(of: chrome.selectedDockItem) ?? 0
        let destinationIndex = chrome.primaryDockItems.firstIndex(of: item) ?? sourceIndex
        let sourceX = AppDockSelectionLayout.itemCenterX(
            index: sourceIndex,
            itemCount: chrome.primaryDockItems.count,
            contentWidth: contentWidth
        )
        let destinationX = AppDockSelectionLayout.itemCenterX(
            index: destinationIndex,
            itemCount: chrome.primaryDockItems.count,
            contentWidth: contentWidth
        )

        onCancelSearchFocus()

        withAnimation(.interactiveSpring(response: 0.20, dampingFraction: 0.78, blendDuration: 0.04)) {
            dockDrag = AppDockInteractionState(
                startItem: chrome.selectedDockItem,
                activeItem: chrome.selectedDockItem,
                dragX: sourceX,
                predictedDragX: sourceX,
                isFingerTracking: false,
                didMoveBeyondTap: false
            )
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: AppChromeLayout.dockSelectionTapActivationDelay)
            guard requestID == dockSelectionTapRequestID else {
                return
            }

            playDockCrossingHaptic()
            withAnimation(.interactiveSpring(response: 0.24, dampingFraction: 0.76, blendDuration: 0.06)) {
                dockDrag = AppDockInteractionState(
                    startItem: chrome.selectedDockItem,
                    activeItem: item,
                    dragX: destinationX,
                    predictedDragX: destinationX,
                    isFingerTracking: false,
                    didMoveBeyondTap: true
                )
            }

            try? await Task.sleep(nanoseconds: AppChromeLayout.dockSelectionTapTravelDelay)
            guard requestID == dockSelectionTapRequestID else {
                return
            }

            commitDockSelectionAction(item, requestID: requestID, deactivateDelay: AppChromeLayout.dockSelectionTapDeactivateDelay)
        }
    }

    private func dockItem(for locationX: CGFloat, chrome: AppChrome, contentWidth: CGFloat) -> DockItemKind? {
        guard let index = AppDockSelectionLayout.itemIndex(
            for: locationX,
            itemCount: chrome.primaryDockItems.count,
            contentWidth: contentWidth
        ) else {
            return nil
        }

        return chrome.primaryDockItems[index]
    }

    private func playDockCrossingHaptic() {
        #if canImport(UIKit)
        guard !reduceMotion else {
            return
        }

        UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.55)
        #endif
    }

    private var collapsedSearchButton: some View {
        let shape = Circle()

        return Button {
            onOpenSearch()
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.title2.weight(.medium))
                .foregroundStyle(.primary)
                .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
                .contentShape(shape)
                .chromeIconMorph(AppChromeMorphID.searchIcon, namespace: chromeNamespace, isSource: !isSearchRoute)
        }
        .buttonStyle(.plain)
        .background(
            Color.white.opacity(AppChromeLayout.chromeControlBackdropFillOpacity),
            in: shape
        )
        .nativeGlass(in: shape, interactive: true)
        .appChromeGlassOutline(in: shape, prominence: 0.42)
        .nativeGlassMorphID(AppChromeMorphID.search, namespace: chromeNamespace)
        .chromeMorph(AppChromeMorphID.search, namespace: chromeNamespace, isSource: !isSearchRoute)
        .accessibilityLabel("Search")
        .accessibilityIdentifier("AppChrome.SearchButton")
        .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
        .contentShape(shape)
        .zIndex(AppChromeLayout.searchMorphZIndex)
    }

    private func searchOriginGlassShell(kind _: DockItemKind) -> some View {
        let shape = Circle()

        return Color.clear
            .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
            .contentShape(shape)
            .background(
                Color.white.opacity(AppChromeLayout.chromeControlBackdropFillOpacity),
                in: shape
            )
            .nativeGlass(in: shape, interactive: true)
            .appChromeGlassOutline(in: shape, prominence: 0.34)
            .nativeGlassMorphID(AppChromeMorphID.dock, namespace: chromeNamespace)
            .chromeMorph(AppChromeMorphID.dock, namespace: chromeNamespace, isSource: isSearchRoute)
            .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
            .contentShape(shape)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
            .zIndex(AppChromeLayout.searchOriginMorphZIndex)
    }

    private var searchFieldGlassShell: some View {
        let shape = RoundedRectangle(cornerRadius: AppChromeLayout.searchIslandCornerRadius, style: .continuous)

        return Color.clear
            .frame(height: AppChromeLayout.searchFieldHeight)
            .frame(maxWidth: .infinity)
            .background(
                Color.white.opacity(AppChromeLayout.chromeControlBackdropFillOpacity),
                in: shape
            )
            .nativeGlass(in: shape, interactive: true)
            .appChromeGlassOutline(in: shape, prominence: 0.36)
            .nativeGlassMorphID(AppChromeMorphID.search, namespace: chromeNamespace)
            .chromeMorph(AppChromeMorphID.search, namespace: chromeNamespace, isSource: true)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
            .zIndex(AppChromeLayout.searchMorphZIndex)
    }

    private func searchForegroundControls(isKeyboardSearch: Bool, origin: DockItemKind) -> some View {
        HStack(spacing: AppChromeLayout.bottomSpacing) {
            if !isKeyboardSearch {
                searchOriginForegroundButton(kind: origin)
            }

            searchFieldForegroundCluster

            if isKeyboardSearch {
                searchDismissKeyboardForegroundButton
            }
        }
        .frame(maxWidth: .infinity)
        .compositingGroup()
        .zIndex(AppChromeLayout.searchForegroundMorphZIndex)
    }

    private func searchOriginForegroundButton(kind: DockItemKind) -> some View {
        Button {
            onCloseSearch()
        } label: {
            Image(systemName: kind.symbolName)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
                .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
                .contentShape(Circle())
                .chromeIconMorph(AppChromeMorphID.dockItem(kind), namespace: chromeNamespace, isSource: false)
                .accessibilityIdentifier("AppChrome.SearchForegroundOriginIcon.\(kind.title)")
        }
        .buttonStyle(.plain)
        .accessibilityLabel(kind.title)
        .accessibilityIdentifier("AppChrome.SearchOriginButton.\(kind.title)")
        .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
        .contentShape(Circle())
    }

    private var searchFieldForegroundCluster: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: AppChromeLayout.searchFieldIconSlotWidth)
                .chromeIconMorph(AppChromeMorphID.searchIcon, namespace: chromeNamespace, isSource: isSearchRoute)
                .accessibilityIdentifier("AppChrome.SearchForegroundSearchIcon")

            TextField("Search Vietnamese phrases", text: $searchQuery)
                .font(.body.weight(.semibold))
                .foregroundStyle(.primary)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused(searchFieldFocus)
                .accessibilityIdentifier("AppChrome.SearchField")
                .layoutPriority(1)
        }
        .padding(.horizontal, AppChromeLayout.searchFieldHorizontalPadding)
        .frame(height: AppChromeLayout.searchFieldHeight)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(RoundedRectangle(cornerRadius: AppChromeLayout.searchIslandCornerRadius, style: .continuous))
        .onTapGesture {
            onFocusSearchField()
        }
    }

    private var searchDismissKeyboardGlassShell: some View {
        let shape = Circle()

        return Color.clear
            .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
            .contentShape(shape)
            .background(
                Color.white.opacity(AppChromeLayout.chromeControlBackdropFillOpacity),
                in: shape
            )
            .nativeGlass(in: shape, interactive: true)
            .appChromeGlassOutline(in: shape, prominence: 0.34)
            .nativeGlassMorphID(AppChromeMorphID.searchDismissKeyboard, namespace: chromeNamespace)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
            .zIndex(AppChromeLayout.keyboardDismissMorphZIndex)
    }

    private var searchDismissKeyboardForegroundButton: some View {
        Button {
            onClearFocusedSearch()
        } label: {
            Image(systemName: "xmark")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
                .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(searchQuery.isEmpty ? "Dismiss keyboard" : "Clear search")
        .accessibilityIdentifier("AppChrome.SearchDismissKeyboardButton")
        .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
        .zIndex(AppChromeLayout.keyboardDismissMorphZIndex)
    }

    private func searchOriginFallbackButton(kind: DockItemKind) -> some View {
        let shape = Circle()

        return Button {
            onCloseSearch()
        } label: {
            Image(systemName: kind.symbolName)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
                .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
                .contentShape(shape)
        }
        .buttonStyle(.plain)
        .background(
            Color.white.opacity(AppChromeLayout.chromeControlBackdropFillOpacity),
            in: shape
        )
        .nativeGlass(in: shape, interactive: true)
        .appChromeGlassOutline(in: shape, prominence: 0.34)
        .accessibilityLabel(kind.title)
        .accessibilityIdentifier("AppChrome.SearchOriginButton.\(kind.title)")
        .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
        .contentShape(shape)
        .zIndex(AppChromeLayout.searchOriginMorphZIndex)
    }

    private var searchFieldFallbackCluster: some View {
        let shape = RoundedRectangle(cornerRadius: AppChromeLayout.searchIslandCornerRadius, style: .continuous)

        return HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: AppChromeLayout.searchFieldIconSlotWidth)

            TextField("Search Vietnamese phrases", text: $searchQuery)
                .font(.body.weight(.semibold))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused(searchFieldFocus)
                .accessibilityIdentifier("AppChrome.SearchField")
        }
        .padding(.horizontal, AppChromeLayout.searchFieldHorizontalPadding)
        .frame(height: AppChromeLayout.searchFieldHeight)
        .frame(maxWidth: .infinity)
        .background(
            Color.white.opacity(AppChromeLayout.chromeControlBackdropFillOpacity),
            in: shape
        )
        .nativeGlass(in: shape, interactive: true)
        .appChromeGlassOutline(in: shape, prominence: 0.36)
        .zIndex(AppChromeLayout.searchMorphZIndex)
    }

    private var searchDismissKeyboardFallbackButton: some View {
        let shape = Circle()

        return Button {
            onClearFocusedSearch()
        } label: {
            Image(systemName: "xmark")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
                .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
                .contentShape(shape)
        }
        .buttonStyle(.plain)
        .background(
            Color.white.opacity(AppChromeLayout.chromeControlBackdropFillOpacity),
            in: shape
        )
        .nativeGlass(in: shape, interactive: true)
        .appChromeGlassOutline(in: shape, prominence: 0.34)
        .accessibilityLabel(searchQuery.isEmpty ? "Dismiss keyboard" : "Clear search")
        .accessibilityIdentifier("AppChrome.SearchDismissKeyboardButton")
        .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
        .contentShape(shape)
        .zIndex(AppChromeLayout.keyboardDismissMorphZIndex)
    }

    private func resetDockInteraction() {
        dockSelectionTapRequestID += 1
        dockDrag = .inactive
    }
}

private struct AppChromeGlassOutline<S: InsettableShape>: ViewModifier {
    let shape: S
    var prominence: Double

    func body(content: Content) -> some View {
        let clampedProminence = min(max(prominence, 0), 1)

        content
            .overlay {
                shape
                    .strokeBorder(.white.opacity(0.22 + 0.30 * clampedProminence), lineWidth: 0.45 + 0.35 * clampedProminence)
                    .blendMode(.screen)

                shape
                    .strokeBorder(
                        AngularGradient(
                            colors: [
                                Color(red: 0.35, green: 0.88, blue: 1.0).opacity(0.18 * clampedProminence),
                                Color(red: 0.95, green: 0.42, blue: 1.0).opacity(0.14 * clampedProminence),
                                .white.opacity(0.0),
                                Color(red: 1.0, green: 0.87, blue: 0.36).opacity(0.12 * clampedProminence),
                                Color(red: 0.35, green: 0.88, blue: 1.0).opacity(0.18 * clampedProminence),
                            ],
                            center: .center
                        ),
                        lineWidth: 0.8 + 0.4 * clampedProminence
                    )
                    .blendMode(.screen)

                shape
                    .strokeBorder(Color.black.opacity(0.015 + 0.02 * clampedProminence), lineWidth: 0.5)
                    .blendMode(.multiply)
            }
            .shadow(color: .white.opacity(0.10 + 0.16 * clampedProminence), radius: 10 + 6 * clampedProminence, x: 0, y: 0)
            .shadow(color: .black.opacity(0.035 + 0.04 * clampedProminence), radius: 10 + 8 * clampedProminence, x: 0, y: 4 + 4 * clampedProminence)
    }
}

private extension View {
    func appChromeGlassOutline<S: InsettableShape>(in shape: S, prominence: Double = 1.0) -> some View {
        modifier(AppChromeGlassOutline(shape: shape, prominence: prominence))
    }
}

private struct AppShellDockItem: View {
    let kind: DockItemKind
    let selected: Bool
    var chromeNamespace: Namespace.ID?
    var isMorphSource = false

    var body: some View {
        VStack(spacing: 4) {
            icon

            Text(kind.title)
                .font(.system(size: 13, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.68)
                .frame(maxWidth: AppChromeLayout.dockItemWidth - 4)
        }
        .foregroundStyle(selected ? Color(red: 0.98, green: 0.18, blue: 0.22) : Color.primary.opacity(0.68))
        .frame(width: AppChromeLayout.dockItemWidth, height: AppChromeLayout.dockItemHeight)
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private var icon: some View {
        let image = Image(systemName: kind.symbolName)
            .font(.system(size: 22, weight: .semibold))

        if isMorphSource {
            image.chromeIconMorph(AppChromeMorphID.dockItem(kind), namespace: chromeNamespace, isSource: true)
        } else {
            image
        }
    }
}

private struct AppShellDockSelectionLens: View {
    var width = AppChromeLayout.dockSelectionWidth
    var height = AppChromeLayout.dockSelectionHeight
    var isPressed = false
    var isDragging = false
    var chromeNamespace: Namespace.ID?

    var body: some View {
        let cornerRadius = height / 2
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        let surfaceOpacity = isDragging ? 0.50 : (isPressed ? 0.42 : 0.18)
        let highlightOpacity = isDragging ? 0.34 : (isPressed ? 0.24 : 0.08)
        let edgeProminence = isDragging ? 0.38 : (isPressed ? 0.24 : 0.06)

        ZStack {
            shape
                .fill(Color.white.opacity(surfaceOpacity))

            shape
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.54 + highlightOpacity),
                            Color(red: 0.78, green: 0.94, blue: 1.0).opacity(0.16 + highlightOpacity * 0.44),
                            Color(red: 1.0, green: 0.84, blue: 0.98).opacity(0.10 + highlightOpacity * 0.34),
                            .white.opacity(0.24 + highlightOpacity * 0.5),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .blendMode(.plusLighter)

            if isPressed {
                shape
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.72, green: 0.94, blue: 1.0).opacity(isDragging ? 0.34 : 0.22),
                                .white.opacity(0.0),
                            ],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: isDragging ? 86 : 64
                        )
                    )
                    .blendMode(.screen)

                LinearGradient(
                    colors: [
                        .white.opacity(0.0),
                        .white.opacity(isDragging ? 0.66 : 0.46),
                        .white.opacity(0.0),
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: isDragging ? -10 : -6)
                .blendMode(.screen)

                shape
                    .strokeBorder(
                        AngularGradient(
                            colors: [
                                Color(red: 0.02, green: 0.62, blue: 1.0).opacity(isDragging ? 0.42 : 0.26),
                                Color(red: 0.88, green: 0.18, blue: 1.0).opacity(isDragging ? 0.34 : 0.20),
                                .white.opacity(isDragging ? 0.48 : 0.34),
                                Color(red: 1.0, green: 0.80, blue: 0.10).opacity(isDragging ? 0.30 : 0.18),
                                Color(red: 0.02, green: 0.62, blue: 1.0).opacity(isDragging ? 0.42 : 0.26),
                            ],
                            center: .center
                        ),
                        lineWidth: isDragging ? 2.4 : 1.5
                    )
                    .blendMode(.screen)
            }

            shape
                .stroke(.white.opacity(isPressed ? 0.88 : 0.64), lineWidth: isPressed ? 1.0 : 0.7)
                .blendMode(.screen)

            shape
                .stroke(Color.black.opacity(isPressed ? 0.06 : 0.03), lineWidth: 0.6)
                .blendMode(.multiply)
        }
        .frame(width: width, height: height)
        .clipShape(shape)
        .nativeGlass(cornerRadius: cornerRadius, tint: isPressed ? Color(red: 0.84, green: 0.95, blue: 1.0) : .white, interactive: isPressed)
        .appChromeGlassOutline(in: shape, prominence: edgeProminence)
        .nativeGlassMorphID(AppChromeMorphID.dockSelection, namespace: chromeNamespace)
        .scaleEffect(isDragging ? 1.02 : (isPressed ? 1.01 : 1.0))
        .shadow(color: .white.opacity(isPressed ? 0.54 : 0.22), radius: isPressed ? 24 : 14, x: 0, y: 0)
        .shadow(color: .black.opacity(isPressed ? 0.13 : 0.07), radius: isPressed ? 20 : 12, x: 0, y: isPressed ? 8 : 5)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

private struct NavigationPageMotion: ViewModifier {
    let route: AppRoute
    let currentRoute: AppRoute
    let backPreviewRoute: AppRoute?
    let forwardPreviewRoute: AppRoute?
    let drag: AppInteractiveNavigationDrag?
    let width: CGFloat

    func body(content: Content) -> some View {
        content
            .offset(x: presentation.horizontalOffset)
            .opacity(presentation.opacity)
            .scaleEffect(presentation.scale)
            .brightness(presentation.brightness)
            .shadow(
                color: .black.opacity(presentation.shadowOpacity),
                radius: 22 * progress,
                x: presentation.shadowXOffset,
                y: 0
            )
    }

    private var progress: CGFloat {
        drag?.progress ?? 0
    }

    private var presentation: AppInteractiveNavigationPresentation {
        AppInteractiveNavigationPresentation.presentation(
            route: route,
            currentRoute: currentRoute,
            backPreviewRoute: backPreviewRoute,
            forwardPreviewRoute: forwardPreviewRoute,
            drag: drag,
            width: width
        )
    }
}

private extension View {
    func navigationPageMotion(
        route: AppRoute,
        currentRoute: AppRoute,
        backPreviewRoute: AppRoute?,
        forwardPreviewRoute: AppRoute?,
        drag: AppInteractiveNavigationDrag?,
        width: CGFloat
    ) -> some View {
        modifier(
            NavigationPageMotion(
                route: route,
                currentRoute: currentRoute,
                backPreviewRoute: backPreviewRoute,
                forwardPreviewRoute: forwardPreviewRoute,
                drag: drag,
                width: width
            )
        )
    }
}

// MARK: - Home Surfaces

struct HomeView: View {
    @ObservedObject var intentStore: LocalUserIntentStore

    let scrollToTopTrigger: Int
    let chromeNamespace: Namespace.ID?
    let isSearchActive: Bool
    let heroMorphPageID: String?
    var onSearchTapped: () -> Void
    var onOpenDetail: (String) -> Void
    var onOpenFeaturedDetail: (String) -> Void
    var onOpenCollection: (BrowseCollectionRoute) -> Void
    var onStartPractice: (BrowseCollectionPracticeAction) -> Void
    var onBrowseAllTapped: () -> Void

    init(
        intentStore: LocalUserIntentStore,
        scrollToTopTrigger: Int = 0,
        chromeNamespace: Namespace.ID? = nil,
        isSearchActive: Bool = false,
        heroMorphPageID: String? = nil,
        onSearchTapped: @escaping () -> Void,
        onOpenDetail: @escaping (String) -> Void,
        onOpenFeaturedDetail: @escaping (String) -> Void,
        onOpenCollection: @escaping (BrowseCollectionRoute) -> Void,
        onStartPractice: @escaping (BrowseCollectionPracticeAction) -> Void,
        onBrowseAllTapped: @escaping () -> Void
    ) {
        self.intentStore = intentStore
        self.scrollToTopTrigger = scrollToTopTrigger
        self.chromeNamespace = chromeNamespace
        self.isSearchActive = isSearchActive
        self.heroMorphPageID = heroMorphPageID
        self.onSearchTapped = onSearchTapped
        self.onOpenDetail = onOpenDetail
        self.onOpenFeaturedDetail = onOpenFeaturedDetail
        self.onOpenCollection = onOpenCollection
        self.onStartPractice = onStartPractice
        self.onBrowseAllTapped = onBrowseAllTapped
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: HomeLayout.sectionSpacing) {
                        header
                            .id(Self.scrollTopID)

                        phraseCardTestShelf

                        cityShelf

                        continueShelf
                            .padding(.horizontal, HomeLayout.horizontalPadding)

                        practiceScenariosShelf

                        useNowShelf

                        savedForLaterShelf
                            .padding(.horizontal, HomeLayout.horizontalPadding)

                        relationshipShelf

                        situationShelves

                        practiceListShelf
                            .padding(.horizontal, HomeLayout.horizontalPadding)
                    }
                    .padding(.bottom, HomeLayout.bottomChromeContentClearance)
                }
                .onChange(of: scrollToTopTrigger) { _, _ in
                    scrollProxy.scrollTo(Self.scrollTopID, anchor: .top)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .accessibilityIdentifier("HomeView")
    }

    private static let scrollTopID = "HomeViewTop"

    private var header: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeroMastheadImage()

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    ZStack {
                        Circle().fill(Color.red)
                        Image(systemName: "star.fill")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(.yellow)
                    }
                    .frame(width: 22, height: 22)

                    Text("SPEAKLOCAL VIETNAM")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Text("Start speaking now")
                    .font(.system(size: 36, weight: .black, design: .serif))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.68)

                Text("Offline phrases, audio, and local ways to say it.")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
            }
            .padding(.horizontal, HomeLayout.horizontalPadding)
            .padding(.top, 10)
            .padding(.bottom, 2)
        }
    }

    private var continueShelf: some View {
        HomeShelf(title: "Keep going", subtitle: "Recent pages, saved phrases, and practice") {
            HomeContinuePanel(
                item: continueItem,
                savedCount: savedItems.count,
                practiceCount: practiceItems.count,
                onOpenDetail: onOpenDetail,
                onOpenSavedFallback: {
                    if let pageID = savedItems.first?.pageID {
                        onOpenDetail(pageID)
                    } else {
                        onBrowseAllTapped()
                    }
                },
                onStartPractice: { onStartPractice(.practiceMode(.savedReview)) },
                onBrowseAllTapped: onBrowseAllTapped
            )
        }
    }

    private var useNowShelf: some View {
        HomeShelf(title: "Use now", subtitle: "Quick phrases for everyday moments") {
            HomeQuickPhraseGrid(items: HomeContent.useNowItems, onOpenDetail: onOpenDetail)
        }
        .padding(.leading, HomeLayout.horizontalPadding)
    }

    private var phraseCardTestShelf: some View {
        HomeShelf(title: "Test phrase cards", subtitle: "Larger listen cards for common moments") {
            HomeFeaturedPhraseCarousel(
                items: HomeContent.featuredPhraseCardItems,
                heroMorphPageID: heroMorphPageID,
                chromeNamespace: chromeNamespace,
                onOpenDetail: onOpenFeaturedDetail,
                isSaved: { intentStore.isPageSaved($0) },
                onToggleSaved: { intentStore.toggleSavedPage($0) }
            )
        }
        .padding(.leading, HomeLayout.horizontalPadding)
    }

    private var practiceScenariosShelf: some View {
        HomeShelf(title: "Messages", subtitle: "Practice short trip conversations") {
            HomeScenarioRail(
                scenarios: HomeContent.practiceScenarios,
                onStartPractice: onStartPractice
            )
        }
        .padding(.leading, HomeLayout.horizontalPadding)
    }

    private var savedForLaterShelf: some View {
        HomeShelf(title: "Saved for later", subtitle: "Pages you marked to come back to") {
            HomeSavedPhraseGrid(items: savedForLaterDisplayItems, onOpenDetail: onOpenDetail)
        }
    }

    private var situationShelves: some View {
        HomeShelf(title: "Start with a situation", subtitle: "Go straight to what is happening around you") {
            LazyVStack(spacing: 12) {
                ForEach(HomeContent.situationCards) { card in
                    HomeSituationActionRow(card: card, onOpenCollection: onOpenCollection)
                }
            }
        }
        .padding(.horizontal, HomeLayout.horizontalPadding)
    }

    private var relationshipPhraseGroups: [[PhraseOption]] {
        PhrasePage.xinChao.localGreetings.chunked(into: HomeLayout.relationshipRowsPerGroup)
    }

    private var relationshipShelf: some View {
        HomeShelf(title: "Who are you speaking to?", subtitle: "Pick a warmer hello by age or relationship") {
            HomeRelationshipListCard(
                phrases: Array(PhrasePage.xinChao.localGreetings.prefix(3)),
                onOpenDetail: onOpenDetail
            )
        }
        .padding(.horizontal, HomeLayout.horizontalPadding)
    }

    private var cityShelf: some View {
        HomeShelf(title: "Explore by city", subtitle: "Popular city guides for your trip") {
            HomeCityRail(cities: HomeContent.cityCards, onOpenCollection: onOpenCollection)
        }
        .padding(.leading, HomeLayout.horizontalPadding)
    }

    private var practiceListShelf: some View {
        HomeShelf(title: "Your practice list", subtitle: "Save pages now and rehearse them later") {
            LazyVStack(spacing: 12) {
                HomePracticeListRow(
                    title: "Ready to practice",
                    subtitle: practiceReadySubtitle,
                    symbolName: "bookmark.fill",
                    tintName: .green,
                    action: { onStartPractice(.practiceMode(.savedReview)) }
                )

                HomePracticeListRow(
                    title: "Recently viewed",
                    subtitle: recentlyViewedSubtitle,
                    symbolName: "clock.fill",
                    tintName: .blue,
                    action: {
                        if let pageID = continueItem?.pageID {
                            onOpenDetail(pageID)
                        } else {
                            onBrowseAllTapped()
                        }
                    }
                )

                HomeTipCard()
            }
        }
    }

    private var continueItem: HomePhraseItem? {
        intentStore.recentPageIDs.compactMap(HomePhraseItem.resolve(pageID:)).first
    }

    private var savedItems: [HomePhraseItem] {
        intentStore.savedPageIDs.compactMap(HomePhraseItem.resolve(pageID:))
    }

    private var savedForLaterDisplayItems: [HomePhraseItem] {
        let resolvedSavedItems = Array(savedItems.prefix(2))
        guard resolvedSavedItems.isEmpty else {
            return resolvedSavedItems
        }

        return HomeContent.savedFallbackItems
    }

    private var practiceItems: [HomePhraseItem] {
        intentStore.practicePageIDs.compactMap(HomePhraseItem.resolve(pageID:))
    }

    private var practiceReadySubtitle: String {
        let count = max(savedItems.count, practiceItems.count)
        if count == 0 {
            return "Continue with saved pages"
        }

        return "Continue with \(count) saved \(count == 1 ? "page" : "pages")"
    }

    private var recentlyViewedSubtitle: String {
        let recentTitles = intentStore.recentPageIDs
            .compactMap(HomePhraseItem.resolve(pageID:))
            .prefix(3)
            .map(\.title)

        guard !recentTitles.isEmpty else {
            return "Browse a few pages, then return here"
        }

        return recentTitles.joined(separator: ", ")
    }
}

struct SavedPagesView: View {
    @ObservedObject var intentStore: LocalUserIntentStore

    let scrollToTopTrigger: Int
    var onOpenDetail: (String) -> Void
    var onBrowseTapped: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 18) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Saved")
                                .font(.system(size: 42, weight: .black, design: .serif))
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.78)

                            Text("Phrase pages you marked stay private on this device.")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.top, 76)
                        .id(Self.scrollTopID)

                        if savedItems.isEmpty {
                            savedEmptyState
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(savedItems) { item in
                                    HomeWidePhraseButton(item: item, onOpenDetail: onOpenDetail)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, HomeLayout.horizontalPadding)
                    .padding(.bottom, HomeLayout.bottomChromeContentClearance)
                }
                .onChange(of: scrollToTopTrigger) { _, _ in
                    scrollProxy.scrollTo(Self.scrollTopID, anchor: .top)
                }
            }
        }
        .accessibilityIdentifier("SavedPagesView")
    }

    private static let scrollTopID = "SavedPagesViewTop"

    private var savedItems: [HomePhraseItem] {
        intentStore.savedPageIDs.compactMap(HomePhraseItem.resolve(pageID:))
    }

    private var savedEmptyState: some View {
        Button {
            onBrowseTapped()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "heart")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.red)
                    .frame(width: 46, height: 46)
                    .nativeGlass(cornerRadius: 23, interactive: true)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Save useful phrases as you explore")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Browse the catalog, then tap the heart on a phrase page to keep it here.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .layoutPriority(1)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .phraseListCard(cornerRadius: HomeLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
    }
}

enum HomeLayout {
    static let horizontalPadding: CGFloat = 24
    static let sectionSpacing: CGFloat = 28
    static let cardCornerRadius: CGFloat = 22
    static let largeCardCornerRadius: CGFloat = 28
    static let quickPhraseCardHeight: CGFloat = 122
    static let quickPhraseCardWidth: CGFloat = 146
    static let quickPhraseGridRowSpacing: CGFloat = 12
    static let featurePhraseCardWidth: CGFloat = 344
    static let featurePhraseCardHeight: CGFloat = 326
    static let continuePrimaryIconSize: CGFloat = 58
    static let continueActionHeight: CGFloat = 46
    static let messageContactWidth: CGFloat = 104
    static let messageAvatarSize: CGFloat = 82
    static let messageRailHeight: CGFloat = 134
    static let savedCardHeight: CGFloat = 172
    static let situationRowHeight: CGFloat = 96
    static let situationIconSize: CGFloat = 46
    static let situationImageWidth: CGFloat = 108
    static let situationImageHeight: CGFloat = 68
    static let cityCardWidth: CGFloat = 118
    static let cityCardHeight: CGFloat = 178
    static let relationshipRowsPerGroup = 3
    static let relationshipGroupSpacing: CGFloat = 12
    static let relationshipRowHeight: CGFloat = 102
    static let relationshipGroupVerticalPadding: CGFloat = 10
    static let bottomChromeContentClearance: CGFloat = 224

    static func relationshipGroupHeight(for itemCount: Int) -> CGFloat {
        let visibleRows = max(1, min(itemCount, relationshipRowsPerGroup))
        return (relationshipRowHeight * CGFloat(visibleRows)) + (relationshipGroupVerticalPadding * 2)
    }
}

private struct HomePhraseItem: Identifiable, Equatable {
    let pageID: String
    let title: String
    let subtitle: String
    let symbolName: String
    let tintName: AccentTint
    let audioKey: String?

    var id: String { pageID }

    static func resolve(pageID: String) -> HomePhraseItem? {
        if let item = PhraseCatalog.catalogItem(forOpenablePageID: pageID) {
            return HomePhraseItem(
                pageID: item.pageID,
                title: item.title,
                subtitle: item.subtitle,
                symbolName: item.symbolName,
                tintName: item.tintName,
                audioKey: item.playbackAudioKey
            )
        }

        if pageID == PhrasePage.xinChao.id {
            return HomePhraseItem(
                pageID: PhrasePage.xinChao.id,
                title: PhrasePage.xinChao.title,
                subtitle: PhrasePage.xinChao.intentSummary,
                symbolName: "hand.wave.fill",
                tintName: .red,
                audioKey: PhrasePage.xinChao.quickSay.first?.playbackAudioKey
            )
        }

        if let page = PhraseDetailPage.page(withID: pageID) {
            return HomePhraseItem(
                pageID: page.id,
                title: page.title,
                subtitle: page.englishTitle,
                symbolName: page.iconName,
                tintName: page.tintName,
                audioKey: page.playbackAudioKey
            )
        }

        if let item = PhraseCatalog.allItems.first(where: { $0.pageID == pageID }) {
            return HomePhraseItem(
                pageID: item.pageID,
                title: item.title,
                subtitle: item.subtitle,
                symbolName: item.symbolName,
                tintName: item.tintName,
                audioKey: item.playbackAudioKey
            )
        }

        return nil
    }
}

private struct HomeFeaturePhraseItem: Identifiable, Equatable {
    let pageID: String
    let morphPageID: String
    let title: String
    let englishTitle: String
    let pronunciation: String
    let tintName: AccentTint
    let audioKey: String?

    var id: String { pageID }

    static func resolve(pageID: String) -> HomeFeaturePhraseItem? {
        if pageID == PhrasePage.xinChao.id {
            return HomeFeaturePhraseItem(page: PhrasePage.xinChao.articleTemplate)
        }

        if let page = PhraseDetailPage.page(withID: pageID)?.articleTemplate {
            return HomeFeaturePhraseItem(page: page)
        }

        if let item = HomePhraseItem.resolve(pageID: pageID) {
            return HomeFeaturePhraseItem(
                pageID: item.pageID,
                morphPageID: PhraseCatalog.canonicalPageID(forOpenablePageID: item.pageID) ?? item.pageID,
                title: item.title,
                englishTitle: item.subtitle,
                pronunciation: "",
                tintName: item.tintName,
                audioKey: item.audioKey
            )
        }

        return nil
    }

    private init(page: PhraseArticlePage) {
        self.pageID = page.id
        self.morphPageID = PhraseCatalog.canonicalPageID(forOpenablePageID: page.id) ?? page.id
        self.title = page.title
        self.englishTitle = page.englishTitle
        self.pronunciation = page.pronunciation
        self.tintName = page.tintName
        self.audioKey = page.playbackAudioKey
    }

    private init(
        pageID: String,
        morphPageID: String,
        title: String,
        englishTitle: String,
        pronunciation: String,
        tintName: AccentTint,
        audioKey: String?
    ) {
        self.pageID = pageID
        self.morphPageID = morphPageID
        self.title = title
        self.englishTitle = englishTitle
        self.pronunciation = pronunciation
        self.tintName = tintName
        self.audioKey = audioKey
    }
}

private struct HomeScenario: Identifiable {
    let scenarioID: PracticeScenarioID

    var id: String { scenarioID.rawValue }
    var practiceAction: BrowseCollectionPracticeAction { .practiceScenario(scenarioID) }
}

private struct HomeSituationCard: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let imageName: String
    let route: BrowseCollectionRoute
}

private struct HomeCityCard: Identifiable {
    let id: String
    let title: String
    let imageName: String
    let route: BrowseCollectionRoute
}

private struct HomeSituationGroup: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let categoryIDs: [String]
    let symbolName: String
    let tintName: AccentTint

    var items: [PhraseCatalogItem] {
        categoryIDs.flatMap { categoryID in
            PhraseCatalog.items(selectedCategoryID: categoryID).prefix(2)
        }
        .uniquedByPageID()
    }

    var firstOpenablePageID: String? {
        items.first?.pageID
    }
}

enum HomeUseNowCatalog {
    static let starterIDs = [
        PhrasePage.xinChao.id,
        "viet-thank-you",
        "viet-excuse-sorry",
        "viet-family-polite-its-okay",
        "viet-goodbye",
        "viet-family-repair-understand",
        "viet-family-repair-slower",
        "viet-family-repair-repeat",
        "viet-family-service-water",
        "viet-family-food-menu",
        "viet-family-food-pay-now",
        "viet-family-bathroom-where",
    ]
}

private enum HomeContent {
    static let useNowIDs = HomeUseNowCatalog.starterIDs

    static let featuredIDs = [
        "viet-thank-you",
        PhrasePage.xinChao.id,
        "viet-excuse-sorry",
        "viet-family-repair-meaning",
        "viet-family-hotel-checkout-time",
    ]

    static var useNowItems: [HomePhraseItem] {
        useNowIDs.compactMap(HomePhraseItem.resolve(pageID:))
    }

    static var savedFallbackItems: [HomePhraseItem] {
        [
            "viet-phrase-v500-unde-repa-can-you-show-me-a-picture",
            "viet-phrase-hotel-3",
        ].compactMap(HomePhraseItem.resolve(pageID:))
    }

    static var featuredItems: [HomePhraseItem] {
        featuredIDs.compactMap(HomePhraseItem.resolve(pageID:))
    }

    static var featuredPhraseCardItems: [HomeFeaturePhraseItem] {
        featuredIDs.compactMap(HomeFeaturePhraseItem.resolve(pageID:))
    }

    static var practiceScenarios: [HomeScenario] {
        [
            .danangFirstDay,
            .hotelCheckInHelp,
            .taxiGrabPickup,
            .pharmacyHelp,
            .danangDay,
            .restaurantOrderingPayment,
        ].map { HomeScenario(scenarioID: $0) }
    }

    static let situationCards = [
        HomeSituationCard(
            id: "arrival",
            title: "Arrival and getting around",
            subtitle: "Airports, taxis, directions, transport, tickets",
            imageName: "HomeSituationArrival",
            route: .category("airport")
        ),
        HomeSituationCard(
            id: "food-shopping",
            title: "Food and shopping",
            subtitle: "Restaurants, markets, items, prices",
            imageName: "HomeSituationFoodShopping",
            route: .category("food")
        ),
        HomeSituationCard(
            id: "help-health",
            title: "Help and health",
            subtitle: "Asking for help, pharmacies, health, emergencies",
            imageName: "HomeSituationHelpHealth",
            route: .category("emergency")
        ),
    ]

    static var cityCards: [HomeCityCard] {
        BrowseSearchDestinations.homepageCityShortcuts.map { city in
            HomeCityCard(
                id: city.id,
                title: homeCityTitle(for: city.id, fallback: city.title),
                imageName: homeCityImageName(for: city.id),
                route: city.collectionRoute
            )
        }
    }

    private static func homeCityTitle(for cityID: String, fallback: String) -> String {
        switch cityID {
        case "hoian":
            return "Hội An"
        case "hanoi":
            return "Hà Nội"
        case "hue":
            return "Huế"
        default:
            return fallback
        }
    }

    private static func homeCityImageName(for cityID: String) -> String {
        switch cityID {
        case "danang":
            return "HomeCityDaNang"
        case "hoian":
            return "HomeCityHoiAn"
        case "hcmc":
            return "HomeCityHCMC"
        case "hanoi":
            return "HomeCityHanoi"
        case "hue":
            return "HomeCityHue"
        default:
            return BrowseSearchDestinations.collectionDescriptor(for: .city(cityID))?.mastheadImageName
                ?? "HeroVietnamMasthead"
        }
    }

    static let situationGroups = [
        HomeSituationGroup(
            id: "arrival",
            title: "Arrival and getting around",
            subtitle: "Airport, taxis, directions, SIM cards",
            categoryIDs: ["airport-border-arrival", "transport", "directions-navigation", "phone-internet-power"],
            symbolName: "location.fill",
            tintName: .blue
        ),
        HomeSituationGroup(
            id: "food-money-shopping",
            title: "Food, money, and shopping",
            subtitle: "Order, pay, ask prices, buy what you need",
            categoryIDs: ["food-drink", "money-numbers-prices", "shopping"],
            symbolName: "creditcard.fill",
            tintName: .green
        ),
        HomeSituationGroup(
            id: "help-health",
            title: "Help and health",
            subtitle: "Understand, explain problems, get help calmly",
            categoryIDs: ["understanding-repair", "problems-help", "health-pharmacy", "emergency-safety"],
            symbolName: "cross.case.fill",
            tintName: .red
        ),
        HomeSituationGroup(
            id: "everyday",
            title: "Everyday basics",
            subtitle: "Polite basics, bathroom, time, local services",
            categoryIDs: ["polite-basics", "bathroom-personal-needs", "time-dates-booking", "local-services-everyday-tasks", "sightseeing-activities"],
            symbolName: "sparkles",
            tintName: .orange
        ),
    ]
}

private struct HomeShelf<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, subtitle _: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            content
        }
    }
}

private struct HomeContinuePanel: View {
    let item: HomePhraseItem?
    let savedCount: Int
    let practiceCount: Int
    let onOpenDetail: (String) -> Void
    let onOpenSavedFallback: () -> Void
    let onStartPractice: () -> Void
    let onBrowseAllTapped: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Button(action: primaryAction) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(primaryTint.color.opacity(0.14))
                            .overlay {
                                Circle().stroke(.white.opacity(0.76), lineWidth: 1)
                            }

                        Image(systemName: primarySymbolName)
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundStyle(primaryTint.color)
                    }
                    .frame(width: HomeLayout.continuePrimaryIconSize, height: HomeLayout.continuePrimaryIconSize)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(item == nil ? "Start here" : "Last viewed")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(primaryTint.color)
                            .textCase(.uppercase)

                        Text(primaryTitle)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.78)

                        Text(primarySubtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)

                    Image(systemName: "chevron.right")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.tertiary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("Home.ContinuePrimary")

            HStack(spacing: 10) {
                HomeContinueActionPill(
                    title: savedActionTitle,
                    symbolName: "heart.fill",
                    tintName: .red,
                    action: onOpenSavedFallback
                )

                HomeContinueActionPill(
                    title: practiceActionTitle,
                    symbolName: "play.fill",
                    tintName: .green,
                    action: onStartPractice
                )
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .homeGlassCard(cornerRadius: HomeLayout.largeCardCornerRadius)
        .accessibilityIdentifier("Home.ContinuePanel")
    }

    private var primaryTitle: String {
        item?.title ?? "Browse phrases"
    }

    private var primarySubtitle: String {
        item?.subtitle ?? "Pick a useful page to save or practice."
    }

    private var primarySymbolName: String {
        item?.symbolName ?? "square.grid.2x2.fill"
    }

    private var primaryTint: AccentTint {
        item?.tintName ?? .blue
    }

    private var savedActionTitle: String {
        savedCount == 0 ? "Saved phrases" : "\(savedCount) saved"
    }

    private var practiceActionTitle: String {
        practiceCount == 0 ? "Practice list" : "\(practiceCount) practice"
    }

    private func primaryAction() {
        if let item {
            onOpenDetail(item.pageID)
        } else {
            onBrowseAllTapped()
        }
    }
}

private struct HomeContinueActionPill: View {
    let title: String
    let symbolName: String
    let tintName: AccentTint
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 7) {
                Image(systemName: symbolName)
                    .font(.caption.weight(.bold))

                Text(title)
                    .font(.subheadline.weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.76)
            }
            .foregroundStyle(tintName.color)
            .frame(maxWidth: .infinity)
            .frame(height: HomeLayout.continueActionHeight)
            .background(tintName.color.opacity(0.10), in: Capsule(style: .continuous))
            .overlay {
                Capsule(style: .continuous)
                    .stroke(tintName.color.opacity(0.18), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct HomeQuickPhraseGrid: View {
    let items: [HomePhraseItem]
    let onOpenDetail: (String) -> Void

    private let rows = [
        GridItem(.fixed(HomeLayout.quickPhraseCardHeight), spacing: HomeLayout.quickPhraseGridRowSpacing),
        GridItem(.fixed(HomeLayout.quickPhraseCardHeight), spacing: 0),
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, alignment: .top, spacing: 12) {
                ForEach(items) { item in
                    HomeQuickPhraseCard(item: item, onOpenDetail: onOpenDetail)
                }
            }
            .padding(.trailing, HomeLayout.horizontalPadding)
            .padding(.bottom, 2)
        }
        .frame(height: HomeLayout.quickPhraseCardHeight * 2 + HomeLayout.quickPhraseGridRowSpacing)
        .scrollClipDisabled()
    }
}

private struct HomeFeaturedPhraseCarousel: View {
    let items: [HomeFeaturePhraseItem]
    let heroMorphPageID: String?
    let chromeNamespace: Namespace.ID?
    let onOpenDetail: (String) -> Void
    let isSaved: (String) -> Bool
    let onToggleSaved: (String) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(items) { item in
                    HomeFeaturedPhraseCard(
                        item: item,
                        isSaved: isSaved(item.pageID),
                        isHeroMorphSource: heroMorphPageID == item.morphPageID,
                        chromeNamespace: chromeNamespace,
                        onOpenDetail: onOpenDetail,
                        onToggleSaved: { onToggleSaved(item.pageID) }
                    )
                }
            }
            .scrollTargetLayout()
            .padding(.trailing, HomeLayout.horizontalPadding)
            .padding(.bottom, 3)
        }
        .frame(height: HomeLayout.featurePhraseCardHeight)
        .scrollTargetBehavior(.viewAligned)
        .scrollClipDisabled()
    }
}

private struct HomeFeaturedPhraseCard: View {
    let item: HomeFeaturePhraseItem
    let isSaved: Bool
    let isHeroMorphSource: Bool
    let chromeNamespace: Namespace.ID?
    let onOpenDetail: (String) -> Void
    let onToggleSaved: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 12) {
                Button {
                    onOpenDetail(item.pageID)
                } label: {
                    PhraseHeroCopyStack(
                        title: item.title,
                        englishTitle: item.englishTitle,
                        pronunciation: item.pronunciation,
                        titleSize: 42,
                        pronunciationLineLimit: 1,
                        morphPageID: item.morphPageID,
                        morphNamespace: chromeNamespace,
                        isMorphActive: isHeroMorphSource,
                        isMorphSource: true
                    )
                    .padding(.trailing, 48)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("HomeFeaturedPhrase.Open.\(item.pageID)")
                .zIndex(isHeroMorphSource ? 4 : 0)

                Spacer(minLength: 0)

                PlaybackDockView(
                    audioKey: item.audioKey,
                    isSaved: isSaved,
                    onToggleSaved: onToggleSaved
                )
                .homePhraseHeroMorph(
                    HomePhraseHeroMorphID.player(item.morphPageID),
                    namespace: chromeNamespace,
                    isActive: isHeroMorphSource,
                    isSource: true,
                    anchor: .topLeading
                )
                .zIndex(isHeroMorphSource ? 3 : 0)
            }
            .padding(.horizontal, 18)
            .padding(.top, 22)
            .padding(.bottom, 14)
            .frame(width: HomeLayout.featurePhraseCardWidth, height: HomeLayout.featurePhraseCardHeight, alignment: .topLeading)
            .background(.white.opacity(0.64), in: RoundedRectangle(cornerRadius: 32, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(.white.opacity(0.72), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.07), radius: 22, x: 0, y: 14)
            .nativeGlass(cornerRadius: 32)
        }
        .accessibilityIdentifier("HomeFeaturedPhrase.\(item.pageID)")
    }
}

private struct HomeQuickPhraseCard: View {
    let item: HomePhraseItem
    let onOpenDetail: (String) -> Void

    var body: some View {
        Button {
            onOpenDetail(item.pageID)
        } label: {
            VStack(spacing: 8) {
                AudioSpeakerButton(
                    tint: item.tintName,
                    size: 52,
                    audioKey: item.audioKey,
                    accessibilityIdentifier: "HomeQuick.Audio.\(item.pageID)"
                )
                .frame(height: 56)

                VStack(spacing: 3) {
                    Text(item.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.72)

                    Text(item.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.78)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            .frame(width: HomeLayout.quickPhraseCardWidth, height: HomeLayout.quickPhraseCardHeight)
            .homeGlassCard(cornerRadius: HomeLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("HomeQuick.\(item.pageID)")
    }
}

private struct HomeScenarioRail: View {
    let scenarios: [HomeScenario]
    let onStartPractice: (BrowseCollectionPracticeAction) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: 8) {
                ForEach(scenarios) { scenario in
                    HomeScenarioContactButton(
                        scenario: scenario,
                        onStartPractice: onStartPractice
                    )
                }
            }
            .padding(.trailing, HomeLayout.horizontalPadding)
            .padding(.bottom, 2)
        }
        .frame(height: HomeLayout.messageRailHeight)
        .scrollClipDisabled()
    }
}

private struct HomeScenarioContactButton: View {
    let scenario: HomeScenario
    let onStartPractice: (BrowseCollectionPracticeAction) -> Void

    var body: some View {
        Button {
            onStartPractice(scenario.practiceAction)
        } label: {
            VStack(spacing: 9) {
                PracticeMessageAvatar(
                    scenarioID: scenario.scenarioID,
                    size: HomeLayout.messageAvatarSize,
                    showsSymbol: true
                )

                Text(scenario.scenarioID.messageContactName)
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)
                    .frame(height: 38, alignment: .top)
            }
            .frame(width: HomeLayout.messageContactWidth, alignment: .top)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(scenario.scenarioID.messageContactName)
        .accessibilityIdentifier("HomeScenario.\(scenario.id)")
    }
}

private struct HomeSavedPhraseGrid: View {
    let items: [HomePhraseItem]
    let onOpenDetail: (String) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(items) { item in
                HomeSavedPhraseCard(item: item, onOpenDetail: onOpenDetail)
            }
        }
    }
}

private struct HomeSavedPhraseCard: View {
    let item: HomePhraseItem
    let onOpenDetail: (String) -> Void

    var body: some View {
        Button {
            onOpenDetail(item.pageID)
        } label: {
            VStack(spacing: 14) {
                AudioSpeakerButton(
                    tint: item.tintName,
                    size: 52,
                    audioKey: item.audioKey,
                    accessibilityIdentifier: "HomeSaved.Audio.\(item.pageID)"
                )
                .frame(height: 56)

                VStack(spacing: 5) {
                    Text(item.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.68)

                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.76)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity)
            .frame(height: HomeLayout.savedCardHeight)
            .homeGlassCard(cornerRadius: HomeLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("HomeSaved.\(item.pageID)")
    }
}

private struct HomeRelationshipListCard: View {
    let phrases: [PhraseOption]
    let onOpenDetail: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(phrases) { phrase in
                HomeRelationshipListRow(phrase: phrase, onOpenDetail: onOpenDetail)
                    .frame(height: HomeLayout.relationshipRowHeight)

                if phrase.id != phrases.last?.id {
                    Divider().padding(.leading, 92)
                }
            }
        }
        .padding(.vertical, HomeLayout.relationshipGroupVerticalPadding)
        .homeGlassCard(cornerRadius: HomeLayout.largeCardCornerRadius)
    }
}

private struct HomeRelationshipListRow: View {
    let phrase: PhraseOption
    let onOpenDetail: (String) -> Void

    var body: some View {
        HStack(spacing: 16) {
            HomeRelationshipAvatar(tint: phrase.tintName, symbolName: avatarSymbolName)

            Button {
                if let detailPageID = phrase.detailPageID {
                    onOpenDetail(detailPageID)
                }
            } label: {
                VStack(alignment: .leading, spacing: 5) {
                    Text(phrase.vietnamese)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.74)

                    Text(phrase.english)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.76)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            AudioSpeakerButton(
                tint: phrase.tintName,
                size: 50,
                audioKey: phrase.playbackAudioKey,
                accessibilityIdentifier: "HomeRelationship.Audio.\(phrase.id)"
            )
        }
        .padding(.horizontal, 16)
    }

    private var avatarSymbolName: String {
        switch phrase.id {
        case "anh":
            return "person.fill"
        case "chi":
            return "person.fill"
        case "em":
            return "figure.child"
        default:
            return "person.fill"
        }
    }
}

private struct HomeRelationshipAvatar: View {
    let tint: AccentTint
    let symbolName: String

    var body: some View {
        ZStack {
            Circle()
                .fill(tint.color.opacity(0.12))
                .overlay {
                    Circle().stroke(.white.opacity(0.72), lineWidth: 1)
                }

            Image(systemName: symbolName)
                .font(.system(size: 27, weight: .semibold))
                .foregroundStyle(tint.color)
        }
        .frame(width: 62, height: 62)
    }
}

private struct HomeSituationActionRow: View {
    let card: HomeSituationCard
    let onOpenCollection: (BrowseCollectionRoute) -> Void

    var body: some View {
        Button {
            onOpenCollection(card.route)
        } label: {
            HStack(spacing: 18) {
                Image(card.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: HomeLayout.situationImageWidth, height: HomeLayout.situationImageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                VStack(alignment: .leading, spacing: 5) {
                    Text(card.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.78)

                    Text(card.subtitle)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.76)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .frame(height: HomeLayout.situationRowHeight)
            .homeGlassCard(cornerRadius: HomeLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("HomeSituation.\(card.id)")
    }
}

private struct HomeCityRail: View {
    let cities: [HomeCityCard]
    let onOpenCollection: (BrowseCollectionRoute) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(cities) { city in
                    HomeCityCardView(city: city, onOpenCollection: onOpenCollection)
                }
            }
            .scrollTargetLayout()
            .padding(.trailing, HomeLayout.horizontalPadding)
            .padding(.bottom, 4)
        }
        .frame(height: HomeLayout.cityCardHeight + 4)
        .scrollTargetBehavior(.viewAligned)
        .scrollClipDisabled()
        .accessibilityIdentifier("HomeCityRail")
    }
}

private struct HomeCityCardView: View {
    let city: HomeCityCard
    let onOpenCollection: (BrowseCollectionRoute) -> Void

    var body: some View {
        Button {
            onOpenCollection(city.route)
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                Image(city.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: HomeLayout.cityCardWidth, height: 122)
                    .clipped()

                HStack(spacing: 6) {
                    Text(city.title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.64)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 2)

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 12)
                .frame(height: 56)
            }
            .frame(width: HomeLayout.cityCardWidth, height: HomeLayout.cityCardHeight)
            .clipShape(RoundedRectangle(cornerRadius: HomeLayout.cardCornerRadius, style: .continuous))
            .homeGlassCard(cornerRadius: HomeLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("HomeCity.\(city.id)")
    }
}

private struct HomePracticeListRow: View {
    let title: String
    let subtitle: String
    let symbolName: String
    let tintName: AccentTint
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 18) {
                Image(systemName: symbolName)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(tintName.color)
                    .frame(width: 62, height: 62)
                    .nativeGlass(cornerRadius: 31, tint: tintName.color.opacity(0.32), interactive: true)

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(subtitle)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.76)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .homeGlassCard(cornerRadius: HomeLayout.largeCardCornerRadius)
        }
        .buttonStyle(.plain)
    }
}

private struct HomeTipCard: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "lightbulb.fill")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color(red: 0.82, green: 0.53, blue: 0.08))
                .frame(width: 62, height: 62)
                .nativeGlass(cornerRadius: 31, tint: Color(red: 0.82, green: 0.53, blue: 0.08).opacity(0.24))

            VStack(alignment: .leading, spacing: 5) {
                Text("Tip")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)

                Text("Save phrases as you browse so Practice is ready when you need it.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 1.0, green: 0.94, blue: 0.78).opacity(0.18), in: RoundedRectangle(cornerRadius: HomeLayout.cardCornerRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: HomeLayout.cardCornerRadius, style: .continuous)
                .stroke(Color(red: 0.82, green: 0.53, blue: 0.08).opacity(0.28), lineWidth: 1)
        }
    }
}

private extension View {
    func homeGlassCard(cornerRadius: CGFloat) -> some View {
        self
            .background(.white.opacity(0.58), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.white.opacity(0.72), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.055), radius: 18, x: 0, y: 10)
            .nativeGlass(cornerRadius: cornerRadius)
    }
}

private struct HomeHorizontalPhraseShelf: View {
    let title: String
    let subtitle: String
    let items: [HomePhraseItem]
    let onOpenDetail: (String) -> Void

    var body: some View {
        if !items.isEmpty {
            HomeShelf(title: title, subtitle: subtitle) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(items) { item in
                            HomePhraseCard(item: item, onOpenDetail: onOpenDetail)
                        }
                    }
                    .padding(.trailing, HomeLayout.horizontalPadding)
                    .padding(.bottom, 2)
                }
                .scrollClipDisabled()
            }
            .padding(.leading, HomeLayout.horizontalPadding)
        }
    }
}

private struct HomeWidePhraseButton: View {
    let item: HomePhraseItem
    let onOpenDetail: (String) -> Void

    var body: some View {
        HStack(spacing: 12) {
            AudioSpeakerButton(
                tint: item.tintName,
                audioKey: item.audioKey,
                accessibilityIdentifier: "HomePhrase.Audio.\(item.pageID)"
            )

            Button {
                onOpenDetail(item.pageID)
            } label: {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.title)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(item.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .layoutPriority(1)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            .accessibilityIdentifier("HomePhrase.\(item.pageID)")
        }
        .padding(14)
        .phraseListCard(cornerRadius: HomeLayout.cardCornerRadius)
    }
}

private struct HomePhraseCard: View {
    let item: HomePhraseItem
    let onOpenDetail: (String) -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                onOpenDetail(item.pageID)
            } label: {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: item.symbolName)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(item.tintName.color)
                            .frame(width: 44, height: 44)
                            .nativeGlass(cornerRadius: 22)

                        Spacer()
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.78)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(item.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .layoutPriority(1)

                    HStack {
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.tertiary)
                    }
                }
                .padding(14)
                .frame(width: 152, height: 190, alignment: .topLeading)
                .phraseListCard(cornerRadius: HomeLayout.cardCornerRadius)
                .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 10)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("HomePhrase.\(item.pageID)")

            AudioSpeakerButton(
                tint: item.tintName,
                size: 38,
                audioKey: item.audioKey,
                accessibilityIdentifier: "HomePhrase.Audio.\(item.pageID)"
            )
            .padding(14)
        }
    }
}

private struct HomeSituationGroupRow: View {
    let group: HomeSituationGroup
    let onOpenDetail: (String) -> Void

    var body: some View {
        Button {
            if let pageID = group.firstOpenablePageID {
                onOpenDetail(pageID)
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: group.symbolName)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(group.tintName.color)
                    .frame(width: HomeLayout.situationIconSize, height: HomeLayout.situationIconSize)
                    .nativeGlass(cornerRadius: 23, interactive: true)

                VStack(alignment: .leading, spacing: 4) {
                    Text(group.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)

                    Text(group.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(1)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .frame(
                maxWidth: .infinity,
                minHeight: HomeLayout.situationRowHeight,
                maxHeight: HomeLayout.situationRowHeight,
                alignment: .leading
            )
            .phraseListCard(cornerRadius: HomeLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

private struct HomeRelationshipGroupCard: View {
    let phrases: [PhraseOption]
    let width: CGFloat
    let onOpenDetail: (String) -> Void

    private var cardHeight: CGFloat {
        HomeLayout.relationshipGroupHeight(for: phrases.count)
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(phrases) { phrase in
                HomeRelationshipRow(phrase: phrase, onOpenDetail: onOpenDetail)
                    .frame(height: HomeLayout.relationshipRowHeight)

                if phrase.id != phrases.last?.id {
                    Divider().padding(.leading, 72)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, HomeLayout.relationshipGroupVerticalPadding)
        .frame(width: width, height: cardHeight, alignment: .top)
        .phraseListCard(cornerRadius: HomeLayout.cardCornerRadius)
    }
}

private struct HomeRelationshipRow: View {
    let phrase: PhraseOption
    let onOpenDetail: (String) -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: phrase.symbolName)
                .font(.headline.weight(.semibold))
                .foregroundStyle(phrase.tintName.color)
                .frame(width: 46, height: 46)
                .nativeGlass(cornerRadius: 23, interactive: true)

            if let detailPageID = phrase.detailPageID {
                Button {
                    onOpenDetail(detailPageID)
                } label: {
                    rowContent(showsChevron: true)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            } else {
                rowContent(showsChevron: false)
            }

            AudioSpeakerButton(
                tint: phrase.tintName,
                size: 34,
                audioKey: phrase.playbackAudioKey,
                accessibilityIdentifier: "HomeRelationship.Audio.\(phrase.id)"
            )
        }
        .padding(.horizontal, 14)
    }

    private func rowContent(showsChevron: Bool) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(phrase.vietnamese)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.74)

                Text(phrase.english)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .layoutPriority(1)

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else {
            return []
        }

        return stride(from: 0, to: count, by: size).map { startIndex in
            Array(self[startIndex..<Swift.min(startIndex + size, count)])
        }
    }
}

private extension Array where Element == PhraseCatalogItem {
    func uniquedByPageID() -> [PhraseCatalogItem] {
        var seen = Set<String>()
        return filter { item in
            seen.insert(item.pageID).inserted
        }
    }
}
