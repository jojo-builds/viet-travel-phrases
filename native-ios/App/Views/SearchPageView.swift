import SwiftUI

struct SearchPageView: View {
    @Binding private var query: String

    let chromeNamespace: Namespace.ID?
    let showsChrome: Bool
    let onClose: () -> Void
    var onOpenDetail: (String) -> Void = { _ in }

    init(
        query: Binding<String> = .constant(""),
        chromeNamespace: Namespace.ID? = nil,
        showsChrome: Bool = true,
        onClose: @escaping () -> Void,
        onOpenDetail: @escaping (String) -> Void = { _ in }
    ) {
        _query = query
        self.chromeNamespace = chromeNamespace
        self.showsChrome = showsChrome
        self.onClose = onClose
        self.onOpenDetail = onOpenDetail
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(red: 0.96, green: 0.97, blue: 0.98)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: SearchPageLayout.contentSpacing) {
                    Text("Search")
                        .font(.system(size: 42, weight: .bold))
                        .padding(.top, SearchPageLayout.titleTopPadding)

                    Text("Find phrases by English, Vietnamese, situation, or what you want to do next.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(3)

                    LazyVStack(alignment: .leading, spacing: SearchPageLayout.resultGroupSpacing) {
                        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            SearchSuggestionRow(title: "Different ways to say hello", subtitle: "Xin chào, chào bạn, chào anh/chị")
                            SearchSuggestionRow(title: "Ask for directions", subtitle: "How do I get there, take me here")
                            SearchSuggestionRow(title: "When you don't understand", subtitle: "What does it mean, please repeat, write it down")
                        } else {
                            let results = PhraseSearchIndex.search(query)

                            if results.isEmpty {
                                Text("No matching phrase pages yet.")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(.white.opacity(0.68), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                            } else {
                                ForEach(results.prefix(8)) { result in
                                    SearchResultRow(result: result, onOpenDetail: onOpenDetail)
                                }
                            }
                        }
                    }
                    .padding(.top, SearchPageLayout.resultGroupTopPadding)
                }
                .padding(.horizontal, SearchPageLayout.horizontalPadding)
                .padding(.bottom, SearchPageLayout.resultsBottomClearance)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scrollDismissesKeyboard(.interactively)
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
                    .foregroundStyle(.secondary)

                TextField("Search Vietnamese phrases", text: $query)
                    .font(.body.weight(.semibold))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                if !query.isEmpty {
                    Button {
                        query = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
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

private struct SearchSuggestionRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "magnifyingglass")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.red)
                .frame(width: 42, height: 42)
                .nativeGlass(cornerRadius: 21)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline.weight(.semibold))
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(14)
        .background(.white.opacity(0.68), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        }
    }
}

private struct SearchResultRow: View {
    let result: PhraseSearchResult
    let onOpenDetail: (String) -> Void

    var body: some View {
        Button {
            onOpenDetail(result.pageID)
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.red)
                    .frame(width: 42, height: 42)
                    .nativeGlass(cornerRadius: 21)

                VStack(alignment: .leading, spacing: 3) {
                    Text(result.title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(result.subtitle)
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
        }
        .buttonStyle(.plain)
        .padding(14)
        .background(.white.opacity(0.68), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        }
    }
}

enum SearchResultRowLayout {
    static let subtitleLineLimit = 2
}

#Preview {
    SearchPageView(onClose: {})
}
