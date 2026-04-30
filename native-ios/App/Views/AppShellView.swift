import SwiftUI

struct AppShellView: View {
    @State private var navigation: AppShellNavigationState
    @State private var interactiveDrag: AppInteractiveNavigationDrag?
    @State private var searchQuery = ""
    @StateObject private var intentStore = LocalUserIntentStore()
    @FocusState private var isSearchFieldFocused: Bool
    @Namespace private var chromeNamespace
    private let launchPracticeMode: PracticeMode?
    private let launchDetailScrollTarget: PhraseArticleInitialScrollTarget?

    init(
        initialRoute: AppRoute = AppShellView.initialRoute,
        initialPracticeMode: PracticeMode? = AppShellView.initialPracticeMode,
        initialDetailScrollTarget: PhraseArticleInitialScrollTarget? = AppShellView.initialDetailScrollTarget
    ) {
        _navigation = State(initialValue: AppShellNavigationState(initialRoute: initialRoute))
        self.launchPracticeMode = initialPracticeMode
        self.launchDetailScrollTarget = initialDetailScrollTarget
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

                detailPageStack(width: pageWidth)

                if navigation.isSearchPresented {
                    SearchPageView(
                        query: $searchQuery,
                        chromeNamespace: chromeNamespace,
                        showsChrome: false,
                        onClose: closeSearch,
                        onOpenDetail: openDetailFromSearch
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
            .animation(.snappy(duration: 0.34), value: navigation.isSearchPresented)
            .animation(.snappy(duration: 0.24), value: navigation.forwardStack)
            .simultaneousGesture(backSwipeGesture(width: pageWidth))
            .simultaneousGesture(forwardSwipeGesture(width: pageWidth))
            .overlay(alignment: .bottom) {
                ChromeSeparationGradient(edge: .bottom)
                    .zIndex(360)
            }
            .overlay(alignment: .bottom) {
                staticBottomChrome
                    .padding(.horizontal, AppChromeLayout.bottomOuterHorizontalPadding)
                    .padding(.bottom, AppChromeLayout.bottomPadding)
                    .offset(y: AppChromeLayout.bottomOffset)
                    .zIndex(380)
            }
            .overlay(alignment: .top) {
                if showsStaticBackButton {
                    ChromeSeparationGradient(edge: .top)
                        .zIndex(360)
                }
            }
            .overlay(alignment: .topLeading) {
                if showsStaticBackButton {
                    staticBackButton
                        .padding(.leading, 24)
                        .padding(.top, 6)
                        .offset(y: -24)
                        .zIndex(400)
                }
            }
            .overlay(alignment: .topTrailing) {
                if navigation.canGoForward {
                    forwardButton
                        .padding(.trailing, 24)
                        .padding(.top, 6)
                        .offset(y: -24)
                        .zIndex(400)
                }
            }
            .onChange(of: navigation.isSearchPresented) { _, isPresented in
                if isPresented {
                    focusSearchField()
                } else {
                    isSearchFieldFocused = false
                }
            }
        }
        .preferredColorScheme(.light)
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
                onBrowseAllTapped: openBrowseAll
            )
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
                chromeNamespace: chromeNamespace,
                showsChrome: false,
                onClose: closeSearch,
                onOpenDetail: openDetailFromSearch
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
            initialScrollTarget: initialScrollTarget,
            scrollToTopTrigger: scrollToTopTrigger,
            chromeNamespace: chromeNamespace,
            isSearchActive: navigation.isSearchPresented,
            showsChrome: false,
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
        navigation.currentRoute != .home && navigation.currentRoute != .search
    }

    private var staticBackButton: some View {
        Button {
            goBack()
        } label: {
            Image(systemName: "chevron.left")
                .font(.title3.weight(.semibold))
                .frame(width: 52, height: 52)
                .foregroundStyle(.primary)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .nativeGlass(cornerRadius: 26, interactive: true)
        .accessibilityLabel("Go back")
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
        if navigation.currentRoute == .search {
            searchBottomChromeContent
        } else {
            collapsedBottomChromeContent
        }
    }

    @ViewBuilder
    private var collapsedBottomChromeContent: some View {
        let chrome = AppChrome(route: navigation.currentRoute)

        HStack(spacing: AppChromeLayout.bottomSpacing) {
            HStack(spacing: AppChromeLayout.dockItemSpacing) {
                ForEach(chrome.primaryDockItems, id: \.self) { item in
                    Button {
                        performDockAction(item)
                    } label: {
                        AppShellDockItem(kind: item, selected: item == chrome.selectedDockItem)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(item.title)
                }
            }
            .padding(.horizontal, AppChromeLayout.dockHorizontalPadding)
            .padding(.vertical, AppChromeLayout.dockVerticalPadding)
            .nativeGlass(cornerRadius: AppChromeLayout.dockCornerRadius)

            Button {
                openSearch()
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title2.weight(.medium))
                    .foregroundStyle(.primary)
                    .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
            }
            .buttonStyle(.plain)
            .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
            .nativeGlassMorphID(AppChromeMorphID.search, namespace: chromeNamespace)
            .chromeMorph(AppChromeMorphID.search, namespace: chromeNamespace, isSource: !navigation.isSearchPresented)
        }
    }

    private var searchBottomChromeContent: some View {
        HStack(spacing: AppChromeLayout.bottomSpacing) {
            Button {
                openHome()
            } label: {
                Image(systemName: "house.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.red)
                    .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
            }
            .buttonStyle(.plain)
            .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)

                TextField("Search Vietnamese phrases", text: $searchQuery)
                    .font(.body.weight(.semibold))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($isSearchFieldFocused)

                if !searchQuery.isEmpty {
                    Button {
                        searchQuery = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppChromeLayout.searchFieldHorizontalPadding)
            .frame(height: AppChromeLayout.searchFieldHeight)
            .frame(maxWidth: .infinity)
            .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
            .nativeGlassMorphID(AppChromeMorphID.search, namespace: chromeNamespace)
            .chromeMorph(AppChromeMorphID.search, namespace: chromeNamespace, isSource: true)
        }
    }

    private var forwardButton: some View {
        Button {
            goForward()
        } label: {
            Image(systemName: "chevron.right")
                .font(.title3.weight(.semibold))
                .frame(width: 52, height: 52)
                .foregroundStyle(.primary)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .nativeGlass(cornerRadius: 26, interactive: true)
        .accessibilityLabel("Go forward")
    }

    private func backSwipeGesture(width: CGFloat) -> some Gesture {
        DragGesture(
            minimumDistance: AppBackSwipeGesturePolicy.minimumDistance,
            coordinateSpace: .local
        )
        .onChanged { value in
            guard
                navigation.canNavigateBackWithSwipe,
                AppBackSwipeGesturePolicy.canTrackBackSwipe(
                    startX: value.startLocation.x,
                    translation: value.translation
                )
            else {
                return
            }

            interactiveDrag = AppInteractiveNavigationDrag(
                direction: .back,
                translation: AppInteractiveNavigationGesture.clampedBackTranslation(
                    value.translation.width,
                    width: width
                ),
                width: width
            )
        }
        .onEnded { value in
            let shouldNavigateBack = navigation.canNavigateBackWithSwipe && AppBackSwipeGesturePolicy.shouldCommitBackSwipe(
                startX: value.startLocation.x,
                translation: value.translation,
                predictedEndTranslation: value.predictedEndTranslation,
                width: width
            )

            if shouldNavigateBack {
                goBack()
                interactiveDrag = nil
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
                AppForwardSwipeGesturePolicy.canTrackForwardSwipe(
                    startX: value.startLocation.x,
                    containerWidth: width,
                    translation: value.translation
                )
            else {
                return
            }

            interactiveDrag = AppInteractiveNavigationDrag(
                direction: .forward,
                translation: AppInteractiveNavigationGesture.clampedForwardTranslation(
                    value.translation.width,
                    width: width
                ),
                width: width
            )
        }
        .onEnded { value in
            let shouldNavigateForward = navigation.canGoForward && AppForwardSwipeGesturePolicy.shouldCommitForwardSwipe(
                startX: value.startLocation.x,
                containerWidth: width,
                translation: value.translation,
                predictedEndTranslation: value.predictedEndTranslation,
                width: width
            )

            if shouldNavigateForward {
                goForward()
                interactiveDrag = nil
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

    private func openDetailFromSaved(_ id: String) {
        openDetail(id, source: .home)
    }

    private func openDetailFromPractice(_ id: String) {
        openDetail(id, source: .practice)
    }

    private func openDetail(_ id: String, source: UserIntentSource) {
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openDetail(id)
        }
        intentStore.recordOpenedPage(id, source: source)
    }

    private func openDetailFromSearch(_ id: String) {
        openDetail(id, source: .search)
    }

    private func openBrowseAll() {
        openDetail(PhrasePage.xinChao.id, source: .browse)
    }

    private func performDockAction(_ item: DockItemKind) {
        switch item {
        case .home:
            openHome()
        case .browse:
            openBrowseAll()
        case .saved:
            openSaved()
        case .practice:
            openPractice()
        }
    }

    private func openHome() {
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openHome()
        }
        searchQuery = ""
        isSearchFieldFocused = false
    }

    private func openSaved() {
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openSaved()
        }
        isSearchFieldFocused = false
    }

    private func openPractice() {
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openPractice()
        }
        isSearchFieldFocused = false
    }

    private func goBack() {
        withAnimation(.snappy(duration: 0.34)) {
            navigation.goBack()
        }
    }

    private func goForward() {
        withAnimation(.snappy(duration: 0.34)) {
            navigation.goForward()
        }
    }

    private func openSearch() {
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openSearch()
        }
        focusSearchField()
    }

    private func closeSearch() {
        isSearchFieldFocused = false
        goBack()
    }

    private func focusSearchField() {
        DispatchQueue.main.async {
            isSearchFieldFocused = true
        }
    }

    private func cancelInteractiveDrag() {
        withAnimation(.interactiveSpring(response: 0.26, dampingFraction: 0.88)) {
            interactiveDrag = nil
        }
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
        if arguments.contains("--practice") || initialPracticeMode(for: arguments) != nil {
            return .practice
        }

        return arguments.contains("--search") ? .search : .home
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

    private static var initialPracticeMode: PracticeMode? {
        initialPracticeMode(for: ProcessInfo.processInfo.arguments)
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

    private static var initialRoute: AppRoute {
        initialRoute(for: ProcessInfo.processInfo.arguments)
    }
}

struct AppShellNavigationState: Equatable {
    var rootRoute: AppRoute
    var detailPath: [String]
    var isSearchPresented: Bool
    var forwardStack: [AppRoute] = []
    var homeScrollToTopTrigger = 0
    var rootScrollToTopTrigger = 0
    var savedScrollToTopTrigger = 0
    var practiceScrollToTopTrigger = 0
    var detailScrollToTopTrigger = 0

    init(initialRoute: AppRoute = .home) {
        rootRoute = .home
        detailPath = []
        isSearchPresented = false

        switch initialRoute {
        case .home:
            rootRoute = .home
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
                return rootRoute
            }

            return .detailPage(detailPath[detailPath.count - 2])
        }

        if rootRoute == .phrasePage || rootRoute == .saved || rootRoute == .practice {
            return .home
        }

        return nil
    }

    var canGoForward: Bool {
        forwardPreviewRoute != nil
    }

    private var routeBelowSearch: AppRoute {
        if let detailPageID = detailPath.last {
            return .detailPage(detailPageID)
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

    var canNavigateBackWithSwipe: Bool {
        isSearchPresented || !detailPath.isEmpty || rootRoute == .phrasePage || rootRoute == .saved || rootRoute == .practice
    }

    mutating func openDetail(_ id: String) {
        let canonicalPageID = PhraseCatalog.canonicalPageID(forOpenablePageID: id)

        if id == PhrasePage.xinChao.id && canonicalPageID == PhrasePage.xinChao.id {
            guard currentRoute != .phrasePage else {
                rootScrollToTopTrigger += 1
                return
            }

            detailPath.removeAll()
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
        detailPath.removeAll()
        isSearchPresented = false
        forwardStack.removeAll()
        homeScrollToTopTrigger += 1
    }

    mutating func openSaved() {
        guard currentRoute != .saved else {
            savedScrollToTopTrigger += 1
            return
        }

        rootRoute = .saved
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

    mutating func goBack() {
        if isSearchPresented {
            isSearchPresented = false
            forwardStack.append(.search)
            return
        }

        guard !detailPath.isEmpty else {
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
            detailPath.removeAll()
            rootRoute = .home
            homeScrollToTopTrigger += 1
        case .phrasePage:
            isSearchPresented = false
            detailPath.removeAll()
            rootRoute = .phrasePage
            rootScrollToTopTrigger += 1
        case .saved:
            isSearchPresented = false
            detailPath.removeAll()
            rootRoute = .saved
            savedScrollToTopTrigger += 1
        case .practice:
            isSearchPresented = false
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

    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: kind.symbolName)
                .font(.system(size: 18, weight: .semibold))

            Text(kind.title)
                .font(.caption2.weight(.semibold))
        }
        .foregroundStyle(selected ? .red : .secondary)
        .frame(width: 52, height: 50)
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
            .offset(x: horizontalOffset)
            .opacity(pageOpacity)
            .scaleEffect(pageScale)
            .brightness(pageBrightness)
            .shadow(
                color: .black.opacity(shadowOpacity),
                radius: 22 * progress,
                x: shadowXOffset,
                y: 0
            )
    }

    private var isCurrentRoute: Bool {
        route == currentRoute
    }

    private var isForwardPreviewRoute: Bool {
        route == forwardPreviewRoute && drag?.direction == .forward
    }

    private var isBackPreviewRoute: Bool {
        route == backPreviewRoute && drag?.direction == .back
    }

    private var progress: CGFloat {
        drag?.progress ?? 0
    }

    private var horizontalOffset: CGFloat {
        guard let drag else {
            return 0
        }

        switch drag.direction {
        case .back:
            return isCurrentRoute ? drag.translation : 0
        case .forward:
            if isForwardPreviewRoute {
                return max(0, width + drag.translation)
            }

            return isCurrentRoute ? drag.translation * 0.18 : 0
        }
    }

    private var pageOpacity: Double {
        guard let drag else {
            return isCurrentRoute ? 1 : 0
        }

        switch drag.direction {
        case .back:
            return (isCurrentRoute || isBackPreviewRoute) ? 1 : 0
        case .forward:
            return (isCurrentRoute || isForwardPreviewRoute) ? 1 : 0
        }
    }

    private var pageScale: CGFloat {
        guard let drag else {
            return 1
        }

        switch drag.direction {
        case .back:
            return isCurrentRoute ? 1 : 0.985 + (0.015 * progress)
        case .forward:
            return isCurrentRoute ? 1 - (0.012 * progress) : 1
        }
    }

    private var pageBrightness: Double {
        guard let drag else {
            return 0
        }

        switch drag.direction {
        case .back:
            return isCurrentRoute ? 0 : -Double(0.035 * (1 - progress))
        case .forward:
            return isCurrentRoute ? -Double(0.035 * progress) : 0
        }
    }

    private var shadowOpacity: Double {
        guard drag != nil else {
            return 0
        }

        return (isCurrentRoute || isForwardPreviewRoute) ? Double(0.16 * progress) : 0
    }

    private var shadowXOffset: CGFloat {
        guard let drag else {
            return 0
        }

        switch drag.direction {
        case .back:
            return -8
        case .forward:
            return isForwardPreviewRoute ? -8 : 6
        }
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
    var onBrowseAllTapped: () -> Void

    init(
        intentStore: LocalUserIntentStore,
        scrollToTopTrigger: Int = 0,
        chromeNamespace: Namespace.ID? = nil,
        isSearchActive: Bool = false,
        onSearchTapped: @escaping () -> Void,
        onOpenDetail: @escaping (String) -> Void,
        onBrowseAllTapped: @escaping () -> Void
    ) {
        self.intentStore = intentStore
        self.scrollToTopTrigger = scrollToTopTrigger
        self.chromeNamespace = chromeNamespace
        self.isSearchActive = isSearchActive
        self.onSearchTapped = onSearchTapped
        self.onOpenDetail = onOpenDetail
        self.onBrowseAllTapped = onBrowseAllTapped
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: HomeLayout.sectionSpacing) {
                        Color.clear
                            .frame(height: 0)
                            .id(Self.scrollTopID)

                        header

                        searchEntry
                            .padding(.horizontal, HomeLayout.horizontalPadding)

                        returningUserShelves

                        useNowShelf

                        situationShelves

                        relationshipShelf

                        featuredPagesShelf

                        browseAllEntry
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
                    .font(.system(size: 42, weight: .black, design: .serif))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)

                Text("Offline phrases, audio, and local ways to say it.")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)
            }
            .padding(.horizontal, HomeLayout.horizontalPadding)
            .padding(.top, 18)
            .padding(.bottom, 4)
        }
    }

    private var searchEntry: some View {
        Button {
            onSearchTapped()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "magnifyingglass")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.red)
                    .frame(width: 48, height: 48)
                    .nativeGlass(cornerRadius: 24, interactive: true)

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

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .phraseListCard(cornerRadius: HomeLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Home.SearchEntry")
    }

    @ViewBuilder
    private var returningUserShelves: some View {
        if let continueItem {
            HomeShelf(title: "Continue", subtitle: "Pick up where you were reading") {
                HomeWidePhraseButton(item: continueItem, onOpenDetail: onOpenDetail)
            }
            .padding(.horizontal, HomeLayout.horizontalPadding)
        }

        if !savedItems.isEmpty {
            HomeHorizontalPhraseShelf(
                title: "Saved",
                subtitle: "Phrase pages you marked for later",
                items: savedItems,
                onOpenDetail: onOpenDetail
            )
        }

        if !practiceItems.isEmpty {
            HomeHorizontalPhraseShelf(
                title: "Practice pool",
                subtitle: "Pages you chose for future rehearsal",
                items: practiceItems,
                onOpenDetail: onOpenDetail
            )
        }
    }

    private var useNowShelf: some View {
        HomeHorizontalPhraseShelf(
            title: intentStore.hasReturningUserState ? "Use now" : "Start with essentials",
            subtitle: "High-utility phrases for the first few minutes in Vietnam",
            items: HomeContent.useNowItems,
            onOpenDetail: onOpenDetail
        )
    }

    private var situationShelves: some View {
        HomeShelf(title: "Travel situations", subtitle: "Browse by what is happening around you") {
            LazyVStack(spacing: 12) {
                ForEach(HomeContent.situationGroups) { group in
                    HomeSituationGroupRow(group: group, onOpenDetail: onOpenDetail)
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
            GeometryReader { proxy in
                let groupWidth = max(260, min(326, proxy.size.width - 42))

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: HomeLayout.relationshipGroupSpacing) {
                        ForEach(Array(relationshipPhraseGroups.enumerated()), id: \.offset) { _, group in
                            HomeRelationshipGroupCard(
                                phrases: group,
                                width: groupWidth,
                                onOpenDetail: onOpenDetail
                            )
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollClipDisabled()
            }
            .frame(height: HomeLayout.relationshipGroupHeight(
                for: min(PhrasePage.xinChao.localGreetings.count, HomeLayout.relationshipRowsPerGroup)
            ))
        }
        .padding(.horizontal, HomeLayout.horizontalPadding)
    }

    private var featuredPagesShelf: some View {
        HomeHorizontalPhraseShelf(
            title: "Useful phrase pages",
            subtitle: "Open full pages with audio and local usage notes",
            items: HomeContent.featuredItems,
            onOpenDetail: onOpenDetail
        )
    }

    private var browseAllEntry: some View {
        Button {
            onBrowseAllTapped()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "square.grid.2x2.fill")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.blue)
                    .frame(width: 46, height: 46)
                    .nativeGlass(cornerRadius: 23, interactive: true)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Browse all phrase pages")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Search, browse, save, and practice.")
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

    private var continueItem: HomePhraseItem? {
        intentStore.recentPageIDs.compactMap(HomePhraseItem.resolve(pageID:)).first
    }

    private var savedItems: [HomePhraseItem] {
        intentStore.savedPageIDs.compactMap(HomePhraseItem.resolve(pageID:))
    }

    private var practiceItems: [HomePhraseItem] {
        intentStore.practicePageIDs.compactMap(HomePhraseItem.resolve(pageID:))
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
                        Color.clear
                            .frame(height: 0)
                            .id(Self.scrollTopID)

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
    static let horizontalPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 28
    static let cardCornerRadius: CGFloat = 22
    static let situationRowHeight: CGFloat = 104
    static let situationIconSize: CGFloat = 46
    static let relationshipRowsPerGroup = 3
    static let relationshipGroupSpacing: CGFloat = 12
    static let relationshipRowHeight: CGFloat = 86
    static let relationshipGroupVerticalPadding: CGFloat = 8
    static let bottomChromeContentClearance: CGFloat = 176

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

    static var featuredItems: [HomePhraseItem] {
        featuredIDs.compactMap(HomePhraseItem.resolve(pageID:))
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
        Button {
            onOpenDetail(item.pageID)
        } label: {
            HStack(spacing: 12) {
                AudioSpeakerButton(tint: item.tintName, audioKey: item.audioKey)

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
            .padding(14)
            .phraseListCard(cornerRadius: HomeLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
    }
}

private struct HomePhraseCard: View {
    let item: HomePhraseItem
    let onOpenDetail: (String) -> Void

    var body: some View {
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

                    AudioSpeakerButton(tint: item.tintName, size: 38, audioKey: item.audioKey)
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
        Button {
            if let detailPageID = phrase.detailPageID {
                onOpenDetail(detailPageID)
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: phrase.symbolName)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(phrase.tintName.color)
                    .frame(width: 46, height: 46)
                    .nativeGlass(cornerRadius: 23, interactive: true)

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

                AudioSpeakerButton(tint: phrase.tintName, size: 34, audioKey: phrase.playbackAudioKey)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
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
