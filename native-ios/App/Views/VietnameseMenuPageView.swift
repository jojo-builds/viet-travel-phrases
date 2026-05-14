import SwiftUI

struct VietnameseMenuPageView: View {
    let kind: VietnameseMenuKind
    let scrollToTopTrigger: Int
    let scrollToTopRoute: BrowseCollectionRoute?
    var onOpenDetail: (String) -> Void

    @State private var selectedCategoryID: String?

    private var route: BrowseCollectionRoute {
        .category(kind.routeID)
    }

    private var categories: [VietnameseMenuCategory] {
        VietnameseMenuCatalog.categories(for: kind)
    }

    private var selectedCategory: VietnameseMenuCategory? {
        categories.first { $0.id == selectedCategoryID }
    }

    private var visibleItems: [VietnameseMenuItem] {
        if let selectedCategory {
            return Array(selectedCategory.items.prefix(24))
        }

        return VietnameseMenuCatalog.popularItems(for: kind, limit: 5)
    }

    private var visibleItemsTitle: String {
        selectedCategory?.title ?? kind.popularTitle
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: VietnameseMenuLayout.sectionSpacing) {
                        header
                            .id(Self.scrollTopID)

                        filterRail

                        browseByTypeSection
                            .padding(.horizontal, VietnameseMenuLayout.horizontalPadding)

                        itemListSection
                            .padding(.horizontal, VietnameseMenuLayout.horizontalPadding)
                    }
                    .padding(.bottom, VietnameseMenuLayout.bottomChromeContentClearance)
                }
                .onChange(of: scrollToTopTrigger) { _, _ in
                    guard scrollToTopRoute == nil || scrollToTopRoute == route else {
                        return
                    }

                    scrollProxy.scrollTo(Self.scrollTopID, anchor: .top)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .accessibilityIdentifier("VietnameseMenu.\(kind.routeID)")
    }

    private static let scrollTopID = "VietnameseMenuPageTop"

    private var header: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeroMastheadImage(imageName: kind.heroImageName, height: VietnameseMenuLayout.heroHeight)

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

                Text(kind.title)
                    .font(.system(size: 46, weight: .black, design: .serif))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.68)
                    .accessibilityIdentifier("VietnameseMenu.Title.\(kind.routeID)")

                Text(kind.subtitle)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, VietnameseMenuLayout.horizontalPadding)
            .padding(.top, 16)
        }
    }

    private var filterRail: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                VietnameseMenuFilterCard(
                    title: "Popular",
                    symbolName: "star.fill",
                    tintName: .orange,
                    isSelected: selectedCategoryID == nil,
                    action: { selectedCategoryID = nil }
                )
                .padding(.leading, VietnameseMenuLayout.horizontalPadding)

                ForEach(categories.prefix(kind == .food ? 6 : 5)) { category in
                    VietnameseMenuFilterCard(
                        title: category.title,
                        symbolName: category.symbolName,
                        tintName: category.tintName,
                        isSelected: selectedCategoryID == category.id,
                        action: { selectedCategoryID = category.id }
                    )
                }
            }
            .padding(.trailing, VietnameseMenuLayout.horizontalPadding)
            .padding(.bottom, 2)
        }
        .scrollClipDisabled()
    }

    private var browseByTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Browse by type")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)

                Spacer()

                Button {
                    selectedCategoryID = nil
                } label: {
                    Text("View all")
                        .font(.subheadline.weight(.black))
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
            }

            LazyVGrid(columns: VietnameseMenuLayout.typeColumns, spacing: 12) {
                ForEach(typeCardCategories) { category in
                    VietnameseMenuTypeCard(
                        category: category,
                        isSelected: selectedCategoryID == category.id,
                        action: { selectedCategoryID = category.id }
                    )
                }
            }
        }
    }

    private var typeCardCategories: [VietnameseMenuCategory] {
        let preferredTitles: [String]
        switch kind {
        case .food:
            preferredTitles = ["Seafood", "Pork", "Chicken & duck", "Vegetarian"]
        case .drink:
            preferredTitles = ["Coffee", "Tea", "Smoothies", "Water & more"]
        }

        let preferred = preferredTitles.compactMap { title in
            categories.first { $0.title == title }
        }
        return preferred.isEmpty ? Array(categories.prefix(4)) : preferred
    }

    private var itemListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(visibleItemsTitle)
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)

            VStack(spacing: 0) {
                ForEach(visibleItems) { item in
                    VietnameseMenuItemRow(
                        item: item,
                        heroImageName: menuThumbnailImageName(for: item),
                        onOpenDetail: { onOpenDetail(item.detailPageID) }
                    )

                    if item.id != visibleItems.last?.id {
                        Divider().padding(.leading, 86)
                    }
                }
            }
            .padding(.vertical, 8)
            .phraseListCard(cornerRadius: 24)
        }
    }

    private func menuThumbnailImageName(for item: VietnameseMenuItem) -> String {
        item.menuImageName
    }
}

private enum VietnameseMenuLayout {
    static let horizontalPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 20
    static let heroHeight: CGFloat = 240
    static let bottomChromeContentClearance: CGFloat = 132
    static let typeColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]
}

private struct VietnameseMenuFilterCard: View {
    let title: String
    let symbolName: String
    let tintName: AccentTint
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: symbolName)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(tintName.color)
                    .frame(width: 42, height: 42)
                    .nativeGlass(cornerRadius: 21, tint: tintName.color.opacity(0.15), interactive: true)

                Text(title)
                    .font(.subheadline.weight(.black))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.74)
            }
            .padding(.horizontal, 8)
            .frame(width: 106, height: 108)
            .background(isSelected ? tintName.color.opacity(0.10) : .white.opacity(0.72), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(isSelected ? tintName.color.opacity(0.42) : Color.black.opacity(0.06), lineWidth: 1)
                    .allowsHitTesting(false)
            }
            .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("VietnameseMenu.Filter.\(title)")
    }
}

private struct VietnameseMenuTypeCard: View {
    let category: VietnameseMenuCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                Image(category.featuredImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 102)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .overlay(alignment: .bottom) {
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.12)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 34)
                    }
                    .overlay(alignment: .topTrailing) {
                        Image(systemName: category.symbolName)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(category.tintName.color)
                            .frame(width: 30, height: 30)
                            .nativeGlass(cornerRadius: 15, tint: .white.opacity(0.2), interactive: false)
                            .padding(8)
                    }

                VStack(alignment: .leading, spacing: 3) {
                    Text(category.title)
                        .font(.headline.weight(.black))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.76)

                    Text(category.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.76)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white.opacity(0.96))
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .background(isSelected ? category.tintName.color.opacity(0.08) : .clear, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? category.tintName.color.opacity(0.48) : Color.black.opacity(0.06), lineWidth: 1)
                    .allowsHitTesting(false)
            }
            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 8)
            .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("VietnameseMenu.TypeCard.\(category.id)")
    }
}

private struct VietnameseMenuItemRow: View {
    let item: VietnameseMenuItem
    let heroImageName: String
    let onOpenDetail: () -> Void

    var body: some View {
        Button(action: onOpenDetail) {
            HStack(spacing: 14) {
                Image(heroImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 62, height: 62)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.white.opacity(0.8), lineWidth: 1)
                    }
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 3) {
                    Text(item.vietnameseItem)
                        .font(.headline.weight(.black))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.74)

                    Text(item.englishTranslation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)

                if let audioKey = AudioAssetManifest.main?.audioKey(forExactText: item.vietnameseItem) {
                    AudioSpeakerButton(tint: item.kind?.tintName ?? .orange, audioKey: audioKey)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.secondary.opacity(0.8))
                        .frame(width: 36, height: 36)
                        .nativeGlass(cornerRadius: 18, interactive: false)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("VietnameseMenu.Row.\(item.itemID)")
    }
}
