import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct AppShellView: View {
    @State private var navigation: AppShellNavigationState
    @State private var interactiveDrag: AppInteractiveNavigationDrag?
    @State private var interactiveDragResolutionID = 0
    @State private var searchQuery: String
    @State private var searchFocusRequestID = 0
    @State private var didApplyLaunchSearchFocus = false
    @State private var practiceStartRequestID = 0
    @State private var requestedPracticeMode: PracticeMode?
    @State private var requestedPracticeScenarioID: PracticeScenarioID?
    @State private var requestedPracticeScenarioThreadDismissal = PracticeScenarioThreadDismissal.messagesHub
    @State private var pendingPracticeThreadReturnFocus: BrowseCollectionFocusRequest?
    @State private var browseCollectionFocusRequestID = 0
    @State private var browseCollectionFocusRequest: BrowseCollectionFocusRequest?
    @State private var isPracticeThreadPresented = false
    @State private var pinnedAudioSpeedChromeState = PinnedAudioSpeedChromeState.hidden
    @State private var homePhraseHeroRoutePageID: String?
    @State private var homePhraseHeroMorphPageID: String?
    @State private var homePhraseHeroContentHoldPageID: String?
    @State private var homePhraseHeroMorphResetID = 0
    @State private var browseCityHeroRoute: BrowseCollectionRoute?
    @State private var browseCityHeroMorphResetID = 0
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
        TabView(selection: systemTabSelection) {
            Tab("Home", systemImage: DockItemKind.home.symbolName, value: AppSystemTab.home) {
                shellContent
            }

            Tab("Browse", systemImage: DockItemKind.browse.symbolName, value: AppSystemTab.browse) {
                shellContent
            }

            Tab("Saved", systemImage: DockItemKind.saved.symbolName, value: AppSystemTab.saved) {
                shellContent
            }

            Tab("Messages", systemImage: DockItemKind.practice.symbolName, value: AppSystemTab.practice) {
                shellContent
            }

            Tab("Search", systemImage: "magnifyingglass", value: AppSystemTab.search, role: .search) {
                NavigationStack {
                    shellContent
                }
                .navigationTitle("Search")
                .searchable(
                    text: $searchQuery,
                    isPresented: systemSearchPresentation,
                    placement: .automatic,
                    prompt: "Search Vietnamese phrases"
                )
            }
        }
        .tabViewSearchActivation(.searchTabSelection)
    }

    private var shellContent: some View {
        shellContentBody
            .preferredColorScheme(.light)
    }

    private var shellContentBody: some View {
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
                    chromeNamespace: chromeNamespace,
                    cityHeroMorphRoute: browseCityHeroRoute,
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
                    onThreadBackToOrigin: returnFromPracticeThreadToOrigin,
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
    }

    private var practiceStartRequest: PracticeStartRequest? {
        if let requestedPracticeScenarioID {
            return PracticeStartRequest(
                id: practiceStartRequestID,
                scenarioID: requestedPracticeScenarioID,
                scenarioThreadDismissal: requestedPracticeScenarioThreadDismissal
            )
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
                    focusRequest: browseCollectionFocusRequest,
                    chromeNamespace: chromeNamespace,
                    cityHeroMorphRoute: browseCityHeroRoute,
                    onOpenDetail: openDetailFromBrowse,
                    onOpenCollection: openBrowseCollection,
                    onPractice: openPractice
                )
                .allowsHitTesting(isActive && !navigation.isSearchPresented && !isPreviewingForwardPage)
                .accessibilityHidden(!isActive || navigation.isSearchPresented)
                .transition(browseCollectionTransition(for: renderedCollection.route))
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

    private var systemTabSelection: Binding<AppSystemTab> {
        Binding(
            get: {
                AppSystemTab(route: navigation.currentRoute)
            },
            set: { tab in
                selectSystemTab(tab)
            }
        )
    }

    private var systemSearchPresentation: Binding<Bool> {
        Binding(
            get: {
                navigation.isSearchPresented && isSearchFieldFocused
            },
            set: { isPresented in
                if isPresented {
                    openSearch(prefilledQuery: nil, focusField: true)
                } else {
                    cancelSearchFocus()
                }
            }
        )
    }

    private func selectSystemTab(_ tab: AppSystemTab) {
        switch tab {
        case .home:
            openHome()
        case .browse:
            openBrowse()
        case .saved:
            openSaved()
        case .practice:
            openPractice()
        case .search:
            openSearch(prefilledQuery: nil, focusField: true)
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

    private func browseCollectionTransition(for route: BrowseCollectionRoute) -> AnyTransition {
        browseCityHeroRoute == route
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
                    focusRequest: nil,
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
        guard PinnedAudioSpeedChromePolicy.canShowPinnedControl(
            on: navigation.currentRoute,
            hasStaticBackButton: showsStaticBackButton,
            isSearchPresented: navigation.isSearchPresented
        ) else {
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
        if shouldUseBrowseCityHeroMorph(for: route) {
            openBrowseCollectionWithCityHeroMorph(route)
            return
        }

        cancelInteractiveChromeState()
        cancelSearchFocus()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openBrowseCollection(route)
        }
    }

    private func shouldUseBrowseCityHeroMorph(for route: BrowseCollectionRoute) -> Bool {
        guard case .city = route else {
            return false
        }

        return navigation.currentRoute == .browse && !navigation.isSearchPresented
    }

    private func openBrowseCollectionWithCityHeroMorph(_ route: BrowseCollectionRoute) {
        cancelInteractiveChromeState()
        cancelSearchFocus()
        browseCityHeroMorphResetID += 1
        let resetID = browseCityHeroMorphResetID

        withoutRouteAnimation {
            browseCityHeroRoute = route
        }

        withAnimation(HomePhraseHeroMorphTiming.navigationAnimation) {
            navigation.openBrowseCollection(route)
        }
        clearBrowseCityHeroLaunch(after: resetID)
    }

    private func clearBrowseCityHeroLaunch(after resetID: Int) {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: HomePhraseHeroMorphTiming.cleanupDelayNanoseconds)
            guard browseCityHeroMorphResetID == resetID else {
                return
            }

            withoutRouteAnimation {
                browseCityHeroRoute = nil
            }
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
        if navigation.searchOriginSystemTab == .home {
            openBrowseCollectionFromHome(route)
        } else {
            openBrowseCollection(route)
        }
    }

    private func openBrowseAll() {
        openBrowse()
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
            requestedPracticeScenarioThreadDismissal = .messagesHub
            pendingPracticeThreadReturnFocus = nil
        case .practiceMode(let mode):
            practiceStartRequestID += 1
            requestedPracticeMode = mode
            requestedPracticeScenarioID = nil
            requestedPracticeScenarioThreadDismissal = .messagesHub
            pendingPracticeThreadReturnFocus = nil
        case .practiceScenario(let scenarioID):
            practiceStartRequestID += 1
            requestedPracticeMode = nil
            requestedPracticeScenarioID = scenarioID
            if case .browseCollection(let route) = navigation.currentRoute {
                requestedPracticeScenarioThreadDismissal = .originRoute
                pendingPracticeThreadReturnFocus = BrowseCollectionFocusRequest(
                    id: 0,
                    route: route,
                    target: .messageScenario(scenarioID)
                )
            } else {
                requestedPracticeScenarioThreadDismissal = .messagesHub
                pendingPracticeThreadReturnFocus = nil
            }
        }

        openPractice()
    }

    private func returnFromPracticeThreadToOrigin() {
        let focusRequest = pendingPracticeThreadReturnFocus
        pendingPracticeThreadReturnFocus = nil
        cancelInteractiveChromeState()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.goBack()
        }
        restoreBrowseCollectionFocusIfNeeded(focusRequest)
    }

    private func restoreBrowseCollectionFocusIfNeeded(_ focusRequest: BrowseCollectionFocusRequest?) {
        guard let focusRequest else {
            return
        }

        DispatchQueue.main.async {
            browseCollectionFocusRequestID += 1
            let request = BrowseCollectionFocusRequest(
                id: browseCollectionFocusRequestID,
                route: focusRequest.route,
                target: focusRequest.target
            )
            browseCollectionFocusRequest = request

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if browseCollectionFocusRequest == request {
                    browseCollectionFocusRequest = nil
                }
            }
        }
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

    private func cancelInteractiveChromeState() {
        interactiveDragResolutionID += 1
        homePhraseHeroMorphResetID += 1
        browseCityHeroMorphResetID += 1
        homePhraseHeroRoutePageID = nil
        homePhraseHeroMorphPageID = nil
        homePhraseHeroContentHoldPageID = nil
        browseCityHeroRoute = nil
        interactiveDrag = nil
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

    var searchOriginSystemTab: AppSystemTab {
        AppSystemTab(route: routeBelowSearch)
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
                    VStack(alignment: .leading, spacing: HomeLayout.sectionSpacing) {
                        header
                            .id(Self.scrollTopID)

                        useNowShelf

                        homepagePhraseShelf("first-day")

                        cityShelf

                        homepagePhraseShelf("food-coffee")

                        practiceScenariosShelf

                        homepagePhraseShelf("taxi-getting-around")

                        situationShelves

                        homepagePhraseShelf("when-stuck")

                        homepagePhraseShelf("hotel-basics")

                        relationshipShelf

                        homepagePhraseShelf("money-shopping")

                        homepagePhraseShelf("help-emergency")

                        recentlyViewedShelf
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
            }
            .padding(.horizontal, HomeLayout.horizontalPadding)
            .padding(.top, 10)
            .padding(.bottom, 0)
        }
    }

    private var useNowShelf: some View {
        HomeShelf(
            title: "Essentials",
            subtitle: "Core phrases for any trip",
            route: .category("essentials"),
            onOpenCollection: onOpenCollection
        ) {
            HomeFeaturedPhraseCarousel(
                items: HomeContent.useNowFeaturePhraseCardItems,
                heroMorphPageID: heroMorphPageID,
                chromeNamespace: chromeNamespace,
                visibilityRoute: .home,
                onOpenDetail: onOpenFeaturedDetail,
                isSaved: { intentStore.isPageSaved($0) },
                onToggleSaved: { intentStore.toggleSavedPage($0) }
            )
        }
        .padding(.leading, HomeLayout.horizontalPadding)
    }

    @ViewBuilder
    private func homepagePhraseShelf(_ id: String) -> some View {
        if let shelf = HomeContent.homepagePhraseShelf(id) {
            HomeRoutePhraseShelf(
                shelf: shelf,
                onOpenDetail: onOpenDetail,
                onOpenCollection: onOpenCollection
            )
        }
    }

    @ViewBuilder
    private var recentlyViewedShelf: some View {
        let items = recentlyViewedFeatureItems

        if !items.isEmpty {
            HomeShelf(title: "Recently viewed", subtitle: "Pick up where you left off") {
                HomeFeaturedPhraseCarousel(
                    items: items,
                    heroMorphPageID: heroMorphPageID,
                    chromeNamespace: chromeNamespace,
                    onOpenDetail: onOpenFeaturedDetail,
                    isSaved: { intentStore.isPageSaved($0) },
                    onToggleSaved: { intentStore.toggleSavedPage($0) }
                )
            }
            .padding(.leading, HomeLayout.horizontalPadding)
        }
    }

    private var recentlyViewedFeatureItems: [HomeFeaturePhraseItem] {
        HomeRecentlyViewedContent
            .cardPageIDs(from: intentStore.recentPageIDs)
            .compactMap(HomeFeaturePhraseItem.resolve(pageID:))
    }

    private var practiceScenariosShelf: some View {
        HomeShelf(title: "Messages", subtitle: "Short trip conversations") {
            HomeScenarioRail(
                scenarios: HomeContent.practiceScenarios,
                onStartPractice: onStartPractice
            )
        }
        .padding(.leading, HomeLayout.horizontalPadding)
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

    private var relationshipShelf: some View {
        HomeShelf(
            title: "Who are you speaking to?",
            subtitle: "Pick a warmer hello by age or relationship",
            route: .category("local-greetings"),
            onOpenCollection: onOpenCollection
        ) {
            HomeRelationshipListCard(
                phrases: Array(PhrasePage.xinChao.localGreetings.prefix(3)),
                onOpenDetail: onOpenDetail
            )
        }
        .padding(.horizontal, HomeLayout.horizontalPadding)
    }

    private var cityShelf: some View {
        HomeShelf(
            title: "Explore by city",
            subtitle: "Popular city guides for your trip",
            route: .category("city-guides"),
            onOpenCollection: onOpenCollection
        ) {
            HomeCityRail(cities: HomeContent.cityCards, onOpenCollection: onOpenCollection)
        }
        .padding(.leading, HomeLayout.horizontalPadding)
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
            }
            .padding(14)
            .phraseListCard(cornerRadius: HomeLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
    }
}

enum HomeLayout {
    static let horizontalPadding: CGFloat = 24
    static let sectionSpacing: CGFloat = 42
    static let cardCornerRadius: CGFloat = 22
    static let largeCardCornerRadius: CGFloat = 28
    static let quickPhraseCardHeight: CGFloat = 142
    static let quickPhraseCardWidth: CGFloat = 160
    static let quickPhraseGridRowSpacing: CGFloat = 12
    static let featurePhraseCardWidth: CGFloat = 344
    static let featurePhraseCardHeight: CGFloat = 326
    static let tallPhraseCardWidth: CGFloat = 158
    static let tallPhraseCardHeight: CGFloat = 190
    static let compactPhraseRowWidth: CGFloat = 278
    static let compactPhraseRowHeight: CGFloat = 88
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
    static let bottomChromeContentClearance: CGFloat = 48

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

private enum HomePhraseShelfLayout {
    case quickTiles
    case spotlightRows
    case mediumGrid
    case wideRows
    case tallCards
}

private struct HomeSituationCard: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let imageName: String
    let route: BrowseCollectionRoute
}

private struct HomePhraseShelfDefinition: Identifiable {
    private static let defaultMaximumShelfItems = 12

    let id: String
    let title: String
    let subtitle: String
    let route: BrowseCollectionRoute
    let sourceCategoryIDs: [String]
    let pageIDs: [String]
    let layout: HomePhraseShelfLayout
    let maximumItemCount: Int
    let fillsFromSourceCategories: Bool

    init(
        id: String,
        title: String,
        subtitle: String,
        route: BrowseCollectionRoute,
        sourceCategoryIDs: [String],
        pageIDs: [String],
        layout: HomePhraseShelfLayout = .quickTiles,
        maximumItemCount: Int = Self.defaultMaximumShelfItems,
        fillsFromSourceCategories: Bool = true
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.route = route
        self.sourceCategoryIDs = sourceCategoryIDs
        self.pageIDs = pageIDs
        self.layout = layout
        self.maximumItemCount = maximumItemCount
        self.fillsFromSourceCategories = fillsFromSourceCategories
    }

    var items: [HomePhraseItem] {
        var seen = Set<String>()
        var rows: [HomePhraseItem] = []

        func append(_ item: HomePhraseItem) {
            guard rows.count < maximumItemCount else {
                return
            }
            guard seen.insert(item.pageID).inserted else {
                return
            }
            rows.append(item)
        }

        for item in pageIDs.compactMap(HomePhraseItem.resolve(pageID:)) {
            append(item)
        }

        guard fillsFromSourceCategories else {
            return rows
        }

        for categoryID in sourceCategoryIDs where rows.count < maximumItemCount {
            let categoryItems = PhraseCatalog.items(selectedCategoryID: categoryID)
            for catalogItem in categoryItems where rows.count < maximumItemCount {
                if let item = HomePhraseItem.resolve(pageID: catalogItem.pageID) {
                    append(item)
                }
            }
        }

        return rows
    }

    var browseTitle: String {
        BrowseSearchDestinations.collectionDescriptor(for: route)?.title ?? "Browse"
    }
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

    static let featureCardIDs = Array(starterIDs.prefix(6))
}

enum HomeRecentlyViewedContent {
    static let maximumFeatureCards = 6

    static func cardPageIDs(from recentPageIDs: [String]) -> [String] {
        var seen = Set<String>()
        var cardPageIDs: [String] = []

        for pageID in recentPageIDs {
            guard let canonicalPageID = PhraseCatalog.canonicalPageID(forOpenablePageID: pageID) else {
                continue
            }
            guard seen.insert(canonicalPageID).inserted else {
                continue
            }

            cardPageIDs.append(canonicalPageID)
            if cardPageIDs.count == maximumFeatureCards {
                break
            }
        }

        return cardPageIDs
    }
}

enum HomeFirstDayShelfContent {
    static let title = "First Day in Vietnam"
    static let maximumCards = 8
    static let pageIDs = [
        "viet-phrase-airport-1",
        "viet-phrase-airport-3",
        "viet-phrase-v500-airp-bord-arri-where-is-the-atm",
        "viet-phrase-airport-5",
        "viet-phrase-taxi-1",
        "viet-phrase-hotel-1",
        "viet-phrase-hotel-2",
        "viet-phrase-directions-9",
    ]
}

private enum HomeContent {
    static let useNowIDs = HomeUseNowCatalog.starterIDs

    static let homepagePhraseShelves: [HomePhraseShelfDefinition] = [
        HomePhraseShelfDefinition(
            id: "first-day",
            title: HomeFirstDayShelfContent.title,
            subtitle: "Short airport, ride, and check-in phrases.",
            route: .category("first-day"),
            sourceCategoryIDs: ["airport-border-arrival", "hotel-accommodation", "transport", "directions-navigation"],
            pageIDs: HomeFirstDayShelfContent.pageIDs,
            layout: .spotlightRows,
            maximumItemCount: HomeFirstDayShelfContent.maximumCards,
            fillsFromSourceCategories: false
        ),
        HomePhraseShelfDefinition(
            id: "food-coffee",
            title: "Food & coffee",
            subtitle: "Menu, water, coffee, spice, allergies, and paying.",
            route: .category("food"),
            sourceCategoryIDs: ["food-drink", "money-numbers-prices"],
            pageIDs: [
                "viet-phrase-food-menu",
                "viet-family-food-bottled-water",
                "viet-phrase-coffee-1",
                "viet-phrase-food-3",
                "viet-family-food-peanut-allergy",
                "viet-phrase-coffee-7",
            ],
            layout: .mediumGrid
        ),
        HomePhraseShelfDefinition(
            id: "when-stuck",
            title: "When you get stuck",
            subtitle: "Slow down, repeat, write it, use English, or ask for help.",
            route: .category("polite-repair"),
            sourceCategoryIDs: ["understanding-repair", "polite-basics", "problems-help"],
            pageIDs: [
                "viet-phrase-problems-2",
                "viet-phrase-problems-3",
                "viet-phrase-repair-1",
                "viet-phrase-repair-2",
                "viet-phrase-repair-english-help",
                "viet-phrase-help-need-help-direct",
                "viet-phrase-v500-unde-repa-can-you-show-me-a-picture",
            ],
            layout: .quickTiles
        ),
        HomePhraseShelfDefinition(
            id: "taxi-getting-around",
            title: "Taxi & getting around",
            subtitle: "Pickup points, drivers, addresses, and getting back.",
            route: .category("getting-around"),
            sourceCategoryIDs: ["transport", "directions-navigation"],
            pageIDs: [
                "viet-phrase-taxi-1",
                "viet-phrase-directions-8",
                "viet-phrase-v500-tran-please-call-the-driver",
                "viet-phrase-v900-tran-please-take-me-to-this-address",
                "viet-phrase-v500-tran-please-take-me-to-this-hotel",
                "viet-family-hotel-call-taxi",
            ],
            layout: .wideRows
        ),
        HomePhraseShelfDefinition(
            id: "hotel-basics",
            title: "Hotel basics",
            subtitle: "Reservation, passport, Wi-Fi, checkout, and room help.",
            route: .category("hotel"),
            sourceCategoryIDs: ["hotel-accommodation", "time-dates-booking", "local-services-everyday-tasks"],
            pageIDs: [
                "viet-phrase-hotel-1",
                "viet-phrase-v500-hote-acco-here-is-my-passport-for-check-in",
                "viet-phrase-phone-1",
                "viet-phrase-hotel-3",
                "viet-phrase-v900-hote-acco-the-reservation-is-under-this-name",
            ],
            layout: .spotlightRows
        ),
        HomePhraseShelfDefinition(
            id: "money-shopping",
            title: "Money & shopping",
            subtitle: "Prices, receipts, cards, cash, and sizes.",
            route: .category("shopping"),
            sourceCategoryIDs: ["shopping", "money-numbers-prices", "local-services-everyday-tasks"],
            pageIDs: [
                "viet-phrase-money-how-much-common",
                "viet-phrase-price-1",
                "viet-phrase-v500-mone-numb-pric-can-i-have-a-receipt",
                "viet-phrase-v500-mone-numb-pric-can-i-try-another-card",
                "viet-phrase-price-9",
                "viet-phrase-shop-1",
            ],
            layout: .mediumGrid
        ),
        HomePhraseShelfDefinition(
            id: "help-emergency",
            title: "Help & emergency",
            subtitle: "Need help, pharmacy, doctor, police, passport.",
            route: .category("emergency"),
            sourceCategoryIDs: ["problems-help", "health-pharmacy", "emergency-safety"],
            pageIDs: [
                "viet-phrase-help-need-help-direct",
                "viet-phrase-health-pharmacy-clearer",
                "viet-phrase-problems-6",
                "viet-phrase-emergency-3",
                "viet-phrase-emergency-4",
                "viet-phrase-emergency-1",
                "viet-phrase-emergency-hospital",
            ],
            layout: .wideRows
        ),
    ]

    static func homepagePhraseShelf(_ id: String) -> HomePhraseShelfDefinition? {
        homepagePhraseShelves.first { $0.id == id }
    }

    static var useNowItems: [HomePhraseItem] {
        useNowIDs.compactMap(HomePhraseItem.resolve(pageID:))
    }

    static var useNowFeaturePhraseCardItems: [HomeFeaturePhraseItem] {
        HomeUseNowCatalog.featureCardIDs.compactMap(HomeFeaturePhraseItem.resolve(pageID:))
    }

    static var savedFallbackItems: [HomePhraseItem] {
        savedFallbackPageIDs.compactMap(HomePhraseItem.resolve(pageID:))
    }

    static let savedFallbackPageIDs = [
        "viet-phrase-v500-unde-repa-can-you-show-me-a-picture",
        "viet-phrase-hotel-3",
    ]

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

#if DEBUG
enum HomePageLinkRegistry {
    static var homepageListingPageIDs: [String] {
        uniquePageIDs(
            HomeUseNowCatalog.featureCardIDs
            + HomeContent.homepagePhraseShelves.flatMap(\.pageIDs)
            + HomeContent.savedFallbackPageIDs
            + PhrasePage.xinChao.localGreetings.prefix(3).compactMap(\.detailPageID)
        )
    }

    static var firstDayHomepagePageIDs: [String] {
        HomeContent.homepagePhraseShelf("first-day")?.items.map(\.pageID) ?? []
    }

    private static func uniquePageIDs(_ pageIDs: [String]) -> [String] {
        var seen = Set<String>()
        return pageIDs.filter { seen.insert($0).inserted }
    }
}
#endif

private struct HomeShelf<Content: View>: View {
    let title: String
    let subtitle: String
    let route: BrowseCollectionRoute?
    let onOpenCollection: ((BrowseCollectionRoute) -> Void)?
    let content: Content

    init(
        title: String,
        subtitle: String,
        route: BrowseCollectionRoute? = nil,
        onOpenCollection: ((BrowseCollectionRoute) -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.route = route
        self.onOpenCollection = onOpenCollection
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header

            content
        }
    }

    @ViewBuilder
    private var header: some View {
        if let route, let onOpenCollection {
            Button {
                onOpenCollection(route)
            } label: {
                headerContent(showsChevron: true)
            }
            .buttonStyle(.plain)
            .accessibilityHint(subtitle)
            .accessibilityIdentifier("HomeShelf.Header.\(route.id)")
        } else {
            headerContent(showsChevron: false)
                .accessibilityHint(subtitle)
        }
    }

    private func headerContent(showsChevron: Bool) -> some View {
        HStack(spacing: 7) {
            Text(title)
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
        }
        .contentShape(Rectangle())
    }
}

private struct HomeFeaturedPhraseCarousel: View {
    let items: [HomeFeaturePhraseItem]
    let heroMorphPageID: String?
    let chromeNamespace: Namespace.ID?
    let visibilityRoute: AppRoute?
    let onOpenDetail: (String) -> Void
    let isSaved: (String) -> Bool
    let onToggleSaved: (String) -> Void

    init(
        items: [HomeFeaturePhraseItem],
        heroMorphPageID: String?,
        chromeNamespace: Namespace.ID?,
        visibilityRoute: AppRoute? = nil,
        onOpenDetail: @escaping (String) -> Void,
        isSaved: @escaping (String) -> Bool,
        onToggleSaved: @escaping (String) -> Void
    ) {
        self.items = items
        self.heroMorphPageID = heroMorphPageID
        self.chromeNamespace = chromeNamespace
        self.visibilityRoute = visibilityRoute
        self.onOpenDetail = onOpenDetail
        self.isSaved = isSaved
        self.onToggleSaved = onToggleSaved
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            carouselContent
                .padding(.trailing, HomeLayout.horizontalPadding)
                .padding(.bottom, 3)
        }
        .frame(height: HomeLayout.featurePhraseCardHeight)
        .scrollTargetBehavior(.viewAligned)
        .scrollClipDisabled()
    }

    @ViewBuilder
    private var carouselContent: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: 14) {
                carouselItems
            }
        } else {
            carouselItems
        }
    }

    private var carouselItems: some View {
        LazyHStack(spacing: 14) {
            ForEach(items) { item in
                HomeFeaturedPhraseCard(
                    item: item,
                    isSaved: isSaved(item.pageID),
                    isHeroMorphSource: heroMorphPageID == item.morphPageID,
                    chromeNamespace: chromeNamespace,
                    visibilityRoute: visibilityRoute,
                    onOpenDetail: onOpenDetail,
                    onToggleSaved: { onToggleSaved(item.pageID) }
                )
            }
        }
        .scrollTargetLayout()
    }
}

private struct HomeFeaturedPhraseCard: View {
    let item: HomeFeaturePhraseItem
    let isSaved: Bool
    let isHeroMorphSource: Bool
    let chromeNamespace: Namespace.ID?
    let visibilityRoute: AppRoute?
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
                    onToggleSaved: onToggleSaved,
                    visibilityRoute: visibilityRoute
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
                        .minimumScaleFactor(0.66)

                    Text(item.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
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
        .accessibilityIdentifier("HomeScenarioRail")
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

private struct HomeRoutePhraseShelf: View {
    let shelf: HomePhraseShelfDefinition
    let onOpenDetail: (String) -> Void
    let onOpenCollection: (BrowseCollectionRoute) -> Void

    var body: some View {
        let items = shelf.items

        if !items.isEmpty {
            phraseRail(items: items)
        }
    }

    private func phraseRail(items: [HomePhraseItem]) -> some View {
        HomeShelf(
            title: shelf.title,
            subtitle: shelf.subtitle,
            route: shelf.route,
            onOpenCollection: onOpenCollection
        ) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 12) {
                    ForEach(items) { item in
                        HomeQuickPhraseCard(item: item, onOpenDetail: onOpenDetail)
                    }
                }
                .padding(.trailing, HomeLayout.horizontalPadding)
                .padding(.bottom, 2)
            }
            .frame(height: HomeLayout.quickPhraseCardHeight)
            .scrollClipDisabled()
        }
        .padding(.leading, HomeLayout.horizontalPadding)
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
                    rowContent
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            } else {
                rowContent
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

    private var rowContent: some View {
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
