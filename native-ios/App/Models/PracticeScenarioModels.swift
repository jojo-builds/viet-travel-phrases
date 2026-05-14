import Foundation

enum PracticeScenarioID: String, CaseIterable, Codable, Equatable, Identifiable {
    case danangFirstDay
    case airportPassportControl
    case airportSimCash
    case airportWifiPower
    case hotelCheckInHelp
    case hotelRoomHelp
    case hotelBagsTaxi
    case hotelWifiCheckout
    case restaurantOrderingPayment
    case danangDay
    case foodAllergyHelp
    case foodCoffeeOrder
    case taxiGrabPickup
    case taxiRouteHelp
    case driverProblemHelp
    case walkingDirectionsHelp
    case shoppingMarketPrice
    case shoppingSizeGift
    case shoppingReceiptHelp
    case shoppingPayCard
    case pharmacyHelp
    case emergencyLostPassport
    case emergencyLostBag
    case emergencyDoctorHelp
    case localGreetingMarket
    case localGreetingHotel
    case localGreetingRespect
    case localThanksSorry

    var id: String { rawValue }

    var title: String {
        switch self {
        case .danangFirstDay:
            return "Airport baggage"
        case .airportPassportControl:
            return "Passport control"
        case .airportSimCash:
            return "SIM and cash"
        case .airportWifiPower:
            return "Airport Wi-Fi"
        case .hotelCheckInHelp:
            return "Hotel check-in"
        case .hotelRoomHelp:
            return "Room help"
        case .hotelBagsTaxi:
            return "Bags and taxi"
        case .hotelWifiCheckout:
            return "Wi-Fi and checkout"
        case .restaurantOrderingPayment:
            return "Restaurant table"
        case .danangDay:
            return "Beach snacks"
        case .foodAllergyHelp:
            return "Food allergies"
        case .foodCoffeeOrder:
            return "Coffee order"
        case .taxiGrabPickup:
            return "Grab pickup"
        case .taxiRouteHelp:
            return "Taxi route"
        case .driverProblemHelp:
            return "Driver help"
        case .walkingDirectionsHelp:
            return "Walking directions"
        case .shoppingMarketPrice:
            return "Market price"
        case .shoppingSizeGift:
            return "Size and gift"
        case .shoppingReceiptHelp:
            return "Receipt help"
        case .shoppingPayCard:
            return "Pay by card"
        case .pharmacyHelp:
            return "Pharmacy visit"
        case .emergencyLostPassport:
            return "Lost passport"
        case .emergencyLostBag:
            return "Lost bag"
        case .emergencyDoctorHelp:
            return "Doctor help"
        case .localGreetingMarket:
            return "Market hello"
        case .localGreetingHotel:
            return "Hotel hello"
        case .localGreetingRespect:
            return "Respectful hello"
        case .localThanksSorry:
            return "Thanks and sorry"
        }
    }

    var shortTitle: String {
        switch self {
        case .danangFirstDay:
            return "Baggage"
        case .airportPassportControl:
            return "Passport"
        case .airportSimCash:
            return "SIM"
        case .airportWifiPower:
            return "Wi-Fi"
        case .hotelCheckInHelp:
            return "Check-In"
        case .hotelRoomHelp:
            return "Room"
        case .hotelBagsTaxi:
            return "Bags"
        case .hotelWifiCheckout:
            return "Wi-Fi"
        case .restaurantOrderingPayment:
            return "Table"
        case .danangDay:
            return "Snacks"
        case .foodAllergyHelp:
            return "Allergy"
        case .foodCoffeeOrder:
            return "Coffee"
        case .taxiGrabPickup:
            return "Grab"
        case .taxiRouteHelp:
            return "Route"
        case .driverProblemHelp:
            return "Driver"
        case .walkingDirectionsHelp:
            return "Walk"
        case .shoppingMarketPrice:
            return "Market"
        case .shoppingSizeGift:
            return "Gift"
        case .shoppingReceiptHelp:
            return "Receipt"
        case .shoppingPayCard:
            return "Card"
        case .pharmacyHelp:
            return "Pharmacy"
        case .emergencyLostPassport:
            return "Passport"
        case .emergencyLostBag:
            return "Lost Bag"
        case .emergencyDoctorHelp:
            return "Doctor"
        case .localGreetingMarket:
            return "Market"
        case .localGreetingHotel:
            return "Hotel"
        case .localGreetingRespect:
            return "Respect"
        case .localThanksSorry:
            return "Thanks"
        }
    }

    var symbolName: String {
        switch self {
        case .danangFirstDay:
            return "airplane.arrival"
        case .airportPassportControl:
            return "doc.text.fill"
        case .airportSimCash:
            return "simcard.fill"
        case .airportWifiPower:
            return "wifi"
        case .hotelCheckInHelp:
            return "bed.double.fill"
        case .hotelRoomHelp:
            return "key.fill"
        case .hotelBagsTaxi:
            return "suitcase.cart.fill"
        case .hotelWifiCheckout:
            return "wifi.router.fill"
        case .restaurantOrderingPayment:
            return "fork.knife"
        case .danangDay:
            return "cup.and.saucer.fill"
        case .foodAllergyHelp:
            return "leaf.fill"
        case .foodCoffeeOrder:
            return "cup.and.saucer.fill"
        case .taxiGrabPickup:
            return "car.fill"
        case .taxiRouteHelp:
            return "map.fill"
        case .driverProblemHelp:
            return "exclamationmark.triangle.fill"
        case .walkingDirectionsHelp:
            return "figure.walk"
        case .shoppingMarketPrice:
            return "basket.fill"
        case .shoppingSizeGift:
            return "gift.fill"
        case .shoppingReceiptHelp:
            return "receipt.fill"
        case .shoppingPayCard:
            return "creditcard.fill"
        case .pharmacyHelp:
            return "cross.case.fill"
        case .emergencyLostPassport:
            return "person.text.rectangle.fill"
        case .emergencyLostBag:
            return "bag.fill"
        case .emergencyDoctorHelp:
            return "stethoscope"
        case .localGreetingMarket:
            return "hand.wave.fill"
        case .localGreetingHotel:
            return "person.crop.circle.badge.checkmark"
        case .localGreetingRespect:
            return "person.2.fill"
        case .localThanksSorry:
            return "bubble.left.and.bubble.right.fill"
        }
    }

    var tint: AccentTint {
        switch self {
        case .danangFirstDay:
            return .blue
        case .airportPassportControl:
            return .red
        case .airportSimCash, .airportWifiPower:
            return .green
        case .hotelCheckInHelp, .hotelRoomHelp, .hotelBagsTaxi, .hotelWifiCheckout:
            return .purple
        case .restaurantOrderingPayment, .danangDay, .foodAllergyHelp, .foodCoffeeOrder:
            return .green
        case .taxiGrabPickup, .taxiRouteHelp, .driverProblemHelp, .walkingDirectionsHelp:
            return .orange
        case .shoppingMarketPrice, .shoppingSizeGift, .shoppingReceiptHelp, .shoppingPayCard:
            return .orange
        case .pharmacyHelp, .emergencyLostPassport, .emergencyLostBag, .emergencyDoctorHelp:
            return .red
        case .localGreetingMarket, .localGreetingHotel, .localGreetingRespect, .localThanksSorry:
            return .teal
        }
    }

    var categoryIDs: [String] {
        switch self {
        case .danangFirstDay:
            return ["airport-border-arrival", "transport", "hotel-accommodation", "food-drink"]
        case .airportPassportControl:
            return ["airport-border-arrival", "directions-navigation"]
        case .airportSimCash:
            return ["airport-border-arrival", "phone-internet-power", "money-numbers-prices"]
        case .airportWifiPower:
            return ["airport-border-arrival", "phone-internet-power", "problems-help"]
        case .hotelCheckInHelp:
            return ["hotel-accommodation", "problems-help"]
        case .hotelRoomHelp:
            return ["hotel-accommodation", "phone-internet-power", "problems-help"]
        case .hotelBagsTaxi:
            return ["hotel-accommodation", "transport", "directions-navigation"]
        case .hotelWifiCheckout:
            return ["hotel-accommodation", "phone-internet-power", "time-dates-booking"]
        case .restaurantOrderingPayment:
            return ["food-drink", "money-numbers-prices"]
        case .danangDay:
            return ["food-drink", "local-services-everyday-tasks", "money-numbers-prices"]
        case .foodAllergyHelp:
            return ["food-drink", "health-pharmacy", "understanding-repair"]
        case .foodCoffeeOrder:
            return ["food-drink", "money-numbers-prices"]
        case .taxiGrabPickup:
            return ["transport", "directions-navigation"]
        case .taxiRouteHelp:
            return ["transport", "directions-navigation", "money-numbers-prices"]
        case .driverProblemHelp:
            return ["transport", "problems-help", "emergency-safety"]
        case .walkingDirectionsHelp:
            return ["directions-navigation", "transport", "understanding-repair"]
        case .shoppingMarketPrice:
            return ["shopping", "money-numbers-prices"]
        case .shoppingSizeGift:
            return ["shopping", "local-services-everyday-tasks"]
        case .shoppingReceiptHelp:
            return ["shopping", "money-numbers-prices", "local-services-everyday-tasks"]
        case .shoppingPayCard:
            return ["shopping", "money-numbers-prices"]
        case .pharmacyHelp:
            return ["health-pharmacy", "problems-help"]
        case .emergencyLostPassport:
            return ["emergency-safety", "problems-help", "airport-border-arrival"]
        case .emergencyLostBag:
            return ["emergency-safety", "problems-help", "airport-border-arrival"]
        case .emergencyDoctorHelp:
            return ["health-pharmacy", "emergency-safety", "problems-help"]
        case .localGreetingMarket, .localGreetingHotel, .localGreetingRespect, .localThanksSorry:
            return ["polite-basics", "social-small-talk", "relationship-aware-hellos"]
        }
    }

    var flowBeats: [String] {
        switch self {
        case .danangFirstDay:
            return ["Baggage", "Pickup", "Driver", "Water"]
        case .airportPassportControl:
            return ["Passport", "Visa", "Purpose", "Signature"]
        case .airportSimCash:
            return ["SIM", "Cash", "Info desk", "Pickup"]
        case .airportWifiPower:
            return ["Wi-Fi", "Charge", "Help desk", "Pickup"]
        case .hotelCheckInHelp:
            return ["Booking", "Passport", "Wi-Fi", "Room help"]
        case .hotelRoomHelp:
            return ["Key card", "Try again", "Staff", "Supplies"]
        case .hotelBagsTaxi:
            return ["Hold bags", "Pickup", "Taxi", "Airport"]
        case .hotelWifiCheckout:
            return ["Wi-Fi", "Checkout", "Receipt", "Bags"]
        case .restaurantOrderingPayment:
            return ["Table", "Menu", "Order", "Pay"]
        case .danangDay:
            return ["Water", "Shade", "Snack", "Pay"]
        case .foodAllergyHelp:
            return ["Allergy", "Ingredients", "Safer dish", "Fix order"]
        case .foodCoffeeOrder:
            return ["Coffee", "Ice", "Sugar", "Pay"]
        case .taxiGrabPickup:
            return ["Confirm car", "Pickup point", "Route", "Drop-off"]
        case .taxiRouteHelp:
            return ["Hotel", "Map", "Turns", "Receipt"]
        case .driverProblemHelp:
            return ["Wrong car", "Call driver", "Unsafe", "Report"]
        case .walkingDirectionsHelp:
            return ["Find place", "Straight", "Turn", "Repeat"]
        case .shoppingMarketPrice:
            return ["Price", "Discount", "Two items", "Pay"]
        case .shoppingSizeGift:
            return ["Gift", "Size", "Color", "Pack"]
        case .shoppingReceiptHelp:
            return ["Card", "Receipt", "Wrong charge", "Refund"]
        case .shoppingPayCard:
            return ["Card", "QR", "Another card", "Receipt"]
        case .pharmacyHelp:
            return ["Find help", "Symptoms", "Medicine", "Directions"]
        case .emergencyLostPassport:
            return ["Passport", "Police", "Embassy", "Report"]
        case .emergencyLostBag:
            return ["Stolen bag", "Security", "Camera", "Report"]
        case .emergencyDoctorHelp:
            return ["Doctor", "Clinic", "Hospital", "Interpreter"]
        case .localGreetingMarket:
            return ["Hello", "Look around", "Thanks", "Goodbye"]
        case .localGreetingHotel:
            return ["Polite hello", "Wait", "Sorry", "Thanks"]
        case .localGreetingRespect:
            return ["Respectful hello", "Look around", "Permission", "Thanks"]
        case .localThanksSorry:
            return ["Thank you", "Sorry", "Repeat", "No thanks"]
        }
    }

    var messageContactName: String {
        switch self {
        case .danangFirstDay:
            return "Airport Baggage"
        case .airportPassportControl:
            return "Passport Control"
        case .airportSimCash:
            return "SIM & Cash"
        case .airportWifiPower:
            return "Airport Wi-Fi"
        case .hotelCheckInHelp:
            return "Hotel Check-In"
        case .hotelRoomHelp:
            return "Room Help"
        case .hotelBagsTaxi:
            return "Bags & Taxi"
        case .hotelWifiCheckout:
            return "Hotel Wi-Fi"
        case .restaurantOrderingPayment:
            return "Restaurant Table"
        case .danangDay:
            return "Beach Snacks"
        case .foodAllergyHelp:
            return "Food Allergies"
        case .foodCoffeeOrder:
            return "Coffee Order"
        case .taxiGrabPickup:
            return "Grab Pickup"
        case .taxiRouteHelp:
            return "Taxi Route"
        case .driverProblemHelp:
            return "Driver Help"
        case .walkingDirectionsHelp:
            return "Walking Help"
        case .shoppingMarketPrice:
            return "Market Price"
        case .shoppingSizeGift:
            return "Gift & Size"
        case .shoppingReceiptHelp:
            return "Receipt Help"
        case .shoppingPayCard:
            return "Pay by Card"
        case .pharmacyHelp:
            return "Pharmacy Visit"
        case .emergencyLostPassport:
            return "Lost Passport"
        case .emergencyLostBag:
            return "Lost Bag"
        case .emergencyDoctorHelp:
            return "Doctor Help"
        case .localGreetingMarket:
            return "Market Hello"
        case .localGreetingHotel:
            return "Hotel Hello"
        case .localGreetingRespect:
            return "Respectful Hello"
        case .localThanksSorry:
            return "Thanks & Sorry"
        }
    }

    var messageLocation: String {
        switch self {
        case .danangFirstDay:
            return "Da Nang Airport"
        case .airportPassportControl:
            return "Arrival desk"
        case .airportSimCash:
            return "Airport services"
        case .airportWifiPower:
            return "Arrivals hall"
        case .hotelCheckInHelp:
            return "Ngu Hanh Son, Da Nang"
        case .hotelRoomHelp:
            return "Hotel room"
        case .hotelBagsTaxi:
            return "Front desk"
        case .hotelWifiCheckout:
            return "Front desk"
        case .restaurantOrderingPayment:
            return "Local restaurant"
        case .danangDay:
            return "Beach stand"
        case .foodAllergyHelp:
            return "Street food stall"
        case .foodCoffeeOrder:
            return "Local cafe"
        case .taxiGrabPickup:
            return "Pickup point"
        case .taxiRouteHelp:
            return "In the taxi"
        case .driverProblemHelp:
            return "Ride problem"
        case .walkingDirectionsHelp:
            return "Street corner"
        case .shoppingMarketPrice:
            return "Local market"
        case .shoppingSizeGift:
            return "Gift shop"
        case .shoppingReceiptHelp:
            return "Checkout counter"
        case .shoppingPayCard:
            return "Checkout counter"
        case .pharmacyHelp:
            return "Nearby pharmacy"
        case .emergencyLostPassport:
            return "Police station"
        case .emergencyLostBag:
            return "Security desk"
        case .emergencyDoctorHelp:
            return "Clinic desk"
        case .localGreetingMarket:
            return "Morning market"
        case .localGreetingHotel:
            return "Hotel lobby"
        case .localGreetingRespect:
            return "Neighborhood shop"
        case .localThanksSorry:
            return "Everyday chat"
        }
    }

    var messageInitials: String {
        switch self {
        case .danangFirstDay:
            return "AB"
        case .airportPassportControl:
            return "PC"
        case .airportSimCash:
            return "SC"
        case .airportWifiPower:
            return "AW"
        case .hotelCheckInHelp:
            return "HC"
        case .hotelRoomHelp:
            return "RH"
        case .hotelBagsTaxi:
            return "BT"
        case .hotelWifiCheckout:
            return "HW"
        case .restaurantOrderingPayment:
            return "RT"
        case .danangDay:
            return "BS"
        case .foodAllergyHelp:
            return "FA"
        case .foodCoffeeOrder:
            return "CO"
        case .taxiGrabPickup:
            return "GP"
        case .taxiRouteHelp:
            return "TR"
        case .driverProblemHelp:
            return "DH"
        case .walkingDirectionsHelp:
            return "WH"
        case .shoppingMarketPrice:
            return "MP"
        case .shoppingSizeGift:
            return "GS"
        case .shoppingReceiptHelp:
            return "RH"
        case .shoppingPayCard:
            return "PC"
        case .pharmacyHelp:
            return "PV"
        case .emergencyLostPassport:
            return "LP"
        case .emergencyLostBag:
            return "LB"
        case .emergencyDoctorHelp:
            return "DR"
        case .localGreetingMarket:
            return "MH"
        case .localGreetingHotel:
            return "HH"
        case .localGreetingRespect:
            return "RH"
        case .localThanksSorry:
            return "TS"
        }
    }

    var messageAvatarSymbolName: String {
        switch self {
        case .danangFirstDay:
            return "airplane.arrival"
        case .airportPassportControl:
            return "doc.text.fill"
        case .airportSimCash:
            return "simcard.fill"
        case .airportWifiPower:
            return "wifi"
        case .hotelCheckInHelp:
            return "person.crop.circle.badge.checkmark"
        case .hotelRoomHelp:
            return "key.fill"
        case .hotelBagsTaxi:
            return "suitcase.cart.fill"
        case .hotelWifiCheckout:
            return "wifi.router.fill"
        case .restaurantOrderingPayment:
            return "fork.knife"
        case .danangDay:
            return "cup.and.saucer.fill"
        case .foodAllergyHelp:
            return "leaf.fill"
        case .foodCoffeeOrder:
            return "cup.and.saucer.fill"
        case .taxiGrabPickup:
            return "car.fill"
        case .taxiRouteHelp:
            return "map.fill"
        case .driverProblemHelp:
            return "exclamationmark.triangle.fill"
        case .walkingDirectionsHelp:
            return "figure.walk"
        case .shoppingMarketPrice:
            return "basket.fill"
        case .shoppingSizeGift:
            return "gift.fill"
        case .shoppingReceiptHelp:
            return "receipt.fill"
        case .shoppingPayCard:
            return "creditcard.fill"
        case .pharmacyHelp:
            return "cross.case.fill"
        case .emergencyLostPassport:
            return "person.text.rectangle.fill"
        case .emergencyLostBag:
            return "bag.fill"
        case .emergencyDoctorHelp:
            return "stethoscope"
        case .localGreetingMarket:
            return "hand.wave.fill"
        case .localGreetingHotel:
            return "person.crop.circle.badge.checkmark"
        case .localGreetingRespect:
            return "person.2.fill"
        case .localThanksSorry:
            return "bubble.left.and.bubble.right.fill"
        }
    }

    var messageSectionTitle: String {
        switch self {
        case .danangFirstDay, .airportPassportControl, .airportSimCash, .airportWifiPower:
            return "Airport"
        case .hotelCheckInHelp, .hotelRoomHelp, .hotelBagsTaxi, .hotelWifiCheckout:
            return "Hotel"
        case .restaurantOrderingPayment, .danangDay, .foodAllergyHelp, .foodCoffeeOrder:
            return "Food"
        case .taxiGrabPickup, .taxiRouteHelp, .driverProblemHelp, .walkingDirectionsHelp:
            return "Getting Around"
        case .shoppingMarketPrice, .shoppingSizeGift, .shoppingReceiptHelp, .shoppingPayCard:
            return "Shopping"
        case .pharmacyHelp, .emergencyLostPassport, .emergencyLostBag, .emergencyDoctorHelp:
            return "Emergency"
        case .localGreetingMarket, .localGreetingHotel, .localGreetingRespect, .localThanksSorry:
            return "Local Greetings"
        }
    }

    var messageSectionSortRank: Int {
        switch self {
        case .danangFirstDay, .airportPassportControl, .airportSimCash, .airportWifiPower:
            return 0
        case .hotelCheckInHelp, .hotelRoomHelp, .hotelBagsTaxi, .hotelWifiCheckout:
            return 1
        case .restaurantOrderingPayment, .danangDay, .foodAllergyHelp, .foodCoffeeOrder:
            return 2
        case .taxiGrabPickup, .taxiRouteHelp, .driverProblemHelp, .walkingDirectionsHelp:
            return 3
        case .shoppingMarketPrice, .shoppingSizeGift, .shoppingReceiptHelp, .shoppingPayCard:
            return 4
        case .pharmacyHelp, .emergencyLostPassport, .emergencyLostBag, .emergencyDoctorHelp:
            return 5
        case .localGreetingMarket, .localGreetingHotel, .localGreetingRespect, .localThanksSorry:
            return 6
        }
    }

    var messageContactSortRank: Int {
        switch self {
        case .danangFirstDay, .hotelCheckInHelp, .foodAllergyHelp, .taxiGrabPickup, .shoppingMarketPrice, .pharmacyHelp, .localGreetingMarket:
            return 0
        case .airportPassportControl, .hotelRoomHelp, .restaurantOrderingPayment, .taxiRouteHelp, .shoppingSizeGift, .emergencyLostPassport, .localGreetingHotel:
            return 1
        case .airportSimCash, .hotelBagsTaxi, .danangDay, .driverProblemHelp, .shoppingReceiptHelp, .emergencyLostBag, .localGreetingRespect:
            return 2
        case .airportWifiPower, .hotelWifiCheckout, .foodCoffeeOrder, .walkingDirectionsHelp, .shoppingPayCard, .emergencyDoctorHelp, .localThanksSorry:
            return 3
        }
    }

    static var messageSectionTitles: [String] {
        let titlesByRank = Dictionary(grouping: allCases, by: \.messageSectionTitle)

        return titlesByRank.keys.sorted { lhs, rhs in
            let lhsRank = titlesByRank[lhs]?.first?.messageSectionSortRank ?? Int.max
            let rhsRank = titlesByRank[rhs]?.first?.messageSectionSortRank ?? Int.max

            if lhsRank != rhsRank {
                return lhsRank < rhsRank
            }

            return lhs < rhs
        }
    }

    static func messageScenarioIDs(in sectionTitle: String) -> [PracticeScenarioID] {
        allCases
            .filter { $0.messageSectionTitle == sectionTitle }
            .sorted { lhs, rhs in
                if lhs.messageContactSortRank != rhs.messageContactSortRank {
                    return lhs.messageContactSortRank < rhs.messageContactSortRank
                }

                return declarationIndex(of: lhs) < declarationIndex(of: rhs)
            }
    }

    private static func declarationIndex(of id: PracticeScenarioID) -> Int {
        allCases.firstIndex(of: id) ?? Int.max
    }
}

enum PracticeScenarioMomentType: String, Codable, Equatable {
    case ask
    case listen
    case recovery
}

enum PracticeScenarioQueueSource: String, CaseIterable, Codable, Equatable, Hashable {
    case missedReview
    case addedPractice
    case savedRecent
    case tripFallback

    var title: String {
        switch self {
        case .missedReview:
            return "Worth repeating"
        case .addedPractice:
            return "Saved phrases"
        case .savedRecent:
            return "Recent phrases"
        case .tripFallback:
            return "Starter scenes"
        }
    }

    var subtitle: String {
        switch self {
        case .missedReview:
            return "Phrases worth keeping fresh."
        case .addedPractice:
            return "Phrases you kept for later."
        case .savedRecent:
            return "Recently opened phrases."
        case .tripFallback:
            return "Practical travel conversations to start with."
        }
    }

    var sortRank: Int {
        switch self {
        case .missedReview:
            return 0
        case .addedPractice:
            return 1
        case .savedRecent:
            return 2
        case .tripFallback:
            return 3
        }
    }
}

enum PracticeScenarioPhraseRole: String, Codable, Equatable {
    case youHear = "you_hear"
    case bestQuickReply = "best_quick_reply"
    case moreReply = "more_reply"
    case ifUnsure = "if_unsure"
}

struct PracticeScenarioPhraseCopy: Equatable {
    let scenarioVietnamese: String
    let scenarioEnglish: String
    let scenarioRole: PracticeScenarioPhraseRole
    let scenarioContext: String
    let sourcePhraseID: String?
}

struct PracticeScenarioResponseOption: Identifiable, Equatable {
    let id: String
    let candidate: PracticeCandidate
    let isBestFit: Bool
    let scenarioCopy: PracticeScenarioPhraseCopy?
    let nextLocalLine: String?
    let nextLocalMeaning: String?
    let feedbackTitle: String
    let feedbackBody: String

    var scenarioVietnamese: String {
        scenarioCopy?.scenarioVietnamese ?? candidate.vietnamese
    }

    var scenarioEnglish: String {
        scenarioCopy?.scenarioEnglish ?? candidate.english
    }

    var scenarioRole: PracticeScenarioPhraseRole {
        scenarioCopy?.scenarioRole ?? (isBestFit ? .bestQuickReply : .moreReply)
    }

    var scenarioContext: String {
        scenarioCopy?.scenarioContext ?? "scenario_response"
    }

    var sourcePhraseID: String {
        scenarioCopy?.sourcePhraseID ?? candidate.phraseID
    }

    var audioKey: String? {
        AudioAssetManifest.main?.audioKey(forExactText: scenarioVietnamese)
    }

    var hasSpecificLocalReply: Bool {
        nextLocalLine?.isEmpty == false || nextLocalMeaning?.isEmpty == false
    }
}

struct PracticeScenarioRecovery: Equatable {
    let title: String
    let body: String
    let candidate: PracticeCandidate?
}

struct PracticeScenarioStep: Identifiable, Equatable {
    let id: String
    let scenarioID: PracticeScenarioID
    let queueSource: PracticeScenarioQueueSource
    let momentType: PracticeScenarioMomentType
    let scene: String
    let localPhrase: PracticeScenarioPhraseCopy
    let localLine: String
    let localLineMeaning: String
    let userGoal: String
    let responseOptions: [PracticeScenarioResponseOption]
    let nextLocalLine: String
    let nextLocalMeaning: String
    let recovery: PracticeScenarioRecovery
    let nextStepTitle: String
    let source: PracticeSourceMetadata

    var bestResponse: PracticeScenarioResponseOption? {
        responseOptions.first(where: \.isBestFit)
    }

    func localReplyLine(after option: PracticeScenarioResponseOption) -> String {
        option.nextLocalLine ?? nextLocalLine
    }

    func localReplyMeaning(after option: PracticeScenarioResponseOption) -> String {
        option.nextLocalMeaning ?? nextLocalMeaning
    }

    func hasLocalReply(after option: PracticeScenarioResponseOption) -> Bool {
        !localReplyLine(after: option).isEmpty || !localReplyMeaning(after: option).isEmpty
    }

    var visibleCopy: [String] {
        [
            scene,
            localLine,
            localLineMeaning,
            userGoal,
            nextLocalLine,
            nextLocalMeaning,
            recovery.title,
            recovery.body,
            nextStepTitle,
        ] + responseOptions.flatMap { option in
            [
                option.scenarioVietnamese,
                option.scenarioEnglish,
                option.nextLocalLine ?? "",
                option.nextLocalMeaning ?? "",
            ]
        }
    }
}

struct PracticeScenario: Identifiable, Equatable {
    let id: PracticeScenarioID
    let queueSource: PracticeScenarioQueueSource
    let sceneTitle: String
    let sceneSetup: String
    let steps: [PracticeScenarioStep]

    var title: String { id.title }

    var unreadPreview: String {
        steps.first?.localLine ?? sceneSetup
    }

    var recommendedCandidates: [PracticeCandidate] {
        steps.compactMap { $0.bestResponse?.candidate }
    }

    var phrasePageIDs: [String] {
        var seen = Set<String>()
        return steps
            .flatMap { step -> [String] in
                let recoveryPageIDs = step.recovery.candidate.map { [$0.pageID] } ?? []
                return step.responseOptions.map(\.candidate.pageID)
                    + recoveryPageIDs
            }
            .filter { seen.insert($0).inserted }
    }

    func visibleResponseOptions(
        for step: PracticeScenarioStep,
        selectedOptionIDs: [String: String],
        limit: Int = 4
    ) -> [PracticeScenarioResponseOption] {
        var blockedKeys = previouslySelectedReplyKeys(before: step, selectedOptionIDs: selectedOptionIDs)
        var visible: [PracticeScenarioResponseOption] = []

        for option in step.responseOptions {
            let optionKeys = Self.replyKeys(for: option)
            guard optionKeys.isDisjoint(with: blockedKeys) else {
                continue
            }

            visible.append(option)
            blockedKeys.formUnion(optionKeys)

            if visible.count == limit {
                break
            }
        }

        if visible.isEmpty {
            return Array(step.responseOptions.prefix(limit))
        }

        return visible
    }

    var visibleCopy: [String] {
        [sceneTitle, sceneSetup, queueSource.title, queueSource.subtitle]
            + steps.flatMap(\.visibleCopy)
    }

    private func previouslySelectedReplyKeys(
        before step: PracticeScenarioStep,
        selectedOptionIDs: [String: String]
    ) -> Set<String> {
        guard let currentStepIndex = steps.firstIndex(where: { $0.id == step.id }) else {
            return []
        }

        return steps.prefix(currentStepIndex).reduce(into: Set<String>()) { keys, previousStep in
            guard
                let selectedOptionID = selectedOptionIDs[previousStep.id],
                let selectedOption = previousStep.responseOptions.first(where: { $0.id == selectedOptionID })
            else {
                return
            }

            keys.formUnion(Self.replyKeys(for: selectedOption))
        }
    }

    private static func replyKeys(for option: PracticeScenarioResponseOption) -> Set<String> {
        let key = normalizedReplyKey(option.scenarioEnglish)
        if key.isEmpty {
            return []
        }

        return [key]
    }

    private static func normalizedReplyKey(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .trimmingCharacters(in: CharacterSet(charactersIn: ".。!?！？"))
    }
}

struct PracticeScenarioDeckSnapshot: Equatable {
    let scenarios: [PracticeScenario]
    let rankedQueueSources: [PracticeScenarioQueueSource]
    let queueCounts: [PracticeScenarioQueueSource: Int]
    let loadedFallbackScenarioIDs: [PracticeScenarioID]
    let loadedFallbackCandidateCount: Int

    var primaryScenario: PracticeScenario? {
        scenarios.first
    }

    var starterScenario: PracticeScenario? {
        scenarios.first { $0.id == .danangFirstDay } ?? primaryScenario
    }

    var visibleCopy: [String] {
        scenarios.flatMap(\.visibleCopy)
            + rankedQueueSources.flatMap { source in
                [source.title, source.subtitle]
            }
    }
}

enum PracticeScenarioLoadState: Equatable {
    case loading
    case loaded(PracticeScenarioDeckSnapshot)
    case failed(String)

    var snapshot: PracticeScenarioDeckSnapshot? {
        guard case .loaded(let snapshot) = self else {
            return nil
        }

        return snapshot
    }
}
