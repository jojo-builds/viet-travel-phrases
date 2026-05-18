import SwiftUI

struct BrowseCollectionPageView: View {
    let descriptor: BrowseCollectionDescriptor
    let scrollToTopTrigger: Int
    let scrollToTopRoute: BrowseCollectionRoute?
    let focusRequest: BrowseCollectionFocusRequest?
    var isActive: Bool = true
    var onOpenDetail: (String) -> Void
    var onOpenCollection: (BrowseCollectionRoute) -> Void
    var onPractice: (BrowseCollectionPracticeAction) -> Void

    @State private var selectedSubcategoryID: String?
    @State private var selectedCityCardID: String?
    @State private var didApplyPhotoBackdropInitialPosition = false
    @State private var isPhotoBackdropImmersive = false
    @State private var photoBackdropScrollOffset: CGFloat = 0

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
                    }
                    .padding(.bottom, BrowseCollectionLayout.bottomChromeContentClearance)
                }
                .onChange(of: scrollToTopTrigger) { _, _ in
                    guard scrollToTopRoute == nil || scrollToTopRoute == descriptor.route else {
                        return
                    }

                    scrollProxy.scrollTo(Self.scrollTopID, anchor: .top)
                }
                .task(id: focusRequest?.id) {
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
                    .onScrollGeometryChange(for: CGFloat.self, of: { scrollGeometry in
                        max(scrollGeometry.contentOffset.y + scrollGeometry.contentInsets.top, 0)
                    }) { _, offset in
                        let backdropOffset = PhrasePhotoBackdropLayout.quantizedBackdropOffset(for: offset)
                        if abs(backdropOffset - photoBackdropScrollOffset) >= 1 {
                            photoBackdropScrollOffset = backdropOffset
                        }

                        if isPhotoBackdropImmersive, offset > metrics.revealImmersiveOffset {
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
                    selectedSubcategoryID = selectedSubcategoryID == subcategory.id ? nil : subcategory.id
                }
            )

            BrowseCollectionStarterSection(
                title: starterTitle,
                items: starterItems,
                onOpenDetail: onOpenDetail
            )
            .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)

            if descriptor.hasMessageSection {
                BrowseCollectionMessageSection(
                    descriptor: descriptor,
                    onStartScenario: { scenarioID in
                        onPractice(.practiceScenario(scenarioID))
                    }
                )
                .id(BrowseCollectionFocusRequest.messageSectionScrollTargetID)
                .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)
            } else {
                BrowseCollectionMessageEntryCard(
                    descriptor: descriptor,
                    onPractice: { onPractice(descriptor.practiceAction) }
                )
                .id(BrowseCollectionFocusRequest.practiceEntryScrollTargetID)
                .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)
            }

            if selectedSubcategory == nil {
                BrowseCollectionExploreSection(
                    shelves: descriptor.exploreShelves,
                    onOpenDetail: onOpenDetail,
                    onOpenCollection: onOpenCollection
                )
            }
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

            BrowseCollectionHeaderCopy(
                descriptor: descriptor
            )
            .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)
            .padding(.bottom, 26)

            collectionSections(scrollProxy: scrollProxy)
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
        .shadow(color: .black.opacity(0.16), radius: 28, x: 0, y: -12)
        .opacity(isPhotoBackdropImmersive ? 0 : 1)
        .allowsHitTesting(!isPhotoBackdropImmersive)
        .accessibilityHidden(isPhotoBackdropImmersive)
        .animation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation, value: isPhotoBackdropImmersive)
    }

    private func photoBackdropImage(geometry: GeometryProxy) -> some View {
        Image(descriptor.mastheadImageName)
            .resizable()
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
        let backdropBottom = geometry.size.height + PhrasePhotoBackdropLayout.bottomChromeBackdropOffset(
            safeAreaBottom: safeAreaBottom
        )
        let sheetTop = max(metrics.collapsedContentTop - photoBackdropScrollOffset, 0)
        let roundedSheetClearance = PhrasePhotoBackdropLayout.sheetCornerClearance
        let maximumBackdropHeight = max(backdropBottom - sheetTop - roundedSheetClearance, 0)
        let backdropHeight = min(
            PhrasePhotoBackdropLayout.bottomChromeBackdropHeight(safeAreaBottom: safeAreaBottom),
            maximumBackdropHeight
        )

        return VStack(spacing: 0) {
            Spacer(minLength: 0)

            PhotoBackdropBottomChromeBacking(height: backdropHeight)
        }
        .frame(
            height: backdropBottom,
            alignment: .bottom
        )
        .ignoresSafeArea(edges: .bottom)
        .opacity(isPhotoBackdropImmersive ? 0 : 1)
        .animation(PhrasePhotoBackdropLayout.immersiveDissolveAnimation, value: isPhotoBackdropImmersive)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private static let scrollTopID = "BrowseCollectionTop"
    private static let photoBackdropInitialID = "BrowseCollectionPhotoBackdropInitial"

    private var selectedSubcategory: BrowseCollectionSubcategory? {
        descriptor.subcategories.first { $0.id == selectedSubcategoryID }
    }

    private var starterTitle: String {
        selectedSubcategory.map {
            $0.countUnit == "item" ? $0.title : "\($0.title) phrases"
        } ?? descriptor.starterTitle
    }

    private var starterItems: [BrowseSearchPhraseItem] {
        selectedSubcategory?.items ?? descriptor.starterItems
    }

    private var usesPhotoBackdropLayout: Bool {
        descriptor.cityHub != nil || descriptor.mastheadImageName.hasPrefix("HeroCategory")
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
            scrollProxy.scrollTo(BrowseCityBrowseScrollID.group(filter.id), anchor: .top)
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

        try? await Task.sleep(nanoseconds: BrowseCollectionLayout.focusRestoreDelayNanoseconds)
        guard !Task.isCancelled else {
            return
        }

        withAnimation(.snappy(duration: BrowseCollectionLayout.focusRestoreAnimationDuration)) {
            scrollProxy.scrollTo(focusRequest.target.scrollTargetID, anchor: .center)
        }
    }
}

private enum BrowseCollectionLayout {
    static let horizontalPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = HomeLayout.sectionSpacing
    static let bottomChromeContentClearance: CGFloat = 128
    static let focusRestoreDelayNanoseconds: UInt64 = 520_000_000
    static let focusRestoreAnimationDuration: TimeInterval = 0.24
    static let cityFilterCardSpacing: CGFloat = 12
    static let cityFilterCardHeight: CGFloat = 166
    static let cityFilterImageHeight: CGFloat = 108
    static let cityNounThumbnailSize: CGFloat = 62
    static let subcategoryCardWidth: CGFloat = 136
    static let subcategoryCardHeight: CGFloat = 124
}

private extension BrowseSearchPhraseItem {
    var resolvedImageName: String? {
        guard let imageName, UIImage(named: imageName) != nil else {
            return nil
        }

        return imageName
    }
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
    }
}

private struct BrowseCollectionSubcategoryCard: View {
    let subcategory: BrowseCollectionSubcategory
    let isSelected: Bool
    let fallbackImageName: String?
    let onSelect: () -> Void

    private var imageName: String? {
        subcategory.items.first(where: { $0.resolvedImageName != nil })?.resolvedImageName ?? fallbackImageName
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
            .background(.white.opacity(0.58), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? subcategory.tintName.color.opacity(0.72) : .white.opacity(0.64), lineWidth: isSelected ? 2 : 1)
            }
            .shadow(color: .black.opacity(0.04), radius: 9, x: 0, y: 5)
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
                        onOpenDetail: onOpenDetail
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

    private var visibleFilters: [BrowseCollectionSubcategory] {
        filters.filter { !$0.items.isEmpty }
    }

    var body: some View {
        BrowseCollectionSection(title: title) {
            VStack(alignment: .leading, spacing: 18) {
                imageFilterRail

                VStack(alignment: .leading, spacing: 18) {
                    ForEach(visibleFilters) { filter in
                        BrowseCityNounGroupSection(
                            filter: filter,
                            onOpenDetail: onOpenDetail
                        )
                        .id(BrowseCityBrowseScrollID.group(filter.id))
                    }
                }
            }
        }
    }

    private var imageFilterRail: some View {
        GeometryReader { proxy in
            let cardWidth = max(154, (proxy.size.width - BrowseCollectionLayout.cityFilterCardSpacing) / 2)

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
                    .padding(.bottom, 2)
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
        .frame(height: BrowseCollectionLayout.cityFilterCardHeight)
    }

    private func filterImageName(_ filter: BrowseCollectionSubcategory) -> String? {
        filter.items.first(where: { $0.resolvedImageName != nil })?.resolvedImageName
    }

    private static func filterScrollID(_ filterID: String) -> String {
        "BrowseCollection.CityFilter.ScrollTarget.\(filterID)"
    }
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
                    .background(.white.opacity(0.96))
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(isSelected ? tintName.color.opacity(0.50) : Color.black.opacity(0.06), lineWidth: isSelected ? 1.5 : 1)
                    .allowsHitTesting(false)
            }
            .shadow(color: .black.opacity(0.025), radius: 7, x: 0, y: 4)
            .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier(identifier)
    }

    @ViewBuilder
    private var cityImage: some View {
        if let imageName {
            Image(imageName)
                .resizable()
                .scaledToFill()
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

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(filter.title)
                .font(.headline.weight(.black))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            VStack(spacing: 0) {
                ForEach(filter.items) { item in
                    BrowseCityNounRow(item: item, onOpenDetail: onOpenDetail)

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
    let onOpenDetail: (String) -> Void

    var body: some View {
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(1)

                Spacer(minLength: 0)

                trailingControl
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("BrowseCollection.Row.\(item.pageID)")
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let imageName = item.resolvedImageName {
            Image(imageName)
                .resizable()
                .scaledToFill()
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
            AudioSpeakerButton(tint: item.tintName, audioKey: item.audioKey)
        } else {
            Image(systemName: "chevron.right")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.secondary.opacity(0.8))
                .frame(width: 36, height: 36)
                .nativeGlass(cornerRadius: 18, interactive: false)
        }
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
                        .fill(isSelected ? tintName.color.opacity(0.16) : Color(.secondarySystemBackground).opacity(0.92))
                }
                .overlay {
                    Capsule(style: .continuous)
                        .stroke(isSelected ? tintName.color.opacity(0.58) : Color.black.opacity(0.08), lineWidth: 1)
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

private extension BrowseCollectionDescriptor {
    var hasMessageSection: Bool {
        false
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
