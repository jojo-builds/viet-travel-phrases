import SwiftUI

enum VietnameseMenuPhotoBackdropPolicy {
    static func imageName(
        photoBackdropImageName: String?,
        fallbackHeroImageName: String
    ) -> String {
        photoBackdropImageName ?? fallbackHeroImageName
    }

    static func preheatImageNames(
        photoBackdropImageName: String?,
        fallbackHeroImageName: String
    ) -> [String] {
        guard let photoBackdropImageName else {
            return []
        }

        return [
            imageName(
                photoBackdropImageName: photoBackdropImageName,
                fallbackHeroImageName: fallbackHeroImageName
            ),
        ]
    }
}

struct VietnameseMenuPageView: View {
    let kind: VietnameseMenuKind
    let scrollToTopTrigger: Int
    let scrollToTopRoute: BrowseCollectionRoute?
    let sectionJumpRequest: VietnameseMenuSectionJumpRequest?
    var isSaved: (String) -> Bool
    var onToggleSaved: (String) -> Void
    var onOpenDetail: (String) -> Void
    var isActive: Bool = true

    @State private var sectionTracker = VietnameseMenuSectionTrackingCoordinator(initialSectionID: "popular")
    @State private var pendingSectionJumpID = 0
    @State private var pendingSectionJumpSectionID: String?
    @State private var isResolvingSectionJump = false
    @State private var pendingScrollSectionUpdate: VietnameseMenuPendingSectionUpdate?
    @State private var sectionJumpSettleID = 0
    @State private var isSettlingProgrammaticSectionJump = false
    @State private var didApplyPhotoBackdropInitialPosition = false
    @State private var isPhotoBackdropImmersive = false
    @State private var photoBackdropScrollCoordinator = VietnameseMenuPhotoBackdropScrollCoordinator()

    private var bottomSentinelID: String {
        "VietnameseMenu.BottomSentinel.\(kind.routeID)"
    }

    private var route: BrowseCollectionRoute {
        .category(kind.routeID)
    }

    private var sections: [VietnameseMenuSection] {
        VietnameseMenuCatalog.sections(for: kind)
    }

    private var sectionChromeItems: [VietnameseMenuSectionChromeItem] {
        sections.map { section in
            VietnameseMenuSectionChromeItem(
                id: section.id,
                title: section.title,
                symbolName: section.symbolName,
                tintName: section.tintName
            )
        }
    }

    @ViewBuilder
    var body: some View {
        Group {
            if usesPhotoBackdropLayout {
                photoBackdropBody
            } else {
                standardBody
            }
        }
        .onChange(of: kind) { _, _ in
            sectionTracker.reset(to: sections.first?.id ?? "popular")
            pendingSectionJumpSectionID = nil
            didApplyPhotoBackdropInitialPosition = false
            isPhotoBackdropImmersive = false
            photoBackdropScrollCoordinator.reset()
        }
        .background {
            VietnameseMenuSectionChromePreferenceEmitter(
                route: route,
                isActive: isActive,
                sectionTracker: sectionTracker,
                sections: sectionChromeItems
            )
        }
        .preference(
            key: PhrasePhotoBackdropImmersiveChromePreferenceKey.self,
            value: isActive && usesPhotoBackdropLayout && isPhotoBackdropImmersive
        )
        .preference(
            key: PhrasePhotoBackdropTabBarBackgroundPreferenceKey.self,
            value: isActive && usesPhotoBackdropLayout && !isPhotoBackdropImmersive
        )
        .task(id: "\(isActive)-\(pendingScrollSectionUpdate.map { "\($0.sectionID)-\($0.revision)" } ?? "none")") {
            guard VietnameseMenuTaskPolicy.shouldRunDeferredSectionTask(isActive: isActive) else {
                return
            }

            await commitPendingScrollSectionUpdateIfNeeded()
        }
        .task(id: "\(isActive)-\(sectionJumpSettleID)") {
            guard VietnameseMenuTaskPolicy.shouldRunDeferredSectionTask(isActive: isActive) else {
                return
            }

            await clearProgrammaticSectionJumpSettleIfNeeded()
        }
        .accessibilityIdentifier("VietnameseMenu.\(kind.routeID)")
    }

    private var standardBody: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: VietnameseMenuLayout.sectionSpacing) {
                        header
                            .id(Self.scrollTopID)

                        sectionRail(scrollProxy: scrollProxy)

                        sectionedMenu
                            .padding(.horizontal, VietnameseMenuLayout.horizontalPadding)

                        AppBottomSentinel(id: bottomSentinelID)
                    }
                    .padding(.bottom, VietnameseMenuLayout.bottomContentClearance(usesPhotoBackdrop: false))
                }
                .onPreferenceChange(VietnameseMenuSectionFramePreferenceKey.self) { frames in
                    updateCurrentSection(from: frames)
                }
                .onPreferenceChange(VietnameseMenuRailFramePreferenceKey.self) { frame in
                    guard VietnameseMenuTaskPolicy.shouldApplySectionPreferenceTracking(isActive: isActive) else {
                        return
                    }

                    sectionTracker.applyRailFrame(frame, revealY: VietnameseMenuLayout.glassRailRevealY)
                }
                .onChange(of: scrollToTopTrigger) { _, _ in
                    guard scrollToTopRoute == nil || scrollToTopRoute == route else {
                        return
                    }

                    scrollProxy.scrollTo(Self.scrollTopID, anchor: .top)
                }
                .onChange(of: sectionJumpRequest?.requestID) { _, _ in
                    guard let sectionJumpRequest, sectionJumpRequest.route == route else {
                        return
                    }

                    jumpToSection(sectionJumpRequest.sectionID)
                }
                .task(id: "\(isActive)-\(pendingSectionJumpID)") {
                    guard VietnameseMenuTaskPolicy.shouldRunStandardScrollTask(isActive: isActive) else {
                        return
                    }

                    if AppBottomInsetValidation.shouldScrollToBottom {
                        await AppBottomInsetValidation.scrollToBottom(scrollProxy, sentinelID: bottomSentinelID)
                        return
                    }

                    await performPendingSectionJump(scrollProxy)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }

    private static let scrollTopID = "VietnameseMenuPageTop"
    private static let photoBackdropInitialID = "VietnameseMenuPhotoBackdropInitial"

    private var header: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeroMastheadImage(imageName: kind.heroImageName, height: VietnameseMenuLayout.heroHeight)

            headerCopy
                .padding(.horizontal, VietnameseMenuLayout.horizontalPadding)
                .padding(.top, 16)
        }
    }

    private var headerCopy: some View {
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

            Text(kind.title)
                .font(.system(size: 46, weight: .black, design: .serif))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.68)
                .accessibilityIdentifier("VietnameseMenu.Title.\(kind.routeID)")

            Text(kind.subtitle)
                .font(.body.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var photoBackdropBody: some View {
        GeometryReader { geometry in
            let metrics = PhrasePhotoBackdropLayout.metrics(for: geometry.size)

            ZStack(alignment: .top) {
                photoBackdropImage(geometry: geometry)

                VietnameseMenuPhotoBackdropBottomChromeBackdrop(
                    scrollCoordinator: photoBackdropScrollCoordinator,
                    viewportHeight: geometry.size.height,
                    safeAreaBottom: geometry.safeAreaInsets.bottom,
                    collapsedContentTop: metrics.collapsedContentTop,
                    isPhotoBackdropImmersive: isPhotoBackdropImmersive
                )

                ScrollViewReader { scrollProxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            Color.clear
                                .frame(height: metrics.initialAnchorOffset)
                                .accessibilityHidden(true)

                            Color.clear
                                .frame(height: 1)
                                .id(Self.photoBackdropInitialID)
                                .accessibilityHidden(true)

                            Color.clear
                                .frame(height: max(metrics.initialContentTop - 1, 0))
                                .accessibilityHidden(true)

                            photoBackdropContentSheet(scrollProxy: scrollProxy)
                                .id(Self.scrollTopID)
                        }
                    }
                    .onScrollGeometryChange(for: PhrasePhotoBackdropLayout.ScrollState.self, of: { scrollGeometry in
                        PhrasePhotoBackdropLayout.scrollState(
                            for: max(scrollGeometry.contentOffset.y + scrollGeometry.contentInsets.top, 0),
                            metrics: metrics
                        )
                    }) { _, scrollState in
                        guard VietnameseMenuTaskPolicy.shouldApplyPhotoBackdropScrollGeometry(isActive: isActive) else {
                            return
                        }

                        let hasPassedRevealThreshold = photoBackdropScrollCoordinator.apply(scrollState)

                        if isPhotoBackdropImmersive, hasPassedRevealThreshold {
                            withAnimation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation) {
                                isPhotoBackdropImmersive = false
                            }
                        }
                    }
                    .onPreferenceChange(VietnameseMenuSectionFramePreferenceKey.self) { frames in
                        updateCurrentSection(from: frames)
                    }
                    .onPreferenceChange(VietnameseMenuRailFramePreferenceKey.self) { frame in
                        guard VietnameseMenuTaskPolicy.shouldApplySectionPreferenceTracking(isActive: isActive) else {
                            return
                        }

                        sectionTracker.applyRailFrame(frame, revealY: VietnameseMenuLayout.glassRailRevealY)
                    }
                    .onChange(of: scrollToTopTrigger) { _, _ in
                        guard scrollToTopRoute == nil || scrollToTopRoute == route else {
                            return
                        }

                        isPhotoBackdropImmersive = false
                        scrollProxy.scrollTo(Self.photoBackdropInitialID, anchor: .top)
                    }
                    .onChange(of: sectionJumpRequest?.requestID) { _, _ in
                        guard let sectionJumpRequest, sectionJumpRequest.route == route else {
                            return
                        }

                        jumpToSection(sectionJumpRequest.sectionID)
                    }
                    .task(id: "\(isActive)-\(pendingSectionJumpID)") {
                        guard isActive else {
                            return
                        }

                        if pendingSectionJumpID == 0 {
                            await applyPhotoBackdropInitialPositionIfNeeded(scrollProxy)
                        } else {
                            await performPendingSectionJump(scrollProxy)
                        }

                        await AppBottomInsetValidation.scrollToBottom(scrollProxy, sentinelID: bottomSentinelID)
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
                value: isActive && usesPhotoBackdropLayout && isPhotoBackdropImmersive
                    ? PhrasePhotoBackdropImmersiveImageContext(
                        pageID: route.id,
                        imageName: activePhotoBackdropImageName,
                        viewportSize: geometry.size,
                        safeAreaTop: geometry.safeAreaInsets.top,
                        safeAreaBottom: geometry.safeAreaInsets.bottom,
                        imageFrameHeight: PhrasePhotoBackdropLayout.backdropFrameHeight(
                            for: geometry.size,
                            safeAreaInsets: geometry.safeAreaInsets,
                            pageID: route.id,
                            heroImageName: photoBackdropImageName
                        ),
                        verticalFocusOffset: PhrasePhotoBackdropLayout.backdropVerticalFocusOffset(
                            for: geometry.size,
                            pageID: route.id,
                            heroImageName: photoBackdropImageName
                        )
                    )
                    : nil
            )
        }
        .ignoresSafeArea(edges: .bottom)
        .statusBarHidden(isActive && isPhotoBackdropImmersive)
        .persistentSystemOverlays(isActive && isPhotoBackdropImmersive ? .hidden : .automatic)
        .task(id: isActive ? activePhotoBackdropImageName : "") {
            guard isActive else {
                return
            }

            AdminBackdropImagePreheater.preheatFocused(
                VietnameseMenuPhotoBackdropPolicy.preheatImageNames(
                    photoBackdropImageName: photoBackdropImageName,
                    fallbackHeroImageName: kind.heroImageName
                )
            )
        }
    }

    private func photoBackdropContentSheet(scrollProxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Capsule()
                .fill(.secondary.opacity(0.22))
                .frame(width: 42, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                .padding(.bottom, 10)
                .accessibilityHidden(true)

            headerCopy
                .padding(.horizontal, VietnameseMenuLayout.horizontalPadding)
                .padding(.bottom, 24)

            sectionRail(scrollProxy: scrollProxy)
                .padding(.bottom, VietnameseMenuLayout.sectionSpacing)

            sectionedMenu
                .padding(.horizontal, VietnameseMenuLayout.horizontalPadding)

            AppBottomSentinel(id: bottomSentinelID)
                .padding(.horizontal, VietnameseMenuLayout.horizontalPadding)
        }
        .padding(.bottom, VietnameseMenuLayout.bottomContentClearance(usesPhotoBackdrop: true))
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
        .accessibilityIdentifier("VietnameseMenu.PhotoBackdrop.Content.\(kind.routeID)")
    }

    private func photoBackdropImage(geometry: GeometryProxy) -> some View {
        AdminBackdropPreparedImage(name: activePhotoBackdropImageName)
            .scaledToFill()
            .frame(
                width: geometry.size.width,
                height: PhrasePhotoBackdropLayout.backdropFrameHeight(
                    for: geometry.size,
                    safeAreaInsets: geometry.safeAreaInsets,
                    pageID: route.id,
                    heroImageName: photoBackdropImageName
                ),
                alignment: .top
            )
            .clipped()
            .ignoresSafeArea()
            .accessibilityHidden(true)
    }

    private func sectionRail(scrollProxy: ScrollViewProxy) -> some View {
        VietnameseMenuSectionRail(
            sections: sections,
            sectionTracker: sectionTracker,
            onJump: jumpToSection
        )
    }

    private var sectionedMenu: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(Array(sections.enumerated()), id: \.element.id) { index, section in
                Color.clear
                    .frame(width: 1, height: 1)
                    .id(Self.sectionAnchorID(for: section.id))
                    .accessibilityHidden(true)

                VietnameseMenuSectionBlock(
                    section: section,
                    heroImageName: menuThumbnailImageName,
                    isSaved: isSaved,
                    onToggleSaved: onToggleSaved,
                    onOpenDetail: onOpenDetail
                )
                .padding(.top, index == 0 ? 0 : VietnameseMenuLayout.sectionSpacing)
                .background {
                    GeometryReader { proxy in
                        Color.clear.preference(
                            key: VietnameseMenuSectionFramePreferenceKey.self,
                            value: [
                                VietnameseMenuSectionFrame(
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

    private func jumpToSection(_ sectionID: String) {
        guard sections.contains(where: { $0.id == sectionID }) else {
            return
        }

        sectionTracker.setCurrentSection(sectionID)
        pendingScrollSectionUpdate = nil
        isSettlingProgrammaticSectionJump = true
        sectionJumpSettleID += 1
        pendingSectionJumpSectionID = sectionID
        pendingSectionJumpID += 1
    }

    @MainActor
    private func performPendingSectionJump(_ scrollProxy: ScrollViewProxy) async {
        let requestID = pendingSectionJumpID
        guard requestID > 0, let pendingSectionJumpSectionID else {
            return
        }

        isResolvingSectionJump = true

        if VietnameseMenuSectionJumpPolicy.delayNanoseconds > 0 {
            try? await Task.sleep(nanoseconds: VietnameseMenuSectionJumpPolicy.delayNanoseconds)
            guard !Task.isCancelled else {
                isResolvingSectionJump = false
                return
            }
        }

        for _ in 0..<VietnameseMenuSectionJumpPolicy.layoutCorrectionPasses {
            scrollToSection(pendingSectionJumpSectionID, scrollProxy: scrollProxy)
            await Task.yield()

            guard
                !Task.isCancelled,
                pendingSectionJumpID == requestID,
                self.pendingSectionJumpSectionID == pendingSectionJumpSectionID
            else {
                isResolvingSectionJump = false
                return
            }
        }

        sectionTracker.setCurrentSection(pendingSectionJumpSectionID)
        self.pendingSectionJumpSectionID = nil
        isResolvingSectionJump = false
    }

    private func scrollToSection(_ sectionID: String, scrollProxy: ScrollViewProxy) {
        let viewportAnchor = UnitPoint(x: 0.5, y: VietnameseMenuLayout.sectionJumpViewportAnchorY)

        if VietnameseMenuSectionJumpPolicy.usesAnimatedScroll {
            withAnimation(.snappy(duration: 0.32)) {
                scrollProxy.scrollTo(Self.sectionAnchorID(for: sectionID), anchor: viewportAnchor)
            }
            return
        }

        var transaction = Transaction()
        transaction.animation = nil
        withTransaction(transaction) {
            scrollProxy.scrollTo(Self.sectionAnchorID(for: sectionID), anchor: viewportAnchor)
        }
    }

    private var photoBackdropImageName: String? {
        kind.photoBackdropImageName
    }

    private var activePhotoBackdropImageName: String {
        VietnameseMenuPhotoBackdropPolicy.imageName(
            photoBackdropImageName: photoBackdropImageName,
            fallbackHeroImageName: kind.heroImageName
        )
    }

    private var usesPhotoBackdropLayout: Bool {
        photoBackdropImageName != nil
    }

    @MainActor
    private func applyPhotoBackdropInitialPositionIfNeeded(_ scrollProxy: ScrollViewProxy) async {
        guard !didApplyPhotoBackdropInitialPosition else {
            return
        }

        try? await Task.sleep(nanoseconds: 80_000_000)
        guard !Task.isCancelled else {
            return
        }

        isPhotoBackdropImmersive = false
        scrollProxy.scrollTo(Self.photoBackdropInitialID, anchor: .top)
        didApplyPhotoBackdropInitialPosition = true
    }

    private func togglePhotoBackdropImmersive(at location: CGPoint, metrics: PhrasePhotoBackdropLayout.Metrics) {
        if isPhotoBackdropImmersive {
            withAnimation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation) {
                isPhotoBackdropImmersive = false
            }
            return
        }

        guard PhrasePhotoBackdropLayout.isImageTap(
            location,
            scrollOffset: photoBackdropScrollCoordinator.displayOffset,
            metrics: metrics
        ) else {
            return
        }

        withAnimation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation) {
            isPhotoBackdropImmersive = true
        }
    }

    static func railScrollID(for sectionID: String) -> String {
        "rail-\(sectionID)"
    }

    static func sectionAnchorID(for sectionID: String) -> String {
        "section-anchor-\(sectionID)"
    }

    private func updateCurrentSection(from frames: [VietnameseMenuSectionFrame]) {
        guard VietnameseMenuTaskPolicy.shouldApplySectionPreferenceTracking(isActive: isActive),
              !isResolvingSectionJump,
              !isSettlingProgrammaticSectionJump else {
            return
        }

        let nextPendingScrollSectionUpdate = sectionTracker.applySectionFrames(
            frames,
            activationY: VietnameseMenuLayout.sectionActivationY,
            defersPinnedUpdates: true
        )
        if pendingScrollSectionUpdate != nextPendingScrollSectionUpdate {
            pendingScrollSectionUpdate = nextPendingScrollSectionUpdate
        }
    }

    @MainActor
    private func clearProgrammaticSectionJumpSettleIfNeeded() async {
        guard VietnameseMenuTaskPolicy.shouldRunDeferredSectionTask(isActive: isActive),
              sectionJumpSettleID > 0,
              isSettlingProgrammaticSectionJump else {
            return
        }

        try? await Task.sleep(nanoseconds: VietnameseMenuSectionJumpPolicy.settleNanoseconds)
        guard !Task.isCancelled,
              VietnameseMenuTaskPolicy.shouldRunDeferredSectionTask(isActive: isActive) else {
            return
        }

        isSettlingProgrammaticSectionJump = false
    }

    @MainActor
    private func commitPendingScrollSectionUpdateIfNeeded() async {
        guard VietnameseMenuTaskPolicy.shouldRunDeferredSectionTask(isActive: isActive),
              let pendingScrollSectionUpdate else {
            return
        }

        try? await Task.sleep(nanoseconds: VietnameseMenuSectionTrackingPolicy.pinnedScrollUpdateDelayNanoseconds)
        guard !Task.isCancelled,
              VietnameseMenuTaskPolicy.shouldRunDeferredSectionTask(isActive: isActive),
              !isResolvingSectionJump else {
            return
        }

        sectionTracker.commitPendingSectionUpdate(pendingScrollSectionUpdate)

        if self.pendingScrollSectionUpdate == pendingScrollSectionUpdate {
            self.pendingScrollSectionUpdate = nil
        }
    }

    private func menuThumbnailImageName(for item: VietnameseMenuItem) -> String {
        item.menuImageName
    }
}

final class VietnameseMenuPhotoBackdropScrollCoordinator: ObservableObject {
    @Published private(set) var displayOffset: CGFloat = 0

    func apply(_ scrollState: PhrasePhotoBackdropLayout.ScrollState) -> Bool {
        if displayOffset != scrollState.displayOffset {
            displayOffset = scrollState.displayOffset
        }

        return scrollState.hasPassedRevealThreshold
    }

    func reset() {
        if displayOffset != 0 {
            displayOffset = 0
        }
    }
}

private struct VietnameseMenuPhotoBackdropBottomChromeBackdrop: View {
    @ObservedObject var scrollCoordinator: VietnameseMenuPhotoBackdropScrollCoordinator
    let viewportHeight: CGFloat
    let safeAreaBottom: CGFloat
    let collapsedContentTop: CGFloat
    let isPhotoBackdropImmersive: Bool

    var body: some View {
        let sheetTop = max(collapsedContentTop - scrollCoordinator.displayOffset, 0)
        let backingFrameHeight = PhrasePhotoBackdropLayout.bottomChromeBackingFrameHeight(
            viewportHeight: viewportHeight,
            safeAreaBottom: safeAreaBottom
        )
        let backdropHeight = PhrasePhotoBackdropLayout.bottomChromeBackingHeight(
            viewportHeight: viewportHeight,
            safeAreaBottom: safeAreaBottom,
            sheetTop: sheetTop
        )
        let topCornerRadius = PhrasePhotoBackdropLayout.bottomChromeBackingTopCornerRadius(sheetTop: sheetTop)

        VStack(spacing: 0) {
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
}

private struct VietnameseMenuSectionRail: View {
    let sections: [VietnameseMenuSection]
    @ObservedObject var sectionTracker: VietnameseMenuSectionTrackingCoordinator
    let onJump: (String) -> Void

    var body: some View {
        GeometryReader { proxy in
            let cardWidth = VietnameseMenuLayout.sectionCardWidth(containerWidth: proxy.size.width)

            ScrollViewReader { railProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: VietnameseMenuLayout.sectionCardSpacing) {
                        ForEach(sections) { section in
                            VietnameseMenuSectionImageCard(
                                accessibilityID: section.id,
                                title: section.title,
                                imageName: section.featuredImageName,
                                tintName: section.tintName,
                                isSelected: sectionTracker.currentSectionID == section.id,
                                action: { onJump(section.id) }
                            )
                            .frame(width: cardWidth)
                            .id(VietnameseMenuPageView.railScrollID(for: section.id))
                        }
                    }
                    .padding(.leading, VietnameseMenuLayout.horizontalPadding)
                    .padding(.trailing, VietnameseMenuLayout.horizontalPadding)
                    .padding(.bottom, PhrasePageStyle.cardShadowBleedPadding)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollClipDisabled()
                .onChange(of: sectionTracker.currentSectionID) { _, sectionID in
                    guard !sectionTracker.isSectionRailPinned else {
                        return
                    }

                    scrollRailDirectly(to: sectionID, railProxy: railProxy)
                }
                .onChange(of: sectionTracker.isSectionRailPinned) { _, isPinned in
                    guard !isPinned else {
                        return
                    }

                    scrollRailDirectly(to: sectionTracker.currentSectionID, railProxy: railProxy)
                }
            }
        }
        .frame(height: VietnameseMenuLayout.sectionCardHeight + PhrasePageStyle.cardShadowBleedPadding)
        .background {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: VietnameseMenuRailFramePreferenceKey.self,
                    value: proxy.frame(in: .global)
                )
            }
        }
    }

    private func scrollRailDirectly(to sectionID: String, railProxy: ScrollViewProxy) {
        var transaction = Transaction()
        transaction.animation = nil
        withTransaction(transaction) {
            railProxy.scrollTo(VietnameseMenuPageView.railScrollID(for: sectionID), anchor: .leading)
        }
    }
}

private struct VietnameseMenuSectionChromePreferenceEmitter: View {
    let route: BrowseCollectionRoute
    let isActive: Bool
    @ObservedObject var sectionTracker: VietnameseMenuSectionTrackingCoordinator
    let sections: [VietnameseMenuSectionChromeItem]

    var body: some View {
        Color.clear
            .preference(
                key: VietnameseMenuSectionChromePreferenceKey.self,
                value: preferenceValue
            )
            .accessibilityHidden(true)
    }

    private var preferenceValue: [VietnameseMenuSectionChromeState] {
        guard isActive, !sections.isEmpty else {
            return []
        }

        return [
            VietnameseMenuSectionChromeState(
                route: route,
                currentSectionID: sectionTracker.currentSectionID,
                isPinned: sectionTracker.isSectionRailPinned,
                sections: sections
            ),
        ]
    }
}

final class VietnameseMenuSectionTrackingCoordinator: ObservableObject {
    @Published private(set) var currentSectionID: String
    @Published private(set) var isSectionRailPinned = false
    private var pendingSectionID: String?
    private var pendingSectionRevision = 0

    init(initialSectionID: String) {
        currentSectionID = initialSectionID
    }

    func reset(to sectionID: String) {
        clearPendingSectionUpdate()
        setCurrentSection(sectionID)
        setSectionRailPinned(false)
    }

    func setCurrentSection(_ sectionID: String) {
        clearPendingSectionUpdate()
        guard currentSectionID != sectionID else {
            return
        }

        currentSectionID = sectionID
    }

    @discardableResult
    func applySectionFrames(
        _ frames: [VietnameseMenuSectionFrame],
        activationY: CGFloat,
        defersPinnedUpdates: Bool = false
    ) -> VietnameseMenuPendingSectionUpdate? {
        guard let selectedSectionID = Self.selectedSectionID(from: frames, activationY: activationY) else {
            return nil
        }

        if defersPinnedUpdates, isSectionRailPinned {
            return preparePendingSectionUpdate(selectedSectionID)
        }

        setCurrentSection(selectedSectionID)
        return nil
    }

    func applyRailFrame(_ frame: CGRect?, revealY: CGFloat) {
        let isPinned = (frame?.maxY ?? .greatestFiniteMagnitude) <= revealY
        if !isPinned {
            clearPendingSectionUpdate()
        }
        setSectionRailPinned(isPinned)
    }

    func commitPendingSectionUpdate(_ update: VietnameseMenuPendingSectionUpdate) {
        guard pendingSectionID == update.sectionID, pendingSectionRevision == update.revision else {
            return
        }

        setCurrentSection(update.sectionID)
    }

    private func setSectionRailPinned(_ isPinned: Bool) {
        guard isSectionRailPinned != isPinned else {
            return
        }

        isSectionRailPinned = isPinned
    }

    private func preparePendingSectionUpdate(_ sectionID: String) -> VietnameseMenuPendingSectionUpdate? {
        guard currentSectionID != sectionID else {
            clearPendingSectionUpdate()
            return nil
        }

        if pendingSectionID != sectionID {
            pendingSectionID = sectionID
            pendingSectionRevision += 1
        }

        return VietnameseMenuPendingSectionUpdate(
            sectionID: sectionID,
            revision: pendingSectionRevision
        )
    }

    private func clearPendingSectionUpdate() {
        pendingSectionID = nil
    }

    private static func selectedSectionID(
        from frames: [VietnameseMenuSectionFrame],
        activationY: CGFloat
    ) -> String? {
        guard !frames.isEmpty else {
            return nil
        }

        let sortedFrames = frames.sorted { lhs, rhs in
            if lhs.order == rhs.order {
                return lhs.minY < rhs.minY
            }

            return lhs.order < rhs.order
        }
        let activeFrames = sortedFrames.filter { $0.minY <= activationY }
        let selectedFrame = activeFrames.max { $0.minY < $1.minY } ?? sortedFrames.first

        return selectedFrame?.id
    }
}

struct VietnameseMenuPendingSectionUpdate: Equatable {
    let sectionID: String
    let revision: Int
}

enum VietnameseMenuSectionJumpPolicy {
    static let delayNanoseconds: UInt64 = 0
    static let usesAnimatedScroll = false
    static let layoutCorrectionPasses = 3
    static let settleNanoseconds: UInt64 = 900_000_000
}

enum VietnameseMenuSectionTrackingPolicy {
    static let pinnedScrollUpdateDelayNanoseconds: UInt64 = 120_000_000
}

enum VietnameseMenuTaskPolicy {
    static func shouldRunDeferredSectionTask(isActive: Bool) -> Bool {
        isActive
    }

    static func shouldRunStandardScrollTask(isActive: Bool) -> Bool {
        isActive
    }

    static func shouldApplyPhotoBackdropScrollGeometry(isActive: Bool) -> Bool {
        isActive
    }

    static func shouldApplySectionPreferenceTracking(isActive: Bool) -> Bool {
        isActive
    }
}

enum VietnameseMenuLayout {
    static let horizontalPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 20
    static let sectionTitleToRowsSpacing: CGFloat = 26
    static let heroHeight: CGFloat = 240
    static let bottomChromeContentClearance: CGFloat = 132
    static let sectionCardSpacing: CGFloat = 12
    static let sectionCardHeight: CGFloat = 166
    static let sectionImageHeight: CGFloat = 108
    static let sectionActivationY: CGFloat = AppChromeLayout.menuSectionJumpClearance + 32
    static let sectionJumpViewportAnchorY: CGFloat = AppChromeLayout.menuSectionJumpViewportAnchorY
    static let glassRailRevealY: CGFloat = 72

    static func bottomContentClearance(usesPhotoBackdrop: Bool) -> CGFloat {
        AppBottomContentClearance.rootSurface(
            usesPhotoBackdrop: usesPhotoBackdrop,
            standard: bottomChromeContentClearance
        )
    }

    static func sectionCardWidth(containerWidth: CGFloat) -> CGFloat {
        max(154, (containerWidth - horizontalPadding * 2 - sectionCardSpacing) / 2)
    }
}

private struct VietnameseMenuSectionImageCard: View {
    let accessibilityID: String
    let title: String
    let imageName: String
    let tintName: AccentTint
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: VietnameseMenuLayout.sectionImageHeight)
                    .frame(maxWidth: .infinity)
                    .clipped()

                Text(title)
                    .font(.headline.weight(.black))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                    .padding(.horizontal, 14)
                    .frame(maxWidth: .infinity, minHeight: 58, alignment: .leading)
                    .background(PhrasePageStyle.imageCaptionFill)
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .background(PhrasePageStyle.elevatedCardFill, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(isSelected ? tintName.color.opacity(0.50) : .white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: isSelected ? 1.5 : 1)
                    .allowsHitTesting(false)
            }
            .softAmbientCardShadow()
            .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("VietnameseMenu.SectionRail.\(accessibilityID)")
    }
}

private struct VietnameseMenuSectionBlock: View {
    let section: VietnameseMenuSection
    let heroImageName: (VietnameseMenuItem) -> String
    let isSaved: (String) -> Bool
    let onToggleSaved: (String) -> Void
    let onOpenDetail: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: VietnameseMenuLayout.sectionTitleToRowsSpacing) {
            VStack(alignment: .leading, spacing: 5) {
                Text(section.title)
                    .font(.title2.weight(.black))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("VietnameseMenu.SectionTitle.\(section.id)")

                if !section.subtitle.isEmpty {
                    Text(section.subtitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            VStack(spacing: 0) {
                ForEach(section.items) { item in
                    VietnameseMenuItemRow(
                        item: item,
                        heroImageName: heroImageName(item),
                        isSaved: isSaved(item.detailPageID),
                        onOpenDetail: { onOpenDetail(item.detailPageID) },
                        onToggleSaved: { onToggleSaved(item.detailPageID) }
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

private struct VietnameseMenuItemRow: View {
    let item: VietnameseMenuItem
    let heroImageName: String
    let isSaved: Bool
    let onOpenDetail: () -> Void
    let onToggleSaved: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onOpenDetail) {
                HStack(spacing: 14) {
                    Image(heroImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 62, height: 62)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                        }
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.vietnameseItem)
                            .font(.headline.weight(.black))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.74)

                        Text(item.englishTranslation)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .layoutPriority(1)
                }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .accessibilityIdentifier("VietnameseMenu.Row.\(item.itemID)")

            if let audioKey = AudioAssetManifest.main?.audioKey(forExactText: item.vietnameseItem) {
                AudioSpeakerButton(
                    tint: item.kind?.tintName ?? .orange,
                    size: 44,
                    audioKey: audioKey,
                    accessibilityIdentifier: "VietnameseMenu.Audio.\(item.detailPageID)"
                )
                .zIndex(1)
            } else {
                Image(systemName: "chevron.right")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.secondary.opacity(0.8))
                    .frame(width: 36, height: 36)
                    .nativeGlass(cornerRadius: 18, interactive: false)
                    .zIndex(1)
            }

            Button(action: onToggleSaved) {
                Image(systemName: isSaved ? "heart.fill" : "heart")
                    .font(.headline.weight(.black))
                    .foregroundStyle(.red)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.001), in: Circle())
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .frame(width: 44, height: 44)
            .contentShape(Circle())
            .accessibilityLabel(isSaved ? "Remove from Saved" : "Save to My Trip")
            .accessibilityIdentifier("VietnameseMenu.Save.\(item.detailPageID)")
            .zIndex(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}

struct VietnameseMenuSectionJumpRequest: Equatable {
    let requestID: Int
    let route: BrowseCollectionRoute
    let sectionID: String
}

struct VietnameseMenuSectionChromeItem: Identifiable, Equatable {
    let id: String
    let title: String
    let symbolName: String
    let tintName: AccentTint
}

struct VietnameseMenuSectionChromeState: Equatable {
    let route: BrowseCollectionRoute
    let currentSectionID: String
    let isPinned: Bool
    let sections: [VietnameseMenuSectionChromeItem]
}

struct VietnameseMenuSectionChromePreferenceKey: PreferenceKey {
    static var defaultValue: [VietnameseMenuSectionChromeState] = []

    static func reduce(value: inout [VietnameseMenuSectionChromeState], nextValue: () -> [VietnameseMenuSectionChromeState]) {
        value.append(contentsOf: nextValue())
    }
}

final class VietnameseMenuSectionChromeCoordinator: ObservableObject {
    @Published private(set) var currentState: VietnameseMenuSectionChromeState?

    @discardableResult
    func apply(_ states: [VietnameseMenuSectionChromeState]) -> Bool {
        let nextState = states.last
        let didPinnedStateChange = (currentState?.isPinned == true) != (nextState?.isPinned == true)

        guard currentState != nextState else {
            return false
        }

        currentState = nextState
        return didPinnedStateChange
    }
}

struct VietnameseMenuSectionFrame: Equatable {
    let id: String
    let order: Int
    let minY: CGFloat
}

private struct VietnameseMenuSectionFramePreferenceKey: PreferenceKey {
    static var defaultValue: [VietnameseMenuSectionFrame] = []

    static func reduce(value: inout [VietnameseMenuSectionFrame], nextValue: () -> [VietnameseMenuSectionFrame]) {
        value.append(contentsOf: nextValue())
    }
}

private struct VietnameseMenuRailFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect?

    static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
        value = nextValue() ?? value
    }
}
