import Foundation

enum PracticeScenarioID: String, CaseIterable, Codable, Equatable, Identifiable {
    case danangFirstDay
    case danangDay
    case taxiGrabPickup
    case restaurantOrderingPayment
    case hotelCheckInHelp

    var id: String { rawValue }

    var title: String {
        switch self {
        case .danangFirstDay:
            return "First day in Da Nang"
        case .danangDay:
            return "Da Nang day"
        case .taxiGrabPickup:
            return "Taxi / Grab pickup"
        case .restaurantOrderingPayment:
            return "Restaurant ordering"
        case .hotelCheckInHelp:
            return "At the hotel"
        }
    }

    var shortTitle: String {
        switch self {
        case .danangFirstDay:
            return "First day"
        case .danangDay:
            return "Da Nang"
        case .taxiGrabPickup:
            return "Taxi"
        case .restaurantOrderingPayment:
            return "Restaurant"
        case .hotelCheckInHelp:
            return "Hotel"
        }
    }

    var symbolName: String {
        switch self {
        case .danangFirstDay:
            return "airplane.arrival"
        case .danangDay:
            return "sun.max.fill"
        case .taxiGrabPickup:
            return "car.fill"
        case .restaurantOrderingPayment:
            return "fork.knife"
        case .hotelCheckInHelp:
            return "bed.double.fill"
        }
    }

    var tint: AccentTint {
        switch self {
        case .danangFirstDay:
            return .blue
        case .danangDay:
            return .teal
        case .taxiGrabPickup:
            return .orange
        case .restaurantOrderingPayment:
            return .green
        case .hotelCheckInHelp:
            return .purple
        }
    }

    var categoryIDs: [String] {
        switch self {
        case .danangFirstDay:
            return ["airport-border-arrival", "transport", "hotel-accommodation", "food-drink"]
        case .danangDay:
            return ["directions-navigation", "food-drink", "bathroom-personal-needs", "transport"]
        case .taxiGrabPickup:
            return ["transport", "directions-navigation"]
        case .restaurantOrderingPayment:
            return ["food-drink", "money-numbers-prices"]
        case .hotelCheckInHelp:
            return ["hotel-accommodation", "problems-help"]
        }
    }

    var flowBeats: [String] {
        switch self {
        case .danangFirstDay:
            return ["Airport", "Ride", "Hotel", "Food"]
        case .danangDay:
            return ["Beach", "Food", "Photo", "Ride back"]
        case .taxiGrabPickup:
            return ["Confirm car", "Find pickup", "If unsure"]
        case .restaurantOrderingPayment:
            return ["Table", "Menu", "Order", "Pay"]
        case .hotelCheckInHelp:
            return ["Booking", "Passport", "Wi-Fi", "Room help"]
        }
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
            return "Practical travel moments to start with."
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
            ?? (scenarioCopy == nil ? candidate.playableAudioKey : nil)
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

    var visibleCopy: [String] {
        var copy = [
            scene,
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
            ]
        }
        if momentType == .listen {
            copy.append(localPhrase.scenarioVietnamese)
            copy.append(localPhrase.scenarioEnglish)
        }
        return copy
    }
}

struct PracticeScenario: Identifiable, Equatable {
    let id: PracticeScenarioID
    let queueSource: PracticeScenarioQueueSource
    let sceneTitle: String
    let sceneSetup: String
    let steps: [PracticeScenarioStep]

    var title: String { id.title }

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

    var visibleCopy: [String] {
        [sceneTitle, sceneSetup, queueSource.title, queueSource.subtitle]
            + steps.flatMap(\.visibleCopy)
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
