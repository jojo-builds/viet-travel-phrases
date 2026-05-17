import SwiftUI

struct BrowsePageView: View {
    @ObservedObject var intentStore: LocalUserIntentStore

    let scrollToTopTrigger: Int
    var onOpenDetail: (String) -> Void
    var onOpenCollection: (BrowseCollectionRoute) -> Void
    var onSearchTapped: () -> Void
    var onSearchQuery: (String) -> Void

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
            BrowseCityHeroRail(
                cities: cityHeroShortcuts,
                onOpenCollection: onOpenCollection
            )
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

    private var cityHeroShortcuts: [BrowseCityShortcut] {
        BrowseSearchDestinations.homepageCityShortcuts
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
    static let cityHeroCardHeight: CGFloat = 368
    static let cityHeroImageHeight: CGFloat = 216
    static let cityHeroCopyAreaHeight: CGFloat = cityHeroCardHeight - cityHeroImageHeight
    static let cityHeroImageFadeHeight: CGFloat = 146
    static let cityHeroCardSpacing: CGFloat = 14
    static let phraseFamilyCardHeight: CGFloat = 166
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

    static func cityHeroCardWidth(containerWidth: CGFloat) -> CGFloat {
        min(292, max(264, containerWidth * 0.78))
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

private struct BrowseCityHeroRail: View {
    let cities: [BrowseCityShortcut]
    let onOpenCollection: (BrowseCollectionRoute) -> Void

    var body: some View {
        GeometryReader { proxy in
            let cardWidth = BrowsePageLayout.cityHeroCardWidth(containerWidth: proxy.size.width)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: BrowsePageLayout.cityHeroCardSpacing) {
                    ForEach(cities) { city in
                        BrowseCityHeroCard(
                            city: city,
                            width: cardWidth,
                            onOpenCollection: onOpenCollection
                        )
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, BrowsePageLayout.horizontalPadding)
                .padding(.bottom, 4)
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
        }
        .frame(height: BrowsePageLayout.cityHeroCardHeight + 4)
        .accessibilityIdentifier("Browse.CityHeroRail")
    }
}

private struct BrowseCityHeroCard: View {
    let city: BrowseCityShortcut
    let width: CGFloat
    let onOpenCollection: (BrowseCollectionRoute) -> Void

    private var descriptor: BrowseCollectionDescriptor? {
        BrowseSearchDestinations.collectionDescriptor(for: city.collectionRoute)
    }

    private var title: String {
        descriptor?.title ?? city.title
    }

    private var subtitle: String {
        descriptor?.subtitle ?? "Names, places, and practical phrases."
    }

    private var imageName: String {
        descriptor?.mastheadImageName ?? "HeroVietnamMasthead"
    }

    var body: some View {
        Button {
            onOpenCollection(city.collectionRoute)
        } label: {
            ZStack(alignment: .bottomLeading) {
                VStack(spacing: 0) {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: BrowsePageLayout.cityHeroImageHeight, alignment: .top)
                        .clipped()

                    Color.white.opacity(0.98)
                        .frame(width: width, height: BrowsePageLayout.cityHeroCopyAreaHeight)
                }

                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0),
                        .init(color: Color.white.opacity(0.24), location: 0.38),
                        .init(color: Color.white.opacity(0.72), location: 0.68),
                        .init(color: Color.white.opacity(0.98), location: 1),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: width, height: BrowsePageLayout.cityHeroImageFadeHeight)
                .frame(maxHeight: .infinity, alignment: .top)
                .offset(y: BrowsePageLayout.cityHeroImageHeight - BrowsePageLayout.cityHeroImageFadeHeight)
                .allowsHitTesting(false)

                VStack(alignment: .leading, spacing: 9) {
                    HStack(alignment: .firstTextBaseline, spacing: 10) {
                        Text(title)
                            .font(.system(size: 31, weight: .black, design: .serif))
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.72)

                        Spacer(minLength: 8)
                    }

                    Text(subtitle)
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineSpacing(2)
                        .lineLimit(3)
                        .minimumScaleFactor(0.82)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .padding(.top, 18)
                .frame(width: width, height: BrowsePageLayout.cityHeroCopyAreaHeight, alignment: .topLeading)
            }
            .frame(width: width, height: BrowsePageLayout.cityHeroCardHeight)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .background(.white.opacity(0.58), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(.white.opacity(0.78), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.035), radius: 12, x: 0, y: 7)
            .nativeGlass(cornerRadius: 30, interactive: true)
            .contentShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
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

                    Text("Start")
                        .font(.subheadline.weight(.bold))
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

    private var heroImageName: String {
        BrowseSearchDestinations.collectionDescriptor(for: destination.collectionRoute)?.mastheadImageName ?? "HeroVietnamMasthead"
    }

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                Image(heroImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, minHeight: BrowsePageLayout.phraseFamilyCardHeight)
                    .clipped()
                    .accessibilityHidden(true)

                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.08),
                        .init(color: Color.white.opacity(0.18), location: 0.46),
                        .init(color: Color.white.opacity(0.88), location: 0.78),
                        .init(color: Color.white.opacity(0.97), location: 1),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .allowsHitTesting(false)

                Text(destination.title)
                    .font(.system(size: 21, weight: .black))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.74)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, minHeight: BrowsePageLayout.phraseFamilyCardHeight, maxHeight: BrowsePageLayout.phraseFamilyCardHeight)
            .clipShape(RoundedRectangle(cornerRadius: BrowsePageLayout.cardCornerRadius, style: .continuous))
            .background(.white.opacity(0.58), in: RoundedRectangle(cornerRadius: BrowsePageLayout.cardCornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: BrowsePageLayout.cardCornerRadius, style: .continuous)
                    .stroke(.white.opacity(0.76), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 5)
            .nativeGlass(cornerRadius: BrowsePageLayout.cardCornerRadius, interactive: true)
            .contentShape(RoundedRectangle(cornerRadius: BrowsePageLayout.cardCornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Browse.PhraseFamily.\(destination.id)")
    }
}

#Preview {
    BrowsePageView(
        intentStore: LocalUserIntentStore(defaults: .standard),
        scrollToTopTrigger: 0,
        onOpenDetail: { _ in },
        onOpenCollection: { _ in },
        onSearchTapped: {},
        onSearchQuery: { _ in }
    )
}
