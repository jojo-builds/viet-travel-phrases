import SwiftUI

struct AppShellView: View {
    @State private var navigation: AppShellNavigationState
    @State private var interactiveDrag: AppInteractiveNavigationDrag?
    @State private var interactiveDragResolutionID = 0
    @State private var searchQuery: String
    @State private var searchFocusRequestID = 0
    @State private var didApplyLaunchSearchFocus = false
    @State private var practiceStartRequestID = 0
    @State private var requestedPracticeMode: PracticeMode?
    @State private var pinnedAudioSpeedChromeState = PinnedAudioSpeedChromeState.hidden
    @StateObject private var intentStore = LocalUserIntentStore()
    @FocusState private var isSearchFieldFocused: Bool
    @Namespace private var chromeNamespace
    private let launchPracticeMode: PracticeMode?
    private let launchPracticeEntryContext: PracticeEntryContext
    private let launchDetailScrollTarget: PhraseArticleInitialScrollTarget?
    private let launchSearchShouldFocus: Bool

    init(
        initialRoute: AppRoute = AppShellView.initialRoute,
        initialPracticeMode: PracticeMode? = AppShellView.initialPracticeMode,
        initialPracticeEntryContext: PracticeEntryContext = AppShellView.initialPracticeEntryContext,
        initialDetailScrollTarget: PhraseArticleInitialScrollTarget? = AppShellView.initialDetailScrollTarget,
        initialSearchQuery: String = AppShellView.initialSearchQuery,
        initialSearchShouldFocus: Bool = AppShellView.initialSearchShouldFocus
    ) {
        _navigation = State(initialValue: AppShellNavigationState(initialRoute: initialRoute))
        _searchQuery = State(initialValue: initialSearchQuery)
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
                    onSearchTapped: openSearch,
                    onOpenDetail: openDetailFromHome,
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
                    onBrowseTapped: openBrowseAll
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
                    isInPractice: intentStore.isPageInPractice(PhrasePage.xinChao.id),
                    onBackTapped: {},
                    onSearchTapped: openSearch,
                    onToggleSaved: { intentStore.toggleSavedPage(PhrasePage.xinChao.id) },
                    onTogglePractice: { intentStore.togglePracticePage(PhrasePage.xinChao.id) },
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
                    .zIndex(200)
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
            .animation(.snappy(duration: 0.34), value: navigation.detailPath)
            .animation(.snappy(duration: 0.34), value: navigation.browseCollectionPath)
            .animation(.snappy(duration: AppChromeLayout.searchMorphDuration), value: navigation.isSearchPresented)
            .animation(.snappy(duration: 0.24), value: navigation.forwardStack)
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
                backSwipeCaptureEdge(width: pageWidth)
            }
            .overlay(alignment: .trailing) {
                forwardSwipeCaptureEdge(width: pageWidth)
            }
            .overlay(alignment: .bottom) {
                ChromeSeparationGradient(edge: .bottom)
                    .zIndex(360)
            }
            .overlay(alignment: .bottom) {
                bottomChromeHitTestEnvelope
                    .padding(.bottom, bottomChromePadding)
                    .offset(y: bottomChromeOffset)
                    .zIndex(380)
            }
            .overlay(alignment: .top) {
                ChromeSeparationGradient(edge: .top)
                    .zIndex(360)
            }
            .overlay(alignment: .top) {
                if showsTopAdminRow {
                    TopAdminHitTestEnvelope()
                        .zIndex(390)
                }
            }
            .overlay(alignment: .top) {
                if showsTopAdminRow {
                    topAdminRow
                        .padding(.horizontal, AppChromeLayout.topAdminHorizontalPadding)
                        .padding(.top, AppChromeLayout.topAdminTopPadding)
                        .transition(.opacity)
                        .zIndex(410)
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
        guard let requestedPracticeMode else {
            return nil
        }

        return PracticeStartRequest(id: practiceStartRequestID, mode: requestedPracticeMode)
    }

    @ViewBuilder
    private func browseCollectionPageStack(width: CGFloat) -> some View {
        ForEach(Array(navigation.renderedBrowseCollections.enumerated()), id: \.element.id) { index, renderedCollection in
            let route = AppRoute.browseCollection(renderedCollection.route)
            let isActive = route == navigation.currentRoute

            if let descriptor = BrowseSearchDestinations.collectionDescriptor(for: renderedCollection.route) {
                BrowseCollectionPageView(
                    descriptor: descriptor,
                    scrollToTopTrigger: isActive ? navigation.browseCollectionScrollToTopTrigger : 0,
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
                    scrollToTopTrigger: isActive ? navigation.detailScrollToTopTrigger : 0,
                    onBackTapped: goBack
                )
                .allowsHitTesting(isActive && !navigation.isSearchPresented && !isPreviewingForwardPage)
                .accessibilityHidden(!isActive || navigation.isSearchPresented)
                .transition(AppPageTransition.slideFromTrailing)
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
                    scrollToTopTrigger: isActive ? navigation.detailScrollToTopTrigger : 0,
                    chromeNamespace: chromeNamespace,
                    isSearchActive: navigation.isSearchPresented,
                    showsChrome: false,
                    topChromeContentClearance: pinnedAudioSpeedScrollClearance,
                    isSaved: intentStore.isPageSaved(renderedPage.pageID),
                    isInPractice: intentStore.isPageInPractice(renderedPage.pageID),
                    onBackTapped: goBack,
                    onSearchTapped: openSearch,
                    onToggleSaved: { intentStore.toggleSavedPage(renderedPage.pageID) },
                    onTogglePractice: { intentStore.togglePracticePage(renderedPage.pageID) },
                    onDetailTapped: openDetail
                )
                .allowsHitTesting(isActive && !navigation.isSearchPresented && !isPreviewingForwardPage)
                .accessibilityHidden(!isActive || navigation.isSearchPresented)
                .transition(AppPageTransition.slideFromTrailing)
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
                isInPractice: intentStore.isPageInPractice(PhrasePage.xinChao.id),
                onBackTapped: {},
                onSearchTapped: openSearch,
                onToggleSaved: { intentStore.toggleSavedPage(PhrasePage.xinChao.id) },
                onTogglePractice: { intentStore.togglePracticePage(PhrasePage.xinChao.id) },
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
                    isInPractice: intentStore.isPageInPractice(detailPageID),
                    onBackTapped: goBack,
                    onSearchTapped: openSearch,
                    onToggleSaved: { intentStore.toggleSavedPage(detailPageID) },
                    onTogglePractice: { intentStore.togglePracticePage(detailPageID) },
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
        onBackTapped: @escaping () -> Void
    ) -> some View {
        PhraseListingView(
            page: .xinChao,
            chromeRoute: .detailPage(routePageID),
            initialScrollTarget: initialScrollTarget,
            scrollToTopTrigger: scrollToTopTrigger,
            chromeNamespace: chromeNamespace,
            isSearchActive: navigation.isSearchPresented,
            showsChrome: false,
            topChromeContentClearance: pinnedAudioSpeedScrollClearance,
            isSaved: intentStore.isPageSaved(routePageID),
            isInPractice: intentStore.isPageInPractice(routePageID),
            onBackTapped: onBackTapped,
            onSearchTapped: openSearch,
            onToggleSaved: { intentStore.toggleSavedPage(routePageID) },
            onTogglePractice: { intentStore.togglePracticePage(routePageID) },
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
        navigation.currentRoute != .home && navigation.currentRoute != .browse && navigation.currentRoute != .search
    }

    private var showsPinnedAudioSpeedControl: Bool {
        guard showsStaticBackButton, !navigation.isSearchPresented else {
            return false
        }

        return pinnedAudioSpeedChromeState.route == navigation.currentRoute
            && pinnedAudioSpeedChromeState.isVisible
    }

    private var pinnedAudioSpeedScrollClearance: CGFloat {
        showsPinnedAudioSpeedControl ? AppChromeLayout.pinnedAudioSpeedScrollClearance : 0
    }

    private var showsTopAdminRow: Bool {
        showsStaticBackButton || showsPinnedAudioSpeedControl || navigation.canGoForward
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
        .frame(maxWidth: .infinity)
        .frame(height: AppChromeLayout.topAdminControlSize)
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
        .nativeGlass(cornerRadius: AppChromeLayout.topAdminControlCornerRadius, interactive: true)
        .accessibilityLabel("Go back")
        .accessibilityIdentifier("TopAdmin.BackButton")
    }

    @ViewBuilder
    private var staticBottomChrome: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: AppChromeLayout.bottomSpacing) {
                staticBottomChromeContent
            }
        } else {
            staticBottomChromeContent
        }
    }

    @ViewBuilder
    private var staticBottomChromeContent: some View {
        let isSearchRoute = navigation.currentRoute == .search
        let isKeyboardSearch = isSearchRoute && isSearchFieldFocused
        let chrome = AppChrome(route: navigation.currentRoute)

        ZStack {
            HStack(spacing: AppChromeLayout.bottomSpacing) {
                if isSearchRoute {
                    if !isKeyboardSearch {
                        searchOriginButton(kind: navigation.searchOriginDockItem)
                    }
                } else {
                    dockCluster(chrome: chrome)
                }

                if isSearchRoute {
                    searchFieldCluster(isKeyboardSearch: isKeyboardSearch)
                } else {
                    collapsedSearchButton
                }

                if isKeyboardSearch {
                    searchDismissKeyboardButton
                }
            }

            if isSearchRoute {
                searchForegroundIconPair(isKeyboardSearch: isKeyboardSearch, origin: navigation.searchOriginDockItem)
            }
        }
        .animation(.snappy(duration: AppChromeLayout.searchMorphDuration), value: isSearchRoute)
        .animation(.snappy(duration: 0.34), value: isSearchFieldFocused)
    }

    private func dockCluster(chrome: AppChrome) -> some View {
        let selectedIndex = chrome.primaryDockItems.firstIndex(of: chrome.selectedDockItem) ?? 0

        return ZStack(alignment: .leading) {
            AppShellDockSelectionLens(chromeNamespace: chromeNamespace)
                .offset(x: dockSelectionLensXOffset(selectedIndex: selectedIndex))
                .animation(
                    .snappy(duration: AppChromeLayout.dockSelectionMorphDuration, extraBounce: 0.13),
                    value: selectedIndex
                )
                .zIndex(AppChromeLayout.dockSelectionLensZIndex)

            HStack(spacing: AppChromeLayout.dockItemSpacing) {
                ForEach(chrome.primaryDockItems, id: \.self) { item in
                    Button {
                        performDockAction(item)
                    } label: {
                        AppShellDockItem(
                            kind: item,
                            selected: item == chrome.selectedDockItem,
                            chromeNamespace: chromeNamespace,
                            isMorphSource: item == chrome.selectedDockItem
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(item.title)
                    .accessibilityIdentifier("AppChrome.Dock.\(item.title)")
                    .frame(width: AppChromeLayout.dockItemWidth, height: AppChromeLayout.dockItemHeight)
                    .contentShape(Rectangle())
                }
            }
            .zIndex(AppChromeLayout.dockItemForegroundZIndex)
        }
        .padding(.horizontal, AppChromeLayout.dockHorizontalPadding)
        .padding(.vertical, AppChromeLayout.dockVerticalPadding)
        .nativeGlass(cornerRadius: AppChromeLayout.dockCornerRadius)
        .nativeGlassMorphID(AppChromeMorphID.dock, namespace: chromeNamespace)
        .chromeMorph(AppChromeMorphID.dock, namespace: chromeNamespace, isSource: !navigation.isSearchPresented)
        .zIndex(AppChromeLayout.dockMorphZIndex)
    }

    private func dockSelectionLensXOffset(selectedIndex: Int) -> CGFloat {
        CGFloat(selectedIndex) * (AppChromeLayout.dockItemWidth + AppChromeLayout.dockItemSpacing)
            + (AppChromeLayout.dockItemWidth - AppChromeLayout.dockSelectionWidth) / 2
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
        .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
        .nativeGlassMorphID(AppChromeMorphID.search, namespace: chromeNamespace)
        .chromeMorph(AppChromeMorphID.search, namespace: chromeNamespace, isSource: !navigation.isSearchPresented)
        .accessibilityLabel("Search")
        .accessibilityIdentifier("AppChrome.SearchButton")
        .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
        .contentShape(Circle())
        .zIndex(AppChromeLayout.searchMorphZIndex)
    }

    private func searchOriginButton(kind: DockItemKind) -> some View {
        Button {
            performDockAction(kind)
        } label: {
            Color.clear
                .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
        .nativeGlassMorphID(AppChromeMorphID.dock, namespace: chromeNamespace)
        .chromeMorph(AppChromeMorphID.dock, namespace: chromeNamespace, isSource: navigation.isSearchPresented)
        .accessibilityLabel(kind.title)
        .accessibilityIdentifier("AppChrome.SearchOriginButton.\(kind.title)")
        .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
        .contentShape(Circle())
        .zIndex(AppChromeLayout.searchOriginMorphZIndex)
    }

    private func searchFieldCluster(isKeyboardSearch: Bool) -> some View {
        HStack(spacing: 10) {
            Color.clear
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
        .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
        .nativeGlassMorphID(AppChromeMorphID.search, namespace: chromeNamespace)
        .chromeMorph(AppChromeMorphID.search, namespace: chromeNamespace, isSource: true)
        .zIndex(AppChromeLayout.searchMorphZIndex)
    }

    private func searchForegroundIconPair(isKeyboardSearch: Bool, origin: DockItemKind) -> some View {
        HStack(spacing: AppChromeLayout.bottomSpacing) {
            if !isKeyboardSearch {
                Image(systemName: origin.symbolName)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
                    .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
                    .contentShape(Circle())
                    .chromeIconMorph(AppChromeMorphID.dockItem(origin), namespace: chromeNamespace, isSource: false)
                    .accessibilityIdentifier("AppChrome.SearchForegroundOriginIcon.\(origin.title)")
            }

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: AppChromeLayout.searchFieldIconSlotWidth)
                    .chromeIconMorph(AppChromeMorphID.searchIcon, namespace: chromeNamespace, isSource: navigation.isSearchPresented)
                    .accessibilityIdentifier("AppChrome.SearchForegroundSearchIcon")

                Spacer(minLength: 0)
            }
            .padding(.horizontal, AppChromeLayout.searchFieldHorizontalPadding)
            .frame(height: AppChromeLayout.searchFieldHeight)
            .frame(maxWidth: .infinity, alignment: .leading)

            if isKeyboardSearch {
                Color.clear
                    .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .zIndex(AppChromeLayout.searchForegroundMorphZIndex)
    }

    private var searchDismissKeyboardButton: some View {
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
        .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
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
        .nativeGlass(cornerRadius: AppChromeLayout.topAdminControlCornerRadius, interactive: true)
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
        case .practiceMode(let mode):
            practiceStartRequestID += 1
            requestedPracticeMode = mode
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

    static func initialPracticeEntryContext(for arguments: [String]) -> PracticeEntryContext {
        arguments.contains("--practice-placement") ? .placement : .standard
    }

    private static var initialPracticeMode: PracticeMode? {
        initialPracticeMode(for: ProcessInfo.processInfo.arguments)
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

struct AppShellNavigationState: Equatable {
    var rootRoute: AppRoute
    var browseCollectionPath: [BrowseCollectionRoute]
    var detailPath: [String]
    var isSearchPresented: Bool
    var forwardStack: [AppRoute] = []
    var homeScrollToTopTrigger = 0
    var browseScrollToTopTrigger = 0
    var rootScrollToTopTrigger = 0
    var savedScrollToTopTrigger = 0
    var practiceScrollToTopTrigger = 0
    var browseCollectionScrollToTopTrigger = 0
    var detailScrollToTopTrigger = 0

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
        isSearchPresented || !detailPath.isEmpty || !browseCollectionPath.isEmpty || rootRoute == .browse || rootRoute == .phrasePage || rootRoute == .saved || rootRoute == .practice
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
        detailScrollToTopTrigger += 1
    }

    mutating func openHome() {
        guard currentRoute != .home else {
            homeScrollToTopTrigger += 1
            return
        }

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
        browseCollectionScrollToTopTrigger += 1
    }

    mutating func openHomeBrowseCollection(_ route: BrowseCollectionRoute) {
        guard currentRoute != .browseCollection(route) else {
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
                if browseCollectionPath.isEmpty {
                    if rootRoute == .home {
                        homeScrollToTopTrigger += 1
                    } else {
                        browseScrollToTopTrigger += 1
                    }
                } else {
                    browseCollectionScrollToTopTrigger += 1
                }
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
            isSearchPresented = false
            browseCollectionPath.removeAll()
            detailPath.removeAll()
            rootRoute = .home
            homeScrollToTopTrigger += 1
        case .browse:
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
                browseCollectionScrollToTopTrigger += 1
            }
        case .phrasePage:
            isSearchPresented = false
            browseCollectionPath.removeAll()
            detailPath.removeAll()
            rootRoute = .phrasePage
            rootScrollToTopTrigger += 1
        case .saved:
            isSearchPresented = false
            browseCollectionPath.removeAll()
            detailPath.removeAll()
            rootRoute = .saved
            savedScrollToTopTrigger += 1
        case .practice:
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
}

private struct AppShellDockItem: View {
    let kind: DockItemKind
    let selected: Bool
    var chromeNamespace: Namespace.ID?
    var isMorphSource = false

    var body: some View {
        VStack(spacing: 3) {
            icon

            Text(kind.title)
                .font(.caption2.weight(.semibold))
        }
        .foregroundStyle(selected ? .red : .secondary)
        .frame(width: AppChromeLayout.dockItemWidth, height: AppChromeLayout.dockItemHeight)
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private var icon: some View {
        let image = Image(systemName: kind.symbolName)
            .font(.system(size: 18, weight: .semibold))

        if isMorphSource {
            image.chromeIconMorph(AppChromeMorphID.dockItem(kind), namespace: chromeNamespace, isSource: true)
        } else {
            image
        }
    }
}

private struct AppShellDockSelectionLens: View {
    var chromeNamespace: Namespace.ID?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppChromeLayout.dockSelectionCornerRadius, style: .continuous)
                .fill(.white.opacity(0.20))

            LinearGradient(
                colors: [
                    .white.opacity(0.54),
                    .white.opacity(0.16),
                    Color(red: 0.28, green: 0.68, blue: 1.0).opacity(0.18),
                    Color(red: 1.0, green: 0.88, blue: 0.28).opacity(0.16),
                    .white.opacity(0.28),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .blendMode(.screen)

            LinearGradient(
                colors: [
                    .white.opacity(0.0),
                    .white.opacity(0.40),
                    .white.opacity(0.0),
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .offset(x: -8)
            .blendMode(.screen)

            RoundedRectangle(cornerRadius: AppChromeLayout.dockSelectionCornerRadius, style: .continuous)
                .stroke(.white.opacity(0.62), lineWidth: 1)
        }
        .frame(width: AppChromeLayout.dockSelectionWidth, height: AppChromeLayout.dockSelectionHeight)
        .clipShape(RoundedRectangle(cornerRadius: AppChromeLayout.dockSelectionCornerRadius, style: .continuous))
        .nativeGlass(cornerRadius: AppChromeLayout.dockSelectionCornerRadius, tint: .white, interactive: true)
        .nativeGlassMorphID(AppChromeMorphID.dockSelection, namespace: chromeNamespace)
        .shadow(color: .white.opacity(0.34), radius: 14, x: 0, y: 0)
        .shadow(color: .black.opacity(0.10), radius: 16, x: 0, y: 8)
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
    var onSearchTapped: () -> Void
    var onOpenDetail: (String) -> Void
    var onOpenCollection: (BrowseCollectionRoute) -> Void
    var onStartPractice: (BrowseCollectionPracticeAction) -> Void
    var onBrowseAllTapped: () -> Void

    init(
        intentStore: LocalUserIntentStore,
        scrollToTopTrigger: Int = 0,
        chromeNamespace: Namespace.ID? = nil,
        isSearchActive: Bool = false,
        onSearchTapped: @escaping () -> Void,
        onOpenDetail: @escaping (String) -> Void,
        onOpenCollection: @escaping (BrowseCollectionRoute) -> Void,
        onStartPractice: @escaping (BrowseCollectionPracticeAction) -> Void,
        onBrowseAllTapped: @escaping () -> Void
    ) {
        self.intentStore = intentStore
        self.scrollToTopTrigger = scrollToTopTrigger
        self.chromeNamespace = chromeNamespace
        self.isSearchActive = isSearchActive
        self.onSearchTapped = onSearchTapped
        self.onOpenDetail = onOpenDetail
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

                        searchEntry
                            .padding(.horizontal, HomeLayout.horizontalPadding)

                        continueShelf
                            .padding(.horizontal, HomeLayout.horizontalPadding)

                        useNowShelf

                        practiceScenariosShelf

                        savedForLaterShelf
                            .padding(.horizontal, HomeLayout.horizontalPadding)

                        relationshipShelf

                        situationShelves

                        cityShelf

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

    private var searchEntry: some View {
        Button {
            onSearchTapped()
        } label: {
            HStack(spacing: 16) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.red)
                    .frame(width: 58, height: 58)
                    .nativeGlass(cornerRadius: 29, interactive: true)

                VStack(alignment: .leading, spacing: 4) {
                    Text("What do you need to say?")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Search English, Vietnamese, situations, or next steps")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .layoutPriority(1)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .homeGlassCard(cornerRadius: HomeLayout.largeCardCornerRadius)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Home.SearchEntry")
    }

    private var continueShelf: some View {
        HomeShelf(title: "Continue", subtitle: "Pick up where you left off") {
            HomeContinueCard(
                item: continueDisplayItem,
                imageName: "HomeContinueStation",
                progress: 0.60,
                onOpenDetail: onOpenDetail
            )
        }
    }

    private var useNowShelf: some View {
        HomeShelf(title: "Use now", subtitle: "Quick phrases for everyday moments") {
            HomeQuickPhraseGrid(items: Array(HomeContent.useNowItems.prefix(3)), onOpenDetail: onOpenDetail)
        }
        .padding(.horizontal, HomeLayout.horizontalPadding)
    }

    private var practiceScenariosShelf: some View {
        HomeShelf(title: "Practice scenarios", subtitle: "Real situations, ready when you are") {
            HomeScenarioRail(
                scenarios: HomeContent.practiceScenarios,
                onOpenCollection: onOpenCollection,
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

    private var continueDisplayItem: HomePhraseItem {
        continueItem
            ?? HomePhraseItem.resolve(pageID: "viet-phrase-city-hue-place-railway-station")
            ?? HomeContent.useNowItems.first
            ?? HomePhraseItem(
                pageID: PhrasePage.xinChao.id,
                title: PhrasePage.xinChao.title,
                subtitle: "Hello",
                symbolName: "hand.wave.fill",
                tintName: .red,
                audioKey: PhrasePage.xinChao.quickSay.first?.playbackAudioKey
            )
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
                    Text("Save useful phrase pages as you explore")
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
    static let scenarioCardWidth: CGFloat = 198
    static let scenarioCardHeight: CGFloat = 368
    static let scenarioCardPadding: CGFloat = 16
    static let scenarioCardSpacing: CGFloat = 14
    static let scenarioCardImageHeight: CGFloat = 144
    static let scenarioStartButtonHeight: CGFloat = 44
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

private struct HomeScenario: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let imageName: String
    let route: BrowseCollectionRoute
    let practiceAction: BrowseCollectionPracticeAction
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

private enum HomeContent {
    static let useNowIDs = [
        PhrasePage.xinChao.id,
        "viet-thank-you",
        "viet-family-repair-understand",
        "viet-family-bathroom-where",
        "viet-family-health-doctor",
    ]

    static let featuredIDs = [
        PhrasePage.xinChao.id,
        "viet-thank-you",
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

    static var practiceScenarios: [HomeScenario] {
        [
            HomeScenario(
                id: "first-day",
                title: "First day in Vietnam",
                subtitle: "Arrive, check in, get oriented",
                imageName: "HomeScenarioFirstDay",
                route: .category("first-day"),
                practiceAction: BrowseSearchDestinations.collectionDescriptor(for: .category("first-day"))?.practiceAction
                    ?? .practiceMode(.danangCity)
            ),
            HomeScenario(
                id: "hotel",
                title: "At the hotel",
                subtitle: "Check in, rooms, key issues",
                imageName: "HomeScenarioHotel",
                route: .category("hotel"),
                practiceAction: BrowseSearchDestinations.collectionDescriptor(for: .category("hotel"))?.practiceAction
                    ?? .addStarterPages(["viet-family-hotel-check-in", "viet-phrase-hotel-3"])
            ),
            HomeScenario(
                id: "danang",
                title: "Da Nang day",
                subtitle: "Beach, bridge, food, ride back",
                imageName: "HomeCityDaNang",
                route: .city("danang"),
                practiceAction: .practiceMode(.danangCity)
            ),
        ]
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
    let subtitle: String
    let content: Content

    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content
        }
    }
}

private struct HomeContinueCard: View {
    let item: HomePhraseItem
    let imageName: String
    let progress: CGFloat
    let onOpenDetail: (String) -> Void

    var body: some View {
        Button {
            onOpenDetail(item.pageID)
        } label: {
            HStack(spacing: 16) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 86, height: 86)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                VStack(alignment: .leading, spacing: 9) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.82)

                        Text(item.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }

                    HStack(spacing: 14) {
                        GeometryReader { proxy in
                            ZStack(alignment: .leading) {
                                Capsule(style: .continuous)
                                    .fill(Color.black.opacity(0.08))

                                Capsule(style: .continuous)
                                    .fill(Color(red: 0.24, green: 0.58, blue: 0.41))
                                    .frame(width: proxy.size.width * min(max(progress, 0), 1))
                            }
                        }
                        .frame(height: 5)

                        Text("\(Int(progress * 100))%")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color(red: 0.24, green: 0.58, blue: 0.41))
                    }
                }
                .layoutPriority(1)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 112, alignment: .leading)
            .homeGlassCard(cornerRadius: HomeLayout.largeCardCornerRadius)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Home.ContinueCard")
    }
}

private struct HomeQuickPhraseGrid: View {
    let items: [HomePhraseItem]
    let onOpenDetail: (String) -> Void

    var body: some View {
        HStack(spacing: 12) {
            ForEach(items) { item in
                HomeQuickPhraseCard(item: item, onOpenDetail: onOpenDetail)
                    .frame(maxWidth: .infinity)
            }
        }
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
            .frame(maxWidth: .infinity)
            .frame(height: HomeLayout.quickPhraseCardHeight)
            .homeGlassCard(cornerRadius: HomeLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("HomeQuick.\(item.pageID)")
    }
}

private struct HomeScenarioRail: View {
    let scenarios: [HomeScenario]
    let onOpenCollection: (BrowseCollectionRoute) -> Void
    let onStartPractice: (BrowseCollectionPracticeAction) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 14) {
                ForEach(scenarios) { scenario in
                    HomeScenarioCard(
                        scenario: scenario,
                        onOpenCollection: onOpenCollection,
                        onStartPractice: onStartPractice
                    )
                }
            }
            .padding(.trailing, HomeLayout.horizontalPadding)
            .padding(.bottom, 4)
        }
        .scrollClipDisabled()
    }
}

private struct HomeScenarioCard: View {
    let scenario: HomeScenario
    let onOpenCollection: (BrowseCollectionRoute) -> Void
    let onStartPractice: (BrowseCollectionPracticeAction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: HomeLayout.scenarioCardSpacing) {
            Button {
                onOpenCollection(scenario.route)
            } label: {
                Image(scenario.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: HomeLayout.scenarioCardWidth - HomeLayout.scenarioCardPadding * 2,
                        height: HomeLayout.scenarioCardImageHeight
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .buttonStyle(.plain)

            Button {
                onOpenCollection(scenario.route)
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    Text(scenario.title)
                        .font(.system(size: 20, weight: .black, design: .serif))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.78)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(scenario.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.78)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)

            Spacer(minLength: 0)

            Button {
                onStartPractice(scenario.practiceAction)
            } label: {
                Text("Start")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color(red: 0.24, green: 0.58, blue: 0.41))
                    .frame(maxWidth: .infinity)
                    .frame(height: HomeLayout.scenarioStartButtonHeight)
                    .homeGlassCard(cornerRadius: 22)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Start \(scenario.title)")
            .accessibilityIdentifier("HomeScenario.Start.\(scenario.id)")
        }
        .padding(HomeLayout.scenarioCardPadding)
        .frame(width: HomeLayout.scenarioCardWidth, height: HomeLayout.scenarioCardHeight, alignment: .topLeading)
        .homeGlassCard(cornerRadius: HomeLayout.largeCardCornerRadius)
        .accessibilityElement(children: .contain)
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
            LazyHStack(spacing: 14) {
                ForEach(cities) { city in
                    HomeCityCardView(city: city, onOpenCollection: onOpenCollection)
                }
            }
            .padding(.trailing, HomeLayout.horizontalPadding)
            .padding(.bottom, 4)
        }
        .scrollClipDisabled()
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
