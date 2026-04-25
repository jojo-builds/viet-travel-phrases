import SwiftUI

struct PhraseListingView: View {
    let page: PhrasePage
    var onBackTapped: () -> Void = {}
    var onSearchTapped: () -> Void = {}
    var onDetailTapped: (String) -> Void = { _ in }

    var body: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    hero

                    VStack(alignment: .leading, spacing: PhrasePageStyle.sectionSpacing) {
                        SectionBlock(title: "At a glance") {
                            Text(page.atGlance)
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .lineSpacing(3)
                        }

                        SectionBlock(title: "Quick say") {
                            VStack(spacing: 0) {
                                ForEach(page.quickSay) { phrase in
                                    PhraseRow(phrase: phrase, onOpenDetail: onDetailTapped)
                                    if phrase.id != page.quickSay.last?.id {
                                        Divider().padding(.leading, 70)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .phraseListCard()
                        }

                        SectionBlock(title: "Break it down") {
                            BreakdownView(tokens: page.breakdown)
                        }

                        SectionBlock(title: "Situational greetings", trailing: "See all", leadIn: page.situationalGreetingsLeadIn) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(page.situationalGreetings) { phrase in
                                        SituationCard(phrase: phrase, onOpenDetail: onDetailTapped)
                                    }
                                }
                                .padding(.horizontal, 2)
                                .padding(.bottom, 2)
                            }
                        }

                        SectionBlock(title: "How locals actually greet", leadIn: page.localGreetingsLeadIn) {
                            VStack(spacing: 0) {
                                ForEach(page.localGreetings) { phrase in
                                    LocalGreetingRow(phrase: phrase, onOpenDetail: onDetailTapped)
                                    if phrase.id != page.localGreetings.last?.id {
                                        Divider().padding(.leading, 70)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .phraseListCard()
                        }

                        SectionBlock(title: "Common follow-ups", leadIn: page.followUpsLeadIn) {
                            VStack(spacing: 0) {
                                ForEach(page.followUps) { phrase in
                                    PhraseRow(phrase: phrase, onOpenDetail: onDetailTapped)
                                    if phrase.id != page.followUps.last?.id {
                                        Divider().padding(.leading, 70)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .phraseListCard()
                        }

                        CulturalNote(text: page.culturalNote)

                        SectionBlock(title: "Explore next") {
                            VStack(spacing: 0) {
                                ForEach(page.exploreNext) { link in
                                    ExploreLinkRow(link: link, onOpenDetail: onDetailTapped)
                                    if link.id != page.exploreNext.last?.id {
                                        Divider().padding(.leading, 48)
                                    }
                                }
                            }
                            .padding(.vertical, 6)
                            .phraseListCard(cornerRadius: PhrasePageStyle.compactCardCornerRadius)
                        }
                    }
                    .padding(.horizontal, PhrasePageStyle.horizontalPadding)
                    .padding(.top, 72)
                    .padding(.bottom, 118)
                }
            }
            .ignoresSafeArea(edges: .top)
            .overlay(alignment: .topLeading) {
                fixedBackButton
                    .padding(.leading, 24)
                    .padding(.top, 6)
                    .offset(y: -24)
            }

            bottomChrome
                .padding(.horizontal, 16)
                .padding(.bottom, -14)
                .offset(y: 14)
        }
    }

    private var hero: some View {
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

                    Text(page.destination.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Text(page.title)
                    .font(.system(size: 56, weight: .black, design: .serif))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Text(page.intentSummary)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)

                HStack(spacing: 10) {
                    Image(systemName: "waveform")
                        .foregroundStyle(.red)
                    Text(page.pronunciation)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                PlaybackDockView()
                    .padding(.top, PhrasePageStyle.heroPlayerTopSpacing)
            }
            .padding(.horizontal, 24)
            .padding(.top, PhrasePageStyle.heroTextTopPadding)
            .padding(.bottom, PhrasePageStyle.heroTextBottomPadding)
        }
        .background(PhrasePageStyle.pageBackground)
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

    private var bottomChrome: some View {
        HStack(spacing: 10) {
            HStack(spacing: 16) {
                ForEach(AppChrome(route: .phrasePage).primaryDockItems, id: \.self) { item in
                    DockItem(kind: item, selected: item == .home)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
            .nativeGlass(cornerRadius: 32)

            Button {
                onSearchTapped()
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title2.weight(.medium))
                    .foregroundStyle(.primary)
                    .frame(width: 64, height: 64)
            }
            .buttonStyle(.plain)
            .nativeGlass(cornerRadius: 32, interactive: true)
        }
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
            AudioSpeakerButton(tint: phrase.tintName)

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

            if phrase.detailPageID != nil {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if let detailPageID = phrase.detailPageID {
                onOpenDetail(detailPageID)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
    }
}

private struct SituationCard: View {
    let phrase: PhraseOption
    let onOpenDetail: (String) -> Void

    var body: some View {
        VStack(spacing: 10) {
            cardSummary

            HStack(spacing: 10) {
                AudioSpeakerButton(tint: phrase.tintName, size: 42)

                if phrase.detailPageID != nil {
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
                        .frame(width: 24, height: 42)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if let detailPageID = phrase.detailPageID {
                onOpenDetail(detailPageID)
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
    let onOpenDetail: (String) -> Void

    var body: some View {
        HStack(spacing: 12) {
            AudioSpeakerButton(tint: phrase.tintName)

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

            if phrase.detailPageID != nil {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if let detailPageID = phrase.detailPageID {
                onOpenDetail(detailPageID)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
    }
}

struct BreakdownView: View {
    let tokens: [BreakdownToken]

    var body: some View {
        HStack(spacing: 9) {
            ForEach(Array(tokens.enumerated()), id: \.element.id) { index, token in
                VStack(spacing: 4) {
                    Text(token.vietnamese)
                        .font(.headline.weight(.black))
                        .foregroundStyle(.red)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)

                    Text(token.english)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.78)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .phraseListCard(cornerRadius: 16, strokeOpacity: 0.05)

                if index < tokens.count - 1 {
                    Text(index == 0 ? "+" : "=")
                        .font(.title.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
        }
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

private struct ExploreLinkRow: View {
    let link: PhraseLink
    let onOpenDetail: (String) -> Void

    var body: some View {
        Button {
            onOpenDetail(link.detailPageID ?? link.id)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: link.symbolName)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(link.tintName.color)
                    .frame(width: 44, height: 44)
                    .nativeGlass(cornerRadius: 22)

                VStack(alignment: .leading, spacing: 3) {
                    Text(link.vietnamese)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)

                    Text(link.english)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
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
