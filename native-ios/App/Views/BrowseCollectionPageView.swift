import SwiftUI

struct BrowseCollectionPageView: View {
    let descriptor: BrowseCollectionDescriptor
    let scrollToTopTrigger: Int
    let scrollToTopRoute: BrowseCollectionRoute?
    let focusRequest: BrowseCollectionFocusRequest?
    var onOpenDetail: (String) -> Void
    var onOpenCollection: (BrowseCollectionRoute) -> Void
    var onPractice: (BrowseCollectionPracticeAction) -> Void

    @State private var selectedSubcategoryID: String?
    @State private var selectedCityCardID: String?
    @State private var cityCardScrollRequestID = 0

    var body: some View {
        let selectedSubcategory = descriptor.subcategories.first { $0.id == selectedSubcategoryID }
        let starterTitle = selectedSubcategory.map {
            $0.countUnit == "item" ? $0.title : "\($0.title) phrases"
        } ?? descriptor.starterTitle
        let starterItems = selectedSubcategory?.items ?? descriptor.starterItems

        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: BrowseCollectionLayout.sectionSpacing) {
                        BrowseCollectionHeader(descriptor: descriptor)
                            .id(Self.scrollTopID)

                        if let cityHub = descriptor.cityHub {
                            BrowseCityHubContent(
                                descriptor: descriptor,
                                cityHub: cityHub,
                                selectedCityCardID: $selectedCityCardID,
                                onOpenDetail: onOpenDetail,
                                onOpenCollection: onOpenCollection,
                                onPractice: { onPractice(descriptor.practiceAction) },
                                onCityCardSelectionActivated: { _ in }
                            )
                        } else {
                            BrowseCollectionSubcategoryRail(
                                subcategories: descriptor.subcategories,
                                selectedSubcategoryID: selectedSubcategoryID,
                                onSelect: { subcategory in
                                    selectedSubcategoryID = selectedSubcategoryID == subcategory.id ? nil : subcategory.id
                                }
                            )

                            BrowseCollectionStarterSection(
                                title: starterTitle,
                                actionTitle: selectedSubcategory == nil ? "View all" : "",
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
                                BrowseCollectionPracticeCard(
                                    descriptor: descriptor,
                                    onPractice: { onPractice(descriptor.practiceAction) }
                                )
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
                .onChange(of: selectedCityCardID) { _, newValue in
                    cityCardScrollRequestID += 1
                    let requestID = cityCardScrollRequestID
                    guard let newValue else { return }
                    Task { @MainActor in
                        try? await Task.sleep(nanoseconds: BrowseCollectionLayout.citySelectedScrollDelayNanoseconds)
                        guard
                            requestID == cityCardScrollRequestID,
                            selectedCityCardID == newValue
                        else {
                            return
                        }

                        withAnimation(.snappy(duration: 0.24)) {
                            scrollProxy.scrollTo(
                                BrowseCollectionLayout.citySelectedSectionID(for: newValue),
                                anchor: BrowseCollectionLayout.citySelectedSectionAnchor
                            )
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .onChange(of: descriptor.id) { _, _ in
            cityCardScrollRequestID += 1
            selectedSubcategoryID = nil
            selectedCityCardID = nil
        }
        .accessibilityIdentifier("BrowseCollection.\(descriptor.route.id)")
    }

    private static let scrollTopID = "BrowseCollectionTop"

    @MainActor
    private func restoreFocusIfNeeded(_ scrollProxy: ScrollViewProxy) async {
        guard
            let focusRequest,
            focusRequest.route == descriptor.route
        else {
            return
        }

        try? await Task.sleep(nanoseconds: BrowseCollectionLayout.focusRestoreDelayNanoseconds)
        withAnimation(.snappy(duration: 0.24)) {
            scrollProxy.scrollTo(focusRequest.target.scrollTargetID, anchor: .center)
        }
    }
}

private enum BrowseCollectionLayout {
    static let horizontalPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 24
    static let bottomChromeContentClearance: CGFloat = 224
    static let citySelectedScrollDelayNanoseconds: UInt64 = 180_000_000
    static let focusRestoreDelayNanoseconds: UInt64 = 520_000_000

    static func citySelectedSectionID(for cardID: String) -> String {
        "BrowseCollectionCitySelectedSection.\(cardID)"
    }

    static let citySelectedSectionAnchor = UnitPoint(x: 0.5, y: 0.4)
}

private struct BrowseCollectionHeader: View {
    let descriptor: BrowseCollectionDescriptor

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeroMastheadImage(imageName: descriptor.mastheadImageName)

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
            .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)
            .padding(.top, 16)
        }
    }
}

private struct BrowseCollectionSubcategoryRail: View {
    let subcategories: [BrowseCollectionSubcategory]
    let selectedSubcategoryID: String?
    let onSelect: (BrowseCollectionSubcategory) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(subcategories) { subcategory in
                    BrowseCollectionSubcategoryCard(
                        subcategory: subcategory,
                        isSelected: subcategory.id == selectedSubcategoryID,
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
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: subcategory.symbolName)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(subcategory.tintName.color)
                    .frame(width: 48, height: 48)
                    .nativeGlass(cornerRadius: 18, tint: subcategory.tintName.color.opacity(0.14), interactive: true)

                Text(subcategory.title)
                    .font(.subheadline.weight(.black))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)

                Text("\(subcategory.phraseCount) \(subcategory.countUnit)\(subcategory.phraseCount == 1 ? "" : "s")")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .padding(12)
            .frame(width: 120, height: 136, alignment: .topLeading)
            .phraseListCard(cornerRadius: 20)
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? subcategory.tintName.color.opacity(0.55) : .clear, lineWidth: 2)
            }
            .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("BrowseCollection.Subcategory.\(subcategory.id)")
    }
}

private struct BrowseCityHubContent: View {
    let descriptor: BrowseCollectionDescriptor
    let cityHub: BrowseCityHub
    @Binding var selectedCityCardID: String?

    let onOpenDetail: (String) -> Void
    let onOpenCollection: (BrowseCollectionRoute) -> Void
    let onPractice: () -> Void
    let onCityCardSelectionActivated: (String) -> Void

    var body: some View {
        let selectedSituation = cityHub.situations.first { $0.id == selectedCityCardID }
        let selectedBrowseGroup = cityHub.browseGroups.first { $0.id == selectedCityCardID }

        VStack(alignment: .leading, spacing: BrowseCollectionLayout.sectionSpacing) {
            if let cityNameAudioItem = cityHub.cityNameAudioItem {
                BrowseCityNameAudioPlayer(item: cityNameAudioItem)
            }

            if isCountryHub {
                BrowseCityCardGridSection(
                    title: cityHub.situationTitle,
                    cards: cityHub.situations,
                    onOpenCollection: onOpenCollection
                )

                BrowseCollectionPracticeCard(
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
                        actionTitle: "",
                        items: cityHub.namesToKnowItems,
                        onOpenDetail: onOpenDetail
                    )
                }

                if !cityHub.quickPhraseItems.isEmpty {
                    BrowseCollectionStarterSection(
                        title: cityHub.quickPhrasesTitle,
                        actionTitle: "",
                        items: cityHub.quickPhraseItems,
                        onOpenDetail: onOpenDetail
                    )
                }
            } else {
                if !cityHub.namesToKnowItems.isEmpty {
                    BrowseCollectionStarterSection(
                        title: cityHub.namesTitle,
                        actionTitle: "",
                        items: cityHub.namesToKnowItems,
                        onOpenDetail: onOpenDetail
                    )
                }

                BrowseCityCardGridSection(
                    title: cityHub.browseTitle,
                    cards: cityHub.browseGroups,
                    selectedCardID: selectedCityCardID,
                    onOpenCollection: onOpenCollection,
                    onSelectCard: selectCityCard
                )

                if let selectedBrowseGroup, !selectedBrowseGroup.items.isEmpty {
                    BrowseCollectionStarterSection(
                        title: citySectionTitle(for: selectedBrowseGroup),
                        actionTitle: "",
                        items: selectedBrowseGroup.items,
                        onOpenDetail: onOpenDetail
                    )
                    .id(BrowseCollectionLayout.citySelectedSectionID(for: selectedBrowseGroup.id))
                }

                BrowseCollectionPracticeCard(
                    descriptor: descriptor,
                    onPractice: onPractice
                )

                BrowseCityCardGridSection(
                    title: cityHub.situationTitle,
                    cards: cityHub.situations,
                    selectedCardID: selectedCityCardID,
                    onOpenCollection: onOpenCollection,
                    onSelectCard: selectCityCard
                )

                if let selectedSituation, !selectedSituation.items.isEmpty {
                    BrowseCollectionStarterSection(
                        title: citySectionTitle(for: selectedSituation),
                        actionTitle: "",
                        items: selectedSituation.items,
                        onOpenDetail: onOpenDetail
                    )
                    .id(BrowseCollectionLayout.citySelectedSectionID(for: selectedSituation.id))
                }

                if !cityHub.quickPhraseItems.isEmpty {
                    BrowseCollectionStarterSection(
                        title: cityHub.quickPhrasesTitle,
                        actionTitle: "",
                        items: cityHub.quickPhraseItems,
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

    private func selectCityCard(_ card: BrowseCollectionSubcategory) {
        guard !card.items.isEmpty else {
            return
        }

        let isActivatingCard = selectedCityCardID != card.id
        selectedCityCardID = isActivatingCard ? card.id : nil

        if isActivatingCard {
            onCityCardSelectionActivated(card.id)
        }
    }

    private func citySectionTitle(for card: BrowseCollectionSubcategory) -> String {
        "\(card.title) in \(descriptor.title)"
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
        BrowseCollectionSection(title: title, actionTitle: "") {
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
    var actionTitle: String = "View all"
    let items: [BrowseSearchPhraseItem]
    let onOpenDetail: (String) -> Void

    var body: some View {
        BrowseCollectionSection(title: title, actionTitle: actionTitle) {
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

private struct BrowseCollectionPracticeCard: View {
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

                Text("Start")
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
        .accessibilityIdentifier("BrowseCollection.Practice.\(descriptor.route.id)")
    }
}

private extension BrowseCollectionDescriptor {
    var hasMessageSection: Bool {
        messageSectionTitle != nil && !messageScenarioIDs.isEmpty
    }
}

private struct BrowseCollectionMessageSection: View {
    let descriptor: BrowseCollectionDescriptor
    let onStartScenario: (PracticeScenarioID) -> Void

    var body: some View {
        if let title = descriptor.browseMessageSectionTitle {
            BrowseCollectionSection(title: title, actionTitle: "") {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: 16) {
                        ForEach(descriptor.messageScenarioIDs) { scenarioID in
                            BrowseCollectionMessageContactButton(
                                scenarioID: scenarioID,
                                onStart: { onStartScenario(scenarioID) }
                            )
                            .frame(width: 104)
                        }
                    }
                    .padding(.horizontal, 1)
                    .padding(.bottom, 2)
                }
                .frame(height: 144)
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
                    size: 88,
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
        LazyVStack(alignment: .leading, spacing: 22) {
            ForEach(shelves) { shelf in
                BrowseCollectionShelfView(shelf: shelf, onOpenDetail: onOpenDetail)
            }
        }
        .padding(.horizontal, BrowseCollectionLayout.horizontalPadding)
    }
}

private struct BrowseCollectionShelfView: View {
    let shelf: BrowseCollectionShelf
    let onOpenDetail: (String) -> Void

    var body: some View {
        BrowseCollectionSection(title: shelf.title, actionTitle: "Browse") {
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
    let actionTitle: String
    let content: Content

    init(title: String, actionTitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.actionTitle = actionTitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.title3.weight(.black))
                    .foregroundStyle(.primary)

                Spacer()

                if !actionTitle.isEmpty {
                    Text(actionTitle)
                        .font(.caption.weight(.black))
                        .foregroundStyle(.red)
                }
            }

            content
        }
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
