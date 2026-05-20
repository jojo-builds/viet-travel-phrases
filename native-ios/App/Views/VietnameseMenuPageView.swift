import SwiftUI

struct VietnameseMenuPageView: View {
    let kind: VietnameseMenuKind
    let scrollToTopTrigger: Int
    let scrollToTopRoute: BrowseCollectionRoute?
    let sectionJumpRequest: VietnameseMenuSectionJumpRequest?
    var isSaved: (String) -> Bool
    var onToggleSaved: (String) -> Void
    var onOpenDetail: (String) -> Void
    var isActive: Bool = true

    @State private var currentSectionID: String?
    @State private var isSectionRailPinned = false
    @State private var pendingSectionJumpID = 0
    @State private var pendingSectionJumpSectionID: String?
    @State private var didApplyPhotoBackdropInitialPosition = false
    @State private var isPhotoBackdropImmersive = false
    @State private var photoBackdropScrollOffset: CGFloat = 0

    private var route: BrowseCollectionRoute {
        .category(kind.routeID)
    }

    private var sections: [VietnameseMenuSection] {
        VietnameseMenuCatalog.sections(for: kind)
    }

    private var resolvedCurrentSectionID: String {
        currentSectionID ?? sections.first?.id ?? "popular"
    }

    private var sectionChromeState: VietnameseMenuSectionChromeState? {
        guard !sections.isEmpty else {
            return nil
        }

        return VietnameseMenuSectionChromeState(
            route: route,
            currentSectionID: resolvedCurrentSectionID,
            isPinned: isSectionRailPinned,
            sections: sections.map { section in
                VietnameseMenuSectionChromeItem(
                    id: section.id,
                    title: section.title,
                    symbolName: section.symbolName,
                    tintName: section.tintName
                )
            }
        )
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
            currentSectionID = nil
            isSectionRailPinned = false
            pendingSectionJumpSectionID = nil
            didApplyPhotoBackdropInitialPosition = false
            isPhotoBackdropImmersive = false
            photoBackdropScrollOffset = 0
        }
        .preference(
            key: VietnameseMenuSectionChromePreferenceKey.self,
            value: isActive ? sectionChromeState.map { [$0] } ?? [] : []
        )
        .preference(
            key: PhrasePhotoBackdropImmersiveChromePreferenceKey.self,
            value: isActive && usesPhotoBackdropLayout && isPhotoBackdropImmersive
        )
        .preference(
            key: PhrasePhotoBackdropTabBarBackgroundPreferenceKey.self,
            value: isActive && usesPhotoBackdropLayout && !isPhotoBackdropImmersive
        )
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
                    }
                    .padding(.bottom, VietnameseMenuLayout.bottomChromeContentClearance)
                }
                .onPreferenceChange(VietnameseMenuSectionFramePreferenceKey.self) { frames in
                    updateCurrentSection(from: frames)
                }
                .onPreferenceChange(VietnameseMenuRailFramePreferenceKey.self) { frame in
                    isSectionRailPinned = (frame?.maxY ?? .greatestFiniteMagnitude) <= VietnameseMenuLayout.glassRailRevealY
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
                .task(id: pendingSectionJumpID) {
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

                photoBackdropBottomChromeBackdrop(geometry: geometry, metrics: metrics)

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
                        if photoBackdropScrollOffset != scrollState.displayOffset {
                            photoBackdropScrollOffset = scrollState.displayOffset
                        }

                        if isPhotoBackdropImmersive, scrollState.hasPassedRevealThreshold {
                            withAnimation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation) {
                                isPhotoBackdropImmersive = false
                            }
                        }
                    }
                    .onPreferenceChange(VietnameseMenuSectionFramePreferenceKey.self) { frames in
                        updateCurrentSection(from: frames)
                    }
                    .onPreferenceChange(VietnameseMenuRailFramePreferenceKey.self) { frame in
                        isSectionRailPinned = (frame?.maxY ?? .greatestFiniteMagnitude) <= VietnameseMenuLayout.glassRailRevealY
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
                        imageName: photoBackdropImageName ?? kind.heroImageName,
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
                .padding(.bottom, PhrasePhotoBackdropLayout.bottomReadingClearance)
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
        .accessibilityIdentifier("VietnameseMenu.PhotoBackdrop.Content.\(kind.routeID)")
    }

    private func photoBackdropImage(geometry: GeometryProxy) -> some View {
        Image(photoBackdropImageName ?? kind.heroImageName)
            .resizable()
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

    private func photoBackdropBottomChromeBackdrop(
        geometry: GeometryProxy,
        metrics: PhrasePhotoBackdropLayout.Metrics
    ) -> some View {
        let safeAreaBottom = geometry.safeAreaInsets.bottom
        let sheetTop = max(metrics.collapsedContentTop - photoBackdropScrollOffset, 0)
        let backdropHeight = max(geometry.size.height + safeAreaBottom - sheetTop, 0)
        let topCornerRadius: CGFloat = sheetTop > 1 ? 34 : 0

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
            height: geometry.size.height + safeAreaBottom,
            alignment: .top
        )
        .ignoresSafeArea(edges: .bottom)
        .opacity(isPhotoBackdropImmersive ? 0 : 1)
        .animation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation, value: isPhotoBackdropImmersive)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func sectionRail(scrollProxy: ScrollViewProxy) -> some View {
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
                                isSelected: resolvedCurrentSectionID == section.id,
                                action: { jumpToSection(section.id) }
                            )
                            .frame(width: cardWidth)
                            .id(Self.railScrollID(for: section.id))
                        }
                    }
                    .padding(.leading, VietnameseMenuLayout.horizontalPadding)
                    .padding(.trailing, VietnameseMenuLayout.horizontalPadding)
                    .padding(.bottom, PhrasePageStyle.cardShadowBleedPadding)
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

        currentSectionID = sectionID
        pendingSectionJumpSectionID = sectionID
        pendingSectionJumpID += 1
    }

    @MainActor
    private func performPendingSectionJump(_ scrollProxy: ScrollViewProxy) async {
        guard pendingSectionJumpID > 0, let pendingSectionJumpSectionID else {
            return
        }

        try? await Task.sleep(nanoseconds: VietnameseMenuLayout.sectionJumpDelayNanoseconds)
        guard !Task.isCancelled else {
            return
        }

        withAnimation(.snappy(duration: 0.32)) {
            scrollProxy.scrollTo(
                Self.sectionAnchorID(for: pendingSectionJumpSectionID),
                anchor: UnitPoint(x: 0.5, y: VietnameseMenuLayout.sectionJumpViewportAnchorY)
            )
        }
    }

    private var photoBackdropImageName: String? {
        kind.photoBackdropImageName
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
            scrollOffset: photoBackdropScrollOffset,
            metrics: metrics
        ) else {
            return
        }

        withAnimation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation) {
            isPhotoBackdropImmersive = true
        }
    }

    private static func railScrollID(for sectionID: String) -> String {
        "rail-\(sectionID)"
    }

    private static func sectionAnchorID(for sectionID: String) -> String {
        "section-anchor-\(sectionID)"
    }

    private func updateCurrentSection(from frames: [VietnameseMenuSectionFrame]) {
        guard !frames.isEmpty else {
            return
        }

        let sortedFrames = frames.sorted { lhs, rhs in
            if lhs.order == rhs.order {
                return lhs.minY < rhs.minY
            }

            return lhs.order < rhs.order
        }
        let activeFrames = sortedFrames.filter { $0.minY <= VietnameseMenuLayout.sectionActivationY }
        let selectedFrame = activeFrames.max { $0.minY < $1.minY } ?? sortedFrames.first

        if currentSectionID != selectedFrame?.id {
            currentSectionID = selectedFrame?.id
        }
    }

    private func menuThumbnailImageName(for item: VietnameseMenuItem) -> String {
        item.menuImageName
    }
}

private enum VietnameseMenuLayout {
    static let horizontalPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 20
    static let sectionTitleToRowsSpacing: CGFloat = 26
    static let heroHeight: CGFloat = 240
    static let bottomChromeContentClearance: CGFloat = 132
    static let sectionCardSpacing: CGFloat = 12
    static let sectionCardHeight: CGFloat = 166
    static let sectionImageHeight: CGFloat = 108
    static let sectionActivationY: CGFloat = AppChromeLayout.menuSectionJumpClearance + 32
    static let sectionJumpViewportAnchorY: CGFloat = 0.19
    static let sectionJumpDelayNanoseconds: UInt64 = 80_000_000
    static let glassRailRevealY: CGFloat = 72

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

private struct VietnameseMenuSectionFrame: Equatable {
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
