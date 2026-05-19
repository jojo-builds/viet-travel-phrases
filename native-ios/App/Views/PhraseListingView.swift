import SwiftUI
import UIKit

enum PhraseArticleInitialScrollTarget: String {
    case firstBreakdown = "first-breakdown"
    case catalogExplore = "catalog-explore"
}

struct PhraseListingView: View {
    let page: PhrasePage
    let chromeRoute: AppRoute
    let initialScrollTarget: PhraseArticleInitialScrollTarget?
    let scrollToTopTrigger: Int
    let scrollToTopRoute: AppRoute?
    let chromeNamespace: Namespace.ID?
    let isSearchActive: Bool
    let isActive: Bool
    let showsChrome: Bool
    let topChromeContentClearance: CGFloat
    let isSaved: Bool
    let heroMorphPageID: String?
    let heroMorphContentHoldPageID: String?
    let heroImageNameOverride: String?
    var onBackTapped: () -> Void = {}
    var onSearchTapped: () -> Void = {}
    var onToggleSaved: (() -> Void)? = nil
    var onDetailTapped: (String) -> Void = { _ in }

    init(
        page: PhrasePage,
        chromeRoute: AppRoute = .phrasePage,
        initialScrollTarget: PhraseArticleInitialScrollTarget? = nil,
        scrollToTopTrigger: Int = 0,
        scrollToTopRoute: AppRoute? = nil,
        chromeNamespace: Namespace.ID? = nil,
        isSearchActive: Bool = false,
        isActive: Bool = true,
        showsChrome: Bool = true,
        topChromeContentClearance: CGFloat = 0,
        isSaved: Bool = false,
        heroMorphPageID: String? = nil,
        heroMorphContentHoldPageID: String? = nil,
        heroImageNameOverride: String? = nil,
        onBackTapped: @escaping () -> Void = {},
        onSearchTapped: @escaping () -> Void = {},
        onToggleSaved: (() -> Void)? = nil,
        onDetailTapped: @escaping (String) -> Void = { _ in }
    ) {
        self.page = page
        self.chromeRoute = chromeRoute
        self.initialScrollTarget = initialScrollTarget
        self.scrollToTopTrigger = scrollToTopTrigger
        self.scrollToTopRoute = scrollToTopRoute
        self.chromeNamespace = chromeNamespace
        self.isSearchActive = isSearchActive
        self.isActive = isActive
        self.showsChrome = showsChrome
        self.topChromeContentClearance = topChromeContentClearance
        self.isSaved = isSaved
        self.heroMorphPageID = heroMorphPageID
        self.heroMorphContentHoldPageID = heroMorphContentHoldPageID
        self.heroImageNameOverride = heroImageNameOverride
        self.onBackTapped = onBackTapped
        self.onSearchTapped = onSearchTapped
        self.onToggleSaved = onToggleSaved
        self.onDetailTapped = onDetailTapped
    }

    var body: some View {
        PhraseArticleTemplateView(
            page: page.articleTemplate,
            chromeRoute: chromeRoute,
            initialScrollTarget: initialScrollTarget,
            scrollToTopTrigger: scrollToTopTrigger,
            scrollToTopRoute: scrollToTopRoute,
            chromeNamespace: chromeNamespace,
            isSearchActive: isSearchActive,
            isActive: isActive,
            showsChrome: showsChrome,
            topChromeContentClearance: topChromeContentClearance,
            isSaved: isSaved,
            heroMorphPageID: heroMorphPageID,
            heroMorphContentHoldPageID: heroMorphContentHoldPageID,
            heroImageNameOverride: heroImageNameOverride,
            onBackTapped: onBackTapped,
            onSearchTapped: onSearchTapped,
            onToggleSaved: onToggleSaved,
            onDetailTapped: onDetailTapped
        )
    }
}

struct PhraseArticleTemplateView: View {
    let page: PhraseArticlePage
    let chromeRoute: AppRoute
    let initialScrollTarget: PhraseArticleInitialScrollTarget?
    let scrollToTopTrigger: Int
    let scrollToTopRoute: AppRoute?
    let chromeNamespace: Namespace.ID?
    let isSearchActive: Bool
    let isActive: Bool
    let showsChrome: Bool
    let topChromeContentClearance: CGFloat
    let isSaved: Bool
    let heroMorphPageID: String?
    let heroMorphContentHoldPageID: String?
    let heroImageNameOverride: String?
    var onBackTapped: () -> Void = {}
    var onSearchTapped: () -> Void = {}
    var onToggleSaved: (() -> Void)? = nil
    var onDetailTapped: (String) -> Void = { _ in }
    @State private var didApplyInitialScrollTarget = false
    @State private var didApplyPhotoBackdropInitialPosition = false
    @State private var isPhotoBackdropImmersive = false
    @State private var photoBackdropScrollOffset: CGFloat = 0
    @State private var presentedHeroImage: PhraseHeroImagePresentation?

    init(
        page: PhraseArticlePage,
        chromeRoute: AppRoute,
        initialScrollTarget: PhraseArticleInitialScrollTarget? = nil,
        scrollToTopTrigger: Int = 0,
        scrollToTopRoute: AppRoute? = nil,
        chromeNamespace: Namespace.ID? = nil,
        isSearchActive: Bool = false,
        isActive: Bool = true,
        showsChrome: Bool = true,
        topChromeContentClearance: CGFloat = 0,
        isSaved: Bool = false,
        heroMorphPageID: String? = nil,
        heroMorphContentHoldPageID: String? = nil,
        heroImageNameOverride: String? = nil,
        onBackTapped: @escaping () -> Void = {},
        onSearchTapped: @escaping () -> Void = {},
        onToggleSaved: (() -> Void)? = nil,
        onDetailTapped: @escaping (String) -> Void = { _ in }
    ) {
        self.page = page
        self.chromeRoute = chromeRoute
        self.initialScrollTarget = initialScrollTarget
        self.scrollToTopTrigger = scrollToTopTrigger
        self.scrollToTopRoute = scrollToTopRoute
        self.chromeNamespace = chromeNamespace
        self.isSearchActive = isSearchActive
        self.isActive = isActive
        self.showsChrome = showsChrome
        self.topChromeContentClearance = topChromeContentClearance
        self.isSaved = isSaved
        self.heroMorphPageID = heroMorphPageID
        self.heroMorphContentHoldPageID = heroMorphContentHoldPageID
        self.heroImageNameOverride = heroImageNameOverride
        self.onBackTapped = onBackTapped
        self.onSearchTapped = onSearchTapped
        self.onToggleSaved = onToggleSaved
        self.onDetailTapped = onDetailTapped
    }

    @ViewBuilder
    var body: some View {
        if usesPhotoBackdropLayout {
            photoBackdropBody
        } else {
            standardBody
        }
    }

    private var standardBody: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        hero
                            .id(Self.scrollTopID)

                        LazyVStack(alignment: .leading, spacing: PhrasePageStyle.sectionSpacing) {
                            ForEach(visibleSections) { section in
                                ArticleSectionView(
                                    section: section,
                                    currentPageID: page.id,
                                    onOpenDetail: onDetailTapped
                                )
                                .id(section.id)
                            }

                            if shouldRenderCatalogExplore {
                                ExploreCatalogSection(
                                    currentPageID: page.id,
                                    onOpenDetail: onDetailTapped
                                )
                                .id(Self.catalogExploreID)
                            }
                        }
                        .padding(.horizontal, PhrasePageStyle.horizontalPadding)
                        .padding(.top, articleSectionsTopPadding + topChromeContentClearance)
                        .padding(.bottom, articleBottomChromeContentClearance)
                        .opacity(holdsArticleContentForHomeMorph ? 0 : 1)
                        .offset(y: holdsArticleContentForHomeMorph ? 18 : 0)
                        .allowsHitTesting(!holdsArticleContentForHomeMorph)
                        .animation(HomePhraseHeroMorphTiming.articleRevealAnimation, value: holdsArticleContentForHomeMorph)
                    }
                }
                .onChange(of: scrollToTopTrigger) { _, _ in
                    guard scrollToTopRoute == nil || scrollToTopRoute == chromeRoute else {
                        return
                    }

                    scrollProxy.scrollTo(Self.scrollTopID, anchor: .top)
                }
                .task {
                    await applyInitialScrollTargetIfNeeded(scrollProxy)
                }
            }
            .ignoresSafeArea(edges: .top)
            .overlay(alignment: .topLeading) {
                if showsChrome {
                    fixedBackButton
                        .padding(.leading, 24)
                        .padding(.top, 6)
                        .offset(y: -24)
                }
            }
        }
        .fullScreenCover(item: $presentedHeroImage) { presentation in
            PhraseHeroImageLightbox(presentation: presentation)
        }
        .accessibilityIdentifier("PhraseArticle.\(page.id)")
    }

    private var photoBackdropBody: some View {
        GeometryReader { geometry in
            let imageName = heroImageName
            let metrics = PhrasePhotoBackdropLayout.metrics(for: geometry.size)

            ZStack(alignment: .top) {
                photoBackdropImage(imageName: imageName, geometry: geometry)

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

                            photoBackdropContentSheet
                                .id(Self.photoBackdropContentID)
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
                        guard scrollToTopRoute == nil || scrollToTopRoute == chromeRoute else {
                            return
                        }

                        isPhotoBackdropImmersive = false
                        scrollProxy.scrollTo(Self.photoBackdropInitialID, anchor: .top)
                    }
                    .task(id: isActive) {
                        guard isActive else {
                            return
                        }

                        if initialScrollTarget == nil {
                            await applyPhotoBackdropInitialPositionIfNeeded(scrollProxy)
                        } else {
                            await applyInitialScrollTargetIfNeeded(scrollProxy)
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
            .overlay(alignment: .topLeading) {
                if showsChrome && !isPhotoBackdropImmersive {
                    fixedBackButton
                        .padding(.leading, 24)
                        .padding(.top, 6)
                        .offset(y: -24)
                        .transition(.opacity)
                }
            }
            .preference(
                key: PhrasePhotoBackdropImmersiveImagePreferenceKey.self,
                value: isActive && isPhotoBackdropImmersive
                    ? PhrasePhotoBackdropImmersiveImageContext(
                        pageID: page.id,
                        imageName: imageName,
                        viewportSize: geometry.size,
                        safeAreaTop: geometry.safeAreaInsets.top,
                        safeAreaBottom: geometry.safeAreaInsets.bottom,
                        imageFrameHeight: PhrasePhotoBackdropLayout.backdropFrameHeight(
                            for: geometry.size,
                            safeAreaInsets: geometry.safeAreaInsets,
                            pageID: page.id,
                            heroImageName: imageName
                        ),
                        verticalFocusOffset: PhrasePhotoBackdropLayout.backdropVerticalFocusOffset(
                            for: geometry.size,
                            pageID: page.id,
                            heroImageName: imageName
                        )
                    )
                    : nil
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
        .accessibilityIdentifier("PhraseArticle.\(page.id)")
    }

    private func photoBackdropImage(imageName: String, geometry: GeometryProxy) -> some View {
        let frameHeight = PhrasePhotoBackdropLayout.backdropFrameHeight(
            for: geometry.size,
            safeAreaInsets: geometry.safeAreaInsets,
            pageID: page.id,
            heroImageName: imageName
        )
        let verticalFocusOffset = PhrasePhotoBackdropLayout.backdropVerticalFocusOffset(
            for: geometry.size,
            pageID: page.id,
            heroImageName: imageName
        )

        return Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(
                width: geometry.size.width,
                height: frameHeight,
                alignment: .top
            )
            .clipped()
            .offset(y: -verticalFocusOffset)
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

    private var photoBackdropContentSheet: some View {
        VStack(alignment: .leading, spacing: 0) {
            Capsule()
                .fill(.secondary.opacity(0.22))
                .frame(width: 42, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                .padding(.bottom, 10)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    heroBadge

                    Text(page.destination.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                PhraseHeroCopyStack(
                    title: page.title,
                    englishTitle: page.englishTitle,
                    pronunciation: page.pronunciation,
                    titleSize: heroTitleSize,
                    titleLineLimit: 2,
                    pronunciationLineLimit: 2,
                    morphPageID: morphPageID,
                    morphNamespace: chromeNamespace,
                    isMorphActive: false,
                    isMorphSource: false
                )

                if shouldShowHeroPlaybackDock {
                    PlaybackDockView(
                        audioKey: page.playbackAudioKey,
                        isSaved: isSaved,
                        onToggleSaved: onToggleSaved,
                        visibilityRoute: chromeRoute
                    )
                    .padding(.top, heroPlayerTopSpacing)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, PhrasePageStyle.heroTextBottomPadding + 6)

            LazyVStack(alignment: .leading, spacing: PhrasePageStyle.sectionSpacing) {
                ForEach(visibleSections) { section in
                    ArticleSectionView(
                        section: section,
                        currentPageID: page.id,
                        onOpenDetail: onDetailTapped
                    )
                    .id(section.id)
                }

                if shouldRenderCatalogExplore {
                    ExploreCatalogSection(
                        currentPageID: page.id,
                        onOpenDetail: onDetailTapped
                    )
                    .id(Self.catalogExploreID)
                }
            }
            .padding(.horizontal, PhrasePageStyle.horizontalPadding)
            .padding(.top, articleSectionsTopPadding)
            .padding(.bottom, articleBottomChromeContentClearance)
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
        .accessibilityIdentifier("PhraseArticle.PhotoBackdrop.Content.\(page.id)")
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 0) {
            if usesCompactPhraseHero {
                CompactPhraseMastheadBackground()
                    .frame(height: 112)
            } else {
                heroImage
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    heroBadge

                    Text(page.destination.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                PhraseHeroCopyStack(
                    title: page.title,
                    englishTitle: page.englishTitle,
                    pronunciation: page.pronunciation,
                    titleSize: heroTitleSize,
                    titleLineLimit: usesCompactPhraseHero ? 3 : 2,
                    pronunciationLineLimit: 2,
                    morphPageID: morphPageID,
                    morphNamespace: chromeNamespace,
                    isMorphActive: usesHomePhraseHeroMorph,
                    isMorphSource: false
                )
                .zIndex(usesHomePhraseHeroMorph ? 4 : 0)

                if shouldShowHeroPlaybackDock {
                    PlaybackDockView(
                        audioKey: page.playbackAudioKey,
                        isSaved: isSaved,
                        onToggleSaved: onToggleSaved,
                        visibilityRoute: chromeRoute
                    )
                        .homePhraseHeroMorph(
                            HomePhraseHeroMorphID.player(morphPageID),
                            namespace: chromeNamespace,
                            isActive: usesHomePhraseHeroMorph,
                            isSource: false,
                            anchor: .topLeading
                        )
                        .zIndex(usesHomePhraseHeroMorph ? 3 : 0)
                        .padding(.top, heroPlayerTopSpacing)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, heroTextTopPadding)
            .padding(.bottom, PhrasePageStyle.heroTextBottomPadding)
        }
        .background(PhrasePageStyle.pageBackground)
    }

    @ViewBuilder
    private var heroImage: some View {
        let imageName = heroImageName
        let masthead = HeroMastheadImage(
            imageName: imageName,
            height: heroImageHeight
        )

        if supportsHeroImageLightbox {
            Button {
                presentedHeroImage = PhraseHeroImagePresentation(
                    pageID: page.id,
                    imageName: imageName,
                    title: page.title,
                    subtitle: page.englishTitle
                )
            } label: {
                masthead
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .font(.caption.weight(.black))
                            .foregroundStyle(.primary)
                            .frame(width: 36, height: 36)
                            .nativeGlass(cornerRadius: 18, tint: .white.opacity(0.22), interactive: true)
                            .padding(.trailing, 24)
                            .padding(.bottom, 28)
                            .accessibilityHidden(true)
                    }
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Open \(page.title) photo")
            .accessibilityIdentifier("PhraseArticle.HeroImageButton.\(page.id)")
        } else {
            masthead
        }
    }

    private var shouldRenderCatalogExplore: Bool {
        page.showsCatalogExplore && page.id == PhrasePage.xinChao.id
    }

    private var usesCompactPhraseHero: Bool {
        effectiveHeroImageName == "HeroCompactPhraseMasthead"
    }

    private var usesVietnameseMenuDetailFit: Bool {
        page.id.hasPrefix("viet-menu-")
    }

    private var usesCityNounDetailFit: Bool {
        (page.id.hasPrefix("viet-family-city-") || page.id.hasPrefix("viet-phrase-city-"))
            && effectiveHeroImageName != nil
            && !usesCompactPhraseHero
    }

    private var usesImageDetailFit: Bool {
        usesVietnameseMenuDetailFit || usesCityNounDetailFit
    }

    private var usesPhotoBackdropLayout: Bool {
        PhrasePhotoBackdropLayout.supportsListingPage(
            pageID: page.id,
            heroImageName: effectiveHeroImageName
        )
    }

    private var supportsHeroImageLightbox: Bool {
        usesImageDetailFit && effectiveHeroImageName != nil && !usesPhotoBackdropLayout
    }

    private var effectiveHeroImageName: String? {
        heroImageNameOverride ?? page.heroImageName
    }

    private var heroImageName: String {
        effectiveHeroImageName ?? PhrasePageStyle.heroImageName
    }

    private var shouldShowHeroPlaybackDock: Bool {
        !usesImageDetailFit || page.playbackAudioKey != nil
    }

    private var heroImageHeight: CGFloat {
        usesImageDetailFit ? 238 : PhrasePageStyle.heroImageHeight
    }

    private var heroTitleSize: CGFloat {
        if usesCompactPhraseHero {
            return 38
        }

        return usesImageDetailFit ? 46 : 54
    }

    private var heroTextTopPadding: CGFloat {
        if usesCompactPhraseHero {
            return 20
        }

        return usesImageDetailFit ? 20 : PhrasePageStyle.heroTextTopPadding
    }

    private var heroPlayerTopSpacing: CGFloat {
        usesImageDetailFit ? 12 : PhrasePageStyle.heroPlayerTopSpacing
    }

    private var articleSectionsTopPadding: CGFloat {
        usesImageDetailFit ? 22 : PhrasePageStyle.articleSectionsTopPadding
    }

    private var articleBottomChromeContentClearance: CGFloat {
        if usesPhotoBackdropLayout {
            return PhrasePhotoBackdropLayout.bottomReadingClearance
        }

        return usesImageDetailFit ? 132 : PhrasePageStyle.bottomChromeContentClearance
    }

    private var usesHomePhraseHeroMorph: Bool {
        heroMorphPageID == morphPageID
    }

    private var holdsArticleContentForHomeMorph: Bool {
        heroMorphContentHoldPageID == morphPageID
    }

    private var morphPageID: String {
        PhraseCatalog.canonicalPageID(forOpenablePageID: page.id) ?? page.id
    }

    private static let scrollTopID = "PhraseArticleTemplateViewTop"
    private static let catalogExploreID = "PhraseArticleTemplateViewCatalogExplore"
    private static let photoBackdropInitialID = "PhraseArticleTemplateViewPhotoBackdropInitial"
    private static let photoBackdropContentID = "PhraseArticleTemplateViewPhotoBackdropContent"

    private var visibleSections: [PhraseArticleSection] {
        Self.visibleSections(for: page)
    }

    static func visibleSections(for page: PhraseArticlePage) -> [PhraseArticleSection] {
        page.sections.filter { section in
            guard !isHeroRepeatSection(section, page: page) else { return false }
            return !section.body.isEmpty || !section.phrases.isEmpty || !section.breakdown.isEmpty || !section.chips.isEmpty
        }
    }

    private static func isHeroRepeatSection(_ section: PhraseArticleSection, page: PhraseArticlePage) -> Bool {
        isSelfOnlyHeroPhraseRepeat(section, page: page)
            || isHeroMeaningRepeat(section, page: page)
    }

    private static func isSelfOnlyHeroPhraseRepeat(_ section: PhraseArticleSection, page: PhraseArticlePage) -> Bool {
        let duplicateSectionTitles: Set<String> = ["Quick say", "Say this"]
        guard duplicateSectionTitles.contains(section.title), section.phrases.count == 1, let phrase = section.phrases.first else {
            return false
        }

        return normalizedDisplayText(phrase.vietnamese) == normalizedDisplayText(page.title)
            && normalizedDisplayText(phrase.english) == normalizedDisplayText(page.englishTitle)
    }

    private static func isHeroMeaningRepeat(_ section: PhraseArticleSection, page: PhraseArticlePage) -> Bool {
        let duplicateSectionTitles: Set<String> = ["Meaning", "At a glance"]
        guard duplicateSectionTitles.contains(section.title),
              section.phrases.isEmpty,
              section.breakdown.isEmpty,
              section.chips.isEmpty
        else {
            return false
        }

        let body = normalizedSentenceText(section.body)
        let title = normalizedSentenceText(page.title)
        let english = normalizedSentenceText(page.englishTitle)
        let summary = normalizedSentenceText(page.summary)

        guard !body.isEmpty, !english.isEmpty else {
            return false
        }

        if body == english {
            return true
        }

        if !summary.isEmpty, summary == english, body == summary {
            return true
        }

        if !title.isEmpty {
            let directMeaning = "\(title) means \(english)"
            let compactPair = "\(title) \(english)"
            if body == directMeaning || body == compactPair {
                return true
            }

            if body.hasPrefix("\(title) means "), body.contains(english) {
                return true
            }
        }

        let bodyWordCount = body.split(separator: " ").count
        let englishWordCount = english.split(separator: " ").count
        return body.hasPrefix(english) && bodyWordCount <= max(4, englishWordCount + 2)
    }

    private static func normalizedDisplayText(_ value: String) -> String {
        value
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
            .replacingOccurrences(of: "’", with: "'")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func normalizedSentenceText(_ value: String) -> String {
        let folded = value
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "d")
            .replacingOccurrences(of: "’", with: "'")
            .replacingOccurrences(of: "“", with: "\"")
            .replacingOccurrences(of: "”", with: "\"")
            .lowercased()
            .replacingOccurrences(of: #"[^a-z0-9]+"#, with: " ", options: .regularExpression)

        return folded
            .split(separator: " ")
            .joined(separator: " ")
    }

    @MainActor
    private func applyInitialScrollTargetIfNeeded(_ scrollProxy: ScrollViewProxy) async {
        guard !didApplyInitialScrollTarget, let initialScrollTarget else {
            return
        }

        let scrollID: String?
        let anchor: UnitPoint

        switch initialScrollTarget {
        case .firstBreakdown:
            scrollID = visibleSections.first { !$0.breakdown.isEmpty }?.id
            anchor = .center
        case .catalogExplore:
            scrollID = shouldRenderCatalogExplore ? Self.catalogExploreID : visibleSections.last?.id
            anchor = .top
        }

        guard let scrollID else {
            return
        }

        try? await Task.sleep(nanoseconds: 900_000_000)
        guard !Task.isCancelled else {
            return
        }
        scrollProxy.scrollTo(scrollID, anchor: anchor)
        didApplyInitialScrollTarget = true
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

    @ViewBuilder
    private var heroBadge: some View {
        if page.id == PhrasePage.xinChao.id {
            ZStack {
                Circle().fill(Color.red)
                Image(systemName: "star.fill")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(.yellow)
            }
            .frame(width: 22, height: 22)
        } else {
            Image(systemName: page.iconName)
                .font(.caption.weight(.bold))
                .foregroundStyle(page.tintName.color)
                .frame(width: 22, height: 22)
                .nativeGlass(cornerRadius: 11)
        }
    }

    private var fixedBackButton: some View {
        Button {
            onBackTapped()
        } label: {
            Image(systemName: "chevron.left")
                .font(.title3.weight(.semibold))
                .frame(width: 52, height: 52)
                .foregroundStyle(.primary)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .nativeGlass(cornerRadius: 26, interactive: true)
    }

}

struct PhrasePhotoBackdropImmersiveChromePreferenceKey: PreferenceKey {
    static var defaultValue = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value || nextValue()
    }
}

struct PhrasePhotoBackdropTabBarBackgroundPreferenceKey: PreferenceKey {
    static var defaultValue = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value || nextValue()
    }
}

struct PhrasePhotoBackdropImmersiveImageContext: Equatable {
    let pageID: String
    let imageName: String
    let viewportSize: CGSize
    let safeAreaTop: CGFloat
    let safeAreaBottom: CGFloat
    let imageFrameHeight: CGFloat
    let verticalFocusOffset: CGFloat
}

struct PhrasePhotoBackdropImmersiveImagePreferenceKey: PreferenceKey {
    static var defaultValue: PhrasePhotoBackdropImmersiveImageContext?

    static func reduce(
        value: inout PhrasePhotoBackdropImmersiveImageContext?,
        nextValue: () -> PhrasePhotoBackdropImmersiveImageContext?
    ) {
        value = nextValue() ?? value
    }
}

enum PhrasePhotoBackdropLayout {
    static let bottomReadingClearance: CGFloat = 332
    static let minimumBottomChromeBackdropHeight: CGFloat = 196
    static let minimumBottomChromeBackdropOffset: CGFloat = 92
    static let sheetCornerClearance: CGFloat = 44
    static let immersiveDissolveDuration = 0.18
    static let immersiveDissolveAnimation: Animation = .easeInOut(duration: immersiveDissolveDuration)
    private static let standardBackdropVerticalOverscan: CGFloat = 160
    private static let backdropOffsetUpdateStep: CGFloat = 16

    static func supportsCityListingPage(pageID: String, heroImageName: String?) -> Bool {
        guard let heroImageName, heroImageName != "HeroCompactPhraseMasthead" else {
            return false
        }

        let isCityPage = pageID.hasPrefix("viet-family-city-") || pageID.hasPrefix("viet-phrase-city-")
        return isCityPage && heroImageName.hasPrefix("HeroCity")
    }

    static func supportsMenuListingPage(pageID: String, heroImageName: String?) -> Bool {
        guard let heroImageName, heroImageName != "HeroCompactPhraseMasthead" else {
            return false
        }

        let isMenuPage = pageID.hasPrefix("viet-menu-")
        return isMenuPage && heroImageName.hasPrefix("BackdropMenu")
    }

    static func supportsCategoryListingPage(pageID: String, heroImageName: String?) -> Bool {
        guard let heroImageName, heroImageName != "HeroCompactPhraseMasthead" else {
            return false
        }

        return !pageID.hasPrefix("viet-menu-") && heroImageName.hasPrefix("HeroCategory")
    }

    static func supportsListingPage(pageID: String, heroImageName: String?) -> Bool {
        supportsCityListingPage(pageID: pageID, heroImageName: heroImageName)
            || supportsMenuListingPage(pageID: pageID, heroImageName: heroImageName)
            || supportsCategoryListingPage(pageID: pageID, heroImageName: heroImageName)
    }

    static func backdropFrameHeight(
        for size: CGSize,
        safeAreaInsets: EdgeInsets,
        pageID: String,
        heroImageName: String?
    ) -> CGFloat {
        let height = max(size.height, 1)

        if supportsMenuListingPage(pageID: pageID, heroImageName: heroImageName) {
            return height + safeAreaInsets.bottom
        }

        return height + safeAreaInsets.top + safeAreaInsets.bottom + standardBackdropVerticalOverscan
    }

    static func backdropVerticalFocusOffset(
        for size: CGSize,
        pageID: String,
        heroImageName: String?
    ) -> CGFloat {
        0
    }

    struct Metrics {
        let initialAnchorOffset: CGFloat
        let initialContentTop: CGFloat
        let collapsedContentTop: CGFloat
        let revealImmersiveOffset: CGFloat
    }

    static func metrics(for size: CGSize) -> Metrics {
        let height = max(size.height, 1)
        let collapsedPeek = min(max(height * 0.11, 78), 104)
        let collapsedContentTop = max(height - collapsedPeek, 0)
        let preferredInitialTop = max(height * 0.25, 210)
        let initialContentTop = min(preferredInitialTop, max(collapsedContentTop - 72, 0))

        return Metrics(
            initialAnchorOffset: max(collapsedContentTop - initialContentTop, 0),
            initialContentTop: initialContentTop,
            collapsedContentTop: collapsedContentTop,
            revealImmersiveOffset: 24
        )
    }

    static func isImageTap(
        _ location: CGPoint,
        scrollOffset: CGFloat,
        metrics: Metrics
    ) -> Bool {
        let sheetTop = max(metrics.collapsedContentTop - scrollOffset, 0)
        return location.y >= 0 && location.y <= sheetTop
    }

    static func bottomChromeBackdropHeight(safeAreaBottom: CGFloat) -> CGFloat {
        max(safeAreaBottom + 162, minimumBottomChromeBackdropHeight)
    }

    static func bottomChromeBackdropOffset(safeAreaBottom: CGFloat) -> CGFloat {
        max(safeAreaBottom + 58, minimumBottomChromeBackdropOffset)
    }

    static func bottomChromeBackdropVisibleHeight(safeAreaBottom: CGFloat) -> CGFloat {
        bottomChromeBackdropHeight(safeAreaBottom: safeAreaBottom)
            - bottomChromeBackdropOffset(safeAreaBottom: safeAreaBottom)
    }

    static func quantizedBackdropOffset(for offset: CGFloat) -> CGFloat {
        guard offset > 0 else {
            return 0
        }

        return (offset / backdropOffsetUpdateStep).rounded() * backdropOffsetUpdateStep
    }
}

struct PhotoBackdropBottomChromeBacking: View {
    let height: CGFloat

    var body: some View {
        Color.clear
            .frame(height: height)
    }
}

private struct PhraseHeroImagePresentation: Identifiable, Equatable {
    let pageID: String
    let imageName: String
    let title: String
    let subtitle: String

    var id: String { pageID }
}

private struct PhraseHeroImageLightbox: View {
    let presentation: PhraseHeroImagePresentation
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            Color.black
                .ignoresSafeArea()

            ZoomableAssetImageView(
                imageName: presentation.imageName,
                accessibilityIdentifier: "PhraseArticle.HeroImageLightbox.Image.\(presentation.pageID)",
                accessibilityLabel: "\(presentation.title) photo",
                onVerticalSwipe: {
                    dismiss()
                }
            )
                .ignoresSafeArea()

            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(presentation.title)
                        .font(.headline.weight(.black))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)

                    Text(presentation.subtitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.72))
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)
                }
                .layoutPriority(1)

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline.weight(.black))
                        .foregroundStyle(.white)
                        .frame(width: 46, height: 46)
                        .background(.ultraThinMaterial, in: Circle())
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close image")
                .accessibilityIdentifier("PhraseArticle.HeroImageLightbox.Close")
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
        }
        .statusBarHidden()
    }
}

private struct ZoomableAssetImageView: UIViewRepresentable {
    let imageName: String
    let accessibilityIdentifier: String
    let accessibilityLabel: String
    let onVerticalSwipe: () -> Void

    func makeUIView(context: Context) -> AssetImageZoomScrollView {
        let scrollView = AssetImageZoomScrollView()
        scrollView.onVerticalSwipe = onVerticalSwipe
        scrollView.configure(
            imageName: imageName,
            accessibilityIdentifier: accessibilityIdentifier,
            accessibilityLabel: accessibilityLabel
        )
        return scrollView
    }

    func updateUIView(_ scrollView: AssetImageZoomScrollView, context: Context) {
        scrollView.onVerticalSwipe = onVerticalSwipe
        scrollView.configure(
            imageName: imageName,
            accessibilityIdentifier: accessibilityIdentifier,
            accessibilityLabel: accessibilityLabel
        )
    }
}

private final class AssetImageZoomScrollView: UIScrollView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    var onVerticalSwipe: (() -> Void)?

    private let imageView = UIImageView()
    private var loadedImageName: String?
    private lazy var verticalDismissPanRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handleVerticalDismissPan(_:)))
        recognizer.cancelsTouchesInView = false
        recognizer.maximumNumberOfTouches = 1
        recognizer.delegate = self
        return recognizer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        delegate = self
        minimumZoomScale = 1
        maximumZoomScale = 4
        bouncesZoom = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never

        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        addSubview(imageView)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
        addGestureRecognizer(verticalDismissPanRecognizer)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(imageName: String, accessibilityIdentifier: String, accessibilityLabel: String) {
        isAccessibilityElement = true
        self.accessibilityIdentifier = accessibilityIdentifier
        self.accessibilityLabel = accessibilityLabel
        accessibilityTraits = [.image, .allowsDirectInteraction]

        guard loadedImageName != imageName else {
            return
        }

        loadedImageName = imageName
        imageView.image = UIImage(named: imageName)
        zoomScale = minimumZoomScale
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if zoomScale == minimumZoomScale {
            imageView.frame = bounds
        }

        centerImageIfNeeded()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageIfNeeded()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer === verticalDismissPanRecognizer || otherGestureRecognizer === verticalDismissPanRecognizer
    }

    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if zoomScale > minimumZoomScale {
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            let point = gesture.location(in: imageView)
            let targetScale = min(maximumZoomScale, 2.6)
            let size = CGSize(width: bounds.width / targetScale, height: bounds.height / targetScale)
            let origin = CGPoint(x: point.x - size.width / 2, y: point.y - size.height / 2)
            zoom(to: CGRect(origin: origin, size: size), animated: true)
        }
    }

    @objc private func handleVerticalDismissPan(_ gesture: UIPanGestureRecognizer) {
        guard gesture.state == .ended, zoomScale <= minimumZoomScale + 0.01 else {
            return
        }

        let translation = gesture.translation(in: self)
        let velocity = gesture.velocity(in: self)
        let isMostlyVertical = abs(translation.y) > abs(translation.x) * 1.25
        let movedEnough = abs(translation.y) > 96
        let flungEnough = abs(velocity.y) > 900 && abs(translation.y) > 32

        if isMostlyVertical && (movedEnough || flungEnough) {
            onVerticalSwipe?()
        }
    }

    private func centerImageIfNeeded() {
        let boundsSize = bounds.size
        var frame = imageView.frame

        frame.origin.x = frame.size.width < boundsSize.width ? (boundsSize.width - frame.size.width) / 2 : 0
        frame.origin.y = frame.size.height < boundsSize.height ? (boundsSize.height - frame.size.height) / 2 : 0
        imageView.frame = frame
    }
}

private struct ArticleSectionView: View {
    let section: PhraseArticleSection
    let currentPageID: String
    let onOpenDetail: (String) -> Void

    var body: some View {
        switch section.presentation {
        case .breakdownStrip:
            breakdownSection
        case .menuChips:
            menuChipsSection
        case .relationshipShelf:
            relationshipShelfSection
        case .horizontalPhraseCards:
            horizontalCardsSection
        case .phraseList:
            phraseListSection
        case .tipCallout:
            ArticleCallout(
                title: section.title,
                text: section.body,
                symbolName: "sparkles",
                tint: .orange
            )
        case .warningCallout:
            ArticleCallout(
                title: section.title,
                text: section.body,
                symbolName: "exclamationmark.triangle.fill",
                tint: .orange
            )
        case .plainText, .automatic:
            plainTextSection
        }
    }

    private var relationshipPhraseGroups: [[PhraseOption]] {
        section.phrases.chunked(into: ExploreCatalogLayout.itemsPerGroup)
    }

    private var relationshipShelfHeight: CGFloat {
        ExploreCatalogLayout.groupHeight(for: Swift.min(section.phrases.count, ExploreCatalogLayout.itemsPerGroup))
    }

    private var plainTextSection: some View {
        SectionBlock(title: section.title) {
            DefinedBodyText(text: section.body, definitions: section.inlineDefinitions)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var relationshipShelfSection: some View {
        SectionBlock(title: section.title, leadIn: section.body.nilIfEmpty) {
            if section.phrases.isEmpty {
                Text(section.body)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                GeometryReader { proxy in
                    let groupWidth = max(260, min(326, proxy.size.width - 42))

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: ExploreCatalogLayout.groupSpacing) {
                            ForEach(Array(relationshipPhraseGroups.enumerated()), id: \.offset) { _, group in
                                RelationshipPhraseGroupCard(
                                    phrases: group,
                                    width: groupWidth,
                                    currentPageID: currentPageID,
                                    onOpenDetail: onOpenDetail
                                )
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollClipDisabled()
                }
                .frame(height: relationshipShelfHeight)
            }
        }
    }

    private var phraseListSection: some View {
        SectionBlock(title: section.title, leadIn: section.body.nilIfEmpty) {
            if section.phrases.isEmpty {
                Text(section.body)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                VStack(spacing: 0) {
                    ForEach(section.phrases) { phrase in
                        LocalGreetingRow(
                            phrase: phrase,
                            currentPageID: currentPageID,
                            onOpenDetail: onOpenDetail
                        )

                        if phrase.id != section.phrases.last?.id {
                            Divider().padding(.leading, 70)
                        }
                    }
                }
                .padding(.vertical, 8)
                .phraseListCard()
            }
        }
    }

    private var horizontalCardsSection: some View {
        SectionBlock(title: section.title, leadIn: section.body.nilIfEmpty) {
            if section.phrases.isEmpty {
                Text(section.body)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(section.phrases) { phrase in
                            SituationCard(
                                phrase: phrase,
                                currentPageID: currentPageID,
                                onOpenDetail: onOpenDetail
                            )
                        }
                    }
                    .padding(.horizontal, 2)
                    .padding(.bottom, 2)
                }
                .scrollClipDisabled()
            }
        }
    }

    private var breakdownSection: some View {
        SectionBlock(title: section.title, leadIn: section.body.nilIfEmpty) {
            if section.breakdown.isEmpty {
                Text(section.body)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                BreakdownView(tokens: section.breakdown)
            }
        }
    }

    private var menuChipsSection: some View {
        SectionBlock(title: section.title, leadIn: section.body.nilIfEmpty) {
            if section.chips.isEmpty {
                Text(section.body)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                MenuChipFlow(chips: section.chips, sectionID: section.id)
            }
        }
    }
}

private struct MenuChipFlow: View {
    let chips: [String]
    let sectionID: String

    var body: some View {
        MenuChipFlowLayout(horizontalSpacing: 8, verticalSpacing: 8) {
            ForEach(chips, id: \.self) { chip in
                Text(chip)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(PhrasePageStyle.elevatedCardFill, in: Capsule(style: .continuous))
                    .overlay {
                        Capsule(style: .continuous)
                            .stroke(Color.black.opacity(0.06), lineWidth: 1)
                            .allowsHitTesting(false)
                    }
                    .accessibilityIdentifier("MenuDetail.Chip.\(sectionID).\(chip.normalizedMenuChipIdentifier)")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct MenuChipFlowLayout: Layout {
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        guard !sizes.isEmpty else {
            return .zero
        }

        let maxWidth = max(1, proposal.width ?? sizes.reduce(0) { $0 + $1.width + horizontalSpacing })
        let rows = arrangedRows(for: sizes, maxWidth: maxWidth)
        let height = rows.reduce(CGFloat.zero) { partial, row in
            partial + row.height
        } + CGFloat(max(0, rows.count - 1)) * verticalSpacing

        return CGSize(width: maxWidth, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let rows = arrangedRows(for: sizes, maxWidth: bounds.width)
        var y = bounds.minY

        for row in rows {
            var x = bounds.minX
            for index in row.indices {
                subviews[index].place(
                    at: CGPoint(x: x, y: y + (row.height - sizes[index].height) / 2),
                    anchor: .topLeading,
                    proposal: ProposedViewSize(sizes[index])
                )
                x += sizes[index].width + horizontalSpacing
            }
            y += row.height + verticalSpacing
        }
    }

    private func arrangedRows(for sizes: [CGSize], maxWidth: CGFloat) -> [MenuChipFlowRow] {
        var rows: [MenuChipFlowRow] = []
        var current = MenuChipFlowRow(indices: [], width: 0, height: 0)

        for (index, size) in sizes.enumerated() {
            let proposedWidth = current.indices.isEmpty ? size.width : current.width + horizontalSpacing + size.width
            if !current.indices.isEmpty, proposedWidth > maxWidth {
                rows.append(current)
                current = MenuChipFlowRow(indices: [index], width: size.width, height: size.height)
            } else {
                current.indices.append(index)
                current.width = proposedWidth
                current.height = max(current.height, size.height)
            }
        }

        if !current.indices.isEmpty {
            rows.append(current)
        }

        return rows
    }
}

private struct MenuChipFlowRow {
    var indices: [Int]
    var width: CGFloat
    var height: CGFloat
}

private struct ArticleCallout: View {
    let title: String
    let text: String
    let symbolName: String
    let tint: AccentTint

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: symbolName)
                .font(.title2.weight(.semibold))
                .foregroundStyle(tint.color)
                .frame(width: 48, height: 48)
                .nativeGlass(cornerRadius: 24)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.primary)

                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(tint.color.opacity(0.10), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(tint.color.opacity(0.22), lineWidth: 1)
        }
    }
}

private struct DefinedBodyText: View {
    let text: String
    let definitions: [PhraseInlineDefinition]
    @State private var selectedDefinition: PhraseInlineDefinition?

    var body: some View {
        Text(attributedText)
            .contentShape(Rectangle())
            .onTapGesture {
                if definitions.count == 1 {
                    selectedDefinition = definitions[0]
                }
            }
            .environment(\.openURL, OpenURLAction { url in
                guard url.scheme == "speaklocal-definition",
                      let id = url.host(),
                      let definition = definitions.first(where: { $0.id == id })
                else {
                    return .systemAction
                }

                selectedDefinition = definition
                return .handled
            })
            .popover(item: $selectedDefinition) { definition in
                DefinitionPopover(definition: definition)
                    .presentationCompactAdaptation(.popover)
            }
    }

    private var attributedText: AttributedString {
        var attributed = AttributedString(text)
        for definition in definitions {
            var searchStart = attributed.startIndex
            while let range = attributed[searchStart...].range(
                of: definition.vietnamese,
                options: [.caseInsensitive, .diacriticInsensitive]
            ) {
                attributed[range].foregroundColor = .red
                attributed[range].font = .body.weight(.semibold)
                attributed[range].underlineStyle = Text.LineStyle(pattern: .dot)
                attributed[range].underlineColor = UIColor.systemRed.withAlphaComponent(0.75)
                searchStart = range.upperBound
            }
        }
        return attributed
    }
}

private struct DefinitionPopover: View {
    let definition: PhraseInlineDefinition

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(definition.vietnamese)
                .font(.headline.weight(.black))
                .foregroundStyle(.red)

            Text(definition.english)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .presentationCompactAdaptation(.popover)
    }
}

private struct CompactPhraseMastheadBackground: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground

            LinearGradient(
                stops: [
                    .init(color: Color.white.opacity(0.92), location: 0),
                    .init(color: Color.white.opacity(0.72), location: 0.46),
                    .init(color: PhrasePageStyle.pageBackground.opacity(1), location: 1),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea(edges: .top)
    }
}

private struct SectionBlock<Content: View>: View {
    let title: String
    var trailing: String?
    var leadIn: String?
    let content: Content

    init(title: String, trailing: String? = nil, leadIn: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.trailing = trailing
        self.leadIn = leadIn
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: title, trailing: trailing)

            if let leadIn {
                SectionLeadIn(text: leadIn)
                    .padding(.top, PhrasePageStyle.headerToLeadInSpacing)

                content
                    .padding(.top, PhrasePageStyle.leadInToContentSpacing)
            } else {
                content
                    .padding(.top, PhrasePageStyle.headerToContentSpacing)
            }
        }
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }

    var normalizedMenuChipIdentifier: String {
        lowercased()
            .replacingOccurrences(of: "&", with: "and")
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: "-")
    }
}

private struct SectionLeadIn: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .lineSpacing(2)
            .fixedSize(horizontal: false, vertical: true)
    }
}

private struct SectionHeader: View {
    let title: String
    var trailing: String?

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.headline.weight(.bold))
                .foregroundStyle(.primary)

            Spacer()

            if let trailing {
                Text(trailing)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.red)
            }
        }
    }
}

private struct PhraseRow: View {
    let phrase: PhraseOption
    let onOpenDetail: (String) -> Void

    var body: some View {
        HStack(spacing: 12) {
            AudioSpeakerButton(tint: phrase.tintName, audioKey: phrase.playbackAudioKey)

            if let detailPageID = phrase.detailPageID {
                Button {
                    onOpenDetail(detailPageID)
                } label: {
                    rowContent
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            } else {
                rowContent
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
    }

    private var rowContent: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(phrase.vietnamese)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                PannableLineText(text: phrase.english, font: .subheadline, color: .secondary)
                    .frame(height: 20)
            }

            Spacer()
        }
    }
}

private struct SituationCard: View {
    let phrase: PhraseOption
    let currentPageID: String
    let onOpenDetail: (String) -> Void

    private var destinationPageID: String? {
        PhraseRowNavigation.destinationPageID(for: phrase.detailPageID, currentPageID: currentPageID)
    }

    var body: some View {
        VStack(spacing: 10) {
            if let destinationPageID {
                Button {
                    onOpenDetail(destinationPageID)
                } label: {
                    cardSummary
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            } else {
                cardSummary
            }

            HStack(spacing: 10) {
                AudioSpeakerButton(tint: phrase.tintName, size: 42, audioKey: phrase.playbackAudioKey)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 16)
        .frame(width: 112, height: 174)
        .phraseListCard(strokeOpacity: 0.05)
        .softAmbientCardShadow()
    }

    private var cardSummary: some View {
        VStack(spacing: 10) {
            Image(systemName: phrase.symbolName)
                .font(.system(size: 29, weight: .regular))
                .foregroundStyle(phrase.tintName.color)
                .frame(height: 34)

            VStack(spacing: 3) {
                Text(phrase.vietnamese)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)

                Text(phrase.english)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(0.78)
            }
            .frame(height: 54)
        }
        .contentShape(Rectangle())
    }
}

private struct LocalGreetingRow: View {
    let phrase: PhraseOption
    let currentPageID: String
    let onOpenDetail: (String) -> Void

    private var destinationPageID: String? {
        PhraseRowNavigation.destinationPageID(for: phrase.detailPageID, currentPageID: currentPageID)
    }

    var body: some View {
        HStack(spacing: 12) {
            AudioSpeakerButton(tint: phrase.tintName, audioKey: phrase.playbackAudioKey)

            if let destinationPageID {
                Button {
                    onOpenDetail(destinationPageID)
                } label: {
                    rowContent
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            } else {
                rowContent
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
    }

    private var rowContent: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
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

            Spacer()
        }
    }
}

struct BreakdownView: View {
    let tokens: [BreakdownToken]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: BreakdownLayout.cardSpacing) {
                ForEach(Array(tokens.enumerated()), id: \.element.id) { index, token in
                    BreakdownTokenCard(
                        token: token,
                        width: tokenWidth(for: token, index: index)
                    )

                    if let separator = Self.separator(afterTokenAt: index, tokenCount: tokens.count) {
                        Text(separator)
                            .font(.title.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .frame(width: BreakdownLayout.separatorWidth)
                    }
                }
            }
            .padding(.leading, BreakdownLayout.horizontalPadding)
            .padding(.trailing, BreakdownLayout.trailingPadding(tokenCount: tokens.count))
            .padding(.vertical, 2)
        }
        .scrollClipDisabled()
    }

    static func separator(afterTokenAt index: Int, tokenCount: Int) -> String? {
        guard index >= 0, index < tokenCount - 1 else {
            return nil
        }

        return index == tokenCount - 2 ? "=" : "+"
    }

    private func tokenWidth(for token: BreakdownToken, index: Int) -> CGFloat {
        BreakdownLayout.cardWidth(
            longestTextCount: max(token.vietnamese.count, token.english.count),
            index: index,
            tokenCount: tokens.count
        )
    }
}

enum BreakdownLayout {
    static let cardSpacing: CGFloat = 9
    static let separatorWidth: CGFloat = 28
    static let horizontalPadding: CGFloat = 2
    static let multiCardPeekPadding: CGFloat = 48
    static let singleCardTrailingPadding: CGFloat = 2
    static let nonFinalMinimumWidth: CGFloat = 138
    static let nonFinalMaximumWidth: CGFloat = 188
    static let finalMinimumWidth: CGFloat = 188
    static let finalMaximumWidth: CGFloat = 252

    static func trailingPadding(tokenCount: Int) -> CGFloat {
        tokenCount > 1 ? multiCardPeekPadding : singleCardTrailingPadding
    }

    static func cardWidth(longestTextCount: Int, index: Int, tokenCount: Int) -> CGFloat {
        let baseWidth = CGFloat(longestTextCount) * 7 + 58

        if index == tokenCount - 1 {
            return min(max(baseWidth, finalMinimumWidth), finalMaximumWidth)
        }

        return min(max(baseWidth, nonFinalMinimumWidth), nonFinalMaximumWidth)
    }
}

private struct BreakdownTokenCard: View {
    let token: BreakdownToken
    let width: CGFloat
    @AppStorage(AudioPlaybackPreference.speedKey) private var selectedSpeed = AudioPlaybackPreference.defaultSpeed

    private var resolvedAudioKey: String? {
        token.playbackAudioKey
    }

    @ViewBuilder
    var body: some View {
        if let resolvedAudioKey {
            Button {
                AudioPlaybackService.shared.play(audioKey: resolvedAudioKey, rate: selectedRate)
            } label: {
                cardContent
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Play \(token.vietnamese)")
            .accessibilityIdentifier("Breakdown.Audio.\(token.id)")
            .accessibilityAddTraits(.isButton)
        } else {
            cardContent
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(token.vietnamese), audio not available yet")
        }
    }

    private var selectedRate: Double {
        AudioPlaybackPreference.rate(for: selectedSpeed)
    }

    private var cardContent: some View {
        VStack(spacing: 6) {
            Text(token.vietnamese)
                .font(.headline.weight(.black))
                .foregroundStyle(.red)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.84)
                .fixedSize(horizontal: false, vertical: true)

            Text(token.english)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.82)
                .fixedSize(horizontal: false, vertical: true)

            if resolvedAudioKey != nil {
                BreakdownTokenAudioIndicator()
                    .padding(.top, 1)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .frame(width: width)
        .frame(minHeight: 112)
        .phraseListCard(cornerRadius: 16, strokeOpacity: 0.05)
    }
}

private struct BreakdownTokenAudioIndicator: View {
    private let size: CGFloat = 30

    var body: some View {
        Image(systemName: "speaker.wave.2.fill")
            .font(.system(size: size * 0.36, weight: .semibold))
            .foregroundStyle(AccentTint.red.audioColor)
            .frame(width: size, height: size)
            .nativeGlass(cornerRadius: size / 2, interactive: true)
    }
}

private struct CulturalNote: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "sparkles")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.orange)
                .frame(width: 48, height: 48)
                .nativeGlass(cornerRadius: 24)

            VStack(alignment: .leading, spacing: 5) {
                Text("Cultural note")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.primary)
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
            }
        }
        .padding(16)
        .background(Color.orange.opacity(0.10), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.orange.opacity(0.22), lineWidth: 1)
        }
    }
}

struct ExploreCatalogSection: View {
    let currentPageID: String
    let onOpenDetail: (String) -> Void
    private let sections: [PhraseCatalogSection]
    private let title: String

    init(currentPageID: String, onOpenDetail: @escaping (String) -> Void) {
        self.currentPageID = currentPageID
        self.onOpenDetail = onOpenDetail
        self.sections = Self.sections(forPageID: currentPageID)
        self.title = Self.browseTitle(forPageID: currentPageID)
    }

    static func sections(forPageID pageID: String) -> [PhraseCatalogSection] {
        let currentCategoryIDs = PhraseCatalog.categoryIDs(forPageID: pageID)
        let semanticCategoryIDs = currentCategoryIDs.filter(Self.isRenderedExploreCategory)
        let preferredCategoryIDs = semanticCategoryIDs
            .sorted { lhs, rhs in
                let lhsRank = Self.categoryDisplayRank(lhs)
                let rhsRank = Self.categoryDisplayRank(rhs)

                if lhsRank != rhsRank {
                    return lhsRank < rhsRank
                }

                return lhs < rhs
            }
            .prefix(Self.maxRenderedSections)

        let preferredSections = Array(preferredCategoryIDs).compactMap { categoryID in
            Self.section(
                for: categoryID,
                currentPageID: pageID,
                currentCategoryIDs: Set(semanticCategoryIDs)
            )
        }

        if !preferredSections.isEmpty {
            return preferredSections
        }

        return fallbackSection(forPageID: pageID)
            .map { [$0] }
            ?? []
    }

    static func browseTitle(forPageID pageID: String) -> String {
        let categoryIDs = Set(PhraseCatalog.categoryIDs(forPageID: pageID))

        if categoryIDs.contains("derived-place-phrases") {
            if categoryIDs.contains("danang") { return "More Da Nang phrases" }
            if categoryIDs.contains("hanoi") { return "More Hanoi phrases" }
            if categoryIDs.contains("hcmc") { return "More Ho Chi Minh City phrases" }
            if categoryIDs.contains("hoian") { return "More Hoi An phrases" }
            if categoryIDs.contains("hue") { return "More Hue phrases" }
            return "Related phrases"
        }

        if categoryIDs.contains("restaurants") { return "More restaurant phrases" }
        if categoryIDs.contains("shopping") || categoryIDs.contains("shopping-markets") { return "More shopping phrases" }
        if categoryIDs.contains("landmarks-attractions") { return "More place phrases" }
        if categoryIDs.contains("neighborhoods-streets") { return "More street phrases" }

        return "Browse more"
    }

    private static func section(
        for categoryID: String,
        currentPageID: String,
        currentCategoryIDs: Set<String>
    ) -> PhraseCatalogSection? {
        guard let category = PhraseCatalog.category(withID: categoryID)
            ?? fallbackExploreCategory(for: categoryID)
        else {
            return nil
        }

        let items = rankedItems(
            for: categoryID,
            currentPageID: currentPageID,
            currentCategoryIDs: currentCategoryIDs
        )

        guard !items.isEmpty else {
            return nil
        }

        return PhraseCatalogSection(category: category, items: items)
    }

    var body: some View {
        if sections.isEmpty {
            ExploreCatalogEmptyState()
        } else {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: title)

                LazyVStack(alignment: .leading, spacing: ExploreCatalogLayout.sectionSpacing) {
                    ForEach(sections) { section in
                        ExploreCatalogCategoryShelf(section: section, onOpenDetail: onOpenDetail)
                    }
                }
            }
        }
    }

    private static let maxRenderedSections = 2
    private static let maxRenderedItemsPerSection = 6

    private static let suppressedExploreCategoryIDs: Set<String> = [
        "all",
        "beginner",
        "premium",
        "city-guides",
        "city-phrases",
        "city-page-kind-phrase",
        "city-page-kind-place",
        "derived-place-phrases",
        "actual-landmarks",
        "editorial-pilot",
        "journey-page",
    ]

    private static let cityCategoryIDs: Set<String> = [
        "danang",
        "hanoi",
        "hcmc",
        "hoian",
        "hue",
    ]

    private static let fallbackExploreCategories: [String: PhraseCategory] = [
        "danang": PhraseCategory(id: "danang", title: "Da Nang", symbolName: "building.2.fill", tintName: .teal),
        "hanoi": PhraseCategory(id: "hanoi", title: "Hanoi", symbolName: "building.2.fill", tintName: .red),
        "hcmc": PhraseCategory(id: "hcmc", title: "Ho Chi Minh City", symbolName: "building.2.fill", tintName: .blue),
        "hoian": PhraseCategory(id: "hoian", title: "Hoi An", symbolName: "building.2.fill", tintName: .orange),
        "hue": PhraseCategory(id: "hue", title: "Hue", symbolName: "building.2.fill", tintName: .purple),
        "arrivals-routes": PhraseCategory(id: "arrivals-routes", title: "Arrivals and routes", symbolName: "car.fill", tintName: .blue),
        "landmarks-attractions": PhraseCategory(id: "landmarks-attractions", title: "Landmarks and attractions", symbolName: "signpost.right.fill", tintName: .teal),
        "neighborhoods-streets": PhraseCategory(id: "neighborhoods-streets", title: "Neighborhoods and streets", symbolName: "map.fill", tintName: .teal),
        "food-coffee": PhraseCategory(id: "food-coffee", title: "Food and cafes", symbolName: "fork.knife", tintName: .green),
        "shopping-markets": PhraseCategory(id: "shopping-markets", title: "Shopping and markets", symbolName: "bag.fill", tintName: .orange),
        "practical-help-near-places": PhraseCategory(id: "practical-help-near-places", title: "Nearby help", symbolName: "cross.case.fill", tintName: .blue),
    ]

    private static func isRenderedExploreCategory(_ categoryID: String) -> Bool {
        if suppressedExploreCategoryIDs.contains(categoryID) {
            return false
        }

        if categoryID.hasPrefix("difficulty-")
            || categoryID.hasPrefix("practice-")
            || categoryID.hasPrefix("place-kind-")
            || categoryID.hasPrefix("ba-na-hills-") {
            return false
        }

        return true
    }

    private static func fallbackExploreCategory(for categoryID: String) -> PhraseCategory? {
        fallbackExploreCategories[categoryID]
    }

    private static func fallbackSection(forPageID pageID: String) -> PhraseCatalogSection? {
        let defaultCategoryID = PhraseCatalog.defaultCategoryID(forPageID: pageID)
        let fallbackCategoryID = PhraseCatalog.category(withID: defaultCategoryID) == nil
            ? "greetings"
            : defaultCategoryID

        return section(
            for: fallbackCategoryID,
            currentPageID: pageID,
            currentCategoryIDs: []
        )
    }

    private static func categoryDisplayRank(_ categoryID: String) -> Int {
        cityCategoryIDs.contains(categoryID) ? 20 : 0
    }

    private static func rankedItems(
        for categoryID: String,
        currentPageID: String,
        currentCategoryIDs: Set<String>
    ) -> [PhraseCatalogItem] {
        PhraseCatalog.items(selectedCategoryID: categoryID, excludingPageID: currentPageID)
            .filter { item in
                !item.categoryIDs.contains("derived-place-phrases")
            }
            .enumerated()
            .sorted { lhs, rhs in
                let lhsScore = relevanceScore(for: lhs.element, currentCategoryIDs: currentCategoryIDs)
                let rhsScore = relevanceScore(for: rhs.element, currentCategoryIDs: currentCategoryIDs)

                if lhsScore != rhsScore {
                    return lhsScore > rhsScore
                }

                return lhs.offset < rhs.offset
            }
            .prefix(maxRenderedItemsPerSection)
            .map(\.element)
    }

    private static func relevanceScore(
        for item: PhraseCatalogItem,
        currentCategoryIDs: Set<String>
    ) -> Int {
        Set(item.categoryIDs).intersection(currentCategoryIDs).count
    }
}

enum ExploreCatalogLayout {
    static let itemsPerGroup = 3
    static let sectionSpacing: CGFloat = 28
    static let groupSpacing: CGFloat = 12
    static let rowHeight: CGFloat = 86
    static let groupVerticalPadding: CGFloat = 8
    static let rowSubtitleLineLimit = 2

    static func groupHeight(for itemCount: Int) -> CGFloat {
        let visibleRows = max(1, min(itemCount, itemsPerGroup))
        return (rowHeight * CGFloat(visibleRows)) + (groupVerticalPadding * 2)
    }

    static var fullGroupHeight: CGFloat {
        groupHeight(for: itemsPerGroup)
    }
}

private struct ExploreCatalogCategoryShelf: View {
    let section: PhraseCatalogSection
    let onOpenDetail: (String) -> Void

    private var itemGroups: [[PhraseCatalogItem]] {
        section.items.chunked(into: ExploreCatalogLayout.itemsPerGroup)
    }

    private var shelfHeight: CGFloat {
        ExploreCatalogLayout.groupHeight(for: Swift.min(section.items.count, ExploreCatalogLayout.itemsPerGroup))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 5) {
                    Text(section.category.title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Image(systemName: "chevron.right")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
            }

            GeometryReader { proxy in
                let groupWidth = max(260, min(326, proxy.size.width - 42))

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: ExploreCatalogLayout.groupSpacing) {
                        ForEach(Array(itemGroups.enumerated()), id: \.offset) { _, group in
                            ExploreCatalogGroupCard(
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
            .frame(height: shelfHeight)
        }
    }

    private var subtitle: String {
        switch section.category.id {
        case "greetings":
            return "Core hellos, polite openers, and first words"
        case "local-greetings":
            return "Pronoun-based greetings for anh, chị, em, ông, bà"
        case "politeness":
            return "Softer ways to sound respectful"
        case "attention":
            return "Get someone's attention without sounding abrupt"
        case "small-talk":
            return "Natural openers for casual conversation"
        case "phone":
            return "Phrases that make calls easier"
        case "time":
            return "Timing, schedules, and daily moments"
        case "meeting":
            return "Friendly ways to start meeting someone"
        case "gratitude":
            return "Thanks, apologies, and warm closers"
        case "repair":
            return "Keep the conversation moving with simple helper phrases"
        case "understanding-repair":
            return "Ask what it means, slow things down, or get it written"
        case "danang":
            return "Places, streets, and phrases around Da Nang"
        case "hanoi":
            return "Places, food, and phrases around Hanoi"
        case "hcmc":
            return "Places, restaurants, and phrases around Ho Chi Minh City"
        case "hoian":
            return "Places, food, and phrases around Hoi An"
        case "hue":
            return "Places, food, and phrases around Hue"
        case "landmarks-attractions":
            return "Names and sentences for places worth visiting"
        case "restaurants":
            return "Table, menu, order, and payment phrases"
        case "shopping", "shopping-markets":
            return "Prices, sizes, payment, and returns"
        case "goodbyes":
            return "Leave conversations cleanly"
        default:
            return "Useful phrases for this travel moment"
        }
    }
}

private struct ExploreCatalogGroupCard: View {
    let items: [PhraseCatalogItem]
    let width: CGFloat
    let onOpenDetail: (String) -> Void

    private var cardHeight: CGFloat {
        ExploreCatalogLayout.groupHeight(for: items.count)
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(items) { item in
                ExploreCatalogRow(item: item, onOpenDetail: onOpenDetail)
                    .frame(height: ExploreCatalogLayout.rowHeight)

                if item.id != items.last?.id {
                    Divider().padding(.leading, 70)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, ExploreCatalogLayout.groupVerticalPadding)
        .frame(width: width, height: cardHeight, alignment: .top)
        .phraseListCard(cornerRadius: PhrasePageStyle.compactCardCornerRadius)
    }
}

private struct RelationshipPhraseGroupCard: View {
    let phrases: [PhraseOption]
    let width: CGFloat
    let currentPageID: String
    let onOpenDetail: (String) -> Void

    private var cardHeight: CGFloat {
        ExploreCatalogLayout.groupHeight(for: phrases.count)
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(phrases) { phrase in
                LocalGreetingRow(
                    phrase: phrase,
                    currentPageID: currentPageID,
                    onOpenDetail: onOpenDetail
                )
                    .frame(height: ExploreCatalogLayout.rowHeight)

                if phrase.id != phrases.last?.id {
                    Divider().padding(.leading, 70)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, ExploreCatalogLayout.groupVerticalPadding)
        .frame(width: width, height: cardHeight, alignment: .top)
        .phraseListCard(cornerRadius: PhrasePageStyle.compactCardCornerRadius)
    }
}

enum PhraseRowNavigation {
    static func destinationPageID(for detailPageID: String?, currentPageID: String) -> String? {
        guard let detailPageID else {
            return nil
        }

        let canonicalDestination = PhraseCatalog.canonicalPageID(forOpenablePageID: detailPageID) ?? detailPageID
        let canonicalCurrent = PhraseCatalog.canonicalPageID(forOpenablePageID: currentPageID) ?? currentPageID
        return canonicalDestination == canonicalCurrent ? nil : detailPageID
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

private struct ExploreCatalogRow: View {
    let item: PhraseCatalogItem
    let onOpenDetail: (String) -> Void

    var body: some View {
        HStack(spacing: 0) {
            AudioSpeakerButton(tint: item.tintName, size: 44, audioKey: item.playbackAudioKey)
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
                            .lineLimit(ExploreCatalogLayout.rowSubtitleLineLimit)
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
            .accessibilityIdentifier("ExploreCatalogRow.\(item.pageID)")
            .accessibilityLabel("\(item.title), \(item.subtitle)")
        }
    }
}

private struct ExploreCatalogEmptyState: View {
    var body: some View {
        Text("More phrases will appear here as this collection grows.")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .phraseListCard(cornerRadius: PhrasePageStyle.compactCardCornerRadius)
    }
}

private struct CircleIcon: View {
    let symbol: String
    let tint: AccentTint

    var body: some View {
        Image(systemName: symbol)
            .font(.callout.weight(.semibold))
            .foregroundStyle(tint.color)
            .frame(width: 48, height: 48)
            .nativeGlass(cornerRadius: 24)
    }
}

#Preview {
    AppShellView()
}
