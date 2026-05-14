import Foundation

enum VietnameseMenuKind: String, CaseIterable, Equatable {
    case food = "Food"
    case drink = "Drink"

    var routeID: String {
        switch self {
        case .food:
            return "vietnamese-food-menu"
        case .drink:
            return "vietnamese-drink-menu"
        }
    }

    var title: String {
        switch self {
        case .food:
            return "Vietnamese menu"
        case .drink:
            return "Vietnamese drinks"
        }
    }

    var subtitle: String {
        switch self {
        case .food:
            return "Browse noodle soups, rice plates, and street snacks. Tap a dish to hear it and know what to order."
        case .drink:
            return "Browse Vietnamese coffee, tea, smoothies, juice, and cold drinks. Tap a drink to hear it and order with confidence."
        }
    }

    var popularTitle: String {
        switch self {
        case .food:
            return "Popular dishes"
        case .drink:
            return "Popular drinks"
        }
    }

    var heroImageName: String {
        switch self {
        case .food:
            return "HeroVietnameseFoodMenu"
        case .drink:
            return "HeroVietnameseDrinkMenu"
        }
    }

    var symbolName: String {
        switch self {
        case .food:
            return "fork.knife"
        case .drink:
            return "cup.and.saucer.fill"
        }
    }

    var tintName: AccentTint {
        switch self {
        case .food:
            return .orange
        case .drink:
            return .teal
        }
    }

    static func routeID(for kind: VietnameseMenuKind) -> String {
        kind.routeID
    }

    static func kind(forRouteID routeID: String) -> VietnameseMenuKind? {
        allCases.first { $0.routeID == routeID }
    }
}

struct VietnameseMenuItem: Identifiable, Decodable, Equatable {
    let itemID: String
    let menuType: String
    let category: String
    let subcategory: String
    let popular: Bool
    let vietnameseItem: String
    let englishTranslation: String
    let romanizedNoTones: String
    let soundOut: String
    let notes: String
    let atAGlance: String
    let usuallyIncludes: [String]
    let goodToKnow: String
    let commonOptions: [String]
    let quickSayVietnamese: String
    let quickSayEnglish: String
    let quickSaySoundOut: String

    var id: String { itemID }
    var detailPageID: String { "viet-menu-\(itemID)" }
    var menuImageName: String { VietnameseMenuImages.assetName(forItemID: itemID) }

    var kind: VietnameseMenuKind? {
        VietnameseMenuKind(rawValue: menuType)
    }

    var displayPronunciation: String {
        soundOut.isEmpty ? romanizedNoTones : soundOut
    }
}

struct VietnameseMenuCategory: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let symbolName: String
    let tintName: AccentTint
    let featuredImageName: String
    let items: [VietnameseMenuItem]

    var itemCount: Int { items.count }
}

enum VietnameseMenuImages {
    static func assetName(forItemID itemID: String) -> String {
        "HeroMenu" + itemID
            .split(separator: "-")
            .map { component in
                component.prefix(1).uppercased() + component.dropFirst()
            }
            .joined()
    }
}

private struct VietnameseMenuPayload: Decodable {
    let items: [VietnameseMenuItem]
}

enum VietnameseMenuCatalog {
    static let allItems: [VietnameseMenuItem] = loadItems()

    static func kind(for route: BrowseCollectionRoute) -> VietnameseMenuKind? {
        guard case .category(let id) = route else {
            return nil
        }

        return VietnameseMenuKind.kind(forRouteID: id)
    }

    static func items(for kind: VietnameseMenuKind) -> [VietnameseMenuItem] {
        allItems.filter { $0.kind == kind }
    }

    static func categories(for kind: VietnameseMenuKind) -> [VietnameseMenuCategory] {
        let rowsByCategory = Dictionary(grouping: items(for: kind), by: \.category)
        let order = categoryOrder(for: kind)
        let sortedTitles = rowsByCategory.keys.sorted { lhs, rhs in
            let lhsIndex = order.firstIndex(of: lhs) ?? Int.max
            let rhsIndex = order.firstIndex(of: rhs) ?? Int.max

            if lhsIndex == rhsIndex {
                return lhs.localizedCaseInsensitiveCompare(rhs) == .orderedAscending
            }

            return lhsIndex < rhsIndex
        }

        return sortedTitles.compactMap { title in
            guard let items = rowsByCategory[title], !items.isEmpty else {
                return nil
            }

            return VietnameseMenuCategory(
                id: categoryID(for: title),
                title: categoryDisplayTitle(title),
                subtitle: categorySubtitle(for: title),
                symbolName: categorySymbolName(for: title, kind: kind),
                tintName: categoryTintName(for: title, kind: kind),
                featuredImageName: featuredImageName(for: title, items: items),
                items: items
            )
        }
    }

    static func popularItems(for kind: VietnameseMenuKind, limit: Int = 5) -> [VietnameseMenuItem] {
        Array(items(for: kind).filter(\.popular).prefix(limit))
    }

    static func detailItem(withPageID pageID: String) -> VietnameseMenuItem? {
        guard pageID.hasPrefix("viet-menu-") else {
            return nil
        }

        let itemID = String(pageID.dropFirst("viet-menu-".count))
        return allItems.first { $0.itemID == itemID }
    }

    static func detailPage(withID pageID: String) -> PhraseDetailPage? {
        guard let item = detailItem(withPageID: pageID), let kind = item.kind else {
            return nil
        }

        let includeTokens = item.usuallyIncludes.enumerated().map { index, value in
            BreakdownToken(id: "include-\(index)-\(slug(value))", vietnamese: value, english: "")
        }
        let optionTokens = item.commonOptions.enumerated().map { index, value in
            BreakdownToken(id: "option-\(index)-\(slug(value))", vietnamese: value, english: "")
        }
        let quickSay = PhraseOption(
            id: "\(item.detailPageID)-quick-say",
            vietnamese: item.quickSayVietnamese,
            english: item.quickSayEnglish,
            pronunciation: item.quickSaySoundOut,
            symbolName: "speaker.wave.2.fill",
            tintName: kind.tintName,
            detailPageID: nil
        )

        return PhraseDetailPage(
            id: item.detailPageID,
            title: item.vietnameseItem,
            englishTitle: item.englishTranslation,
            pronunciation: item.displayPronunciation,
            summary: item.atAGlance,
            iconName: kind.symbolName,
            tintName: kind.tintName,
            heroImageName: heroImageName(for: item, kind: kind),
            sections: [
                PhraseDetailSection(
                    id: "at-glance",
                    title: "At a glance",
                    body: item.atAGlance
                ),
                PhraseDetailSection(
                    id: "usually-includes",
                    title: "Usually includes",
                    body: "",
                    breakdown: includeTokens,
                    presentation: .breakdownStrip
                ),
                PhraseDetailSection(
                    id: "good-to-know",
                    title: "Good to know",
                    body: item.goodToKnow,
                    presentation: .tipCallout
                ),
                PhraseDetailSection(
                    id: "common-options",
                    title: "Common options",
                    body: "",
                    breakdown: optionTokens,
                    presentation: .breakdownStrip
                ),
                PhraseDetailSection(
                    id: "standard-way",
                    title: "Quick say",
                    body: "",
                    phrases: [quickSay],
                    presentation: .phraseList
                ),
            ],
            examples: [],
            audioKey: nil,
            practiceCTALabel: "Practice ordering this",
            showsCatalogExplore: false
        )
    }

    static func descriptor(for kind: VietnameseMenuKind) -> BrowseCollectionDescriptor {
        let starterItems = popularItems(for: kind, limit: 5).map(phraseItem(for:))
        let subcategories = categories(for: kind).prefix(8).map { category in
            BrowseCollectionSubcategory(
                id: "\(kind.routeID).\(category.id)",
                title: category.title,
                subtitle: category.subtitle,
                symbolName: category.symbolName,
                tintName: category.tintName,
                phraseCount: category.itemCount,
                countUnit: "item",
                items: category.items.prefix(4).map(phraseItem(for:))
            )
        }

        return BrowseCollectionDescriptor(
            route: .category(kind.routeID),
            title: kind.title,
            subtitle: kind.subtitle,
            eyebrow: "SPEAKLOCAL VIETNAM",
            mastheadImageName: kind.heroImageName,
            symbolName: kind.symbolName,
            tintName: kind.tintName,
            subcategories: Array(subcategories),
            starterTitle: kind.popularTitle,
            starterItems: starterItems,
            practiceTitle: "Practice ordering",
            practiceSubtitle: "Use quick phrases from the menu.",
            practiceAction: .addStarterPages(starterItems.map(\.pageID)),
            exploreShelves: []
        )
    }

    static func phraseItem(for item: VietnameseMenuItem) -> BrowseSearchPhraseItem {
        BrowseSearchPhraseItem(
            pageID: item.detailPageID,
            title: item.vietnameseItem,
            subtitle: item.englishTranslation,
            symbolName: item.kind?.symbolName ?? "fork.knife",
            tintName: item.kind?.tintName ?? .orange,
            audioKey: AudioAssetManifest.main?.audioKey(forExactText: item.vietnameseItem)
        )
    }

    static func categoryID(for title: String) -> String {
        slug(title)
    }

    private static func heroImageName(for item: VietnameseMenuItem, kind: VietnameseMenuKind) -> String {
        item.kind == nil ? kind.heroImageName : item.menuImageName
    }

    private static func categoryOrder(for kind: VietnameseMenuKind) -> [String] {
        switch kind {
        case .food:
            return [
                "Noodle soups",
                "Dry noodles & vermicelli",
                "Rice & sticky rice",
                "Rolls, appetizers & street snacks",
                "Bánh mì, bread & buns",
                "Pork",
                "Chicken & duck",
                "Beef & goat",
                "Seafood",
                "Vegetarian",
                "Soups, hot pots & family-style",
                "Desserts & sweets",
            ]
        case .drink:
            return [
                "Coffee",
                "Tea",
                "Smoothies",
                "Juices & fresh drinks",
                "Water, soda & other drinks",
            ]
        }
    }

    private static func categoryDisplayTitle(_ title: String) -> String {
        switch title {
        case "Dry noodles & vermicelli":
            return "Vermicelli"
        case "Rice & sticky rice":
            return "Rice"
        case "Rolls, appetizers & street snacks":
            return "Street snacks"
        case "Bánh mì, bread & buns":
            return "Bánh mì"
        case "Chicken & duck":
            return "Chicken & duck"
        case "Beef & goat":
            return "Beef & goat"
        case "Soups, hot pots & family-style":
            return "Family-style"
        case "Desserts & sweets":
            return "Desserts"
        case "Juices & fresh drinks":
            return "Fresh juices"
        case "Water, soda & other drinks":
            return "Water & more"
        default:
            return title
        }
    }

    private static func categorySubtitle(for title: String) -> String {
        switch title {
        case "Noodle soups":
            return "phở, bún, mì"
        case "Dry noodles & vermicelli":
            return "bún, noodles"
        case "Rice & sticky rice":
            return "cơm, xôi"
        case "Rolls, appetizers & street snacks":
            return "rolls, snacks"
        case "Bánh mì, bread & buns":
            return "bread, buns"
        case "Pork":
            return "grilled, braised"
        case "Chicken & duck":
            return "grilled, roasted"
        case "Beef & goat":
            return "stews, grilled"
        case "Seafood":
            return "fish, shrimp, crab"
        case "Vegetarian":
            return "tofu, greens"
        case "Soups, hot pots & family-style":
            return "soups, hot pot"
        case "Desserts & sweets":
            return "chè, sweets"
        case "Coffee":
            return "iced, black, milk"
        case "Tea":
            return "iced, hot, herbal"
        case "Smoothies":
            return "mango, avocado"
        case "Juices & fresh drinks":
            return "fruit, cane, coconut"
        case "Water, soda & other drinks":
            return "water, soda, beer"
        default:
            return "menu items"
        }
    }

    private static func categorySymbolName(for title: String, kind: VietnameseMenuKind) -> String {
        switch title {
        case "Noodle soups":
            return "takeoutbag.and.cup.and.straw.fill"
        case "Rice & sticky rice":
            return "bowl.fill"
        case "Pork":
            return "fork.knife"
        case "Chicken & duck":
            return "bird.fill"
        case "Seafood":
            return "fish.fill"
        case "Vegetarian":
            return "leaf.fill"
        case "Coffee":
            return "cup.and.saucer.fill"
        case "Tea":
            return "leaf.fill"
        case "Smoothies", "Juices & fresh drinks":
            return "takeoutbag.and.cup.and.straw.fill"
        case "Water, soda & other drinks":
            return "drop.fill"
        default:
            return kind.symbolName
        }
    }

    private static func categoryTintName(for title: String, kind: VietnameseMenuKind) -> AccentTint {
        switch title {
        case "Noodle soups", "Tea", "Vegetarian":
            return .green
        case "Seafood", "Water, soda & other drinks":
            return .blue
        case "Smoothies":
            return .orange
        case "Juices & fresh drinks":
            return .red
        default:
            return kind.tintName
        }
    }

    private static func featuredImageName(for title: String, items: [VietnameseMenuItem]) -> String {
        let preferredItemID: String?
        switch title {
        case "Seafood":
            preferredItemID = "food-tom-rang-muoi"
        case "Pork":
            preferredItemID = "food-suon-nuong"
        case "Chicken & duck":
            preferredItemID = "food-ga-nuong-muoi-ot"
        case "Vegetarian":
            preferredItemID = "food-dau-hu-chien-gion"
        case "Coffee":
            preferredItemID = "drink-ca-phe-sua-da"
        case "Tea":
            preferredItemID = "drink-tra-da"
        case "Smoothies":
            preferredItemID = "drink-sinh-to-xoai"
        case "Water, soda & other drinks":
            preferredItemID = "drink-nuoc-mia"
        default:
            preferredItemID = nil
        }

        if let preferredItemID, let preferredItem = items.first(where: { $0.itemID == preferredItemID }) {
            return preferredItem.menuImageName
        }

        return items.first(where: \.popular)?.menuImageName ?? items.first?.menuImageName ?? VietnameseMenuKind.food.heroImageName
    }

    private static func slug(_ value: String) -> String {
        let folded = value
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
            .lowercased()
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "&", with: " and ")
            .replacingOccurrences(of: #"[^a-z0-9]+"#, with: "-", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))

        return folded.isEmpty ? "menu-item" : folded
    }

    private static func loadItems() -> [VietnameseMenuItem] {
        guard
            let url = Bundle.main.url(forResource: "vietnamese-menu-copy", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let payload = try? JSONDecoder().decode(VietnameseMenuPayload.self, from: data)
        else {
            return []
        }

        return payload.items
    }
}
