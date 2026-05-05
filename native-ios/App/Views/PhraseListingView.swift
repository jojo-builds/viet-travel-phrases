import SwiftUI

enum PhraseArticleInitialScrollTarget: String {
    case firstBreakdown = "first-breakdown"
    case catalogExplore = "catalog-explore"
}

struct PhraseListingView: View {
    let page: PhrasePage
    let chromeRoute: AppRoute
    let initialScrollTarget: PhraseArticleInitialScrollTarget?
    let scrollToTopTrigger: Int
    let chromeNamespace: Namespace.ID?
    let isSearchActive: Bool
    let showsChrome: Bool
    let isSaved: Bool
    let isInPractice: Bool
    var onBackTapped: () -> Void = {}
    var onSearchTapped: () -> Void = {}
    var onToggleSaved: (() -> Void)? = nil
    var onTogglePractice: (() -> Void)? = nil
    var onDetailTapped: (String) -> Void = { _ in }

    init(
        page: PhrasePage,
        chromeRoute: AppRoute = .phrasePage,
        initialScrollTarget: PhraseArticleInitialScrollTarget? = nil,
        scrollToTopTrigger: Int = 0,
        chromeNamespace: Namespace.ID? = nil,
        isSearchActive: Bool = false,
        showsChrome: Bool = true,
        isSaved: Bool = false,
        isInPractice: Bool = false,
        onBackTapped: @escaping () -> Void = {},
        onSearchTapped: @escaping () -> Void = {},
        onToggleSaved: (() -> Void)? = nil,
        onTogglePractice: (() -> Void)? = nil,
        onDetailTapped: @escaping (String) -> Void = { _ in }
    ) {
        self.page = page
        self.chromeRoute = chromeRoute
        self.initialScrollTarget = initialScrollTarget
        self.scrollToTopTrigger = scrollToTopTrigger
        self.chromeNamespace = chromeNamespace
        self.isSearchActive = isSearchActive
        self.showsChrome = showsChrome
        self.isSaved = isSaved
        self.isInPractice = isInPractice
        self.onBackTapped = onBackTapped
        self.onSearchTapped = onSearchTapped
        self.onToggleSaved = onToggleSaved
        self.onTogglePractice = onTogglePractice
        self.onDetailTapped = onDetailTapped
    }

    var body: some View {
        PhraseArticleTemplateView(
            page: page.articleTemplate,
            chromeRoute: chromeRoute,
            initialScrollTarget: initialScrollTarget,
            scrollToTopTrigger: scrollToTopTrigger,
            chromeNamespace: chromeNamespace,
            isSearchActive: isSearchActive,
            showsChrome: showsChrome,
            isSaved: isSaved,
            isInPractice: isInPractice,
            onBackTapped: onBackTapped,
            onSearchTapped: onSearchTapped,
            onToggleSaved: onToggleSaved,
            onTogglePractice: onTogglePractice,
            onDetailTapped: onDetailTapped
        )
    }
}

struct PhraseArticleTemplateView: View {
    let page: PhraseArticlePage
    let chromeRoute: AppRoute
    let initialScrollTarget: PhraseArticleInitialScrollTarget?
    let scrollToTopTrigger: Int
    let chromeNamespace: Namespace.ID?
    let isSearchActive: Bool
    let showsChrome: Bool
    let isSaved: Bool
    let isInPractice: Bool
    var onBackTapped: () -> Void = {}
    var onSearchTapped: () -> Void = {}
    var onToggleSaved: (() -> Void)? = nil
    var onTogglePractice: (() -> Void)? = nil
    var onDetailTapped: (String) -> Void = { _ in }
    @State private var didApplyInitialScrollTarget = false

    init(
        page: PhraseArticlePage,
        chromeRoute: AppRoute,
        initialScrollTarget: PhraseArticleInitialScrollTarget? = nil,
        scrollToTopTrigger: Int = 0,
        chromeNamespace: Namespace.ID? = nil,
        isSearchActive: Bool = false,
        showsChrome: Bool = true,
        isSaved: Bool = false,
        isInPractice: Bool = false,
        onBackTapped: @escaping () -> Void = {},
        onSearchTapped: @escaping () -> Void = {},
        onToggleSaved: (() -> Void)? = nil,
        onTogglePractice: (() -> Void)? = nil,
        onDetailTapped: @escaping (String) -> Void = { _ in }
    ) {
        self.page = page
        self.chromeRoute = chromeRoute
        self.initialScrollTarget = initialScrollTarget
        self.scrollToTopTrigger = scrollToTopTrigger
        self.chromeNamespace = chromeNamespace
        self.isSearchActive = isSearchActive
        self.showsChrome = showsChrome
        self.isSaved = isSaved
        self.isInPractice = isInPractice
        self.onBackTapped = onBackTapped
        self.onSearchTapped = onSearchTapped
        self.onToggleSaved = onToggleSaved
        self.onTogglePractice = onTogglePractice
        self.onDetailTapped = onDetailTapped
    }

    var body: some View {
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

                            if page.showsCatalogExplore {
                                ExploreCatalogSection(
                                    currentPageID: page.id,
                                    onOpenDetail: onDetailTapped
                                )
                                .id(Self.catalogExploreID)
                            }
                        }
                        .padding(.horizontal, PhrasePageStyle.horizontalPadding)
                        .padding(.top, 72)
                        .padding(.bottom, PhrasePageStyle.bottomChromeContentClearance)
                    }
                }
                .onChange(of: scrollToTopTrigger) { _, _ in
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

            if showsChrome {
                bottomChrome
                    .padding(.horizontal, AppChromeLayout.bottomOuterHorizontalPadding)
                    .padding(.bottom, AppChromeLayout.bottomPadding)
                    .offset(y: AppChromeLayout.bottomOffset)
            }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 0) {
                HeroMastheadImage(imageName: page.heroImageName ?? PhrasePageStyle.heroImageName)

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    heroBadge

                    Text(page.destination.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Text(page.title)
                    .font(.system(size: 54, weight: .black, design: .serif))
                    .foregroundStyle(.primary)
                    .lineLimit(page.id == PhrasePage.xinChao.id ? 1 : 2)
                    .minimumScaleFactor(0.62)

                Text(page.englishTitle)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)

                HStack(spacing: 10) {
                    Image(systemName: "waveform")
                        .foregroundStyle(.red)
                    Text(page.pronunciation)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.76)
                }

                PlaybackDockView(
                    audioKey: page.playbackAudioKey,
                    isSaved: isSaved,
                    onToggleSaved: onToggleSaved,
                    visibilityRoute: chromeRoute
                )
                    .padding(.top, PhrasePageStyle.heroPlayerTopSpacing)

                if let onTogglePractice {
                    PhrasePracticeIntentButton(
                        isInPractice: isInPractice,
                        onTogglePractice: onTogglePractice
                    )
                    .padding(.top, 4)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, PhrasePageStyle.heroTextTopPadding)
            .padding(.bottom, PhrasePageStyle.heroTextBottomPadding)
        }
        .background(PhrasePageStyle.pageBackground)
    }

    private static let scrollTopID = "PhraseArticleTemplateViewTop"
    private static let catalogExploreID = "PhraseArticleTemplateViewCatalogExplore"

    private var visibleSections: [PhraseArticleSection] {
        page.sections.filter { section in
            !section.body.isEmpty || !section.phrases.isEmpty || !section.breakdown.isEmpty
        }
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
            scrollID = page.showsCatalogExplore ? Self.catalogExploreID : visibleSections.last?.id
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

    @ViewBuilder
    private var bottomChrome: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: AppChromeLayout.bottomSpacing) {
                bottomChromeContent
            }
        } else {
            bottomChromeContent
        }
    }

    private var bottomChromeContent: some View {
        HStack(spacing: AppChromeLayout.bottomSpacing) {
            HStack(spacing: AppChromeLayout.dockItemSpacing) {
                ForEach(AppChrome(route: chromeRoute).primaryDockItems, id: \.self) { item in
                    DockItem(kind: item, selected: item == .home)
                }
            }
            .padding(.horizontal, AppChromeLayout.dockHorizontalPadding)
            .padding(.vertical, AppChromeLayout.dockVerticalPadding)
            .nativeGlass(cornerRadius: AppChromeLayout.dockCornerRadius)

            Button {
                onSearchTapped()
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title2.weight(.medium))
                    .foregroundStyle(.primary)
                    .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
            }
            .buttonStyle(.plain)
            .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
            .nativeGlassMorphID(AppChromeMorphID.search, namespace: chromeNamespace)
            .chromeMorph(AppChromeMorphID.search, namespace: chromeNamespace, isSource: !isSearchActive)
        }
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
            Text(section.body)
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

private struct PhrasePracticeIntentButton: View {
    let isInPractice: Bool
    let onTogglePractice: () -> Void

    var body: some View {
        Button {
            onTogglePractice()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: isInPractice ? "checkmark.circle.fill" : "plus.circle.fill")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.red)

                Text(isInPractice ? "In practice pool" : "Add to practice")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 52)
            .phraseListCard(cornerRadius: 20, strokeOpacity: 0.05)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isInPractice ? "Remove from practice pool" : "Add to practice pool")
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
                    rowContent(showsChevron: true)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            } else {
                rowContent(showsChevron: false)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
    }

    private func rowContent(showsChevron: Bool) -> some View {
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

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
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

                if let destinationPageID {
                    Button {
                        onOpenDetail(destinationPageID)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.tertiary)
                            .frame(width: 24, height: 42)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 16)
        .frame(width: 112, height: 174)
        .phraseListCard(strokeOpacity: 0.05)
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 10)
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
                    rowContent(showsChevron: true)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            } else {
                rowContent(showsChevron: false)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
    }

    private func rowContent(showsChevron: Bool) -> some View {
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

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
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

    private var sections: [PhraseCatalogSection] {
        Self.sections(forPageID: currentPageID)
    }

    static func sections(forPageID pageID: String) -> [PhraseCatalogSection] {
        PhraseCatalog.browseSections(
            defaultCategoryID: PhraseCatalog.defaultCategoryID(forPageID: pageID),
            excludingPageID: pageID
        )
    }

    var body: some View {
        if sections.isEmpty {
            ExploreCatalogEmptyState()
        } else {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Browse more")

                LazyVStack(alignment: .leading, spacing: ExploreCatalogLayout.sectionSpacing) {
                    ForEach(sections) { section in
                        ExploreCatalogCategoryShelf(section: section, onOpenDetail: onOpenDetail)
                    }
                }
            }
        }
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
        case "goodbyes":
            return "Leave conversations cleanly"
        default:
            return "Useful phrase pages for this travel moment"
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

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
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

private struct DockItem: View {
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

#Preview {
    AppShellView()
}
