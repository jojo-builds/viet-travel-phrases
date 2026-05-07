import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct SearchPageView: View {
    @Binding private var query: String
    @State private var selectedFilter: SearchResultFilter = .all
    @FocusState private var localSearchFieldFocused: Bool

    let isFieldFocused: Bool
    let chromeNamespace: Namespace.ID?
    let showsChrome: Bool
    let onClose: () -> Void
    var onOpenDetail: (String) -> Void = { _ in }
    var onOpenCollection: (BrowseCollectionRoute) -> Void = { _ in }
    var onSearchQuery: (String) -> Void = { _ in }
    var onBrowseTapped: () -> Void = {}

    init(
        query: Binding<String> = .constant(""),
        isFieldFocused: Bool = false,
        chromeNamespace: Namespace.ID? = nil,
        showsChrome: Bool = true,
        onClose: @escaping () -> Void,
        onOpenDetail: @escaping (String) -> Void = { _ in },
        onOpenCollection: @escaping (BrowseCollectionRoute) -> Void = { _ in },
        onSearchQuery: @escaping (String) -> Void = { _ in },
        onBrowseTapped: @escaping () -> Void = {}
    ) {
        _query = query
        self.isFieldFocused = isFieldFocused
        self.chromeNamespace = chromeNamespace
        self.showsChrome = showsChrome
        self.onClose = onClose
        self.onOpenDetail = onOpenDetail
        self.onOpenCollection = onOpenCollection
        self.onSearchQuery = onSearchQuery
        self.onBrowseTapped = onBrowseTapped
    }

    var body: some View {
        let results = SearchPageResults(query: trimmedQuery)
        GeometryReader { proxy in
            let topMastheadBleed = max(proxy.safeAreaInsets.top, currentWindowTopSafeAreaInset)

            ZStack(alignment: .bottom) {
                PhrasePageStyle.pageBackground
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: SearchPageLayout.contentSpacing) {
                        header(results: results)

                        if results.query.isEmpty {
                            if effectiveFieldFocused {
                                focusedContent
                            } else {
                                defaultContent
                            }
                        } else if results.hasResults {
                            resultsContent(results: results)
                        } else {
                            recoveryContent
                        }
                    }
                    .padding(.top, -topMastheadBleed)
                    .padding(.horizontal, SearchPageLayout.horizontalPadding)
                    .padding(.bottom, SearchPageLayout.resultsBottomClearance)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .scrollDismissesKeyboard(.interactively)
                .ignoresSafeArea(edges: .top)
                .zIndex(SearchPageLayout.resultsZIndex)

                if showsChrome {
                    searchBottomChrome
                        .padding(.horizontal, AppChromeLayout.bottomOuterHorizontalPadding)
                        .padding(.bottom, AppChromeLayout.bottomPadding)
                        .offset(y: AppChromeLayout.bottomOffset)
                        .zIndex(SearchPageLayout.pinnedChromeZIndex)
                }
            }
        }
        .accessibilityIdentifier("SearchPageView")
    }

    private var effectiveFieldFocused: Bool {
        isFieldFocused || localSearchFieldFocused
    }

    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var currentWindowTopSafeAreaInset: CGFloat {
        #if canImport(UIKit)
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .safeAreaInsets.top ?? 0
        #else
        0
        #endif
    }

    private func header(results: SearchPageResults) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HeroMastheadImage()
                .padding(.horizontal, -SearchPageLayout.horizontalPadding)

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
            .padding(.top, 14)

            Text(results.headerTitle)
                .font(.system(size: 42, weight: .black, design: .serif))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.66)
                .padding(.top, 14)
                .accessibilityIdentifier("Search.Title")

            Text(results.headerSubtitle)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineSpacing(3)
                .padding(.top, 10)
        }
    }

    private var defaultContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            SearchSection(title: "Suggested needs") {
                LazyVStack(spacing: 10) {
                    ForEach(BrowseSearchDestinations.suggestedNeeds) { prompt in
                        SearchPromptRow(prompt: prompt) {
                            onSearchQuery(prompt.query)
                        }
                    }
                }
            }

            popularQueryChips

            cityShortcuts

            likelyNextRows
        }
    }

    private var focusedContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            SearchChipWrap(title: "Quick suggestions", chips: BrowseSearchDestinations.focusedQueryChips) { chip in
                onSearchQuery(chip)
            }

            SearchSection(title: "Try searching for") {
                LazyVStack(spacing: 10) {
                    ForEach(BrowseSearchDestinations.focusedSuggestions) { prompt in
                        SearchPromptRow(prompt: prompt) {
                            onSearchQuery(prompt.query)
                        }
                    }
                }
            }

            HStack(spacing: 8) {
                Image(systemName: "lightbulb")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.orange)

                Text("Type English, Vietnamese, or a situation")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func resultsContent(results: SearchPageResults) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            resultFilters

            if selectedFilter.includesCategories, !results.collectionResults.isEmpty {
                SearchSection(title: "Best match") {
                    LazyVStack(spacing: 12) {
                        ForEach(results.collectionResults.prefix(3)) { match in
                            SearchCollectionCard(match: match, onOpenCollection: onOpenCollection)
                        }
                    }
                }
            }

            if selectedFilter.includesPhrases, !results.phraseResults.isEmpty {
                SearchSection(title: "Best matches") {
                    LazyVStack(spacing: 10) {
                        ForEach(results.phraseResults.prefix(5)) { item in
                            SearchPhraseRow(item: item, onOpenDetail: onOpenDetail)
                        }
                    }
                    .padding(14)
                    .phraseListCard(cornerRadius: 24)
                }
            }

            if selectedFilter.includesCities, !results.cityResults.isEmpty {
                SearchSection(title: "Cities") {
                    cityShortcutRow(cities: results.cityResults)
                }
            }

            relatedSearches(query: results.query)
        }
    }

    private var recoveryContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            SearchChipWrap(title: "Try instead", chips: BrowseSearchDestinations.emptyRecoveryChips) { chip in
                onSearchQuery(chip)
            }

            LazyVStack(spacing: 14) {
                ForEach(BrowseSearchDestinations.recoveryActions) { action in
                    SearchRecoveryCard(action: action) {
                        if let pageID = action.openablePageID {
                            onOpenDetail(pageID)
                        } else {
                            onSearchQuery(action.title)
                        }
                    }
                }

                SearchBrowseAllRecoveryCard(onBrowseTapped: onBrowseTapped)
            }
        }
    }

    private var popularQueryChips: some View {
        SearchSection(title: "Popular right now") {
            FlexibleChipGrid(items: BrowseSearchDestinations.popularQueries) { prompt in
                SearchIconChip(
                    title: prompt.title,
                    symbolName: prompt.symbolName,
                    tintName: prompt.tintName
                ) {
                    onSearchQuery(prompt.query)
                }
            }
        }
    }

    private var cityShortcuts: some View {
        SearchSection(title: "City shortcuts") {
            cityShortcutRow(cities: BrowseSearchDestinations.cityShortcuts.filter { $0.id != "all-vietnam" })
        }
    }

    private func cityShortcutRow(cities: [BrowseCityShortcut]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(cities) { city in
                        SearchCityCard(city: city) {
                            onOpenCollection(city.collectionRoute)
                        }
                    }
                }
            .padding(.bottom, 2)
        }
        .scrollClipDisabled()
    }

    private var likelyNextRows: some View {
        let items = BrowseSearchDestinations.phraseItems(
            for: BrowseSearchDestinations.likelyNextPageIDs,
            limit: 3
        )

        return SearchSection(title: "Likely next") {
            LazyVStack(spacing: 10) {
                ForEach(items) { item in
                    SearchPhraseRow(item: item, onOpenDetail: onOpenDetail)
                }
            }
        }
    }

    private var resultFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(SearchResultFilter.allCases) { filter in
                    Button {
                        selectedFilter = filter
                    } label: {
                        HStack(spacing: 7) {
                            Image(systemName: filter.symbolName)
                                .font(.subheadline.weight(.semibold))
                            Text(filter.title)
                                .font(.subheadline.weight(.bold))
                        }
                        .foregroundStyle(filter == selectedFilter ? .red : .secondary)
                        .padding(.horizontal, 14)
                        .frame(height: 46)
                        .nativeGlass(cornerRadius: 23, interactive: true)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("Search.Filter.\(filter.title)")
                }
            }
            .padding(.bottom, 2)
        }
        .scrollClipDisabled()
    }

    private func relatedSearches(query: String) -> some View {
        SearchChipWrap(title: "Related searches", chips: relatedSearchChips(for: query)) { chip in
            onSearchQuery(chip)
        }
    }

    private func relatedSearchChips(for query: String) -> [String] {
        let normalized = query.lowercased()
        if normalized.contains("hotel") {
            return ["taxi to hotel", "late checkout", "breakfast time"]
        }
        if normalized.contains("food") {
            return ["food allergies", "pay by card", "water"]
        }
        return ["taxi", "bathroom", "thank you"]
    }

    @ViewBuilder
    private var searchBottomChrome: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: AppChromeLayout.bottomSpacing) {
                searchBottomChromeContent
            }
        } else {
            searchBottomChromeContent
        }
    }

    private var searchBottomChromeContent: some View {
        HStack(spacing: AppChromeLayout.bottomSpacing) {
            Button {
                onClose()
            } label: {
                Image(systemName: "house.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.red)
                    .frame(width: AppChromeLayout.searchIslandSize, height: AppChromeLayout.searchIslandSize)
            }
            .buttonStyle(.plain)
            .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.red)

                TextField("Search Vietnamese phrases", text: $query)
                    .font(.body.weight(.semibold))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($localSearchFieldFocused)
            }
            .padding(.horizontal, AppChromeLayout.searchFieldHorizontalPadding)
            .frame(height: AppChromeLayout.searchFieldHeight)
            .frame(maxWidth: .infinity)
            .nativeGlass(cornerRadius: AppChromeLayout.searchIslandCornerRadius, interactive: true)
            .nativeGlassMorphID(AppChromeMorphID.search, namespace: chromeNamespace)
            .chromeMorph(AppChromeMorphID.search, namespace: chromeNamespace, isSource: true)
        }
    }
}

private struct SearchPageResults {
    let query: String
    let phraseResults: [BrowseSearchPhraseItem]
    let collectionResults: [BrowseSearchCollectionMatch]
    let cityResults: [BrowseCityShortcut]

    init(query: String) {
        self.query = query

        guard !query.isEmpty else {
            phraseResults = []
            collectionResults = []
            cityResults = []
            return
        }

        phraseResults = BrowseSearchDestinations.searchResults(for: query, limit: 8)
        collectionResults = BrowseSearchDestinations.matchingCollections(for: query)
        cityResults = BrowseSearchDestinations.matchingCities(for: query)
    }

    var hasResults: Bool {
        !collectionResults.isEmpty || !phraseResults.isEmpty || !cityResults.isEmpty
    }

    var headerTitle: String {
        guard !query.isEmpty else {
            return "Search"
        }

        return hasResults ? "Results for \(query)" : "No exact match"
    }

    var headerSubtitle: String {
        guard !query.isEmpty else {
            return "Find phrases by English, Vietnamese, situation, or what you want to do next."
        }

        return hasResults ? "Here are the most helpful matches." : "Try a nearby travel need or browse by situation."
    }
}

private enum SearchResultFilter: CaseIterable, Identifiable {
    case all
    case phrases
    case categories
    case cities

    var id: String { title }

    var title: String {
        switch self {
        case .all:
            return "All"
        case .phrases:
            return "Phrases"
        case .categories:
            return "Categories"
        case .cities:
            return "Cities"
        }
    }

    var symbolName: String {
        switch self {
        case .all:
            return "square.grid.2x2"
        case .phrases:
            return "ellipsis.bubble"
        case .categories:
            return "signpost.right"
        case .cities:
            return "building.2"
        }
    }

    var includesPhrases: Bool { self == .all || self == .phrases }
    var includesCategories: Bool { self == .all || self == .categories }
    var includesCities: Bool { self == .all || self == .cities }
}

private struct SearchSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)

            content
        }
    }
}

private struct SearchPromptRow: View {
    let prompt: SearchPrompt
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: prompt.symbolName)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(prompt.tintName.color)
                    .frame(width: 48, height: 48)
                    .nativeGlass(cornerRadius: 24, tint: prompt.tintName.color.opacity(0.16), interactive: true)

                VStack(alignment: .leading, spacing: 3) {
                    Text(prompt.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(prompt.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .phraseListCard(cornerRadius: 22)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Search.Prompt.\(prompt.id)")
    }
}

private struct SearchPhraseRow: View {
    let item: BrowseSearchPhraseItem
    let onOpenDetail: (String) -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: item.symbolName)
                .font(.headline.weight(.semibold))
                .foregroundStyle(item.tintName.color)
                .frame(width: 46, height: 46)
                .nativeGlass(cornerRadius: 23, tint: item.tintName.color.opacity(0.16), interactive: true)

            Button {
                onOpenDetail(item.pageID)
            } label: {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.title)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(item.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(SearchResultRowLayout.subtitleLineLimit)
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
            .accessibilityIdentifier("SearchResult.\(item.pageID)")

            AudioSpeakerButton(
                tint: item.tintName,
                size: 38,
                audioKey: item.audioKey,
                accessibilityIdentifier: "SearchResult.Audio.\(item.pageID)"
            )
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .background(.white.opacity(0.48), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        }
        .accessibilityElement(children: .contain)
    }
}

private struct SearchCollectionCard: View {
    let match: BrowseSearchCollectionMatch
    let onOpenCollection: (BrowseCollectionRoute) -> Void

    var body: some View {
        let descriptor = match.descriptor

        Button {
            onOpenCollection(descriptor.route)
        } label: {
            HStack(spacing: 14) {
                Image(descriptor.mastheadImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 96, height: 104)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(alignment: .topLeading) {
                        Text(labelText(for: descriptor.route))
                            .font(.caption2.weight(.black))
                            .foregroundStyle(descriptor.tintName.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 5)
                            .background(.white.opacity(0.86), in: Capsule())
                            .padding(8)
                    }

                VStack(alignment: .leading, spacing: 7) {
                    Text("Browse collection")
                        .font(.caption2.weight(.black))
                        .foregroundStyle(descriptor.tintName.color)
                        .textCase(.uppercase)

                    Text(descriptor.title)
                        .font(.title3.weight(.black))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)

                    Text(descriptor.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 8) {
                        Text("Open in Browse")
                            .font(.caption.weight(.black))
                        Image(systemName: "chevron.right")
                            .font(.caption2.weight(.black))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .frame(height: 32)
                    .background(Color.red, in: Capsule())
                }
                .layoutPriority(1)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .phraseListCard(cornerRadius: 24)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Search.Collection.\(descriptor.route.id)")
    }

    private func labelText(for route: BrowseCollectionRoute) -> String {
        switch route {
        case .category:
            return "Category"
        case .city:
            return "City"
        }
    }
}

private struct SearchSituationCard: View {
    let destination: BrowseDestination
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: destination.symbolName)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(destination.tintName.color)
                        .frame(width: 46, height: 46)
                        .nativeGlass(cornerRadius: 23, tint: destination.tintName.color.opacity(0.16), interactive: true)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
                }

                Text(destination.title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                Text("\(destination.itemCount) phrases")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .frame(width: 152, height: 154, alignment: .topLeading)
            .phraseListCard(cornerRadius: 22)
        }
        .buttonStyle(.plain)
    }
}

private struct SearchCityCard: View {
    let city: BrowseCityShortcut
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: city.symbolName)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(city.tintName.color)
                    .frame(width: 52, height: 52)
                    .nativeGlass(cornerRadius: 19, tint: city.tintName.color.opacity(0.14), interactive: true)

                Text(city.title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.72)
            }
            .padding(10)
            .frame(width: 112, height: 122)
            .phraseListCard(cornerRadius: 18)
        }
        .buttonStyle(.plain)
    }
}

private struct SearchRecoveryCard: View {
    let action: SearchRecoveryAction
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: action.symbolName)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(action.tintName.color)
                    .frame(width: 64, height: 64)
                    .nativeGlass(cornerRadius: 32, tint: action.tintName.color.opacity(0.16), interactive: true)

                VStack(alignment: .leading, spacing: 8) {
                    Text(action.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)

                    Text(action.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(action.highlight)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(action.tintName.color)
                        .lineLimit(1)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(action.tintName.color.opacity(0.09), in: Capsule())
                }
                .layoutPriority(1)

                Image(systemName: "chevron.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.red)
                    .frame(width: 42, height: 42)
                    .nativeGlass(cornerRadius: 21, interactive: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .phraseListCard(cornerRadius: 24)
        }
        .buttonStyle(.plain)
    }
}

private struct SearchBrowseAllRecoveryCard: View {
    let onBrowseTapped: () -> Void

    var body: some View {
        Button(action: onBrowseTapped) {
            HStack(spacing: 14) {
                Image(systemName: "square.grid.2x2")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.orange)
                    .frame(width: 46, height: 46)
                    .nativeGlass(cornerRadius: 23, interactive: true)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Browse all situations")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Airport, Hotel, Food, Emergency, and more")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .layoutPriority(1)

                Image(systemName: "chevron.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.red)
            }
            .padding(14)
            .phraseListCard(cornerRadius: 22)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Search.BrowseAllSituations")
    }
}

private struct SearchChipWrap: View {
    let title: String
    let chips: [String]
    let onTap: (String) -> Void

    var body: some View {
        SearchSection(title: title) {
            StringChipGrid(items: chips) { chip in
                SearchTextChip(title: chip) {
                    onTap(chip)
                }
            }
        }
    }
}

private struct FlexibleChipGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    let items: Data
    let content: (Data.Element) -> Content

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 116), spacing: 10)], alignment: .leading, spacing: 10) {
            ForEach(items) { item in
                content(item)
            }
        }
    }
}

private struct StringChipGrid<Content: View>: View {
    let items: [String]
    let content: (String) -> Content

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 104), spacing: 10)], alignment: .leading, spacing: 10) {
            ForEach(items, id: \.self) { item in
                content(item)
            }
        }
    }
}

private struct SearchIconChip: View {
    let title: String
    let symbolName: String
    let tintName: AccentTint
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: symbolName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(tintName.color)

                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
            }
            .padding(.horizontal, 12)
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .nativeGlass(cornerRadius: 22, interactive: true)
        }
        .buttonStyle(.plain)
    }
}

private struct SearchTextChip: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .nativeGlass(cornerRadius: 22, interactive: true)
        }
        .buttonStyle(.plain)
    }
}

enum SearchResultRowLayout {
    static let subtitleLineLimit = 2
}

#Preview("Search default") {
    SearchPageView(onClose: {})
}

#Preview("Search results") {
    SearchPageView(query: .constant("hotel"), onClose: {})
}
