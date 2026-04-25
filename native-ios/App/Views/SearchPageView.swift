import SwiftUI

struct SearchPageView: View {
    @State private var query = ""

    let onClose: () -> Void
    var onOpenDetail: (String) -> Void = { _ in }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(red: 0.96, green: 0.97, blue: 0.98)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                Text("Search")
                    .font(.system(size: 42, weight: .bold))
                    .padding(.top, 74)

                Text("Find phrases by English, Vietnamese, situation, or what you want to do next.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)

                VStack(alignment: .leading, spacing: 12) {
                    if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        SearchSuggestionRow(title: "Different ways to say hello", subtitle: "Xin chào, chào bạn, chào anh/chị")
                        SearchSuggestionRow(title: "Ask for directions", subtitle: "How do I get there, take me here")
                        SearchSuggestionRow(title: "Repair the conversation", subtitle: "I don't understand, please repeat")
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
                .padding(.top, 10)

                Spacer()
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, alignment: .leading)

            searchBottomChrome
                .padding(.horizontal, 16)
                .padding(.bottom, -14)
                .offset(y: 14)
        }
    }

    private var searchBottomChrome: some View {
        HStack(spacing: 10) {
            Button {
                onClose()
            } label: {
                Image(systemName: "house.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.red)
                    .frame(width: 60, height: 60)
            }
            .buttonStyle(.plain)
            .nativeGlass(cornerRadius: 30, interactive: true)

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
            .padding(.horizontal, 16)
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .nativeGlass(cornerRadius: 30, interactive: true)
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

                    Text(result.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

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

#Preview {
    SearchPageView(onClose: {})
}
