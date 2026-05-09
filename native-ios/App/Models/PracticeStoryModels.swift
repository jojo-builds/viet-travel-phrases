import Foundation

enum PracticeStoryTurnRole: Equatable {
    case scene
    case localSpeaker
    case localTyping
    case travelerReply
    case choiceSet
    case recovery
    case system
}

struct PracticeStoryTurn: Identifiable, Equatable {
    let id: String
    let stepID: String
    let role: PracticeStoryTurnRole
    let text: String?
    let vietnamese: String?
    let english: String?
    let audioKey: String?
    let source: PracticeSourceMetadata?
    let responseOptions: [PracticeScenarioResponseOption]

    static func scene(step: PracticeScenarioStep, index: Int) -> PracticeStoryTurn {
        PracticeStoryTurn(
            id: "\(step.id):scene:\(index)",
            stepID: step.id,
            role: .scene,
            text: step.scene,
            vietnamese: nil,
            english: nil,
            audioKey: nil,
            source: step.source,
            responseOptions: []
        )
    }

    static func local(
        step: PracticeScenarioStep,
        idSuffix: String,
        vietnamese: String,
        english: String
    ) -> PracticeStoryTurn {
        PracticeStoryTurn(
            id: "\(step.id):local:\(idSuffix)",
            stepID: step.id,
            role: .localSpeaker,
            text: nil,
            vietnamese: vietnamese,
            english: english,
            audioKey: AudioAssetManifest.main?.audioKey(forExactText: vietnamese),
            source: step.source,
            responseOptions: []
        )
    }

    static func traveler(
        step: PracticeScenarioStep,
        option: PracticeScenarioResponseOption
    ) -> PracticeStoryTurn {
        PracticeStoryTurn(
            id: "\(step.id):traveler:\(option.id)",
            stepID: step.id,
            role: .travelerReply,
            text: nil,
            vietnamese: option.scenarioVietnamese,
            english: option.scenarioEnglish,
            audioKey: option.audioKey,
            source: option.candidate.source,
            responseOptions: []
        )
    }

    static func localTyping(step: PracticeScenarioStep) -> PracticeStoryTurn {
        PracticeStoryTurn(
            id: "\(step.id):local:typing",
            stepID: step.id,
            role: .localTyping,
            text: nil,
            vietnamese: nil,
            english: nil,
            audioKey: nil,
            source: step.source,
            responseOptions: []
        )
    }

    static func choiceSet(
        step: PracticeScenarioStep
    ) -> PracticeStoryTurn {
        PracticeStoryTurn(
            id: "\(step.id):choices",
            stepID: step.id,
            role: .choiceSet,
            text: step.userGoal,
            vietnamese: nil,
            english: nil,
            audioKey: nil,
            source: step.source,
            responseOptions: Array(step.responseOptions.prefix(3))
        )
    }

    static func recovery(step: PracticeScenarioStep) -> PracticeStoryTurn {
        PracticeStoryTurn(
            id: "\(step.id):recovery",
            stepID: step.id,
            role: .recovery,
            text: step.recovery.body,
            vietnamese: nil,
            english: nil,
            audioKey: step.recovery.candidate?.playableAudioKey,
            source: step.recovery.candidate?.source ?? step.source,
            responseOptions: []
        )
    }
}

enum PracticeStoryTranscript {
    static func turns(
        for scenario: PracticeScenario,
        currentIndex: Int,
        selectedOptionIDs: [String: String],
        revealedReplyStepIDs: Set<String> = []
    ) -> [PracticeStoryTurn] {
        let visibleSteps = Array(scenario.steps.prefix(max(0, currentIndex) + 1))
        var turns: [PracticeStoryTurn] = []

        for (index, step) in visibleSteps.enumerated() {
            turns.append(.scene(step: step, index: index))

            if !step.localLine.isEmpty {
                turns.append(
                    .local(
                        step: step,
                        idSuffix: "prompt",
                        vietnamese: step.localLine,
                        english: step.localLineMeaning
                    )
                )
            }

            let selectedOption = selectedOptionIDs[step.id].flatMap { selectedID in
                step.responseOptions.first { $0.id == selectedID }
            }

            if let selectedOption {
                turns.append(.traveler(step: step, option: selectedOption))

                if !step.nextLocalLine.isEmpty {
                    if revealedReplyStepIDs.contains(step.id) {
                        turns.append(
                            .local(
                                step: step,
                                idSuffix: "reply",
                                vietnamese: step.nextLocalLine,
                                english: step.nextLocalMeaning
                            )
                        )
                    } else {
                        turns.append(.localTyping(step: step))
                    }
                }

            } else if index == currentIndex {
                turns.append(.choiceSet(step: step))
            }
        }

        return turns
    }
}
