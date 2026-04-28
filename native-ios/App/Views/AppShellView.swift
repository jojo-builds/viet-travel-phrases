import SwiftUI

struct AppShellView: View {
    @State private var navigation: AppShellNavigationState
    @State private var interactiveDrag: AppInteractiveNavigationDrag?
    @State private var searchQuery = ""
    @Namespace private var chromeNamespace

    init(initialRoute: AppRoute = AppShellView.initialRoute) {
        _navigation = State(initialValue: AppShellNavigationState(initialRoute: initialRoute))
    }

    var body: some View {
        GeometryReader { proxy in
            let pageWidth = max(proxy.size.width, 1)

            ZStack {
                PhraseListingView(
                    page: .xinChao,
                    scrollToTopTrigger: navigation.rootScrollToTopTrigger,
                    chromeNamespace: chromeNamespace,
                    isSearchActive: navigation.isSearchPresented,
                    showsChrome: false,
                    onBackTapped: {},
                    onSearchTapped: openSearch,
                    onDetailTapped: openDetail
                )
                .allowsHitTesting(navigation.currentRoute == .phrasePage && !isPreviewingForwardPage)
                .accessibilityHidden(navigation.currentRoute != .phrasePage)
                .navigationPageMotion(
                    route: .phrasePage,
                    currentRoute: navigation.currentRoute,
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
                staticBottomChrome
                    .padding(.horizontal, AppChromeLayout.bottomOuterHorizontalPadding)
                    .padding(.bottom, AppChromeLayout.bottomPadding)
                    .offset(y: AppChromeLayout.bottomOffset)
                    .zIndex(380)
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
        }
        .preferredColorScheme(.light)
    }

    @ViewBuilder
    private func detailPageStack(width: CGFloat) -> some View {
        ForEach(Array(navigation.renderedDetailPages.enumerated()), id: \.element.id) { index, renderedPage in
            if let detailPage = PhraseDetailPage.page(withID: renderedPage.pageID) {
                let route = AppRoute.detailPage(renderedPage.pageID)
                let isActive = route == navigation.currentRoute

                PhraseDetailView(
                    page: detailPage,
                    scrollToTopTrigger: isActive ? navigation.detailScrollToTopTrigger : 0,
                    chromeNamespace: chromeNamespace,
                    isSearchActive: navigation.isSearchPresented,
                    showsChrome: false,
                    onBackTapped: goBack,
                    onSearchTapped: openSearch,
                    onDetailTapped: openDetail
                )
                .allowsHitTesting(isActive && !navigation.isSearchPresented && !isPreviewingForwardPage)
                .accessibilityHidden(!isActive || navigation.isSearchPresented)
                .transition(AppPageTransition.slideFromTrailing)
                .zIndex(Double(index + 10))
                .navigationPageMotion(
                    route: route,
                    currentRoute: navigation.currentRoute,
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
                    forwardPreviewRoute: navigation.forwardPreviewRoute,
                    drag: interactiveDrag,
                    width: width
                )
        }
    }

    @ViewBuilder
    private func previewPage(for route: AppRoute) -> some View {
        switch route {
        case .phrasePage:
            PhraseListingView(
                page: .xinChao,
                scrollToTopTrigger: navigation.rootScrollToTopTrigger,
                chromeNamespace: chromeNamespace,
                isSearchActive: navigation.isSearchPresented,
                showsChrome: false,
                onBackTapped: {},
                onSearchTapped: openSearch,
                onDetailTapped: openDetail
            )
        case .detailPage(let detailPageID):
            if let detailPage = PhraseDetailPage.page(withID: detailPageID) {
                PhraseDetailView(
                    page: detailPage,
                    scrollToTopTrigger: 0,
                    chromeNamespace: chromeNamespace,
                    isSearchActive: navigation.isSearchPresented,
                    showsChrome: false,
                    onBackTapped: goBack,
                    onSearchTapped: openSearch,
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

    private var isPreviewingForwardPage: Bool {
        interactiveDrag?.direction == .forward && navigation.forwardPreviewRoute != nil
    }

    private var showsStaticBackButton: Bool {
        navigation.currentRoute != .search
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

    private var collapsedBottomChromeContent: some View {
        HStack(spacing: AppChromeLayout.bottomSpacing) {
            HStack(spacing: AppChromeLayout.dockItemSpacing) {
                ForEach(AppChrome(route: navigation.currentRoute).primaryDockItems, id: \.self) { item in
                    AppShellDockItem(kind: item, selected: item == .home)
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
                closeSearch()
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
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openDetail(id)
        }
    }

    private func openDetailFromSearch(_ id: String) {
        withAnimation(.snappy(duration: 0.34)) {
            navigation.openDetail(id)
        }
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
    }

    private func closeSearch() {
        goBack()
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
            return arguments.contains("--search") ? .search : .phrasePage
        }

        let pageID = arguments[arguments.index(after: flagIndex)]
        guard PhraseCatalog.isOpenablePageID(pageID) else {
            return arguments.contains("--search") ? .search : .phrasePage
        }

        return .detailPage(pageID)
    }

    private static var initialRoute: AppRoute {
        initialRoute(for: ProcessInfo.processInfo.arguments)
    }
}

struct AppShellNavigationState: Equatable {
    var detailPath: [String]
    var isSearchPresented: Bool
    var forwardStack: [AppRoute] = []
    var rootScrollToTopTrigger = 0
    var detailScrollToTopTrigger = 0

    init(initialRoute: AppRoute = .phrasePage) {
        if case .detailPage(let detailPageID) = initialRoute {
            detailPath = [detailPageID]
        } else {
            detailPath = []
        }

        isSearchPresented = initialRoute == .search
    }

    var currentRoute: AppRoute {
        if isSearchPresented {
            return .search
        }

        if let detailPageID = detailPath.last {
            return .detailPage(detailPageID)
        }

        return .phrasePage
    }

    var forwardPreviewRoute: AppRoute? {
        forwardStack.last
    }

    var canGoForward: Bool {
        forwardPreviewRoute != nil
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
        isSearchPresented || !detailPath.isEmpty
    }

    mutating func openDetail(_ id: String) {
        if id == PhrasePage.xinChao.id {
            guard currentRoute != .phrasePage else {
                return
            }

            detailPath.removeAll()
            isSearchPresented = false
            forwardStack.removeAll()
            rootScrollToTopTrigger += 1
            return
        }

        guard PhraseCatalog.isOpenablePageID(id) else {
            return
        }

        guard detailPath.last != id else {
            return
        }

        isSearchPresented = false
        forwardStack.removeAll()
        detailPath.append(id)
        detailScrollToTopTrigger += 1
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
        case .phrasePage:
            isSearchPresented = false
            detailPath.removeAll()
            rootScrollToTopTrigger += 1
        case .detailPage(let detailPageID):
            guard PhraseCatalog.isOpenablePageID(detailPageID) else {
                return
            }

            isSearchPresented = false

            if detailPath.last != detailPageID {
                detailPath.append(detailPageID)
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
    let forwardPreviewRoute: AppRoute?
    let drag: AppInteractiveNavigationDrag?
    let width: CGFloat

    func body(content: Content) -> some View {
        content
            .offset(x: horizontalOffset)
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
        forwardPreviewRoute: AppRoute?,
        drag: AppInteractiveNavigationDrag?,
        width: CGFloat
    ) -> some View {
        modifier(
            NavigationPageMotion(
                route: route,
                currentRoute: currentRoute,
                forwardPreviewRoute: forwardPreviewRoute,
                drag: drag,
                width: width
            )
        )
    }
}
