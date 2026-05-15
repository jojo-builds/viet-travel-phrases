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
    let howLocalsOrder: String?
    let worthKnowing: String?
    let regionalAssociation: String?
    let originPosture: String?
    let travelerCaution: String?
    let goodToKnow: String
    let commonOptions: [String]
    let quickSayVietnamese: String
    let quickSayEnglish: String
    let quickSaySoundOut: String
    let orderLine: VietnameseMenuOrderLine?
    let helperPhraseIDs: [String]?
    let editorialReview: VietnameseMenuEditorialReview?

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

    var guideHowLocalsOrder: String {
        howLocalsOrder.nonEmptyValue ?? ""
    }

    var guideWorthKnowing: String {
        worthKnowing.nonEmptyValue ?? regionalAssociation.nonEmptyValue.map { "\(vietnameseItem) is associated with \($0), but preparations can still vary by shop and region." } ?? ""
    }

    var guideOrderLine: VietnameseMenuOrderLine {
        orderLine ?? VietnameseMenuOrderLine(
            vietnamese: quickSayVietnamese,
            english: quickSayEnglish,
            pronunciation: quickSaySoundOut,
            audioPolicy: "text-only"
        )
    }

    var guideOrderLineBody: String {
        let line = guideOrderLine
        return "\(line.vietnamese)\n\(line.english)\n\(line.pronunciation)"
    }
}

struct VietnameseMenuOrderLine: Decodable, Equatable {
    let vietnamese: String
    let english: String
    let pronunciation: String
    let audioPolicy: String
}

struct VietnameseMenuEditorialReview: Decodable, Equatable {
    let status: String
    let reviewedBy: String?
    let reviewedAt: String?
    let checks: [String]?
    let reviewNote: String?
}

struct VietnameseMenuHelperPhraseDefinition: Identifiable, Decodable, Equatable {
    let id: String
    let vietnamese: String
    let english: String
    let pronunciation: String
    let audioKey: String?
    let detailPageID: String?
    let audioStatus: String
    let appliesTo: [String]

    var isReady: Bool {
        audioStatus == "ready"
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
    let helperPhrases: [VietnameseMenuHelperPhraseDefinition]?
    let items: [VietnameseMenuItem]
}

enum VietnameseMenuCatalog {
    private static let payload: VietnameseMenuPayload = loadPayload()
    static let allItems: [VietnameseMenuItem] = payload.items
    static let helperPhrases: [VietnameseMenuHelperPhraseDefinition] = payload.helperPhrases ?? []
    private static let helperPhrasesByID = Dictionary(uniqueKeysWithValues: helperPhrases.map { ($0.id, $0) })

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
                id: "how-locals-order",
                title: "How locals order",
                body: item.guideHowLocalsOrder,
                presentation: .plainText
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
                id: "order-line",
                title: "Order line",
                body: item.guideOrderLineBody,
                presentation: .plainText
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
            "the likely ingredients are",
            "how sweet or icy",
            "hot version",
            "herbs, broth, grill, or dip",
            "depending on the shop, the balance may lean",
            "useful window",
            "whole eating style",
            "cultural value",
            "the thing to notice is",
            "A plate or bowl of",
            "which make the dish easier to spot",
            "details tell you whether",
            "so the pleasure is in how those pieces meet",
            "The cue is",
            "as the detail to watch for",
            "best ordered by cooking style and protein",
            "a sharp a small",
            "chiliping",
            "For a cautious order",
            "hot bowls",
            "grilled plates",
            "rolls before",
            "rice, noodles, greens, or wrapper",
            "hands-on Vietnamese snack eating",
            "herbs, wrappers, crunch",
            "vegetarian soy-lime vegetarian",
            "an useful",
            "the a small dipping bowl",
            "made with winter melon soup",
            "one sandwich of",
            "bBQ",
            "Maggi-style soy seasoning, chili or pâté spread",
            "soy-based muối tiêu",
            "For fish, ask about bones",
            "Pointing at",
            "typically made with",
            "Travelers can read",
            "ordering cue",
            "works in Vietnam",
            "American menus",
            "Americans",
            "For Americans",
            "thick soup base",
            "vegetarian sauce",
            "mushrooms or tofu",
            "a small dipping bowl",
            "generic fish in sauce",
            "generic chicken-and-rice plate",
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
            "A plate or bowl of",
            "which make the dish easier to spot",
            "details tell you whether",
            "so the pleasure is in how those pieces meet",
            "The cue is",
            "as the detail to watch for",
            "best ordered by cooking style and protein",
            "a sharp a small",
            "chiliping",
            "For a cautious order",
            "hot bowls",
            "grilled plates",
            "rolls before",
            "rice, noodles, greens, or wrapper",
            "hands-on Vietnamese snack eating",
            "herbs, wrappers, crunch",
            "vegetarian soy-lime vegetarian",
            "an useful",
            "the a small dipping bowl",
            "made with winter melon soup",
            "one sandwich of",
            "bBQ",
            "Maggi-style soy seasoning, chili or pâté spread",
            "soy-based muối tiêu",
            "For fish, ask about bones",
            "Pointing at",
            "typically made with",
            "Travelers can read",
            "ordering cue",
            "works in Vietnam",
            "American menus",
            "Americans",
            "For Americans",
            "thick soup base",
            "vegetarian sauce",
            "mushrooms or tofu",
            "a small dipping bowl",
            "generic fish in sauce",
            "generic chicken-and-rice plate",
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
        let vagueSauceFragments = [
            "extra sauce",
            "dipping sauce",
            "house sauce",
            "rich sauce",
            "seasoning sauce",
            "stir-fry sauce",
            "braising sauce",
            "sweet-and-sour sauce",
            "with sauce",
            "and sauce",
            "the sauce",
            "sauce is served separately",
        ]
        let drinkSensoryMarkers = [
            "alcoholic",
            "bitter",
            "body",
            "bubbles",
            "buttery",
            "caffeine",
            "caramel",
            "clean",
            "cold",
            "condensed",
            "cooling",
            "cream",
            "creamy",
            "crisp",
            "earthy",
            "fizzy",
            "floral",
            "fragrant",
            "grassy",
            "herbal",
            "ice",
            "icy",
            "juicy",
            "lager",
            "light",
            "malt",
            "mellow",
            "milk",
            "mineral",
            "neutral",
            "nutty",
            "plain",
            "pulpy",
            "refreshing",
            "roasted",
            "salty",
            "sharp",
            "silky",
            "slippery",
            "smooth",
            "soft",
            "sour",
            "sparkling",
            "strong",
            "sweet",
            "sweetness",
            "syrupy",
            "tangy",
            "tannic",
            "tart",
            "thick",
            "tropical",
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
        let localContextMarkers = [
            "Vietnam",
            "Vietnamese",
            "Hanoi",
            "Hà Nội",
            "Huế",
            "Hội An",
            "Saigon",
            "Sài Gòn",
            "Chợ Lớn",
            "Mekong",
            "Mỹ Tho",
            "Đà Lạt",
            "Nha Trang",
            "Vũng Tàu",
            "Phú Yên",
            "Quảng Nam",
            "Cầu Mống",
            "Sóc Trăng",
            "Tết",
            "northern Vietnam",
            "southern Vietnam",
            "central Vietnam",
            "central coast",
            "Mekong Delta",
            "northern",
            "southern",
            "central",
            "coastal",
            "highland",
            "street",
            "stall",
            "shop",
            "rice-shop",
            "noodle-shop",
            "snack",
            "family",
            "home",
            "homestyle",
            "home-style",
            "breakfast",
            "market",
            "table",
            "party",
            "wedding",
            "gift",
            "Buddhist",
            "Chinese-Vietnamese",
            "French-influenced",
            "chay",
            "rice paper",
            "mắm",
            "nước mắm",
            "means",
            "word",
            "signals",
            "points to",
        ]
        let ricePaperGuidanceRequirements: [String: [String]] = [
            "food-banh-xeo": ["rice paper", "herbs", "nước chấm"],
            "food-banh-xeo-chay": ["rice paper", "herbs", "vegetarian"],
            "food-banh-khot": ["rice paper", "herbs", "nước chấm"],
            "food-goi-cuon-chay": ["rice paper", "herbs"],
            "food-nem-nuong": ["rice paper", "herbs"],
            "food-thit-luoc-cuon-banh-trang": ["rice paper", "roll", "herbs"],
            "food-be-thui-cuon-banh-trang": ["rice paper", "roll", "herbs"],
            "food-bo-nhung-dam": ["rice paper", "roll", "herbs"],
            "food-ca-loc-nuong-trui": ["rice paper", "bones", "herbs"],
            "food-chao-tom": ["rice paper", "sugarcane", "herbs"],
            "food-banh-hoi-thit-nuong": ["rice paper", "herbs"],
            "food-banh-hoi-heo-quay": ["rice paper", "herbs"],
            "food-heo-quay-banh-hoi": ["rice paper", "herbs"],
        ]
        let originConnectionRequirements: [String: [String]] = [
            "drink-ca-phe-trung": ["Hanoi", "1946", "milk"],
            "food-com-tam-suon": ["broken rice", "southern"],
            "food-com-tam-bi-cha-suon": ["broken rice", "southern"],
            "food-com-tam-suon-bi-cha-trung": ["broken-rice", "southern"],
            "food-banh-mi-pate": ["French", "Vietnam", "street"],
            "food-banh-mi-thit": ["French", "Vietnam", "street"],
            "food-banh-mi-dac-biet": ["French", "Vietnam", "street"],
            "food-banh-mi-cha-lua": ["French", "Vietnam"],
            "food-banh-mi-ga": ["French", "Vietnam", "street"],
            "food-banh-mi-heo-quay": ["French", "Vietnam"],
            "food-banh-mi-op-la": ["French", "Vietnam"],
            "food-banh-mi-thit-nuong": ["French", "Vietnam"],
            "food-banh-mi-xiu-mai": ["French", "Vietnam"],
            "food-banh-mi-chay": ["French", "Vietnam"],
        ]
        let itemSpecificBlockedFragments: [String: [String]] = [
            "food-hu-tieu-my-tho": ["fish-sauce caramel braise"],
            "food-cao-lau": ["nước chấm"],
            "food-hu-tieu-kho": ["fish-sauce caramel braise"],
            "food-com-tam-suon": ["muối tiêu chanh"],
            "food-com-bo-luc-lac": ["nước chấm"],
            "food-com-chien-hai-san": ["muối tiêu chanh", "ginger fish sauce"],
            "food-com-chien-ga": ["muối tiêu chanh"],
            "food-com-chien-bo": ["nước chấm"],
            "food-com-chien-trung": ["nước chấm"],
            "food-xoi-bap": ["nước chấm"],
            "food-banh-beo": ["rolls"],
            "food-khoai-lang-chien": ["fish-sauce caramel braise"],
            "food-khoai-tay-chien": ["fish-sauce caramel braise"],
            "food-cha-ca-la-vong": ["lime-pepper/ginger fish sauce"],
            "food-tom-chien-xu": ["fish-sauce caramel braise"],
            "food-muc-xao-chua-ngot": ["garlic-fish-sauce glaze"],
            "food-ngheu-xao-bo-toi": ["garlic-fish-sauce glaze", "generated correction"],
            "food-thit-kho-tau": ["creamy coconut sauce"],
            "food-gio-heo-ham": ["fish-sauce caramel braise", "caramel sauce"],
            "food-ga-hap-hanh": ["tamarind sauce"],
            "food-ga-nuong-la-chanh": ["tamarind sauce"],
            "food-bo-luc-lac": ["tamarind sauce"],
            "food-bo-ne": ["nước chấm"],
            "food-bo-kho-banh-mi": ["fish-sauce caramel braise"],
            "food-de-hap-tia-to": ["tamarind sauce"],
            "food-ca-ri-de": ["lime-pepper", "ginger fish sauce"],
            "food-de-xao-lan": ["garlic-fish-sauce glaze"],
            "food-vit-om-sau": ["muối tiêu chanh"],
            "food-bo-xao-luc-lac": ["garlic-fish-sauce stir-fry glaze"],
            "food-bo-xao-rau-cai": ["garlic-fish-sauce stir-fry glaze"],
            "food-bo-xao-sa-ot": ["garlic-fish-sauce stir-fry glaze"],
            "food-bun-bo-hue-chay": ["vegetarian sauce"],
            "food-hu-tieu-chay": ["vegetarian sauce"],
            "food-pho-chay": ["vegetarian sauce"],
        ]
        let helperContextMarkers: [String: [String]] = [
            "menu-ask-peanuts": ["peanut"],
            "menu-peanut-allergy": ["peanut"],
            "menu-sauce-on-side": ["sauce", "dip", "dressing", "glaze", "gravy", "nước", "mắm", "soy", "tương", "broth"],
            "menu-less-sugar": ["sweet", "sugar", "syrup", "condensed", "caramel", "dessert", "cake", "chè", "milk", "coconut", "chocolate", "honey"],
            "menu-no-sugar": ["sweet", "sugar", "syrup", "condensed", "caramel", "dessert", "cake", "chè", "milk", "coconut", "chocolate", "honey"],
            "menu-less-ice": ["ice", "iced", "cold", "chilled", "bottle", "can", "glass", "sparkling", "water", "smoothie", "juice", "tea", "coffee"],
            "menu-no-ice": ["ice", "iced", "cold", "chilled", "bottle", "can", "glass", "sparkling", "water", "smoothie", "juice", "tea", "coffee"],
        ]

        return allItems.flatMap { item in
            let guideFailures = [
                ("whatItIs", item.whatItIs),
                ("howToEnjoy", item.howToEnjoy),
                ("howLocalsOrder", item.howLocalsOrder),
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

                if fieldName == "worthKnowing",
                   !localContextMarkers.contains(where: { value.localizedCaseInsensitiveContains($0) }) {
                    return "\(item.itemID): worthKnowing missing Vietnam-specific context"
                }

                return nil
            }

            let visibleText = ([item.atAGlance, item.goodToKnow, item.guideWhatItIs, item.guideHowToEnjoy, item.guideHowLocalsOrder, item.guideWorthKnowing, item.travelerCaution ?? ""] + item.usuallyIncludes + item.commonOptions)
                .joined(separator: "\n")
            let localOrderText = item.guideHowLocalsOrder
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
            let ricePaperGuidanceText = [
                item.guideWhatItIs,
                item.guideHowToEnjoy,
                item.guideHowLocalsOrder,
                item.usuallyIncludes.joined(separator: " "),
                item.commonOptions.joined(separator: " "),
            ].joined(separator: "\n")
            let ricePaperGuidanceFailures = (ricePaperGuidanceRequirements[item.itemID] ?? []).compactMap { term in
                ricePaperGuidanceText.localizedCaseInsensitiveContains(term)
                    ? nil
                    : "\(item.itemID): rice-paper/local eating guidance is missing '\(term)'"
            }
            let originConnectionText = [
                item.atAGlance,
                item.guideWhatItIs,
                item.guideHowToEnjoy,
                item.guideHowLocalsOrder,
                item.guideWorthKnowing,
                item.goodToKnow,
                item.regionalAssociation ?? "",
                item.originPosture ?? "",
            ].joined(separator: "\n")
            let originConnectionFailures = (originConnectionRequirements[item.itemID] ?? []).compactMap { term in
                originConnectionText.localizedCaseInsensitiveContains(term)
                    ? nil
                    : "\(item.itemID): origin/Vietnam story guidance is missing '\(term)'"
            }
            let itemSpecificBlockedFailures = (itemSpecificBlockedFragments[item.itemID] ?? []).compactMap { fragment in
                visibleText.localizedCaseInsensitiveContains(fragment)
                    ? "\(item.itemID): item-specific semantic guard blocks '\(fragment)'"
                    : nil
            }
            let helperContextFailures = (item.helperPhraseIDs ?? []).compactMap { helperID -> String? in
                guard let markers = helperContextMarkers[helperID], !markers.isEmpty else {
                    return nil
                }
                return markers.contains(where: { visibleText.localizedCaseInsensitiveContains($0) })
                    ? nil
                    : "\(item.itemID): helper \(helperID) lacks visible copy context"
            }

            let guardrailFailures: [String?] = [
                isDrink && item.atAGlance.localizedCaseInsensitiveContains("\(item.vietnameseItem) is ") && item.atAGlance.contains(":")
                    ? "\(item.itemID): drink atAGlance still uses item-is-translation template wording"
                    : nil,
                item.menuType == VietnameseMenuKind.drink.rawValue && item.travelerCaution?.localizedCaseInsensitiveContains("spicy") == true
                    ? "\(item.itemID): drink item has a spicy caution"
                    : nil,
                visibleBlockFragments.first(where: { visibleText.localizedCaseInsensitiveContains($0) }).map {
                    "\(item.itemID): visible menu copy contains blocked fragment '\($0)'"
                },
                localOrderText.split(separator: " ").count < 18
                    ? "\(item.itemID): howLocalsOrder needs a specific local ordering note"
                    : nil,
                item.category == "Coffee" ? coffeeGenericFragments.first(where: { visibleText.localizedCaseInsensitiveContains($0) }).map {
                    "\(item.itemID): visible coffee copy contains generic fragment '\($0)'"
                } : nil,
                isFood ? foodVisibleBlockFragments.first(where: { visibleText.localizedCaseInsensitiveContains($0) }).map {
                    "\(item.itemID): visible food copy contains blocked fragment '\($0)'"
                } : nil,
                vagueSauceFragments.first(where: { visibleText.localizedCaseInsensitiveContains($0) }).map {
                    "\(item.itemID): sauce copy must name or explain the sauce instead of '\($0)'"
                },
                isDrink && !drinkSensoryMarkers.contains(where: { visibleText.localizedCaseInsensitiveContains($0) })
                    ? "\(item.itemID): drink copy needs flavor, body, texture, or experience descriptors"
                    : nil,
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
                    lowerQuickSayVietnamese.contains(spec.marker)
                        && !lowerQuickSayEnglish.contains("one \(spec.unit) of")
                        && !(spec.marker == "một ổ" && lowerQuickSayEnglish.contains("one ") && lowerQuickSayEnglish.contains("bánh mì"))
                }).map { spec in
                    "\(item.itemID): quick say unit '\(spec.marker)' is not translated as one \(spec.unit)"
                },
            ]

            var failures = guideFailures
            failures.append(contentsOf: guardrailFailures.compactMap { $0 })
            failures.append(contentsOf: ricePaperGuidanceFailures)
            failures.append(contentsOf: originConnectionFailures)
            failures.append(contentsOf: itemSpecificBlockedFailures)
            failures.append(contentsOf: helperContextFailures)
            return failures
        }
    }

    private static func menuHelperPhrases(for item: VietnameseMenuItem, kind: VietnameseMenuKind) -> [PhraseOption] {
        (item.helperPhraseIDs ?? []).compactMap { helperID in
            guard let helper = helperPhrasesByID[helperID], helper.isReady else {
                return nil
            }

            let phrase = PhraseOption(
                id: helper.id,
                vietnamese: helper.vietnamese,
                english: helper.english,
                pronunciation: helper.pronunciation,
                symbolName: "text.bubble.fill",
                tintName: kind.tintName,
                detailPageID: helper.detailPageID,
                audioKey: helper.audioKey
            )

            return phrase.playbackAudioKey == nil ? nil : phrase
        }
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

    private static func loadPayload() -> VietnameseMenuPayload {
        guard
            let url = Bundle.main.url(forResource: "vietnamese-menu-copy", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let payload = try? JSONDecoder().decode(VietnameseMenuPayload.self, from: data)
        else {
            return VietnameseMenuPayload(helperPhrases: [], items: [])
        }

        return payload
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
