import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum AdminRootPhotoBackdropSurface: String, CaseIterable, Hashable {
    case home
    case browse
    case saved
    case practice
    case search

    var poolSurface: SharedBackdropImagePool.Surface {
        switch self {
        case .home:
            return .home
        case .browse:
            return .browse
        case .saved:
            return .saved
        case .practice:
            return .practice
        case .search:
            return .search
        }
    }

    var pageID: String {
        "admin-\(rawValue)"
    }

    var accessibilityPrefix: String {
        switch self {
        case .home:
            return "Home"
        case .browse:
            return "Browse"
        case .saved:
            return "Saved"
        case .practice:
            return "Practice"
        case .search:
            return "Search"
        }
    }

    static func surface(for route: AppRoute) -> AdminRootPhotoBackdropSurface? {
        switch route {
        case .home:
            return .home
        case .browse:
            return .browse
        case .saved:
            return .saved
        case .practice:
            return .practice
        case .search:
            return .search
        case .browseCollection, .phrasePage, .detailPage:
            return nil
        }
    }
}

struct AdminRootPhotoBackdropState: Equatable {
    var imageName: String
    var activationToken: Int

    static let fallback = AdminRootPhotoBackdropState(
        imageName: SharedBackdropImagePool.fallbackImageName,
        activationToken: 0
    )
}

enum AdminRootPhotoBackdropActivationPolicy {
    static func targetSurface(
        previousRoute: AppRoute,
        currentRoute: AppRoute
    ) -> AdminRootPhotoBackdropSurface? {
        guard let currentSurface = AdminRootPhotoBackdropSurface.surface(for: currentRoute) else {
            return nil
        }

        return AdminRootPhotoBackdropSurface.surface(for: previousRoute) == currentSurface
            ? nil
            : currentSurface
    }

    static func shouldAdvanceBackdrop(previousRoute: AppRoute, currentRoute: AppRoute) -> Bool {
        targetSurface(previousRoute: previousRoute, currentRoute: currentRoute) != nil
    }

    static func shouldRefreshImage(
        surface: AdminRootPhotoBackdropSurface,
        currentState: AdminRootPhotoBackdropState
    ) -> Bool {
        switch surface {
        case .home:
            return true
        case .browse, .saved, .practice, .search:
            return currentState.activationToken == 0
        }
    }
}

enum AdminBackdropPreheatPolicy {
    static let maxRetainedPreparedImages = 4

    static func imageNames(backdropImageName: String) -> [String] {
        [backdropImageName]
    }
}

enum HomeBackdropPreheatPolicy {
    static let maxRetainedPreparedImages = AdminBackdropPreheatPolicy.maxRetainedPreparedImages

    static func imageNames(backdropImageName: String) -> [String] {
        SharedBackdropImagePool.preheatCandidateImageNames(selectedImageName: backdropImageName)
    }
}

enum AdminBackdropImagePreheatPlan {
    struct NextQueuedImage: Equatable {
        let imageName: String
        let remainingQueuedImageNames: [String]
    }

    static func pendingImageNames(
        requestedImageNames: [String],
        reservedImageNames: Set<String>
    ) -> [String] {
        var seenImageNames = Set<String>()

        return requestedImageNames.filter { imageName in
            seenImageNames.insert(imageName).inserted && !reservedImageNames.contains(imageName)
        }
    }

    static func queuedImageNames(
        existingQueuedImageNames: [String],
        incomingImageNames: [String],
        maxQueuedImageCount: Int
    ) -> [String] {
        let maxCount = max(maxQueuedImageCount, 0)
        guard maxCount > 0 else {
            return []
        }

        let mergedImageNames = existingQueuedImageNames + incomingImageNames
        return Array(mergedImageNames.suffix(maxCount))
    }

    static func focusedQueuedImageNames(
        existingQueuedImageNames _: [String],
        incomingImageNames: [String],
        maxQueuedImageCount: Int
    ) -> [String] {
        return queuedImageNames(
            existingQueuedImageNames: [],
            incomingImageNames: incomingImageNames,
            maxQueuedImageCount: maxQueuedImageCount
        )
    }

    static func nextQueuedImageName(from queuedImageNames: [String]) -> NextQueuedImage? {
        guard let imageName = queuedImageNames.last else {
            return nil
        }

        return NextQueuedImage(
            imageName: imageName,
            remainingQueuedImageNames: Array(queuedImageNames.dropLast())
        )
    }
}

enum AdminPhotoBackdropSurfaceLayout {
    static func sheetTop(scrollOffset: CGFloat, metrics: PhrasePhotoBackdropLayout.Metrics) -> CGFloat {
        max(metrics.collapsedContentTop - scrollOffset, 0)
    }
}

enum AdminPhotoBackdropTaskPolicy {
    static func shouldRunInitialPositionTask(
        isActive: Bool,
        isVisible: Bool
    ) -> Bool {
        isActive && isVisible
    }

    static func shouldApplyScrollGeometry(
        isActive: Bool,
        isVisible: Bool
    ) -> Bool {
        isActive && isVisible
    }
}

struct AdminPhotoBackdropScrollState: Equatable {
    let displayOffset: CGFloat
    let hasPassedRevealThreshold: Bool

    init(rawOffset: CGFloat, metrics: PhrasePhotoBackdropLayout.Metrics) {
        let offset = max(rawOffset, 0)
        displayOffset = PhrasePhotoBackdropLayout.quantizedScrollOffset(offset)
        hasPassedRevealThreshold = offset > metrics.revealImmersiveOffset
    }
}

struct AdminPhotoBackdropSurfaceView<Content: View>: View {
    let surface: AdminRootPhotoBackdropSurface
    let backdropImageName: String
    let activationToken: Int
    let isActive: Bool
    let isVisible: Bool
    let allowsImmersiveToggle: Bool
    let scrollToTopTrigger: Int
    let onScrollToTop: () -> Void
    let proxyRefreshID: Int
    let onScrollProxyReady: (ScrollViewProxy) -> Void
    let content: (ScrollViewProxy) -> Content

    @State private var didApplyInitialPosition = false
    @State private var isImmersive = false
    @State private var scrollOffset: CGFloat = 0

    init(
        surface: AdminRootPhotoBackdropSurface,
        backdropImageName: String,
        activationToken: Int,
        isActive: Bool,
        isVisible: Bool,
        allowsImmersiveToggle: Bool = true,
        scrollToTopTrigger: Int = 0,
        onScrollToTop: @escaping () -> Void = {},
        proxyRefreshID: Int = 0,
        onScrollProxyReady: @escaping (ScrollViewProxy) -> Void = { _ in },
        @ViewBuilder content: @escaping (ScrollViewProxy) -> Content
    ) {
        self.surface = surface
        self.backdropImageName = backdropImageName
        self.activationToken = activationToken
        self.isActive = isActive
        self.isVisible = isVisible
        self.allowsImmersiveToggle = allowsImmersiveToggle
        self.scrollToTopTrigger = scrollToTopTrigger
        self.onScrollToTop = onScrollToTop
        self.proxyRefreshID = proxyRefreshID
        self.onScrollProxyReady = onScrollProxyReady
        self.content = content
    }

    var body: some View {
        Group {
            if isVisible {
                GeometryReader { geometry in
                    let metrics = PhrasePhotoBackdropLayout.metrics(for: geometry.size)
                    let sheetTop = AdminPhotoBackdropSurfaceLayout.sheetTop(
                        scrollOffset: scrollOffset,
                        metrics: metrics
                    )
                    let topChromeStyle = PhrasePhotoBackdropLayout.topChromeStyle(
                        sheetTop: sheetTop,
                        safeAreaTop: geometry.safeAreaInsets.top,
                        topChromeBackdropHeight: AppChromeLayout.topChromeBackdropHeight(showsMenuSectionChrome: false)
                    )

                    ZStack(alignment: .top) {
                        accessibilityMarker(
                            identifier: "\(surface.accessibilityPrefix).PhotoBackdrop.Surface",
                            label: "\(surface.accessibilityPrefix) photo backdrop surface"
                        )

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
                                        .id(topAnchorID)
                                        .accessibilityHidden(true)

                                    Color.clear
                                        .frame(height: max(metrics.initialContentTop - 1, 0))
                                        .accessibilityHidden(true)

                                    contentSheet(scrollProxy: scrollProxy)
                                }
                            }
                            .scrollDismissesKeyboard(.interactively)
                            .onScrollGeometryChange(for: AdminPhotoBackdropScrollState.self, of: { scrollGeometry in
                                AdminPhotoBackdropScrollState(
                                    rawOffset: max(scrollGeometry.contentOffset.y + scrollGeometry.contentInsets.top, 0),
                                    metrics: metrics
                                )
                            }) { _, scrollState in
                                guard AdminPhotoBackdropTaskPolicy.shouldApplyScrollGeometry(
                                    isActive: isActive,
                                    isVisible: isVisible
                                ) else {
                                    return
                                }

                                if scrollOffset != scrollState.displayOffset {
                                    scrollOffset = scrollState.displayOffset
                                }

                                if isImmersive, scrollState.hasPassedRevealThreshold {
                                    withAnimation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation) {
                                        isImmersive = false
                                    }
                                }
                            }
                            .onAppear {
                                if isVisible, !didApplyInitialPosition {
                                    scrollProxy.scrollTo(topAnchorID, anchor: .top)
                                }
                                onScrollProxyReady(scrollProxy)
                            }
                            .onChange(of: isVisible) { _, visible in
                                if visible, !didApplyInitialPosition {
                                    scrollProxy.scrollTo(topAnchorID, anchor: .top)
                                }
                            }
                            .onChange(of: proxyRefreshID) { _, _ in
                                onScrollProxyReady(scrollProxy)
                            }
                            .onChange(of: scrollToTopTrigger) { _, _ in
                                onScrollToTop()
                                isImmersive = false
                                scrollOffset = 0
                                scrollProxy.scrollTo(topAnchorID, anchor: .top)
                                DispatchQueue.main.async {
                                    scrollOffset = 0
                                    scrollProxy.scrollTo(topAnchorID, anchor: .top)
                                }
                            }
                            .task(id: AdminPhotoBackdropTaskPolicy.shouldRunInitialPositionTask(
                                isActive: isActive,
                                isVisible: isVisible
                            )) {
                                guard AdminPhotoBackdropTaskPolicy.shouldRunInitialPositionTask(
                                    isActive: isActive,
                                    isVisible: isVisible
                                ) else {
                                    return
                                }

                                await applyInitialPositionIfNeeded(scrollProxy, metrics: metrics)
                                await AppBottomInsetValidation.scrollToBottom(
                                    scrollProxy,
                                    sentinelID: "\(surface.accessibilityPrefix).BottomSentinel"
                                )
                            }
                        }

                    }
                    .ignoresSafeArea(edges: .top)
                    .contentShape(Rectangle())
                    .simultaneousGesture(
                        SpatialTapGesture().onEnded { value in
                            toggleImmersive(at: value.location, metrics: metrics)
                        }
                    )
                    .preference(
                        key: PhrasePhotoBackdropImmersiveImagePreferenceKey.self,
                        value: isActive && isImmersive
                            ? PhrasePhotoBackdropImmersiveImageContext(
                                pageID: surface.pageID,
                                imageName: backdropImageName,
                                viewportSize: geometry.size,
                                safeAreaTop: geometry.safeAreaInsets.top,
                                safeAreaBottom: geometry.safeAreaInsets.bottom,
                                imageFrameHeight: PhrasePhotoBackdropLayout.backdropFrameHeight(
                                    for: geometry.size,
                                    safeAreaInsets: geometry.safeAreaInsets,
                                    pageID: surface.pageID,
                                    heroImageName: backdropImageName
                                ),
                                verticalFocusOffset: PhrasePhotoBackdropLayout.backdropVerticalFocusOffset(
                                    for: geometry.size,
                                    pageID: surface.pageID,
                                    heroImageName: backdropImageName
                                )
                            )
                            : nil
                    )
                    .preference(
                        key: PhrasePhotoBackdropTopChromeStylePreferenceKey.self,
                        value: isActive && !isImmersive ? topChromeStyle : .light
                    )
                }
            } else {
                Color.clear
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .statusBarHidden(isActive && isImmersive)
        .persistentSystemOverlays(isActive && isImmersive ? .hidden : .automatic)
        .preference(
            key: PhrasePhotoBackdropImmersiveChromePreferenceKey.self,
            value: isActive && isVisible && isImmersive
        )
        .preference(
            key: PhrasePhotoBackdropTabBarBackgroundPreferenceKey.self,
            value: isActive && isVisible && !isImmersive
        )
        .task(id: activationToken) {
            guard isActive, isVisible else {
                return
            }

            AdminBackdropImagePreheater.preheat(
                AdminBackdropPreheatPolicy.imageNames(backdropImageName: backdropImageName)
            )
        }
        .onChange(of: isActive) { _, active in
            if !active {
                isImmersive = false
            }
        }
        .onChange(of: allowsImmersiveToggle) { _, allowsImmersiveToggle in
            if !allowsImmersiveToggle {
                isImmersive = false
            }
        }
    }

    private var topAnchorID: String {
        "\(surface.rawValue)-photo-backdrop-top"
    }

    private func contentSheet(scrollProxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Capsule()
                .fill(.secondary.opacity(0.22))
                .frame(width: 42, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                .padding(.bottom, 10)
                .accessibilityHidden(true)

            accessibilityMarker(
                identifier: "\(surface.accessibilityPrefix).PhotoBackdrop.Content",
                label: "\(surface.accessibilityPrefix) photo backdrop content"
            )

            content(scrollProxy)
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
        .opacity(isImmersive ? 0 : 1)
        .allowsHitTesting(!isImmersive)
        .accessibilityHidden(isImmersive)
        .animation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation, value: isImmersive)
    }

    private func accessibilityMarker(identifier: String, label: String) -> some View {
        Color.clear
            .frame(width: 1, height: 1)
            .accessibilityElement()
            .accessibilityLabel(label)
            .accessibilityIdentifier(identifier)
    }

    private func photoBackdropImage(geometry: GeometryProxy) -> some View {
        AdminBackdropPreparedImage(name: backdropImageName)
            .scaledToFill()
            .frame(
                width: geometry.size.width,
                height: PhrasePhotoBackdropLayout.backdropFrameHeight(
                    for: geometry.size,
                    safeAreaInsets: geometry.safeAreaInsets,
                    pageID: surface.pageID,
                    heroImageName: backdropImageName
                ),
                alignment: .top
            )
            .clipped()
            .ignoresSafeArea()
            .accessibilityLabel("\(surface.accessibilityPrefix) backdrop")
            .accessibilityHidden(true)
            .accessibilityIdentifier("\(surface.accessibilityPrefix).PhotoBackdrop.Image")
    }

    private func photoBackdropBottomChromeBackdrop(
        geometry: GeometryProxy,
        metrics: PhrasePhotoBackdropLayout.Metrics
    ) -> some View {
        let safeAreaBottom = geometry.safeAreaInsets.bottom
        let sheetTop = AdminPhotoBackdropSurfaceLayout.sheetTop(
            scrollOffset: scrollOffset,
            metrics: metrics
        )
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
        .opacity(isImmersive ? 0 : 1)
        .animation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation, value: isImmersive)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    @MainActor
    private func applyInitialPositionIfNeeded(
        _ scrollProxy: ScrollViewProxy,
        metrics: PhrasePhotoBackdropLayout.Metrics
    ) async {
        guard !didApplyInitialPosition else {
            return
        }

        try? await Task.sleep(nanoseconds: 80_000_000)
        guard !Task.isCancelled, isActive, isVisible else {
            return
        }

        isImmersive = false
        scrollProxy.scrollTo(topAnchorID, anchor: .top)
        didApplyInitialPosition = true
    }

    private func toggleImmersive(
        at location: CGPoint,
        metrics: PhrasePhotoBackdropLayout.Metrics
    ) {
        guard isActive, isVisible, allowsImmersiveToggle else {
            return
        }

        if isImmersive {
            withAnimation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation) {
                isImmersive = false
            }
            return
        }

        guard PhrasePhotoBackdropLayout.isImageTap(
            location,
            scrollOffset: scrollOffset,
            metrics: metrics
        ) else {
            return
        }

        withAnimation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation) {
            isImmersive = true
        }
    }
}

enum AdminBackdropImagePreheater {
    #if canImport(UIKit)
    private enum QueueMode {
        case retainingQueuedWork
        case focusedOnCurrentRequest
    }

    typealias ImagePreparer = (String) -> UIImage?
    typealias ImageAvailabilityChecker = (String) -> Bool

    private static let maxPreheatedImageCount = AdminBackdropPreheatPolicy.maxRetainedPreparedImages
    private static let maxQueuedImageCount = AdminBackdropPreheatPolicy.maxRetainedPreparedImages
    private static let lock = NSLock()
    private static let defaultImagePreparer: ImagePreparer = { imageName in
        UIImage(named: imageName)?.preparingForDisplay()
    }
    private static let defaultImageAvailabilityChecker: ImageAvailabilityChecker = { imageName in
        UIImage(named: imageName) != nil
    }
    private static var preheatedImageNames = Set<String>()
    private static var preheatedImages = [String: UIImage]()
    private static var preheatedImageOrder = [String]()
    private static var queuedImageNames = [String]()
    private static var focusedPreheatGeneration = 0
    private static var focusedRequestImageNames = Set<String>()
    private static var focusedGenerationByImageName = [String: Int]()
    private static var imagePreparer: ImagePreparer = defaultImagePreparer
    private static var imageAvailabilityChecker: ImageAvailabilityChecker = defaultImageAvailabilityChecker
    private static var displayImageNameCache = [String: String]()
    private static var queueWorkerTask: Task<Void, Never>?

    static func preheat(_ imageNames: [String]) {
        preheat(imageNames, queueMode: .retainingQueuedWork)
    }

    static func preheatFocused(_ imageNames: [String]) {
        preheat(imageNames, queueMode: .focusedOnCurrentRequest)
    }

    private static func preheat(_ imageNames: [String], queueMode: QueueMode) {
        let imageNames = imageNames.map(displayImageName(for:))
        lock.lock()
        let pendingImageNames = AdminBackdropImagePreheatPlan.pendingImageNames(
            requestedImageNames: imageNames,
            reservedImageNames: preheatedImageNames
        )
        pendingImageNames.forEach { preheatedImageNames.insert($0) }
        let previousQueuedImageNames = queuedImageNames

        switch queueMode {
        case .retainingQueuedWork:
            guard !pendingImageNames.isEmpty else {
                lock.unlock()
                return
            }

            queuedImageNames = AdminBackdropImagePreheatPlan.queuedImageNames(
                existingQueuedImageNames: queuedImageNames,
                incomingImageNames: pendingImageNames,
                maxQueuedImageCount: maxQueuedImageCount
            )
        case .focusedOnCurrentRequest:
            focusedPreheatGeneration += 1
            let requestedImageNames = Set(imageNames)
            focusedRequestImageNames = requestedImageNames
            let retainedRequestedQueue = queuedImageNames.filter { requestedImageNames.contains($0) }
            queuedImageNames = AdminBackdropImagePreheatPlan.focusedQueuedImageNames(
                existingQueuedImageNames: queuedImageNames,
                incomingImageNames: retainedRequestedQueue + pendingImageNames,
                maxQueuedImageCount: maxQueuedImageCount
            )
            for imageName in queuedImageNames where requestedImageNames.contains(imageName) {
                focusedGenerationByImageName[imageName] = focusedPreheatGeneration
            }
        }

        releaseDroppedQueuedReservations(
            previousQueuedImageNames + pendingImageNames,
            retainedQueuedImageNames: queuedImageNames
        )

        guard !queuedImageNames.isEmpty else {
            lock.unlock()
            return
        }

        if queueWorkerTask == nil {
            queueWorkerTask = Task.detached(priority: .utility) {
                drainPreheatQueue()
            }
        }
        lock.unlock()
    }

    static func preparedImage(named imageName: String) -> UIImage? {
        let imageName = displayImageName(for: imageName)
        lock.lock()
        defer { lock.unlock() }
        return preheatedImages[imageName]
    }

    static func displayImageName(for imageName: String) -> String {
        lock.lock()
        if let cachedDisplayImageName = displayImageNameCache[imageName] {
            lock.unlock()
            return cachedDisplayImageName
        }
        let availabilityChecker = Self.imageAvailabilityChecker
        lock.unlock()

        let displayImageName = availabilityChecker(imageName)
            ? imageName
            : SharedBackdropImagePool.fallbackImageName

        lock.lock()
        displayImageNameCache[imageName] = displayImageName
        lock.unlock()
        return displayImageName
    }

    private static func drainPreheatQueue() {
        while true {
            lock.lock()
            guard let nextQueuedImage = AdminBackdropImagePreheatPlan.nextQueuedImageName(from: queuedImageNames) else {
                queueWorkerTask = nil
                lock.unlock()
                return
            }
            queuedImageNames = nextQueuedImage.remainingQueuedImageNames
            let imageName = nextQueuedImage.imageName
            let focusedGeneration = focusedGenerationByImageName[imageName]
            let imagePreparer = imagePreparer
            lock.unlock()

            autoreleasepool {
                let preparedImage = imagePreparer(imageName)
                lock.lock()
                if let preparedImage,
                   shouldCommitPreparedImage(imageName, focusedGeneration: focusedGeneration) {
                    preheatedImages[imageName] = preparedImage
                    preheatedImageOrder.append(imageName)
                    trimPreheatedImagesIfNeeded()
                } else {
                    releasePendingReservation(imageName)
                }
                lock.unlock()
            }
        }
    }

    private static func releaseDroppedQueuedReservations(
        _ candidateImageNames: [String],
        retainedQueuedImageNames: [String]
    ) {
        let retainedQueuedImageNames = Set(retainedQueuedImageNames)

        for imageName in candidateImageNames where !retainedQueuedImageNames.contains(imageName) {
            releasePendingReservation(imageName)
        }
    }

    private static func shouldCommitPreparedImage(_ imageName: String, focusedGeneration: Int?) -> Bool {
        guard let focusedGeneration else {
            return true
        }

        return focusedGeneration == focusedPreheatGeneration
            || focusedRequestImageNames.contains(imageName)
    }

    private static func releasePendingReservation(_ imageName: String) {
        if preheatedImages[imageName] == nil {
            preheatedImageNames.remove(imageName)
            focusedGenerationByImageName.removeValue(forKey: imageName)
        }
    }

    private static func trimPreheatedImagesIfNeeded() {
        while preheatedImageOrder.count > maxPreheatedImageCount {
            let evictedImageName = preheatedImageOrder.removeFirst()
            preheatedImages[evictedImageName] = nil
            preheatedImageNames.remove(evictedImageName)
            focusedGenerationByImageName.removeValue(forKey: evictedImageName)
        }
    }

#if DEBUG
    static func resetForTesting(
        imagePreparer: ImagePreparer? = nil,
        imageAvailabilityChecker: ImageAvailabilityChecker? = nil
    ) {
        lock.lock()
        queueWorkerTask?.cancel()
        queueWorkerTask = nil
        preheatedImageNames.removeAll()
        preheatedImages.removeAll()
        preheatedImageOrder.removeAll()
        queuedImageNames.removeAll()
        focusedPreheatGeneration = 0
        focusedRequestImageNames.removeAll()
        focusedGenerationByImageName.removeAll()
        Self.imagePreparer = imagePreparer ?? defaultImagePreparer
        Self.imageAvailabilityChecker = imageAvailabilityChecker
            ?? (imagePreparer == nil ? defaultImageAvailabilityChecker : { _ in true })
        displayImageNameCache.removeAll()
        lock.unlock()
    }
#endif
    #else
    static func preheat(_ imageNames: [String]) {}
    static func preheatFocused(_ imageNames: [String]) {}
    static func displayImageName(for imageName: String) -> String { imageName }
    #endif
}

struct AdminBackdropPreparedImage: View {
    let name: String

    var body: some View {
        #if canImport(UIKit)
        let imageName = AdminBackdropImagePreheater.displayImageName(for: name)
        if let preparedImage = AdminBackdropImagePreheater.preparedImage(named: imageName) {
            Image(uiImage: preparedImage)
                .resizable()
                .interpolation(.medium)
        } else {
            Image(imageName)
                .resizable()
                .interpolation(.medium)
        }
        #else
        Image(name)
            .resizable()
            .interpolation(.medium)
        #endif
    }
}
