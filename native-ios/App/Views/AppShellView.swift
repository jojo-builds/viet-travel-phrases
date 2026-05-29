import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

private struct PracticeThreadForwardRestore: Equatable {
    let scenarioID: PracticeScenarioID
    let focusRequest: BrowseCollectionFocusRequest?
}

enum HomeScrollTarget: Hashable, Sendable {
    case top
    case essentials
    case firstDay
    case city
    case foodCoffee
    case practice
    case gettingAround
    case situations
    case whenStuck
    case hotelBasics
    case relationships
    case moneyShopping
    case helpEmergency
    case recentlyViewed
}

struct HomeScrollRestorationTarget: Equatable {
    let target: HomeScrollTarget
    let offsetY: CGFloat
}

private struct HomePhotoBackdropScrollState: Equatable {
    let displayOffset: CGFloat
    let restorationOffset: CGFloat
    let hasPassedRevealThreshold: Bool

    init(rawOffset: CGFloat, metrics: PhrasePhotoBackdropLayout.Metrics) {
        let offset = max(rawOffset, 0)
        displayOffset = PhrasePhotoBackdropLayout.quantizedScrollOffset(offset)
        restorationOffset = PhrasePhotoBackdropLayout.quantizedScrollOffset(
            offset,
            stride: HomeLayout.shellScrollOffsetPublishStride
        )
        hasPassedRevealThreshold = offset > metrics.revealImmersiveOffset
    }
}

enum HomeBackdropActivationPolicy {
    static func shouldAdvanceBackdrop(previousRoute: AppRoute, currentRoute: AppRoute) -> Bool {
        AdminRootPhotoBackdropActivationPolicy.targetSurface(
            previousRoute: previousRoute,
            currentRoute: currentRoute
        ) == .home
    }
}

enum AppShellTabBarVisibilityPolicy {
    static func hidesNativeToolbarTabBar(
        isPracticeOverlayPresented: Bool,
        isPracticeMatchPresented: Bool,
        isPracticeThreadPresented: Bool
    ) -> Bool {
        (isPracticeMatchPresented && !isPracticeOverlayPresented) || isPracticeThreadPresented
    }

    static func hidesRenderedSystemTabBar(
        isPracticeOverlayPresented: Bool,
        isPracticeMatchPresented: Bool,
        isPracticeThreadPresented: Bool,
        hidesPhotoBackdropChrome: Bool
    ) -> Bool {
        hidesPhotoBackdropChrome
            || isPracticeOverlayPresented
            || hidesNativeToolbarTabBar(
                isPracticeOverlayPresented: isPracticeOverlayPresented,
                isPracticeMatchPresented: isPracticeMatchPresented,
                isPracticeThreadPresented: isPracticeThreadPresented
            )
    }
}

enum AppShellPracticeOverlayChromePolicy {
    static func topChromeStyle(
        isPracticeOverlayPresented: Bool,
        hidesPhotoBackdropChrome: Bool,
        photoBackdropTopChromeStyle: ChromeSeparationGradientStyle
    ) -> ChromeSeparationGradientStyle {
        if isPracticeOverlayPresented {
            return .darkPhoto
        }

        return hidesPhotoBackdropChrome ? .light : photoBackdropTopChromeStyle
    }

    static func preferredSystemColorScheme(isPracticeOverlayPresented: Bool) -> ColorScheme? {
        isPracticeOverlayPresented ? .dark : nil
    }

    static func topChromeOpacityScale(
        isPracticeOverlayPresented: Bool,
        backdropOpacity: Double
    ) -> Double {
        guard isPracticeOverlayPresented else {
            return 1
        }

        guard PracticeMatchPullUpMetrics.backdropOpacity > 0 else {
            return 1
        }

        return min(max(backdropOpacity / PracticeMatchPullUpMetrics.backdropOpacity, 0), 1)
    }
}

struct AppShellView: View {
    @State private var navigation: AppShellNavigationState
    @State private var interactiveDrag: AppInteractiveNavigationDrag?
    @State private var interactiveDragResolutionID = 0
    @State private var searchQuery: String
    @State private var isSearchPresentationActive = false
    @State private var searchFocusRequestID = 0
    @State private var searchReturnFocusRequestID = 0
    @State private var searchReturnFocusRequest: SearchReturnFocusRequest?
    @State private var didApplyLaunchSearchFocus = false
    @State private var hidesPhotoBackdropChrome = false
    @State private var showsPhotoBackdropTabBarBackground = false
    @State private var photoBackdropTopChromeStyle = ChromeSeparationGradientStyle.light
    @State private var photoBackdropImmersiveImageContext: PhrasePhotoBackdropImmersiveImageContext?
    @State private var practiceStartRequestID = 0
    @State private var requestedPracticeSourceID: String?
    @State private var requestedPracticeMode: PracticeMode?
    @State private var requestedPracticeScenarioID: PracticeScenarioID?
    @State private var requestedPracticeScenarioThreadDismissal = PracticeScenarioThreadDismissal.messagesHub
    @State private var pendingPracticeThreadReturnFocus: BrowseCollectionFocusRequest?
    @State private var pendingPracticeThreadForwardRestore: PracticeThreadForwardRestore?
    @State private var pendingPracticeMatchReturnFocus: BrowseCollectionFocusRequest?
    @State private var isPracticeOverlayPresented = false
    @State private var practiceOverlayBackdropOpacity = PracticeMatchPullUpMetrics.backdropOpacity
    @State private var practiceOverlayResetTrigger = 0
    @State private var browseCollectionFocusRequestID = 0
    @State private var browseCollectionFocusRequest: BrowseCollectionFocusRequest?
    @State private var isPracticeThreadPresented = false
    @State private var isPracticeMatchPresented = false
    @State private var tabBarVisibilityRefreshID = 0
    @State private var homePhraseHeroRoutePageID: String?
    @State private var homePhraseHeroMorphPageID: String?
    @State private var homePhraseHeroContentHoldPageID: String?
    @State private var homePhraseHeroMorphResetID = 0
    @State private var browseDetailHeroImageOverrides: [String: String] = [:]
    @State private var homeCurrentScrollTarget: HomeScrollTarget? = .top
    @State private var homeCurrentScrollOffsetY: CGFloat = 0
    @State private var homeScrollRestorationTarget: HomeScrollRestorationTarget?
    @State private var adminBackdropStates: [AdminRootPhotoBackdropSurface: AdminRootPhotoBackdropState]
    @State private var menuSectionChromeStates: [VietnameseMenuSectionChromeState] = []
    @State private var menuSectionJumpRequestID = 0
    @State private var menuSectionJumpRequest: VietnameseMenuSectionJumpRequest?
    @State private var savedTripSectionChromeStates: [SavedTripSectionChromeState] = []
    @State private var savedTripSectionJumpRequestID = 0
    @State private var savedTripSectionJumpRequest: SavedTripSectionJumpRequest?
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
        _adminBackdropStates = State(
            initialValue: AppShellView.initialAdminBackdropStates(initialRoute: initialRoute)
        )
        self.launchPracticeMode = initialPracticeMode
        self.launchPracticeEntryContext = initialPracticeEntryContext
        self.launchDetailScrollTarget = initialDetailScrollTarget
        self.launchSearchShouldFocus = initialSearchShouldFocus
    }

    private static func initialAdminBackdropStates(
        initialRoute: AppRoute
    ) -> [AdminRootPhotoBackdropSurface: AdminRootPhotoBackdropState] {
        let initialSurface = AdminRootPhotoBackdropSurface.surface(for: initialRoute)

        return AdminRootPhotoBackdropSurface.allCases.reduce(into: [:]) { result, surface in
            if surface == initialSurface {
                result[surface] = AdminRootPhotoBackdropState(
                    imageName: SharedBackdropImagePool.nextImageName(for: surface.poolSurface),
                    activationToken: 1
                )
            } else {
                result[surface] = .fallback
            }
        }
    }

    var body: some View {
        TabView(selection: systemTabSelection) {
            Tab("Home", systemImage: DockItemKind.home.symbolName, value: AppSystemTab.home) {
                tabShellContent(for: .home)
            }

            Tab("Browse", systemImage: DockItemKind.browse.symbolName, value: AppSystemTab.browse) {
                tabShellContent(for: .browse)
            }

            Tab("Saved", systemImage: DockItemKind.saved.symbolName, value: AppSystemTab.saved) {
                tabShellContent(for: .saved)
            }

            Tab("Practice", systemImage: DockItemKind.practice.symbolName, value: AppSystemTab.practice) {
                tabShellContent(for: .practice)
            }

            Tab("Search", systemImage: "magnifyingglass", value: AppSystemTab.search, role: .search) {
                NavigationStack {
                    tabShellContent(for: .search)
                }
                .navigationTitle("Search")
            }
        }
        .toolbar(hidesNativeToolbarTabBar ? .hidden : .visible, for: .tabBar)
        .toolbarBackground(Color.clear, for: .tabBar)
        .toolbarBackground(tabBarBackgroundVisibility, for: .tabBar)
        .toolbarColorScheme(.light, for: .tabBar)
        .preferredColorScheme(preferredSystemColorScheme)
        .statusBarHidden(hidesPhotoBackdropChrome)
        .persistentSystemOverlays(hidesPhotoBackdropChrome ? .hidden : .automatic)
        .searchable(
            text: $searchQuery,
            isPresented: $isSearchPresentationActive,
            placement: .automatic,
            prompt: "Search Vietnamese phrases"
        )
        .searchFocused($isSearchFieldFocused)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .tabViewSearchActivation(.automatic)
        .background {
            #if canImport(UIKit)
            AppShellTabBarAppearanceBridge(
                usesContentBackground: showsPhotoBackdropTabBarBackground && !hidesPhotoBackdropChrome,
                isHidden: hidesSystemTabBar
            )
            .id(tabBarVisibilityRefreshID)
            .frame(width: 0, height: 0)
            #endif
        }
        .overlay {
            if hidesPhotoBackdropChrome, let photoBackdropImmersiveImageContext {
                PhotoBackdropImmersiveImageCover(context: photoBackdropImmersiveImageContext)
            }
        }
        .overlay(alignment: .bottom) {
            if showsBottomAdminHitTestOverlay {
                BottomAdminHitTestOverlay(
                    selectedTab: selectedSystemTab,
                    onSelect: handleBottomAdminTabTap
                )
                .zIndex(AppChromeLayout.bottomAdminHitTestLayerZIndex)
            }
        }
    }

    @ViewBuilder
    private func tabShellContent(for tab: AppSystemTab) -> some View {
        if selectedSystemTab == tab {
            shellContent
        } else {
            Color.clear
                .accessibilityHidden(true)
        }
    }

    private var shellContent: some View {
        shellContentBody
            .environment(\.colorScheme, .light)
            .onPreferenceChange(PracticeOverlayBackdropOpacityPreferenceKey.self) { opacity in
                practiceOverlayBackdropOpacity = opacity
            }
    }

    private var effectiveTopChromeStyle: ChromeSeparationGradientStyle {
        AppShellPracticeOverlayChromePolicy.topChromeStyle(
            isPracticeOverlayPresented: isPracticeOverlayPresented,
            hidesPhotoBackdropChrome: hidesPhotoBackdropChrome,
            photoBackdropTopChromeStyle: photoBackdropTopChromeStyle
        )
    }

    private var preferredSystemColorScheme: ColorScheme? {
        AppShellPracticeOverlayChromePolicy.preferredSystemColorScheme(
            isPracticeOverlayPresented: isPracticeOverlayPresented
        )
    }

    private var topChromeOpacityScale: Double {
        AppShellPracticeOverlayChromePolicy.topChromeOpacityScale(
            isPracticeOverlayPresented: isPracticeOverlayPresented,
            backdropOpacity: practiceOverlayBackdropOpacity
        )
    }

    private var tabBarBackgroundVisibility: Visibility {
        if hidesNativeToolbarTabBar || hidesPhotoBackdropChrome {
            return .hidden
        }

        return .automatic
    }

    private var hidesSystemTabBar: Bool {
        AppShellTabBarVisibilityPolicy.hidesRenderedSystemTabBar(
            isPracticeOverlayPresented: isPracticeOverlayPresented,
            isPracticeMatchPresented: isPracticeMatchPresented,
            isPracticeThreadPresented: isPracticeThreadPresented,
            hidesPhotoBackdropChrome: hidesPhotoBackdropChrome
        )
    }

    private var showsBottomAdminHitTestOverlay: Bool {
        !hidesSystemTabBar && !navigation.isSearchPresented
    }

    private var hidesNativeToolbarTabBar: Bool {
        AppShellTabBarVisibilityPolicy.hidesNativeToolbarTabBar(
            isPracticeOverlayPresented: isPracticeOverlayPresented,
            isPracticeMatchPresented: isPracticeMatchPresented,
            isPracticeThreadPresented: isPracticeThreadPresented
        )
    }

    private func adminBackdropState(
        for surface: AdminRootPhotoBackdropSurface
    ) -> AdminRootPhotoBackdropState {
        adminBackdropStates[surface] ?? .fallback
    }

    private func isAdminBackdropSurfaceVisible(
        _ surface: AdminRootPhotoBackdropSurface
    ) -> Bool {
        [navigation.currentRoute, navigation.backPreviewRoute, navigation.forwardPreviewRoute]
            .compactMap { $0 }
            .contains { AdminRootPhotoBackdropSurface.surface(for: $0) == surface }
    }

    private var shellContentBody: some View {
        GeometryReader { proxy in
            let pageWidth = max(proxy.size.width, 1)

            ZStack {
                let homeBackdropState = adminBackdropState(for: .home)
                HomeView(
                    intentStore: intentStore,
                    backdropImageName: homeBackdropState.imageName,
                    backdropActivationToken: homeBackdropState.activationToken,
                    scrollToTopTrigger: navigation.homeScrollToTopTrigger,
                    isActive: navigation.currentRoute == .home,
                    isSearchActive: navigation.isSearchPresented,
                    currentScrollTarget: $homeCurrentScrollTarget,
                    currentScrollOffsetY: $homeCurrentScrollOffsetY,
                    scrollRestorationTarget: $homeScrollRestorationTarget,
                    onSearchTapped: openSearch,
                    onOpenDetail: { id, target in
                        prepareHomeScrollRestoration(target)
                        openDetailFromHome(id)
                    },
                    onOpenFeaturedDetail: { id, target in
                        prepareHomeScrollRestoration(target)
                        openFeaturedDetailFromHome(id)
                    },
                    onOpenCollection: { route, target in
                        prepareHomeScrollRestoration(target)
                        openBrowseCollectionFromHome(route)
                    },
                    onStartPractice: { action, target in
                        prepareHomeScrollRestoration(target)
                        openPractice(action)
                    },
                    onBrowseAllTapped: openBrowseAll
                )
                .allowsHitTesting(navigation.currentRoute == .home && allowsBasePageHitTesting)
                .accessibilityHidden(navigation.currentRoute != .home)
                .navigationPageMotion(
                    route: .home,
                    currentRoute: navigation.currentRoute,
                    backPreviewRoute: navigation.backPreviewRoute,
                    forwardPreviewRoute: navigation.forwardPreviewRoute,
                    drag: interactiveDrag,
                    width: pageWidth
                )

                let browseBackdropState = adminBackdropState(for: .browse)
                AdminPhotoBackdropSurfaceView(
                    surface: .browse,
                    backdropImageName: browseBackdropState.imageName,
                    activationToken: browseBackdropState.activationToken,
                    isActive: navigation.currentRoute == .browse,
                    isVisible: isAdminBackdropSurfaceVisible(.browse),
                    scrollToTopTrigger: navigation.browseScrollToTopTrigger
                ) { _ in
                    BrowsePageView(
                        intentStore: intentStore,
                        scrollToTopTrigger: navigation.browseScrollToTopTrigger,
                        usesPhotoBackdrop: true,
                        onOpenDetail: { openDetailFromBrowse($0) },
                        onOpenCollection: openBrowseCollection,
                        onSearchTapped: openSearch,
                        onSearchQuery: openSearchQuery
                    )
                }
                .allowsHitTesting(navigation.currentRoute == .browse && allowsBasePageHitTesting)
                .accessibilityHidden(navigation.currentRoute != .browse)
                .navigationPageMotion(
                    route: .browse,
                    currentRoute: navigation.currentRoute,
                    backPreviewRoute: navigation.backPreviewRoute,
                    forwardPreviewRoute: navigation.forwardPreviewRoute,
                    drag: interactiveDrag,
                    width: pageWidth
                )

                let savedBackdropState = adminBackdropState(for: .saved)
                AdminPhotoBackdropSurfaceView(
                    surface: .saved,
                    backdropImageName: savedBackdropState.imageName,
                    activationToken: savedBackdropState.activationToken,
                    isActive: navigation.currentRoute == .saved,
                    isVisible: isAdminBackdropSurfaceVisible(.saved),
                    scrollToTopTrigger: navigation.savedScrollToTopTrigger
                ) { scrollProxy in
                    SavedPagesView(
                        intentStore: intentStore,
                        scrollToTopTrigger: navigation.savedScrollToTopTrigger,
                        sectionJumpRequest: savedTripSectionJumpRequest,
                        usesPhotoBackdrop: true,
                        backdropScrollProxy: scrollProxy,
                        onOpenDetail: openDetailFromSaved,
                        onBrowseTapped: openBrowseAll,
                        onStartSavedPractice: { openPractice(.practiceSource("saved")) }
                    )
                }
                .allowsHitTesting(navigation.currentRoute == .saved && allowsBasePageHitTesting)
                .accessibilityHidden(navigation.currentRoute != .saved)
                .navigationPageMotion(
                    route: .saved,
                    currentRoute: navigation.currentRoute,
                    backPreviewRoute: navigation.backPreviewRoute,
                    forwardPreviewRoute: navigation.forwardPreviewRoute,
                    drag: interactiveDrag,
                    width: pageWidth
                )

                practiceRouteSurface
                .allowsHitTesting(navigation.currentRoute == .practice && allowsBasePageHitTesting)
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
                    isActive: navigation.currentRoute == .phrasePage,
                    showsChrome: false,
                    topChromeContentClearance: pinnedAudioSpeedScrollClearance,
                    isSaved: intentStore.isPageSaved(PhrasePage.xinChao.id),
                    isPageSaved: { intentStore.isPageSaved($0) },
                    heroMorphPageID: homePhraseHeroMorphPageID,
                    heroMorphContentHoldPageID: homePhraseHeroContentHoldPageID,
                    onBackTapped: {},
                    onSearchTapped: openSearch,
                    onToggleSaved: { intentStore.toggleSavedPage(PhrasePage.xinChao.id) },
                    onToggleSavedPage: { intentStore.toggleSavedPage($0) },
                    onDetailTapped: openDetail
                )
                .allowsHitTesting(navigation.currentRoute == .phrasePage && allowsBasePageHitTesting)
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
                    let searchBackdropState = adminBackdropState(for: .search)
                    SearchPageView(
                        query: $searchQuery,
                        isFieldFocused: isSearchFieldFocused,
                        returnFocusRequest: searchReturnFocusRequest,
                        photoBackdropState: searchBackdropState,
                        isPhotoBackdropActive: navigation.currentRoute == .search,
                        isPhotoBackdropVisible: isAdminBackdropSurfaceVisible(.search),
                        onClose: closeSearch,
                        onDismissSearchFocus: dismissSearchFieldFocus,
                        onPrepareReturnFocus: prepareSearchReturnFocus,
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

                if isPracticeOverlayPresented {
                    PracticeView(
                        intentStore: intentStore,
                        startRequest: practiceStartRequest,
                        isActive: true,
                        scrollToTopTrigger: practiceOverlayResetTrigger,
                        topContentClearance: 0,
                        presentationStyle: .pullUpOverlay,
                        onOpenDetail: openDetailFromPractice,
                        onBrowseTapped: openBrowseAll,
                        onDismiss: dismissPracticeOverlay,
                        onCloseMatchToOrigin: returnFromPracticeMatchToOrigin,
                        onMatchPresentationChanged: { isPracticeMatchPresented = $0 },
                        onThreadBackToOrigin: returnFromPracticeThreadToOrigin,
                        onThreadPresentationChanged: { isPracticeThreadPresented = $0 }
                    )
                    .transition(.opacity)
                    .zIndex(AppChromeLayout.searchPageLayerZIndex + 2)
                }
            }
            .appShellChromeOverlays(
                currentRoute: navigation.currentRoute,
                isSearchPresented: navigation.isSearchPresented,
                isPracticeThreadPresented: isPracticeThreadPresented,
                hidesPhotoBackdropChrome: hidesPhotoBackdropChrome,
                topChromeStyle: effectiveTopChromeStyle,
                topChromeOpacityScale: topChromeOpacityScale,
                isPracticeMatchPresented: isPracticeMatchPresented || isPracticeOverlayPresented,
                showsStaticBackButton: showsStaticBackButton,
                showsMenuSectionChrome: showsMenuSectionChrome,
                canGoForward: navigation.canGoForward,
                backSwipeCaptureEdge: { backSwipeCaptureEdge(width: pageWidth) },
                forwardSwipeCaptureEdge: { forwardSwipeCaptureEdge(width: pageWidth) },
                topAdminRow: { showsPinnedAudioSpeedControl in
                    topAdminRow(showsPinnedAudioSpeedControl: showsPinnedAudioSpeedControl)
                },
                menuSectionRail: {
                    if let currentMenuSectionChromeState {
                        VietnameseMenuTopSectionRail(
                            state: currentMenuSectionChromeState,
                            onSelect: jumpToMenuSection
                        )
                    } else if let currentSavedTripSectionChromeState {
                        SavedTripTopSectionRail(
                            state: currentSavedTripSectionChromeState,
                            onSelect: jumpToSavedTripSection
                        )
                    }
                }
            )
            .onPreferenceChange(VietnameseMenuSectionChromePreferenceKey.self) { states in
                if menuSectionChromeStates != states {
                    menuSectionChromeStates = states
                }
            }
            .onPreferenceChange(PhrasePhotoBackdropImmersiveChromePreferenceKey.self) { isHidden in
                if hidesPhotoBackdropChrome != isHidden {
                    withAnimation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation) {
                        hidesPhotoBackdropChrome = isHidden
                    }
                }
            }
            .onPreferenceChange(PhrasePhotoBackdropTabBarBackgroundPreferenceKey.self) { isVisible in
                if showsPhotoBackdropTabBarBackground != isVisible {
                    withAnimation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation) {
                        showsPhotoBackdropTabBarBackground = isVisible
                    }
                }
            }
            .onPreferenceChange(PhrasePhotoBackdropTopChromeStylePreferenceKey.self) { style in
                if photoBackdropTopChromeStyle != style {
                    withAnimation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation) {
                        photoBackdropTopChromeStyle = style
                    }
                }
            }
            .onPreferenceChange(PhrasePhotoBackdropImmersiveImagePreferenceKey.self) { context in
                if photoBackdropImmersiveImageContext != context {
                    photoBackdropImmersiveImageContext = context
                }
            }
            .onPreferenceChange(SavedTripSectionChromePreferenceKey.self) { states in
                if savedTripSectionChromeStates != states {
                    savedTripSectionChromeStates = states
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
        }
    }

    @ViewBuilder
    private var practiceRouteSurface: some View {
        if shouldRenderPracticeRouteSurface {
            let practiceBackdropState = adminBackdropState(for: .practice)
            PracticeView(
                intentStore: intentStore,
                initialMode: launchPracticeMode,
                entryContext: launchPracticeEntryContext,
                startRequest: practiceStartRequest,
                isActive: navigation.currentRoute == .practice,
                scrollToTopTrigger: navigation.practiceScrollToTopTrigger,
                topContentClearance: showsStaticBackButton && !isPracticeMatchPresented ? AppChromeLayout.topAdminHitTestEnvelopeHeight : 0,
                photoBackdropState: practiceBackdropState,
                isPhotoBackdropVisible: isAdminBackdropSurfaceVisible(.practice),
                onOpenDetail: openDetailFromPractice,
                onBrowseTapped: openBrowseAll,
                onCloseMatchToOrigin: returnFromPracticeMatchToOrigin,
                onMatchPresentationChanged: { isPracticeMatchPresented = $0 },
                onThreadBackToOrigin: returnFromPracticeThreadToOrigin,
                onThreadPresentationChanged: { isPracticeThreadPresented = $0 }
            )
        } else {
            Color.clear
                .accessibilityHidden(true)
        }
    }

    private var shouldRenderPracticeRouteSurface: Bool {
        [navigation.currentRoute, navigation.backPreviewRoute, navigation.forwardPreviewRoute]
            .compactMap { $0 }
            .contains(.practice)
    }

    private var practiceStartRequest: PracticeStartRequest? {
        if requestedPracticeScenarioID != nil {
            return PracticeStartRequest(
                id: practiceStartRequestID,
                sourceID: "quick"
            )
        }

        if let requestedPracticeSourceID {
            return PracticeStartRequest(id: practiceStartRequestID, sourceID: requestedPracticeSourceID)
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

            if let menuKind = VietnameseMenuCatalog.kind(for: renderedCollection.route) {
                VietnameseMenuPageView(
                    kind: menuKind,
                    scrollToTopTrigger: navigation.browseCollectionScrollToTopTrigger,
                    scrollToTopRoute: navigation.browseCollectionScrollToTopRoute,
                    sectionJumpRequest: menuSectionJumpRequest,
                    isSaved: { intentStore.isPageSaved($0) },
                    onToggleSaved: { intentStore.toggleSavedPage($0) },
                    onOpenDetail: { openDetailFromBrowse($0) },
                    isActive: isActive
                )
                .allowsHitTesting(isActive && !navigation.isSearchPresented && allowsBasePageHitTesting)
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
            } else if let descriptor = BrowseSearchDestinations.collectionDescriptor(for: renderedCollection.route) {
                BrowseCollectionPageView(
                    descriptor: descriptor,
                    scrollToTopTrigger: navigation.browseCollectionScrollToTopTrigger,
                    scrollToTopRoute: navigation.browseCollectionScrollToTopRoute,
                    focusRequest: browseCollectionFocusRequest,
                    isActive: isActive,
                    isSaved: { intentStore.isPageSaved($0) },
                    onToggleSaved: { intentStore.toggleSavedPage($0) },
                    onOpenDetail: { pageID in
                        openDetailFromBrowse(pageID, heroImageName: descriptor.mastheadImageName)
                    },
                    onOpenCollection: openBrowseCollection,
                    onPractice: openPractice
                )
                .allowsHitTesting(isActive && !navigation.isSearchPresented && allowsBasePageHitTesting)
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

    private var systemTabSelection: Binding<AppSystemTab> {
        Binding(
            get: {
                selectedSystemTab
            },
            set: { tab in
                selectSystemTab(tab)
            }
        )
    }

    private var selectedSystemTab: AppSystemTab {
        navigation.isSearchPresented
            ? .search
            : AppSystemTab(route: navigation.rootRoute)
    }

    private func selectSystemTab(_ tab: AppSystemTab) {
        switch tab {
        case .home, .browse, .saved, .practice:
            openPrimarySystemTab(tab)
        case .search:
            openSearch(prefilledQuery: nil, focusField: false)
        }
    }

    private func handleBottomAdminTabTap(_ tab: AppSystemTab) {
        switch tab {
        case .home, .browse, .saved, .practice:
            openPrimarySystemTab(tab)
        case .search:
            if navigation.isSearchPresented {
                focusSearchField()
            } else {
                openSearch(prefilledQuery: nil, focusField: false)
            }
        }
    }

    private func jumpToMenuSection(_ sectionID: String) {
        guard let currentMenuSectionChromeState else {
            return
        }

        menuSectionJumpRequestID += 1
        menuSectionJumpRequest = VietnameseMenuSectionJumpRequest(
            requestID: menuSectionJumpRequestID,
            route: currentMenuSectionChromeState.route,
            sectionID: sectionID
        )
    }

    private func jumpToSavedTripSection(_ sectionID: String) {
        guard currentSavedTripSectionChromeState != nil else {
            return
        }

        savedTripSectionJumpRequestID += 1
        savedTripSectionJumpRequest = SavedTripSectionJumpRequest(
            requestID: savedTripSectionJumpRequestID,
            sectionID: sectionID
        )
    }

    private func openPrimarySystemTab(_ tab: AppSystemTab) {
        let previousRoute = navigation.currentRoute
        withoutRouteAnimation {
            cancelInteractiveChromeState()
            cancelSearchFocus()

            switch tab {
            case .home:
                clearPracticeThreadForwardRestore()
                navigation.openHome()
                searchQuery = ""
            case .browse:
                prepareHomeScrollRestoration()
                clearPracticeThreadForwardRestore()
                navigation.openBrowse()
            case .saved:
                prepareHomeScrollRestoration()
                clearPracticeThreadForwardRestore()
                navigation.openSaved()
            case .practice:
                prepareHomeScrollRestoration()
                clearPracticeThreadForwardRestore()
                clearPracticeStartRequest()
                navigation.openPractice()
            case .search:
                break
            }
        }
        activateAdminBackdropIfNeeded(from: previousRoute, to: navigation.currentRoute)
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
                    isActive: isActive,
                    onBackTapped: goBack
                )
                .allowsHitTesting(isActive && !navigation.isSearchPresented && allowsBasePageHitTesting)
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
                    isActive: isActive,
                    showsChrome: false,
                    topChromeContentClearance: pinnedAudioSpeedScrollClearance,
                    isSaved: intentStore.isPageSaved(renderedPage.pageID),
                    isPageSaved: { intentStore.isPageSaved($0) },
                    heroMorphPageID: homePhraseHeroMorphPageID,
                    heroMorphContentHoldPageID: homePhraseHeroContentHoldPageID,
                    heroImageNameOverride: browseDetailHeroImageOverrides[renderedPage.pageID],
                    onBackTapped: goBack,
                    onSearchTapped: openSearch,
                    onToggleSaved: { intentStore.toggleSavedPage(renderedPage.pageID) },
                    onToggleSavedPage: { intentStore.toggleSavedPage($0) },
                    onDetailTapped: openDetail
                )
                .allowsHitTesting(isActive && !navigation.isSearchPresented && allowsBasePageHitTesting)
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
        BrowseCollectionNativeTransition.usesCityDissolve(for: route)
            ? AppPageTransition.browseCityDissolve
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
            let homeBackdropState = adminBackdropState(for: .home)
            HomeView(
                intentStore: intentStore,
                backdropImageName: homeBackdropState.imageName,
                backdropActivationToken: homeBackdropState.activationToken,
                scrollToTopTrigger: 0,
                isActive: false,
                isSearchActive: navigation.isSearchPresented,
                currentScrollTarget: .constant(nil),
                currentScrollOffsetY: .constant(0),
                scrollRestorationTarget: .constant(nil),
                onSearchTapped: openSearch,
                onOpenDetail: { id, _ in openDetailFromHome(id) },
                onOpenFeaturedDetail: { id, _ in openFeaturedDetailFromHome(id) },
                onOpenCollection: { route, _ in openBrowseCollectionFromHome(route) },
                onStartPractice: { action, _ in openPractice(action) },
                onBrowseAllTapped: openBrowseAll
            )
        case .browse:
            let browseBackdropState = adminBackdropState(for: .browse)
            AdminPhotoBackdropSurfaceView(
                surface: .browse,
                backdropImageName: browseBackdropState.imageName,
                activationToken: browseBackdropState.activationToken,
                isActive: false,
                isVisible: true
            ) { _ in
                BrowsePageView(
                    intentStore: intentStore,
                    scrollToTopTrigger: 0,
                    usesPhotoBackdrop: true,
                    onOpenDetail: { openDetailFromBrowse($0) },
                    onOpenCollection: openBrowseCollection,
                    onSearchTapped: openSearch,
                    onSearchQuery: openSearchQuery
                )
            }
        case .browseCollection(let collectionRoute):
            if let menuKind = VietnameseMenuCatalog.kind(for: collectionRoute) {
                VietnameseMenuPageView(
                    kind: menuKind,
                    scrollToTopTrigger: 0,
                    scrollToTopRoute: nil,
                    sectionJumpRequest: nil,
                    isSaved: { intentStore.isPageSaved($0) },
                    onToggleSaved: { intentStore.toggleSavedPage($0) },
                    onOpenDetail: { openDetailFromBrowse($0) },
                    isActive: false
                )
            } else if let descriptor = BrowseSearchDestinations.collectionDescriptor(for: collectionRoute) {
                BrowseCollectionPageView(
                    descriptor: descriptor,
                    scrollToTopTrigger: 0,
                    scrollToTopRoute: nil,
                    focusRequest: nil,
                    isActive: false,
                    isSaved: { intentStore.isPageSaved($0) },
                    onToggleSaved: { intentStore.toggleSavedPage($0) },
                    onOpenDetail: { pageID in
                        openDetailFromBrowse(pageID, heroImageName: descriptor.mastheadImageName)
                    },
                    onOpenCollection: openBrowseCollection,
                    onPractice: openPractice
                )
            }
        case .saved:
            let savedBackdropState = adminBackdropState(for: .saved)
            AdminPhotoBackdropSurfaceView(
                surface: .saved,
                backdropImageName: savedBackdropState.imageName,
                activationToken: savedBackdropState.activationToken,
                isActive: false,
                isVisible: true
            ) { scrollProxy in
                SavedPagesView(
                    intentStore: intentStore,
                    scrollToTopTrigger: 0,
                    sectionJumpRequest: nil,
                    usesPhotoBackdrop: true,
                    backdropScrollProxy: scrollProxy,
                    onOpenDetail: openDetailFromSaved,
                    onBrowseTapped: openBrowseAll,
                    onStartSavedPractice: { openPractice(.practiceSource("saved")) }
                )
            }
        case .practice:
            let practiceBackdropState = adminBackdropState(for: .practice)
            PracticeView(
                intentStore: intentStore,
                startRequest: practiceStartRequest,
                isActive: false,
                scrollToTopTrigger: 0,
                topContentClearance: 0,
                photoBackdropState: practiceBackdropState,
                isPhotoBackdropVisible: true,
                onOpenDetail: openDetailFromPractice,
                onBrowseTapped: openBrowseAll,
                onCloseMatchToOrigin: returnFromPracticeMatchToOrigin,
                onMatchPresentationChanged: { isPracticeMatchPresented = $0 }
            )
        case .phrasePage:
            PhraseListingView(
                page: .xinChao,
                scrollToTopTrigger: navigation.rootScrollToTopTrigger,
                chromeNamespace: chromeNamespace,
                isSearchActive: navigation.isSearchPresented,
                isActive: false,
                showsChrome: false,
                topChromeContentClearance: pinnedAudioSpeedScrollClearance,
                isSaved: intentStore.isPageSaved(PhrasePage.xinChao.id),
                isPageSaved: { intentStore.isPageSaved($0) },
                onBackTapped: {},
                onSearchTapped: openSearch,
                onToggleSaved: { intentStore.toggleSavedPage(PhrasePage.xinChao.id) },
                onToggleSavedPage: { intentStore.toggleSavedPage($0) },
                onDetailTapped: openDetail
            )
        case .detailPage(let detailPageID):
            if Self.shouldRenderDesignedXinChaoPage(for: detailPageID) {
                xinChaoListingView(
                    routePageID: detailPageID,
                    scrollToTopTrigger: 0,
                    isActive: false,
                    onBackTapped: goBack
                )
            } else if let detailPage = PhraseDetailPage.page(withID: detailPageID) {
                PhraseDetailView(
                    page: detailPage,
                    scrollToTopTrigger: 0,
                    chromeNamespace: chromeNamespace,
                    isSearchActive: navigation.isSearchPresented,
                    isActive: false,
                    showsChrome: false,
                    topChromeContentClearance: pinnedAudioSpeedScrollClearance,
                    isSaved: intentStore.isPageSaved(detailPageID),
                    isPageSaved: { intentStore.isPageSaved($0) },
                    heroImageNameOverride: browseDetailHeroImageOverrides[detailPageID],
                    onBackTapped: goBack,
                    onSearchTapped: openSearch,
                    onToggleSaved: { intentStore.toggleSavedPage(detailPageID) },
                    onToggleSavedPage: { intentStore.toggleSavedPage($0) },
                    onDetailTapped: openDetail
                )
            }
        case .search:
            let searchBackdropState = adminBackdropState(for: .search)
            SearchPageView(
                query: $searchQuery,
                isFieldFocused: isSearchFieldFocused,
                returnFocusRequest: searchReturnFocusRequest,
                photoBackdropState: searchBackdropState,
                isPhotoBackdropActive: false,
                isPhotoBackdropVisible: true,
                onClose: closeSearch,
                onDismissSearchFocus: dismissSearchFieldFocus,
                onPrepareReturnFocus: prepareSearchReturnFocus,
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
        isActive: Bool = true,
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
            isActive: isActive,
            showsChrome: false,
            topChromeContentClearance: pinnedAudioSpeedScrollClearance,
            isSaved: intentStore.isPageSaved(routePageID),
            isPageSaved: { intentStore.isPageSaved($0) },
            heroMorphPageID: homePhraseHeroMorphPageID,
            heroMorphContentHoldPageID: homePhraseHeroContentHoldPageID,
            onBackTapped: onBackTapped,
            onSearchTapped: openSearch,
            onToggleSaved: { intentStore.toggleSavedPage(routePageID) },
            onToggleSavedPage: { intentStore.toggleSavedPage($0) },
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

    private var allowsBasePageHitTesting: Bool {
        !isPracticeOverlayPresented && !isPreviewingForwardPage
    }

    private var showsStaticBackButton: Bool {
        navigation.showsStaticBackButton
    }

    private var pinnedAudioSpeedScrollClearance: CGFloat {
        AppChromeLayout.pinnedAudioSpeedScrollClearance
    }

    private var currentMenuSectionChromeState: VietnameseMenuSectionChromeState? {
        guard case .browseCollection(let route) = navigation.currentRoute else {
            return nil
        }

        return menuSectionChromeStates.last { $0.route == route }
    }

    private var currentSavedTripSectionChromeState: SavedTripSectionChromeState? {
        guard navigation.currentRoute == .saved else {
            return nil
        }

        return savedTripSectionChromeStates.last
    }

    private var showsMenuSectionChrome: Bool {
        guard !isPracticeThreadPresented, !navigation.isSearchPresented else {
            return false
        }

        return currentMenuSectionChromeState?.isPinned == true
            || currentSavedTripSectionChromeState?.isPinned == true
    }

    private func topAdminRow(showsPinnedAudioSpeedControl: Bool) -> some View {
        Group {
            if #available(iOS 26.0, *) {
                GlassEffectContainer(spacing: 14) {
                    topAdminRowContent(showsPinnedAudioSpeedControl: showsPinnedAudioSpeedControl)
                }
            } else {
                topAdminRowContent(showsPinnedAudioSpeedControl: showsPinnedAudioSpeedControl)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: AppChromeLayout.topAdminControlSize)
    }

    private func topAdminRowContent(showsPinnedAudioSpeedControl: Bool) -> some View {
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

    private struct VietnameseMenuTopSectionRail: View {
        let state: VietnameseMenuSectionChromeState
        let onSelect: (String) -> Void

        private var currentSection: VietnameseMenuSectionChromeItem? {
            state.sections.first { $0.id == state.currentSectionID } ?? state.sections.first
        }

        var body: some View {
            HStack {
                Spacer(minLength: 0)

                Menu {
                    ForEach(state.sections) { section in
                        Button {
                            onSelect(section.id)
                        } label: {
                            Label(section.title, systemImage: section.symbolName)
                        }
                        .accessibilityIdentifier("VietnameseMenu.TopSectionMenu.\(section.id)")
                    }
                } label: {
                    HStack(spacing: 7) {
                        if let currentSection {
                            Image(systemName: currentSection.symbolName)
                                .font(.caption.weight(.black))
                                .foregroundStyle(currentSection.tintName.color)

                            Text(currentSection.title)
                                .font(.subheadline.weight(.black))
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.78)
                        }

                        Image(systemName: "chevron.down")
                            .font(.caption2.weight(.black))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 14)
                    .frame(height: AppChromeLayout.menuSectionChromeHeight)
                    .background(.white.opacity(0.42), in: Capsule(style: .continuous))
                    .overlay {
                        Capsule(style: .continuous)
                            .stroke(.white.opacity(AppSurfaceDepth.controlStrokeOpacity), lineWidth: 1)
                            .allowsHitTesting(false)
                    }
                    .contentShape(Capsule(style: .continuous))
                }
                .buttonStyle(.plain)
                .nativeGlass(in: Capsule(style: .continuous), tint: .white.opacity(0.18), interactive: true)
                .accessibilityLabel("Menu section")
                .accessibilityValue(currentSection?.title ?? "")
                .accessibilityIdentifier("VietnameseMenu.TopSectionPill")

                Spacer(minLength: 0)
            }
            .frame(height: AppChromeLayout.menuSectionChromeHeight)
        }
    }

    private struct SavedTripTopSectionRail: View {
        let state: SavedTripSectionChromeState
        let onSelect: (String) -> Void

        private var currentSection: SavedTripSectionChromeItem? {
            state.sections.first { $0.id == state.currentSectionID } ?? state.sections.first
        }

        var body: some View {
            HStack {
                Spacer(minLength: 0)

                Menu {
                    ForEach(state.sections) { section in
                        Button {
                            onSelect(section.id)
                        } label: {
                            Label(section.title, systemImage: section.symbolName)
                        }
                        .accessibilityIdentifier("SavedTrip.TopSectionMenu.\(section.id)")
                    }
                } label: {
                    HStack(spacing: 7) {
                        if let currentSection {
                            Image(systemName: currentSection.symbolName)
                                .font(.caption.weight(.black))
                                .foregroundStyle(currentSection.tintName.color)

                            Text(currentSection.title)
                                .font(.subheadline.weight(.black))
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.78)
                        }

                        Image(systemName: "chevron.down")
                            .font(.caption2.weight(.black))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 14)
                    .frame(height: AppChromeLayout.menuSectionChromeHeight)
                    .background(.white.opacity(0.42), in: Capsule(style: .continuous))
                    .overlay {
                        Capsule(style: .continuous)
                            .stroke(.white.opacity(AppSurfaceDepth.controlStrokeOpacity), lineWidth: 1)
                            .allowsHitTesting(false)
                    }
                    .contentShape(Capsule(style: .continuous))
                }
                .buttonStyle(.plain)
                .nativeGlass(in: Capsule(style: .continuous), tint: .white.opacity(0.18), interactive: true)
                .accessibilityLabel("Saved section")
                .accessibilityValue(currentSection?.title ?? "")
                .accessibilityIdentifier("SavedTrip.TopSectionPill")

                Spacer(minLength: 0)
            }
            .frame(height: AppChromeLayout.menuSectionChromeHeight)
        }
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

    private func prepareHomeScrollRestoration(_ target: HomeScrollTarget? = nil) {
        guard navigation.currentRoute == .home else {
            return
        }

        let resolvedTarget = target
            ?? homeScrollRestorationTarget?.target
            ?? homeCurrentScrollTarget
            ?? .top

        homeScrollRestorationTarget = HomeScrollRestorationTarget(
            target: resolvedTarget,
            offsetY: max(homeCurrentScrollOffsetY, 0)
        )
    }

    private func activateAdminBackdropIfNeeded(from previousRoute: AppRoute, to currentRoute: AppRoute) {
        guard let surface = AdminRootPhotoBackdropActivationPolicy.targetSurface(
            previousRoute: previousRoute,
            currentRoute: currentRoute
        ) else {
            return
        }

        let currentState = adminBackdropStates[surface] ?? .fallback
        guard AdminRootPhotoBackdropActivationPolicy.shouldRefreshImage(
            surface: surface,
            currentState: currentState
        ) else {
            return
        }

        adminBackdropStates[surface] = AdminRootPhotoBackdropState(
            imageName: SharedBackdropImagePool.nextImageName(for: surface.poolSurface),
            activationToken: currentState.activationToken + 1
        )
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

    private func openDetailFromBrowse(_ id: String, heroImageName: String? = nil) {
        if let heroImageName, heroImageName.hasPrefix("HeroCategory") {
            browseDetailHeroImageOverrides[id] = heroImageName
        } else {
            browseDetailHeroImageOverrides[id] = nil
        }

        openDetail(id, source: .browse)
    }

    private func openDetailFromSaved(_ id: String) {
        openDetail(id, source: .home)
    }

    private func openDetailFromPractice(_ id: String) {
        openDetail(id, source: .practice)
    }

    private func openDetail(_ id: String, source: UserIntentSource) {
        if source != .browse {
            browseDetailHeroImageOverrides[id] = nil
        }

        cancelInteractiveChromeState()
        clearPracticeThreadForwardRestore()
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
        clearPracticeThreadForwardRestore()
        withAnimation(BrowseCollectionNativeTransition.animation(for: route)) {
            navigation.openBrowseCollection(route)
        }
    }

    private func openBrowseCollectionFromHome(_ route: BrowseCollectionRoute) {
        cancelInteractiveChromeState()
        cancelSearchFocus()
        clearPracticeThreadForwardRestore()
        withAnimation(BrowseCollectionNativeTransition.animation(for: route)) {
            navigation.openHomeBrowseCollection(route)
        }
    }

    private func openBrowseCollectionFromSearch(_ route: BrowseCollectionRoute) {
        cancelInteractiveChromeState()
        cancelSearchFocus()
        clearPracticeThreadForwardRestore()
        withAnimation(BrowseCollectionNativeTransition.animation(for: route)) {
            navigation.openBrowseCollectionFromSearch(route)
        }
    }

    private func openBrowseAll() {
        if isPracticeOverlayPresented {
            dismissPracticeOverlay(resetStartRequest: true)
        }
        openBrowse()
    }

    private func openHome() {
        let previousRoute = navigation.currentRoute
        cancelInteractiveChromeState()
        cancelSearchFocus()
        clearPracticeThreadForwardRestore()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openHome()
        }
        activateAdminBackdropIfNeeded(from: previousRoute, to: navigation.currentRoute)
        searchQuery = ""
    }

    private func openBrowse() {
        let previousRoute = navigation.currentRoute
        cancelInteractiveChromeState()
        cancelSearchFocus()
        prepareHomeScrollRestoration()
        clearPracticeThreadForwardRestore()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openBrowse()
        }
        activateAdminBackdropIfNeeded(from: previousRoute, to: navigation.currentRoute)
    }

    private func openSaved() {
        let previousRoute = navigation.currentRoute
        cancelInteractiveChromeState()
        cancelSearchFocus()
        prepareHomeScrollRestoration()
        clearPracticeThreadForwardRestore()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openSaved()
        }
        activateAdminBackdropIfNeeded(from: previousRoute, to: navigation.currentRoute)
    }

    private func openPractice(preservingStartRequest: Bool = false) {
        cancelInteractiveChromeState()
        cancelSearchFocus()
        prepareHomeScrollRestoration()
        clearPracticeThreadForwardRestore()
        if !preservingStartRequest {
            clearPracticeStartRequest()
        }

        practiceOverlayResetTrigger += 1
        practiceOverlayBackdropOpacity = PracticeMatchPullUpMetrics.backdropOpacity
        withAnimation(.spring(response: 0.34, dampingFraction: 0.88)) {
            isPracticeOverlayPresented = true
        }
    }

    private func openPractice(_ action: BrowseCollectionPracticeAction) {
        let matchReturnFocus = currentBrowseCollectionPracticeFocusRequest()

        switch action {
        case .addStarterPages(let pageIDs):
            intentStore.addPracticePages(pageIDs)
            practiceStartRequestID += 1
            requestedPracticeSourceID = pageIDs.isEmpty ? "quick" : "practice"
            requestedPracticeMode = nil
            requestedPracticeScenarioID = nil
            requestedPracticeScenarioThreadDismissal = .messagesHub
            pendingPracticeThreadReturnFocus = nil
            pendingPracticeMatchReturnFocus = matchReturnFocus
        case .practiceSource(let sourceID):
            practiceStartRequestID += 1
            requestedPracticeSourceID = sourceID
            requestedPracticeMode = nil
            requestedPracticeScenarioID = nil
            requestedPracticeScenarioThreadDismissal = .messagesHub
            pendingPracticeThreadReturnFocus = nil
            pendingPracticeMatchReturnFocus = matchReturnFocus
        case .practiceMode(let mode):
            practiceStartRequestID += 1
            requestedPracticeSourceID = nil
            requestedPracticeMode = mode
            requestedPracticeScenarioID = nil
            requestedPracticeScenarioThreadDismissal = .messagesHub
            pendingPracticeThreadReturnFocus = nil
            pendingPracticeMatchReturnFocus = matchReturnFocus
        case .practiceScenario:
            practiceStartRequestID += 1
            requestedPracticeSourceID = "quick"
            requestedPracticeMode = nil
            requestedPracticeScenarioID = nil
            clearPracticeThreadForwardRestore()
            requestedPracticeScenarioThreadDismissal = .messagesHub
            pendingPracticeThreadReturnFocus = nil
            pendingPracticeMatchReturnFocus = nil
        }

        openPractice(preservingStartRequest: true)
    }

    private func currentBrowseCollectionPracticeFocusRequest() -> BrowseCollectionFocusRequest? {
        guard case let .browseCollection(route) = navigation.currentRoute else {
            return nil
        }

        return BrowseCollectionFocusRequest(
            id: 0,
            route: route,
            target: .practiceEntry
        )
    }

    private func returnFromPracticeThreadToOrigin(_ scenarioID: PracticeScenarioID?) {
        let previousRoute = navigation.currentRoute
        let focusRequest = pendingPracticeThreadReturnFocus
        pendingPracticeThreadReturnFocus = nil
        if let scenarioID {
            pendingPracticeThreadForwardRestore = PracticeThreadForwardRestore(
                scenarioID: scenarioID,
                focusRequest: focusRequest
            )
        }
        cancelInteractiveChromeState()
        prepareBrowseCollectionFocusRestoreIfNeeded(focusRequest)
        withAnimation(.snappy(duration: 0.34)) {
            navigation.goBack()
        }
        activateAdminBackdropIfNeeded(from: previousRoute, to: navigation.currentRoute)
    }

    private func returnFromPracticeMatchToOrigin() {
        let previousRoute = navigation.currentRoute
        let focusRequest = pendingPracticeMatchReturnFocus
        cancelInteractiveChromeState()
        clearPracticeStartRequest()
        prepareBrowseCollectionFocusRestoreIfNeeded(focusRequest)
        pendingPracticeMatchReturnFocus = nil

        if isPracticeOverlayPresented {
            dismissPracticeOverlay(resetStartRequest: false)
            return
        }

        withAnimation(.snappy(duration: 0.34)) {
            navigation.goBack()
        }
        activateAdminBackdropIfNeeded(from: previousRoute, to: navigation.currentRoute)
    }

    private func dismissPracticeOverlay() {
        dismissPracticeOverlay(resetStartRequest: true)
    }

    private func dismissPracticeOverlay(resetStartRequest: Bool) {
        if resetStartRequest {
            clearPracticeStartRequest()
        }

        withAnimation(.spring(response: 0.28, dampingFraction: 0.92)) {
            isPracticeMatchPresented = false
            isPracticeThreadPresented = false
            isPracticeOverlayPresented = false
        }
        refreshTabBarVisibilitySoon()
    }

    private func refreshTabBarVisibilitySoon() {
        restoreSystemTabBarVisibility()

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 220_000_000)
            tabBarVisibilityRefreshID += 1
            restoreSystemTabBarVisibility()
        }
    }

    private func restoreSystemTabBarVisibility() {
        #if canImport(UIKit)
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        for window in scenes.flatMap(\.windows) {
            guard let tabBar = window.rootViewController?.findDescendantTabBar() else {
                continue
            }

            tabBar.isHidden = false
            tabBar.alpha = 1
            tabBar.isUserInteractionEnabled = true
        }
        #endif
    }

    private func prepareBrowseCollectionFocusRestoreIfNeeded(_ focusRequest: BrowseCollectionFocusRequest?) {
        guard let focusRequest else {
            return
        }

        browseCollectionFocusRequestID += 1
        let request = BrowseCollectionFocusRequest(
            id: browseCollectionFocusRequestID,
            route: focusRequest.route,
            target: focusRequest.target
        )
        browseCollectionFocusRequest = request

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if browseCollectionFocusRequest == request {
                browseCollectionFocusRequest = nil
            }
        }
    }

    private func goBack() {
        let previousRoute = navigation.currentRoute
        cancelInteractiveChromeState()
        preparePracticeMatchFocusRestoreIfNeeded()
        withAnimation(.snappy(duration: 0.34)) {
            navigation.goBack()
        }
        activateAdminBackdropIfNeeded(from: previousRoute, to: navigation.currentRoute)
    }

    private func preparePracticeMatchFocusRestoreIfNeeded() {
        guard navigation.currentRoute == .practice else {
            return
        }

        prepareBrowseCollectionFocusRestoreIfNeeded(pendingPracticeMatchReturnFocus)
    }

    private func goForward() {
        let previousRoute = navigation.currentRoute
        cancelInteractiveChromeState()
        let shouldFocusSearch = navigation.forwardPreviewRoute == .search
        withAnimation(.snappy(duration: 0.34)) {
            navigateForwardInState()
        }
        activateAdminBackdropIfNeeded(from: previousRoute, to: navigation.currentRoute)
        if shouldFocusSearch {
            focusSearchField()
        }
    }

    private func openSearch() {
        openSearch(prefilledQuery: nil, focusField: false)
    }

    private func openSearchQuery(_ query: String) {
        openSearch(prefilledQuery: query, focusField: isSearchFieldFocused)
    }

    private func openSearch(prefilledQuery: String?, focusField: Bool) {
        let previousRoute = navigation.currentRoute
        cancelInteractiveChromeState()
        clearPracticeThreadForwardRestore()
        prepareHomeScrollRestoration()
        if !navigation.isSearchPresented {
            searchReturnFocusRequest = nil
        }
        if let prefilledQuery {
            searchQuery = prefilledQuery
        }

        if !focusField {
            isSearchPresentationActive = false
            isSearchFieldFocused = false
        }

        withoutRouteAnimation {
            navigation.openSearch()
        }
        activateAdminBackdropIfNeeded(from: previousRoute, to: navigation.currentRoute)

        if focusField {
            focusSearchField()
        }
    }

    private func prepareSearchReturnFocus(_ scrollID: String) {
        searchReturnFocusRequestID += 1
        searchReturnFocusRequest = SearchReturnFocusRequest(
            id: searchReturnFocusRequestID,
            scrollID: scrollID
        )
    }

    private func closeSearch() {
        let previousRoute = navigation.currentRoute
        cancelSearchFocus()
        cancelInteractiveChromeState()
        withAnimation(.snappy(duration: AppChromeLayout.searchMorphDuration)) {
            navigation.goBack()
        }
        activateAdminBackdropIfNeeded(from: previousRoute, to: navigation.currentRoute)
    }

    private func dismissSearchFieldFocus() {
        searchFocusRequestID += 1
        isSearchPresentationActive = false
        isSearchFieldFocused = false
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }

    private func focusSearchField() {
        searchFocusRequestID += 1
        let requestID = searchFocusRequestID
        isSearchPresentationActive = true
        isSearchFieldFocused = true

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

        guard navigation.isSearchPresented else {
            return
        }

        if launchSearchShouldFocus {
            focusSearchField()
        } else {
            dismissSearchFieldFocus()
        }
    }

    private func cancelSearchFocus() {
        searchFocusRequestID += 1
        isSearchPresentationActive = false
        isSearchFieldFocused = false
    }

    private func cancelInteractiveChromeState() {
        interactiveDragResolutionID += 1
        homePhraseHeroMorphResetID += 1
        homePhraseHeroRoutePageID = nil
        homePhraseHeroMorphPageID = nil
        homePhraseHeroContentHoldPageID = nil
        interactiveDrag = nil
    }

    private func clearPracticeStartRequest() {
        requestedPracticeSourceID = nil
        requestedPracticeMode = nil
        requestedPracticeScenarioID = nil
        requestedPracticeScenarioThreadDismissal = .messagesHub
        pendingPracticeThreadReturnFocus = nil
        pendingPracticeMatchReturnFocus = nil
    }

    private func clearPracticeThreadForwardRestore() {
        pendingPracticeThreadForwardRestore = nil
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
                let previousRoute = navigation.currentRoute
                switch direction {
                case .back:
                    preparePracticeMatchFocusRestoreIfNeeded()
                    navigation.goBack()
                case .forward:
                    navigateForwardInState()
                }
                activateAdminBackdropIfNeeded(from: previousRoute, to: navigation.currentRoute)
                interactiveDrag = nil
            }
        }
    }

    private func navigateForwardInState() {
        preparePracticeThreadForwardRestoreIfNeeded(for: navigation.forwardPreviewRoute)
        navigation.goForward()
    }

    private func preparePracticeThreadForwardRestoreIfNeeded(for route: AppRoute?) {
        guard route == .practice else {
            return
        }

        guard let restore = pendingPracticeThreadForwardRestore else {
            if requestedPracticeSourceID == nil, requestedPracticeMode == nil, requestedPracticeScenarioID == nil {
                clearPracticeStartRequest()
            }
            return
        }

        practiceStartRequestID += 1
        requestedPracticeSourceID = nil
        requestedPracticeMode = nil
        requestedPracticeScenarioID = restore.scenarioID
        requestedPracticeScenarioThreadDismissal = .originRoute
        pendingPracticeThreadReturnFocus = restore.focusRequest
        pendingPracticeThreadForwardRestore = nil
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
        if let canonicalPageID = PhraseCatalog.canonicalPageID(forOpenablePageID: pageID) {
            return .detailPage(canonicalPageID)
        }

        if VietnameseMenuCatalog.detailItem(withPageID: pageID) != nil {
            return .detailPage(pageID)
        }

        return shortcutRoute(for: arguments)
    }

    private static func shortcutRoute(for arguments: [String]) -> AppRoute {
        if let route = initialBrowseCollectionRoute(for: arguments) {
            return .browseCollection(route)
        }

        if arguments.contains("--browse") {
            return .browse
        }

        if arguments.contains("--saved") {
            return .saved
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

        if let searchResultBackPreviewRoute {
            return searchResultBackPreviewRoute
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

    private var searchResultBackPreviewRoute: AppRoute? {
        guard let snapshot = backStack.last, snapshot.isSearchPresented else {
            return nil
        }

        if !detailPath.isEmpty {
            guard
                rootRoute == snapshot.rootRoute,
                browseCollectionPath == snapshot.browseCollectionPath,
                Array(detailPath.dropLast()) == snapshot.detailPath
            else {
                return nil
            }

            return .search
        }

        guard !browseCollectionPath.isEmpty else {
            return nil
        }

        if rootRoute == snapshot.rootRoute,
           Array(browseCollectionPath.dropLast()) == snapshot.browseCollectionPath,
           snapshot.detailPath.isEmpty {
            return .search
        }

        if browseCollectionPath.count == snapshot.browseCollectionPath.count + 1,
           Array(browseCollectionPath.dropLast()) == snapshot.browseCollectionPath,
           !snapshot.detailPath.isEmpty {
            return .search
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

    var showsStaticBackButton: Bool {
        switch currentRoute {
        case .home:
            return false
        case .practice:
            return hasExplicitBackHistory
        default:
            return backPreviewRoute != nil
        }
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

    private mutating func recordSearchRouteForBackHistoryIfNeeded() {
        guard isSearchPresented else {
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
            ?? (VietnameseMenuCatalog.detailItem(withPageID: id) == nil ? nil : id)

        if id == PhrasePage.xinChao.id && canonicalPageID == PhrasePage.xinChao.id {
            guard currentRoute != .phrasePage else {
                rootScrollToTopTrigger += 1
                return
            }

            recordSearchRouteForBackHistoryIfNeeded()
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
            if isSearchPresented {
                isSearchPresented = false
                forwardStack.removeAll()
                detailScrollToTopRoute = .detailPage(canonicalPageID)
                detailScrollToTopTrigger += 1
            }
            return
        }

        recordSearchRouteForBackHistoryIfNeeded()
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

    mutating func openBrowseCollectionFromSearch(_ route: BrowseCollectionRoute) {
        let originRoute = routeBelowSearch
        let originSnapshot = AppShellNavigationSnapshot(
            rootRoute: rootRoute,
            browseCollectionPath: browseCollectionPath,
            detailPath: detailPath,
            isSearchPresented: false
        )

        if originRoute == .browseCollection(route) {
            isSearchPresented = false
            forwardStack.removeAll()
            browseCollectionScrollToTopRoute = route
            browseCollectionScrollToTopTrigger += 1
            return
        }

        if isSearchPresented {
            recordSearchRouteForBackHistoryIfNeeded()
        } else if case .detailPage = originRoute, backStack.last != originSnapshot {
            backStack.append(originSnapshot)
        }

        rootRoute = rootRoute == .home ? .home : .browse
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
                restoreSearchBackStackAfterPoppingCollectionIfNeeded()
                restoreExplicitBackStackAfterPoppingCollectionIfNeeded()
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
        restoreSearchBackStackAfterPoppingDetailIfNeeded()
    }

    private mutating func restoreSearchBackStackAfterPoppingDetailIfNeeded() {
        guard let previousSnapshot = backStack.last, previousSnapshot.isSearchPresented else {
            return
        }

        guard
            rootRoute == previousSnapshot.rootRoute,
            browseCollectionPath == previousSnapshot.browseCollectionPath,
            detailPath == previousSnapshot.detailPath
        else {
            return
        }

        restore(backStack.removeLast())
    }

    private mutating func restoreSearchBackStackAfterPoppingCollectionIfNeeded() {
        guard let previousSnapshot = backStack.last, previousSnapshot.isSearchPresented else {
            return
        }

        if rootRoute == previousSnapshot.rootRoute,
           browseCollectionPath == previousSnapshot.browseCollectionPath,
           detailPath == previousSnapshot.detailPath {
            restore(backStack.removeLast())
            return
        }

        if rootRoute == previousSnapshot.rootRoute,
           browseCollectionPath == previousSnapshot.browseCollectionPath,
           detailPath.isEmpty,
           !previousSnapshot.detailPath.isEmpty {
            restore(backStack.removeLast())
        }
    }

    private mutating func restoreExplicitBackStackAfterPoppingCollectionIfNeeded() {
        guard browseCollectionPath.isEmpty, let previousSnapshot = backStack.last else {
            return
        }

        switch previousSnapshot.currentRoute {
        case .detailPage, .phrasePage, .saved, .practice:
            restore(backStack.removeLast())
        case .home, .browse, .browseCollection, .search:
            return
        }
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

    static let browseCityDissolve = AnyTransition.asymmetric(
        insertion: .opacity.animation(BrowseCollectionNativeTransition.cityDissolveAnimation),
        removal: .opacity.animation(BrowseCollectionNativeTransition.cityDissolveAnimation)
    )
}

enum BrowseCollectionNativeTransition {
    static let cityDissolveDuration: TimeInterval = 0.22
    static let cityDissolveAnimation: Animation = .easeInOut(duration: cityDissolveDuration)

    static func usesCityDissolve(for route: BrowseCollectionRoute) -> Bool {
        guard case .city = route else {
            return false
        }

        return true
    }

    static func animation(for route: BrowseCollectionRoute) -> Animation {
        usesCityDissolve(for: route)
            ? cityDissolveAnimation
            : .snappy(duration: 0.34)
    }
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
                color: .black.opacity(presentation.shadowOpacity * 0.55),
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
    func appShellChromeOverlays<BackSwipeCaptureEdge: View, ForwardSwipeCaptureEdge: View, TopAdminRow: View, MenuSectionRail: View>(
        currentRoute: AppRoute,
        isSearchPresented: Bool,
        isPracticeThreadPresented: Bool,
        hidesPhotoBackdropChrome: Bool,
        topChromeStyle: ChromeSeparationGradientStyle,
        topChromeOpacityScale: Double,
        isPracticeMatchPresented: Bool,
        showsStaticBackButton: Bool,
        showsMenuSectionChrome: Bool,
        canGoForward: Bool,
        @ViewBuilder backSwipeCaptureEdge: @escaping () -> BackSwipeCaptureEdge,
        @ViewBuilder forwardSwipeCaptureEdge: @escaping () -> ForwardSwipeCaptureEdge,
        @ViewBuilder topAdminRow: @escaping (_ showsPinnedAudioSpeedControl: Bool) -> TopAdminRow,
        @ViewBuilder menuSectionRail: @escaping () -> MenuSectionRail
    ) -> some View {
        modifier(
            AppShellChromeOverlayModifier(
                currentRoute: currentRoute,
                isSearchPresented: isSearchPresented,
                isPracticeThreadPresented: isPracticeThreadPresented,
                hidesPhotoBackdropChrome: hidesPhotoBackdropChrome,
                topChromeStyle: topChromeStyle,
                topChromeOpacityScale: topChromeOpacityScale,
                isPracticeMatchPresented: isPracticeMatchPresented,
                showsStaticBackButton: showsStaticBackButton,
                showsMenuSectionChrome: showsMenuSectionChrome,
                canGoForward: canGoForward,
                backSwipeCaptureEdge: backSwipeCaptureEdge,
                forwardSwipeCaptureEdge: forwardSwipeCaptureEdge,
                topAdminRow: topAdminRow,
                menuSectionRail: menuSectionRail
            )
        )
    }

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

private struct PhotoBackdropImmersiveImageCover: View {
    let context: PhrasePhotoBackdropImmersiveImageContext

    var body: some View {
        GeometryReader { geometry in
            let viewportSize = context.viewportSize
            let frameHeight = max(context.imageFrameHeight, geometry.size.height)

            Image(context.imageName)
                .resizable()
                .scaledToFill()
                .frame(
                    width: viewportSize.width,
                    height: frameHeight,
                    alignment: .top
                )
                .offset(y: -context.verticalFocusOffset)
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    alignment: .top
                )
                .clipped()
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

private struct BottomAdminHitTestOverlay: View {
    let selectedTab: AppSystemTab
    let onSelect: (AppSystemTab) -> Void

    private let tabs: [AppSystemTab] = [
        .home,
        .browse,
        .saved,
        .practice,
        .search,
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                Button {
                    onSelect(tab)
                } label: {
                    Color.clear
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .accessibilityHidden(true)
            }
        }
        .id(selectedTab)
        .frame(maxWidth: .infinity)
        .frame(height: AppChromeLayout.bottomAdminHitTestEnvelopeHeight)
        .ignoresSafeArea(edges: .bottom)
        .allowsHitTesting(true)
        .accessibilityHidden(true)
    }
}

#if canImport(UIKit)
enum AppShellTabBarVisibilityTransition {
    static let duration = PhrasePhotoBackdropLayout.immersiveDissolveDuration
}

private struct AppShellTabBarAppearanceBridge: UIViewControllerRepresentable {
    let usesContentBackground: Bool
    let isHidden: Bool

    func makeUIViewController(context: Context) -> Controller {
        Controller()
    }

    func updateUIViewController(_ controller: Controller, context: Context) {
        controller.usesContentBackground = usesContentBackground
        controller.isHidden = isHidden
    }

    final class Controller: UIViewController {
        private var lastAppliedIsHidden: Bool?

        var usesContentBackground = false {
            didSet {
                guard oldValue != usesContentBackground else {
                    return
                }
                applyAppearance()
            }
        }
        var isHidden = false {
            didSet {
                guard oldValue != isHidden else {
                    return
                }
                applyAppearance()
            }
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            applyAppearance()
        }

        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            applyAppearance()
        }

        private func applyAppearance(retryCount: Int = 3) {
            let usesContentBackground = usesContentBackground
            let isHidden = isHidden

            DispatchQueue.main.async { [weak self] in
                guard let self, let tabBar = self.findTabBar() else {
                    if retryCount > 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                            self?.applyAppearance(retryCount: retryCount - 1)
                        }
                    }
                    return
                }
                let targetAlpha: CGFloat = isHidden ? 0 : 1
                let shouldAnimateVisibility = self.lastAppliedIsHidden.map { $0 != isHidden } ?? false
                self.lastAppliedIsHidden = isHidden

                let appearance = UITabBarAppearance()
                if isHidden {
                    appearance.configureWithTransparentBackground()
                    appearance.backgroundColor = .clear
                    appearance.shadowColor = .clear
                    tabBar.backgroundColor = .clear
                    tabBar.isTranslucent = true
                    tabBar.layer.shadowOpacity = 0
                } else if usesContentBackground {
                    appearance.configureWithTransparentBackground()
                    appearance.backgroundColor = .clear
                    appearance.shadowColor = .clear
                    tabBar.backgroundColor = .clear
                    tabBar.isTranslucent = true
                    tabBar.layer.shadowOpacity = 0
                } else {
                    appearance.configureWithDefaultBackground()
                    appearance.shadowColor = nil
                    tabBar.layer.shadowOpacity = 0
                }

                tabBar.standardAppearance = appearance
                tabBar.scrollEdgeAppearance = appearance
                tabBar.isHidden = false
                tabBar.isUserInteractionEnabled = !isHidden

                guard shouldAnimateVisibility else {
                    tabBar.alpha = targetAlpha
                    return
                }

                UIView.animate(
                    withDuration: AppShellTabBarVisibilityTransition.duration,
                    delay: 0,
                    options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseInOut]
                ) {
                    tabBar.alpha = targetAlpha
                }
            }
        }

        private func findTabBar() -> UITabBar? {
            if let tabBar = tabBarController?.tabBar {
                return tabBar
            }

            var ancestor = parent
            while let controller = ancestor {
                if let tabController = controller as? UITabBarController {
                    return tabController.tabBar
                }

                if let tabBar = controller.tabBarController?.tabBar {
                    return tabBar
                }

                ancestor = controller.parent
            }

            return view.window?.rootViewController?.findDescendantTabBar()
        }
    }
}

private extension UIViewController {
    func findDescendantTabBar() -> UITabBar? {
        if let tabController = self as? UITabBarController {
            return tabController.tabBar
        }

        for child in children {
            if let tabBar = child.findDescendantTabBar() {
                return tabBar
            }
        }

        if let presentedViewController,
           let tabBar = presentedViewController.findDescendantTabBar()
        {
            return tabBar
        }

        return nil
    }
}
#endif

private struct AppShellChromeOverlayModifier<BackSwipeCaptureEdge: View, ForwardSwipeCaptureEdge: View, TopAdminRow: View, MenuSectionRail: View>: ViewModifier {
    @State private var pinnedAudioSpeedChromeState = PinnedAudioSpeedChromeState.hidden

    let currentRoute: AppRoute
    let isSearchPresented: Bool
    let isPracticeThreadPresented: Bool
    let hidesPhotoBackdropChrome: Bool
    let topChromeStyle: ChromeSeparationGradientStyle
    let topChromeOpacityScale: Double
    let isPracticeMatchPresented: Bool
    let showsStaticBackButton: Bool
    let showsMenuSectionChrome: Bool
    let canGoForward: Bool
    let backSwipeCaptureEdge: () -> BackSwipeCaptureEdge
    let forwardSwipeCaptureEdge: () -> ForwardSwipeCaptureEdge
    let topAdminRow: (_ showsPinnedAudioSpeedControl: Bool) -> TopAdminRow
    let menuSectionRail: () -> MenuSectionRail

    func body(content: Content) -> some View {
        let showsPinnedAudioSpeedControl = PinnedAudioSpeedChromePolicy.shouldShowPinnedControl(
            chromeState: pinnedAudioSpeedChromeState,
            currentRoute: currentRoute,
            hasStaticBackButton: showsStaticBackButton,
            isSearchPresented: isSearchPresented,
            isMenuSectionChromeVisible: showsMenuSectionChrome
        )
        let showsTopAdminRow = !hidesPhotoBackdropChrome
            && !isPracticeThreadPresented
            && !isPracticeMatchPresented
            && (showsStaticBackButton || showsPinnedAudioSpeedControl || canGoForward)
        let showsTopGlassChrome = !hidesPhotoBackdropChrome
            && (showsTopAdminRow || showsMenuSectionChrome)

        content
            .onPreferenceChange(PhraseAudioPlayerAnchorPreferenceKey.self) { anchors in
                let nextState = PinnedAudioSpeedChromePolicy.state(
                    for: anchors,
                    currentRoute: currentRoute
                )

                if nextState != pinnedAudioSpeedChromeState {
                    pinnedAudioSpeedChromeState = nextState
                }
            }
            .overlay(alignment: .leading) {
                if !isPracticeThreadPresented {
                    backSwipeCaptureEdge()
                }
            }
            .overlay(alignment: .trailing) {
                if !isPracticeThreadPresented {
                    forwardSwipeCaptureEdge()
                }
            }
            .overlay(alignment: .top) {
                if !isPracticeThreadPresented && !hidesPhotoBackdropChrome {
                    ChromeSeparationGradient(
                        edge: .top,
                        extendsBehindMenuSectionChrome: showsMenuSectionChrome,
                        style: topChromeStyle,
                        opacityScale: topChromeOpacityScale
                    )
                        .zIndex(AppChromeLayout.chromeSeparationLayerZIndex)
                }
            }
            .overlay(alignment: .top) {
                if showsTopGlassChrome {
                    TopAdminHitTestEnvelope()
                        .zIndex(AppChromeLayout.topAdminHitTestLayerZIndex)
                }
            }
            .overlay(alignment: .top) {
                if !isPracticeThreadPresented, showsTopGlassChrome {
                    VStack(spacing: AppChromeLayout.menuSectionChromeRowSpacing) {
                        if showsTopAdminRow {
                            topAdminRow(showsPinnedAudioSpeedControl)
                        }

                        if showsMenuSectionChrome {
                            menuSectionRail()
                                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                        }
                    }
                        .padding(.horizontal, AppChromeLayout.topAdminHorizontalPadding)
                        .padding(.top, AppChromeLayout.topAdminTopPadding)
                        .zIndex(AppChromeLayout.topAdminControlLayerZIndex)
                }
            }
    }
}

// MARK: - Home Surfaces

struct HomeView: View {
    @ObservedObject var intentStore: LocalUserIntentStore
    @Binding var currentScrollTarget: HomeScrollTarget?
    @Binding var currentScrollOffsetY: CGFloat
    @Binding var scrollRestorationTarget: HomeScrollRestorationTarget?
    @State private var scrollPosition = ScrollPosition(idType: HomeScrollTarget.self, edge: .top)
    @State private var didApplyPhotoBackdropInitialPosition = false
    @State private var isPhotoBackdropImmersive = false
    @State private var photoBackdropScrollOffset: CGFloat = 0

    let backdropImageName: String
    let backdropActivationToken: Int
    let scrollToTopTrigger: Int
    let isActive: Bool
    let isSearchActive: Bool
    var onSearchTapped: () -> Void
    var onOpenDetail: (String, HomeScrollTarget) -> Void
    var onOpenFeaturedDetail: (String, HomeScrollTarget) -> Void
    var onOpenCollection: (BrowseCollectionRoute, HomeScrollTarget) -> Void
    var onStartPractice: (BrowseCollectionPracticeAction, HomeScrollTarget) -> Void
    var onBrowseAllTapped: () -> Void

    init(
        intentStore: LocalUserIntentStore,
        backdropImageName: String = SharedBackdropImagePool.fallbackImageName,
        backdropActivationToken: Int = 0,
        scrollToTopTrigger: Int = 0,
        isActive: Bool = true,
        isSearchActive: Bool = false,
        currentScrollTarget: Binding<HomeScrollTarget?>,
        currentScrollOffsetY: Binding<CGFloat>,
        scrollRestorationTarget: Binding<HomeScrollRestorationTarget?>,
        onSearchTapped: @escaping () -> Void,
        onOpenDetail: @escaping (String, HomeScrollTarget) -> Void,
        onOpenFeaturedDetail: @escaping (String, HomeScrollTarget) -> Void,
        onOpenCollection: @escaping (BrowseCollectionRoute, HomeScrollTarget) -> Void,
        onStartPractice: @escaping (BrowseCollectionPracticeAction, HomeScrollTarget) -> Void,
        onBrowseAllTapped: @escaping () -> Void
    ) {
        self.intentStore = intentStore
        self.backdropImageName = backdropImageName
        self.backdropActivationToken = backdropActivationToken
        self._currentScrollTarget = currentScrollTarget
        self._currentScrollOffsetY = currentScrollOffsetY
        self._scrollRestorationTarget = scrollRestorationTarget
        self.scrollToTopTrigger = scrollToTopTrigger
        self.isActive = isActive
        self.isSearchActive = isSearchActive
        self.onSearchTapped = onSearchTapped
        self.onOpenDetail = onOpenDetail
        self.onOpenFeaturedDetail = onOpenFeaturedDetail
        self.onOpenCollection = onOpenCollection
        self.onStartPractice = onStartPractice
        self.onBrowseAllTapped = onBrowseAllTapped
    }

    var body: some View {
        GeometryReader { geometry in
            let metrics = PhrasePhotoBackdropLayout.metrics(for: geometry.size)
            let sheetTop = max(metrics.collapsedContentTop - photoBackdropScrollOffset, 0)
            let topChromeStyle = PhrasePhotoBackdropLayout.topChromeStyle(
                sheetTop: sheetTop,
                safeAreaTop: geometry.safeAreaInsets.top,
                topChromeBackdropHeight: AppChromeLayout.topChromeBackdropHeight(showsMenuSectionChrome: false)
            )

            ZStack(alignment: .top) {
                photoBackdropImage(geometry: geometry)

                photoBackdropBottomChromeBackdrop(geometry: geometry, metrics: metrics)

                ScrollViewReader { scrollProxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            Color.clear
                                .frame(height: metrics.initialAnchorOffset)
                                .accessibilityHidden(true)

                            Color.clear
                                .frame(height: 1)
                                .id(HomeScrollTarget.top)
                                .accessibilityHidden(true)

                            Color.clear
                                .frame(height: max(metrics.initialContentTop - 1, 0))
                                .accessibilityHidden(true)

                            homeContentSheet
                        }
                    }
                    .scrollPosition($scrollPosition)
                    .onScrollGeometryChange(for: HomePhotoBackdropScrollState.self, of: { scrollGeometry in
                        HomePhotoBackdropScrollState(
                            rawOffset: max(scrollGeometry.contentOffset.y + scrollGeometry.contentInsets.top, 0),
                            metrics: metrics
                        )
                    }) { _, scrollState in
                        if currentScrollOffsetY != scrollState.restorationOffset {
                            currentScrollOffsetY = scrollState.restorationOffset
                        }

                        if photoBackdropScrollOffset != scrollState.displayOffset {
                            photoBackdropScrollOffset = scrollState.displayOffset
                        }

                        if isPhotoBackdropImmersive, scrollState.hasPassedRevealThreshold {
                            withAnimation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation) {
                                isPhotoBackdropImmersive = false
                            }
                        }
                    }
                    .onAppear {
                        guard isActive else { return }
                        restoreScrollTargetIfNeeded(scrollProxy: scrollProxy, metrics: metrics)
                    }
                    .onChange(of: isActive) { _, isActive in
                        if isActive {
                            restoreScrollTargetIfNeeded(scrollProxy: scrollProxy, metrics: metrics)
                        } else if isPhotoBackdropImmersive {
                            isPhotoBackdropImmersive = false
                        }
                    }
                    .onChange(of: scrollToTopTrigger) { _, _ in
                        scrollRestorationTarget = nil
                        currentScrollTarget = .top
                        isPhotoBackdropImmersive = false
                        scrollProxy.scrollTo(HomeScrollTarget.top, anchor: .top)
                    }
                    .task(id: isActive) {
                        guard isActive, scrollRestorationTarget == nil else {
                            return
                        }

                        await applyPhotoBackdropInitialPositionIfNeeded(scrollProxy)
                        await AppBottomInsetValidation.scrollToBottom(scrollProxy, sentinelID: "Home.BottomSentinel")
                    }
                }
                .ignoresSafeArea(edges: .top)
            }
            .contentShape(Rectangle())
            .simultaneousGesture(
                SpatialTapGesture().onEnded { value in
                    togglePhotoBackdropImmersive(at: value.location, metrics: metrics)
                }
            )
            .preference(
                key: PhrasePhotoBackdropImmersiveImagePreferenceKey.self,
                value: isActive && isPhotoBackdropImmersive
                    ? PhrasePhotoBackdropImmersiveImageContext(
                        pageID: "home",
                        imageName: backdropImageName,
                        viewportSize: geometry.size,
                        safeAreaTop: geometry.safeAreaInsets.top,
                        safeAreaBottom: geometry.safeAreaInsets.bottom,
                        imageFrameHeight: PhrasePhotoBackdropLayout.backdropFrameHeight(
                            for: geometry.size,
                            safeAreaInsets: geometry.safeAreaInsets,
                            pageID: "home",
                            heroImageName: backdropImageName
                        ),
                        verticalFocusOffset: PhrasePhotoBackdropLayout.backdropVerticalFocusOffset(
                            for: geometry.size,
                            pageID: "home",
                            heroImageName: backdropImageName
                        )
                    )
                    : nil
            )
            .preference(
                key: PhrasePhotoBackdropTopChromeStylePreferenceKey.self,
                value: isActive && !isPhotoBackdropImmersive ? topChromeStyle : .light
            )
        }
        .ignoresSafeArea(edges: .bottom)
        .statusBarHidden(isActive && isPhotoBackdropImmersive)
        .persistentSystemOverlays(isActive && isPhotoBackdropImmersive ? .hidden : .automatic)
        .preference(
            key: PhrasePhotoBackdropImmersiveChromePreferenceKey.self,
            value: isActive && isPhotoBackdropImmersive
        )
        .preference(
            key: PhrasePhotoBackdropTabBarBackgroundPreferenceKey.self,
            value: isActive && !isPhotoBackdropImmersive
        )
        .accessibilityIdentifier("HomeView")
        .task(id: backdropActivationToken) {
            guard isActive else {
                return
            }

            AdminBackdropImagePreheater.preheat(
                HomeBackdropPreheatPolicy.imageNames(backdropImageName: backdropImageName)
            )
        }
    }

    private var homeContentSheet: some View {
        VStack(alignment: .leading, spacing: 0) {
            Capsule()
                .fill(.secondary.opacity(0.22))
                .frame(width: 42, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                .padding(.bottom, 10)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: HomeLayout.sectionSpacing) {
                header

                useNowShelf
                    .id(HomeScrollTarget.essentials)

                homepagePhraseShelf("first-day", scrollTarget: .firstDay)
                    .id(HomeScrollTarget.firstDay)

                cityShelf
                    .id(HomeScrollTarget.city)

                LazyVStack(alignment: .leading, spacing: HomeLayout.sectionSpacing) {
                    homepagePhraseShelf("food-coffee", scrollTarget: .foodCoffee)
                        .id(HomeScrollTarget.foodCoffee)

                    practiceScenariosShelf
                        .id(HomeScrollTarget.practice)

                    homepagePhraseShelf("taxi-getting-around", scrollTarget: .gettingAround)
                        .id(HomeScrollTarget.gettingAround)

                    situationShelves
                        .id(HomeScrollTarget.situations)

                    homepagePhraseShelf("when-stuck", scrollTarget: .whenStuck)
                        .id(HomeScrollTarget.whenStuck)

                    homepagePhraseShelf("hotel-basics", scrollTarget: .hotelBasics)
                        .id(HomeScrollTarget.hotelBasics)

                    relationshipShelf
                        .id(HomeScrollTarget.relationships)

                    homepagePhraseShelf("money-shopping", scrollTarget: .moneyShopping)
                        .id(HomeScrollTarget.moneyShopping)

                    homepagePhraseShelf("help-emergency", scrollTarget: .helpEmergency)
                        .id(HomeScrollTarget.helpEmergency)

                    recentlyViewedShelf
                        .id(HomeScrollTarget.recentlyViewed)

                    AppBottomSentinel(id: "Home.BottomSentinel")
                }
            }
            .padding(.bottom, HomeLayout.bottomContentClearance(usesPhotoBackdrop: true))
        }
        .background {
            UnevenRoundedRectangle(
                cornerRadii: RectangleCornerRadii(
                    topLeading: 34,
                    bottomLeading: 0,
                    bottomTrailing: 0,
                    topTrailing: 34
                ),
                style: .continuous
            )
            .fill(PhrasePageStyle.pageBackground)
        }
        .softLiftedSheetShadow()
        .opacity(isPhotoBackdropImmersive ? 0 : 1)
        .allowsHitTesting(!isPhotoBackdropImmersive)
        .accessibilityHidden(isPhotoBackdropImmersive)
        .animation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation, value: isPhotoBackdropImmersive)
        .accessibilityIdentifier("Home.PhotoBackdrop.Content")
    }

    private func photoBackdropImage(geometry: GeometryProxy) -> some View {
        HomePreparedImage(name: backdropImageName)
            .scaledToFill()
            .frame(
                width: geometry.size.width,
                height: PhrasePhotoBackdropLayout.backdropFrameHeight(
                    for: geometry.size,
                    safeAreaInsets: geometry.safeAreaInsets,
                    pageID: "home",
                    heroImageName: backdropImageName
                ),
                alignment: .top
            )
            .clipped()
            .ignoresSafeArea()
            .accessibilityLabel("Home backdrop")
            .accessibilityHidden(true)
            .accessibilityIdentifier("Home.PhotoBackdrop.Image")
    }

    private func photoBackdropBottomChromeBackdrop(
        geometry: GeometryProxy,
        metrics: PhrasePhotoBackdropLayout.Metrics
    ) -> some View {
        let safeAreaBottom = geometry.safeAreaInsets.bottom
        let sheetTop = max(metrics.collapsedContentTop - photoBackdropScrollOffset, 0)
        let backingFrameHeight = PhrasePhotoBackdropLayout.bottomChromeBackingFrameHeight(
            viewportHeight: geometry.size.height,
            safeAreaBottom: safeAreaBottom
        )
        let backdropHeight = PhrasePhotoBackdropLayout.bottomChromeBackingHeight(
            viewportHeight: geometry.size.height,
            safeAreaBottom: safeAreaBottom,
            sheetTop: sheetTop
        )
        let topCornerRadius = PhrasePhotoBackdropLayout.bottomChromeBackingTopCornerRadius(sheetTop: sheetTop)

        return VStack(spacing: 0) {
            Color.clear
                .frame(height: sheetTop)
                .accessibilityHidden(true)

            PhotoBackdropBottomChromeBacking(
                height: backdropHeight,
                topCornerRadius: topCornerRadius
            )
        }
        .frame(
            height: backingFrameHeight,
            alignment: .top
        )
        .ignoresSafeArea(edges: .bottom)
        .opacity(isPhotoBackdropImmersive ? 0 : 1)
        .animation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation, value: isPhotoBackdropImmersive)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private var header: some View {
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
        .padding(.bottom, -12)
    }

    private var useNowShelf: some View {
        HomeShelf(
            title: "Essentials",
            subtitle: "Core phrases for any trip",
            route: .category("essentials"),
            onOpenCollection: { onOpenCollection($0, .essentials) }
        ) {
            HomeFeaturedPhraseCarousel(
                items: HomeContent.useNowFeaturePhraseCardItems,
                visibilityRoute: .home,
                onOpenDetail: { onOpenFeaturedDetail($0, .essentials) },
                isSaved: { intentStore.isPageSaved($0) },
                onToggleSaved: { intentStore.toggleSavedPage($0) }
            )
        }
        .padding(.leading, HomeLayout.horizontalPadding)
    }

    @ViewBuilder
    private func homepagePhraseShelf(_ id: String, scrollTarget: HomeScrollTarget) -> some View {
        if let shelf = HomeContent.homepagePhraseShelf(id) {
            HomeRoutePhraseShelf(
                shelf: shelf,
                onOpenDetail: { onOpenDetail($0, scrollTarget) },
                onOpenCollection: { onOpenCollection($0, scrollTarget) }
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
                    onOpenDetail: { onOpenFeaturedDetail($0, .recentlyViewed) },
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
        HomeShelf(title: "Practice", subtitle: "Quick matching rounds") {
            HomePracticeStarterRail(
                onStartPractice: { onStartPractice($0, .practice) }
            )
        }
        .padding(.leading, HomeLayout.horizontalPadding)
    }

    private var situationShelves: some View {
        HomeShelf(title: "Start with a situation", subtitle: "Go straight to what is happening around you") {
            LazyVStack(spacing: 12) {
                ForEach(HomeContent.situationCards) { card in
                    HomeSituationActionRow(
                        card: card,
                        onOpenCollection: { onOpenCollection($0, .situations) }
                    )
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
            onOpenCollection: { onOpenCollection($0, .relationships) }
        ) {
            HomeRelationshipListCard(
                phrases: Array(PhrasePage.xinChao.localGreetings.prefix(3)),
                onOpenDetail: { onOpenDetail($0, .relationships) }
            )
        }
        .padding(.horizontal, HomeLayout.horizontalPadding)
    }

    private var cityShelf: some View {
        HomeShelf(
            title: "Explore by city",
            subtitle: "Popular city guides for your trip",
            route: .category("city-guides"),
            onOpenCollection: { onOpenCollection($0, .city) }
        ) {
            HomeCityRail(
                cities: HomeContent.cityCards,
                onOpenCollection: { onOpenCollection($0, .city) }
            )
        }
        .padding(.leading, HomeLayout.horizontalPadding)
    }

    private func restoreScrollTargetIfNeeded(
        scrollProxy: ScrollViewProxy,
        metrics: PhrasePhotoBackdropLayout.Metrics
    ) {
        guard let target = scrollRestorationTarget else {
            return
        }

        currentScrollTarget = target.target
        restoreScrollPosition(target, scrollProxy: scrollProxy, metrics: metrics)
        Task { @MainActor in
            await Task.yield()
            restoreScrollPosition(target, scrollProxy: scrollProxy, metrics: metrics)
            scrollRestorationTarget = nil
        }
    }

    private func restoreScrollPosition(
        _ target: HomeScrollRestorationTarget,
        scrollProxy: ScrollViewProxy,
        metrics: PhrasePhotoBackdropLayout.Metrics
    ) {
        if target.offsetY <= 1 {
            scrollProxy.scrollTo(target.target, anchor: .top)
            currentScrollOffsetY = target.target == .top ? metrics.initialAnchorOffset : 0
        } else {
            scrollPosition.scrollTo(y: target.offsetY)
        }
    }

    @MainActor
    private func applyPhotoBackdropInitialPositionIfNeeded(_ scrollProxy: ScrollViewProxy) async {
        guard !didApplyPhotoBackdropInitialPosition else {
            return
        }

        try? await Task.sleep(nanoseconds: 80_000_000)
        guard !Task.isCancelled, isActive, scrollRestorationTarget == nil else {
            return
        }

        isPhotoBackdropImmersive = false
        currentScrollTarget = .top
        scrollProxy.scrollTo(HomeScrollTarget.top, anchor: .top)
        didApplyPhotoBackdropInitialPosition = true
    }

    private func togglePhotoBackdropImmersive(
        at location: CGPoint,
        metrics: PhrasePhotoBackdropLayout.Metrics
    ) {
        if isPhotoBackdropImmersive {
            withAnimation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation) {
                isPhotoBackdropImmersive = false
            }
            return
        }

        guard PhrasePhotoBackdropLayout.isImageTap(
            location,
            scrollOffset: photoBackdropScrollOffset,
            metrics: metrics
        ) else {
            return
        }

        withAnimation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation) {
            isPhotoBackdropImmersive = true
        }
    }
}

struct SavedPagesView: View {
    @ObservedObject var intentStore: LocalUserIntentStore

    let scrollToTopTrigger: Int
    let sectionJumpRequest: SavedTripSectionJumpRequest?
    var usesPhotoBackdrop = false
    var backdropScrollProxy: ScrollViewProxy?
    var onOpenDetail: (String) -> Void
    var onBrowseTapped: () -> Void
    var onStartSavedPractice: () -> Void

    @State private var currentSectionID: String? = "all"
    @State private var isSectionRailPinned = false
    @State private var pendingSectionJumpID = 0
    @State private var pendingSectionJumpSectionID: String?
    @State private var practiceReadyCount = 0

    @ViewBuilder
    var body: some View {
        if usesPhotoBackdrop, let backdropScrollProxy {
            savedContent(scrollProxy: backdropScrollProxy)
                .savedPagesChromePreferences(
                    sectionChromeState: sectionChromeState,
                    onSectionFramesChanged: updateCurrentSection(from:),
                    onRailFrameChanged: updateRailFrame(_:)
                )
                .onChange(of: scrollToTopTrigger) { _, _ in
                    currentSectionID = "all"
                }
                .onChange(of: sectionJumpRequest?.requestID) { _, _ in
                    guard let sectionJumpRequest else {
                        return
                    }

                    jumpToSection(sectionJumpRequest.sectionID)
                }
                .onChange(of: intentStore.savedPageIDs) { _, _ in
                    if !snapshot.railItems.contains(where: { $0.id == currentSectionID }) {
                        currentSectionID = "all"
                    }
                }
                .task(id: pendingSectionJumpID) {
                    await performPendingSectionJump(backdropScrollProxy)
                }
                .task(id: intentStore.savedPageIDs) {
                    await refreshPracticeReadyCount(for: intentStore.savedPageIDs)
                }
                .accessibilityIdentifier("SavedPagesView")
        } else {
            ZStack(alignment: .bottom) {
                PhrasePageStyle.pageBackground
                    .ignoresSafeArea()

                ScrollViewReader { scrollProxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        savedContent(scrollProxy: scrollProxy)
                    }
                    .onChange(of: scrollToTopTrigger) { _, _ in
                        currentSectionID = "all"
                        scrollProxy.scrollTo(Self.scrollTopID, anchor: .top)
                    }
                    .onChange(of: sectionJumpRequest?.requestID) { _, _ in
                        guard let sectionJumpRequest else {
                            return
                        }

                        jumpToSection(sectionJumpRequest.sectionID)
                    }
                    .onChange(of: intentStore.savedPageIDs) { _, _ in
                        if !snapshot.railItems.contains(where: { $0.id == currentSectionID }) {
                            currentSectionID = "all"
                        }
                    }
                    .task(id: pendingSectionJumpID) {
                        await performPendingSectionJump(scrollProxy)
                    }
                    .task(id: intentStore.savedPageIDs) {
                        await refreshPracticeReadyCount(for: intentStore.savedPageIDs)
                    }
                }
            }
            .savedPagesChromePreferences(
                sectionChromeState: sectionChromeState,
                onSectionFramesChanged: updateCurrentSection(from:),
                onRailFrameChanged: updateRailFrame(_:)
            )
            .accessibilityIdentifier("SavedPagesView")
        }
    }

    private static let scrollTopID = "SavedPagesViewTop"
    private static let savedContentTopID = "SavedPagesViewContentTop"

    private func savedContent(scrollProxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: SavedTripLayout.sectionSpacing) {
            header
                .id(Self.scrollTopID)
                .padding(.horizontal, SavedTripLayout.horizontalPadding)

            SavedTripPracticeCard(
                practiceReadyCount: snapshot.practiceReadyCount,
                totalSavedCount: snapshot.totalItemCount,
                onStart: onStartSavedPractice,
                onBrowse: onBrowseTapped
            )
            .padding(.horizontal, SavedTripLayout.horizontalPadding)

            if snapshot.totalItemCount == 0 {
                savedEmptyState
                    .padding(.horizontal, SavedTripLayout.horizontalPadding)
            } else {
                sectionRail(scrollProxy: scrollProxy)

                Color.clear
                    .frame(width: 1, height: 1)
                    .id(Self.savedContentTopID)
                    .accessibilityHidden(true)

                sectionedSavedItems
                    .padding(.horizontal, SavedTripLayout.horizontalPadding)
            }

            AppBottomSentinel(id: "Saved.BottomSentinel")
                .padding(.horizontal, SavedTripLayout.horizontalPadding)
        }
        .padding(.bottom, SavedTripLayout.bottomContentClearance(usesPhotoBackdrop: usesPhotoBackdrop))
    }

    private var snapshot: SavedTripSnapshot {
        SavedTripSnapshot.make(
            savedPageIDs: intentStore.savedPageIDs,
            practiceReadyCount: practiceReadyCount
        )
    }

    private var resolvedCurrentSectionID: String {
        currentSectionID ?? "all"
    }

    private var sectionChromeState: SavedTripSectionChromeState? {
        let railItems = snapshot.railItems
        guard !railItems.isEmpty else {
            return nil
        }

        return SavedTripSectionChromeState(
            currentSectionID: resolvedCurrentSectionID,
            isPinned: isSectionRailPinned,
            sections: railItems.map { item in
                SavedTripSectionChromeItem(
                    id: item.id,
                    title: item.title,
                    symbolName: item.symbolName,
                    tintName: item.tintName
                )
            }
        )
    }

    private var header: some View {
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

            Text("Saved")
                .font(.system(size: 42, weight: .black, design: .serif))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.78)

            Text("Your saved phrases, foods, drinks, and places for your trip.")
                .font(.body.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, usesPhotoBackdrop ? 18 : 76)
    }

    private func sectionRail(scrollProxy: ScrollViewProxy) -> some View {
        GeometryReader { proxy in
            let cardWidth = SavedTripLayout.sectionCardWidth(containerWidth: proxy.size.width)

            ScrollViewReader { railProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: SavedTripLayout.sectionCardSpacing) {
                        ForEach(snapshot.railItems) { item in
                            SavedTripSectionImageCard(
                                item: item,
                                isSelected: resolvedCurrentSectionID == item.id,
                                action: { jumpToSection(item.id) }
                            )
                            .frame(width: cardWidth)
                            .id(Self.railScrollID(for: item.id))
                        }
                    }
                    .padding(.leading, SavedTripLayout.horizontalPadding)
                    .padding(.trailing, SavedTripLayout.horizontalPadding)
                    .padding(.bottom, 2)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollClipDisabled()
                .onChange(of: resolvedCurrentSectionID) { _, sectionID in
                    withAnimation(.snappy(duration: 0.24)) {
                        railProxy.scrollTo(Self.railScrollID(for: sectionID), anchor: .leading)
                    }
                }
            }
        }
        .frame(height: SavedTripLayout.sectionCardHeight)
        .background {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: SavedTripRailFramePreferenceKey.self,
                    value: proxy.frame(in: .global)
                )
            }
        }
    }

    private var sectionedSavedItems: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(Array(snapshot.sections.enumerated()), id: \.element.id) { index, section in
                Color.clear
                    .frame(width: 1, height: 1)
                    .id(Self.sectionAnchorID(for: section.id))
                    .accessibilityHidden(true)

                SavedTripSectionBlock(
                    section: section,
                    onOpenDetail: onOpenDetail,
                    onToggleSaved: { item in intentStore.toggleSavedPage(item.pageID) }
                )
                .padding(.top, index == 0 ? 0 : SavedTripLayout.sectionSpacing)
                .background {
                    GeometryReader { proxy in
                        Color.clear.preference(
                            key: SavedTripSectionFramePreferenceKey.self,
                            value: [
                                SavedTripSectionFrame(
                                    id: section.id,
                                    order: index,
                                    minY: proxy.frame(in: .global).minY
                                ),
                            ]
                        )
                    }
                }
            }
        }
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
                    Text("Save what matters for your trip")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Browse Vietnam, then tap the heart on phrases, foods, and drinks to keep them here.")
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

    private func jumpToSection(_ sectionID: String) {
        let validIDs = Set(snapshot.railItems.map(\.id))
        guard validIDs.contains(sectionID) else {
            return
        }

        currentSectionID = sectionID
        pendingSectionJumpSectionID = sectionID
        pendingSectionJumpID += 1
    }

    @MainActor
    private func performPendingSectionJump(_ scrollProxy: ScrollViewProxy) async {
        guard pendingSectionJumpID > 0, let pendingSectionJumpSectionID else {
            return
        }

        try? await Task.sleep(nanoseconds: SavedTripLayout.sectionJumpDelayNanoseconds)
        guard !Task.isCancelled else {
            return
        }

        let target = pendingSectionJumpSectionID == "all"
            ? Self.savedContentTopID
            : Self.sectionAnchorID(for: pendingSectionJumpSectionID)

        withAnimation(.snappy(duration: 0.32)) {
            scrollProxy.scrollTo(
                target,
                anchor: UnitPoint(x: 0.5, y: SavedTripLayout.sectionJumpViewportAnchorY)
            )
        }
    }

    private func updateCurrentSection(from frames: [SavedTripSectionFrame]) {
        guard !frames.isEmpty else {
            return
        }

        let sortedFrames = frames.sorted { lhs, rhs in
            if lhs.order == rhs.order {
                return lhs.minY < rhs.minY
            }

            return lhs.order < rhs.order
        }
        let activeFrames = sortedFrames.filter { $0.minY <= SavedTripLayout.sectionActivationY }
        let selectedID = activeFrames.max { $0.minY < $1.minY }?.id ?? "all"

        if currentSectionID != selectedID {
            currentSectionID = selectedID
        }
    }

    private func updateRailFrame(_ frame: CGRect?) {
        isSectionRailPinned = (frame?.maxY ?? .greatestFiniteMagnitude) <= SavedTripLayout.glassRailRevealY
    }

    private func refreshPracticeReadyCount(for pageIDs: [String]) async {
        let count = await Task.detached(priority: .userInitiated) {
            (try? SavedTripPracticeCatalog.items(for: pageIDs).count) ?? 0
        }.value

        await MainActor.run {
            guard pageIDs == intentStore.savedPageIDs else {
                return
            }

            practiceReadyCount = count
        }
    }

    private static func railScrollID(for sectionID: String) -> String {
        "saved-rail-\(sectionID)"
    }

    private static func sectionAnchorID(for sectionID: String) -> String {
        "saved-section-anchor-\(sectionID)"
    }
}

private extension View {
    func savedPagesChromePreferences(
        sectionChromeState: SavedTripSectionChromeState?,
        onSectionFramesChanged: @escaping ([SavedTripSectionFrame]) -> Void,
        onRailFrameChanged: @escaping (CGRect?) -> Void
    ) -> some View {
        self
            .onPreferenceChange(SavedTripSectionFramePreferenceKey.self, perform: onSectionFramesChanged)
            .onPreferenceChange(SavedTripRailFramePreferenceKey.self, perform: onRailFrameChanged)
            .preference(
                key: SavedTripSectionChromePreferenceKey.self,
                value: sectionChromeState.map { [$0] } ?? []
            )
    }
}

enum SavedTripLayout {
    static let horizontalPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 22
    static let sectionTitleToRowsSpacing: CGFloat = 20
    static let sectionCardSpacing: CGFloat = 12
    static let sectionCardHeight: CGFloat = 154
    static let sectionImageHeight: CGFloat = 96
    static let practiceUnlockCount = 4
    static let sectionActivationY: CGFloat = AppChromeLayout.menuSectionJumpClearance + 280
    static let sectionJumpViewportAnchorY: CGFloat = 0.19
    static let sectionJumpDelayNanoseconds: UInt64 = 80_000_000
    static let glassRailRevealY: CGFloat = 72

    static func bottomContentClearance(usesPhotoBackdrop: Bool) -> CGFloat {
        AppBottomContentClearance.rootSurface(
            usesPhotoBackdrop: usesPhotoBackdrop,
            standard: HomeLayout.bottomChromeContentClearance
        )
    }

    static func sectionCardWidth(containerWidth: CGFloat) -> CGFloat {
        max(132, min(164, (containerWidth - horizontalPadding * 2 - sectionCardSpacing * 1.5) / 2.35))
    }
}

private struct SavedTripPracticeCard: View {
    let practiceReadyCount: Int
    let totalSavedCount: Int
    let onStart: () -> Void
    let onBrowse: () -> Void

    private var canStart: Bool {
        practiceReadyCount >= SavedTripLayout.practiceUnlockCount
    }

    private var remainingCount: Int {
        max(0, SavedTripLayout.practiceUnlockCount - practiceReadyCount)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.red.opacity(0.16), Color.red.opacity(0.04)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 72, height: 72)
                        .rotationEffect(.degrees(-4))

                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.white.opacity(0.82))
                        .frame(width: 54, height: 54)
                        .softAmbientCardShadow()

                    Image(systemName: "heart.fill")
                        .font(.system(size: 24, weight: .black))
                        .foregroundStyle(.red)
                }
                .frame(width: 84, height: 78)
                .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 6) {
                    Text(canStart ? "Practice your saved items" : "Save 4 items to unlock practice")
                        .font(.headline.weight(.black))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(canStart ? "Review the things you saved." : "Saved phrases, foods, and drinks become match rounds.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
            }

            Button(action: canStart ? onStart : onBrowse) {
                HStack {
                    Text(canStart ? "Start Practicing" : (totalSavedCount == 0 ? "Browse Vietnam" : "Save \(remainingCount) more"))
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)

                    Spacer(minLength: 8)

                    Image(systemName: "chevron.right")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 18)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.red, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier(canStart ? "SavedTrip.Practice.Start" : "SavedTrip.Practice.Browse")
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color.red.opacity(0.11), Color.white.opacity(0.78)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: 1)
                .allowsHitTesting(false)
        }
        .softAmbientCardShadow()
    }
}

private struct SavedTripSectionImageCard: View {
    let item: SavedTripRailItem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                if let imageName = item.imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: SavedTripLayout.sectionImageHeight)
                        .frame(maxWidth: .infinity)
                        .clipped()
                } else {
                    ZStack {
                        item.tintName.color.opacity(0.10)

                        Image(systemName: item.symbolName)
                            .font(.system(size: 30, weight: .black))
                            .foregroundStyle(item.tintName.color)
                    }
                    .frame(height: SavedTripLayout.sectionImageHeight)
                    .frame(maxWidth: .infinity)
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text(item.title)
                        .font(.headline.weight(.black))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                }
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, minHeight: 58, alignment: .leading)
                .background(PhrasePageStyle.imageCaptionFill)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .background(PhrasePageStyle.elevatedCardFill, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? item.tintName.color.opacity(0.58) : .white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: isSelected ? 1.5 : 1)
                    .allowsHitTesting(false)
            }
            .softAmbientCardShadow()
            .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("SavedTrip.SectionRail.\(item.id)")
    }
}

private struct SavedTripSectionBlock: View {
    let section: SavedTripSection
    let onOpenDetail: (String) -> Void
    let onToggleSaved: (SavedTripItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: SavedTripLayout.sectionTitleToRowsSpacing) {
            Text(section.title)
                .font(.title2.weight(.black))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityIdentifier("SavedTrip.SectionTitle.\(section.id)")

            VStack(spacing: 0) {
                ForEach(section.items) { item in
                    SavedTripItemRow(
                        item: item,
                        onOpenDetail: { onOpenDetail(item.pageID) },
                        onToggleSaved: { onToggleSaved(item) }
                    )

                    if item.id != section.items.last?.id {
                        Divider().padding(.leading, 86)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .phraseListCard(cornerRadius: 24)
        }
    }
}

private struct SavedTripItemRow: View {
    let item: SavedTripItem
    let onOpenDetail: () -> Void
    let onToggleSaved: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onOpenDetail) {
                HStack(spacing: 14) {
                    thumbnail

                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.headline.weight(.black))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.74)

                        Text(item.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("SavedTrip.Row.\(item.pageID)")

            AudioSpeakerButton(
                tint: item.tintName,
                audioKey: item.audioKey,
                accessibilityIdentifier: "SavedTrip.Audio.\(item.pageID)"
            )

            Button(action: onToggleSaved) {
                Image(systemName: "heart.fill")
                    .font(.headline.weight(.black))
                    .foregroundStyle(.red)
                    .frame(width: 44, height: 44)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Remove from Saved")
            .accessibilityIdentifier("SavedTrip.Unsave.\(item.pageID)")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let imageName = item.imageName {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 62, height: 62)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.8), lineWidth: 1)
                }
                .accessibilityHidden(true)
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(item.tintName.color.opacity(0.10))

                Image(systemName: item.symbolName)
                    .font(.system(size: 22, weight: .black))
                    .foregroundStyle(item.tintName.color)
            }
            .frame(width: 62, height: 62)
            .accessibilityHidden(true)
        }
    }
}

struct SavedTripSectionJumpRequest: Equatable {
    let requestID: Int
    let sectionID: String
}

struct SavedTripSectionChromeItem: Identifiable, Equatable {
    let id: String
    let title: String
    let symbolName: String
    let tintName: AccentTint
}

struct SavedTripSectionChromeState: Equatable {
    let currentSectionID: String
    let isPinned: Bool
    let sections: [SavedTripSectionChromeItem]
}

struct SavedTripSectionChromePreferenceKey: PreferenceKey {
    static var defaultValue: [SavedTripSectionChromeState] = []

    static func reduce(value: inout [SavedTripSectionChromeState], nextValue: () -> [SavedTripSectionChromeState]) {
        value.append(contentsOf: nextValue())
    }
}

private struct SavedTripSectionFrame: Equatable {
    let id: String
    let order: Int
    let minY: CGFloat
}

private struct SavedTripSectionFramePreferenceKey: PreferenceKey {
    static var defaultValue: [SavedTripSectionFrame] = []

    static func reduce(value: inout [SavedTripSectionFrame], nextValue: () -> [SavedTripSectionFrame]) {
        value.append(contentsOf: nextValue())
    }
}

private struct SavedTripRailFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect?

    static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
        value = nextValue() ?? value
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
    static let cityImageHeight: CGFloat = 122
    static let relationshipRowsPerGroup = 3
    static let relationshipGroupSpacing: CGFloat = 12
    static let relationshipRowHeight: CGFloat = 102
    static let relationshipGroupVerticalPadding: CGFloat = 10
    static let bottomChromeContentClearance: CGFloat = PhrasePageStyle.bottomChromeContentClearance
    static let photoBackdropBottomReadingClearance: CGFloat = AppBottomContentClearance.photoBackdropRoot
    static let shellScrollOffsetPublishStride: CGFloat = 4

    static func bottomContentClearance(usesPhotoBackdrop: Bool) -> CGFloat {
        AppBottomContentClearance.rootSurface(
            usesPhotoBackdrop: usesPhotoBackdrop,
            standard: bottomChromeContentClearance
        )
    }

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
    let items: [HomePhraseItem]

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
        self.items = Self.resolveItems(
            pageIDs: pageIDs,
            sourceCategoryIDs: sourceCategoryIDs,
            maximumItemCount: maximumItemCount,
            fillsFromSourceCategories: fillsFromSourceCategories
        )
    }

    private static func resolveItems(
        pageIDs: [String],
        sourceCategoryIDs: [String],
        maximumItemCount: Int,
        fillsFromSourceCategories: Bool
    ) -> [HomePhraseItem] {
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
            title: "Eating Out",
            subtitle: "Tables, ordering, allergies, and paying.",
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
                "viet-phrase-price-1",
                "viet-phrase-v500-shop-can-you-lower-the-price",
                "viet-phrase-v500-mone-numb-pric-can-i-have-a-receipt",
                "viet-phrase-v500-mone-numb-pric-can-i-try-another-card",
                "viet-phrase-price-9",
                "viet-phrase-shop-1",
            ],
            layout: .mediumGrid,
            maximumItemCount: 6,
            fillsFromSourceCategories: false
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

    static let useNowItems: [HomePhraseItem] = {
        useNowIDs.compactMap(HomePhraseItem.resolve(pageID:))
    }()

    static let useNowFeaturePhraseCardItems: [HomeFeaturePhraseItem] = {
        HomeUseNowCatalog.featureCardIDs.compactMap(HomeFeaturePhraseItem.resolve(pageID:))
    }()

    static let savedFallbackItems: [HomePhraseItem] = {
        savedFallbackPageIDs.compactMap(HomePhraseItem.resolve(pageID:))
    }()

    static let savedFallbackPageIDs = [
        "viet-phrase-v500-unde-repa-can-you-show-me-a-picture",
        "viet-phrase-hotel-3",
    ]

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
            title: "Eating out and shopping",
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

    static let cityCards: [HomeCityCard] = {
        BrowseSearchDestinations.homepageCityShortcuts.map { city in
            HomeCityCard(
                id: city.id,
                title: homeCityTitle(for: city.id, fallback: city.title),
                imageName: homeCityImageName(for: city.id),
                route: city.collectionRoute
            )
        }
    }()

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

private struct HomePreparedImage: View {
    let name: String

    var body: some View {
        AdminBackdropPreparedImage(name: name)
    }
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

    static var homepagePhraseShelfSnapshots: [HomePagePhraseShelfSnapshot] {
        HomeContent.homepagePhraseShelves.map { shelf in
            HomePagePhraseShelfSnapshot(
                id: shelf.id,
                title: shelf.title,
                items: shelf.items.map { item in
                    HomePagePhraseShelfSnapshot.Item(
                        pageID: item.pageID,
                        title: item.title,
                        subtitle: item.subtitle
                    )
                }
            )
        }
    }

    static var homepageCollectionRoutes: [BrowseCollectionRoute] {
        [
            .category("essentials"),
            .category("local-greetings"),
            .category("city-guides"),
        ]
        + HomeContent.homepagePhraseShelves.map(\.route)
        + HomeContent.situationCards.map(\.route)
        + HomeContent.cityCards.map(\.route)
    }

    private static func uniquePageIDs(_ pageIDs: [String]) -> [String] {
        var seen = Set<String>()
        return pageIDs.filter { seen.insert($0).inserted }
    }
}

struct HomePagePhraseShelfSnapshot: Equatable {
    struct Item: Equatable {
        let pageID: String
        let title: String
        let subtitle: String
    }

    let id: String
    let title: String
    let items: [Item]
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
            headerContent(showsChevron: true)
                .onTapGesture {
                    onOpenCollection(route)
                }
        } else {
            headerContent(showsChevron: false)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(title)
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
    let visibilityRoute: AppRoute?
    let onOpenDetail: (String) -> Void
    let isSaved: (String) -> Bool
    let onToggleSaved: (String) -> Void

    init(
        items: [HomeFeaturePhraseItem],
        visibilityRoute: AppRoute? = nil,
        onOpenDetail: @escaping (String) -> Void,
        isSaved: @escaping (String) -> Bool,
        onToggleSaved: @escaping (String) -> Void
    ) {
        self.items = items
        self.visibilityRoute = visibilityRoute
        self.onOpenDetail = onOpenDetail
        self.isSaved = isSaved
        self.onToggleSaved = onToggleSaved
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            carouselItems
                .padding(.trailing, HomeLayout.horizontalPadding)
                .padding(.bottom, PhrasePageStyle.cardShadowBleedPadding)
        }
        .frame(height: HomeLayout.featurePhraseCardHeight + PhrasePageStyle.cardShadowBleedPadding)
        .scrollClipDisabled()
    }

    private var carouselItems: some View {
        LazyHStack(spacing: 14) {
            ForEach(items) { item in
                HomeFeaturedPhraseCard(
                    item: item,
                    isSaved: isSaved(item.pageID),
                    visibilityRoute: item.id == items.first?.id ? visibilityRoute : nil,
                    onOpenDetail: onOpenDetail,
                    onToggleSaved: { onToggleSaved(item.pageID) }
                )
            }
        }
    }
}

private struct HomeFeaturedPhraseCard: View {
    let item: HomeFeaturePhraseItem
    let isSaved: Bool
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
                        pronunciationLineLimit: 1
                    )
                    .padding(.trailing, 48)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("HomeFeaturedPhrase.Open.\(item.pageID)")

                Spacer(minLength: 0)

                PlaybackDockView(
                    audioKey: item.audioKey,
                    isSaved: isSaved,
                    onToggleSaved: onToggleSaved,
                    visibilityRoute: visibilityRoute
                )
            }
            .padding(.horizontal, 18)
            .padding(.top, 22)
            .padding(.bottom, 14)
            .frame(width: HomeLayout.featurePhraseCardWidth, height: HomeLayout.featurePhraseCardHeight, alignment: .topLeading)
            .background(PhrasePageStyle.glassCardFill, in: RoundedRectangle(cornerRadius: 32, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(.white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: 1)
            }
            .softAmbientCardShadow()
            .nativeGlass(cornerRadius: 32)
        }
        .accessibilityIdentifier("HomeFeaturedPhrase.\(item.pageID)")
    }
}

private struct HomeQuickPhraseCard: View {
    let item: HomePhraseItem
    let onOpenDetail: (String) -> Void

    var body: some View {
        ZStack(alignment: .top) {
            Button {
                onOpenDetail(item.pageID)
            } label: {
                VStack(spacing: 8) {
                    Color.clear
                        .frame(height: 56)
                        .accessibilityHidden(true)

                    VStack(spacing: 3) {
                        Text(item.title)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.66)
                            .frame(height: 44, alignment: .bottom)

                        Text(item.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.78)
                            .frame(height: 18, alignment: .top)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 12)
                .frame(width: HomeLayout.quickPhraseCardWidth, height: HomeLayout.quickPhraseCardHeight)
                .contentShape(Rectangle())
                .homeGlassCard(cornerRadius: HomeLayout.cardCornerRadius)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(item.title), \(item.subtitle)")
            .accessibilityIdentifier("HomeQuick.\(item.pageID)")

            AudioSpeakerButton(
                tint: item.tintName,
                size: 52,
                audioKey: item.audioKey,
                accessibilityIdentifier: "HomeQuick.Audio.\(item.pageID)"
            )
            .frame(height: 56)
            .padding(.top, 12)
        }
        .frame(width: HomeLayout.quickPhraseCardWidth, height: HomeLayout.quickPhraseCardHeight)
    }
}

private struct HomePracticeStarter: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let symbolName: String
    let tint: AccentTint
    let action: BrowseCollectionPracticeAction

    static let defaults: [HomePracticeStarter] = [
        HomePracticeStarter(
            id: "quick",
            title: "Quick match",
            subtitle: "Four useful pairs",
            symbolName: "bolt.fill",
            tint: .red,
            action: .practiceSource("quick")
        ),
        HomePracticeStarter(
            id: "practice",
            title: "Practice pool",
            subtitle: "Your added phrases",
            symbolName: "bookmark.fill",
            tint: .red,
            action: .practiceSource("practice")
        ),
        HomePracticeStarter(
            id: "food-drinks",
            title: "Eating Out",
            subtitle: "Order, ask, pay",
            symbolName: "takeoutbag.and.cup.and.straw.fill",
            tint: .orange,
            action: .practiceSource("topic:food-drinks")
        ),
        HomePracticeStarter(
            id: "airport",
            title: "Airport",
            subtitle: "Arrival and baggage",
            symbolName: "airplane.arrival",
            tint: .red,
            action: .practiceSource("topic:airport")
        ),
    ]
}

private struct HomePracticeStarterRail: View {
    let onStartPractice: (BrowseCollectionPracticeAction) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: 10) {
                ForEach(HomePracticeStarter.defaults) { starter in
                    Button {
                        onStartPractice(starter.action)
                    } label: {
                        VStack(alignment: .leading, spacing: 12) {
                            HomePracticeStarterIcon(symbolName: starter.symbolName, tint: starter.tint)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(starter.title)
                                    .font(.headline.weight(.black))
                                    .foregroundStyle(.primary)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.78)

                                Text(starter.subtitle)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }

                            Spacer(minLength: 0)
                        }
                        .padding(14)
                        .frame(width: 152, height: 138, alignment: .leading)
                        .phraseListCard(cornerRadius: 22)
                        .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("Home.PracticeStarter.\(starter.id)")
                }
            }
            .padding(.trailing, HomeLayout.horizontalPadding)
            .padding(.bottom, PhrasePageStyle.cardShadowBleedPadding)
        }
        .frame(height: 138 + PhrasePageStyle.cardShadowBleedPadding)
        .scrollClipDisabled()
        .accessibilityIdentifier("HomePracticeStarterRail")
    }
}

private struct HomePracticeStarterIcon: View {
    let symbolName: String
    let tint: AccentTint

    var body: some View {
        Image(systemName: symbolName)
            .font(.headline.weight(.bold))
            .foregroundStyle(tint.color)
            .frame(width: 48, height: 48)
            .nativeGlass(cornerRadius: 24, tint: tint.color, interactive: true)
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
                HomePreparedImage(name: card.imageName)
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
            LazyHStack(spacing: 14) {
                ForEach(cities) { city in
                    HomeCityCardView(city: city, onOpenCollection: onOpenCollection)
                }
            }
            .padding(.trailing, HomeLayout.horizontalPadding)
            .padding(.bottom, PhrasePageStyle.cardShadowBleedPadding)
        }
        .frame(height: HomeLayout.cityCardHeight + PhrasePageStyle.cardShadowBleedPadding)
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
                HomePreparedImage(name: city.imageName)
                    .scaledToFill()
                    .frame(width: HomeLayout.cityCardWidth, height: HomeLayout.cityImageHeight)
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
            .homeStaticImageCard(cornerRadius: HomeLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("HomeCity.\(city.id)")
    }
}

private extension View {
    func homeGlassCard(cornerRadius: CGFloat) -> some View {
        self
            .background(PhrasePageStyle.glassCardFill, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: 1)
            }
            .softAmbientCardShadow()
            .nativeGlass(cornerRadius: cornerRadius)
    }

    func homeStaticImageCard(cornerRadius: CGFloat) -> some View {
        self
            .background(PhrasePageStyle.elevatedCardFill, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: 1)
                    .allowsHitTesting(false)
            }
            .softAmbientCardShadow()
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
                .padding(.bottom, PhrasePageStyle.cardShadowBleedPadding)
            }
            .frame(height: HomeLayout.quickPhraseCardHeight + PhrasePageStyle.cardShadowBleedPadding)
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
