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

    var playbackAudioKey: String? {
        if let audioKey, AudioAssetManifest.main?.url(for: audioKey) != nil {
            return audioKey
        }

        guard let vietnamese else {
            return nil
        }

        return AudioAssetManifest.main?.audioKey(forExactText: vietnamese)
    }

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
        step: PracticeScenarioStep,
        responseOptions: [PracticeScenarioResponseOption]
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
            responseOptions: responseOptions
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
        let visibleSteps = scenario.visibleSteps(
            through: currentIndex,
            selectedOptionIDs: selectedOptionIDs
        )
        var turns: [PracticeStoryTurn] = []

        for (index, step) in visibleSteps.enumerated() {
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

                if step.hasLocalReply(after: selectedOption) {
                    if revealedReplyStepIDs.contains(step.id) {
                        turns.append(
                            .local(
                                step: step,
                                idSuffix: "reply",
                                vietnamese: step.localReplyLine(after: selectedOption),
                                english: step.localReplyMeaning(after: selectedOption)
                            )
                        )
                    } else {
                        turns.append(.localTyping(step: step))
                    }
                }

            } else if index == visibleSteps.count - 1 {
                turns.append(
                    .choiceSet(
                        step: step,
                        responseOptions: scenario.visibleResponseOptions(
                            for: step,
                            selectedOptionIDs: selectedOptionIDs
                        )
                    )
                )
            }
        }

        return turns
    }
}
