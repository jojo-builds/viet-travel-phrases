import Foundation

enum PracticeMode: String, CaseIterable, Codable, Equatable, Identifiable {
    case hcmcCity
    case hanoiBucketList
    case danangCity
    case hoianCity
    case hueCity
    case savedReview
    case missedReview

    var id: String { rawValue }

    static let cityModes: [PracticeMode] = [
        .hcmcCity,
        .hanoiBucketList,
        .danangCity,
        .hoianCity,
        .hueCity,
    ]

    var title: String {
        switch self {
        case .hcmcCity:
            return "Saigon First Loop"
        case .hanoiBucketList:
            return "Hanoi Bucket List"
        case .danangCity:
            return "Da Nang Coast Loop"
        case .hoianCity:
            return "Hoi An Old Town Loop"
        case .hueCity:
            return "Hue Heritage Loop"
        case .savedReview:
            return "Saved Review"
        case .missedReview:
            return "Missed Review"
        }
    }

    var subtitle: String {
        switch self {
        case .hcmcCity:
            return "Short phrases for District 1, markets, cafes, arrivals, and Saigon landmarks."
        case .hanoiBucketList:
            return "Vietnamese-first phrases for your first Hanoi loop."
        case .danangCity:
            return "Beach, bridge, airport, market, and mountain phrases for Da Nang."
        case .hoianCity:
            return "Old Town, beaches, markets, cafes, and route phrases for Hoi An."
        case .hueCity:
            return "Citadel, river, tomb, food, and heritage-route phrases for Hue."
        case .savedReview:
            return "Practice saved pages without mixing them into the bucket list."
        case .missedReview:
            return "Calmly revisit prompts that need another pass."
        }
    }

    var cityID: String? {
        switch self {
        case .hcmcCity:
            return "hcmc"
        case .hanoiBucketList:
            return "hanoi"
        case .danangCity:
            return "danang"
        case .hoianCity:
            return "hoian"
        case .hueCity:
            return "hue"
        case .savedReview, .missedReview:
            return nil
        }
    }

    var cityShortName: String? {
        switch self {
        case .hcmcCity:
            return "Saigon"
        case .hanoiBucketList:
            return "Hanoi"
        case .danangCity:
            return "Da Nang"
        case .hoianCity:
            return "Hoi An"
        case .hueCity:
            return "Hue"
        case .savedReview, .missedReview:
            return nil
        }
    }

    var isCityMode: Bool {
        cityID != nil
    }
}

enum PracticePromptKind: String, CaseIterable, Codable, Equatable {
    case listenAndPick
    case englishToVietnamese
    case vietnameseToEnglish
    case missingToken

    var title: String {
        switch self {
        case .listenAndPick:
            return "Listen and pick"
        case .englishToVietnamese:
            return "English to Vietnamese"
        case .vietnameseToEnglish:
            return "Vietnamese to English"
        case .missingToken:
            return "Missing token"
        }
    }
}

struct PracticeSourceMetadata: Codable, Equatable {
    let phraseID: String
    let pageID: String
    let cityID: String?
    let cityName: String?
    let citySubcategoryID: String?
    let citySubcategoryTitle: String?
    let placeID: String?
    let placeName: String?

    var hasCityMetadata: Bool {
        cityID != nil || citySubcategoryID != nil || placeID != nil
    }

    var cityContextLabel: String? {
        [cityName, citySubcategoryTitle, placeName]
            .compactMap { value in
                guard let value, !value.isEmpty else {
                    return nil
                }

                return value
            }
            .joined(separator: " / ")
            .nilIfEmpty
    }
}

struct PracticeCandidate: Identifiable, Equatable {
    let phraseID: String
    let pageID: String
    let vietnamese: String
    let english: String
    let pronunciation: String
    let categoryIDs: [String]
    let symbolName: String
    let tintName: AccentTint
    let audioKey: String?
    let breakdownTokens: [BreakdownToken]
    let source: PracticeSourceMetadata

    var id: String { pageID }

    var playableAudioKey: String? {
        AudioSpeakerButton.playableAudioKey(audioKey)
            ?? AudioAssetManifest.main?.audioKey(forExactText: vietnamese)
    }
}

struct PracticeAnswerOption: Identifiable, Equatable {
    let id: String
    let text: String
    let subtitle: String
    let isCorrect: Bool
}

struct PracticePrompt: Identifiable, Equatable {
    let id: String
    let mode: PracticeMode
    let kind: PracticePromptKind
    let candidate: PracticeCandidate
    let promptText: String
    let instruction: String
    let answerText: String
    let answerExplanation: String
    let options: [PracticeAnswerOption]
    let audioKey: String?
    let source: PracticeSourceMetadata

    var sourceLabel: String {
        source.cityContextLabel ?? "Source phrase page"
    }
}

enum PracticeAnswerResult: String, Codable, Equatable {
    case correct
    case missed
}

struct PracticePromptProgress: Codable, Equatable {
    let promptID: String
    var seenCount: Int
    var correctCount: Int
    var missedCount: Int
    var lastResult: PracticeAnswerResult?
    var lastAnsweredAt: Date?
    var nextDueAt: Date?
    var isReady: Bool
}

final class LocalPracticeProgressStore: ObservableObject {
    @Published private(set) var progressByPromptID: [String: PracticePromptProgress]

    private let defaults: UserDefaults
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private enum Key {
        static let progress = "SpeakLocal.Practice.progress.v1"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        progressByPromptID = Self.loadProgress(defaults: defaults)
    }

    var missedPromptIDs: Set<String> {
        Set(progressByPromptID.values.compactMap { progress in
            progress.lastResult == .missed ? progress.promptID : nil
        })
    }

    var readyPromptIDs: Set<String> {
        Set(progressByPromptID.values.compactMap { progress in
            progress.isReady ? progress.promptID : nil
        })
    }

    func progress(for promptID: String) -> PracticePromptProgress? {
        progressByPromptID[promptID]
    }

    func record(prompt: PracticePrompt, selectedOption: PracticeAnswerOption, answeredAt: Date = Date()) {
        record(promptID: prompt.id, isCorrect: selectedOption.isCorrect, answeredAt: answeredAt)
    }

    func record(promptID: String, isCorrect: Bool, answeredAt: Date = Date()) {
        var progress = progressByPromptID[promptID] ?? PracticePromptProgress(
            promptID: promptID,
            seenCount: 0,
            correctCount: 0,
            missedCount: 0,
            lastResult: nil,
            lastAnsweredAt: nil,
            nextDueAt: nil,
            isReady: false
        )

        progress.seenCount += 1
        progress.lastAnsweredAt = answeredAt
        progress.lastResult = isCorrect ? .correct : .missed

        if isCorrect {
            progress.correctCount += 1
            progress.nextDueAt = Calendar.current.date(byAdding: .day, value: 1, to: answeredAt)
            progress.isReady = progress.correctCount >= 2
        } else {
            progress.missedCount += 1
            progress.nextDueAt = Calendar.current.date(byAdding: .minute, value: 10, to: answeredAt)
            progress.isReady = false
        }

        progressByPromptID[promptID] = progress
        persist()
    }

    func readyCount(in promptIDs: [String]) -> Int {
        promptIDs.filter { readyPromptIDs.contains($0) }.count
    }

    func missedCount(in promptIDs: [String]) -> Int {
        promptIDs.filter { missedPromptIDs.contains($0) }.count
    }

    private func persist() {
        guard let data = try? encoder.encode(progressByPromptID) else {
            return
        }

        defaults.set(data, forKey: Key.progress)
    }

    private static func loadProgress(defaults: UserDefaults) -> [String: PracticePromptProgress] {
        guard let data = defaults.data(forKey: Key.progress) else {
            return [:]
        }

        return (try? JSONDecoder().decode([String: PracticePromptProgress].self, from: data)) ?? [:]
    }
}

enum PracticePromptGenerator {
    static func prompts(
        mode: PracticeMode,
        candidates: [PracticeCandidate],
        distractors: [PracticeCandidate],
        limit: Int = 8
    ) -> [PracticePrompt] {
        let promptCandidates = uniqueCandidates(candidates)
        let distractorPool = uniqueCandidates(distractors + candidates)
        var generated: [PracticePrompt] = []

        for (index, candidate) in promptCandidates.enumerated() {
            let preferredKinds = rotatedKinds(startingAt: index)
            guard let prompt = preferredKinds.compactMap({ kind in
                makePrompt(
                    mode: mode,
                    kind: kind,
                    candidate: candidate,
                    distractors: distractorPool
                )
            }).first else {
                continue
            }

            generated.append(prompt)

            if generated.count >= limit {
                break
            }
        }

        return generated
    }

    static func promptVariants(
        mode: PracticeMode,
        candidate: PracticeCandidate,
        distractors: [PracticeCandidate]
    ) -> [PracticePrompt] {
        PracticePromptKind.allCases.compactMap { kind in
            makePrompt(mode: mode, kind: kind, candidate: candidate, distractors: distractors)
        }
    }

    static func stablePromptID(
        kind: PracticePromptKind,
        candidate: PracticeCandidate,
        tokenID: String? = nil
    ) -> String {
        [
            "practice",
            kind.rawValue,
            candidate.pageID,
            tokenID ?? "main",
        ].joined(separator: ":")
    }

    private static func makePrompt(
        mode: PracticeMode,
        kind: PracticePromptKind,
        candidate: PracticeCandidate,
        distractors: [PracticeCandidate]
    ) -> PracticePrompt? {
        switch kind {
        case .listenAndPick:
            guard let audioKey = candidate.playableAudioKey else {
                return nil
            }

            return PracticePrompt(
                id: stablePromptID(kind: kind, candidate: candidate),
                mode: mode,
                kind: kind,
                candidate: candidate,
                promptText: "Play the phrase, then pick what you heard.",
                instruction: "Listen for the Vietnamese wording.",
                answerText: candidate.vietnamese,
                answerExplanation: "\(candidate.vietnamese) means \(candidate.english).",
                options: answerOptions(
                    candidate: candidate,
                    distractors: distractors,
                    answerText: candidate.vietnamese,
                    answerSubtitle: candidate.english,
                    optionText: \.vietnamese,
                    optionSubtitle: \.english,
                    seed: stablePromptID(kind: kind, candidate: candidate)
                ),
                audioKey: audioKey,
                source: candidate.source
            )
        case .englishToVietnamese:
            return PracticePrompt(
                id: stablePromptID(kind: kind, candidate: candidate),
                mode: mode,
                kind: kind,
                candidate: candidate,
                promptText: candidate.english,
                instruction: "Pick the Vietnamese phrase.",
                answerText: candidate.vietnamese,
                answerExplanation: "\(candidate.vietnamese) is the phrase for \(candidate.english).",
                options: answerOptions(
                    candidate: candidate,
                    distractors: distractors,
                    answerText: candidate.vietnamese,
                    answerSubtitle: candidate.pronunciation,
                    optionText: \.vietnamese,
                    optionSubtitle: { $0.english },
                    seed: stablePromptID(kind: kind, candidate: candidate)
                ),
                audioKey: nil,
                source: candidate.source
            )
        case .vietnameseToEnglish:
            return PracticePrompt(
                id: stablePromptID(kind: kind, candidate: candidate),
                mode: mode,
                kind: kind,
                candidate: candidate,
                promptText: candidate.vietnamese,
                instruction: "Pick the English meaning.",
                answerText: candidate.english,
                answerExplanation: "\(candidate.vietnamese) means \(candidate.english).",
                options: answerOptions(
                    candidate: candidate,
                    distractors: distractors,
                    answerText: candidate.english,
                    answerSubtitle: meaningOptionSubtitle(for: candidate),
                    optionText: \.english,
                    optionSubtitle: { meaningOptionSubtitle(for: $0) },
                    seed: stablePromptID(kind: kind, candidate: candidate)
                ),
                audioKey: nil,
                source: candidate.source
            )
        case .missingToken:
            let token = missingToken(for: candidate)
            guard !token.text.isEmpty else {
                return nil
            }

            let promptText = candidate.vietnamese.replacingFirstOccurrence(of: token.text, with: "____")
            let promptID = stablePromptID(kind: kind, candidate: candidate, tokenID: token.id)

            return PracticePrompt(
                id: promptID,
                mode: mode,
                kind: kind,
                candidate: candidate,
                promptText: promptText,
                instruction: "Complete the Vietnamese phrase.",
                answerText: token.text,
                answerExplanation: "\(token.text) is the missing part in \(candidate.vietnamese).",
                options: tokenAnswerOptions(
                    token: token,
                    candidate: candidate,
                    distractors: distractors,
                    seed: promptID
                ),
                audioKey: nil,
                source: candidate.source
            )
        }
    }

    private static func answerOptions(
        candidate: PracticeCandidate,
        distractors: [PracticeCandidate],
        answerText: String,
        answerSubtitle: String,
        optionText: KeyPath<PracticeCandidate, String>,
        optionSubtitle: (PracticeCandidate) -> String,
        seed: String
    ) -> [PracticeAnswerOption] {
        let correct = PracticeAnswerOption(
            id: "\(seed):correct",
            text: answerText,
            subtitle: answerSubtitle,
            isCorrect: true
        )

        let wrongOptions = rankedDistractors(for: candidate, in: distractors)
            .filter { $0[keyPath: optionText] != answerText }
            .prefix(6)
            .reduce(into: [PracticeAnswerOption]()) { options, distractor in
                let text = distractor[keyPath: optionText]
                guard !options.contains(where: { $0.text == text }) else {
                    return
                }

                options.append(
                        PracticeAnswerOption(
                            id: "\(seed):\(distractor.pageID)",
                            text: text,
                            subtitle: optionSubtitle(distractor),
                            isCorrect: false
                        )
                )
            }
            .prefix(3)

        return stableOptionOrder([correct] + Array(wrongOptions), seed: seed)
    }

    private static func meaningOptionSubtitle(for candidate: PracticeCandidate) -> String {
        if let cityLabel = candidate.source.cityContextLabel {
            return cityLabel
        }

        if let categoryID = candidate.categoryIDs.first {
            return categoryID
                .split(separator: "-")
                .map { token in
                    token.prefix(1).uppercased() + String(token.dropFirst())
                }
                .joined(separator: " ")
        }

        return "Phrase page"
    }

    private static func tokenAnswerOptions(
        token: PracticeToken,
        candidate: PracticeCandidate,
        distractors: [PracticeCandidate],
        seed: String
    ) -> [PracticeAnswerOption] {
        let correct = PracticeAnswerOption(
            id: "\(seed):correct",
            text: token.text,
            subtitle: token.gloss,
            isCorrect: true
        )

        let wrongOptions = rankedDistractors(for: candidate, in: distractors)
            .flatMap { tokens(for: $0) }
            .filter { $0.text != token.text }
            .prefix(10)
            .reduce(into: [PracticeAnswerOption]()) { options, token in
                guard !options.contains(where: { $0.text == token.text }) else {
                    return
                }

                options.append(
                    PracticeAnswerOption(
                        id: "\(seed):\(token.id)",
                        text: token.text,
                        subtitle: token.gloss,
                        isCorrect: false
                    )
                )
            }
            .prefix(3)

        return stableOptionOrder([correct] + Array(wrongOptions), seed: seed)
    }

    private static func rankedDistractors(
        for candidate: PracticeCandidate,
        in candidates: [PracticeCandidate]
    ) -> [PracticeCandidate] {
        uniqueCandidates(candidates)
            .filter { $0.pageID != candidate.pageID }
            .sorted { lhs, rhs in
                let leftRank = distractorRank(lhs, for: candidate)
                let rightRank = distractorRank(rhs, for: candidate)

                if leftRank != rightRank {
                    return leftRank < rightRank
                }

                return lhs.pageID < rhs.pageID
            }
    }

    private static func distractorRank(_ candidate: PracticeCandidate, for source: PracticeCandidate) -> Int {
        if candidate.source.placeID != nil && candidate.source.placeID == source.source.placeID {
            return 0
        }

        if let sourceCityID = source.source.cityID {
            if candidate.source.cityID == sourceCityID
                && candidate.source.citySubcategoryID != nil
                && candidate.source.citySubcategoryID == source.source.citySubcategoryID {
                return 1
            }

            if candidate.source.cityID == sourceCityID {
                return 2
            }

            if candidate.source.citySubcategoryID != nil
                && candidate.source.citySubcategoryID == source.source.citySubcategoryID {
                return 3
            }

            if !Set(candidate.categoryIDs).isDisjoint(with: Set(source.categoryIDs)) {
                return 4
            }

            return 5
        }

        if candidate.source.citySubcategoryID != nil
            && candidate.source.citySubcategoryID == source.source.citySubcategoryID {
            return 1
        }

        if candidate.source.cityID != nil && candidate.source.cityID == source.source.cityID {
            return 2
        }

        if !Set(candidate.categoryIDs).isDisjoint(with: Set(source.categoryIDs)) {
            return 3
        }

        return 4
    }

    private static func missingToken(for candidate: PracticeCandidate) -> PracticeToken {
        tokens(for: candidate)
            .filter { $0.text.count > 1 }
            .sorted { lhs, rhs in
                if lhs.text.count != rhs.text.count {
                    return lhs.text.count > rhs.text.count
                }

                return lhs.text < rhs.text
            }
            .first ?? PracticeToken(id: "whole", text: candidate.vietnamese, gloss: candidate.english)
    }

    private static func tokens(for candidate: PracticeCandidate) -> [PracticeToken] {
        let breakdownTokens = candidate.breakdownTokens.map { token in
            PracticeToken(id: token.id, text: token.vietnamese, gloss: token.english)
        }

        if !breakdownTokens.isEmpty {
            return breakdownTokens
        }

        return candidate.vietnamese
            .split(separator: " ")
            .enumerated()
            .map { index, value in
                PracticeToken(
                    id: "\(candidate.pageID):token-\(index)",
                    text: String(value),
                    gloss: "Part of the phrase"
                )
            }
    }

    private static func stableOptionOrder(
        _ options: [PracticeAnswerOption],
        seed: String
    ) -> [PracticeAnswerOption] {
        options.sorted { lhs, rhs in
            let leftRank = stableRank("\(seed):\(lhs.text)")
            let rightRank = stableRank("\(seed):\(rhs.text)")

            if leftRank != rightRank {
                return leftRank < rightRank
            }

            return lhs.text < rhs.text
        }
    }

    private static func stableRank(_ value: String) -> Int {
        value.unicodeScalars.reduce(0) { result, scalar in
            ((result * 31) + Int(scalar.value)) % 10_007
        }
    }

    private static func rotatedKinds(startingAt index: Int) -> [PracticePromptKind] {
        let kinds = PracticePromptKind.allCases
        let start = index % kinds.count
        return Array(kinds[start...]) + Array(kinds[..<start])
    }

    private static func uniqueCandidates(_ candidates: [PracticeCandidate]) -> [PracticeCandidate] {
        var seenPageIDs = Set<String>()

        return candidates.filter { candidate in
            seenPageIDs.insert(candidate.pageID).inserted
        }
    }
}

private struct PracticeToken: Equatable {
    let id: String
    let text: String
    let gloss: String
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }

    func replacingFirstOccurrence(of target: String, with replacement: String) -> String {
        guard let range = range(of: target) else {
            return self
        }

        return replacingCharacters(in: range, with: replacement)
    }
}
