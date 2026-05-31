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
            return "Food Menu"
        case .drink:
            return "Drink Menu"
        }
    }

    var subtitle: String {
        switch self {
        case .food:
            return "Browse khai vị, noodle bowls, rice plates, shared hot pots, chay dishes, and sweets. Tap a dish to hear it and recognize what to order."
        case .drink:
            return "Browse coffee, tea, smoothies, juice, and cold drinks. Tap a drink to hear it and order with confidence."
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

    var photoBackdropImageName: String? {
        switch self {
        case .food:
            return "BackdropVietnameseFoodMenu"
        case .drink:
            return "BackdropVietnameseDrinkMenu"
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

struct VietnameseMenuItem: Identifiable, Decodable {
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
    var menuBackdropImageName: String { VietnameseMenuImages.backdropAssetName(forItemID: itemID) }

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

struct VietnameseMenuCategory: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let symbolName: String
    let tintName: AccentTint
    let featuredImageName: String
    let items: [VietnameseMenuItem]

    var itemCount: Int { items.count }
}

struct VietnameseMenuSection: Identifiable {
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
        "HeroMenu" + pascalCaseIdentifier(forItemID: itemID)
    }

    static func backdropAssetName(forItemID itemID: String) -> String {
        "BackdropMenu" + pascalCaseIdentifier(forItemID: itemID)
    }

    private static func pascalCaseIdentifier(forItemID itemID: String) -> String {
        itemID
            .split(separator: "-")
            .map { component in
                component.prefix(1).uppercased() + component.dropFirst()
            }
            .joined()
    }
}

struct VietnameseMenuPayload: Decodable {
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
        let rowsByCategory = Dictionary(grouping: items(for: kind)) { item in
            presentationCategoryTitle(for: item, kind: kind)
        }
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
                id: "useful-phrases",
                title: "Useful phrases",
                body: "",
                phrases: helperPhrases,
                presentation: .phraseList
            ),
            PhraseDetailSection(
                id: "how-locals-order",
                title: "How locals order",
                body: item.guideHowLocalsOrder,
                inlineDefinitions: menuInlineDefinitions(for: item),
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
        let unglossedOrderingFragments = [
            "ask it cay",
            "it cay",
            "không cay",
            "không ớt",
            "ít đá",
            "không đá",
            "ít đường",
            "không đường",
            "ít ngọt",
            "ít muối",
            "ít sữa",
            "không sữa",
            "không pate",
            "không pâté",
            "không đậu phộng",
            "không nước mắm",
            "nước mắm riêng",
            "nước chấm",
            "nước-chấm",
            "nuoc cham",
            "ít dầu",
            "thêm rau",
            "thêm cơm",
            "thêm trứng",
            "thêm chanh",
            "khuấy đều",
            "nước dùng chay",
            "có xương không",
            "còn vỏ không",
            "có thịt không",
            "chay được không",
            "có nước mắm không",
            "không rượu",
            "nhẹ tiêu",
            "milk đặc",
            "thêm cà phê",
            "ask hot, đá",
            "cà phê đen hot",
            "cà phê sữa hot",
            "trà hot",
        ]
        let mechanicalCaseFragments = [
            "; Ask",
            ". ask for",
            "then Ask",
            "and Ask",
            "so Ask",
            "no ice for no ice",
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
            "food-banh-xeo": ["rice paper", "herbs", "fish-sauce dip"],
            "food-banh-xeo-chay": ["rice paper", "herbs", "vegetarian"],
            "food-banh-khot": ["rice paper", "herbs", "fish-sauce dip"],
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
            "food-cao-lau": ["fish-sauce dip"],
            "food-hu-tieu-kho": ["fish-sauce caramel braise"],
            "food-com-tam-suon": ["muối tiêu chanh"],
            "food-com-bo-luc-lac": ["fish-sauce dip"],
            "food-com-chien-hai-san": ["muối tiêu chanh", "ginger fish sauce"],
            "food-com-chien-ga": ["muối tiêu chanh"],
            "food-com-chien-bo": ["fish-sauce dip"],
            "food-com-chien-trung": ["fish-sauce dip"],
            "food-xoi-bap": ["fish-sauce dip"],
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
            "food-bo-ne": ["fish-sauce dip"],
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
                unglossedOrderingFragments.first(where: { visibleText.localizedCaseInsensitiveContains($0) }).map {
                    "\(item.itemID): visible copy contains unglossed ordering phrase '\($0)'"
                },
                visibleText.localizedCaseInsensitiveContains("ít cay")
                    && !Self.hasLessSpicyGlossBeforeItCay(in: visibleText)
                    ? "\(item.itemID): visible copy uses 'ít cay' without giving 'less spicy' before it"
                    : nil,
                mechanicalCaseFragments.first(where: { visibleText.contains($0) }).map {
                    "\(item.itemID): visible copy contains mechanical case fragment '\($0)'"
                },
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

    private static func menuInlineDefinitions(for item: VietnameseMenuItem) -> [PhraseInlineDefinition] {
        if item.itemID == "food-bun-bo-hue", item.guideHowLocalsOrder.localizedCaseInsensitiveContains("ít cay") {
            return [
                PhraseInlineDefinition(
                    id: "menu-inline-it-cay",
                    vietnamese: "ít cay",
                    english: "less spicy"
                ),
            ]
        }

        return []
    }

    private static func hasLessSpicyGlossBeforeItCay(in text: String) -> Bool {
        let lower = text.lowercased()
        guard let phraseRange = lower.range(of: "ít cay") else {
            return true
        }

        let prefix = lower[..<phraseRange.lowerBound].suffix(80)
        return prefix.contains("less spicy")
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
        item.kind == nil ? kind.heroImageName : item.menuBackdropImageName
    }

    private static func categoryOrder(for kind: VietnameseMenuKind) -> [String] {
        switch kind {
        case .food:
            return [
                "Starters & snacks",
                "Noodles & bowls",
                "Rice plates & clay pots",
                "Bánh mì & buns",
                "Seafood",
                "Grilled & braised meats",
                "Soups & hot pots",
                "Vegetarian & chay",
                "Sweets",
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
        case "Khai vị & snacks", "Starters & snacks":
            return "cuốn, gỏi, bites"
        case "Noodle soups", "Noodles & bowls":
            return "phở, bún, cháo"
        case "Vermicelli bowls", "Dry noodles & vermicelli":
            return "bún, mì khô"
        case "Rice & clay pot", "Rice & sticky rice", "Rice plates & clay pots":
            return "cơm, xôi, niêu"
        case "Bánh mì & buns", "Bánh mì, bread & buns":
            return "bánh mì, bao"
        case "Grilled & braised meats":
            return "pork, chicken, beef"
        case "Pork":
            return "grilled, braised"
        case "Chicken & duck":
            return "grilled, roasted"
        case "Beef & goat":
            return "bò, bê, dê"
        case "Seafood":
            return "fish, shrimp, crab"
        case "Canh & lẩu", "Soups, hot pots & family-style", "Soups & hot pots":
            return "soups, shared pots"
        case "Tofu & chay", "Vegetarian", "Vegetarian & chay":
            return "tofu, greens"
        case "Desserts", "Desserts & sweets", "Sweets":
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
        case "Khai vị & snacks", "Starters & snacks":
            return "menucard.fill"
        case "Noodle soups", "Noodles & bowls":
            return "takeoutbag.and.cup.and.straw.fill"
        case "Vermicelli bowls":
            return "fork.knife"
        case "Rice & clay pot", "Rice & sticky rice", "Rice plates & clay pots":
            return "fork.knife"
        case "Grilled & braised meats":
            return "flame.fill"
        case "Pork":
            return "fork.knife"
        case "Chicken & duck":
            return "bird.fill"
        case "Seafood":
            return "fish.fill"
        case "Canh & lẩu", "Soups & hot pots":
            return "flame.fill"
        case "Tofu & chay", "Vegetarian", "Vegetarian & chay":
            return "leaf.fill"
        case "Desserts", "Sweets":
            return "sparkles"
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
        case "Noodle soups", "Noodles & bowls", "Tea", "Tofu & chay", "Vegetarian", "Vegetarian & chay":
            return .green
        case "Seafood", "Canh & lẩu", "Soups & hot pots", "Water, soda & other drinks":
            return .blue
        case "Khai vị & snacks", "Starters & snacks", "Smoothies":
            return .orange
        case "Desserts", "Sweets", "Juices & fresh drinks":
            return .red
        default:
            return kind.tintName
        }
    }

    private static func featuredImageName(for title: String, items: [VietnameseMenuItem]) -> String {
        let preferredItemID: String?
        switch title {
        case "Khai vị & snacks", "Starters & snacks":
            preferredItemID = "food-goi-cuon"
        case "Noodle soups", "Noodles & bowls":
            preferredItemID = "food-pho-bo"
        case "Vermicelli bowls":
            preferredItemID = "food-bun-cha"
        case "Rice & clay pot", "Rice plates & clay pots":
            preferredItemID = "food-com-tam-suon"
        case "Bánh mì & buns":
            preferredItemID = "food-banh-mi-dac-biet"
        case "Seafood":
            preferredItemID = "food-tom-rang-muoi"
        case "Grilled & braised meats":
            preferredItemID = "food-suon-nuong"
        case "Pork":
            preferredItemID = "food-suon-nuong"
        case "Chicken & duck":
            preferredItemID = "food-ga-nuong-muoi-ot"
        case "Beef & goat":
            preferredItemID = "food-bo-luc-lac"
        case "Canh & lẩu", "Soups & hot pots":
            preferredItemID = "food-lau-thai"
        case "Tofu & chay", "Vegetarian", "Vegetarian & chay":
            preferredItemID = "food-dau-hu-chien-gion"
        case "Desserts", "Sweets":
            preferredItemID = "food-che-ba-mau"
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

    private static func presentationCategoryTitle(for item: VietnameseMenuItem, kind: VietnameseMenuKind) -> String {
        guard kind == .food else {
            return item.category
        }

        switch item.itemID {
        case
            "food-bun-mang-vit",
            "food-chao-suon",
            "food-chao-vit":
            return "Noodles & bowls"
        case
            "food-lau-de",
            "food-bo-nhung-dam":
            return "Soups & hot pots"
        default:
            break
        }

        switch item.category {
        case "Rolls, appetizers & street snacks":
            return "Starters & snacks"
        case "Noodle soups", "Dry noodles & vermicelli":
            return "Noodles & bowls"
        case "Rice & sticky rice":
            return "Rice plates & clay pots"
        case "Bánh mì, bread & buns":
            return "Bánh mì & buns"
        case "Pork", "Chicken & duck", "Beef & goat":
            return "Grilled & braised meats"
        case "Soups, hot pots & family-style":
            return "Soups & hot pots"
        case "Vegetarian":
            return "Vegetarian & chay"
        case "Desserts & sweets":
            return "Sweets"
        default:
            return item.category
        }
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
        if let payload = VietSQLitePhraseGraphRuntime.vietnameseMenuPayload() {
            return payload
        }

        guard let url = Bundle.main.url(forResource: "vietnamese-menu-copy", withExtension: "json") else {
            VietSQLiteRuntimeDiagnostics.reportFallback(
                surface: "VietnameseMenuCatalog",
                reason: "Missing bundled vietnamese-menu-copy.json fallback."
            )
            return VietnameseMenuPayload(helperPhrases: [], items: [])
        }

        do {
            let data = try Data(contentsOf: url)
            let payload = try JSONDecoder().decode(VietnameseMenuPayload.self, from: data)
            VietSQLiteRuntimeDiagnostics.reportFallback(
                surface: "VietnameseMenuCatalog",
                reason: "Loaded bundled JSON fallback."
            )
            return payload
        } catch {
            VietSQLiteRuntimeDiagnostics.reportFallback(surface: "VietnameseMenuCatalog", error: error)
            return VietnameseMenuPayload(helperPhrases: [], items: [])
        }
    }
}

struct LocationMenuPick: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let proof: String
    let imageName: String
    let detailPageID: String
    let audioText: String?
    let linkedMenuItemID: String?
    let afterSectionID: String?

    init(
        id: String,
        title: String,
        subtitle: String,
        proof: String,
        imageName: String,
        detailPageID: String,
        audioText: String? = nil,
        linkedMenuItemID: String?,
        afterSectionID: String?
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.proof = proof
        self.imageName = imageName
        self.detailPageID = detailPageID
        self.audioText = audioText
        self.linkedMenuItemID = linkedMenuItemID
        self.afterSectionID = afterSectionID
    }

    var linkedMenuItem: VietnameseMenuItem? {
        guard let linkedMenuItemID else {
            return nil
        }

        return VietnameseMenuCatalog.allItems.first { $0.itemID == linkedMenuItemID }
    }

    var audioKey: String? {
        if let audioText {
            return AudioAssetManifest.main?.audioKey(forExactText: audioText)
        }

        guard let linkedMenuItem else {
            return nil
        }

        return AudioAssetManifest.main?.audioKey(forExactText: linkedMenuItem.vietnameseItem)
    }
}

private func mergedLocationPicks(staticPicks: [LocationMenuPick], runtimePicks: [LocationMenuPick]) -> [LocationMenuPick] {
    var seenDetailPageIDs = Set<String>()
    return (staticPicks + runtimePicks).filter { pick in
        let canonicalID = VietSQLitePhraseGraphRuntime.canonicalPageID(for: pick.detailPageID) ?? pick.detailPageID
        return seenDetailPageIDs.insert(canonicalID).inserted
    }
}

enum LocationMenuPicksCatalog {
    static func picks(forPageID pageID: String) -> [LocationMenuPick] {
        if pageID.hasPrefix("viet-phrase-city-") {
            let familyPageID = "viet-family-city-" + String(pageID.dropFirst("viet-phrase-city-".count))
            return picks(forPageID: familyPageID)
        }

        let staticPicks: [LocationMenuPick]
        switch pageID {
        case "viet-family-city-danang-place-bac-my-an-market":
            staticPicks = menuItemPicks(["food-kem-bo"], after: "quick-say")
        case "viet-family-city-danang-place-con-market":
            staticPicks = menuItemPicks(["food-che-ba-mau", "food-banh-beo", "food-banh-xeo", "food-mi-quang-ga"], after: "place-brief")
        case "viet-family-city-danang-place-han-market":
            staticPicks = menuItemPicks(["food-mi-quang-ga", "food-mi-quang-tom-thit", "food-banh-beo", "food-banh-xeo"], after: "place-brief")
        case "viet-family-city-danang-place-helio-night-market":
            staticPicks = menuItemPicks(["food-tom-nuong-muoi-ot", "food-lau-hai-san", "food-cha-gio", "food-che-ba-mau"], after: "use-it-with")
        case "viet-family-city-danang-place-son-tra-night-market":
            staticPicks = menuItemPicks(["food-tom-nuong-muoi-ot", "food-ngheu-hap-sa", "food-lau-hai-san", "food-cha-gio"], after: "place-brief")
        case "viet-family-city-hanoi-place-dinh-cafe":
            staticPicks = menuItemPicks(["drink-ca-phe-phin", "drink-ca-phe-den-nong", "drink-ca-phe-sua-nong"], after: "place-brief")
        case "viet-family-city-hanoi-place-giang-cafe":
            staticPicks = menuItemPicks(["drink-ca-phe-trung", "drink-ca-phe-den-nong", "drink-ca-phe-sua-nong"], after: "quick-say")
        case "viet-family-city-hanoi-place-the-note-coffee":
            staticPicks = menuItemPicks(["drink-ca-phe-sua-da", "drink-ca-phe-phin", "drink-ca-phe-trung"], after: "quick-say")
        case "viet-family-city-hoian-place-bale-well":
            staticPicks = menuItemPicks(["food-banh-xeo", "food-nem-nuong-cuon", "food-goi-cuon", "food-cha-gio-tom-thit"], after: "quick-say")
        case "viet-family-city-hoian-place-banh-mi-phuong":
            staticPicks = menuItemPicks(["food-banh-mi-dac-biet", "food-banh-mi-thit", "food-banh-mi-ga", "food-banh-mi-pate"], after: "quick-say")
        case "viet-family-city-hoian-place-madam-khanh":
            staticPicks = menuItemPicks(["food-banh-mi-thit", "food-banh-mi-ga", "food-banh-mi-pate", "food-banh-mi-dac-biet"], after: "quick-say")
        case "viet-family-city-hoian-place-morning-glory":
            staticPicks = menuItemPicks(["food-cao-lau", "food-mi-quang-ga", "food-banh-xeo", "food-banh-bot-loc"], after: "quick-say")
        case "viet-family-city-hue-place-tam-giang-lagoon":
            staticPicks = menuItemPicks(["food-tom-nuong-muoi-ot", "food-ngheu-hap-sa", "food-ngheu-xao-bo-toi"], after: "place-brief")
        case "viet-family-city-hcmc-place-lusine-thao-dien",
             "viet-phrase-city-hcmc-place-lusine-thao-dien":
            staticPicks = lusineThaoDienPicks
        case "viet-family-city-danang-place-international-terminal":
            staticPicks = danangInternationalTerminalMentionedPicks
        case "viet-family-city-danang-place-dong-dinh-museum":
            staticPicks = dongDinhMuseumMentionedPicks
        case "viet-family-city-hcmc-place-pasteur-street":
            staticPicks = pasteurStreetMentionedPicks
        case "viet-family-city-hanoi-place-loading-t-cafe":
            staticPicks = loadingTCafeMentionedPicks
        case "viet-family-city-danang-place-lotte-mart":
            staticPicks = lotteMartDanangMentionedPicks
        default:
            staticPicks = []
        }

        return mergedLocationPicks(
            staticPicks: staticPicks,
            runtimePicks: VietSQLitePhraseGraphRuntime.locationRelationPicks(
                forPageID: pageID,
                relationType: "mentioned-here"
            )
        )
    }

    static func picks(forPageID pageID: String, afterSectionID sectionID: String) -> [LocationMenuPick] {
        picks(forPageID: pageID).filter { $0.afterSectionID == sectionID }
    }

    static func trailingPicks(forPageID pageID: String) -> [LocationMenuPick] {
        picks(forPageID: pageID).filter { $0.afterSectionID == nil }
    }

    static func pick(withDetailPageID pageID: String) -> LocationMenuPick? {
        allPicks.first { $0.detailPageID == pageID }
    }

    static func detailPage(withID pageID: String) -> PhraseDetailPage? {
        guard let pick = pick(withDetailPageID: pageID), pick.linkedMenuItemID == nil else {
            return nil
        }

        return PhraseDetailPage(
            id: pick.detailPageID,
            title: pick.title,
            englishTitle: pick.subtitle,
            pronunciation: pick.title,
            summary: pick.proof,
            iconName: "fork.knife",
            tintName: .orange,
            heroImageName: detailHeroImageName(for: pick),
            sections: detailSections(for: pick),
            examples: [],
            audioKey: nil,
            practiceCTALabel: "Practice ordering here",
            showsCatalogExplore: false
        )
    }

    private static var allPicks: [LocationMenuPick] {
        lusineThaoDienPicks
    }

    private static func menuItemPicks(_ itemIDs: [String], after sectionID: String) -> [LocationMenuPick] {
        Array(itemIDs.prefix(4)).compactMap { menuItemPick(itemID: $0, after: sectionID) }
    }

    private static func menuItemPick(itemID: String, after sectionID: String) -> LocationMenuPick? {
        guard let item = VietnameseMenuCatalog.allItems.first(where: { $0.itemID == itemID }) else {
            return nil
        }

        return LocationMenuPick(
            id: "\(sectionID)-\(item.itemID)",
            title: item.vietnameseItem,
            subtitle: item.englishTranslation,
            proof: "",
            imageName: item.menuImageName,
            detailPageID: item.detailPageID,
            linkedMenuItemID: item.itemID,
            afterSectionID: sectionID
        )
    }

    private static func authoredPagePick(
        id: String,
        title: String,
        subtitle: String,
        proof: String,
        imageName: String,
        detailPageID: String,
        audioText: String? = nil,
        after sectionID: String
    ) -> LocationMenuPick {
        LocationMenuPick(
            id: id,
            title: title,
            subtitle: subtitle,
            proof: proof,
            imageName: imageName,
            detailPageID: detailPageID,
            audioText: audioText,
            linkedMenuItemID: nil,
            afterSectionID: sectionID
        )
    }

    private static let danangInternationalTerminalMentionedPicks: [LocationMenuPick] = [
        authoredPagePick(
            id: "terminal-mentioned-sim",
            title: "SIM card",
            subtitle: "Get connected before leaving the terminal.",
            proof: "Useful before pickup and hotel messages.",
            imageName: "HeroCategoryAirport",
            detailPageID: "viet-family-airport-sim",
            after: "place-brief"
        ),
        authoredPagePick(
            id: "terminal-mentioned-atm",
            title: "ATM",
            subtitle: "Find cash before the ride into the city.",
            proof: "Good to settle before stepping into the pickup flow.",
            imageName: "HeroCategoryNumbersMoney",
            detailPageID: "viet-family-money-find-atm",
            after: "place-brief"
        ),
    ]

    private static let dongDinhMuseumMentionedPicks: [LocationMenuPick] = [
        authoredPagePick(
            id: "dong-dinh-mentioned-son-tra",
            title: "Bán đảo Sơn Trà",
            subtitle: "Son Tra Peninsula",
            proof: "The wider peninsula route this stop belongs to.",
            imageName: "HeroCityDanangPlaceSonTra",
            detailPageID: "viet-family-city-danang-place-son-tra",
            audioText: "Bán đảo Sơn Trà",
            after: "good-to-know"
        ),
        authoredPagePick(
            id: "dong-dinh-mentioned-lady-buddha",
            title: "Tượng Phật Bà",
            subtitle: "Lady Buddha",
            proof: "The natural pairing before or after a quiet museum pause.",
            imageName: "HeroCityDanangPlaceLadyBuddha",
            detailPageID: "viet-family-city-danang-place-lady-buddha",
            audioText: "Tượng Phật Bà",
            after: "good-to-know"
        ),
    ]

    private static let pasteurStreetMentionedPicks: [LocationMenuPick] = [
        authoredPagePick(
            id: "pasteur-mentioned-district-1",
            title: "Đến Quận 1",
            subtitle: "Head to District 1",
            proof: "A District 1 line that helps errands, cafes, offices, and crossings make sense.",
            imageName: "HeroCityHcmcPlaceDistrict1",
            detailPageID: "viet-family-city-hcmc-go-district-1",
            audioText: "Đến Quận 1",
            after: "place-brief"
        ),
    ]

    private static let loadingTCafeMentionedPicks: [LocationMenuPick] = [
        authoredPagePick(
            id: "loading-t-mentioned-egg-coffee",
            title: "Cà phê trứng",
            subtitle: "Egg coffee",
            proof: "The Hanoi drink many visitors come upstairs for.",
            imageName: "HeroCityHanoiPlaceEggCoffee",
            detailPageID: "viet-family-city-hanoi-place-egg-coffee",
            audioText: "Cà phê trứng",
            after: "place-brief"
        ),
        authoredPagePick(
            id: "loading-t-mentioned-ca-phe-sua-da",
            title: "Cà phê sữa đá",
            subtitle: "Iced milk coffee",
            proof: "The familiar cold coffee order beside the room itself.",
            imageName: "HeroCityHanoiPlaceCaPheSuaDa",
            detailPageID: "viet-family-city-hanoi-place-ca-phe-sua-da",
            audioText: "Cà phê sữa đá",
            after: "place-brief"
        ),
        authoredPagePick(
            id: "loading-t-mentioned-old-quarter",
            title: "Phố cổ Hà Nội",
            subtitle: "Hanoi Old Quarter",
            proof: "The surrounding walking context for a tucked-away coffee pause.",
            imageName: "HeroCityHanoiPlaceOldQuarter",
            detailPageID: "viet-family-city-hanoi-go-old-quarter",
            audioText: "Phố cổ Hà Nội",
            after: "place-brief"
        ),
    ]

    private static let lotteMartDanangMentionedPicks: [LocationMenuPick] = [
        authoredPagePick(
            id: "lotte-mart-mentioned-sunscreen",
            title: "Sunscreen",
            subtitle: "Restock before beach time or a long ride.",
            proof: "Worth grabbing before beach time, a long walk, or a ride out of town.",
            imageName: "HeroCityDanangPlaceLotteMart",
            detailPageID: "viet-family-service-sunscreen",
            after: "place-brief"
        ),
    ]

    private static let lusineThaoDienPicks: [LocationMenuPick] = [
        LocationMenuPick(
            id: "lusine-eggs-benedict",
            title: "Eggs Benedict",
            subtitle: "Brunch eggs with hollandaise",
            proof: "The familiar brunch default.",
            imageName: "HeroMenuFoodBanhMiOpLa",
            detailPageID: "viet-menu-lusine-thao-dien-eggs-benedict",
            linkedMenuItemID: nil,
            afterSectionID: nil
        ),
        LocationMenuPick(
            id: "lusine-premium-pho",
            title: "Premium Pho",
            subtitle: "Related phrase: Phở đặc biệt",
            proof: "The comfort bowl beside coffee.",
            imageName: VietnameseMenuImages.assetName(forItemID: "food-pho-dac-biet"),
            detailPageID: "viet-menu-food-pho-dac-biet",
            linkedMenuItemID: "food-pho-dac-biet",
            afterSectionID: nil
        ),
        LocationMenuPick(
            id: "lusine-squid-ink-crab-pasta",
            title: "Squid ink crab pasta",
            subtitle: "Seafood pasta",
            proof: "The plate that turns coffee into lunch.",
            imageName: "HeroMenuFoodMiXaoHaiSan",
            detailPageID: "viet-menu-lusine-thao-dien-squid-ink-crab-pasta",
            linkedMenuItemID: nil,
            afterSectionID: nil
        ),
        LocationMenuPick(
            id: "lusine-crispy-chicken-salad",
            title: "Crispy chicken salad",
            subtitle: "Fresh salad with crunch",
            proof: "The lighter plate with crunch.",
            imageName: "HeroMenuFoodGoiGa",
            detailPageID: "viet-menu-lusine-thao-dien-crispy-chicken-salad",
            linkedMenuItemID: nil,
            afterSectionID: nil
        ),
        LocationMenuPick(
            id: "lusine-salt-caramel-coffee",
            title: "Salt caramel coffee",
            subtitle: "Sweet coffee drink",
            proof: "The one people stay longer for.",
            imageName: "HeroMenuDrinkCaPheMuoi",
            detailPageID: "viet-menu-lusine-thao-dien-salt-caramel-coffee",
            linkedMenuItemID: nil,
            afterSectionID: nil
        ),
        LocationMenuPick(
            id: "lusine-avocado-toast",
            title: "Avocado toast",
            subtitle: "Breakfast toast",
            proof: "The simple breakfast beside coffee.",
            imageName: "HeroMenuFoodBanhMiOpLa",
            detailPageID: "viet-menu-lusine-thao-dien-avocado-toast",
            linkedMenuItemID: nil,
            afterSectionID: nil
        ),
    ]

    private static func detailHeroImageName(for pick: LocationMenuPick) -> String {
        switch pick.id {
        case "lusine-eggs-benedict", "lusine-avocado-toast":
            return "BackdropMenuFoodBanhMiOpLa"
        case "lusine-squid-ink-crab-pasta":
            return "BackdropMenuFoodMiXaoHaiSan"
        case "lusine-crispy-chicken-salad":
            return "BackdropMenuFoodGoiGa"
        case "lusine-salt-caramel-coffee":
            return "BackdropMenuDrinkCaPheMuoi"
        default:
            return "HeroCityHcmcPlaceLusineThaoDien"
        }
    }

    private static func detailSections(for pick: LocationMenuPick) -> [PhraseDetailSection] {
        [
            PhraseDetailSection(
                id: "why-it-shows-up",
                title: "Why it shows up",
                body: pick.proof,
                presentation: .tipCallout
            ),
            PhraseDetailSection(
                id: "what-it-is",
                title: "What it is",
                body: detailBody(for: pick)
            ),
            PhraseDetailSection(
                id: "at-lusine",
                title: "At L'Usine Thảo Điền",
                body: "This branch is remembered as a sit-down brunch cafe, not just a coffee counter: real plates, good coffee, a calmer room, and service people mention afterward."
            ),
        ]
    }

    private static func detailBody(for pick: LocationMenuPick) -> String {
        switch pick.id {
        case "lusine-eggs-benedict":
            return "A classic brunch plate with poached eggs and hollandaise. This is the easy first order when the visit is meant to be breakfast, not only coffee."
        case "lusine-squid-ink-crab-pasta":
            return "A richer seafood pasta order that makes the table feel more like lunch. It is one of the dishes guests name when the cafe turns into a full meal."
        case "lusine-crispy-chicken-salad":
            return "A lighter plate with crunch for the table that wants brunch without everyone choosing eggs, noodles, or a heavier main."
        case "lusine-salt-caramel-coffee":
            return "A sweeter coffee drink for the second-cup part of the visit. It belongs to the Sunday-morning side of this branch."
        case "lusine-avocado-toast":
            return "A familiar breakfast order that makes the branch feel easy for a first Thao Dien morning, especially beside coffee."
        default:
            return pick.subtitle
        }
    }
}

enum LocationRelatedPicksCatalog {
    static func picks(forPageID pageID: String) -> [LocationMenuPick] {
        if pageID.hasPrefix("viet-phrase-city-") {
            let familyPageID = "viet-family-city-" + String(pageID.dropFirst("viet-phrase-city-".count))
            return picks(forPageID: familyPageID)
        }

        let staticPicks: [LocationMenuPick]
        switch pageID {
        case "viet-family-city-danang-place-international-terminal":
            staticPicks = [
                relatedPlacePick(
                    id: "terminal-related-airport",
                    title: "Sân bay Đà Nẵng",
                    subtitle: "Da Nang Airport",
                    proof: "Use the broader airport name when terminal details are not needed.",
                    imageName: "HeroCityDanangPlaceAirport",
                    detailPageID: "viet-family-city-danang-place-airport",
                    audioText: "Sân bay Đà Nẵng"
                ),
                relatedPlacePick(
                    id: "terminal-related-domestic-terminal",
                    title: "Nhà ga quốc nội Đà Nẵng",
                    subtitle: "Da Nang Domestic Terminal",
                    proof: "The domestic side matters for pickups, transfers, and check-in.",
                    imageName: "HeroCityDanangPlaceDomesticTerminal",
                    detailPageID: "viet-family-city-danang-place-domestic-terminal",
                    audioText: "Nhà ga quốc nội Đà Nẵng"
                ),
            ]
        case "viet-family-city-danang-place-dong-dinh-museum":
            staticPicks = [
                relatedPlacePick(
                    id: "dong-dinh-related-linh-ung",
                    title: "Chùa Linh Ứng",
                    subtitle: "Linh Ung Pagoda",
                    proof: "The pagoda stop most people pair with a Sơn Trà route.",
                    imageName: "HeroCityDanangPlaceLinhUngPagoda",
                    detailPageID: "viet-family-city-danang-place-linh-ung-pagoda",
                    audioText: "Chùa Linh Ứng"
                ),
                relatedPlacePick(
                    id: "dong-dinh-related-cham-museum",
                    title: "Bảo tàng Điêu khắc Chăm",
                    subtitle: "Museum of Cham Sculpture",
                    proof: "The stronger central-city museum contrast.",
                    imageName: "HeroCityDanangPlaceChamMuseum",
                    detailPageID: "viet-family-city-danang-place-cham-museum",
                    audioText: "Bảo tàng Điêu khắc Chăm"
                ),
            ]
        case "viet-family-city-hcmc-place-pasteur-street":
            staticPicks = [
                relatedPlacePick(
                    id: "pasteur-related-dong-khoi",
                    title: "Đường Đồng Khởi",
                    subtitle: "Dong Khoi Street",
                    proof: "A more polished District 1 street contrast.",
                    imageName: "HeroCityHcmcPlaceDongKhoiStreet",
                    detailPageID: "viet-family-city-hcmc-place-dong-khoi-street",
                    audioText: "Đường Đồng Khởi"
                ),
                relatedPlacePick(
                    id: "pasteur-related-district-3",
                    title: "Quận 3",
                    subtitle: "District 3",
                    proof: "A nearby district when the walk points beyond central errands.",
                    imageName: "HeroCityHcmcPlaceDistrict3",
                    detailPageID: "viet-family-city-hcmc-place-district-3",
                    audioText: "Quận 3"
                ),
            ]
        case "viet-family-city-hanoi-place-loading-t-cafe":
            staticPicks = [
                relatedPlacePick(
                    id: "loading-t-related-dinh-cafe",
                    title: "Cà phê Đinh",
                    subtitle: "Dinh Cafe",
                    proof: "Another upstairs Old Quarter coffee room.",
                    imageName: "HeroCityHanoiPlaceDinhCafe",
                    detailPageID: "viet-family-city-hanoi-place-dinh-cafe",
                    audioText: "Cà phê Đinh"
                ),
                relatedPlacePick(
                    id: "loading-t-related-giang-cafe",
                    title: "Cà phê Giảng",
                    subtitle: "Cafe Giang",
                    proof: "The classic egg-coffee comparison.",
                    imageName: "HeroCityHanoiPlaceGiangCafe",
                    detailPageID: "viet-family-city-hanoi-place-giang-cafe",
                    audioText: "Cà phê Giảng"
                ),
            ]
        case "viet-family-city-danang-place-lotte-mart":
            staticPicks = [
                relatedPlacePick(
                    id: "lotte-mart-related-han-market",
                    title: "Chợ Hàn",
                    subtitle: "Han Market",
                    proof: "The central-market contrast for texture and bargaining.",
                    imageName: "HeroCityDanangPlaceHanMarket",
                    detailPageID: "viet-family-city-danang-place-han-market",
                    audioText: "Chợ Hàn"
                ),
                relatedPlacePick(
                    id: "lotte-mart-related-vincom-plaza",
                    title: "Vincom Plaza Đà Nẵng",
                    subtitle: "Vincom Plaza Da Nang",
                    proof: "Another indoor mall option when cool air matters.",
                    imageName: "HeroCityDanangPlaceVincomPlaza",
                    detailPageID: "viet-family-city-danang-place-vincom-plaza",
                    audioText: "Vincom Plaza Đà Nẵng"
                ),
            ]
        case "viet-family-city-danang-place-3d-art-in-paradise":
            staticPicks = [
                relatedPlacePick(
                    id: "3d-art-related-fine-arts",
                    title: "Bảo tàng Mỹ thuật Đà Nẵng",
                    subtitle: "Da Nang Fine Arts Museum",
                    proof: "A quieter art stop when you want galleries instead of camera play.",
                    imageName: "HeroCityDanangPlaceFineArtsMuseum",
                    detailPageID: "viet-family-city-danang-place-fine-arts-museum"
                ),
            ]
        case "viet-family-city-hanoi-place-bun-cha":
            staticPicks = [
                relatedPlacePick(
                    id: "bun-cha-related-huong-lien",
                    title: "Bún chả Hương Liên",
                    subtitle: "Bun Cha Huong Lien",
                    proof: "A named bun cha stop if you want a specific restaurant target.",
                    imageName: "HeroCityHanoiPlaceBunChaHuongLien",
                    detailPageID: "viet-family-city-hanoi-place-bun-cha-huong-lien"
                ),
                relatedPlacePick(
                    id: "bun-cha-related-bun-cha-ta",
                    title: "Bún Chả Ta",
                    subtitle: "Bun Cha Ta",
                    proof: "Another named bun cha restaurant candidate for comparison.",
                    imageName: "HeroCityHanoiPlaceBunChaTa",
                    detailPageID: "viet-family-city-hanoi-place-bun-cha-ta"
                ),
            ]
        case "viet-family-city-hcmc-place-ben-thanh-market":
            staticPicks = [
                relatedPlacePick(
                    id: "ben-thanh-related-an-dong",
                    title: "Chợ An Đông",
                    subtitle: "An Dong Market",
                    proof: "A market comparison when shopping matters more than the landmark.",
                    imageName: "HeroCityHcmcPlaceAnDongMarket",
                    detailPageID: "viet-family-city-hcmc-place-an-dong-market"
                ),
                relatedPlacePick(
                    id: "ben-thanh-related-binh-tay",
                    title: "Chợ Bình Tây",
                    subtitle: "Binh Tay Market",
                    proof: "A Cholon market contrast with a different city rhythm.",
                    imageName: "HeroCityHcmcPlaceBinhTayMarket",
                    detailPageID: "viet-family-city-hcmc-place-binh-tay-market"
                ),
            ]
        case "viet-family-city-hoian-place-ancient-town-ticket-booth":
            staticPicks = [
                relatedPlacePick(
                    id: "ticket-booth-related-ancient-town",
                    title: "Phố cổ Hội An",
                    subtitle: "Hoi An Ancient Town",
                    proof: "The larger old-town area beyond the ticket pause.",
                    imageName: "HeroCityHoianPlaceAncientTown",
                    detailPageID: "viet-family-city-hoian-place-ancient-town"
                ),
            ]
        case "viet-family-city-hue-place-bach-ma-national-park":
            staticPicks = [
                relatedPlacePick(
                    id: "bach-ma-related-lap-an",
                    title: "Đầm Lập An",
                    subtitle: "Lap An Lagoon",
                    proof: "A lighter water-and-weather stop on a central Vietnam route.",
                    imageName: "HeroCityHuePlaceLapAnLagoon",
                    detailPageID: "viet-family-city-hue-place-lap-an-lagoon"
                ),
                relatedPlacePick(
                    id: "bach-ma-related-hai-van",
                    title: "Đèo Hải Vân",
                    subtitle: "Hai Van Pass",
                    proof: "A scenic mountain-road option when the ride matters more than hiking.",
                    imageName: "HeroCityDanangPlaceHaiVanPass",
                    detailPageID: "viet-family-city-danang-place-hai-van-pass"
                ),
            ]
        case "viet-family-city-danang-place-han-market":
            staticPicks = [
                LocationMenuPick(
                    id: "han-market-related-con-market",
                    title: "Chợ Cồn",
                    subtitle: "Con Market",
                    proof: "The stronger food-first market nearby.",
                    imageName: "HeroCityDanangPlaceConMarket",
                    detailPageID: "viet-family-city-danang-place-con-market",
                    audioText: "Chợ Cồn",
                    linkedMenuItemID: nil,
                    afterSectionID: "good-to-know"
                ),
            ]
        case "viet-family-city-danang-place-bep-cuon":
            staticPicks = [
                relatedPlacePick(
                    id: "bep-cuon-related-banh-xeo-ba-duong",
                    title: "Bánh xèo Bà Dưỡng",
                    subtitle: "Banh Xeo Ba Duong",
                    proof: "A louder hands-on Da Nang table when crisp pancakes and sauce should lead.",
                    imageName: "HeroCityDanangPlaceBanhXeoBaDuong",
                    detailPageID: "viet-family-city-danang-place-banh-xeo-ba-duong",
                    audioText: "Bánh xèo Bà Dưỡng"
                ),
            ]
        case "viet-family-city-danang-place-co-chu-nho":
            staticPicks = [
                relatedPlacePick(
                    id: "co-chu-nho-related-bep-cuon",
                    title: "Bếp Cuốn Đà Nẵng",
                    subtitle: "Bep Cuon Da Nang",
                    proof: "A 2025 MICHELIN Selected roll table when pork, herbs, rice paper, and mam nem should lead.",
                    imageName: "HeroCityDanangPlaceBepCuon",
                    detailPageID: "viet-family-city-danang-place-bep-cuon",
                    audioText: "Bếp Cuốn Đà Nẵng"
                ),
            ]
        case "viet-family-city-danang-place-the-temptation":
            staticPicks = [
                relatedPlacePick(
                    id: "the-temptation-related-nen",
                    title: "Nén Đà Nẵng",
                    subtitle: "Nen Da Nang",
                    proof: "A Vietnamese fine-dining destination when the evening should feel bigger than quiet French dinner.",
                    imageName: "HeroCityDanangPlaceNen",
                    detailPageID: "viet-family-city-danang-place-nen",
                    audioText: "Nén Đà Nẵng"
                ),
            ]
        default:
            staticPicks = []
        }

        return mergedLocationPicks(
            staticPicks: staticPicks,
            runtimePicks: VietSQLitePhraseGraphRuntime.locationRelationPicks(
                forPageID: pageID,
                relationType: "compare-nearby"
            )
        )
    }

    static func picks(forPageID pageID: String, afterSectionID sectionID: String) -> [LocationMenuPick] {
        picks(forPageID: pageID).filter { $0.afterSectionID == sectionID }
    }

    private static func relatedPlacePick(
        id: String,
        title: String,
        subtitle: String,
        proof: String,
        imageName: String,
        detailPageID: String,
        audioText: String? = nil
    ) -> LocationMenuPick {
        LocationMenuPick(
            id: id,
            title: title,
            subtitle: subtitle,
            proof: proof,
            imageName: imageName,
            detailPageID: detailPageID,
            audioText: audioText,
            linkedMenuItemID: nil,
            afterSectionID: "good-to-know"
        )
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
