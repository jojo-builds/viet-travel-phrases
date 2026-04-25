import SwiftUI

struct PhraseDetailView: View {
    let page: PhraseDetailPage
    var onBackTapped: () -> Void
    var onSearchTapped: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    hero

                    VStack(alignment: .leading, spacing: PhrasePageStyle.sectionSpacing) {
                        ForEach(page.sections) { section in
                            DetailSectionView(section: section)
                        }

                        if !page.examples.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Practice it")
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
                    }
                    .padding(.horizontal, PhrasePageStyle.horizontalPadding)
                    .padding(.top, 24)
                    .padding(.bottom, 118)
                }
            }
            .ignoresSafeArea(edges: .top)
            .overlay(alignment: .topLeading) {
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

                PlaybackDockView()
                    .padding(.top, PhrasePageStyle.heroPlayerTopSpacing)
            }
            .padding(.horizontal, 24)
            .padding(.top, PhrasePageStyle.heroTextTopPadding)
            .padding(.bottom, PhrasePageStyle.heroTextBottomPadding)
        }
        .background(PhrasePageStyle.pageBackground)
    }

    private var bottomChrome: some View {
        HStack(spacing: 10) {
            HStack(spacing: 16) {
                ForEach(AppChrome(route: .detailPage(page.id)).primaryDockItems, id: \.self) { item in
                    DetailDockItem(kind: item, selected: item == .home)
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

private struct DetailSectionView: View {
    let section: PhraseDetailSection

    var body: some View {
        if !section.phrases.isEmpty {
            DetailPhraseListSection(section: section)
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

            Text(section.body)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .phraseListCard(cornerRadius: PhrasePageStyle.compactCardCornerRadius, strokeOpacity: 0.05)
    }
}

private struct DetailPhraseListSection: View {
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

            VStack(spacing: 0) {
                ForEach(section.phrases) { phrase in
                    DetailExampleRow(phrase: phrase)

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
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
    }
}

private struct DetailDockItem: View {
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
    PhraseDetailView(page: .localGreetings, onBackTapped: {}, onSearchTapped: {})
}
