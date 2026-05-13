import SwiftUI

struct BrowsePageView: View {
    @ObservedObject var intentStore: LocalUserIntentStore

    let scrollToTopTrigger: Int
    var onOpenDetail: (String) -> Void
    var onOpenCollection: (BrowseCollectionRoute) -> Void
    var onSearchTapped: () -> Void
    var onSearchQuery: (String) -> Void
    var onSavedTapped: () -> Void
    var onPracticeTapped: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: BrowsePageLayout.sectionSpacing) {
                        header
                            .id(Self.scrollTopID)

                        situationGrid
                            .padding(.horizontal, BrowsePageLayout.horizontalPadding)

                        cityShortcuts

                        startHereShelf

                        compactBrowseHeader
                            .padding(.horizontal, BrowsePageLayout.horizontalPadding)

                        situationChips

                        phraseFamilies
                            .padding(.horizontal, BrowsePageLayout.horizontalPadding)

                        byCityShelf

                        returningUserShelves
                    }
                    .padding(.bottom, BrowsePageLayout.bottomChromeContentClearance)
                }
                .onChange(of: scrollToTopTrigger) { _, _ in
                    scrollProxy.scrollTo(Self.scrollTopID, anchor: .top)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .accessibilityIdentifier("BrowsePageView")
    }

    private static let scrollTopID = "BrowsePageTop"

    private var header: some View {
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

                    Text("SPEAKLOCAL VIETNAM")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Text("Browse")
                    .font(.system(size: 46, weight: .black, design: .serif))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                    .accessibilityIdentifier("Browse.Title")

                Text("Choose a real travel situation.")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, BrowsePageLayout.horizontalPadding)
            .padding(.top, 18)
        }
    }

    private var situationGrid: some View {
        VStack(spacing: 12) {
            BrowseTwoColumnGrid(
                items: BrowseSearchDestinations.situations.filter { $0.id != "local-greetings" },
                spacing: 12
            ) { situation in
                BrowseSituationCard(destination: situation) { open(destination: situation) }
            }

            if let localGreetings = BrowseSearchDestinations.situations.first(where: { $0.id == "local-greetings" }) {
                BrowseSituationCard(destination: localGreetings) { open(destination: localGreetings) }
            }
        }
    }

    private var cityShortcuts: some View {
        BrowseShelf(title: "Cities") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(BrowseSearchDestinations.cityShortcuts) { city in
                        BrowseCityChip(city: city) {
                            onOpenCollection(city.collectionRoute)
                        }
                    }
                }
                .padding(.horizontal, BrowsePageLayout.horizontalPadding)
                .padding(.bottom, 2)
            }
            .scrollClipDisabled()
        }
    }

    private var startHereShelf: some View {
        BrowseShelf(title: "Start here") {
            BrowseTwoColumnGrid(
                items: BrowseSearchDestinations.startHere,
                spacing: 12
            ) { destination in
                BrowseStartHereCard(destination: destination) { open(destination: destination) }
            }
            .padding(.horizontal, BrowsePageLayout.horizontalPadding)
        }
    }

    private var compactBrowseHeader: some View {
        Button {
            onSearchTapped()
        } label: {
            HStack(spacing: 14) {
                Text("Browse")
                    .font(.system(size: 28, weight: .black, design: .serif))
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "magnifyingglass")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.red)
                    .frame(width: 52, height: 52)
                    .nativeGlass(cornerRadius: 26, interactive: true)
            }
            .padding(.leading, 18)
            .padding(.trailing, 8)
            .padding(.vertical, 8)
            .phraseListCard(cornerRadius: 24)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Browse.CompactSearch")
    }

    private var situationChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Text("Situations")
                    .font(.headline.weight(.bold))
                    .padding(.leading, BrowsePageLayout.horizontalPadding)
                    .padding(.trailing, 4)

                ForEach(BrowseSearchDestinations.situations.prefix(5)) { situation in
                    BrowseSituationChip(destination: situation) {
                        open(destination: situation)
                    }
                }
            }
            .padding(.trailing, BrowsePageLayout.horizontalPadding)
            .padding(.bottom, 2)
        }
        .scrollClipDisabled()
    }

    private var phraseFamilies: some View {
        BrowseShelf(title: "Phrase families") {
            BrowseTwoColumnGrid(
                items: BrowseSearchDestinations.phraseFamilies,
                spacing: 12
            ) { family in
                BrowsePhraseFamilyCard(destination: family) { open(destination: family) }
            }
        }
    }

    private var byCityShelf: some View {
        BrowseShelf(title: "By city") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(BrowseSearchDestinations.cityShortcuts.filter { $0.id != "all-vietnam" }) { city in
                        BrowseCityCard(city: city) {
                            onOpenCollection(city.collectionRoute)
                        }
                    }
                }
                .padding(.horizontal, BrowsePageLayout.horizontalPadding)
                .padding(.bottom, 2)
            }
            .scrollClipDisabled()
        }
    }

    @ViewBuilder
    private var returningUserShelves: some View {
        let shelves = returningUserRows

        if !shelves.isEmpty {
            BrowseShelf(title: "Your next shelves") {
                VStack(spacing: 10) {
                    ForEach(shelves) { row in
                        BrowseNextShelfRow(row: row)
                    }
                }
                .padding(.horizontal, BrowsePageLayout.horizontalPadding)
            }
        }
    }

    private var returningUserRows: [BrowseNextShelfRowModel] {
        var rows: [BrowseNextShelfRowModel] = []

        if !intentStore.savedPageIDs.isEmpty {
            rows.append(
                BrowseNextShelfRowModel(
                    id: "saved",
                    title: "Saved phrases",
                    subtitle: "\(intentStore.savedPageIDs.count) saved phrases",
                    symbolName: "bookmark.fill",
                    tintName: .red,
                    action: onSavedTapped
                )
            )
        }

        if !intentStore.practicePageIDs.isEmpty {
            rows.append(
                BrowseNextShelfRowModel(
                    id: "practice",
                    title: "Ready in Messages",
                    subtitle: "Continue with \(intentStore.practicePageIDs.count) chosen pages",
                    symbolName: "waveform",
                    tintName: .green,
                    action: onPracticeTapped
                )
            )
        }

        if let recentTitle = recentSummary {
            rows.append(
                BrowseNextShelfRowModel(
                    id: "recent",
                    title: "Recently viewed",
                    subtitle: recentTitle,
                    symbolName: "clock.fill",
                    tintName: .orange,
                    action: {
                        if let pageID = intentStore.recentPageIDs.first {
                            onOpenDetail(pageID)
                        }
                    }
                )
            )
        }

        return rows
    }

    private var recentSummary: String? {
        let titles = intentStore.recentPageIDs
            .compactMap(BrowseSearchPhraseItem.resolve(pageID:))
            .prefix(3)
            .map(\.title)

        guard !titles.isEmpty else {
            return nil
        }

        return titles.joined(separator: ", ")
    }

    private func open(destination: BrowseDestination) {
        onOpenCollection(destination.collectionRoute)
    }
}

enum BrowsePageLayout {
    static let horizontalPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 26
    static let cardCornerRadius: CGFloat = 22
    static let bottomChromeContentClearance: CGFloat = 48
    static let situationIconSize: CGFloat = 48
    static let situationCardMinHeight: CGFloat = 136
    static let nextShelfRowHeight: CGFloat = 108
    static let nextShelfIconSize: CGFloat = 48
    static let nextShelfRowPadding: CGFloat = 14
    static let nextShelfRowSpacing: CGFloat = 14
    static let situationColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]
    static let startHereColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]
    static let familyColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    static func situationCardTitleContentWidth(cardWidth: CGFloat) -> CGFloat {
        max(0, cardWidth - (14 * 2))
    }
}

private struct BrowseShelf<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)
                .padding(.horizontal, BrowsePageLayout.horizontalPadding)

            content
        }
    }
}

private struct BrowseTwoColumnGrid<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let spacing: CGFloat
    let content: (Item) -> Content

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(alignment: .top, spacing: spacing) {
                    ForEach(rows[rowIndex]) { item in
                        content(item)
                            .frame(maxWidth: .infinity)
                    }

                    if rows[rowIndex].count == 1 {
                        Color.clear
                            .frame(maxWidth: .infinity)
                            .accessibilityHidden(true)
                    }
                }
            }
        }
    }

    private var rows: [[Item]] {
        stride(from: 0, to: items.count, by: 2).map { startIndex in
            Array(items[startIndex..<Swift.min(startIndex + 2, items.count)])
        }
    }
}

private struct BrowseSituationCard: View {
    let destination: BrowseDestination
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: destination.symbolName)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(destination.tintName.color)
                        .frame(width: BrowsePageLayout.situationIconSize, height: BrowsePageLayout.situationIconSize)
                        .nativeGlass(
                            cornerRadius: BrowsePageLayout.situationIconSize / 2,
                            tint: destination.tintName.color.opacity(0.18),
                            interactive: true
                        )

                    Spacer(minLength: 8)

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(destination.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(destination.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.84)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: BrowsePageLayout.situationCardMinHeight, alignment: .topLeading)
            .phraseListCard(cornerRadius: BrowsePageLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Browse.Situation.\(destination.id)")
    }
}

private struct BrowseCityChip: View {
    let city: BrowseCityShortcut
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: city.symbolName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(city.tintName.color)

                Text(city.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 14)
            .frame(height: 46)
            .nativeGlass(cornerRadius: 23, interactive: true)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Browse.City.\(city.id)")
    }
}

private struct BrowseStartHereCard: View {
    let destination: BrowseDestination
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: destination.symbolName)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(destination.tintName.color)
                    .frame(width: 48, height: 48)
                    .nativeGlass(cornerRadius: 24, tint: destination.tintName.color.opacity(0.18), interactive: true)

                VStack(alignment: .leading, spacing: 6) {
                    Text(destination.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    Text(destination.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 5) {
                        Text("Start")
                            .font(.subheadline.weight(.bold))
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.bold))
                    }
                    .foregroundStyle(.red)
                }
                .layoutPriority(1)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 134, alignment: .topLeading)
            .phraseListCard(cornerRadius: BrowsePageLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Browse.StartHereCard.\(destination.id)")
    }
}

private struct BrowseSituationChip: View {
    let destination: BrowseDestination
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: destination.symbolName)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(destination.tintName.color)
                    .frame(width: 42, height: 42)
                    .nativeGlass(cornerRadius: 21, tint: destination.tintName.color.opacity(0.18), interactive: true)

                Text(destination.title == "Getting Around" ? "Transport" : destination.title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .frame(width: 74, height: 86)
        }
        .buttonStyle(.plain)
    }
}

private struct BrowsePhraseFamilyCard: View {
    let destination: BrowseDestination
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    Image(systemName: destination.symbolName)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(destination.tintName.color)
                        .frame(width: 48, height: 48)
                        .nativeGlass(cornerRadius: 24, tint: destination.tintName.color.opacity(0.16), interactive: true)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
                        .padding(.top, 18)
                }

                Text(destination.title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                Text(destination.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                if let sample = destination.items.first {
                    Text(sample.title)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(destination.tintName.color)
                        .lineLimit(1)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(destination.tintName.color.opacity(0.09), in: Capsule())
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 206, alignment: .topLeading)
            .phraseListCard(cornerRadius: BrowsePageLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Browse.PhraseFamily.\(destination.id)")
    }
}

private struct BrowseCityCard: View {
    let city: BrowseCityShortcut
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: city.symbolName)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(city.tintName.color)
                    .frame(width: 56, height: 56)
                    .nativeGlass(cornerRadius: 20, tint: city.tintName.color.opacity(0.14), interactive: true)

                Text(city.title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.75)
            }
            .padding(12)
            .frame(width: 116, height: 128)
            .phraseListCard(cornerRadius: 18)
        }
        .buttonStyle(.plain)
    }
}

private struct BrowseNextShelfRowModel: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let symbolName: String
    let tintName: AccentTint
    let action: () -> Void
}

private struct BrowseNextShelfRow: View {
    let row: BrowseNextShelfRowModel

    var body: some View {
        Button(action: row.action) {
            HStack(spacing: BrowsePageLayout.nextShelfRowSpacing) {
                Image(systemName: row.symbolName)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(row.tintName.color)
                    .frame(width: BrowsePageLayout.nextShelfIconSize, height: BrowsePageLayout.nextShelfIconSize)
                    .nativeGlass(
                        cornerRadius: BrowsePageLayout.nextShelfIconSize / 2,
                        tint: row.tintName.color.opacity(0.16),
                        interactive: true
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(row.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)

                    Text(row.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.86)
                }
                .layoutPriority(1)

                Spacer(minLength: 8)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(BrowsePageLayout.nextShelfRowPadding)
            .frame(maxWidth: .infinity, minHeight: BrowsePageLayout.nextShelfRowHeight, maxHeight: BrowsePageLayout.nextShelfRowHeight, alignment: .leading)
            .phraseListCard(cornerRadius: BrowsePageLayout.cardCornerRadius)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .accessibilityIdentifier("Browse.NextShelf.\(row.id)")
    }
}

#Preview {
    BrowsePageView(
        intentStore: LocalUserIntentStore(defaults: .standard),
        scrollToTopTrigger: 0,
        onOpenDetail: { _ in },
        onOpenCollection: { _ in },
        onSearchTapped: {},
        onSearchQuery: { _ in },
        onSavedTapped: {},
        onPracticeTapped: {}
    )
}
