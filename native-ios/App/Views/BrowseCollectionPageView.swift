import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum BrowseCollectionPhotoBackdropPolicy {
    static func usesPhotoBackdrop(
        hasCityHub: Bool,
        mastheadImageName: String
    ) -> Bool {
        hasCityHub || mastheadImageName.hasPrefix("HeroCategory")
    }

    static func preheatImageNames(
        hasCityHub: Bool,
        mastheadImageName: String
    ) -> [String] {
        guard usesPhotoBackdrop(hasCityHub: hasCityHub, mastheadImageName: mastheadImageName) else {
            return []
        }

        return [mastheadImageName]
    }
}

struct BrowseCollectionPageView: View {
    let descriptor: BrowseCollectionDescriptor
    let scrollToTopTrigger: Int
    let scrollToTopRoute: BrowseCollectionRoute?
    let focusRequest: BrowseCollectionFocusRequest?
    var isActive: Bool = true
    var isSaved: (String) -> Bool = { _ in false }
    var onToggleSaved: (String) -> Void = { _ in }
    var onOpenDetail: (String) -> Void
    var onOpenCollection: (BrowseCollectionRoute) -> Void
    var onPractice: (BrowseCollectionPracticeAction) -> Void

    @State private var selectedSubcategoryID: String?
    @State private var selectedCityCardID: String?
    @State private var didApplyPhotoBackdropInitialPosition = false
    @State private var isPhotoBackdropImmersive = false
    @State private var photoBackdropScrollOffset: CGFloat = 0

    private var bottomSentinelID: String {
        "BrowseCollection.BottomSentinel.\(descriptor.route.id)"
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
        .onChange(of: descriptor.id) { _, _ in
            selectedSubcategoryID = nil
            selectedCityCardID = nil
            didApplyPhotoBackdropInitialPosition = false
            isPhotoBackdropImmersive = false
            photoBackdropScrollOffset = 0
        }
        .preference(
            key: PhrasePhotoBackdropImmersiveChromePreferenceKey.self,
            value: isActive && usesPhotoBackdropLayout && isPhotoBackdropImmersive
        )
        .preference(
            key: PhrasePhotoBackdropTabBarBackgroundPreferenceKey.self,
            value: isActive && usesPhotoBackdropLayout && !isPhotoBackdropImmersive
        )
        .accessibilityIdentifier("BrowseCollection.\(descriptor.route.id)")
    }

    private var standardBody: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: BrowseCollectionLayout.sectionSpacing) {
                        BrowseCollectionHeader(descriptor: descriptor)
                            .id(Self.scrollTopID)

                        collectionSections(scrollProxy: scrollProxy)

                        AppBottomSentinel(id: bottomSentinelID)
                    }
                    .padding(.bottom, BrowseCollectionLayout.bottomContentClearance(usesPhotoBackdrop: false))
                }
                .onChange(of: scrollToTopTrigger) { _, _ in
                    guard scrollToTopRoute == nil || scrollToTopRoute == descriptor.route else {
                        return
                    }

                    scrollProxy.scrollTo(Self.scrollTopID, anchor: .top)
                }
                .task(id: focusRequest?.id) {
                    if AppBottomInsetValidation.shouldScrollToBottom {
                        await AppBottomInsetValidation.scrollToBottom(scrollProxy, sentinelID: bottomSentinelID)
                        return
                    }

                    await restoreFocusIfNeeded(scrollProxy)
                }
            }
            .ignoresSafeArea(edges: .top)
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
                    .onChange(of: scrollToTopTrigger) { _, _ in
                        guard scrollToTopRoute == nil || scrollToTopRoute == descriptor.route else {
                            return
                        }

                        isPhotoBackdropImmersive = false
                        scrollProxy.scrollTo(Self.photoBackdropInitialID, anchor: .top)
                    }
                    .task(id: "\(isActive)-\(focusRequest.map { String($0.id) } ?? "none")") {
                        guard isActive else {
                            return
                        }

                        if focusRequest == nil {
                            await applyPhotoBackdropInitialPositionIfNeeded(scrollProxy)
                        } else {
                            await restoreFocusIfNeeded(scrollProxy)
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
                        pageID: descriptor.route.id,
                        imageName: descriptor.mastheadImageName,
                        viewportSize: geometry.size,
                        safeAreaTop: geometry.safeAreaInsets.top,
                        safeAreaBottom: geometry.safeAreaInsets.bottom,
                        imageFrameHeight: PhrasePhotoBackdropLayout.backdropFrameHeight(
                            for: geometry.size,
                            safeAreaInsets: geometry.safeAreaInsets,
                            pageID: descriptor.route.id,
                            heroImageName: descriptor.mastheadImageName
                        ),
                        verticalFocusOffset: PhrasePhotoBackdropLayout.backdropVerticalFocusOffset(
                            for: geometry.size,
                            pageID: descriptor.route.id,
                            heroImageName: descriptor.mastheadImageName
                        )
                    )
                    : nil
            )
        }
        .ignoresSafeArea(edges: .bottom)
        .statusBarHidden(isActive && isPhotoBackdropImmersive)
        .persistentSystemOverlays(isActive && isPhotoBackdropImmersive ? .hidden : .automatic)
        .task(id: isActive ? descriptor.mastheadImageName : "") {
            guard isActive else {
                return
            }

            AdminBackdropImagePreheater.preheat(
                BrowseCollectionPhotoBackdropPolicy.preheatImageNames(
                    hasCityHub: descriptor.cityHub != nil,
                    mastheadImageName: descriptor.mastheadImageName
                )
            )
        }
    }

    @ViewBuilder
    private func collectionSections(scrollProxy: ScrollViewProxy) -> some View {
        if let cityHub = descriptor.cityHub {
            BrowseCityHubContent(
                descriptor: descriptor,
                cityHub: cityHub,
                selectedCityCardID: selectedCityCardID,
                onOpenDetail: onOpenDetail,
                onOpenCollection: onOpenCollection,
                isSaved: isSaved,
                onToggleSaved: onToggleSaved,
                onSelectCityCard: { filter in
                    selectCityBrowseGroup(filter, scrollProxy: scrollProxy)
                },
                onPractice: { onPractice(descriptor.practiceAction) }
            )
        } else {
            BrowseCollectionSubcategoryRail(
                subcategories: descriptor.subcategories,
                selectedSubcategoryID: selectedSubcategoryID,
                fallbackImageName: descriptor.mastheadImageName,
                onSelect: { subcategory in
                    selectCategorySubcategory(subcategory, scrollProxy: scrollProxy)
                }
            )

            if !BrowseCollectionLayoutPolicy.hasMessageSection(descriptor), !prefersNounRowsBeforePracticeEntry, !descriptor.subcategories.isEmpty {
                BrowseCollectionMessageEntryCard(
                    descriptor: descriptor,
                    onPractice: { onPractice(descriptor.practiceAction) }
                )
                .id(BrowseCollectionFocusRequest.practiceEntryScrollTargetID)
                .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)
            }

            if descriptor.subcategories.isEmpty {
                BrowseCollectionStarterSection(
                    title: descriptor.starterTitle,
                    items: descriptor.starterItems,
                    onOpenDetail: onOpenDetail
                )
                .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)

                if !BrowseCollectionLayoutPolicy.hasMessageSection(descriptor) {
                    BrowseCollectionMessageEntryCard(
                        descriptor: descriptor,
                        onPractice: { onPractice(descriptor.practiceAction) }
                    )
                    .id(BrowseCollectionFocusRequest.practiceEntryScrollTargetID)
                    .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)
                }
            } else {
                BrowseCollectionSubcategorySections(
                    subcategories: descriptor.subcategories,
                    onOpenDetail: onOpenDetail,
                    afterFirstSection: {
                        if !BrowseCollectionLayoutPolicy.hasMessageSection(descriptor), prefersNounRowsBeforePracticeEntry {
                            BrowseCollectionMessageEntryCard(
                                descriptor: descriptor,
                                onPractice: { onPractice(descriptor.practiceAction) }
                            )
                            .id(BrowseCollectionFocusRequest.practiceEntryScrollTargetID)
                        }
                    }
                )
                .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)
            }

            if BrowseCollectionLayoutPolicy.hasMessageSection(descriptor) {
                BrowseCollectionMessageSection(
                    descriptor: descriptor,
                    onStartScenario: { scenarioID in
                        onPractice(.practiceScenario(scenarioID))
                    }
                )
                .id(BrowseCollectionFocusRequest.messageSectionScrollTargetID)
                .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)
            }

            BrowseCollectionExploreSection(
                shelves: descriptor.exploreShelves,
                onOpenDetail: onOpenDetail,
                onOpenCollection: onOpenCollection
            )
        }
    }

    private var prefersNounRowsBeforePracticeEntry: Bool {
        descriptor.route == .category("food")
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

            BrowseCollectionHeaderCopy(
                descriptor: descriptor
            )
            .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)
            .padding(.bottom, 18)

            VStack(alignment: .leading, spacing: BrowseCollectionLayout.sectionSpacing) {
                collectionSections(scrollProxy: scrollProxy)

                AppBottomSentinel(id: bottomSentinelID)
            }
            .padding(.bottom, BrowseCollectionLayout.bottomContentClearance(usesPhotoBackdrop: true))
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
    }

    private func photoBackdropImage(geometry: GeometryProxy) -> some View {
        AdminBackdropPreparedImage(name: descriptor.mastheadImageName)
            .scaledToFill()
            .frame(
                width: geometry.size.width,
                height: geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom + 160,
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

    private static let scrollTopID = "BrowseCollectionTop"
    private static let photoBackdropInitialID = "BrowseCollectionPhotoBackdropInitial"

    private var usesPhotoBackdropLayout: Bool {
        BrowseCollectionPhotoBackdropPolicy.usesPhotoBackdrop(
            hasCityHub: descriptor.cityHub != nil,
            mastheadImageName: descriptor.mastheadImageName
        )
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

    private func selectCityBrowseGroup(_ filter: BrowseCollectionSubcategory, scrollProxy: ScrollViewProxy) {
        guard !filter.items.isEmpty else {
            return
        }

        selectedCityCardID = filter.id
        withAnimation(.snappy(duration: 0.28)) {
            scrollProxy.scrollTo(
                BrowseCityBrowseScrollID.group(filter.id),
                anchor: UnitPoint(x: 0.5, y: BrowseCollectionLayout.sectionJumpViewportAnchorY)
            )
        }
    }

    private func selectCategorySubcategory(_ subcategory: BrowseCollectionSubcategory, scrollProxy: ScrollViewProxy) {
        guard !subcategory.items.isEmpty else {
            return
        }

        selectedSubcategoryID = subcategory.id
        withAnimation(.snappy(duration: 0.28)) {
            scrollProxy.scrollTo(
                BrowseCategorySubcategoryScrollID.group(subcategory.id),
                anchor: UnitPoint(x: 0.5, y: BrowseCollectionLayout.sectionJumpViewportAnchorY)
            )
        }
    }

    @MainActor
    private func restoreFocusIfNeeded(_ scrollProxy: ScrollViewProxy) async {
        guard
            let focusRequest,
            focusRequest.route == descriptor.route
        else {
            return
        }

        isPhotoBackdropImmersive = false

        try? await Task.sleep(nanoseconds: BrowseCollectionLayout.focusRestoreDelayNanoseconds)
        guard !Task.isCancelled else {
            return
        }

        restoreFocus(scrollProxy, target: focusRequest.target)
        try? await Task.sleep(nanoseconds: BrowseCollectionLayout.focusRestoreRetryDelayNanoseconds)
        guard !Task.isCancelled, self.focusRequest == focusRequest else {
            return
        }
        restoreFocus(scrollProxy, target: focusRequest.target)
    }

    @MainActor
    private func restoreFocus(_ scrollProxy: ScrollViewProxy, target: BrowseCollectionFocusRequest.Target) {
        withAnimation(.snappy(duration: BrowseCollectionLayout.focusRestoreAnimationDuration)) {
            scrollProxy.scrollTo(target.scrollTargetID, anchor: .center)
        }
    }
}

enum BrowseCollectionLayout {
    static let horizontalPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = HomeLayout.sectionSpacing
    static let bottomChromeContentClearance: CGFloat = 128
    static let focusRestoreDelayNanoseconds: UInt64 = 520_000_000
    static let focusRestoreRetryDelayNanoseconds: UInt64 = 420_000_000
    static let focusRestoreAnimationDuration: TimeInterval = 0.24
    static let cityFilterCardSpacing: CGFloat = 12
    static let cityFilterCardPeekWidth: CGFloat = 42
    static let cityFilterCardHeight: CGFloat = 166
    static let cityFilterImageHeight: CGFloat = 108
    static let cityNounThumbnailSize: CGFloat = 62
    static let subcategoryCardWidth: CGFloat = 136
    static let subcategoryCardHeight: CGFloat = 124
    static let sectionJumpViewportAnchorY: CGFloat = AppChromeLayout.menuSectionJumpViewportAnchorY

    static func bottomContentClearance(usesPhotoBackdrop: Bool) -> CGFloat {
        AppBottomContentClearance.rootSurface(
            usesPhotoBackdrop: usesPhotoBackdrop,
            standard: bottomChromeContentClearance
        )
    }

    static func cityFilterCardWidth(availableWidth: CGFloat) -> CGFloat {
        let visiblePeekWidth = min(cityFilterCardPeekWidth, max(28, availableWidth * 0.11))
        let twoCardsWithPeek = (availableWidth - cityFilterCardSpacing * 2 - visiblePeekWidth) / 2
        return max(118, min(178, twoCardsWithPeek))
    }
}

private enum BrowseCategorySubcategoryScrollID {
    static func group(_ id: String) -> String {
        "BrowseCategorySubcategoryGroup.\(id)"
    }
}

private extension BrowseSearchPhraseItem {
    var resolvedImageName: String? {
        BrowseImageAssetPolicy.resolvedImageName(imageName, exists: BrowseImageAssetCache.exists)
    }
}

enum BrowseImageAssetPolicy {
    static func resolvedImageName(_ imageName: String?, exists: (String) -> Bool) -> String? {
        guard let imageName else {
            return nil
        }

        if trustsBundledGeneratedAssetName(imageName) {
            return imageName
        }

        return exists(imageName) ? imageName : nil
    }

    private static func trustsBundledGeneratedAssetName(_ imageName: String) -> Bool {
        trustedGeneratedAssetPrefixes.contains { imageName.hasPrefix($0) }
            || trustedGeneratedAssetNames.contains(imageName)
    }

    private static let trustedGeneratedAssetPrefixes = [
        "HeroCategory",
        "HeroCity",
        "HeroMenu",
        "HeroVietnam",
        "BackdropMenu",
        "BackdropPhrase",
        "BackdropVietnamese",
    ]

    private static let trustedGeneratedAssetNames: Set<String> = [
        "HeroCompactPhraseMasthead",
        "HeroXinChao",
    ]
}

private enum BrowseImageAssetCache {
    #if canImport(UIKit)
    private static let lock = NSLock()
    private static var existenceByName: [String: Bool] = [:]
    private static var sizeByName: [String: CGSize] = [:]

    static func exists(_ imageName: String) -> Bool {
        lock.lock()
        if let cached = existenceByName[imageName] {
            lock.unlock()
            return cached
        }
        lock.unlock()

        let image = UIImage(named: imageName)
        lock.lock()
        existenceByName[imageName] = image != nil
        if let image {
            sizeByName[imageName] = image.size
        }
        lock.unlock()
        return image != nil
    }

    static func size(for imageName: String) -> CGSize? {
        lock.lock()
        if let cached = sizeByName[imageName] {
            lock.unlock()
            return cached
        }
        lock.unlock()

        guard let image = UIImage(named: imageName) else {
            lock.lock()
            existenceByName[imageName] = false
            lock.unlock()
            return nil
        }

        lock.lock()
        existenceByName[imageName] = true
        sizeByName[imageName] = image.size
        lock.unlock()
        return image.size
    }
    #else
    static func exists(_ imageName: String) -> Bool { true }
    static func size(for imageName: String) -> CGSize? { nil }
    #endif
}

private struct BrowseCollectionHeader: View {
    let descriptor: BrowseCollectionDescriptor

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeroMastheadImage(imageName: descriptor.mastheadImageName)

            BrowseCollectionHeaderCopy(descriptor: descriptor)
            .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)
            .padding(.top, 16)
        }
    }
}

private struct BrowseCollectionHeaderCopy: View {
    let descriptor: BrowseCollectionDescriptor

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                ZStack {
                    Circle().fill(Color.red)
                    Image(systemName: "star.fill")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(.yellow)
                }
                .frame(width: 22, height: 22)

                Text(descriptor.eyebrow)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Text(descriptor.title)
                .font(.system(size: 46, weight: .black, design: .serif))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.64)
                .accessibilityIdentifier("BrowseCollection.Title.\(descriptor.route.id)")

            Text(descriptor.subtitle)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct BrowseCollectionSubcategoryRail: View {
    let subcategories: [BrowseCollectionSubcategory]
    let selectedSubcategoryID: String?
    let fallbackImageName: String?
    let onSelect: (BrowseCollectionSubcategory) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(subcategories) { subcategory in
                    BrowseCollectionSubcategoryCard(
                        subcategory: subcategory,
                        isSelected: subcategory.id == selectedSubcategoryID,
                        fallbackImageName: fallbackImageName,
                        onSelect: { onSelect(subcategory) }
                    )
                }
            }
            .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)
            .padding(.bottom, 2)
        }
        .scrollClipDisabled()
        .frame(height: BrowseCollectionLayout.subcategoryCardHeight + 6)
    }
}

private struct BrowseCollectionSubcategorySections<AfterFirstSection: View>: View {
    let subcategories: [BrowseCollectionSubcategory]
    let onOpenDetail: (String) -> Void
    @ViewBuilder let afterFirstSection: () -> AfterFirstSection

    var body: some View {
        VStack(alignment: .leading, spacing: BrowseCollectionLayout.sectionSpacing) {
            ForEach(Array(subcategories.enumerated()), id: \.element.id) { index, subcategory in
                VStack(alignment: .leading, spacing: 0) {
                    Color.clear
                        .frame(width: 1, height: 1)
                        .id(BrowseCategorySubcategoryScrollID.group(subcategory.id))
                        .accessibilityHidden(true)

                    BrowseCollectionStarterSection(
                        title: sectionTitle(for: subcategory),
                        items: subcategory.items,
                        onOpenDetail: onOpenDetail
                    )
                }

                if index == 0 {
                    afterFirstSection()
                }
            }
        }
    }

    private func sectionTitle(for subcategory: BrowseCollectionSubcategory) -> String {
        subcategory.countUnit == "item" ? subcategory.title : "\(subcategory.title) phrases"
    }
}

private struct BrowseCollectionSubcategoryCard: View {
    let subcategory: BrowseCollectionSubcategory
    let isSelected: Bool
    let fallbackImageName: String?
    let onSelect: () -> Void

    private var imageName: String? {
        subcategory.imageName
            ?? subcategory.items.lazy.compactMap(\.resolvedImageName).first
            ?? fallbackImageName
    }

    var body: some View {
        Button(action: onSelect) {
            ZStack(alignment: .bottomLeading) {
                cardImage

                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.12),
                        .init(color: Color.black.opacity(0.16), location: 0.48),
                        .init(color: Color.black.opacity(0.68), location: 1),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .allowsHitTesting(false)

                Text(subcategory.title)
                    .font(.subheadline.weight(.black))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)
                    .shadow(color: .black.opacity(0.32), radius: 8, x: 0, y: 2)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(
                width: BrowseCollectionLayout.subcategoryCardWidth,
                height: BrowseCollectionLayout.subcategoryCardHeight,
                alignment: .bottomLeading
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .background(PhrasePageStyle.glassCardFill, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? subcategory.tintName.color.opacity(0.72) : .white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: isSelected ? 2 : 1)
            }
            .softAmbientCardShadow()
            .nativeGlass(cornerRadius: 20, interactive: true)
            .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(subcategory.title). \(subcategory.subtitle)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("BrowseCollection.Subcategory.\(subcategory.id)")
    }

    @ViewBuilder
    private var cardImage: some View {
        if let imageName {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(
                    width: BrowseCollectionLayout.subcategoryCardWidth,
                    height: BrowseCollectionLayout.subcategoryCardHeight,
                    alignment: .top
                )
                .clipped()
                .accessibilityHidden(true)
        } else {
            ZStack {
                subcategory.tintName.color.opacity(0.16)

                Image(systemName: subcategory.symbolName)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(subcategory.tintName.color)
            }
            .frame(
                width: BrowseCollectionLayout.subcategoryCardWidth,
                height: BrowseCollectionLayout.subcategoryCardHeight
            )
            .accessibilityHidden(true)
        }
    }
}

private struct BrowseCityHubContent: View {
    let descriptor: BrowseCollectionDescriptor
    let cityHub: BrowseCityHub
    let selectedCityCardID: String?

    let onOpenDetail: (String) -> Void
    let onOpenCollection: (BrowseCollectionRoute) -> Void
    let isSaved: (String) -> Bool
    let onToggleSaved: (String) -> Void
    let onSelectCityCard: (BrowseCollectionSubcategory) -> Void
    let onPractice: () -> Void

    var body: some View {
        let cityBrowseFilters = cityHub.cityBrowseFilters

        VStack(alignment: .leading, spacing: BrowseCollectionLayout.sectionSpacing) {
            if isCountryHub {
                if let cityNameAudioItem = cityHub.cityNameAudioItem {
                    BrowseCityNameAudioPlayer(item: cityNameAudioItem)
                }

                BrowseCityCardGridSection(
                    title: cityHub.situationTitle,
                    cards: cityHub.situations,
                    onOpenCollection: onOpenCollection
                )

                BrowseCollectionMessageEntryCard(
                    descriptor: descriptor,
                    onPractice: onPractice
                )

                BrowseCityCardGridSection(
                    title: cityHub.browseTitle,
                    cards: cityHub.browseGroups,
                    onOpenCollection: onOpenCollection
                )

                if !cityHub.namesToKnowItems.isEmpty {
                    BrowseCollectionStarterSection(
                        title: cityHub.namesTitle,
                        items: cityHub.namesToKnowItems,
                        onOpenDetail: onOpenDetail
                    )
                }

                if !cityHub.quickPhraseItems.isEmpty {
                    BrowseCollectionStarterSection(
                        title: cityHub.quickPhrasesTitle,
                        items: cityHub.quickPhraseItems,
                        onOpenDetail: onOpenDetail
                    )
                }
            } else {
                BrowseCityIntroSection(
                    title: cityHub.introTitle,
                    text: cityHub.introText
                )

                if let cityNameAudioItem = cityHub.cityNameAudioItem {
                    BrowseCityNameAudioPlayer(item: cityNameAudioItem)
                }

                if !cityBrowseFilters.isEmpty {
                    BrowseCityFilterSection(
                        title: cityHub.browseTitle,
                        filters: cityBrowseFilters,
                        selectedFilterID: selectedCityCardID,
                        onSelectFilter: onSelectCityCard,
                        onOpenDetail: onOpenDetail,
                        isSaved: isSaved,
                        onToggleSaved: onToggleSaved
                    )
                }
            }
        }
        .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)
    }

    private var isCountryHub: Bool {
        descriptor.route == .category("city-guides")
    }
}

private struct BrowseCityIntroSection: View {
    let title: String
    let text: String

    var body: some View {
        BrowseCollectionSection(title: title) {
            Text(text)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct BrowseCityFilterSection: View {
    let title: String
    let filters: [BrowseCollectionSubcategory]
    let selectedFilterID: String?
    let onSelectFilter: (BrowseCollectionSubcategory) -> Void
    let onOpenDetail: (String) -> Void
    let isSaved: (String) -> Bool
    let onToggleSaved: (String) -> Void

    private var visibleFilters: [BrowseCollectionSubcategory] {
        filters.filter { !$0.items.isEmpty }
    }

    var body: some View {
        BrowseCollectionSection(title: title) {
            VStack(alignment: .leading, spacing: 18) {
                imageFilterRail

                LazyVStack(alignment: .leading, spacing: 18) {
                    ForEach(visibleFilters) { filter in
                        VStack(alignment: .leading, spacing: 0) {
                            Color.clear
                                .frame(width: 1, height: 1)
                                .id(BrowseCityBrowseScrollID.group(filter.id))
                                .accessibilityHidden(true)

                            BrowseCityNounGroupSection(
                                filter: filter,
                                onOpenDetail: onOpenDetail,
                                isSaved: isSaved,
                                onToggleSaved: onToggleSaved
                            )
                        }
                    }
                }
            }
        }
    }

    private var imageFilterRail: some View {
        GeometryReader { proxy in
            let cardWidth = BrowseCollectionLayout.cityFilterCardWidth(availableWidth: proxy.size.width)

            ScrollViewReader { filterScrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: BrowseCollectionLayout.cityFilterCardSpacing) {
                        ForEach(visibleFilters) { filter in
                            BrowseCityImageFilterCard(
                                title: filter.title,
                                imageName: filterImageName(filter),
                                tintName: filter.tintName,
                                identifier: "BrowseCollection.CityFilter.\(filter.id)",
                                isSelected: filter.id == selectedFilterID,
                                action: { onSelectFilter(filter) }
                            )
                            .frame(width: cardWidth)
                            .id(Self.filterScrollID(filter.id))
                        }
                    }
                    .padding(.bottom, PhrasePageStyle.cardShadowBleedPadding)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollClipDisabled()
                .onChange(of: selectedFilterID) { _, newValue in
                    guard let newValue else {
                        return
                    }

                    withAnimation(.snappy(duration: 0.24)) {
                        filterScrollProxy.scrollTo(Self.filterScrollID(newValue), anchor: .leading)
                    }
                }
            }
        }
        .frame(height: BrowseCollectionLayout.cityFilterCardHeight + PhrasePageStyle.cardShadowBleedPadding)
    }

    private func filterImageName(_ filter: BrowseCollectionSubcategory) -> String? {
        if let preferredImageName = BrowseImageAssetPolicy.resolvedImageName(
            Self.preferredFilterImageNames[filter.id],
            exists: BrowseImageAssetCache.exists
        ) {
            return preferredImageName
        }

        return filter.items.lazy.compactMap(\.resolvedImageName).first
    }

    private static func filterScrollID(_ filterID: String) -> String {
        "BrowseCollection.CityFilter.ScrollTarget.\(filterID)"
    }

    private static let preferredFilterImageNames: [String: String] = [
        "danang.browse.landmarks": "HeroCityDanangPlaceGoldenBridge",
        "danang.browse.restaurants": "HeroCityDanangPlaceNen",
        "danang.browse.tours": "HeroCityDanangPlaceBaNaCableCar",
        "hanoi.browse.beaches-nature": "HeroCityHanoiPlaceHoanKiemLake",
        "hcmc.browse.cafes": "HeroCityHcmcPlaceLittleHanoiEggCoffee",
        "hue.browse.cafes": "HeroCityHuePlaceLangThangCoffee",
    ]
}

private enum BrowseCityBrowseScrollID {
    static func group(_ filterID: String) -> String {
        "BrowseCollection.CityGroup.ScrollTarget.\(filterID)"
    }
}

private struct BrowseCityImageFilterCard: View {
    let title: String
    let imageName: String?
    let tintName: AccentTint
    let identifier: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                cityImage

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
        .accessibilityIdentifier(identifier)
    }

    @ViewBuilder
    private var cityImage: some View {
        if let imageName {
            BrowseFocusedAssetImage(imageName: imageName)
                .frame(height: BrowseCollectionLayout.cityFilterImageHeight)
                .frame(maxWidth: .infinity)
                .clipped()
                .accessibilityHidden(true)
        } else {
            ZStack {
                tintName.color.opacity(0.15)
                Image(systemName: "photo")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(tintName.color)
            }
            .frame(height: BrowseCollectionLayout.cityFilterImageHeight)
            .frame(maxWidth: .infinity)
            .accessibilityHidden(true)
        }
    }
}

private struct BrowseCityNounGroupSection: View {
    let filter: BrowseCollectionSubcategory
    let onOpenDetail: (String) -> Void
    let isSaved: (String) -> Bool
    let onToggleSaved: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(filter.title)
                .font(.headline.weight(.black))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            LazyVStack(spacing: 0) {
                ForEach(filter.items) { item in
                    BrowseCityNounRow(
                        item: item,
                        isSaved: isSaved(item.pageID),
                        onOpenDetail: onOpenDetail,
                        onToggleSaved: { onToggleSaved(item.pageID) }
                    )

                    if item.id != filter.items.last?.id {
                        Divider().padding(.leading, 86)
                    }
                }
            }
            .padding(.vertical, 8)
            .phraseListCard(cornerRadius: 24)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("BrowseCollection.CityGroup.\(filter.id)")
    }
}

private struct BrowseCityNounRow: View {
    let item: BrowseSearchPhraseItem
    let isSaved: Bool
    let onOpenDetail: (String) -> Void
    let onToggleSaved: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button {
                onOpenDetail(item.pageID)
            } label: {
                HStack(spacing: 14) {
                    thumbnail

                    VStack(alignment: .leading, spacing: 3) {
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
                    .layoutPriority(1)
                }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .accessibilityIdentifier("BrowseCollection.Row.\(item.pageID)")

            trailingControl

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
            .accessibilityIdentifier("BrowseCollection.Save.\(item.pageID)")
            .zIndex(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let imageName = item.resolvedImageName {
            BrowseFocusedAssetImage(imageName: imageName)
                .frame(
                    width: BrowseCollectionLayout.cityNounThumbnailSize,
                    height: BrowseCollectionLayout.cityNounThumbnailSize
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.8), lineWidth: 1)
                }
                .accessibilityHidden(true)
        } else {
            Image(systemName: item.symbolName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(item.tintName.color)
                .frame(
                    width: BrowseCollectionLayout.cityNounThumbnailSize,
                    height: BrowseCollectionLayout.cityNounThumbnailSize
                )
                .nativeGlass(cornerRadius: 16, tint: item.tintName.color.opacity(0.12), interactive: false)
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private var trailingControl: some View {
        if AudioSpeakerButton.isPlayableAudioKey(item.audioKey) {
            AudioSpeakerButton(tint: item.tintName, size: 44, audioKey: item.audioKey)
        } else {
            Image(systemName: "chevron.right")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.secondary.opacity(0.8))
                .frame(width: 36, height: 36)
                .nativeGlass(cornerRadius: 18, interactive: false)
        }
    }
}

enum BrowseFocusedAssetImagePolicy {
    static func shouldReadImageSize(for imageName: String) -> Bool {
        focusedImages[imageName] != nil
    }

    static func focusPoint(for imageName: String) -> UnitPoint {
        focusedImages[imageName] ?? .center
    }

    private static let focusedImages: [String: UnitPoint] = [
        "HeroCityDanangPlaceBaNaHills": UnitPoint(x: 0.5, y: 0.25),
        "HeroCityDanangPlaceBanhXeoBaDuong": UnitPoint(x: 0.5, y: 0.68),
    ]
}

private struct BrowseFocusedAssetImage: View {
    let imageName: String

    var body: some View {
        GeometryReader { proxy in
            let containerSize = proxy.size

            if
                BrowseFocusedAssetImagePolicy.shouldReadImageSize(for: imageName),
                let imageSize = BrowseImageAssetCache.size(for: imageName) {
                let scale = max(
                    containerSize.width / imageSize.width,
                    containerSize.height / imageSize.height
                )
                let scaledSize = CGSize(
                    width: imageSize.width * scale,
                    height: imageSize.height * scale
                )
                let offset = Self.offset(
                    focus: BrowseFocusedAssetImagePolicy.focusPoint(for: imageName),
                    scaledSize: scaledSize,
                    containerSize: containerSize
                )

                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: scaledSize.width, height: scaledSize.height)
                    .offset(offset)
                    .frame(width: containerSize.width, height: containerSize.height)
                    .clipped()
            } else {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: containerSize.width, height: containerSize.height)
                    .clipped()
            }
        }
    }

    private static func offset(
        focus: UnitPoint,
        scaledSize: CGSize,
        containerSize: CGSize
    ) -> CGSize {
        let maxX = max((scaledSize.width - containerSize.width) / 2, 0)
        let maxY = max((scaledSize.height - containerSize.height) / 2, 0)
        let rawX = scaledSize.width * (0.5 - focus.x)
        let rawY = scaledSize.height * (0.5 - focus.y)

        return CGSize(
            width: min(max(rawX, -maxX), maxX),
            height: min(max(rawY, -maxY), maxY)
        )
    }
}

private struct BrowseCityFilterPill: View {
    let title: String
    let identifier: String
    let isSelected: Bool
    let tintName: AccentTint
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            Text(title)
                .font(.subheadline.weight(.black))
                .foregroundStyle(isSelected ? tintName.audioColor : .primary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)
                .padding(.horizontal, 15)
                .frame(height: 38)
                .background {
                    Capsule(style: .continuous)
                        .fill(isSelected ? tintName.color.opacity(0.16) : PhrasePageStyle.cardFill)
                }
                .overlay {
                    Capsule(style: .continuous)
                        .stroke(isSelected ? tintName.color.opacity(0.58) : .white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: 1)
                }
                .contentShape(Capsule(style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier(identifier)
    }
}

private struct BrowseCityCardGridSection: View {
    let title: String
    let cards: [BrowseCollectionSubcategory]
    var selectedCardID: String? = nil
    let onOpenCollection: (BrowseCollectionRoute) -> Void
    var onSelectCard: ((BrowseCollectionSubcategory) -> Void)? = nil

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        BrowseCollectionSection(title: title) {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                ForEach(cards) { card in
                    BrowseCityActionCard(
                        card: card,
                        isSelected: card.id == selectedCardID,
                        onOpenCollection: onOpenCollection,
                        onSelectCard: onSelectCard
                    )
                }
            }
        }
    }
}

private struct BrowseCityActionCard: View {
    let card: BrowseCollectionSubcategory
    let isSelected: Bool
    let onOpenCollection: (BrowseCollectionRoute) -> Void
    let onSelectCard: ((BrowseCollectionSubcategory) -> Void)?

    var body: some View {
        Button(action: activate) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: card.symbolName)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(card.tintName.color)
                    .frame(width: 46, height: 46)
                    .nativeGlass(cornerRadius: 17, tint: card.tintName.color.opacity(0.14), interactive: false)
                    .allowsHitTesting(false)

                VStack(alignment: .leading, spacing: 4) {
                    Text(card.title)
                        .font(.subheadline.weight(.black))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)

                    Text(card.subtitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 146, alignment: .topLeading)
            .phraseListCard(cornerRadius: 20)
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? card.tintName.color.opacity(0.55) : .clear, lineWidth: 2)
            }
            .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("BrowseCollection.CityCard.\(card.id)")
    }

    private func activate() {
        if let targetRoute = card.targetRoute {
            onOpenCollection(targetRoute)
        } else {
            onSelectCard?(card)
        }
    }
}

private struct BrowseCityNameAudioPlayer: View {
    let item: BrowseCityNameAudioItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "waveform")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(item.tintName.audioColor)
                    .frame(width: 42, height: 42)
                    .nativeGlass(cornerRadius: 21, tint: item.tintName.color.opacity(0.12), interactive: false)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.headline.weight(.black))
                        .foregroundStyle(.primary)

                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            PlaybackDockView(
                audioKey: item.audioKey,
                showsFavoriteButton: false
            )
            .frame(height: 108)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("BrowseCollection.CityNamePlayer.\(item.subtitle)")
    }
}

private struct BrowseCollectionStarterSection: View {
    let title: String
    let items: [BrowseSearchPhraseItem]
    let onOpenDetail: (String) -> Void

    var body: some View {
        BrowseCollectionSection(title: title) {
            VStack(spacing: 0) {
                ForEach(items) { item in
                    BrowseCollectionPhraseRow(item: item, onOpenDetail: onOpenDetail)

                    if item.id != items.last?.id {
                        Divider().padding(.leading, 70)
                    }
                }
            }
            .padding(.vertical, 8)
            .phraseListCard(cornerRadius: 24)
        }
    }
}

private struct BrowseCollectionMessageEntryCard: View {
    let descriptor: BrowseCollectionDescriptor
    let onPractice: () -> Void

    var body: some View {
        Button(action: onPractice) {
            HStack(spacing: 14) {
                Image(systemName: "waveform")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 58, height: 58)
                    .background(Color.red, in: Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(descriptor.practiceTitle)
                        .font(.headline.weight(.black))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)

                    Text(descriptor.practiceSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .layoutPriority(1)

                Text("Practice")
                    .font(.caption.weight(.black))
                    .foregroundStyle(.red)
                    .padding(.horizontal, 14)
                    .frame(height: 38)
                    .nativeGlass(cornerRadius: 19, interactive: true)
            }
            .padding(14)
            .phraseListCard(cornerRadius: 24)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("BrowseCollection.PracticeEntry.\(descriptor.route.id)")
    }
}

enum BrowseCollectionLayoutPolicy {
    static func hasMessageSection(_ descriptor: BrowseCollectionDescriptor) -> Bool {
        !descriptor.messageScenarioIDs.isEmpty
    }
}

enum BrowseCollectionMessageLayout {
    static let contactWidth: CGFloat = 104
    static let avatarSize: CGFloat = 88
    static let itemSpacing: CGFloat = 16
    static let rowHeight: CGFloat = 144
    static let rowHorizontalInset: CGFloat = 1
    static var rowViewportHorizontalBleed: CGFloat { BrowseCollectionLayout.horizontalPadding }
    static var rowContentHorizontalInset: CGFloat { BrowseCollectionLayout.horizontalPadding + rowHorizontalInset }

    static func rowViewportWidth(contentColumnWidth: CGFloat) -> CGFloat {
        contentColumnWidth + (rowViewportHorizontalBleed * 2)
    }
}

private struct BrowseCollectionMessageSection: View {
    let descriptor: BrowseCollectionDescriptor
    let onStartScenario: (PracticeScenarioID) -> Void

    var body: some View {
        if let title = descriptor.browseMessageSectionTitle {
            BrowseCollectionSection(title: title) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: BrowseCollectionMessageLayout.itemSpacing) {
                        ForEach(descriptor.messageScenarioIDs) { scenarioID in
                            BrowseCollectionMessageContactButton(
                                scenarioID: scenarioID,
                                onStart: { onStartScenario(scenarioID) }
                            )
                            .frame(width: BrowseCollectionMessageLayout.contactWidth)
                        }
                    }
                    .padding(.horizontal, BrowseCollectionMessageLayout.rowContentHorizontalInset)
                    .padding(.bottom, 2)
                }
                .frame(height: BrowseCollectionMessageLayout.rowHeight)
                .padding(.horizontal, -BrowseCollectionMessageLayout.rowViewportHorizontalBleed)
                .scrollClipDisabled()
                .accessibilityIdentifier("BrowseCollection.Messages.SectionRow.\(descriptor.route.id)")
            }
            .accessibilityIdentifier("BrowseCollection.Messages.\(descriptor.route.id)")
        }
    }
}

private struct BrowseCollectionMessageContactButton: View {
    let scenarioID: PracticeScenarioID
    let onStart: () -> Void

    var body: some View {
        Button(action: onStart) {
            VStack(spacing: 10) {
                PracticeMessageAvatar(
                    scenarioID: scenarioID,
                    size: BrowseCollectionMessageLayout.avatarSize,
                    showsSymbol: true
                )

                Text(scenarioID.messageContactName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)
                    .frame(maxWidth: .infinity, minHeight: 40, alignment: .top)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(scenarioID.messageContactName)
        .accessibilityIdentifier("BrowseCollection.Message.Contact.\(scenarioID.rawValue)")
    }
}

private struct BrowseCollectionExploreSection: View {
    let shelves: [BrowseCollectionShelf]
    let onOpenDetail: (String) -> Void
    let onOpenCollection: (BrowseCollectionRoute) -> Void

    var body: some View {
        LazyVStack(alignment: .leading, spacing: BrowseCollectionLayout.sectionSpacing) {
            ForEach(shelves) { shelf in
                BrowseCollectionShelfView(
                    shelf: shelf,
                    onOpenDetail: onOpenDetail,
                    onOpenCollection: onOpenCollection
                )
            }
        }
        .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)
    }
}

private struct BrowseCollectionShelfView: View {
    let shelf: BrowseCollectionShelf
    let onOpenDetail: (String) -> Void
    let onOpenCollection: (BrowseCollectionRoute) -> Void

    var body: some View {
        BrowseCollectionSection(
            title: shelf.title,
            targetRoute: shelf.targetRoute,
            onOpenCollection: onOpenCollection
        ) {
            GeometryReader { proxy in
                let groupWidth = max(274, min(338, proxy.size.width - 42))

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(Array(shelf.itemGroups.enumerated()), id: \.offset) { _, group in
                            BrowseCollectionPhraseGroupCard(
                                items: group,
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
            .frame(height: BrowseCollectionPhraseGroupCard.groupHeight)
        }
    }
}

private struct BrowseCollectionSection<Content: View>: View {
    let title: String
    let targetRoute: BrowseCollectionRoute?
    let onOpenCollection: ((BrowseCollectionRoute) -> Void)?
    let content: Content

    init(
        title: String,
        targetRoute: BrowseCollectionRoute? = nil,
        onOpenCollection: ((BrowseCollectionRoute) -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.targetRoute = targetRoute
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
        if let targetRoute, let onOpenCollection {
            Button {
                onOpenCollection(targetRoute)
            } label: {
                headerContent(showsChevron: true)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("BrowseCollection.SectionHeader.\(targetRoute.id)")
        } else {
            headerContent(showsChevron: false)
        }
    }

    private func headerContent(showsChevron: Bool) -> some View {
        HStack(spacing: 7) {
            Text(title)
                .font(.title3.weight(.black))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.black))
                    .foregroundStyle(.tertiary)
            }
        }
        .contentShape(Rectangle())
    }
}

private struct BrowseCollectionPhraseGroupCard: View {
    let items: [BrowseSearchPhraseItem]
    let width: CGFloat
    let onOpenDetail: (String) -> Void

    static let rowHeight: CGFloat = 86
    static let verticalPadding: CGFloat = 8
    static let groupHeight: CGFloat = (rowHeight * 3) + (verticalPadding * 2)

    var body: some View {
        VStack(spacing: 0) {
            ForEach(items) { item in
                BrowseCollectionPhraseRow(item: item, onOpenDetail: onOpenDetail)
                    .frame(height: Self.rowHeight)

                if item.id != items.last?.id {
                    Divider().padding(.leading, 70)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, Self.verticalPadding)
        .frame(width: width, height: Self.groupHeight, alignment: .top)
        .phraseListCard(cornerRadius: PhrasePageStyle.compactCardCornerRadius)
    }
}

private struct BrowseCollectionPhraseRow: View {
    let item: BrowseSearchPhraseItem
    let onOpenDetail: (String) -> Void

    var body: some View {
        HStack(spacing: 0) {
            leadingControl
                .padding(.leading, 14)
                .padding(.trailing, 12)

            Button {
                onOpenDetail(item.pageID)
            } label: {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.title)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.72)

                        Text(item.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.78)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .layoutPriority(1)

                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .padding(.trailing, 14)
            .accessibilityIdentifier("BrowseCollection.Row.\(item.pageID)")
        }
        .frame(minHeight: 76)
    }

    @ViewBuilder
    private var leadingControl: some View {
        if AudioSpeakerButton.isPlayableAudioKey(item.audioKey) {
            AudioSpeakerButton(tint: item.tintName, size: 44, audioKey: item.audioKey)
        } else {
            Image(systemName: item.symbolName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(item.tintName.color)
                .frame(width: 44, height: 44)
                .nativeGlass(cornerRadius: 22, tint: item.tintName.color.opacity(0.12), interactive: false)
                .accessibilityHidden(true)
        }
    }
}

#Preview {
    if let descriptor = BrowseSearchDestinations.collectionDescriptor(for: .category("hotel")) {
        BrowseCollectionPageView(
            descriptor: descriptor,
            scrollToTopTrigger: 0,
            scrollToTopRoute: nil,
            focusRequest: nil,
            onOpenDetail: { _ in },
            onOpenCollection: { _ in },
            onPractice: { _ in }
        )
    }
}
