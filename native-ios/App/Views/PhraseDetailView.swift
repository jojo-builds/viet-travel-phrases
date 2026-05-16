import SwiftUI

struct PhraseDetailView: View {
    let page: PhraseDetailPage
    let initialScrollTarget: PhraseArticleInitialScrollTarget?
    let scrollToTopTrigger: Int
    let scrollToTopRoute: AppRoute?
    let chromeNamespace: Namespace.ID?
    let isSearchActive: Bool
    let showsChrome: Bool
    let topChromeContentClearance: CGFloat
    let isSaved: Bool
    let heroMorphPageID: String?
    let heroMorphContentHoldPageID: String?
    var onBackTapped: () -> Void
    var onSearchTapped: () -> Void
    var onToggleSaved: (() -> Void)?
    var onDetailTapped: (String) -> Void

    init(
        page: PhraseDetailPage,
        initialScrollTarget: PhraseArticleInitialScrollTarget? = nil,
        scrollToTopTrigger: Int = 0,
        scrollToTopRoute: AppRoute? = nil,
        chromeNamespace: Namespace.ID? = nil,
        isSearchActive: Bool = false,
        showsChrome: Bool = true,
        topChromeContentClearance: CGFloat = 0,
        isSaved: Bool = false,
        heroMorphPageID: String? = nil,
        heroMorphContentHoldPageID: String? = nil,
        onBackTapped: @escaping () -> Void,
        onSearchTapped: @escaping () -> Void,
        onToggleSaved: (() -> Void)? = nil,
        onDetailTapped: @escaping (String) -> Void
    ) {
        self.page = page
        self.initialScrollTarget = initialScrollTarget
        self.scrollToTopTrigger = scrollToTopTrigger
        self.scrollToTopRoute = scrollToTopRoute
        self.chromeNamespace = chromeNamespace
        self.isSearchActive = isSearchActive
        self.showsChrome = showsChrome
        self.topChromeContentClearance = topChromeContentClearance
        self.isSaved = isSaved
        self.heroMorphPageID = heroMorphPageID
        self.heroMorphContentHoldPageID = heroMorphContentHoldPageID
        self.onBackTapped = onBackTapped
        self.onSearchTapped = onSearchTapped
        self.onToggleSaved = onToggleSaved
        self.onDetailTapped = onDetailTapped
    }

    @ViewBuilder
    var body: some View {
        PhraseArticleTemplateView(
            page: page.articleTemplate,
            chromeRoute: .detailPage(page.id),
            initialScrollTarget: initialScrollTarget,
            scrollToTopTrigger: scrollToTopTrigger,
            scrollToTopRoute: scrollToTopRoute,
            chromeNamespace: chromeNamespace,
            isSearchActive: isSearchActive,
            showsChrome: showsChrome,
            topChromeContentClearance: topChromeContentClearance,
            isSaved: isSaved,
            heroMorphPageID: heroMorphPageID,
            heroMorphContentHoldPageID: heroMorphContentHoldPageID,
            onBackTapped: onBackTapped,
            onSearchTapped: onSearchTapped,
            onToggleSaved: onToggleSaved,
            onDetailTapped: onDetailTapped
        )
    }

    private var legacyBody: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        hero
                            .id(Self.scrollTopID)

                        LazyVStack(alignment: .leading, spacing: PhrasePageStyle.sectionSpacing) {
                            ForEach(visibleSections) { section in
                                DetailSectionView(section: section, onOpenDetail: onDetailTapped)
                            }

                            if !page.examples.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Try it in context")
                                        .font(.headline.weight(.bold))

                                    VStack(spacing: 0) {
                                        ForEach(page.examples) { phrase in
                                            DetailExampleRow(phrase: phrase)

                                            if phrase.id != page.examples.last?.id {
                                                Divider().padding(.leading, 70)
                                            }
                                        }
                                    }
                                    .padding(.vertical, 8)
                                    .phraseListCard()
                                }
                            }

                            ExploreCatalogSection(
                                currentPageID: page.id,
                                onOpenDetail: onDetailTapped
                            )
                        }
                        .padding(.horizontal, PhrasePageStyle.horizontalPadding)
                        .padding(.top, 24 + topChromeContentClearance)
                        .padding(.bottom, PhrasePageStyle.bottomChromeContentClearance)
                    }
                }
                .onChange(of: scrollToTopTrigger) { _, _ in
                    guard scrollToTopRoute == nil || scrollToTopRoute == .detailPage(page.id) else {
                        return
                    }

                    scrollProxy.scrollTo(Self.scrollTopID, anchor: .top)
                }
            }
            .ignoresSafeArea(edges: .top)
            .overlay(alignment: .topLeading) {
                if showsChrome {
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
                    .padding(.leading, 24)
                    .padding(.top, 6)
                    .offset(y: -24)
                }
            }
        }
    }

    private static let scrollTopID = "PhraseDetailViewTop"

    private var visibleSections: [PhraseDetailSection] {
        page.sections
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeroMastheadImage()

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: page.iconName)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(page.tintName.color)
                        .frame(width: 22, height: 22)
                        .nativeGlass(cornerRadius: 11)

                    Text("SPEAKLOCAL VIETNAM")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Text(page.title)
                    .font(.system(size: 48, weight: .black, design: .serif))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.64)

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
                    onToggleSaved: onToggleSaved
                )
                    .padding(.top, PhrasePageStyle.heroPlayerTopSpacing)
            }
            .padding(.horizontal, 24)
            .padding(.top, PhrasePageStyle.heroTextTopPadding)
            .padding(.bottom, PhrasePageStyle.heroTextBottomPadding)
        }
        .background(PhrasePageStyle.pageBackground)
    }

}

private struct DetailSectionView: View {
    let section: PhraseDetailSection
    let onOpenDetail: (String) -> Void

    var body: some View {
        if !section.phrases.isEmpty {
            DetailPhraseListSection(section: section, onOpenDetail: onOpenDetail)
        } else if !section.breakdown.isEmpty {
            DetailBreakdownSection(section: section)
        } else {
            DetailSectionCard(section: section)
        }
    }
}

private struct DetailSectionCard: View {
    let section: PhraseDetailSection

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(section.title)
                .font(.headline.weight(.bold))

            DetailDefinedBodyText(text: section.body, definitions: section.inlineDefinitions)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .phraseListCard(cornerRadius: PhrasePageStyle.compactCardCornerRadius, strokeOpacity: 0.05)
    }
}

private struct DetailDefinedBodyText: View {
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
                DetailDefinitionPopover(definition: definition)
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

private struct DetailDefinitionPopover: View {
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

private struct DetailPhraseListSection: View {
    let section: PhraseDetailSection
    let onOpenDetail: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(section.title)
                .font(.headline.weight(.bold))

            if !section.body.isEmpty {
                Text(section.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(spacing: 0) {
                ForEach(section.phrases) { phrase in
                    DetailExampleRow(phrase: phrase, onOpenDetail: onOpenDetail)

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

private struct DetailBreakdownSection: View {
    let section: PhraseDetailSection

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(section.title)
                .font(.headline.weight(.bold))

            if !section.body.isEmpty {
                Text(section.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            BreakdownView(tokens: section.breakdown)
        }
    }
}

private struct DetailExampleRow: View {
    let phrase: PhraseOption
    var onOpenDetail: ((String) -> Void)? = nil

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            AudioSpeakerButton(tint: phrase.tintName, audioKey: phrase.playbackAudioKey)

            if let detailPageID = phrase.detailPageID, onOpenDetail != nil {
                Button {
                    onOpenDetail?(detailPageID)
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
        .padding(.vertical, 11)
    }

    private var rowContent: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(phrase.vietnamese)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)
                    .fixedSize(horizontal: false, vertical: true)

                Text(phrase.english)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(DetailPhraseRowLayout.secondaryLineLimit)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)

            Spacer()
        }
    }
}

enum DetailPhraseRowLayout {
    static let secondaryLineLimit = 2
}

#Preview {
    PhraseDetailView(page: .localGreetings, onBackTapped: {}, onSearchTapped: {}, onDetailTapped: { _ in })
}
