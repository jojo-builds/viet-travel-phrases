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
    let whatItIs: String?
    let usuallyIncludes: [String]
    let howToEnjoy: String?
    let worthKnowing: String?
    let regionalAssociation: String?
    let originPosture: String?
    let travelerCaution: String?
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

    var guideWhatItIs: String {
        whatItIs.nonEmptyValue ?? atAGlance
    }

    var guideHowToEnjoy: String {
        howToEnjoy.nonEmptyValue ?? goodToKnow
    }

    var guideWorthKnowing: String {
        worthKnowing.nonEmptyValue ?? regionalAssociation.nonEmptyValue.map { "\(vietnameseItem) is associated with \($0), but preparations can still vary by shop and region." } ?? ""
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

struct VietnameseMenuSection: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let symbolName: String
    let tintName: AccentTint
    let featuredImageName: String
    let items: [VietnameseMenuItem]
    let isPopular: Bool

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

    static func sections(for kind: VietnameseMenuKind) -> [VietnameseMenuSection] {
        let popular = VietnameseMenuSection(
            id: "popular",
            title: kind.popularTitle,
            subtitle: "Traveler favorites",
            symbolName: "star.fill",
            tintName: .orange,
            featuredImageName: popularItems(for: kind, limit: 1).first?.menuImageName ?? kind.heroImageName,
            items: popularItems(for: kind, limit: 5),
            isPopular: true
        )

        let categorySections = categories(for: kind).map { category in
            VietnameseMenuSection(
                id: category.id,
                title: category.title,
                subtitle: category.subtitle,
                symbolName: category.symbolName,
                tintName: category.tintName,
                featuredImageName: category.featuredImageName,
                items: category.items,
                isPopular: false
            )
        }

        return [popular] + categorySections
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

        let quickSay = PhraseOption(
            id: "\(item.detailPageID)-quick-say",
            vietnamese: item.quickSayVietnamese,
            english: item.quickSayEnglish,
            pronunciation: item.quickSaySoundOut,
            symbolName: "speaker.wave.2.fill",
            tintName: kind.tintName,
            detailPageID: nil
        )
        let helperPhrases = menuHelperPhrases(for: item, kind: kind)

        let worthKnowing = item.guideWorthKnowing
        let sections = [
            PhraseDetailSection(
                id: "what-it-is",
                title: "What it is",
                body: item.guideWhatItIs
            ),
            PhraseDetailSection(
                id: "usually-includes",
                title: "Usually includes",
                body: "",
                chips: item.usuallyIncludes,
                presentation: .menuChips
            ),
            PhraseDetailSection(
                id: "how-to-enjoy",
                title: "How to enjoy it",
                body: item.guideHowToEnjoy
            ),
            PhraseDetailSection(
                id: "worth-knowing",
                title: "Worth knowing",
                body: worthKnowing,
                presentation: .tipCallout
            ),
            PhraseDetailSection(
                id: "common-options",
                title: "Common options",
                body: "",
                chips: item.commonOptions,
                presentation: .menuChips
            ),
            PhraseDetailSection(
                id: "useful-phrases",
                title: "Useful phrases",
                body: "",
                phrases: helperPhrases,
                presentation: .phraseList
            ),
            PhraseDetailSection(
                id: "standard-way",
                title: "Quick say",
                body: "",
                phrases: [quickSay],
                presentation: .phraseList
            ),
        ].filter { section in
            !section.body.isEmpty || !section.phrases.isEmpty || !section.breakdown.isEmpty || !section.chips.isEmpty
        }

        return PhraseDetailPage(
            id: item.detailPageID,
            title: item.vietnameseItem,
            englishTitle: item.englishTranslation,
            pronunciation: item.displayPronunciation,
            summary: item.guideWhatItIs,
            iconName: kind.symbolName,
            tintName: kind.tintName,
            heroImageName: heroImageName(for: item, kind: kind),
            sections: sections,
            examples: [],
            audioKey: nil,
            practiceCTALabel: "Practice ordering this",
            showsCatalogExplore: false
        )
    }

    static func guideCopyAuditFailures() -> [String] {
        let genericFragments = [
            "centered on",
            "usually combines noodles or rice porridge",
            "Vietnamese menu item",
            "common drink order",
            "easy point-and-order choice",
            "meant for mixing:",
            "with the main topping",
            "bread or bun order featuring",
            "meat-free dish featuring",
            "Depending on the order",
            "strong café-style finish",
            "Vietnamese sweet with",
            "Vietnamese sweet:",
            "a tea drink that can be light",
            "fresh Vietnamese drink with",
            "cold, simple, or familiar drink order",
            "small finish that may be",
            "rice plate with rice with",
            "savory toppings and savory toppings",
        ]
        let coffeeGenericFragments = [
            "Vietnam is a major coffee country",
            "Stir before drinking if milk or cream is involved",
            "Depending on the order",
            "a Vietnamese coffee order with bold flavor",
        ]
        let visibleBlockFragments = [
            "the main topping",
            "common anchors",
            "strong café-style finish",
            "Vietnamese sweet with",
            "Vietnamese sweet:",
            "a tea drink that can be light",
            "fresh Vietnamese drink with",
            "cold, simple, or familiar drink order",
            "small finish that may be",
            "rice plate with rice with",
            "savory toppings and savory toppings",
        ]
        let foodVisibleBlockFragments = [
            "many travelers",
            "travelers picture",
            "before you travel",
            "useful to recognize",
            "without guessing from the menu",
            "helpful travel context",
            "easy to point",
            "point-and-order",
            "cautious eaters",
            "meant for mixing:",
            "easy to customize",
            "dressing or sauce",
            "broth or sauce",
            "savory sauce",
            "built around",
            "centered on",
            "broth and topping should make sense together",
        ]
        let vegetarianMeatTerms = [
            "beef",
            "pork",
            "chicken",
            "duck",
            "fish",
            "shrimp",
            "crab",
            "shellfish",
            "seafood",
            "clams",
            "cockles",
            "snails",
            "squid",
        ]
        let quickSayUnitMarkers: [(marker: String, unit: String)] = [
            ("một chai", "bottle"),
            ("một ly", "glass"),
            ("một cốc", "cup"),
            ("một tách", "cup"),
            ("một tô", "bowl"),
            ("một bát", "bowl"),
            ("một đĩa", "plate"),
            ("một ổ", "sandwich"),
            ("một phần", "order"),
        ]

        return allItems.flatMap { item in
            let guideFailures = [
                ("whatItIs", item.whatItIs),
                ("howToEnjoy", item.howToEnjoy),
                ("worthKnowing", item.worthKnowing),
            ].compactMap { fieldName, value -> String? in
                guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
                    return "\(item.itemID): missing \(fieldName)"
                }

                if let genericFragment = genericFragments.first(where: { value.localizedCaseInsensitiveContains($0) }) {
                    return "\(item.itemID): \(fieldName) contains generic fragment '\(genericFragment)'"
                }

                if item.category == "Coffee",
                   let genericFragment = coffeeGenericFragments.first(where: { value.localizedCaseInsensitiveContains($0) }) {
                    return "\(item.itemID): \(fieldName) contains generic coffee fragment '\(genericFragment)'"
                }

                return nil
            }

            let visibleText = ([item.atAGlance, item.goodToKnow, item.guideWhatItIs, item.guideHowToEnjoy, item.guideWorthKnowing, item.travelerCaution ?? ""] + item.usuallyIncludes + item.commonOptions)
                .joined(separator: "\n")
            let lowerIncludes = item.usuallyIncludes.map { $0.lowercased() }
            let searchableText = "\(item.itemID) \(item.vietnameseItem) \(item.englishTranslation)".lowercased()
            let lowerQuickSayVietnamese = item.quickSayVietnamese.lowercased()
            let lowerQuickSayEnglish = item.quickSayEnglish.lowercased()
            let isFood = item.menuType == VietnameseMenuKind.food.rawValue
            let isDrink = item.menuType == VietnameseMenuKind.drink.rawValue
            let isAlcoholDrink = item.itemID.hasPrefix("drink-bia-") || item.itemID.hasPrefix("drink-ruou-")
            let includesEggNoodles = lowerIncludes.contains { $0.contains("egg noodles") }
            let includesRiceVermicelli = lowerIncludes.contains { $0.contains("rice vermicelli") }
            let includesGlassNoodles = lowerIncludes.contains { $0.contains("glass noodles") }
            let includesTurmericRiceNoodles = lowerIncludes.contains { $0.contains("turmeric rice noodles") }
            let isBunOrVermicelli = item.itemID.contains("food-bun-")
                || item.itemID.contains("banh-hoi")
                || searchableText.contains("bún")
                || searchableText.contains("bánh hỏi")
                || searchableText.contains("vermicelli")
            let isMienOrGlassNoodles = item.itemID.contains("mien-")
                || searchableText.contains("miến")
                || searchableText.contains("glass noodle")
            let isMiQuang = item.itemID.contains("mi-quang")
                || searchableText.contains("mì quảng")

            let guardrailFailures: [String?] = [
                item.menuType == VietnameseMenuKind.drink.rawValue && item.travelerCaution?.localizedCaseInsensitiveContains("spicy") == true
                    ? "\(item.itemID): drink item has a spicy caution"
                    : nil,
                visibleBlockFragments.first(where: { visibleText.localizedCaseInsensitiveContains($0) }).map {
                    "\(item.itemID): visible menu copy contains blocked fragment '\($0)'"
                },
                item.category == "Coffee" ? coffeeGenericFragments.first(where: { visibleText.localizedCaseInsensitiveContains($0) }).map {
                    "\(item.itemID): visible coffee copy contains generic fragment '\($0)'"
                } : nil,
                isFood ? foodVisibleBlockFragments.first(where: { visibleText.localizedCaseInsensitiveContains($0) }).map {
                    "\(item.itemID): visible food copy contains blocked fragment '\($0)'"
                } : nil,
                isFood && isBunOrVermicelli && includesEggNoodles
                    ? "\(item.itemID): bún/vermicelli item includes egg noodles"
                    : nil,
                isFood && isBunOrVermicelli && !includesRiceVermicelli
                    ? "\(item.itemID): bún/vermicelli item is missing rice vermicelli"
                    : nil,
                isFood && isMienOrGlassNoodles && includesEggNoodles
                    ? "\(item.itemID): miến/glass-noodle item includes egg noodles"
                    : nil,
                isFood && isMienOrGlassNoodles && !includesGlassNoodles
                    ? "\(item.itemID): miến/glass-noodle item is missing glass noodles"
                    : nil,
                isFood && isMiQuang && includesEggNoodles
                    ? "\(item.itemID): Mì Quảng item includes egg noodles"
                    : nil,
                isFood && isMiQuang && !includesTurmericRiceNoodles
                    ? "\(item.itemID): Mì Quảng item is missing turmeric rice noodles"
                    : nil,
                isDrink && !isAlcoholDrink && visibleText.localizedCaseInsensitiveContains("beer")
                    ? "\(item.itemID): non-alcoholic drink copy mentions beer"
                    : nil,
                isDrink && !isAlcoholDrink && visibleText.localizedCaseInsensitiveContains("alcohol")
                    ? "\(item.itemID): non-alcoholic drink copy mentions alcohol"
                    : nil,
                isDrink && !isAlcoholDrink && visibleText.localizedCaseInsensitiveContains("rice-wine")
                    ? "\(item.itemID): non-alcoholic drink copy mentions rice wine"
                    : nil,
                item.category == "Vegetarian" ? lowerIncludes.first(where: { include in
                    vegetarianMeatTerms.contains { include.contains($0) }
                }).map {
                    "\(item.itemID): vegetarian includes non-vegetarian chip '\($0)'"
                } : nil,
                item.category == "Vegetarian" && item.travelerCaution?.localizedCaseInsensitiveContains("pork") == true
                    ? "\(item.itemID): vegetarian item has a pork caution"
                    : nil,
                quickSayUnitMarkers.first(where: { spec in
                    lowerQuickSayVietnamese.contains(spec.marker) && !lowerQuickSayEnglish.contains("one \(spec.unit) of")
                }).map { spec in
                    "\(item.itemID): quick say unit '\(spec.marker)' is not translated as one \(spec.unit)"
                },
            ]

            return guideFailures + guardrailFailures.compactMap { $0 }
        }
    }

    private static func menuHelperPhrases(for item: VietnameseMenuItem, kind: VietnameseMenuKind) -> [PhraseOption] {
        switch kind {
        case .food:
            if item.category == "Desserts & sweets" {
                return [
                    helperPhrase(.lessSugar, tintName: kind.tintName),
                    helperPhrase(.noIce, tintName: kind.tintName),
                    helperPhrase(.payNow, tintName: kind.tintName),
                ]
            }

            return [
                helperPhrase(.notSpicy, tintName: kind.tintName),
                helperPhrase(.lessSpicy, tintName: kind.tintName),
                helperPhrase(.seeMenu, tintName: kind.tintName),
                helperPhrase(.payNow, tintName: kind.tintName),
            ]

        case .drink:
            if item.category == "Coffee" {
                return [
                    helperPhrase(.lessSugar, tintName: kind.tintName),
                    helperPhrase(.lessIce, tintName: kind.tintName),
                    helperPhrase(.noIce, tintName: kind.tintName),
                    helperPhrase(.payNow, tintName: kind.tintName),
                ]
            }

            if ["Tea", "Smoothies", "Juices & fresh drinks"].contains(item.category) {
                return [
                    helperPhrase(.lessSugar, tintName: kind.tintName),
                    helperPhrase(.noIce, tintName: kind.tintName),
                    helperPhrase(.payNow, tintName: kind.tintName),
                ]
            }

            return [
                helperPhrase(.noIce, tintName: kind.tintName),
                helperPhrase(.lessIce, tintName: kind.tintName),
                helperPhrase(.payNow, tintName: kind.tintName),
            ]
        }
    }

    private static func helperPhrase(_ phrase: VietnameseMenuHelperPhrase, tintName: AccentTint) -> PhraseOption {
        PhraseOption(
            id: phrase.id,
            vietnamese: phrase.vietnamese,
            english: phrase.english,
            pronunciation: phrase.pronunciation,
            symbolName: "text.bubble.fill",
            tintName: tintName,
            detailPageID: phrase.detailPageID,
            audioKey: phrase.audioKey
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

private enum VietnameseMenuHelperPhrase {
    case lessSugar
    case lessIce
    case noIce
    case notSpicy
    case lessSpicy
    case seeMenu
    case payNow

    var id: String {
        switch self {
        case .lessSugar:
            return "menu-helper-less-sugar"
        case .lessIce:
            return "menu-helper-less-ice"
        case .noIce:
            return "menu-helper-no-ice"
        case .notSpicy:
            return "menu-helper-not-spicy"
        case .lessSpicy:
            return "menu-helper-less-spicy"
        case .seeMenu:
            return "menu-helper-see-menu"
        case .payNow:
            return "menu-helper-pay-now"
        }
    }

    var vietnamese: String {
        switch self {
        case .lessSugar:
            return "Ít đường thôi"
        case .lessIce:
            return "Ít đá thôi"
        case .noIce:
            return "Không đá"
        case .notSpicy:
            return "Không cay nhé"
        case .lessSpicy:
            return "Ít cay thôi"
        case .seeMenu:
            return "Cho tôi xem thực đơn được không?"
        case .payNow:
            return "Tính tiền giúp tôi"
        }
    }

    var english: String {
        switch self {
        case .lessSugar:
            return "Just a little sugar."
        case .lessIce:
            return "Just a little ice."
        case .noIce:
            return "No ice."
        case .notSpicy:
            return "Not spicy, please."
        case .lessSpicy:
            return "Less spicy, please."
        case .seeMenu:
            return "Can I see the menu?"
        case .payNow:
            return "Please let me pay."
        }
    }

    var pronunciation: String {
        switch self {
        case .lessSugar:
            return "eet duong thoy"
        case .lessIce:
            return "eet dah toy"
        case .noIce:
            return "khong da"
        case .notSpicy:
            return "khong kai nhe"
        case .lessSpicy:
            return "eet kai thoy"
        case .seeMenu:
            return "cho toy sem thook dun dook khong"
        case .payNow:
            return "ting tyen zoop toy"
        }
    }

    var detailPageID: String {
        switch self {
        case .lessSugar:
            return "viet-family-vpe-food-less-it-duong-thoi"
        case .lessIce:
            return "viet-family-food-less-ice"
        case .noIce:
            return "viet-family-vpe-food-without-khong-da"
        case .notSpicy, .lessSpicy:
            return "viet-family-food-not-spicy"
        case .seeMenu:
            return "viet-family-food-menu"
        case .payNow:
            return "viet-family-food-pay-now"
        }
    }

    var audioKey: String? {
        switch self {
        case .lessIce:
            return "coffee-4"
        case .notSpicy:
            return "food-3"
        case .lessSpicy:
            return "audio-authored-it-cay-thoi-05b8e258a2"
        case .seeMenu:
            return "food-menu"
        case .payNow:
            return "coffee-7"
        case .lessSugar, .noIce:
            return nil
        }
    }
}

private extension Optional where Wrapped == String {
    var nonEmptyValue: String? {
        guard let value = self?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
            return nil
        }

        return value
    }
}
