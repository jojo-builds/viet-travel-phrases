import Foundation

enum PracticeScenarioBuilder {
    private static let personalCandidateLimit = 12
    private static let fallbackCandidateLimit = 420

    static func loadSnapshot(
        practicePageIDs: [String],
        savedPageIDs: [String],
        recentPageIDs: [String],
        progressStore: LocalPracticeProgressStore
    ) throws -> PracticeScenarioDeckSnapshot {
        try loadSnapshot(
            practicePageIDs: practicePageIDs,
            savedPageIDs: savedPageIDs,
            recentPageIDs: recentPageIDs,
            missedPromptIDs: progressStore.missedPromptIDs
        )
    }

    static func loadSnapshot(
        practicePageIDs: [String],
        savedPageIDs: [String],
        recentPageIDs: [String],
        missedPromptIDs: Set<String>
    ) throws -> PracticeScenarioDeckSnapshot {
        let request = PracticeScenarioDeckRequest(
            practicePageIDs: practicePageIDs,
            savedPageIDs: savedPageIDs,
            recentPageIDs: recentPageIDs,
            missedPromptIDs: missedPromptIDs.sorted()
        )

        if let cached = PracticeScenarioSnapshotCache.snapshot(for: request) {
            return cached
        }

        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let snapshot = try loadSnapshot(request: request, repository: repository)
        PracticeScenarioSnapshotCache.store(snapshot, for: request)
        return snapshot
    }

    static func prewarm(
        practicePageIDs: [String],
        savedPageIDs: [String],
        recentPageIDs: [String],
        progressStore: LocalPracticeProgressStore
    ) {
        prewarm(
            practicePageIDs: practicePageIDs,
            savedPageIDs: savedPageIDs,
            recentPageIDs: recentPageIDs,
            missedPromptIDs: progressStore.missedPromptIDs
        )
    }

    static func prewarm(
        practicePageIDs: [String],
        savedPageIDs: [String],
        recentPageIDs: [String],
        missedPromptIDs: Set<String>
    ) {
        let request = PracticeScenarioDeckRequest(
            practicePageIDs: practicePageIDs,
            savedPageIDs: savedPageIDs,
            recentPageIDs: recentPageIDs,
            missedPromptIDs: missedPromptIDs.sorted()
        )

        guard PracticeScenarioSnapshotCache.beginLoading(request) else {
            return
        }

        DispatchQueue.global(qos: .utility).async {
            do {
                let repository = try VietSQLiteLanguagePackRepository.bundled()
                let snapshot = try loadSnapshot(request: request, repository: repository)
                PracticeScenarioSnapshotCache.store(snapshot, for: request)
            } catch {
                PracticeScenarioSnapshotCache.finishLoading(request)
            }
        }
    }

    static func stableProgressID(step: PracticeScenarioStep) -> String {
        stableProgressID(
            scenarioID: step.scenarioID,
            stepID: step.id,
            candidatePageID: step.bestResponse?.candidate.pageID ?? step.source.pageID
        )
    }

    static func stableProgressID(
        scenarioID: PracticeScenarioID,
        stepID: String,
        candidatePageID: String
    ) -> String {
        [
            "scenario",
            scenarioID.rawValue,
            stepID,
            candidatePageID,
        ].joined(separator: ":")
    }

    private static func loadSnapshot(
        request: PracticeScenarioDeckRequest,
        repository: VietSQLiteLanguagePackRepository
    ) throws -> PracticeScenarioDeckSnapshot {
        let missedPageIDs = uniquePageIDs(request.missedPromptIDs.compactMap(pageIDFromProgressID))
        let addedPageIDs = uniquePageIDs(request.practicePageIDs)
        let savedRecentPageIDs = uniquePageIDs(request.savedPageIDs + request.recentPageIDs)
            .filter { !Set(addedPageIDs).contains($0) }

        let missedCandidates = try repository.loadPracticeCandidates(
            pageIDs: Array(missedPageIDs.prefix(personalCandidateLimit)),
            limit: personalCandidateLimit
        )
        let addedCandidates = try repository.loadPracticeCandidates(
            pageIDs: Array(addedPageIDs.prefix(personalCandidateLimit)),
            limit: personalCandidateLimit
        )
        let savedRecentCandidates = try repository.loadPracticeCandidates(
            pageIDs: Array(savedRecentPageIDs.prefix(personalCandidateLimit)),
            limit: personalCandidateLimit
        )
        let fallbackCandidates = try repository.loadPracticeCandidates(
            pageIDs: Array(Self.requiredFallbackPageIDs.prefix(fallbackCandidateLimit)),
            limit: fallbackCandidateLimit
        )

        let candidatesBySource: [PracticeScenarioQueueSource: [PracticeCandidate]] = [
            .missedReview: missedCandidates,
            .addedPractice: addedCandidates,
            .savedRecent: savedRecentCandidates,
            .tripFallback: fallbackCandidates,
        ]
        let queueCounts = candidatesBySource.mapValues(\.count)
        let rankedSources = rankedQueueSources(counts: queueCounts)
        let canonicalPageIDsByTemplateID = canonicalPageIDMap(
            pageIDs: uniquePageIDs(scenarioTemplates.flatMap(\.requiredPageIDs)),
            repository: repository
        )
        let scenarios = scenarioTemplates.compactMap { template in
            makeScenario(
                template: template,
                candidatesBySource: candidatesBySource,
                rankedSources: rankedSources,
                canonicalPageIDsByTemplateID: canonicalPageIDsByTemplateID
            )
        }
        .sorted { lhs, rhs in
            if lhs.queueSource.sortRank != rhs.queueSource.sortRank {
                return lhs.queueSource.sortRank < rhs.queueSource.sortRank
            }

            return scenarioTemplates.firstIndex { $0.id == lhs.id } ?? 0
                < scenarioTemplates.firstIndex { $0.id == rhs.id } ?? 0
        }

        return PracticeScenarioDeckSnapshot(
            scenarios: scenarios,
            rankedQueueSources: rankedSources,
            queueCounts: queueCounts,
            loadedFallbackScenarioIDs: scenarioTemplates.map(\.id),
            loadedFallbackCandidateCount: fallbackCandidates.count
        )
    }

    private static func makeScenario(
        template: PracticeScenarioTemplate,
        candidatesBySource: [PracticeScenarioQueueSource: [PracticeCandidate]],
        rankedSources: [PracticeScenarioQueueSource],
        canonicalPageIDsByTemplateID: [String: String]
    ) -> PracticeScenario? {
        let source = rankedSources.first { source in
            source != .tripFallback
                && containsCandidateForScenario(
                    candidatesBySource[source] ?? [],
                    template: template,
                    canonicalPageIDsByTemplateID: canonicalPageIDsByTemplateID
                )
        } ?? .tripFallback

        let fallbackCandidates = candidatesBySource[.tripFallback] ?? []
        let sourceCandidates = candidatesBySource[source] ?? []
        let candidates = uniqueCandidates(sourceCandidates + fallbackCandidates)
        let steps = template.steps.compactMap { stepTemplate in
            makeStep(
                template: stepTemplate,
                scenarioID: template.id,
                queueSource: source,
                candidates: candidates,
                sourceCandidates: sourceCandidates,
                canonicalPageIDsByTemplateID: canonicalPageIDsByTemplateID
            )
        }

        guard !steps.isEmpty else {
            return nil
        }

        return PracticeScenario(
            id: template.id,
            queueSource: source,
            sceneTitle: template.sceneTitle,
            sceneSetup: template.sceneSetup,
            steps: steps
        )
    }

    private static func makeStep(
        template: PracticeScenarioStepTemplate,
        scenarioID: PracticeScenarioID,
        queueSource: PracticeScenarioQueueSource,
        candidates: [PracticeCandidate],
        sourceCandidates: [PracticeCandidate],
        canonicalPageIDsByTemplateID: [String: String]
    ) -> PracticeScenarioStep? {
        let bestCandidate = firstCandidate(
            pageIDs: template.bestPageIDs,
            in: uniqueCandidates(sourceCandidates + candidates),
            canonicalPageIDsByTemplateID: canonicalPageIDsByTemplateID
        )
        guard let bestCandidate else {
            return nil
        }

        let alternatePageIDs = uniquePageIDs(template.alternatePageIDs + Array(template.bestPageIDs.dropFirst()))
        let alternateCandidates = uniqueCandidates(
            alternatePageIDs.compactMap { pageID in
                firstCandidate(
                    pageIDs: [pageID],
                    in: candidates,
                    canonicalPageIDsByTemplateID: canonicalPageIDsByTemplateID
                )
            }
        )
            .filter { $0.pageID != bestCandidate.pageID }
        let options = ([bestCandidate] + alternateCandidates.prefix(template.alternateLimit))
            .enumerated()
            .map { index, candidate in
                responseOption(
                    candidate: candidate,
                    bestCandidate: bestCandidate,
                    template: template,
                    index: index,
                    canonicalPageIDsByTemplateID: canonicalPageIDsByTemplateID
                )
            }

        guard options.count >= 2 else {
            return nil
        }

        let recoveryCandidate = firstCandidate(
            pageIDs: template.recoveryPageIDs,
            in: candidates,
            canonicalPageIDsByTemplateID: canonicalPageIDsByTemplateID
        )

        return PracticeScenarioStep(
            id: template.id,
            scenarioID: scenarioID,
            queueSource: queueSource,
            momentType: template.momentType,
            scene: template.scene,
            localPhrase: template.localPhraseCopy,
            localLine: template.localLine,
            localLineMeaning: template.localLineMeaning,
            userGoal: template.userGoal,
            responseOptions: Array(options),
            nextLocalLine: template.nextLocalLine,
            nextLocalMeaning: template.nextLocalMeaning,
            recovery: PracticeScenarioRecovery(
                title: template.recoveryTitle,
                body: template.recoveryBody,
                candidate: recoveryCandidate
            ),
            nextStepTitle: template.nextStepTitle,
            source: bestCandidate.source
        )
    }

    private static func responseOption(
        candidate: PracticeCandidate,
        bestCandidate: PracticeCandidate,
        template: PracticeScenarioStepTemplate,
        index: Int,
        canonicalPageIDsByTemplateID: [String: String]
    ) -> PracticeScenarioResponseOption {
        let isBestFit = candidate.pageID == bestCandidate.pageID
        let scenarioCopy = template.scenarioCopy(
            for: candidate,
            isBestFit: isBestFit,
            canonicalPageIDsByTemplateID: canonicalPageIDsByTemplateID
        )
        return PracticeScenarioResponseOption(
            id: "\(template.id):\(candidate.pageID):\(index)",
            candidate: candidate,
            isBestFit: isBestFit,
            scenarioCopy: scenarioCopy,
            nextLocalLine: template.nextLocalLine(
                for: candidate,
                canonicalPageIDsByTemplateID: canonicalPageIDsByTemplateID
            ),
            nextLocalMeaning: template.nextLocalMeaning(
                for: candidate,
                canonicalPageIDsByTemplateID: canonicalPageIDsByTemplateID
            ),
            feedbackTitle: isBestFit ? "Best quick reply" : "Useful later",
            feedbackBody: isBestFit
                ? template.bestFitFeedback(candidate)
                : template.alternateFeedback(candidate, bestCandidate)
        )
    }

    private static func rankedQueueSources(
        counts: [PracticeScenarioQueueSource: Int]
    ) -> [PracticeScenarioQueueSource] {
        let activePersonalSources = PracticeScenarioQueueSource.allCases
            .filter { $0 != .tripFallback }
            .filter { counts[$0, default: 0] > 0 }
            .sorted { $0.sortRank < $1.sortRank }

        return activePersonalSources + [.tripFallback]
    }

    private static func containsCandidateForScenario(
        _ candidates: [PracticeCandidate],
        template: PracticeScenarioTemplate,
        canonicalPageIDsByTemplateID: [String: String]
    ) -> Bool {
        let requiredPageIDs = Set(template.requiredPageIDs.map {
            canonicalPageIDsByTemplateID[$0] ?? $0
        })
        return candidates.contains { candidate in
            requiredPageIDs.contains(candidate.pageID)
                || !Set(candidate.categoryIDs).isDisjoint(with: Set(template.id.categoryIDs))
        }
    }

    private static func firstCandidate(
        pageIDs: [String],
        in candidates: [PracticeCandidate],
        canonicalPageIDsByTemplateID: [String: String]
    ) -> PracticeCandidate? {
        for pageID in pageIDs {
            let canonicalPageID = canonicalPageIDsByTemplateID[pageID] ?? pageID
            if let candidate = candidates.first(where: { candidate in
                candidate.pageID == pageID || candidate.pageID == canonicalPageID
            }) {
                return candidate
            }
        }

        return nil
    }

    private static func canonicalPageIDMap(
        pageIDs: [String],
        repository: VietSQLiteLanguagePackRepository
    ) -> [String: String] {
        Dictionary(uniqueKeysWithValues: pageIDs.map { pageID in
            let canonicalPageID = (try? repository.canonicalPageID(forPageIDOrAlias: pageID)) ?? pageID
            return (pageID, canonicalPageID)
        })
    }

    private static func uniqueCandidates(_ candidates: [PracticeCandidate]) -> [PracticeCandidate] {
        var seenPageIDs = Set<String>()

        return candidates.filter { candidate in
            seenPageIDs.insert(candidate.pageID).inserted
        }
    }

    private static func uniquePageIDs(_ pageIDs: [String]) -> [String] {
        var seenPageIDs = Set<String>()

        return pageIDs.filter { pageID in
            seenPageIDs.insert(pageID).inserted
        }
    }

    private static func pageIDFromProgressID(_ progressID: String) -> String? {
        let parts = progressID.split(separator: ":", omittingEmptySubsequences: false).map(String.init)
        if parts.count >= 4, parts[0] == "practice" {
            return parts[2]
        }

        if parts.count >= 4, parts[0] == "scenario" {
            return parts[3]
        }

        return nil
    }

    private static var requiredFallbackPageIDs: [String] {
        uniquePageIDs(scenarioTemplates.flatMap(\.requiredPageIDs))
    }
}

private struct PracticeScenarioDeckRequest: Hashable {
    let practicePageIDs: [String]
    let savedPageIDs: [String]
    let recentPageIDs: [String]
    let missedPromptIDs: [String]
}

private enum PracticeScenarioSnapshotCache {
    private static let snapshotLimit = 6
    private static var snapshots: [PracticeScenarioDeckRequest: PracticeScenarioDeckSnapshot] = [:]
    private static var inFlightRequests = Set<PracticeScenarioDeckRequest>()
    private static let lock = NSLock()

    static func snapshot(for request: PracticeScenarioDeckRequest) -> PracticeScenarioDeckSnapshot? {
        lock.lock()
        defer { lock.unlock() }
        return snapshots[request]
    }

    static func beginLoading(_ request: PracticeScenarioDeckRequest) -> Bool {
        lock.lock()
        defer { lock.unlock() }

        if snapshots[request] != nil || inFlightRequests.contains(request) {
            return false
        }

        inFlightRequests.insert(request)
        return true
    }

    static func store(_ snapshot: PracticeScenarioDeckSnapshot, for request: PracticeScenarioDeckRequest) {
        lock.lock()
        defer { lock.unlock() }

        snapshots[request] = snapshot
        inFlightRequests.remove(request)

        if snapshots.count > snapshotLimit,
           let evictableRequest = snapshots.keys.first(where: { $0 != request }) {
            snapshots.removeValue(forKey: evictableRequest)
        }
    }

    static func finishLoading(_ request: PracticeScenarioDeckRequest) {
        lock.lock()
        defer { lock.unlock() }

        inFlightRequests.remove(request)
    }
}

private struct PracticeScenarioTemplate {
    let id: PracticeScenarioID
    let sceneTitle: String
    let sceneSetup: String
    let steps: [PracticeScenarioStepTemplate]

    var requiredPageIDs: [String] {
        steps.flatMap { step in
            step.bestPageIDs + step.alternatePageIDs + step.recoveryPageIDs
        }
    }
}

private struct PracticeScenarioStepTemplate {
    let id: String
    var momentType: PracticeScenarioMomentType = .listen
    let scene: String
    let localLine: String
    let localLineMeaning: String
    let userGoal: String
    let bestPageIDs: [String]
    let alternatePageIDs: [String]
    var alternateLimit = 2
    let recoveryPageIDs: [String]
    let nextLocalLine: String
    let nextLocalMeaning: String
    let recoveryTitle: String
    let recoveryBody: String
    let nextStepTitle: String
    var localScenarioContext = "you_hear"
    var scenarioResponseCopies: [String: PracticeScenarioPhraseTemplate] = [:]

    var localPhraseCopy: PracticeScenarioPhraseCopy {
        PracticeScenarioPhraseCopy(
            scenarioVietnamese: localLine,
            scenarioEnglish: localLineMeaning,
            scenarioRole: .youHear,
            scenarioContext: localScenarioContext,
            sourcePhraseID: nil
        )
    }

    func scenarioCopy(
        for candidate: PracticeCandidate,
        isBestFit: Bool,
        canonicalPageIDsByTemplateID: [String: String]
    ) -> PracticeScenarioPhraseCopy? {
        let copy = scenarioPhraseTemplate(
            for: candidate,
            canonicalPageIDsByTemplateID: canonicalPageIDsByTemplateID
        )
        let role: PracticeScenarioPhraseRole = isBestFit ? .bestQuickReply : .moreReply

        guard let copy else {
            return PracticeScenarioPhraseCopy(
                scenarioVietnamese: candidate.vietnamese,
                scenarioEnglish: candidate.english,
                scenarioRole: role,
                scenarioContext: id,
                sourcePhraseID: candidate.phraseID
            )
        }

        guard hasExactBundledAudio(for: copy.vietnamese)
            || !hasExactBundledAudio(for: candidate.vietnamese) else {
            return PracticeScenarioPhraseCopy(
                scenarioVietnamese: candidate.vietnamese,
                scenarioEnglish: candidate.english,
                scenarioRole: copy.role ?? role,
                scenarioContext: copy.context ?? id,
                sourcePhraseID: candidate.phraseID
            )
        }

        return PracticeScenarioPhraseCopy(
            scenarioVietnamese: copy.vietnamese,
            scenarioEnglish: copy.english,
            scenarioRole: copy.role ?? role,
            scenarioContext: copy.context ?? id,
            sourcePhraseID: candidate.phraseID
        )
    }

    func nextLocalLine(
        for candidate: PracticeCandidate,
        canonicalPageIDsByTemplateID: [String: String]
    ) -> String? {
        scenarioPhraseTemplate(
            for: candidate,
            canonicalPageIDsByTemplateID: canonicalPageIDsByTemplateID
        )?.nextLocalLine
    }

    func nextLocalMeaning(
        for candidate: PracticeCandidate,
        canonicalPageIDsByTemplateID: [String: String]
    ) -> String? {
        scenarioPhraseTemplate(
            for: candidate,
            canonicalPageIDsByTemplateID: canonicalPageIDsByTemplateID
        )?.nextLocalMeaning
    }

    private func scenarioPhraseTemplate(
        for candidate: PracticeCandidate,
        canonicalPageIDsByTemplateID: [String: String]
    ) -> PracticeScenarioPhraseTemplate? {
        scenarioResponseCopies[candidate.pageID] ?? scenarioResponseCopies.first { templatePageID, _ in
            (canonicalPageIDsByTemplateID[templatePageID] ?? templatePageID) == candidate.pageID
        }?.value
    }

    private func hasExactBundledAudio(for vietnamese: String) -> Bool {
        AudioAssetManifest.main?.audioKey(forExactText: vietnamese) != nil
    }

    func bestFitFeedback(_ candidate: PracticeCandidate) -> String {
        "\(candidate.vietnamese) keeps this exchange short and clear."
    }

    func alternateFeedback(_ candidate: PracticeCandidate, _ bestCandidate: PracticeCandidate) -> String {
        "\(candidate.vietnamese) may help later. This exchange starts with \(bestCandidate.vietnamese)."
    }
}

private struct PracticeScenarioPhraseTemplate {
    let vietnamese: String
    let english: String
    var role: PracticeScenarioPhraseRole?
    var context: String?
    var nextLocalLine: String?
    var nextLocalMeaning: String?
}

private struct MessageReplySpec {
    let pageID: String
    let vietnamese: String
    let english: String
    let nextLocalLine: String
    let nextLocalMeaning: String
}

private func messageReply(
    _ pageID: String,
    vietnamese: String,
    english: String,
    nextLocalLine: String,
    nextLocalMeaning: String
) -> MessageReplySpec {
    MessageReplySpec(
        pageID: pageID,
        vietnamese: vietnamese,
        english: english,
        nextLocalLine: nextLocalLine,
        nextLocalMeaning: nextLocalMeaning
    )
}

private func messageScenarioStep(
    id: String,
    momentType: PracticeScenarioMomentType = .ask,
    scene: String,
    localLine: String,
    localLineMeaning: String,
    userGoal: String,
    best: MessageReplySpec,
    alternates: [MessageReplySpec],
    recoveryPageIDs: [String] = [
        "viet-family-v500-prob-help-can-you-help-me",
        "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way",
    ],
    recoveryTitle: String = "If you need a simpler path",
    recoveryBody: String = "Use one short phrase, then wait for the local person to reply before adding more detail.",
    nextStepTitle: String,
    localScenarioContext: String
) -> PracticeScenarioStepTemplate {
    let responseCopies = Dictionary(
        uniqueKeysWithValues: ([best] + alternates).map { reply in
            (
                reply.pageID,
                PracticeScenarioPhraseTemplate(
                    vietnamese: reply.vietnamese,
                    english: reply.english,
                    nextLocalLine: reply.nextLocalLine,
                    nextLocalMeaning: reply.nextLocalMeaning
                )
            )
        }
    )

    return PracticeScenarioStepTemplate(
        id: id,
        momentType: momentType,
        scene: scene,
        localLine: localLine,
        localLineMeaning: localLineMeaning,
        userGoal: userGoal,
        bestPageIDs: [best.pageID],
        alternatePageIDs: alternates.map(\.pageID),
        recoveryPageIDs: recoveryPageIDs,
        nextLocalLine: best.nextLocalLine,
        nextLocalMeaning: best.nextLocalMeaning,
        recoveryTitle: recoveryTitle,
        recoveryBody: recoveryBody,
        nextStepTitle: nextStepTitle,
        localScenarioContext: localScenarioContext,
        scenarioResponseCopies: responseCopies
    )
}

private func messageGoodbyeStep(
    id: String,
    scene: String,
    localLine: String,
    localLineMeaning: String,
    userGoal: String = "Close the conversation politely.",
    nextLocalLine: String = "Tạm biệt",
    nextLocalMeaning: String = "Goodbye.",
    recoveryTitle: String = "If you only remember one thing",
    recoveryBody: String = "Use a short goodbye or polite acknowledgment, then let the conversation end.",
    goodbyeNextLocalLine: String? = nil,
    goodbyeNextLocalMeaning: String? = nil,
    localScenarioContext: String
) -> PracticeScenarioStepTemplate {
    let politeCloseLine = goodbyeNextLocalLine ?? "Tạm biệt nhé."
    let politeCloseMeaning = goodbyeNextLocalMeaning ?? "Goodbye."

    return PracticeScenarioStepTemplate(
        id: id,
        momentType: .ask,
        scene: scene,
        localLine: localLine,
        localLineMeaning: localLineMeaning,
        userGoal: userGoal,
        bestPageIDs: [
            "viet-goodbye",
        ],
        alternatePageIDs: [
            "viet-family-polite-acknowledge",
        ],
        recoveryPageIDs: [
            "viet-goodbye",
            "viet-family-polite-acknowledge",
        ],
        nextLocalLine: nextLocalLine,
        nextLocalMeaning: nextLocalMeaning,
        recoveryTitle: recoveryTitle,
        recoveryBody: recoveryBody,
        nextStepTitle: "Finish story",
        localScenarioContext: localScenarioContext,
        scenarioResponseCopies: [
            "viet-goodbye": PracticeScenarioPhraseTemplate(
                vietnamese: "Tạm biệt",
                english: "Goodbye",
                nextLocalLine: politeCloseLine,
                nextLocalMeaning: politeCloseMeaning
            ),
            "viet-family-polite-acknowledge": PracticeScenarioPhraseTemplate(
                vietnamese: "Dạ",
                english: "Okay",
                nextLocalLine: politeCloseLine,
                nextLocalMeaning: politeCloseMeaning
            ),
        ]
    )
}

private let scenarioTemplates: [PracticeScenarioTemplate] = ([
    PracticeScenarioTemplate(
        id: .danangFirstDay,
        sceneTitle: "Airport arrival help",
        sceneSetup: "Ask airport staff for baggage, pickup, driver help, water, and a polite close.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "airport-story-opening",
                momentType: .ask,
                scene: "You have just landed in Da Nang and need one clear first step.",
                localLine: "Xin chào, tôi có thể giúp gì cho bạn?",
                localLineMeaning: "Hello, how can I help you?",
                userGoal: "Ask for baggage claim first.",
                bestPageIDs: [
                    "viet-family-airport-baggage",
                ],
                alternatePageIDs: [
                    "viet-family-v500-airp-bord-arri-i-need-to-report-lost-luggage",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-phrase-help-1",
                ],
                nextLocalLine: "Khu lấy hành lý ở tầng dưới.",
                nextLocalMeaning: "Baggage claim is downstairs.",
                recoveryTitle: "If the signs are unclear",
                recoveryBody: "Show your baggage tag or point at the baggage symbol.",
                nextStepTitle: "Find the right belt",
                localScenarioContext: "airport_story_opening",
                scenarioResponseCopies: [
                    "viet-family-airport-baggage": PracticeScenarioPhraseTemplate(
                        vietnamese: "Lấy hành lý ở đâu?",
                        english: "Where is baggage claim?"
                    ),
                    "viet-family-v500-airp-bord-arri-i-need-to-report-lost-luggage": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi cần báo cáo hành lý thất lạc",
                        english: "I need to report lost luggage",
                        nextLocalLine: "Tôi hiểu, khu hành lý thất lạc ở bên trái.",
                        nextLocalMeaning: "I understand. The lost-luggage counter is on the left."
                    ),
                    "viet-phrase-v500-prob-help-can-you-help-me": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn giúp tôi được không?",
                        english: "Can you help me?",
                        nextLocalLine: "Được. Bạn cần tìm hành lý hay điểm đón xe?",
                        nextLocalMeaning: "Yes. Do you need baggage claim or the pickup point?"
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "airport-story-baggage-belt",
                momentType: .ask,
                scene: "At baggage claim, you want to confirm the belt before waiting.",
                localLine: "Cho tôi xem thẻ hành lý của bạn được không?",
                localLineMeaning: "Can I see your baggage tag?",
                userGoal: "Show your baggage tag and ask where to wait.",
                bestPageIDs: [
                    "viet-family-v500-airp-bord-arri-this-is-my-baggage-tag",
                    "viet-family-airport-baggage",
                ],
                alternatePageIDs: [
                    "viet-family-v500-airp-bord-arri-i-need-to-report-lost-luggage",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-family-airport-baggage",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-phrase-help-1",
                ],
                nextLocalLine: "Băng chuyền số 4 ở bên trái.",
                nextLocalMeaning: "Belt 4 is on the left.",
                recoveryTitle: "If the belt changes",
                recoveryBody: "Show your flight number and keep the baggage phrase ready.",
                nextStepTitle: "Ask for the pickup area",
                localScenarioContext: "airport_story_baggage_belt",
                scenarioResponseCopies: [
                    "viet-family-v500-airp-bord-arri-this-is-my-baggage-tag": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đây là thẻ hành lý của tôi",
                        english: "Here is my baggage tag"
                    ),
                    "viet-family-v500-airp-bord-arri-i-need-to-report-lost-luggage": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi cần báo cáo hành lý thất lạc",
                        english: "I need to report lost luggage",
                        nextLocalLine: "Được, cho tôi xem thẻ hành lý nhé.",
                        nextLocalMeaning: "Yes, show me your baggage tag."
                    ),
                    "viet-family-airport-baggage": PracticeScenarioPhraseTemplate(
                        vietnamese: "Lấy hành lý ở đâu?",
                        english: "Where is baggage claim?",
                        nextLocalLine: "Cho tôi xem thẻ hành lý trước, rồi tôi chỉ đúng băng chuyền.",
                        nextLocalMeaning: "Show me your baggage tag first, then I'll point you to the right belt."
                    ),
                    "viet-phrase-v500-prob-help-can-you-help-me": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn giúp tôi được không?",
                        english: "Can you help me?",
                        nextLocalLine: "Được, cho tôi xem thẻ hành lý nhé.",
                        nextLocalMeaning: "Yes, show me your baggage tag."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "airport-story-pickup-area",
                momentType: .ask,
                scene: "You have your bag and need the ride-hailing pickup area.",
                localLine: "Bạn cần tìm cửa ra hay điểm đón xe?",
                localLineMeaning: "Do you need the exit or pickup point?",
                userGoal: "Ask where the Grab or pickup point is.",
                bestPageIDs: [
                    "viet-phrase-v900-airp-bord-arri-where-is-the-grab-pickup-point",
                    "viet-family-airport-pickup",
                ],
                alternatePageIDs: [
                    "viet-family-v500-airp-bord-arri-where-do-i-meet-the-driver",
                    "viet-phrase-directions-8",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-family-airport-pickup",
                ],
                nextLocalLine: "Đi thẳng ra cửa số 3 nhé.",
                nextLocalMeaning: "Go straight to Gate 3.",
                recoveryTitle: "If the pickup point is busy",
                recoveryBody: "Ask them to point to the gate number, then show your ride screen.",
                nextStepTitle: "Call the driver",
                localScenarioContext: "airport_story_pickup_area",
                scenarioResponseCopies: [
                    "viet-phrase-v900-airp-bord-arri-where-is-the-grab-pickup-point": PracticeScenarioPhraseTemplate(
                        vietnamese: "Điểm đón Grab ở đâu?",
                        english: "Where is the Grab pickup point?"
                    ),
                    "viet-family-v500-airp-bord-arri-where-do-i-meet-the-driver": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi gặp tài xế ở đâu?",
                        english: "Where do I meet the driver?",
                        nextLocalLine: "Bạn gặp tài xế ở cửa số 3.",
                        nextLocalMeaning: "Meet the driver at Gate 3."
                    ),
                    "viet-phrase-directions-8": PracticeScenarioPhraseTemplate(
                        vietnamese: "Điểm đón ở đâu?",
                        english: "Where is the pickup point?",
                        nextLocalLine: "Điểm đón ở cửa số 3, đi thẳng nhé.",
                        nextLocalMeaning: "The pickup point is at Gate 3. Go straight."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "airport-story-call-driver",
                momentType: .ask,
                scene: "You are near the pickup area, but your driver has not found you yet.",
                localLine: "Bạn có tài xế đang chờ chưa?",
                localLineMeaning: "Do you have a driver waiting?",
                userGoal: "Ask airport staff to call or contact the driver.",
                bestPageIDs: [
                    "viet-family-v900-airp-bord-arri-please-call-this-driver-for-me",
                    "viet-phrase-v500-tran-please-call-the-driver",
                ],
                alternatePageIDs: [
                    "viet-family-v500-tran-please-call-the-driver",
                    "viet-family-v500-prob-help-can-you-contact-the-driver",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-family-v500-tran-please-call-the-driver",
                ],
                nextLocalLine: "Được, bạn cho tôi xem số điện thoại tài xế.",
                nextLocalMeaning: "Okay, please show me the driver's phone number.",
                recoveryTitle: "If calling feels hard",
                recoveryBody: "Show the driver screen and ask staff to call for you.",
                nextStepTitle: "Buy water before leaving",
                localScenarioContext: "airport_story_call_driver",
                scenarioResponseCopies: [
                    "viet-family-v900-airp-bord-arri-please-call-this-driver-for-me": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ có. Gọi tài xế này giúp tôi",
                        english: "Yes. Please call this driver for me"
                    ),
                    "viet-phrase-v500-tran-please-call-the-driver": PracticeScenarioPhraseTemplate(
                        vietnamese: "Gọi tài xế giúp tôi",
                        english: "Please call the driver for me",
                        nextLocalLine: "Được, bạn cho tôi xem số điện thoại tài xế.",
                        nextLocalMeaning: "Okay, please show me the driver's phone number."
                    ),
                    "viet-family-v500-tran-please-call-the-driver": PracticeScenarioPhraseTemplate(
                        vietnamese: "Gọi tài xế giúp tôi",
                        english: "Please call the driver for me",
                        nextLocalLine: "Được, bạn cho tôi xem số điện thoại tài xế.",
                        nextLocalMeaning: "Okay, please show me the driver's phone number."
                    ),
                    "viet-family-v500-prob-help-can-you-contact-the-driver": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn liên hệ tài xế giúp tôi được không?",
                        english: "Can you contact the driver for me?",
                        nextLocalLine: "Được, bạn cho tôi xem số điện thoại tài xế.",
                        nextLocalMeaning: "Okay, please show me the driver's phone number."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "airport-story-water",
                momentType: .ask,
                scene: "Before leaving the airport, you want one simple bottle of water.",
                localLine: "Bạn cần mua gì trước khi ra ngoài không?",
                localLineMeaning: "Do you need to buy anything before going outside?",
                userGoal: "Ask for a bottle of water and understand the price.",
                bestPageIDs: [
                    "viet-family-service-water",
                    "viet-family-food-bottled-water",
                ],
                alternatePageIDs: [
                    "viet-family-food-bottled-water",
                    "viet-phrase-v900-airp-bord-arri-where-can-i-buy-a-bottle-of-water",
                ],
                recoveryPageIDs: [
                    "viet-family-money-how-much",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "Có, quầy nước ở bên phải, gần cửa ra.",
                nextLocalMeaning: "Yes, the water counter is on the right, near the exit.",
                recoveryTitle: "If you need to point",
                recoveryBody: "Point to a bottle and ask how much before paying.",
                nextStepTitle: "Say thanks",
                localScenarioContext: "airport_story_water",
                scenarioResponseCopies: [
                    "viet-family-service-water": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi chai nước",
                        english: "A bottle of water please"
                    ),
                    "viet-family-food-bottled-water": PracticeScenarioPhraseTemplate(
                        vietnamese: "Có nước suối không?",
                        english: "Do you have bottled water?",
                        nextLocalLine: "Có, quầy nước ở bên phải, gần cửa ra.",
                        nextLocalMeaning: "Yes, the water counter is on the right, near the exit."
                    ),
                    "viet-phrase-v900-airp-bord-arri-where-can-i-buy-a-bottle-of-water": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi có thể mua một chai nước ở đâu?",
                        english: "Where can I buy a bottle of water?",
                        nextLocalLine: "Quầy nước ở bên phải, gần cửa ra.",
                        nextLocalMeaning: "The water counter is on the right, near the exit."
                    ),
                ]
            ),
            messageGoodbyeStep(
                id: "airport-story-goodbye",
                scene: "You know where to go and are ready to leave the airport.",
                localLine: "Bạn cần gì thêm không?",
                localLineMeaning: "Do you need anything else?",
                nextLocalLine: "Không có gì, chúc bạn đi an toàn.",
                nextLocalMeaning: "You are welcome, travel safely.",
                goodbyeNextLocalLine: "Tạm biệt, chúc bạn đi an toàn.",
                goodbyeNextLocalMeaning: "Goodbye, travel safely.",
                localScenarioContext: "airport_story_goodbye"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .airportPassportControl,
        sceneTitle: "Passport control",
        sceneSetup: "Use airport arrival phrases for passport, visa, trip purpose, stay length, and the signature desk.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "airport-passport-opening",
                momentType: .listen,
                scene: "You arrive at the passport-control desk and keep your documents visible.",
                localLine: "Xin chào, cho tôi xem hộ chiếu của bạn.",
                localLineMeaning: "Hello, please show me your passport.",
                userGoal: "Show your passport first.",
                bestPageIDs: [
                    "viet-family-v500-airp-bord-arri-here-is-my-passport",
                    "viet-family-vpe-likely-replies-dua-ho-chieu-ra",
                ],
                alternatePageIDs: [
                    "viet-family-v500-airp-bord-arri-here-is-my-visa",
                    "viet-family-v900-time-date-book-do-i-need-to-bring-my-passport",
                ],
                recoveryPageIDs: [
                    "viet-family-v500-emer-safe-i-do-not-have-my-passport",
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way",
                ],
                nextLocalLine: "Cảm ơn, tôi kiểm tra một chút.",
                nextLocalMeaning: "Thank you, I will check now.",
                recoveryTitle: "If you feel stuck",
                recoveryBody: "Keep the document visible and ask for simpler words before guessing.",
                nextStepTitle: "Show the visa",
                localScenarioContext: "airport_passport_opening",
                scenarioResponseCopies: [
                    "viet-family-v500-airp-bord-arri-here-is-my-passport": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đây là hộ chiếu của tôi",
                        english: "Here is my passport"
                    ),
                    "viet-family-v500-airp-bord-arri-here-is-my-visa": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đây là visa của tôi",
                        english: "Here is my visa",
                        nextLocalLine: "Cảm ơn, tôi cũng cần xem hộ chiếu.",
                        nextLocalMeaning: "Thank you. I also need to see your passport."
                    ),
                    "viet-family-v900-time-date-book-do-i-need-to-bring-my-passport": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi có cần đưa hộ chiếu không?",
                        english: "Do I need to show my passport?",
                        nextLocalLine: "Có, cho tôi xem hộ chiếu của bạn nhé.",
                        nextLocalMeaning: "Yes, please show me your passport."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "airport-passport-visa",
                momentType: .listen,
                scene: "The officer checks whether you need a visa document.",
                localLine: "Bạn có visa không?",
                localLineMeaning: "Do you have a visa?",
                userGoal: "Show the visa or ask for simpler wording.",
                bestPageIDs: [
                    "viet-family-v500-airp-bord-arri-here-is-my-visa",
                ],
                alternatePageIDs: [
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way",
                ],
                recoveryPageIDs: [
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way",
                    "viet-family-v500-emer-safe-i-do-not-have-my-passport",
                ],
                nextLocalLine: "Cảm ơn, tôi thấy rồi.",
                nextLocalMeaning: "Thank you, I see it.",
                recoveryTitle: "If you do not understand",
                recoveryBody: "Ask for simpler words and keep your passport open.",
                nextStepTitle: "Explain the visit",
                localScenarioContext: "airport_passport_visa",
                scenarioResponseCopies: [
                    "viet-family-v500-airp-bord-arri-here-is-my-visa": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đây là visa của tôi",
                        english: "Here is my visa"
                    ),
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn nói đơn giản hơn được không?",
                        english: "Can you say it in a simpler way?",
                        nextLocalLine: "Tôi cần xem visa hoặc giấy nhập cảnh của bạn.",
                        nextLocalMeaning: "I need to see your visa or entry document."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "airport-passport-purpose",
                momentType: .listen,
                scene: "The officer asks why you are entering Vietnam.",
                localLine: "Bạn đến Việt Nam làm gì?",
                localLineMeaning: "What is the purpose of your visit?",
                userGoal: "Say you are here for tourism.",
                bestPageIDs: [
                    "viet-family-v500-airp-bord-arri-i-am-here-for-tourism",
                ],
                alternatePageIDs: [
                    "viet-family-v500-airp-bord-arri-i-will-stay-for-five-days",
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way",
                ],
                recoveryPageIDs: [
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way",
                    "viet-family-v500-airp-bord-arri-here-is-my-passport",
                ],
                nextLocalLine: "Cảm ơn, bạn ở Việt Nam bao lâu?",
                nextLocalMeaning: "Thank you, how long will you stay in Vietnam?",
                recoveryTitle: "If the question is too fast",
                recoveryBody: "Say tourism first, then ask them to repeat or simplify.",
                nextStepTitle: "Say the stay length",
                localScenarioContext: "airport_passport_purpose",
                scenarioResponseCopies: [
                    "viet-family-v500-airp-bord-arri-i-am-here-for-tourism": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi đến đây du lịch",
                        english: "I am here for tourism"
                    ),
                    "viet-family-v500-airp-bord-arri-i-will-stay-for-five-days": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi sẽ ở năm ngày",
                        english: "I will stay for five days",
                        nextLocalLine: "Cảm ơn, còn mục đích chuyến đi là gì?",
                        nextLocalMeaning: "Thank you. What is the purpose of your visit?"
                    ),
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn nói đơn giản hơn được không?",
                        english: "Can you say it in a simpler way?",
                        nextLocalLine: "Bạn đi du lịch hay công tác?",
                        nextLocalMeaning: "Are you traveling for tourism or business?"
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "airport-passport-stay",
                momentType: .listen,
                scene: "Now the officer needs your trip length.",
                localLine: "Bạn ở Việt Nam bao lâu?",
                localLineMeaning: "How long will you stay in Vietnam?",
                userGoal: "Give the short stay-length response.",
                bestPageIDs: [
                    "viet-family-v500-airp-bord-arri-i-will-stay-for-five-days",
                ],
                alternatePageIDs: [
                    "viet-family-v500-airp-bord-arri-i-am-here-for-tourism",
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way",
                ],
                recoveryPageIDs: [
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way",
                    "viet-family-v500-airp-bord-arri-here-is-my-passport",
                ],
                nextLocalLine: "Cảm ơn, bạn ký tên ở đây nhé.",
                nextLocalMeaning: "Thank you, please sign here.",
                recoveryTitle: "If dates are hard",
                recoveryBody: "Show the booking dates and say the number of days if you can.",
                nextStepTitle: "Sign the form",
                localScenarioContext: "airport_passport_stay",
                scenarioResponseCopies: [
                    "viet-family-v500-airp-bord-arri-i-will-stay-for-five-days": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi sẽ ở năm ngày",
                        english: "I will stay for five days"
                    ),
                    "viet-family-v500-airp-bord-arri-i-am-here-for-tourism": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi đến đây du lịch",
                        english: "I am here for tourism",
                        nextLocalLine: "Cảm ơn, bạn ở bao nhiêu ngày?",
                        nextLocalMeaning: "Thank you, how many days will you stay?"
                    ),
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn nói đơn giản hơn được không?",
                        english: "Can you say it in a simpler way?",
                        nextLocalLine: "Bạn ở bao nhiêu ngày?",
                        nextLocalMeaning: "How many days will you stay?"
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "airport-passport-sign",
                momentType: .ask,
                scene: "There is a form or receipt at the desk and you need the exact signature spot.",
                localLine: "Bạn ký tên ở đây nhé.",
                localLineMeaning: "Please sign here.",
                userGoal: "Ask where to sign.",
                bestPageIDs: [
                    "viet-family-v500-airp-bord-arri-where-do-i-sign",
                ],
                alternatePageIDs: [
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way",
                    "viet-family-v500-airp-bord-arri-here-is-my-passport",
                ],
                recoveryPageIDs: [
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way",
                    "viet-family-v500-airp-bord-arri-here-is-my-passport",
                ],
                nextLocalLine: "Ký ở dòng này là được.",
                nextLocalMeaning: "Sign on this line.",
                recoveryTitle: "If the form is unclear",
                recoveryBody: "Ask where to sign, then wait for them to point.",
                nextStepTitle: "Finish at the desk",
                localScenarioContext: "airport_passport_sign",
                scenarioResponseCopies: [
                    "viet-family-v500-airp-bord-arri-where-do-i-sign": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi ký ở đâu?",
                        english: "Where do I sign?"
                    ),
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn nói đơn giản hơn được không?",
                        english: "Can you say it in a simpler way?",
                        nextLocalLine: "Ký ở dòng này nhé.",
                        nextLocalMeaning: "Sign on this line."
                    ),
                    "viet-family-v500-airp-bord-arri-here-is-my-passport": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đây là hộ chiếu của tôi",
                        english: "Here is my passport",
                        nextLocalLine: "Cảm ơn, ký ở dòng này nhé.",
                        nextLocalMeaning: "Thank you, sign on this line."
                    ),
                ]
            ),
            messageGoodbyeStep(
                id: "airport-passport-goodbye",
                scene: "The document check is complete and you are ready to leave the desk.",
                localLine: "Xong rồi, bạn có thể đi lấy hành lý.",
                localLineMeaning: "Done, you can go to baggage claim.",
                nextLocalLine: "Không có gì, chúc bạn đi an toàn.",
                nextLocalMeaning: "You are welcome, travel safely.",
                goodbyeNextLocalLine: "Tạm biệt, chúc bạn đi an toàn.",
                goodbyeNextLocalMeaning: "Goodbye, travel safely.",
                localScenarioContext: "airport_passport_goodbye"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .airportSimCash,
        sceneTitle: "Airport services",
        sceneSetup: "Find the SIM counter, ATM, information desk, and pickup point with short airport phrases.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "airport-service-opening",
                momentType: .ask,
                scene: "You are in the arrivals hall and need the useful counters before leaving.",
                localLine: "Xin chào, tôi có thể giúp gì cho bạn?",
                localLineMeaning: "Hello, how can I help you?",
                userGoal: "Ask for the SIM counter first.",
                bestPageIDs: [
                    "viet-family-v500-phon-inte-powe-where-can-i-get-a-local-sim-card",
                    "viet-family-airport-sim",
                ],
                alternatePageIDs: [
                    "viet-family-v500-airp-bord-arri-where-is-the-atm",
                    "viet-family-v900-airp-bord-arri-where-is-the-information-desk",
                ],
                recoveryPageIDs: [
                    "viet-family-v500-prob-help-can-you-help-me",
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way",
                ],
                nextLocalLine: "Quầy SIM ở bên phải, gần cửa ra.",
                nextLocalMeaning: "The SIM counter is on the right, near the exit.",
                recoveryTitle: "If the hall feels busy",
                recoveryBody: "Ask for one counter at a time, then follow where they point.",
                nextStepTitle: "Choose the SIM",
                localScenarioContext: "airport_service_opening",
                scenarioResponseCopies: [
                    "viet-family-v500-phon-inte-powe-where-can-i-get-a-local-sim-card": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi có thể mua SIM địa phương ở đâu?",
                        english: "Where can I get a local SIM card?"
                    ),
                    "viet-family-v500-airp-bord-arri-where-is-the-atm": PracticeScenarioPhraseTemplate(
                        vietnamese: "ATM ở đâu?",
                        english: "Where is the ATM?",
                        nextLocalLine: "ATM ở bên trái, cạnh quầy SIM.",
                        nextLocalMeaning: "The ATM is on the left, next to the SIM counter."
                    ),
                    "viet-family-v900-airp-bord-arri-where-is-the-information-desk": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bàn thông tin ở đâu?",
                        english: "Where is the information desk?",
                        nextLocalLine: "Bàn thông tin ở giữa sảnh.",
                        nextLocalMeaning: "The information desk is in the middle of the hall."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "airport-service-sim-type",
                momentType: .listen,
                scene: "At the SIM counter, staff asks what kind of mobile data you need.",
                localLine: "Bạn cần SIM thường hay eSIM?",
                localLineMeaning: "Do you need a regular SIM or an eSIM?",
                userGoal: "Ask for a data SIM or eSIM.",
                bestPageIDs: [
                    "viet-family-v500-phon-inte-powe-i-need-a-sim-card-with-data",
                    "viet-family-vpe-need-item-toi-can-the-sim",
                ],
                alternatePageIDs: [
                    "viet-family-v500-phon-inte-powe-i-need-an-esim",
                    "viet-family-money-how-much",
                ],
                recoveryPageIDs: [
                    "viet-family-phone-activate-sim",
                    "viet-family-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "Được, tôi lấy SIM có data cho bạn.",
                nextLocalMeaning: "Okay, I will get a SIM card with data for you.",
                recoveryTitle: "If you are not sure",
                recoveryBody: "Show your phone and ask them to check which SIM works.",
                nextStepTitle: "Ask for setup help",
                localScenarioContext: "airport_service_sim_type",
                scenarioResponseCopies: [
                    "viet-family-v500-phon-inte-powe-i-need-a-sim-card-with-data": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi cần SIM có data",
                        english: "I need a SIM card with data"
                    ),
                    "viet-family-v500-phon-inte-powe-i-need-an-esim": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi cần eSIM",
                        english: "I need an eSIM",
                        nextLocalLine: "Được, tôi kiểm tra điện thoại của bạn trước.",
                        nextLocalMeaning: "Okay, I will check your phone first."
                    ),
                    "viet-family-money-how-much": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cái này bao nhiêu?",
                        english: "How much is this?",
                        nextLocalLine: "Gói này là ba trăm nghìn và có data.",
                        nextLocalMeaning: "This plan is three hundred thousand and includes data."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "airport-service-sim-help",
                momentType: .ask,
                scene: "You want the counter staff to make sure the SIM actually works.",
                localLine: "Bạn muốn tôi kích hoạt SIM giúp không?",
                localLineMeaning: "Would you like me to activate the SIM for you?",
                userGoal: "Ask for help checking or activating the SIM.",
                bestPageIDs: [
                    "viet-family-phone-activate-sim",
                ],
                alternatePageIDs: [
                    "viet-family-phone-esim",
                    "viet-family-v900-phon-inte-powe-the-sim-card-is-not-working",
                ],
                recoveryPageIDs: [
                    "viet-family-v500-prob-help-can-you-help-me",
                    "viet-family-phone-data-not-working",
                ],
                nextLocalLine: "Được, đưa điện thoại cho tôi kiểm tra nhé.",
                nextLocalMeaning: "Yes, give me your phone so I can check it.",
                recoveryTitle: "Before you leave the counter",
                recoveryBody: "Wait until data works on your phone before walking away.",
                nextStepTitle: "Find cash",
                localScenarioContext: "airport_service_sim_help",
                scenarioResponseCopies: [
                    "viet-family-phone-activate-sim": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn có thể giúp tôi kích hoạt SIM được không?",
                        english: "Can you help me activate the SIM?"
                    ),
                    "viet-family-phone-esim": PracticeScenarioPhraseTemplate(
                        vietnamese: "eSIM của tôi không hoạt động",
                        english: "My eSIM is not working",
                        nextLocalLine: "Được, mở phần cài đặt điện thoại giúp tôi.",
                        nextLocalMeaning: "Yes, please open your phone settings."
                    ),
                    "viet-family-v900-phon-inte-powe-the-sim-card-is-not-working": PracticeScenarioPhraseTemplate(
                        vietnamese: "Thẻ SIM không hoạt động",
                        english: "The SIM card is not working",
                        nextLocalLine: "Để tôi kiểm tra lại SIM cho bạn.",
                        nextLocalMeaning: "Let me check the SIM again for you."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "airport-service-atm",
                momentType: .ask,
                scene: "After the SIM counter, you need cash before the ride.",
                localLine: "Bạn có cần rút tiền không?",
                localLineMeaning: "Do you need to withdraw cash?",
                userGoal: "Ask where the ATM is.",
                bestPageIDs: [
                    "viet-family-v500-airp-bord-arri-where-is-the-atm",
                    "viet-family-money-find-atm",
                ],
                alternatePageIDs: [
                    "viet-family-v900-mone-numb-pric-is-there-an-atm-nearby",
                    "viet-family-v500-mone-numb-pric-the-atm-did-not-give-me-cash",
                ],
                recoveryPageIDs: [
                    "viet-family-v500-mone-numb-pric-the-atm-kept-my-card",
                    "viet-family-v900-airp-bord-arri-where-is-the-information-desk",
                ],
                nextLocalLine: "ATM ở bên trái, cạnh quầy SIM.",
                nextLocalMeaning: "The ATM is on the left, next to the SIM counter.",
                recoveryTitle: "If the ATM fails",
                recoveryBody: "Use one ATM problem phrase and go back to the information desk.",
                nextStepTitle: "Find the information desk",
                localScenarioContext: "airport_service_atm",
                scenarioResponseCopies: [
                    "viet-family-v500-airp-bord-arri-where-is-the-atm": PracticeScenarioPhraseTemplate(
                        vietnamese: "ATM ở đâu?",
                        english: "Where is the ATM?"
                    ),
                    "viet-family-v900-mone-numb-pric-is-there-an-atm-nearby": PracticeScenarioPhraseTemplate(
                        vietnamese: "Gần đây có ATM không?",
                        english: "Is there an ATM nearby?",
                        nextLocalLine: "Có, ATM ở bên trái, cạnh quầy SIM.",
                        nextLocalMeaning: "Yes, the ATM is on the left, next to the SIM counter."
                    ),
                    "viet-family-v500-mone-numb-pric-the-atm-did-not-give-me-cash": PracticeScenarioPhraseTemplate(
                        vietnamese: "ATM không đưa tiền cho tôi",
                        english: "The ATM did not give me cash",
                        nextLocalLine: "Bạn đến quầy thông tin để được hỗ trợ nhé.",
                        nextLocalMeaning: "Please go to the information desk for help."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "airport-service-info-desk",
                momentType: .ask,
                scene: "You need one last airport counter before leaving the arrivals hall.",
                localLine: "Bạn cần quầy thông tin không?",
                localLineMeaning: "Do you need the information desk?",
                userGoal: "Ask where the information desk is.",
                bestPageIDs: [
                    "viet-family-v900-airp-bord-arri-where-is-the-information-desk",
                    "viet-family-v900-dire-navi-where-is-the-nearest-information-desk",
                ],
                alternatePageIDs: [
                    "viet-family-v900-dire-navi-where-is-the-nearest-information-desk",
                    "viet-family-v500-prob-help-can-you-help-me",
                ],
                recoveryPageIDs: [
                    "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way",
                    "viet-family-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "Quầy thông tin ở giữa sảnh.",
                nextLocalMeaning: "The information desk is in the middle of the hall.",
                recoveryTitle: "If you need a person",
                recoveryBody: "Ask for the information desk before explaining a bigger airport problem.",
                nextStepTitle: "Find pickup",
                localScenarioContext: "airport_service_info_desk",
                scenarioResponseCopies: [
                    "viet-family-v900-airp-bord-arri-where-is-the-information-desk": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bàn thông tin ở đâu?",
                        english: "Where is the information desk?"
                    ),
                    "viet-family-v900-dire-navi-where-is-the-nearest-information-desk": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bàn thông tin gần nhất ở đâu?",
                        english: "Where is the nearest information desk?",
                        nextLocalLine: "Quầy thông tin gần nhất ở giữa sảnh.",
                        nextLocalMeaning: "The nearest information desk is in the middle of the hall."
                    ),
                    "viet-family-v500-prob-help-can-you-help-me": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn có thể giúp tôi được không?",
                        english: "Can you help me?",
                        nextLocalLine: "Có, quầy thông tin ở giữa sảnh.",
                        nextLocalMeaning: "Yes, the information desk is in the middle of the hall."
                    ),
                ]
            ),
            messageScenarioStep(
                id: "airport-service-wifi",
                momentType: .ask,
                scene: "Before you leave the arrivals hall, your phone needs Wi-Fi or charging.",
                localLine: "Bạn cần Wi-Fi hay sạc điện thoại không?",
                localLineMeaning: "Do you need Wi-Fi or to charge your phone?",
                userGoal: "Ask for airport Wi-Fi first.",
                best: messageReply(
                    "viet-family-v900-airp-bord-arri-where-can-i-get-airport-wi-fi",
                    vietnamese: "Tôi có thể lấy Wi-Fi sân bay ở đâu?",
                    english: "Where can I get airport Wi-Fi?",
                    nextLocalLine: "Wi-Fi miễn phí ở quầy thông tin, tôi chỉ bạn nhé.",
                    nextLocalMeaning: "Free Wi-Fi is at the information desk; I will show you."
                ),
                alternates: [
                    messageReply(
                        "viet-family-v900-airp-bord-arri-where-can-i-charge-my-phone",
                        vietnamese: "Tôi có thể sạc điện thoại ở đâu?",
                        english: "Where can I charge my phone?",
                        nextLocalLine: "Ổ sạc ở cạnh quầy thông tin.",
                        nextLocalMeaning: "The charging outlet is beside the information desk."
                    ),
                    messageReply(
                        "viet-family-v900-airp-bord-arri-where-is-the-information-desk",
                        vietnamese: "Bàn thông tin ở đâu?",
                        english: "Where is the information desk?",
                        nextLocalLine: "Bàn thông tin ở giữa sảnh.",
                        nextLocalMeaning: "The information desk is in the middle of the hall."
                    ),
                ],
                recoveryPageIDs: [
                    "viet-family-v900-airp-bord-arri-where-is-the-information-desk",
                    "viet-family-v500-prob-help-can-you-help-me",
                ],
                recoveryTitle: "If the phone is low",
                recoveryBody: "Ask for charging first, then handle Wi-Fi or pickup details.",
                nextStepTitle: "Find pickup",
                localScenarioContext: "airport_service_wifi"
            ),
            PracticeScenarioStepTemplate(
                id: "airport-service-pickup",
                momentType: .ask,
                scene: "You are ready to leave the airport and need the pickup point.",
                localLine: "Bạn cần tìm điểm đón xe không?",
                localLineMeaning: "Do you need to find the pickup point?",
                userGoal: "Ask for the Grab or pickup point.",
                bestPageIDs: [
                    "viet-family-v900-airp-bord-arri-where-is-the-grab-pickup-point",
                    "viet-family-directions-pickup-point",
                ],
                alternatePageIDs: [
                    "viet-family-directions-pickup-point",
                    "viet-family-v500-airp-bord-arri-where-do-i-meet-the-driver",
                ],
                recoveryPageIDs: [
                    "viet-family-v900-airp-bord-arri-please-call-this-driver-for-me",
                    "viet-family-v500-prob-help-can-you-contact-the-driver",
                ],
                nextLocalLine: "Đi thẳng ra cửa số 3 nhé.",
                nextLocalMeaning: "Go straight to Gate 3.",
                recoveryTitle: "If your driver cannot find you",
                recoveryBody: "Show the ride screen and ask staff to contact the driver.",
                nextStepTitle: "Say thanks",
                localScenarioContext: "airport_service_pickup",
                scenarioResponseCopies: [
                    "viet-family-v900-airp-bord-arri-where-is-the-grab-pickup-point": PracticeScenarioPhraseTemplate(
                        vietnamese: "Điểm đón Grab ở đâu?",
                        english: "Where is the Grab pickup point?"
                    ),
                    "viet-family-directions-pickup-point": PracticeScenarioPhraseTemplate(
                        vietnamese: "Điểm đón ở đâu?",
                        english: "Where is the pickup point?",
                        nextLocalLine: "Điểm đón ở cửa số 3, đi thẳng nhé.",
                        nextLocalMeaning: "The pickup point is at Gate 3. Go straight."
                    ),
                    "viet-family-v500-airp-bord-arri-where-do-i-meet-the-driver": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi gặp tài xế ở đâu?",
                        english: "Where do I meet the driver?",
                        nextLocalLine: "Bạn gặp tài xế ở cửa số 3.",
                        nextLocalMeaning: "Meet the driver at Gate 3."
                    ),
                ]
            ),
            messageGoodbyeStep(
                id: "airport-service-goodbye",
                scene: "You have the services you need and can leave the arrivals hall.",
                localLine: "Bạn cần gì thêm trước khi ra ngoài không?",
                localLineMeaning: "Do you need anything else before going outside?",
                nextLocalLine: "Không có gì, chúc bạn đi an toàn.",
                nextLocalMeaning: "You are welcome, travel safely.",
                goodbyeNextLocalLine: "Tạm biệt, chúc bạn đi an toàn.",
                goodbyeNextLocalMeaning: "Goodbye, travel safely.",
                localScenarioContext: "airport_service_goodbye"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .hotelCheckInHelp,
        sceneTitle: "At the hotel",
        sceneSetup: "Greet the desk, check in, handle room basics, and say thanks.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "hotel-story-opening",
                momentType: .listen,
                scene: "You arrive at the hotel desk with your booking confirmation ready.",
                localLine: "Xin chào, bạn muốn nhận phòng phải không?",
                localLineMeaning: "Hello, would you like to check in?",
                userGoal: "Say you have a reservation.",
                bestPageIDs: [
                    "viet-family-hotel-reservation",
                    "viet-phrase-v500-hote-acco-i-booked-online",
                ],
                alternatePageIDs: [
                    "viet-phrase-v900-hote-acco-the-reservation-is-under-this-name",
                    "viet-phrase-v500-hote-acco-i-booked-online",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-family-hotel-reservation",
                ],
                nextLocalLine: "Dạ, tôi kiểm tra giúp bạn.",
                nextLocalMeaning: "Yes, I can check that for you.",
                recoveryTitle: "If the desk is busy",
                recoveryBody: "Keep the confirmation screen visible and use the reservation phrase first.",
                nextStepTitle: "Give the booking name",
                localScenarioContext: "hotel_story_opening",
                scenarioResponseCopies: [
                    "viet-family-hotel-reservation": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ, tôi có đặt phòng",
                        english: "Yes, I have a reservation"
                    ),
                    "viet-phrase-v500-hote-acco-i-booked-online": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi đã đặt phòng online",
                        english: "I booked online",
                        nextLocalLine: "Dạ, tôi kiểm tra giúp bạn.",
                        nextLocalMeaning: "Yes, I can check that for you."
                    ),
                    "viet-phrase-v900-hote-acco-the-reservation-is-under-this-name": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đặt chỗ dưới tên này",
                        english: "The reservation is under this name",
                        nextLocalLine: "Dạ, tôi kiểm tra giúp bạn.",
                        nextLocalMeaning: "Yes, I can check that for you."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "hotel-story-reservation",
                momentType: .listen,
                scene: "The host needs the name on the reservation.",
                localLine: "Đặt phòng tên gì ạ?",
                localLineMeaning: "What name is the reservation under?",
                userGoal: "Show the booking name or say it is under this name.",
                bestPageIDs: [
                    "viet-phrase-v900-hote-acco-the-reservation-is-under-this-name",
                    "viet-family-hotel-reservation",
                ],
                alternatePageIDs: [
                    "viet-phrase-v500-hote-acco-i-booked-online",
                    "viet-family-hotel-reservation",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-family-hotel-reservation",
                ],
                nextLocalLine: "Cảm ơn, tôi thấy đặt phòng rồi.",
                nextLocalMeaning: "Thank you, I found the reservation.",
                recoveryTitle: "If they cannot find it",
                recoveryBody: "Show the confirmation screen and keep the booking phrase ready.",
                nextStepTitle: "Show your passport",
                localScenarioContext: "hotel_story_reservation",
                scenarioResponseCopies: [
                    "viet-phrase-v900-hote-acco-the-reservation-is-under-this-name": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đặt chỗ dưới tên này",
                        english: "The reservation is under this name"
                    ),
                    "viet-family-hotel-reservation": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đây là tên đặt phòng",
                        english: "Here is the reservation name",
                        nextLocalLine: "Cảm ơn, tôi thấy đặt phòng rồi.",
                        nextLocalMeaning: "Thank you, I found the reservation."
                    ),
                    "viet-phrase-v500-hote-acco-i-booked-online": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi đặt phòng online, tên này",
                        english: "I booked online under this name",
                        nextLocalLine: "Cảm ơn, tôi thấy đặt phòng rồi.",
                        nextLocalMeaning: "Thank you, I found the reservation."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "hotel-story-passport",
                momentType: .listen,
                scene: "The host asks to see your passport.",
                localLine: "Cho tôi xem hộ chiếu được không?",
                localLineMeaning: "Can I see your passport?",
                userGoal: "Show the passport with one short line.",
                bestPageIDs: [
                    "viet-family-v500-airp-bord-arri-here-is-my-passport",
                    "viet-phrase-v500-hote-acco-here-is-my-passport-for-check-in",
                ],
                alternatePageIDs: [
                    "viet-phrase-v500-hote-acco-here-is-my-passport-for-check-in",
                    "viet-family-v500-emer-safe-i-do-not-have-my-passport",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-family-v500-emer-safe-i-do-not-have-my-passport",
                ],
                nextLocalLine: "Cảm ơn, tôi kiểm tra một chút.",
                nextLocalMeaning: "Thank you, I will check now.",
                recoveryTitle: "If check-in pauses",
                recoveryBody: "Keep your passport and booking confirmation together.",
                nextStepTitle: "Ask room basics",
                localScenarioContext: "hotel_story_passport",
                scenarioResponseCopies: [
                    "viet-family-v500-airp-bord-arri-here-is-my-passport": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đây là hộ chiếu của tôi",
                        english: "Here is my passport"
                    ),
                    "viet-phrase-v500-hote-acco-here-is-my-passport-for-check-in": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đây là hộ chiếu của tôi để nhận phòng",
                        english: "Here is my passport for check-in",
                        nextLocalLine: "Cảm ơn, tôi kiểm tra một chút.",
                        nextLocalMeaning: "Thank you, I will check now."
                    ),
                    "viet-family-v500-emer-safe-i-do-not-have-my-passport": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi không có hộ chiếu",
                        english: "I do not have my passport",
                        nextLocalLine: "Không sao, bạn có giấy tờ khác hoặc ảnh hộ chiếu không?",
                        nextLocalMeaning: "Okay, do you have another ID or a photo of your passport?"
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "hotel-story-room-basics",
                momentType: .ask,
                scene: "You have your room and need the basic details.",
                localLine: "Bạn cần gì thêm không?",
                localLineMeaning: "Do you need anything else?",
                userGoal: "Ask for the Wi-Fi first.",
                bestPageIDs: [
                    "viet-family-phone-wifi-password",
                    "viet-phrase-phone-wifi-common",
                ],
                alternatePageIDs: [
                    "viet-family-hotel-checkout-time",
                    "viet-family-v900-hote-acco-the-wi-fi-is-not-working-in-my-room",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v900-hote-acco-the-wi-fi-is-not-working-in-my-room",
                    "viet-phrase-phone-premium-password-not-working",
                ],
                nextLocalLine: "Mật khẩu Wi-Fi ở trên thẻ phòng.",
                nextLocalMeaning: "The Wi-Fi password is on the room card.",
                recoveryTitle: "If the reply is unclear",
                recoveryBody: "Ask them to point, write it down, or show the key card.",
                nextStepTitle: "Handle room help",
                localScenarioContext: "hotel_story_room_basics",
                scenarioResponseCopies: [
                    "viet-family-phone-wifi-password": PracticeScenarioPhraseTemplate(
                        vietnamese: "Mật khẩu Wi-Fi là gì?",
                        english: "What is the Wi-Fi password?"
                    ),
                    "viet-family-hotel-checkout-time": PracticeScenarioPhraseTemplate(
                        vietnamese: "Mấy giờ trả phòng?",
                        english: "What time is check-out?",
                        nextLocalLine: "Trả phòng lúc mười hai giờ trưa.",
                        nextLocalMeaning: "Check-out is at noon."
                    ),
                    "viet-family-v900-hote-acco-the-wi-fi-is-not-working-in-my-room": PracticeScenarioPhraseTemplate(
                        vietnamese: "Wi-Fi không hoạt động trong phòng tôi",
                        english: "The Wi-Fi is not working in my room",
                        nextLocalLine: "Tôi sẽ nhờ kỹ thuật kiểm tra Wi-Fi trong phòng.",
                        nextLocalMeaning: "I will ask maintenance to check the Wi-Fi in your room."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "hotel-story-room-help",
                momentType: .recovery,
                scene: "Something in the room needs a quick fix.",
                localLine: "Phòng có vấn đề gì không?",
                localLineMeaning: "Is there a problem with the room?",
                userGoal: "Explain the issue simply and ask for help.",
                bestPageIDs: [
                    "viet-phrase-v500-hote-acco-the-room-is-not-clean",
                    "viet-family-hotel-aircon-broken",
                ],
                alternatePageIDs: [
                    "viet-family-hotel-aircon-broken",
                    "viet-phrase-hotel-8",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-phrase-repair-slower-polite",
                ],
                nextLocalLine: "Tôi sẽ gọi nhân viên lên kiểm tra.",
                nextLocalMeaning: "I will call staff to check it.",
                recoveryTitle: "If you need a fallback",
                recoveryBody: "Use the help phrase, then show the room problem.",
                nextStepTitle: "Get a ride",
                localScenarioContext: "hotel_story_room_help",
                scenarioResponseCopies: [
                    "viet-phrase-v500-hote-acco-the-room-is-not-clean": PracticeScenarioPhraseTemplate(
                        vietnamese: "Phòng chưa sạch",
                        english: "The room is not clean"
                    ),
                    "viet-family-hotel-aircon-broken": PracticeScenarioPhraseTemplate(
                        vietnamese: "Máy lạnh không hoạt động",
                        english: "The air conditioner isn't working",
                        nextLocalLine: "Tôi sẽ gọi nhân viên lên kiểm tra.",
                        nextLocalMeaning: "I will call staff to check it."
                    ),
                    "viet-phrase-hotel-8": PracticeScenarioPhraseTemplate(
                        vietnamese: "Thẻ phòng không dùng được",
                        english: "The key card doesn't work",
                        nextLocalLine: "Tôi làm thẻ phòng mới cho bạn ngay.",
                        nextLocalMeaning: "I will make a new key card for you now."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "hotel-story-ride",
                momentType: .ask,
                scene: "You are leaving the hotel and need help with a ride.",
                localLine: "Bạn cần gọi xe hay đi đến đâu?",
                localLineMeaning: "Do you need a car called, or where are you going?",
                userGoal: "Ask for a taxi or show where you want to go.",
                bestPageIDs: [
                    "viet-family-ves-call-taxi-for-me",
                    "viet-phrase-hotel-9",
                ],
                alternatePageIDs: [
                    "viet-phrase-v900-tran-please-take-me-to-this-address",
                    "viet-family-v900-airp-bord-arri-please-call-this-driver-for-me",
                ],
                recoveryPageIDs: [
                    "viet-family-vpe-help-action-anh-chi-giup-toi-goi-xe-cong-nghe-duoc-khong",
                    "viet-family-vpe-help-action-anh-chi-giup-toi-xac-nhan-dia-chi-duoc-khong",
                ],
                nextLocalLine: "Tôi sẽ gọi xe giúp bạn.",
                nextLocalMeaning: "I will call a car for you.",
                recoveryTitle: "If the place name is hard",
                recoveryBody: "Show the map pin and keep the ride phrase short.",
                nextStepTitle: "Say thanks",
                localScenarioContext: "hotel_story_ride",
                scenarioResponseCopies: [
                    "viet-family-ves-call-taxi-for-me": PracticeScenarioPhraseTemplate(
                        vietnamese: "Gọi taxi giúp tôi được không?",
                        english: "Can you call a taxi for me?"
                    ),
                    "viet-phrase-hotel-9": PracticeScenarioPhraseTemplate(
                        vietnamese: "Gọi taxi giúp tôi được không?",
                        english: "Can you call a taxi for me?"
                    ),
                    "viet-phrase-v900-tran-please-take-me-to-this-address": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi muốn đến địa chỉ này",
                        english: "I want to go to this address",
                        nextLocalLine: "Tôi sẽ gọi xe đến địa chỉ này cho bạn.",
                        nextLocalMeaning: "I will call a car to this address for you."
                    ),
                    "viet-family-v900-airp-bord-arri-please-call-this-driver-for-me": PracticeScenarioPhraseTemplate(
                        vietnamese: "Hãy gọi tài xế này cho tôi",
                        english: "Please call this driver for me",
                        nextLocalLine: "Được, cho tôi xem số điện thoại tài xế.",
                        nextLocalMeaning: "Okay, please show me the driver's phone number."
                    ),
                ]
            ),
            messageGoodbyeStep(
                id: "hotel-story-goodbye",
                scene: "The desk has helped you and the next step is handled.",
                localLine: "Bạn cần hỗ trợ gì nữa không?",
                localLineMeaning: "Do you need any more help?",
                nextLocalLine: "Không có gì, chúc bạn đi chơi vui.",
                nextLocalMeaning: "You are welcome, enjoy your day out.",
                goodbyeNextLocalLine: "Tạm biệt, chúc bạn đi chơi vui.",
                goodbyeNextLocalMeaning: "Goodbye, enjoy your day out.",
                localScenarioContext: "hotel_story_goodbye"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .taxiGrabPickup,
        sceneTitle: "Taxi / Grab pickup",
        sceneSetup: "Greet the driver, confirm the car, set the route, and close the ride.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "taxi-story-opening",
                momentType: .listen,
                scene: "You approach a possible driver near the pickup area and check before getting in.",
                localLine: "Xin chào, bạn đặt xe phải không?",
                localLineMeaning: "Hello, did you book a ride?",
                userGoal: "Confirm this is your driver.",
                bestPageIDs: [
                    "viet-family-v500-tran-are-you-my-driver",
                    "viet-family-v900-airp-bord-arri-i-have-an-airport-pickup-booked",
                ],
                alternatePageIDs: [
                    "viet-family-v900-airp-bord-arri-i-have-an-airport-pickup-booked",
                ],
                recoveryPageIDs: [
                    "viet-family-v900-airp-bord-arri-please-call-this-driver-for-me",
                    "viet-family-v500-tran-please-call-the-driver",
                ],
                nextLocalLine: "Đúng rồi, bạn kiểm tra biển số nhé.",
                nextLocalMeaning: "Yes, please check the license plate.",
                recoveryTitle: "If the car does not match",
                recoveryBody: "Stay outside the car, show the app screen, and ask to confirm the driver.",
                nextStepTitle: "Confirm the car",
                localScenarioContext: "taxi_story_opening",
                scenarioResponseCopies: [
                    "viet-family-v500-tran-are-you-my-driver": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ đúng rồi, bạn là tài xế của tôi à?",
                        english: "Yes, that's right. Are you my driver?"
                    ),
                    "viet-family-v900-airp-bord-arri-i-have-an-airport-pickup-booked": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ, tôi đã đặt xe này",
                        english: "Yes, I booked this ride",
                        nextLocalLine: "Đúng rồi, bạn kiểm tra biển số nhé.",
                        nextLocalMeaning: "Yes, please check the license plate."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "taxi-story-confirm-driver",
                momentType: .listen,
                scene: "The driver is nearby but needs the exact entrance.",
                localLine: "Bạn đang ở cửa nào?",
                localLineMeaning: "Which entrance are you at?",
                userGoal: "Move the pickup point without typing a long message.",
                bestPageIDs: [
                    "viet-family-v900-tran-pick-me-up-at-this-entrance",
                    "viet-family-v900-tran-can-you-pick-me-up-here",
                ],
                alternatePageIDs: [
                    "viet-family-v900-tran-can-you-pick-me-up-here",
                    "viet-family-directions-pickup-point",
                    "viet-family-v500-airp-bord-arri-where-do-i-meet-the-driver",
                ],
                recoveryPageIDs: [
                    "viet-family-v500-prob-help-can-you-contact-the-driver",
                    "viet-family-v500-tran-please-call-the-driver",
                ],
                nextLocalLine: "Tôi sẽ tới cửa này.",
                nextLocalMeaning: "I will come to this entrance.",
                recoveryTitle: "If you still cannot meet",
                recoveryBody: "Show the entrance number or ask nearby staff to contact the driver.",
                nextStepTitle: "Show the address",
                localScenarioContext: "taxi_story_confirm_driver",
                scenarioResponseCopies: [
                    "viet-family-v900-tran-pick-me-up-at-this-entrance": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi đang ở cửa này",
                        english: "I'm at this entrance"
                    ),
                    "viet-family-v900-tran-can-you-pick-me-up-here": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn đón tôi ở đây được không?",
                        english: "Can you pick me up here?",
                        nextLocalLine: "Được, tôi sẽ tới cửa này.",
                        nextLocalMeaning: "Yes, I will come to this entrance."
                    ),
                    "viet-family-directions-pickup-point": PracticeScenarioPhraseTemplate(
                        vietnamese: "Điểm đón ở đâu?",
                        english: "Where is the pickup point?",
                        nextLocalLine: "Điểm đón ở cửa này. Tôi sẽ gặp bạn ở đó.",
                        nextLocalMeaning: "The pickup point is at this entrance. I'll meet you there."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "taxi-story-pickup-point",
                momentType: .ask,
                scene: "You are in the car and show the hotel address on your phone.",
                localLine: "Bạn đi đến khách sạn này đúng không?",
                localLineMeaning: "You are going to this hotel, right?",
                userGoal: "Confirm the destination before the car moves.",
                bestPageIDs: [
                    "viet-family-v500-tran-please-take-me-to-this-hotel",
                    "viet-family-v900-tran-please-take-me-to-this-address",
                ],
                alternatePageIDs: [
                    "viet-family-v900-tran-please-take-me-to-this-address",
                    "viet-family-v500-airp-bord-arri-please-take-me-to-the-hotel-listed-on-this-booki",
                ],
                recoveryPageIDs: [
                    "viet-family-vpe-help-action-anh-chi-giup-toi-xac-nhan-dia-chi-duoc-khong",
                    "viet-phrase-v900-dire-navi-please-write-the-address-for-me",
                ],
                nextLocalLine: "Được, tôi sẽ đi theo bản đồ.",
                nextLocalMeaning: "Okay, I will follow the map.",
                recoveryTitle: "If the address looks wrong",
                recoveryBody: "Show the map pin again before the car starts moving.",
                nextStepTitle: "Confirm the route",
                localScenarioContext: "taxi_story_pickup_point",
                scenarioResponseCopies: [
                    "viet-family-v500-tran-please-take-me-to-this-hotel": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ đúng, khách sạn này",
                        english: "Yes, this hotel"
                    ),
                    "viet-family-v900-tran-please-take-me-to-this-address": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ đúng, địa chỉ này",
                        english: "Yes, this address",
                        nextLocalLine: "Được, tôi sẽ đi theo bản đồ.",
                        nextLocalMeaning: "Okay, I will follow the map."
                    ),
                    "viet-family-v500-airp-bord-arri-please-take-me-to-the-hotel-listed-on-this-booki": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ đúng, khách sạn trong đặt phòng này",
                        english: "Yes, the hotel on this booking",
                        nextLocalLine: "Được, tôi sẽ đi theo bản đồ.",
                        nextLocalMeaning: "Okay, I will follow the map."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "taxi-story-address",
                momentType: .ask,
                scene: "The car is moving and the driver checks the route.",
                localLine: "Đường này hơi kẹt xe, tôi đi theo bản đồ nhé?",
                localLineMeaning: "This road has some traffic; should I follow the map?",
                userGoal: "Keep the route simple and follow the map.",
                bestPageIDs: [
                    "viet-family-v500-tran-please-follow-the-map",
                    "viet-family-v500-tran-please-take-me-to-this-hotel",
                ],
                alternatePageIDs: [
                    "viet-family-v500-tran-please-take-me-to-this-hotel",
                    "viet-family-v900-tran-please-take-me-to-this-address",
                ],
                recoveryPageIDs: [
                    "viet-family-vpe-help-action-anh-chi-giup-toi-xac-nhan-dia-chi-duoc-khong",
                    "viet-phrase-v900-dire-navi-please-write-the-address-for-me",
                ],
                nextLocalLine: "Được, tôi đi theo bản đồ.",
                nextLocalMeaning: "Okay, I will follow the map.",
                recoveryTitle: "If the route looks wrong",
                recoveryBody: "Show the map pin again and ask the driver to confirm the address.",
                nextStepTitle: "Get out cleanly",
                localScenarioContext: "taxi_story_route",
                scenarioResponseCopies: [
                    "viet-family-v900-tran-please-take-me-to-this-address": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ, đi theo địa chỉ này giúp tôi",
                        english: "Yes, please follow this address",
                        nextLocalLine: "Được, tôi đi theo bản đồ.",
                        nextLocalMeaning: "Okay, I will follow the map."
                    ),
                    "viet-family-v500-tran-please-follow-the-map": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ, đi theo bản đồ giúp tôi",
                        english: "Yes, please follow the map"
                    ),
                    "viet-family-v500-tran-please-take-me-to-this-hotel": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đến khách sạn này giúp tôi",
                        english: "Please go to this hotel",
                        nextLocalLine: "Được, tôi giữ khách sạn này làm điểm đến và đi theo bản đồ.",
                        nextLocalMeaning: "Okay, I'll keep this hotel as the destination and follow the map."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "taxi-story-dropoff",
                momentType: .ask,
                scene: "You are close to the destination and want to get out here.",
                localLine: "Bạn muốn xuống ở đâu?",
                localLineMeaning: "Where would you like to get out?",
                userGoal: "Ask for a simple drop-off and close the ride.",
                bestPageIDs: [
                    "viet-family-transport-stop-here",
                ],
                alternatePageIDs: [
                    "viet-family-transport-stop-here",
                    "viet-family-v500-tran-i-will-pay-the-driver-in-cash",
                ],
                recoveryPageIDs: [
                    "viet-family-v900-airp-bord-arri-can-i-pay-the-driver-by-card",
                    "viet-family-v500-tran-please-call-the-driver",
                ],
                nextLocalLine: "Được, tôi dừng ở đây.",
                nextLocalMeaning: "Sure, I will stop here.",
                recoveryTitle: "If payment comes up",
                recoveryBody: "Keep the app screen open and use one payment phrase at a time.",
                nextStepTitle: "Say thanks",
                localScenarioContext: "taxi_story_dropoff",
                scenarioResponseCopies: [
                    "viet-family-transport-stop-here": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dừng ở đây được rồi",
                        english: "You can stop here",
                        nextLocalLine: "Được, tôi dừng ở đây.",
                        nextLocalMeaning: "Sure, I will stop here."
                    ),
                    "viet-family-v500-tran-i-will-pay-the-driver-in-cash": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi trả bằng tiền mặt",
                        english: "I'll pay cash",
                        nextLocalLine: "Được, trả tiền mặt cũng được. Bạn muốn tôi dừng ở đâu?",
                        nextLocalMeaning: "Cash is okay. Where would you like me to stop?"
                    ),
                ]
            ),
            messageGoodbyeStep(
                id: "taxi-story-goodbye",
                scene: "The ride is over and you are getting out.",
                localLine: "Bạn xuống ở đây nhé?",
                localLineMeaning: "You are getting out here, right?",
                nextLocalLine: "Cảm ơn, chúc bạn một ngày tốt lành.",
                nextLocalMeaning: "Thank you, have a good day.",
                goodbyeNextLocalLine: "Tạm biệt, chúc bạn một ngày tốt lành.",
                goodbyeNextLocalMeaning: "Goodbye, have a good day.",
                localScenarioContext: "taxi_story_goodbye"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .pharmacyHelp,
        sceneTitle: "Pharmacy help",
        sceneSetup: "Greet, explain one symptom, understand the medicine, and say thanks.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "pharmacy-story-opening",
                momentType: .listen,
                scene: "You walk up to the pharmacy counter and keep the first symptom simple.",
                localLine: "Xin chào, bạn cần thuốc cho triệu chứng gì?",
                localLineMeaning: "Hello, what symptom do you need medicine for?",
                userGoal: "Say one clear symptom.",
                bestPageIDs: [
                    "viet-family-health-headache",
                    "viet-family-v500-heal-phar-i-have-a-fever",
                ],
                alternatePageIDs: [
                    "viet-family-health-stomach",
                    "viet-family-v500-heal-phar-i-feel-nauseous",
                ],
                recoveryPageIDs: [
                    "viet-family-v500-heal-phar-i-need-a-clinic",
                    "viet-family-health-doctor",
                ],
                nextLocalLine: "Tôi hiểu, để tôi xem thuốc phù hợp.",
                nextLocalMeaning: "I understand, let me look for suitable medicine.",
                recoveryTitle: "If symptoms are serious",
                recoveryBody: "Ask for a clinic or doctor instead of trying to explain everything.",
                nextStepTitle: "Find help",
                localScenarioContext: "pharmacy_story_opening",
                scenarioResponseCopies: [
                    "viet-family-health-headache": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi bị đau đầu",
                        english: "I have a headache"
                    ),
                    "viet-family-v500-heal-phar-i-have-a-fever": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi bị sốt",
                        english: "I have a fever"
                    ),
                    "viet-family-health-stomach": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi đau bụng",
                        english: "My stomach hurts",
                        nextLocalLine: "Tôi hiểu, để tôi xem thuốc phù hợp.",
                        nextLocalMeaning: "I understand, let me look for suitable medicine."
                    ),
                    "viet-family-v500-heal-phar-i-feel-nauseous": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi cảm thấy buồn nôn",
                        english: "I feel nauseous",
                        nextLocalLine: "Tôi hiểu, để tôi xem thuốc phù hợp.",
                        nextLocalMeaning: "I understand, let me look for suitable medicine."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "pharmacy-story-find",
                momentType: .ask,
                scene: "The pharmacist checks whether this is simple enough for over-the-counter medicine.",
                localLine: "Bạn có sốt không?",
                localLineMeaning: "Do you have a fever?",
                userGoal: "Share the closest symptom or ask for a doctor if needed.",
                bestPageIDs: [
                    "viet-family-v500-heal-phar-i-have-a-fever",
                    "viet-family-health-headache",
                ],
                alternatePageIDs: [
                    "viet-family-health-headache",
                    "viet-family-health-stomach",
                    "viet-family-v500-heal-phar-i-feel-nauseous",
                ],
                recoveryPageIDs: [
                    "viet-family-v500-heal-phar-i-need-a-clinic",
                    "viet-family-health-doctor",
                ],
                nextLocalLine: "Cảm ơn, để tôi xem thuốc phù hợp.",
                nextLocalMeaning: "Thank you, let me look for suitable medicine.",
                recoveryTitle: "If you need more help",
                recoveryBody: "Ask for a clinic or doctor when the symptom feels stronger than a simple pharmacy stop.",
                nextStepTitle: "Confirm the symptom",
                localScenarioContext: "pharmacy_story_find",
                scenarioResponseCopies: [
                    "viet-family-v500-heal-phar-i-have-a-fever": PracticeScenarioPhraseTemplate(
                        vietnamese: "Có, tôi bị sốt",
                        english: "Yes, I have a fever"
                    ),
                    "viet-family-health-headache": PracticeScenarioPhraseTemplate(
                        vietnamese: "Không, tôi bị đau đầu",
                        english: "No, I have a headache",
                        nextLocalLine: "Cảm ơn, để tôi xem thuốc phù hợp.",
                        nextLocalMeaning: "Thank you, let me look for suitable medicine."
                    ),
                    "viet-family-health-stomach": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi đau bụng",
                        english: "My stomach hurts",
                        nextLocalLine: "Cảm ơn, để tôi xem thuốc phù hợp.",
                        nextLocalMeaning: "Thank you, let me look for suitable medicine."
                    ),
                    "viet-family-v500-heal-phar-i-feel-nauseous": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi cảm thấy buồn nôn",
                        english: "I feel nauseous"
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "pharmacy-story-symptom",
                momentType: .listen,
                scene: "Before choosing medicine, the pharmacist asks about allergies.",
                localLine: "Bạn có dị ứng thuốc gì không?",
                localLineMeaning: "Are you allergic to any medicine?",
                userGoal: "Mention allergies or keep the reply simple.",
                bestPageIDs: [
                    "viet-family-acknowledge-khong",
                    "viet-family-health-allergy",
                ],
                alternatePageIDs: [
                    "viet-family-health-allergy",
                    "viet-family-v500-heal-phar-i-need-a-clinic",
                ],
                recoveryPageIDs: [
                    "viet-family-v500-heal-phar-i-need-a-clinic",
                    "viet-family-health-doctor",
                ],
                nextLocalLine: "Cảm ơn, tôi sẽ chọn loại phù hợp.",
                nextLocalMeaning: "Thank you, I will choose a suitable type.",
                recoveryTitle: "If symptoms are serious",
                recoveryBody: "Ask for a clinic or doctor instead of trying to explain everything.",
                nextStepTitle: "Ask for medicine",
                localScenarioContext: "pharmacy_story_symptom",
                scenarioResponseCopies: [
                    "viet-family-acknowledge-khong": PracticeScenarioPhraseTemplate(
                        vietnamese: "Không, tôi không bị dị ứng thuốc",
                        english: "No, I am not allergic to medicine"
                    ),
                    "viet-family-health-allergy": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi bị dị ứng thuốc này",
                        english: "I am allergic to this medicine",
                        nextLocalLine: "Cảm ơn bạn đã nói. Tôi sẽ chọn thuốc khác.",
                        nextLocalMeaning: "Thanks for telling me. I will choose a different medicine."
                    ),
                    "viet-family-v500-heal-phar-i-need-a-clinic": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi cần phòng khám",
                        english: "I need a clinic",
                        nextLocalLine: "Được, gần đây có phòng khám. Tôi có thể chỉ đường cho bạn.",
                        nextLocalMeaning: "Okay, there is a nearby clinic. I can help you get there."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "pharmacy-story-medicine",
                momentType: .ask,
                scene: "The pharmacist shows a box of medicine.",
                localLine: "Thuốc này được không?",
                localLineMeaning: "Is this medicine okay?",
                userGoal: "Ask how to take it before paying.",
                bestPageIDs: [
                    "viet-family-v500-heal-phar-how-do-i-take-this",
                    "viet-family-v500-heal-phar-how-many-times-per-day",
                ],
                alternatePageIDs: [
                    "viet-family-v500-heal-phar-how-many-times-per-day",
                    "viet-family-health-allergy",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v900-dire-navi-please-write-the-address-for-me",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "Uống sau khi ăn, ngày hai lần.",
                nextLocalMeaning: "Take it after eating, twice a day.",
                recoveryTitle: "If the directions are unclear",
                recoveryBody: "Ask the pharmacist to write the dose on the box.",
                nextStepTitle: "Close the exchange",
                localScenarioContext: "pharmacy_story_medicine",
                scenarioResponseCopies: [
                    "viet-family-v500-heal-phar-how-do-i-take-this": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi uống thuốc này như thế nào?",
                        english: "How do I take this medicine?"
                    ),
                    "viet-family-v500-heal-phar-how-many-times-per-day": PracticeScenarioPhraseTemplate(
                        vietnamese: "Uống bao nhiêu lần mỗi ngày?",
                        english: "How many times per day should I take it?",
                        nextLocalLine: "Uống sau khi ăn, ngày hai lần.",
                        nextLocalMeaning: "Take it after eating, twice a day."
                    ),
                    "viet-family-health-allergy": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi bị dị ứng thuốc này",
                        english: "I am allergic to this medicine",
                        nextLocalLine: "Đừng uống loại này. Tôi sẽ tìm loại khác hoặc gọi bác sĩ.",
                        nextLocalMeaning: "Do not take this one. I will find another option or call a doctor."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "pharmacy-story-pay",
                momentType: .ask,
                scene: "You are ready to pay and leave with the medicine.",
                localLine: "Bạn cần gì thêm không?",
                localLineMeaning: "Do you need anything else?",
                userGoal: "Pay and keep the close short.",
                bestPageIDs: [
                    "viet-family-food-pay-now",
                    "viet-family-money-how-much",
                ],
                alternatePageIDs: [
                    "viet-family-service-card",
                    "viet-family-transport-cash",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-family-v500-heal-phar-can-you-call-a-doctor",
                ],
                nextLocalLine: "Cảm ơn, chúc bạn mau khỏe.",
                nextLocalMeaning: "Thank you, I hope you feel better soon.",
                recoveryTitle: "Before you leave",
                recoveryBody: "Keep the box and written directions together in your bag.",
                nextStepTitle: "Say thanks",
                localScenarioContext: "pharmacy_story_pay",
                scenarioResponseCopies: [
                    "viet-family-food-pay-now": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi thanh toán luôn nhé",
                        english: "I'll pay now"
                    ),
                    "viet-family-money-how-much": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bao nhiêu tiền?",
                        english: "How much is it?"
                    ),
                    "viet-family-service-card": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi quẹt thẻ được không?",
                        english: "Can I pay by card?",
                        nextLocalLine: "Dạ được, bạn quẹt thẻ ở đây. Chúc bạn mau khỏe.",
                        nextLocalMeaning: "Yes, card is okay. I hope you feel better soon."
                    ),
                    "viet-family-transport-cash": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi trả bằng tiền mặt",
                        english: "I'll pay cash",
                        nextLocalLine: "Dạ được, cảm ơn. Chúc bạn mau khỏe.",
                        nextLocalMeaning: "Cash is okay. I hope you feel better soon."
                    ),
                ]
            ),
            messageGoodbyeStep(
                id: "pharmacy-story-goodbye",
                scene: "You understand the medicine instructions and are ready to leave.",
                localLine: "Bạn hiểu cách uống thuốc chưa?",
                localLineMeaning: "Do you understand how to take the medicine?",
                userGoal: "Thank them and confirm you understand.",
                nextLocalLine: "Tạm biệt, chúc bạn mau khỏe.",
                nextLocalMeaning: "Goodbye, I hope you feel better soon.",
                recoveryTitle: "If the instructions still feel unclear",
                recoveryBody: "Use cảm ơn first, then ask them to write the directions on the box.",
                localScenarioContext: "pharmacy_story_goodbye"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .danangDay,
        sceneTitle: "Beach vendor",
        sceneSetup: "Buy water, ask for shade, choose a snack, understand the price, and close politely.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "beach-vendor-opening",
                momentType: .ask,
                scene: "You walk up to a small stand by the beach and want to start with something easy.",
                localLine: "Xin chào, bạn muốn mua nước hay thuê ghế?",
                localLineMeaning: "Hello, do you want to buy water or rent a chair?",
                userGoal: "Ask for a bottle of water first.",
                bestPageIDs: [
                    "viet-family-service-water",
                    "viet-family-food-bottled-water",
                ],
                alternatePageIDs: [
                    "viet-family-food-bottled-water",
                    "viet-family-money-how-much",
                ],
                recoveryPageIDs: [
                    "viet-family-money-how-much",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "Có, nước suối hai mươi nghìn.",
                nextLocalMeaning: "Yes, bottled water is twenty thousand.",
                recoveryTitle: "If you only point",
                recoveryBody: "Point to the bottle, ask how much, then pay after they confirm.",
                nextStepTitle: "Ask for shade",
                localScenarioContext: "beach_vendor_opening",
                scenarioResponseCopies: [
                    "viet-family-service-water": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi chai nước",
                        english: "A bottle of water please"
                    ),
                    "viet-family-food-bottled-water": PracticeScenarioPhraseTemplate(
                        vietnamese: "Có nước suối không?",
                        english: "Do you have bottled water?",
                        nextLocalLine: "Có, nước suối hai mươi nghìn.",
                        nextLocalMeaning: "Yes, bottled water is twenty thousand."
                    ),
                    "viet-family-money-how-much": PracticeScenarioPhraseTemplate(
                        vietnamese: "Nước suối bao nhiêu tiền?",
                        english: "How much is bottled water?",
                        nextLocalLine: "Nước suối hai mươi nghìn.",
                        nextLocalMeaning: "Bottled water is twenty thousand."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "beach-vendor-chair",
                momentType: .ask,
                scene: "The sun is strong and you want to sit in the shade.",
                localLine: "Bạn cần ghế với dù không?",
                localLineMeaning: "Do you need a chair and umbrella?",
                userGoal: "Ask for an umbrella or shade.",
                bestPageIDs: [
                    "viet-phrase-v500-loca-serv-ever-task-i-need-an-umbrella",
                    "viet-family-service-sunscreen",
                ],
                alternatePageIDs: [
                    "viet-family-money-how-much",
                    "viet-family-service-sunscreen",
                ],
                recoveryPageIDs: [
                    "viet-family-money-how-much",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "Dạ, ghế và dù ở hàng đầu tiên.",
                nextLocalMeaning: "Yes, the chairs and umbrellas are in the first row.",
                recoveryTitle: "If the setup is unclear",
                recoveryBody: "Point to the chair or umbrella and ask how much before sitting down.",
                nextStepTitle: "Ask the price",
                localScenarioContext: "beach_vendor_chair",
                scenarioResponseCopies: [
                    "viet-phrase-v500-loca-serv-ever-task-i-need-an-umbrella": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ, cho tôi ghế với dù",
                        english: "Yes, a chair and umbrella, please"
                    ),
                    "viet-family-money-how-much": PracticeScenarioPhraseTemplate(
                        vietnamese: "Ghế với dù bao nhiêu tiền?",
                        english: "How much are the chair and umbrella?",
                        nextLocalLine: "Một bộ ghế và dù là năm mươi nghìn.",
                        nextLocalMeaning: "A chair and umbrella set is fifty thousand."
                    ),
                    "viet-family-service-sunscreen": PracticeScenarioPhraseTemplate(
                        vietnamese: "Có kem chống nắng không?",
                        english: "Do you have sunscreen?",
                        nextLocalLine: "Có, kem chống nắng ở quầy này.",
                        nextLocalMeaning: "Yes, sunscreen is here by the counter."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "beach-vendor-price",
                momentType: .ask,
                scene: "Before you sit down, you want the price to be clear.",
                localLine: "Bạn muốn thuê ghế này không?",
                localLineMeaning: "Do you want to rent this chair?",
                userGoal: "Ask how much it costs.",
                bestPageIDs: [
                    "viet-family-money-how-much",
                    "viet-family-service-card",
                ],
                alternatePageIDs: [
                    "viet-family-service-card",
                    "viet-family-transport-cash",
                ],
                recoveryPageIDs: [
                    "viet-family-money-how-much",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "Một ghế là năm mươi nghìn.",
                nextLocalMeaning: "One chair is fifty thousand.",
                recoveryTitle: "If the price is unclear",
                recoveryBody: "Ask how much and wait for the number before agreeing.",
                nextStepTitle: "Order a beach snack",
                localScenarioContext: "beach_vendor_price",
                scenarioResponseCopies: [
                    "viet-family-money-how-much": PracticeScenarioPhraseTemplate(
                        vietnamese: "Ghế này bao nhiêu tiền?",
                        english: "How much is this chair?"
                    ),
                    "viet-family-service-card": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi quẹt thẻ được không?",
                        english: "Can I pay by card?",
                        nextLocalLine: "Xin lỗi, chỉ nhận tiền mặt. Một ghế là năm mươi nghìn.",
                        nextLocalMeaning: "Sorry, cash only. One chair is fifty thousand."
                    ),
                    "viet-family-transport-cash": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi trả bằng tiền mặt",
                        english: "I'll pay cash",
                        nextLocalLine: "Được, một ghế là năm mươi nghìn.",
                        nextLocalMeaning: "Okay, one chair is fifty thousand."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "beach-vendor-snack",
                momentType: .ask,
                scene: "The vendor offers simple snacks and drinks while you sit.",
                localLine: "Bạn muốn uống dừa hay ăn gì không?",
                localLineMeaning: "Would you like a coconut or something to eat?",
                userGoal: "Choose one easy beach snack or drink.",
                bestPageIDs: [
                    "viet-phrase-v900-food-drin-one-fresh-coconut-please",
                    "viet-family-food-one-portion",
                ],
                alternatePageIDs: [
                    "viet-family-food-one-portion",
                    "viet-thanks-khong-cam-on",
                ],
                recoveryPageIDs: [
                    "viet-family-food-menu",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "Có, tôi lấy cho bạn.",
                nextLocalMeaning: "Yes, I'll get it for you.",
                recoveryTitle: "If you are not hungry",
                recoveryBody: "Use no thank you, then keep the water or coconut order simple.",
                nextStepTitle: "Adjust the order",
                localScenarioContext: "beach_vendor_snack",
                scenarioResponseCopies: [
                    "viet-phrase-v900-food-drin-one-fresh-coconut-please": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi một trái dừa",
                        english: "One coconut, please"
                    ),
                    "viet-family-food-one-portion": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi một phần món này",
                        english: "One portion of this, please",
                        nextLocalLine: "Có, tôi lấy cho bạn.",
                        nextLocalMeaning: "Yes, I'll get it for you."
                    ),
                    "viet-thanks-khong-cam-on": PracticeScenarioPhraseTemplate(
                        vietnamese: "Không, cảm ơn",
                        english: "No, thank you",
                        nextLocalLine: "Không sao. Cần gì thêm thì gọi tôi nhé.",
                        nextLocalMeaning: "No problem. Let me know if you need anything else."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "beach-vendor-adjust",
                momentType: .ask,
                scene: "You see a snack with sauce and want to keep it mild.",
                localLine: "Món này hơi cay, được không?",
                localLineMeaning: "This is a little spicy, is that okay?",
                userGoal: "Ask for it not spicy or decline politely.",
                bestPageIDs: [
                    "viet-family-food-not-spicy",
                    "viet-thanks-khong-cam-on",
                ],
                alternatePageIDs: [
                    "viet-thanks-khong-cam-on",
                    "viet-family-food-has-peanuts",
                ],
                recoveryPageIDs: [
                    "viet-family-food-peanut-allergy",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "Được, tôi làm nhẹ cho bạn.",
                nextLocalMeaning: "Okay, I'll make it mild for you.",
                recoveryTitle: "If food safety matters",
                recoveryBody: "Use one clear ingredient or allergy phrase, then point to the food.",
                nextStepTitle: "Say thanks",
                localScenarioContext: "beach_vendor_adjust",
                scenarioResponseCopies: [
                    "viet-family-food-not-spicy": PracticeScenarioPhraseTemplate(
                        vietnamese: "Không cay nhé",
                        english: "Not spicy, please"
                    ),
                    "viet-thanks-khong-cam-on": PracticeScenarioPhraseTemplate(
                        vietnamese: "Không, cảm ơn",
                        english: "No, thank you",
                        nextLocalLine: "Không sao, tôi không làm món đó nhé.",
                        nextLocalMeaning: "No problem. I will not prepare that snack."
                    ),
                    "viet-family-food-has-peanuts": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cái này có đậu phộng không?",
                        english: "Does this have peanuts?",
                        nextLocalLine: "Có đậu phộng. Nếu bạn cần tránh, chọn món khác nhé.",
                        nextLocalMeaning: "Yes, it has peanuts. Choose another snack if you need to avoid them."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "beach-vendor-goodbye",
                momentType: .ask,
                scene: "You have water, shade, and the price is clear.",
                localLine: "Bạn muốn tính tiền luôn không?",
                localLineMeaning: "Would you like to pay now?",
                userGoal: "Pay, say thank you, and close the exchange.",
                bestPageIDs: [
                    "viet-family-food-pay-now",
                    "viet-family-money-how-much",
                ],
                alternatePageIDs: [
                    "viet-family-service-card",
                    "viet-family-transport-cash",
                ],
                recoveryPageIDs: [
                    "viet-family-money-how-much",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "Cảm ơn, chúc bạn đi biển vui.",
                nextLocalMeaning: "Thank you, enjoy the beach.",
                recoveryTitle: "If payment is unclear",
                recoveryBody: "Show the price and use one payment phrase at a time.",
                nextStepTitle: "Finish story",
                localScenarioContext: "beach_vendor_goodbye",
                scenarioResponseCopies: [
                    "viet-family-food-pay-now": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ, tính tiền giúp tôi",
                        english: "Yes, please let me pay"
                    ),
                    "viet-family-service-card": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi quẹt thẻ được không?",
                        english: "Can I pay by card?",
                        nextLocalLine: "Xin lỗi, chỉ nhận tiền mặt. Cảm ơn bạn, chúc bạn đi biển vui.",
                        nextLocalMeaning: "Sorry, cash only. Thank you, enjoy the beach."
                    ),
                    "viet-family-transport-cash": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi trả bằng tiền mặt",
                        english: "I'll pay cash",
                        nextLocalLine: "Dạ được, cảm ơn. Chúc bạn đi biển vui.",
                        nextLocalMeaning: "Cash is okay. Thank you, enjoy the beach."
                    ),
                ]
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .restaurantOrderingPayment,
        sceneTitle: "Restaurant ordering",
        sceneSetup: "Greet the server, choose a table, order, ask for help, and pay.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "restaurant-story-opening",
                momentType: .listen,
                scene: "You walk into a local restaurant and the server greets you at the door.",
                localLine: "Xin chào, mấy người ạ?",
                localLineMeaning: "Hello, how many people?",
                userGoal: "Ask for a table.",
                bestPageIDs: [
                    "viet-family-food-need-table",
                    "viet-family-vpe-one-item-please-cho-toi-mot-ban-cho-hai-nguoi",
                ],
                alternatePageIDs: [
                    "viet-phrase-v900-food-drin-a-table-for-one-please",
                    "viet-phrase-v900-food-drin-a-table-for-four-please",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-family-food-menu",
                ],
                nextLocalLine: "Dạ, mời bạn ngồi bàn này.",
                nextLocalMeaning: "Yes, please sit at this table.",
                recoveryTitle: "If you are unsure",
                recoveryBody: "Start with the table or menu phrase. Keep it short.",
                nextStepTitle: "Choose a table",
                localScenarioContext: "restaurant_story_opening",
                scenarioResponseCopies: [
                    "viet-family-food-need-table": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi bàn cho hai người nhé",
                        english: "A table for two, please"
                    ),
                    "viet-family-vpe-one-item-please-cho-toi-mot-ban-cho-hai-nguoi": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi bàn cho hai người",
                        english: "A table for two, please"
                    ),
                    "viet-phrase-v900-food-drin-a-table-for-one-please": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi bàn cho một người",
                        english: "A table for one, please",
                        nextLocalLine: "Dạ, mời bạn ngồi bàn này.",
                        nextLocalMeaning: "Yes, please sit at this table."
                    ),
                    "viet-phrase-v900-food-drin-a-table-for-four-please": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi bàn cho bốn người",
                        english: "A table for four, please",
                        nextLocalLine: "Dạ, mời bạn ngồi bàn này.",
                        nextLocalMeaning: "Yes, please sit at this table."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "restaurant-story-arrive",
                momentType: .ask,
                scene: "You are seated and need the menu before choosing food.",
                localLine: "Bạn muốn xem thực đơn không?",
                localLineMeaning: "Would you like to see the menu?",
                userGoal: "Ask for the menu or help choosing.",
                bestPageIDs: [
                    "viet-family-food-menu",
                    "viet-phrase-v900-food-drin-what-do-you-recommend",
                ],
                alternatePageIDs: [
                    "viet-phrase-v900-food-drin-what-do-you-recommend",
                    "viet-thanks-khong-cam-on",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-family-food-menu",
                ],
                nextLocalLine: "Dạ, đây là thực đơn. Món này dễ ăn.",
                nextLocalMeaning: "Yes, here is the menu. This dish is easy to eat.",
                recoveryTitle: "If you are unsure",
                recoveryBody: "Start with the menu or help phrase. Keep it short.",
                nextStepTitle: "The server is ready",
                localScenarioContext: "restaurant_story_arrive",
                scenarioResponseCopies: [
                    "viet-family-food-menu": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ, cho tôi xem thực đơn",
                        english: "Yes, the menu please"
                    ),
                    "viet-phrase-v900-food-drin-what-do-you-recommend": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn đề xuất món gì?",
                        english: "What do you recommend?",
                        nextLocalLine: "Món này dễ ăn. Tôi mang thực đơn cho bạn nhé.",
                        nextLocalMeaning: "This dish is easy to eat. I'll bring the menu for you."
                    ),
                    "viet-thanks-khong-cam-on": PracticeScenarioPhraseTemplate(
                        vietnamese: "Không, cảm ơn",
                        english: "No, thank you",
                        nextLocalLine: "Không sao. Khi nào sẵn sàng thì gọi tôi nhé.",
                        nextLocalMeaning: "No problem. Let me know when you are ready."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "restaurant-story-server-ready",
                momentType: .listen,
                scene: "The server comes back to the table.",
                localLine: "Bạn dùng gì?",
                localLineMeaning: "What would you like?",
                userGoal: "Choose what you want to do next.",
                bestPageIDs: [
                    "viet-family-food-one-portion",
                    "viet-family-v500-food-drin-id-like-a-b-nh-m-please",
                ],
                alternatePageIDs: [
                    "viet-family-v500-food-drin-id-like-a-b-nh-m-please",
                    "viet-phrase-v900-food-drin-what-do-you-recommend",
                    "viet-family-food-has-peanuts",
                ],
                alternateLimit: 3,
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-family-food-menu",
                ],
                nextLocalLine: "Được, bạn chờ một chút nhé.",
                nextLocalMeaning: "Okay, please wait here.",
                recoveryTitle: "If the menu is hard",
                recoveryBody: "Point to the item first, then play the short phrase.",
                nextStepTitle: "Check what is inside",
                localScenarioContext: "restaurant_story_server_ready",
                scenarioResponseCopies: [
                    "viet-family-food-one-portion": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ, cho tôi một phần món này",
                        english: "One portion of this, please"
                    ),
                    "viet-family-v500-food-drin-id-like-a-b-nh-m-please": PracticeScenarioPhraseTemplate(
                        vietnamese: "Làm ơn cho tôi một cái bánh mì",
                        english: "I'd like a banh mi, please",
                        nextLocalLine: "Được, bạn chờ một chút nhé.",
                        nextLocalMeaning: "Okay, please wait here."
                    ),
                    "viet-family-food-menu": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi xem thực đơn được không?",
                        english: "Can I see the menu?"
                    ),
                    "viet-phrase-v900-food-drin-what-do-you-recommend": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn đề xuất món gì?",
                        english: "What do you recommend?",
                        nextLocalLine: "Tôi đề xuất cao lầu, món này dễ thử.",
                        nextLocalMeaning: "I recommend cao lau; it is easy to try."
                    ),
                    "viet-family-food-has-peanuts": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cái này có đậu phộng không?",
                        english: "Does this have peanuts?",
                        nextLocalLine: "Để tôi hỏi bếp xem có đậu phộng không.",
                        nextLocalMeaning: "Let me check with the kitchen about peanuts."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "restaurant-story-ingredients",
                momentType: .ask,
                scene: "You want to avoid something in the dish.",
                localLine: "Bạn có ăn được cay không?",
                localLineMeaning: "Can you eat spicy food?",
                userGoal: "Ask for it not spicy, or check one ingredient.",
                bestPageIDs: [
                    "viet-family-food-not-spicy",
                    "viet-family-food-has-peanuts",
                ],
                alternatePageIDs: [
                    "viet-family-food-has-peanuts",
                    "viet-family-v900-food-drin-i-do-not-eat-pork",
                ],
                recoveryPageIDs: [
                    "viet-family-food-peanut-allergy",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "Được, tôi sẽ dặn bếp.",
                nextLocalMeaning: "Okay, I'll tell the kitchen.",
                recoveryTitle: "If allergies matter",
                recoveryBody: "Use the allergy phrase and show the ingredient if you can.",
                nextStepTitle: "Order a drink",
                localScenarioContext: "restaurant_story_ingredients",
                scenarioResponseCopies: [
                    "viet-family-food-not-spicy": PracticeScenarioPhraseTemplate(
                        vietnamese: "Không cay nhé",
                        english: "Not spicy, please"
                    ),
                    "viet-family-food-has-peanuts": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cái này có đậu phộng không?",
                        english: "Does this have peanuts?",
                        nextLocalLine: "Để tôi hỏi bếp xem có đậu phộng không.",
                        nextLocalMeaning: "Let me check with the kitchen about peanuts."
                    ),
                    "viet-family-v900-food-drin-i-do-not-eat-pork": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi không ăn thịt lợn",
                        english: "I do not eat pork",
                        nextLocalLine: "Để tôi hỏi bếp xem có thịt heo không.",
                        nextLocalMeaning: "Let me check with the kitchen about pork."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "restaurant-story-drink",
                momentType: .listen,
                scene: "The server asks about drinks.",
                localLine: "Bạn uống gì?",
                localLineMeaning: "What would you like to drink?",
                userGoal: "Pick a simple drink reply.",
                bestPageIDs: [
                    "viet-family-service-water",
                    "viet-phrase-v900-airp-bord-arri-where-can-i-buy-a-bottle-of-water",
                ],
                alternatePageIDs: [
                    "viet-family-v900-food-drin-one-iced-tea-please",
                    "viet-thanks-khong-cam-on",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-family-service-water",
                ],
                nextLocalLine: "Dạ, tôi lấy đồ uống cho bạn.",
                nextLocalMeaning: "Yes, I'll bring your drink.",
                recoveryTitle: "If you want to keep it easy",
                recoveryBody: "Water or iced tea are short, common replies.",
                nextStepTitle: "Pay",
                localScenarioContext: "restaurant_story_drink",
                scenarioResponseCopies: [
                    "viet-family-service-water": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi chai nước",
                        english: "A bottle of water please"
                    ),
                    "viet-family-v900-food-drin-one-iced-tea-please": PracticeScenarioPhraseTemplate(
                        vietnamese: "Làm ơn cho một ly trà đá",
                        english: "One iced tea, please",
                        nextLocalLine: "Dạ, tôi lấy đồ uống cho bạn.",
                        nextLocalMeaning: "Yes, I'll bring your drink."
                    ),
                    "viet-thanks-khong-cam-on": PracticeScenarioPhraseTemplate(
                        vietnamese: "Không, cảm ơn",
                        english: "No, thank you",
                        nextLocalLine: "Không sao, không lấy đồ uống nhé.",
                        nextLocalMeaning: "No problem, no drink."
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "restaurant-story-pay",
                momentType: .ask,
                scene: "You are finished and ready to pay.",
                localLine: "Bạn muốn thanh toán chưa?",
                localLineMeaning: "Would you like to pay now?",
                userGoal: "Ask for the bill or choose how to pay.",
                bestPageIDs: [
                    "viet-family-food-pay-now",
                    "viet-phrase-v900-food-drin-can-i-pay-the-bill-by-card",
                ],
                alternatePageIDs: [
                    "viet-family-service-card",
                    "viet-family-transport-cash",
                ],
                recoveryPageIDs: [
                    "viet-family-vpe-help-action-anh-chi-giup-toi-chia-hoa-don-duoc-khong",
                    "viet-phrase-help-4",
                ],
                nextLocalLine: "Tôi mang hóa đơn ra ngay.",
                nextLocalMeaning: "I will bring the bill right away.",
                recoveryTitle: "If payment gets unclear",
                recoveryBody: "Show the bill and use one payment phrase at a time.",
                nextStepTitle: "Say thanks",
                localScenarioContext: "restaurant_story_pay",
                scenarioResponseCopies: [
                    "viet-family-food-pay-now": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ, tính tiền giúp tôi",
                        english: "Yes, please bring the bill"
                    ),
                    "viet-phrase-v900-food-drin-can-i-pay-the-bill-by-card": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi thanh toán hóa đơn bằng thẻ được không?",
                        english: "Can I pay the bill by card?"
                    ),
                    "viet-family-service-card": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi quẹt thẻ được không?",
                        english: "Can I pay by card?",
                        nextLocalLine: "Dạ được, tôi mang hóa đơn ra ngay.",
                        nextLocalMeaning: "Yes, card is okay; I will bring the bill."
                    ),
                    "viet-family-transport-cash": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi trả bằng tiền mặt",
                        english: "I'll pay cash",
                        nextLocalLine: "Dạ được, tôi mang hóa đơn ra ngay.",
                        nextLocalMeaning: "Cash is okay; I will bring the bill."
                    ),
                ]
            ),
            messageGoodbyeStep(
                id: "restaurant-story-goodbye",
                scene: "You have paid and are leaving the table.",
                localLine: "Cảm ơn bạn.",
                localLineMeaning: "Thank you.",
                userGoal: "Say goodbye before you leave.",
                nextLocalLine: "Tạm biệt, hẹn gặp lại.",
                nextLocalMeaning: "Goodbye, see you again.",
                localScenarioContext: "restaurant_story_goodbye"
            ),
        ]
    ),
] + additionalMessageScenarioTemplates()).sorted {
    scenarioTemplateSortRank($0.id) < scenarioTemplateSortRank($1.id)
}

private func scenarioTemplateSortRank(_ id: PracticeScenarioID) -> Int {
    PracticeScenarioID.allCases.firstIndex(of: id) ?? Int.max
}

private func additionalMessageScenarioTemplates() -> [PracticeScenarioTemplate] {
    [
        PracticeScenarioTemplate(
            id: .airportWifiPower,
            sceneTitle: "Airport Wi-Fi",
            sceneSetup: "Get online, charge your phone, ask the information desk, and find pickup before leaving arrivals.",
            steps: [
                messageScenarioStep(
                    id: "airport-wifi-opening",
                    momentType: .listen,
                    scene: "You are still in arrivals and your phone needs internet before you leave.",
                    localLine: "Xin chào, tôi có thể giúp gì cho bạn?",
                    localLineMeaning: "Hello, how can I help you?",
                    userGoal: "Ask for airport Wi-Fi first.",
                    best: messageReply(
                        "viet-family-v900-airp-bord-arri-where-can-i-get-airport-wi-fi",
                        vietnamese: "Tôi có thể lấy Wi-Fi sân bay ở đâu?",
                        english: "Where can I get airport Wi-Fi?",
                        nextLocalLine: "Wi-Fi miễn phí ở quầy thông tin, tôi chỉ bạn nhé.",
                        nextLocalMeaning: "Free Wi-Fi is at the information desk; I will show you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-airp-bord-arri-where-can-i-charge-my-phone",
                            vietnamese: "Tôi có thể sạc điện thoại ở đâu?",
                            english: "Where can I charge my phone?",
                            nextLocalLine: "Ổ sạc ở cạnh quầy thông tin.",
                            nextLocalMeaning: "The charging outlet is beside the information desk."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-can-you-help-me",
                            vietnamese: "Bạn giúp tôi được không?",
                            english: "Can you help me?",
                            nextLocalLine: "Được, bạn cần Wi-Fi hay sạc điện thoại?",
                            nextLocalMeaning: "Yes, do you need Wi-Fi or phone charging?"
                        ),
                    ],
                    nextStepTitle: "Ask the desk",
                    localScenarioContext: "airport_wifi_opening"
                ),
                messageScenarioStep(
                    id: "airport-wifi-desk",
                    scene: "You need the right counter instead of wandering around the hall.",
                    localLine: "Bạn muốn đến quầy thông tin không?",
                    localLineMeaning: "Do you want to go to the information desk?",
                    userGoal: "Ask where the information desk is.",
                    best: messageReply(
                        "viet-family-v900-airp-bord-arri-where-is-the-information-desk",
                        vietnamese: "Bàn thông tin ở đâu?",
                        english: "Where is the information desk?",
                        nextLocalLine: "Bàn thông tin ở giữa sảnh.",
                        nextLocalMeaning: "The information desk is in the middle of the hall."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-directions-understand-now",
                            vietnamese: "Cảm ơn, tôi hiểu rồi",
                            english: "Thanks, I understand now",
                            nextLocalLine: "Không có gì",
                            nextLocalMeaning: "No problem."
                        ),
                        messageReply(
                            "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way",
                            vietnamese: "Bạn nói đơn giản hơn được không?",
                            english: "Can you say it in a simpler way?",
                            nextLocalLine: "Quầy thông tin ở giữa sảnh.",
                            nextLocalMeaning: "The information desk is in the middle of the hall."
                        ),
                    ],
                    nextStepTitle: "Charge phone",
                    localScenarioContext: "airport_wifi_desk"
                ),
                messageScenarioStep(
                    id: "airport-wifi-charge",
                    scene: "Your battery is low and you need a safe place to plug in.",
                    localLine: "Điện thoại của bạn sắp hết pin à?",
                    localLineMeaning: "Is your phone almost out of battery?",
                    userGoal: "Ask where to charge your phone.",
                    best: messageReply(
                        "viet-family-v900-airp-bord-arri-where-can-i-charge-my-phone",
                        vietnamese: "Tôi có thể sạc điện thoại ở đâu?",
                        english: "Where can I charge my phone?",
                        nextLocalLine: "Ổ sạc ở cạnh quầy thông tin.",
                        nextLocalMeaning: "The charging outlet is beside the information desk."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-phone-data-not-working",
                            vietnamese: "Dữ liệu di động không hoạt động",
                            english: "Mobile data is not working",
                            nextLocalLine: "Bạn thử dùng Wi-Fi sân bay trước nhé.",
                            nextLocalMeaning: "Try using the airport Wi-Fi first."
                        ),
                        messageReply(
                            "viet-family-v500-phon-inte-powe-my-phone-is-almost-dead",
                            vietnamese: "Điện thoại của tôi sắp hết pin",
                            english: "My phone is almost dead",
                            nextLocalLine: "Bạn có thể sạc ở cạnh quầy thông tin.",
                            nextLocalMeaning: "You can charge beside the information desk."
                        ),
                    ],
                    nextStepTitle: "Find pickup",
                    localScenarioContext: "airport_wifi_charge"
                ),
                messageScenarioStep(
                    id: "airport-wifi-pickup",
                    scene: "Now that the phone works, you need the pickup point.",
                    localLine: "Bạn đặt Grab hay taxi?",
                    localLineMeaning: "Did you book Grab or a taxi?",
                    userGoal: "Ask where to meet the driver.",
                    best: messageReply(
                        "viet-family-v900-airp-bord-arri-where-is-the-grab-pickup-point",
                        vietnamese: "Điểm đón Grab ở đâu?",
                        english: "Where is the Grab pickup point?",
                        nextLocalLine: "Đi thẳng ra cửa số 3 nhé.",
                        nextLocalMeaning: "Go straight to Gate 3."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-airp-bord-arri-where-do-i-meet-the-driver",
                            vietnamese: "Tôi gặp tài xế ở đâu?",
                            english: "Where do I meet the driver?",
                            nextLocalLine: "Bạn gặp tài xế ở cửa số 3.",
                            nextLocalMeaning: "Meet the driver at Gate 3."
                        ),
                        messageReply(
                            "viet-family-v900-airp-bord-arri-please-call-this-driver-for-me",
                            vietnamese: "Gọi tài xế này giúp tôi",
                            english: "Please call this driver for me",
                            nextLocalLine: "Được, cho tôi xem số điện thoại tài xế.",
                            nextLocalMeaning: "Okay, show me the driver's phone number."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "airport_wifi_pickup"
                ),
                messageScenarioStep(
                    id: "airport-wifi-final-help",
                    scene: "You want to confirm you are ready to leave the airport.",
                    localLine: "Bạn cần gì thêm trước khi ra ngoài không?",
                    localLineMeaning: "Do you need anything else before going outside?",
                    userGoal: "Ask for one last simple help phrase.",
                    best: messageReply(
                        "viet-family-v500-prob-help-can-you-help-me",
                        vietnamese: "Bạn giúp tôi được không?",
                        english: "Can you help me?",
                        nextLocalLine: "Được, bạn cần tôi chỉ đường hay gọi tài xế?",
                        nextLocalMeaning: "Yes, do you need directions or help calling the driver?"
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-unde-repa-can-you-say-it-in-a-simpler-way",
                            vietnamese: "Bạn nói đơn giản hơn được không?",
                            english: "Can you say it in a simpler way?",
                            nextLocalLine: "Được, tôi nói chậm hơn.",
                            nextLocalMeaning: "Yes, I will speak more slowly."
                        ),
                        messageReply(
                            "viet-family-polite-thank-you",
                            vietnamese: "Cảm ơn",
                            english: "Thank you",
                            nextLocalLine: "Không có gì, chúc bạn đi an toàn.",
                            nextLocalMeaning: "You are welcome, travel safely."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "airport_wifi_final_help"
                ),
                messageGoodbyeStep(
                    id: "airport-wifi-goodbye",
                    scene: "Your phone is working and you know where to meet the driver.",
                    localLine: "Bạn đi cửa số 3 nhé.",
                    localLineMeaning: "Go to Gate 3.",
                    nextLocalLine: "Không có gì, chúc bạn đi an toàn.",
                    nextLocalMeaning: "You are welcome, travel safely.",
                    localScenarioContext: "airport_wifi_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .hotelRoomHelp,
            sceneTitle: "Room help",
            sceneSetup: "Keep one front-desk conversation going while the hotel fixes a room problem.",
            steps: [
                messageScenarioStep(
                    id: "hotel-room-opening",
                    momentType: .listen,
                    scene: "You come back to the hotel desk because something in the room is not working.",
                    localLine: "Xin chào, tôi có thể giúp gì cho bạn?",
                    localLineMeaning: "Hello, how can I help you?",
                    userGoal: "Start with the key-card problem.",
                    best: messageReply(
                        "viet-family-hotel-key-card",
                        vietnamese: "Thẻ phòng không dùng được",
                        english: "The key card is not working",
                        nextLocalLine: "Được, tôi làm thẻ phòng mới cho bạn ngay.",
                        nextLocalMeaning: "Okay, I will make a new key card for you now."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-hote-acco-the-door-does-not-lock",
                            vietnamese: "Cửa không khóa",
                            english: "The door does not lock",
                            nextLocalLine: "Xin lỗi, tôi sẽ cho nhân viên lên kiểm tra cửa ngay.",
                            nextLocalMeaning: "Sorry, I will send staff to check the door right away."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-i-lost-my-room-key",
                            vietnamese: "Tôi làm mất chìa khóa phòng",
                            english: "I lost my room key",
                            nextLocalLine: "Tôi hiểu rồi. Tôi sẽ làm chìa khóa mới sau khi kiểm tra đặt phòng.",
                            nextLocalMeaning: "I understand. I will make a new key after checking the booking."
                        ),
                    ],
                    nextStepTitle: "Try the key card",
                    localScenarioContext: "hotel_room_opening"
                ),
                messageScenarioStep(
                    id: "hotel-room-key-card-check",
                    momentType: .ask,
                    scene: "The front desk has made a new key card and asks you to try it before moving on.",
                    localLine: "Tôi đã làm thẻ mới. Bạn thử lại được không?",
                    localLineMeaning: "I made a new key card. Can you try it again?",
                    userGoal: "Acknowledge the plan, or ask for staff or a room change if the card still fails.",
                    best: messageReply(
                        "viet-family-polite-acknowledge",
                        vietnamese: "Dạ",
                        english: "Okay, I will try it",
                        nextLocalLine: "Cảm ơn. Nếu thẻ vẫn không mở, tôi cho nhân viên lên ngay.",
                        nextLocalMeaning: "Thank you. If the card still does not open, I will send staff up right away."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-hote-acco-can-i-change-rooms",
                            vietnamese: "Tôi đổi phòng được không?",
                            english: "Can I change rooms?",
                            nextLocalLine: "Tôi sẽ kiểm tra phòng trống cho bạn.",
                            nextLocalMeaning: "I will check available rooms for you."
                        ),
                        messageReply(
                            "viet-family-v500-hote-acco-can-someone-come-fix-it",
                            vietnamese: "Có ai lên sửa giúp tôi được không?",
                            english: "Can someone come fix it?",
                            nextLocalLine: "Được, tôi cho nhân viên lên kiểm tra thẻ và cửa.",
                            nextLocalMeaning: "Yes, I will send staff up to check the card and the door."
                        ),
                    ],
                    nextStepTitle: "Check the room",
                    localScenarioContext: "hotel_room_key_card_check"
                ),
                messageScenarioStep(
                    id: "hotel-room-ac",
                    momentType: .ask,
                    scene: "The key-card fix is underway, and the desk checks whether the room itself needs attention.",
                    localLine: "Nhân viên sẽ kiểm tra thẻ phòng. Trong phòng còn gì không ổn không?",
                    localLineMeaning: "Staff will check the key card. Is anything else in the room not okay?",
                    userGoal: "Say the AC is not working.",
                    best: messageReply(
                        "viet-family-hotel-aircon-broken",
                        vietnamese: "Máy lạnh không hoạt động",
                        english: "The AC is not working",
                        nextLocalLine: "Tôi sẽ cho người lên kiểm tra ngay.",
                        nextLocalMeaning: "I will send someone up to check it now."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-hotel-room-hot",
                            vietnamese: "Phòng nóng quá",
                            english: "The room is too hot",
                            nextLocalLine: "Tôi hiểu rồi. Tôi sẽ kiểm tra máy lạnh.",
                            nextLocalMeaning: "I understand. I will check the AC."
                        ),
                        messageReply(
                            "viet-family-v500-hote-acco-the-electricity-is-out",
                            vietnamese: "Phòng tôi mất điện",
                            english: "The electricity is out",
                            nextLocalLine: "Xin lỗi, tôi sẽ báo kỹ thuật ngay.",
                            nextLocalMeaning: "Sorry, I will tell maintenance right away."
                        ),
                    ],
                    nextStepTitle: "Ask for a repair",
                    localScenarioContext: "hotel_room_ac"
                ),
                messageScenarioStep(
                    id: "hotel-room-bathroom",
                    momentType: .ask,
                    scene: "The desk is collecting the room details before sending maintenance upstairs.",
                    localLine: "Tôi sẽ báo kỹ thuật. Bạn cần nói thêm vấn đề nào không?",
                    localLineMeaning: "I will tell maintenance. Do you need to add any other problem?",
                    userGoal: "Name the bathroom or door problem clearly.",
                    best: messageReply(
                        "viet-family-v500-hote-acco-the-toilet-is-not-working",
                        vietnamese: "Nhà vệ sinh không hoạt động",
                        english: "The toilet is not working",
                        nextLocalLine: "Xin lỗi, tôi sẽ báo kỹ thuật kiểm tra ngay.",
                        nextLocalMeaning: "Sorry, I will ask maintenance to check it right away."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-hote-acco-the-door-does-not-lock",
                            vietnamese: "Cửa không khóa",
                            english: "The door does not lock",
                            nextLocalLine: "Xin lỗi, tôi sẽ kiểm tra khóa cửa ngay.",
                            nextLocalMeaning: "Sorry, I will check the door lock right away."
                        ),
                        messageReply(
                            "viet-family-v900-hote-acco-the-room-smells-like-smoke",
                            vietnamese: "Căn phòng có mùi khói",
                            english: "The room smells like smoke",
                            nextLocalLine: "Tôi hiểu rồi. Tôi sẽ kiểm tra phòng khác cho bạn.",
                            nextLocalMeaning: "I understand. I will check another room for you."
                        ),
                    ],
                    recoveryPageIDs: [
                        "viet-family-v500-hote-acco-can-someone-come-fix-it",
                        "viet-family-v500-hote-acco-can-i-change-rooms",
                    ],
                    recoveryTitle: "If the room issue affects safety",
                    recoveryBody: "Name the specific problem first, then ask for staff to come up.",
                    nextStepTitle: "Ask for a repair",
                    localScenarioContext: "hotel_room_bathroom"
                ),
                messageScenarioStep(
                    id: "hotel-room-fix",
                    momentType: .ask,
                    scene: "The desk has the problem list and is ready to choose the next action.",
                    localLine: "Tôi đã ghi lại rồi. Bạn muốn nhân viên lên phòng hay đổi phòng?",
                    localLineMeaning: "I wrote that down. Do you want staff to come up or to change rooms?",
                    userGoal: "Ask someone to come fix it or change rooms.",
                    best: messageReply(
                        "viet-family-v500-hote-acco-can-someone-come-fix-it",
                        vietnamese: "Có ai lên sửa giúp tôi được không?",
                        english: "Can someone come fix it?",
                        nextLocalLine: "Được, nhân viên sẽ lên trong mười phút.",
                        nextLocalMeaning: "Yes, staff will come up in ten minutes."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-hote-acco-can-i-change-rooms",
                            vietnamese: "Tôi đổi phòng được không?",
                            english: "Can I change rooms?",
                            nextLocalLine: "Tôi sẽ kiểm tra phòng trống cho bạn.",
                            nextLocalMeaning: "I will check available rooms for you."
                        ),
                        messageReply(
                            "viet-family-v500-hote-acco-the-room-is-not-clean",
                            vietnamese: "Phòng chưa sạch",
                            english: "The room is not clean",
                            nextLocalLine: "Xin lỗi, tôi sẽ cho người dọn lại ngay.",
                            nextLocalMeaning: "Sorry, I will have someone clean it again now."
                        ),
                    ],
                    nextStepTitle: "Ask for supplies",
                    localScenarioContext: "hotel_room_fix"
                ),
                messageScenarioStep(
                    id: "hotel-room-supplies",
                    momentType: .ask,
                    scene: "While the staff is helping, you ask for one useful room item.",
                    localLine: "Bạn cần thêm đồ dùng gì trong phòng không?",
                    localLineMeaning: "Do you need any more room supplies?",
                    userGoal: "Ask for more drinking water or soap.",
                    best: messageReply(
                        "viet-family-hotel-more-supplies",
                        vietnamese: "Cho tôi thêm đồ dùng trong phòng",
                        english: "Can I have more room supplies?",
                        nextLocalLine: "Được, tôi sẽ mang lên phòng bạn.",
                        nextLocalMeaning: "Yes, I will bring them to your room."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-hote-acco-can-i-have-more-soap",
                            vietnamese: "Cho tôi thêm xà phòng được không?",
                            english: "Can I have more soap?",
                            nextLocalLine: "Được, tôi sẽ mang thêm xà phòng.",
                            nextLocalMeaning: "Yes, I will bring more soap."
                        ),
                        messageReply(
                            "viet-family-v900-hote-acco-can-i-have-more-drinking-water",
                            vietnamese: "Cho tôi thêm nước uống được không?",
                            english: "Can I have more drinking water?",
                            nextLocalLine: "Được, tôi sẽ mang thêm nước uống.",
                            nextLocalMeaning: "Yes, I will bring more drinking water."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "hotel_room_supplies"
                ),
                messageGoodbyeStep(
                    id: "hotel-room-goodbye",
                    scene: "The front desk has a plan for your room problem.",
                    localLine: "Nhân viên sẽ lên hỗ trợ bạn ngay.",
                    localLineMeaning: "Staff will come help you right away.",
                    nextLocalLine: "Không có gì, chúc bạn nghỉ ngơi thoải mái.",
                    nextLocalMeaning: "You are welcome. Rest comfortably.",
                    localScenarioContext: "hotel_room_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .hotelBagsTaxi,
            sceneTitle: "Bags and taxi",
            sceneSetup: "Use the hotel desk for luggage storage, pickup timing, taxi help, and airport travel.",
            steps: [
                messageScenarioStep(
                    id: "hotel-bags-opening",
                    momentType: .listen,
                    scene: "You are checking out but want to leave bags at the hotel for a few hours.",
                    localLine: "Xin chào, bạn muốn gửi hành lý phải không?",
                    localLineMeaning: "Hello, would you like to leave your luggage?",
                    userGoal: "Ask the hotel to hold your bags.",
                    best: messageReply(
                        "viet-family-hotel-luggage",
                        vietnamese: "Tôi gửi hành lý được không?",
                        english: "Can I leave my luggage here?",
                        nextLocalLine: "Được, bạn có thể gửi hành lý ở quầy lễ tân.",
                        nextLocalMeaning: "Yes, you can leave your luggage at the front desk."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-hote-acco-can-i-leave-my-bags-until-check-in",
                            vietnamese: "Tôi gửi hành lý đến giờ nhận phòng được không?",
                            english: "Can I leave my bags until check-in?",
                            nextLocalLine: "Được, chúng tôi sẽ giữ hành lý cho bạn.",
                            nextLocalMeaning: "Yes, we will keep your bags for you."
                        ),
                        messageReply(
                            "viet-family-v900-hote-acco-can-you-store-my-luggage-after-check-out",
                            vietnamese: "Bạn có thể gửi hành lý của tôi sau khi trả phòng không?",
                            english: "Can you store my luggage after check-out?",
                            nextLocalLine: "Được, để hành lý ở quầy này nhé.",
                            nextLocalMeaning: "Yes, leave your luggage at this counter."
                        ),
                    ],
                    nextStepTitle: "Confirm pickup",
                    localScenarioContext: "hotel_bags_opening"
                ),
                messageScenarioStep(
                    id: "hotel-bags-pickup",
                    momentType: .ask,
                    scene: "You need to know where to retrieve the bags later.",
                    localLine: "Bạn cần biết chỗ lấy hành lý sau không?",
                    localLineMeaning: "Do you need to know where to pick up your luggage later?",
                    userGoal: "Ask where to pick the bags up later.",
                    best: messageReply(
                        "viet-family-v900-hote-acco-where-can-i-pick-up-my-luggage",
                        vietnamese: "Tôi lấy hành lý ở đâu?",
                        english: "Where can I pick up my luggage?",
                        nextLocalLine: "Bạn lấy hành lý ở quầy lễ tân này.",
                        nextLocalMeaning: "You can pick up your luggage at this front desk."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-time-what-time",
                            vietnamese: "Mấy giờ được?",
                            english: "What time is okay?",
                            nextLocalLine: "Bạn có thể quay lại trước chín giờ tối.",
                            nextLocalMeaning: "You can come back before nine tonight."
                        ),
                        messageReply(
                            "viet-family-v500-loca-serv-ever-task-how-long-will-it-take",
                            vietnamese: "Sẽ mất bao lâu?",
                            english: "How long will it take?",
                            nextLocalLine: "Lấy hành lý rất nhanh, chỉ vài phút.",
                            nextLocalMeaning: "Picking up the luggage is quick, just a few minutes."
                        ),
                    ],
                    nextStepTitle: "Ask for the invoice",
                    localScenarioContext: "hotel_bags_pickup"
                ),
                messageScenarioStep(
                    id: "hotel-bags-invoice",
                    momentType: .ask,
                    scene: "You want your checkout paperwork before leaving.",
                    localLine: "Bạn cần hóa đơn không?",
                    localLineMeaning: "Do you need an invoice?",
                    userGoal: "Ask for the hotel invoice or receipt.",
                    best: messageReply(
                        "viet-family-v900-hote-acco-can-you-email-me-the-invoice",
                        vietnamese: "Bạn gửi hóa đơn qua email cho tôi được không?",
                        english: "Can you email me the invoice?",
                        nextLocalLine: "Được, cho tôi địa chỉ email của bạn.",
                        nextLocalMeaning: "Yes, please give me your email address."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-service-receipt",
                            vietnamese: "Cho tôi hóa đơn",
                            english: "Can I have a receipt?",
                            nextLocalLine: "Được, tôi in hóa đơn cho bạn.",
                            nextLocalMeaning: "Yes, I will print the receipt for you."
                        ),
                        messageReply(
                            "viet-family-v500-hote-acco-can-i-pay-now",
                            vietnamese: "Tôi thanh toán bây giờ được không?",
                            english: "Can I pay now?",
                            nextLocalLine: "Được, tôi sẽ kiểm tra tổng tiền.",
                            nextLocalMeaning: "Yes, I will check the total."
                        ),
                    ],
                    nextStepTitle: "Arrange a taxi",
                    localScenarioContext: "hotel_bags_invoice"
                ),
                messageScenarioStep(
                    id: "hotel-bags-taxi",
                    momentType: .ask,
                    scene: "You need a car from the hotel after checkout.",
                    localLine: "Bạn cần xe đi đâu?",
                    localLineMeaning: "Where do you need a car to go?",
                    userGoal: "Ask the hotel to arrange a taxi.",
                    best: messageReply(
                        "viet-family-v900-hote-acco-can-you-arrange-a-taxi-for-me",
                        vietnamese: "Bạn đặt taxi giúp tôi được không?",
                        english: "Can you arrange a taxi for me?",
                        nextLocalLine: "Được, taxi sẽ đến trước cửa khách sạn.",
                        nextLocalMeaning: "Yes, the taxi will come to the hotel entrance."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-hotel-call-taxi",
                            vietnamese: "Gọi taxi giúp tôi",
                            english: "Please call a taxi for me",
                            nextLocalLine: "Được, tôi gọi taxi ngay.",
                            nextLocalMeaning: "Yes, I will call a taxi now."
                        ),
                        messageReply(
                            "viet-family-v900-hote-acco-can-you-book-a-car-to-the-airport",
                            vietnamese: "Bạn đặt xe ra sân bay giúp tôi được không?",
                            english: "Can you book a car to the airport?",
                            nextLocalLine: "Được, tôi đặt xe ra sân bay cho bạn.",
                            nextLocalMeaning: "Yes, I will book a car to the airport for you."
                        ),
                    ],
                    nextStepTitle: "Show the address",
                    localScenarioContext: "hotel_bags_taxi"
                ),
                messageScenarioStep(
                    id: "hotel-bags-address",
                    momentType: .ask,
                    scene: "The front desk asks where the driver should take you.",
                    localLine: "Bạn cho tôi xem địa chỉ được không?",
                    localLineMeaning: "Can you show me the address?",
                    userGoal: "Show the address or ask the desk to write it.",
                    best: messageReply(
                        "viet-family-v900-tran-please-take-me-to-this-address",
                        vietnamese: "Làm ơn đưa tôi đến địa chỉ này",
                        english: "Please take me to this address",
                        nextLocalLine: "Được, tôi sẽ đưa địa chỉ này cho tài xế.",
                        nextLocalMeaning: "Okay, I will give this address to the driver."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-unde-repa-can-you-write-the-address",
                            vietnamese: "Bạn có thể viết địa chỉ được không?",
                            english: "Can you write the address?",
                            nextLocalLine: "Được, tôi sẽ viết địa chỉ bằng tiếng Việt.",
                            nextLocalMeaning: "Yes, I will write the address in Vietnamese."
                        ),
                        messageReply(
                            "viet-family-v500-dire-navi-can-you-help-me-get-back-to-my-hotel",
                            vietnamese: "Bạn giúp tôi quay lại khách sạn được không?",
                            english: "Can you help me get back to my hotel?",
                            nextLocalLine: "Được, tôi sẽ ghi tên khách sạn cho tài xế.",
                            nextLocalMeaning: "Yes, I will write the hotel name for the driver."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "hotel_bags_address"
                ),
                messageGoodbyeStep(
                    id: "hotel-bags-goodbye",
                    scene: "Your luggage is stored and the hotel has arranged the ride.",
                    localLine: "Xe sẽ đến trong năm phút.",
                    localLineMeaning: "The car will arrive in five minutes.",
                    nextLocalLine: "Không có gì, chúc bạn đi an toàn.",
                    nextLocalMeaning: "You are welcome, travel safely.",
                    localScenarioContext: "hotel_bags_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .hotelWifiCheckout,
            sceneTitle: "Hotel Wi-Fi",
            sceneSetup: "Ask the front desk for Wi-Fi, checkout time, a receipt, luggage help, and a polite close.",
            steps: [
                messageScenarioStep(
                    id: "hotel-wifi-opening",
                    momentType: .listen,
                    scene: "You are at the front desk after check-in and need the basic room details.",
                    localLine: "Xin chào, bạn cần hỏi Wi-Fi hay giờ trả phòng không?",
                    localLineMeaning: "Do you need to ask about Wi-Fi or checkout time?",
                    userGoal: "Ask for the Wi-Fi password first.",
                    best: messageReply(
                        "viet-family-phone-wifi-password",
                        vietnamese: "Mật khẩu Wi-Fi là gì?",
                        english: "What is the Wi-Fi password?",
                        nextLocalLine: "Mật khẩu ở trên thẻ phòng.",
                        nextLocalMeaning: "The password is on the room card."
                    ),
                    alternates: [
                        messageReply(
                            "viet-phrase-phone-wifi-common",
                            vietnamese: "Pass Wi-Fi là gì?",
                            english: "What is the Wi-Fi pass?",
                            nextLocalLine: "Pass Wi-Fi ở trên thẻ phòng.",
                            nextLocalMeaning: "The Wi-Fi password is on the room card."
                        ),
                        messageReply(
                            "viet-family-hotel-checkout-time",
                            vietnamese: "Mấy giờ trả phòng?",
                            english: "What time is check-out?",
                            nextLocalLine: "Trả phòng lúc mười hai giờ trưa.",
                            nextLocalMeaning: "Check-out is at noon."
                        ),
                    ],
                    nextStepTitle: "Fix Wi-Fi",
                    localScenarioContext: "hotel_wifi_opening"
                ),
                messageScenarioStep(
                    id: "hotel-wifi-problem",
                    scene: "You try the password, but the room still will not connect.",
                    localLine: "Wi-Fi trong phòng dùng được chưa?",
                    localLineMeaning: "Is the room Wi-Fi working yet?",
                    userGoal: "Say the Wi-Fi is not working.",
                    best: messageReply(
                        "viet-family-v900-hote-acco-the-wi-fi-is-not-working-in-my-room",
                        vietnamese: "Wi-Fi không hoạt động trong phòng tôi",
                        english: "The Wi-Fi is not working in my room",
                        nextLocalLine: "Xin lỗi, tôi sẽ nhờ kỹ thuật kiểm tra.",
                        nextLocalMeaning: "Sorry, I will ask maintenance to check it."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-phone-password-not-working",
                            vietnamese: "Mật khẩu Wi-Fi không hoạt động",
                            english: "The Wi-Fi password is not working",
                            nextLocalLine: "Được, tôi sẽ kiểm tra mật khẩu cho bạn.",
                            nextLocalMeaning: "Okay, I will check the password for you."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-can-you-help-me",
                            vietnamese: "Bạn giúp tôi được không?",
                            english: "Can you help me?",
                            nextLocalLine: "Được, tôi kiểm tra Wi-Fi giúp bạn.",
                            nextLocalMeaning: "Yes, I will help check the Wi-Fi."
                        ),
                    ],
                    nextStepTitle: "Ask checkout",
                    localScenarioContext: "hotel_wifi_problem"
                ),
                messageScenarioStep(
                    id: "hotel-wifi-checkout",
                    scene: "The desk has helped with Wi-Fi, and you want tomorrow's checkout time.",
                    localLine: "Bạn cần biết giờ trả phòng không?",
                    localLineMeaning: "Do you need the check-out time?",
                    userGoal: "Ask what time check-out is.",
                    best: messageReply(
                        "viet-family-hotel-checkout-time",
                        vietnamese: "Mấy giờ trả phòng?",
                        english: "What time is check-out?",
                        nextLocalLine: "Trả phòng lúc mười hai giờ trưa.",
                        nextLocalMeaning: "Check-out is at noon."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-time-what-time",
                            vietnamese: "Mấy giờ được?",
                            english: "What time is okay?",
                            nextLocalLine: "Trước mười hai giờ trưa là được.",
                            nextLocalMeaning: "Before noon is okay."
                        ),
                        messageReply(
                            "viet-family-v900-hote-acco-can-i-get-late-check-out",
                            vietnamese: "Tôi trả phòng trễ được không?",
                            english: "Can I get late check-out?",
                            nextLocalLine: "Tôi sẽ kiểm tra phòng trống cho bạn.",
                            nextLocalMeaning: "I will check room availability for you."
                        ),
                    ],
                    nextStepTitle: "Ask for receipt",
                    localScenarioContext: "hotel_wifi_checkout"
                ),
                messageScenarioStep(
                    id: "hotel-wifi-receipt",
                    scene: "Before leaving the front desk, you need a receipt or invoice.",
                    localLine: "Bạn cần hóa đơn không?",
                    localLineMeaning: "Do you need a receipt?",
                    userGoal: "Ask for a receipt.",
                    best: messageReply(
                        "viet-family-service-receipt",
                        vietnamese: "Cho tôi hóa đơn",
                        english: "Receipt, please",
                        nextLocalLine: "Được, tôi in hóa đơn cho bạn.",
                        nextLocalMeaning: "Yes, I will print the receipt for you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-hote-acco-can-you-email-me-the-invoice",
                            vietnamese: "Bạn gửi hóa đơn qua email cho tôi được không?",
                            english: "Can you email me the invoice?",
                            nextLocalLine: "Được, cho tôi địa chỉ email của bạn.",
                            nextLocalMeaning: "Yes, please give me your email address."
                        ),
                        messageReply(
                            "viet-family-v500-mone-numb-pric-can-i-have-a-receipt",
                            vietnamese: "Cho tôi hóa đơn được không?",
                            english: "Can I have a receipt?",
                            nextLocalLine: "Được, tôi in hóa đơn ngay.",
                            nextLocalMeaning: "Yes, I will print the receipt now."
                        ),
                    ],
                    nextStepTitle: "Hold bags",
                    localScenarioContext: "hotel_wifi_receipt"
                ),
                messageScenarioStep(
                    id: "hotel-wifi-bags",
                    scene: "You may leave the hotel for a while after checkout.",
                    localLine: "Bạn có muốn gửi hành lý không?",
                    localLineMeaning: "Would you like to leave your luggage?",
                    userGoal: "Ask the desk to hold your bags.",
                    best: messageReply(
                        "viet-family-hotel-luggage",
                        vietnamese: "Tôi gửi hành lý được không?",
                        english: "Can I leave my luggage here?",
                        nextLocalLine: "Được, bạn gửi hành lý ở quầy lễ tân.",
                        nextLocalMeaning: "Yes, leave your luggage at the front desk."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-hote-acco-where-can-i-pick-up-my-luggage",
                            vietnamese: "Tôi lấy hành lý ở đâu?",
                            english: "Where can I pick up my luggage?",
                            nextLocalLine: "Bạn lấy hành lý ở quầy này.",
                            nextLocalMeaning: "Pick up the luggage at this counter."
                        ),
                        messageReply(
                            "viet-family-v900-hote-acco-can-you-store-my-luggage-after-check-out",
                            vietnamese: "Bạn gửi hành lý của tôi sau khi trả phòng được không?",
                            english: "Can you store my luggage after check-out?",
                            nextLocalLine: "Được, chúng tôi sẽ giữ hành lý cho bạn.",
                            nextLocalMeaning: "Yes, we will keep your luggage for you."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "hotel_wifi_bags"
                ),
                messageGoodbyeStep(
                    id: "hotel-wifi-goodbye",
                    scene: "You have the Wi-Fi, checkout time, and luggage plan.",
                    localLine: "Bạn cần gì thêm không?",
                    localLineMeaning: "Do you need anything else?",
                    nextLocalLine: "Không có gì, chúc bạn nghỉ vui.",
                    nextLocalMeaning: "You are welcome, enjoy your stay.",
                    localScenarioContext: "hotel_wifi_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .foodAllergyHelp,
            sceneTitle: "Cafe and allergy help",
            sceneSetup: "Order coffee or a simple dish, then check peanuts, spice, and safer ingredients before paying.",
            steps: [
                messageScenarioStep(
                    id: "food-allergy-opening",
                    momentType: .listen,
                    scene: "You walk up to a small cafe and want an easy first order.",
                    localLine: "Xin chào, bạn muốn uống gì?",
                    localLineMeaning: "Hello, what would you like to drink?",
                    userGoal: "Order iced milk coffee.",
                    best: messageReply(
                        "viet-family-food-coffee-milk",
                        vietnamese: "Cho tôi cà phê sữa đá",
                        english: "Iced milk coffee, please",
                        nextLocalLine: "Dạ, một cà phê sữa đá nhé.",
                        nextLocalMeaning: "Yes, one iced milk coffee."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-food-coffee-black",
                            vietnamese: "Cho tôi cà phê đen đá",
                            english: "Iced black coffee, please",
                            nextLocalLine: "Dạ, một cà phê đen đá.",
                            nextLocalMeaning: "Yes, one iced black coffee."
                        ),
                        messageReply(
                            "viet-family-v900-food-drin-one-iced-tea-please",
                            vietnamese: "Cho tôi một trà đá",
                            english: "One iced tea, please",
                            nextLocalLine: "Dạ, tôi lấy trà đá cho bạn.",
                            nextLocalMeaning: "Yes, I will get iced tea for you."
                        ),
                    ],
                    nextStepTitle: "Adjust the drink",
                    localScenarioContext: "food_allergy_opening"
                ),
                messageScenarioStep(
                    id: "food-allergy-drink",
                    momentType: .ask,
                    scene: "The cafe can adjust the drink before making it.",
                    localLine: "Bạn muốn chỉnh đá, đường hay mang đi không?",
                    localLineMeaning: "Would you like less ice, sugar adjusted, or to go?",
                    userGoal: "Ask for less ice or no sugar.",
                    best: messageReply(
                        "viet-family-food-less-ice",
                        vietnamese: "Ít đá thôi",
                        english: "Less ice, please",
                        nextLocalLine: "Dạ, tôi làm ít đá.",
                        nextLocalMeaning: "Yes, I will make it with less ice."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-food-no-sugar",
                            vietnamese: "Không đường",
                            english: "No sugar, please",
                            nextLocalLine: "Dạ, tôi làm không đường.",
                            nextLocalMeaning: "Yes, I will make it without sugar."
                        ),
                        messageReply(
                            "viet-family-food-to-go",
                            vietnamese: "Cho tôi mang đi",
                            english: "To go, please",
                            nextLocalLine: "Dạ, tôi làm ly mang đi.",
                            nextLocalMeaning: "Yes, I will make it to go."
                        ),
                    ],
                    nextStepTitle: "Check ingredients",
                    localScenarioContext: "food_allergy_drink"
                ),
                messageScenarioStep(
                    id: "food-allergy-peanuts",
                    momentType: .ask,
                    scene: "You are considering a snack and need to check for peanuts.",
                    localLine: "Bạn có dị ứng gì không?",
                    localLineMeaning: "Do you have any allergies?",
                    userGoal: "Say you have a peanut allergy.",
                    best: messageReply(
                        "viet-family-food-peanut-allergy",
                        vietnamese: "Tôi bị dị ứng đậu phộng",
                        english: "I am allergic to peanuts",
                        nextLocalLine: "Tôi hiểu. Tôi sẽ kiểm tra món này trước.",
                        nextLocalMeaning: "I understand. I will check this dish first."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-food-drin-does-this-contain-peanuts",
                            vietnamese: "Món này có đậu phộng không?",
                            english: "Does this contain peanuts?",
                            nextLocalLine: "Để tôi hỏi bếp xem có đậu phộng không.",
                            nextLocalMeaning: "Let me ask the kitchen if it has peanuts."
                        ),
                        messageReply(
                            "viet-family-v500-food-drin-i-am-allergic-to-shellfish",
                            vietnamese: "Tôi bị dị ứng hải sản có vỏ",
                            english: "I am allergic to shellfish",
                            nextLocalLine: "Tôi hiểu, tôi sẽ kiểm tra nguyên liệu.",
                            nextLocalMeaning: "I understand. I will check the ingredients."
                        ),
                    ],
                    nextStepTitle: "Choose safer food",
                    localScenarioContext: "food_allergy_peanuts"
                ),
                messageScenarioStep(
                    id: "food-allergy-spice",
                    momentType: .ask,
                    scene: "The server points at two dishes and you want the gentler one.",
                    localLine: "Bạn ăn cay được không?",
                    localLineMeaning: "Can you eat spicy food?",
                    userGoal: "Ask what is not too spicy.",
                    best: messageReply(
                        "viet-family-v900-food-drin-what-is-not-too-spicy",
                        vietnamese: "Món nào không quá cay?",
                        english: "What is not too spicy?",
                        nextLocalLine: "Món này ít cay và dễ ăn.",
                        nextLocalMeaning: "This one is less spicy and easy to eat."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-food-not-spicy",
                            vietnamese: "Không cay nhé",
                            english: "Not spicy, please",
                            nextLocalLine: "Dạ, tôi sẽ dặn bếp làm không cay.",
                            nextLocalMeaning: "Yes, I will tell the kitchen to make it not spicy."
                        ),
                        messageReply(
                            "viet-family-v900-food-drin-please-make-it-less-spicy",
                            vietnamese: "Làm ít cay giúp tôi",
                            english: "Please make it less spicy",
                            nextLocalLine: "Dạ, tôi sẽ dặn bếp làm ít cay.",
                            nextLocalMeaning: "Yes, I will tell the kitchen to make it less spicy."
                        ),
                    ],
                    nextStepTitle: "Fix the order",
                    localScenarioContext: "food_allergy_spice"
                ),
                messageScenarioStep(
                    id: "food-allergy-kitchen-note",
                    momentType: .ask,
                    scene: "Before the kitchen starts, you confirm the safest version of the dish.",
                    localLine: "Bạn muốn tôi dặn bếp thế nào?",
                    localLineMeaning: "How would you like me to tell the kitchen?",
                    userGoal: "Ask for a safer version with less spice or no peanuts.",
                    best: messageReply(
                        "viet-family-v500-food-drin-please-make-it-without-peanuts",
                        vietnamese: "Hãy làm món này mà không cần đậu phộng",
                        english: "Please make it without peanuts",
                        nextLocalLine: "Được, tôi sẽ dặn bếp không dùng đậu phộng.",
                        nextLocalMeaning: "Okay, I will tell the kitchen not to use peanuts."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-food-drin-please-make-it-less-spicy",
                            vietnamese: "Làm ơn làm cho nó bớt cay đi",
                            english: "Please make it less spicy",
                            nextLocalLine: "Được, tôi sẽ dặn bếp làm ít cay.",
                            nextLocalMeaning: "Okay, I will tell the kitchen to make it less spicy."
                        ),
                        messageReply(
                            "viet-family-v900-food-drin-can-i-have-napkins",
                            vietnamese: "Tôi có thể có khăn ăn được không?",
                            english: "Can I have napkins?",
                            nextLocalLine: "Được, tôi lấy khăn ăn cho bạn ngay.",
                            nextLocalMeaning: "Sure, I will bring napkins right away."
                        ),
                    ],
                    recoveryPageIDs: [
                        "viet-family-food-peanut-allergy",
                        "viet-family-food-not-spicy",
                    ],
                    recoveryTitle: "If the kitchen note matters",
                    recoveryBody: "Repeat the allergy or spice request before the order goes in.",
                    nextStepTitle: "Fix the order",
                    localScenarioContext: "food_allergy_kitchen_note"
                ),
                messageScenarioStep(
                    id: "food-allergy-fix",
                    momentType: .ask,
                    scene: "The dish arrives and you want to fix it politely before eating.",
                    localLine: "Món này ổn chưa?",
                    localLineMeaning: "Is this dish okay now?",
                    userGoal: "Explain the ingredient problem.",
                    best: messageReply(
                        "viet-family-v500-food-drin-i-ordered-this-without-peanuts",
                        vietnamese: "Tôi đã gọi món này không có đậu phộng",
                        english: "I ordered this without peanuts",
                        nextLocalLine: "Xin lỗi, tôi sẽ đổi món này cho bạn.",
                        nextLocalMeaning: "Sorry, I will change this dish for you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-food-drin-i-asked-for-this-not-spicy",
                            vietnamese: "Tôi đã dặn món này không cay",
                            english: "I asked for this not spicy",
                            nextLocalLine: "Xin lỗi, tôi sẽ nhờ bếp làm lại.",
                            nextLocalMeaning: "Sorry, I will ask the kitchen to remake it."
                        ),
                        messageReply(
                            "viet-family-food-wrong-order",
                            vietnamese: "Đây không phải món tôi gọi",
                            english: "This isn't what I ordered",
                            nextLocalLine: "Được, tôi sẽ đổi món khác cho bạn.",
                            nextLocalMeaning: "Yes, I will change it to another dish for you."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "food_allergy_fix"
                ),
                messageGoodbyeStep(
                    id: "food-allergy-goodbye",
                    scene: "The server has adjusted the order and you are ready to eat.",
                    localLine: "Món mới không có đậu phộng và ít cay.",
                    localLineMeaning: "The new dish has no peanuts and is less spicy.",
                    nextLocalLine: "Không có gì, chúc bạn ăn ngon.",
                    nextLocalMeaning: "You are welcome. Enjoy your meal.",
                    localScenarioContext: "food_allergy_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .foodCoffeeOrder,
            sceneTitle: "Coffee order",
            sceneSetup: "Order a simple Vietnamese coffee, adjust ice or sugar, choose to-go, pay, and close politely.",
            steps: [
                messageScenarioStep(
                    id: "coffee-order-opening",
                    momentType: .listen,
                    scene: "You step up to a cafe counter and want a safe first coffee order.",
                    localLine: "Xin chào, bạn muốn uống gì?",
                    localLineMeaning: "Hello, what would you like to drink?",
                    userGoal: "Order iced milk coffee.",
                    best: messageReply(
                        "viet-family-food-coffee-milk",
                        vietnamese: "Cho tôi cà phê sữa đá",
                        english: "Iced milk coffee, please",
                        nextLocalLine: "Dạ, một cà phê sữa đá nhé.",
                        nextLocalMeaning: "Yes, one iced milk coffee."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-food-coffee-black",
                            vietnamese: "Cho tôi cà phê đen đá",
                            english: "Iced black coffee, please",
                            nextLocalLine: "Dạ, một cà phê đen đá.",
                            nextLocalMeaning: "Yes, one iced black coffee."
                        ),
                        messageReply(
                            "viet-phrase-v900-food-drin-one-hot-coffee-please",
                            vietnamese: "Cho tôi một ly cà phê nóng",
                            english: "One hot coffee, please",
                            nextLocalLine: "Dạ, một ly cà phê nóng.",
                            nextLocalMeaning: "Yes, one hot coffee."
                        ),
                    ],
                    nextStepTitle: "Adjust ice",
                    localScenarioContext: "coffee_order_opening"
                ),
                messageScenarioStep(
                    id: "coffee-order-ice",
                    scene: "The cafe asks about ice and sugar before making the drink.",
                    localLine: "Bạn muốn ít đá hay ít đường không?",
                    localLineMeaning: "Would you like less ice or less sugar?",
                    userGoal: "Ask for less ice.",
                    best: messageReply(
                        "viet-family-food-less-ice",
                        vietnamese: "Ít đá thôi",
                        english: "Less ice, please",
                        nextLocalLine: "Dạ, tôi làm ít đá.",
                        nextLocalMeaning: "Yes, I will make it with less ice."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-food-no-sugar",
                            vietnamese: "Không đường",
                            english: "No sugar, please",
                            nextLocalLine: "Dạ, tôi làm không đường.",
                            nextLocalMeaning: "Yes, I will make it without sugar."
                        ),
                        messageReply(
                            "viet-family-v900-food-drin-less-sugar-please",
                            vietnamese: "Ít đường thôi",
                            english: "Less sugar, please",
                            nextLocalLine: "Dạ, tôi làm ít đường.",
                            nextLocalMeaning: "Yes, I will make it with less sugar."
                        ),
                    ],
                    nextStepTitle: "Choose to-go",
                    localScenarioContext: "coffee_order_ice"
                ),
                messageScenarioStep(
                    id: "coffee-order-to-go",
                    scene: "The drink can be served here or taken away.",
                    localLine: "Bạn uống ở đây hay mang đi?",
                    localLineMeaning: "For here or to go?",
                    userGoal: "Ask for the drink to go.",
                    best: messageReply(
                        "viet-family-food-to-go",
                        vietnamese: "Cho tôi mang đi",
                        english: "To go, please",
                        nextLocalLine: "Dạ, tôi làm ly mang đi.",
                        nextLocalMeaning: "Yes, I will make it to go."
                    ),
                    alternates: [
                        messageReply(
                            "viet-phrase-v900-poli-basi-can-i-sit-here",
                            vietnamese: "Tôi có thể ngồi đây được không?",
                            english: "Can I sit here?",
                            nextLocalLine: "Dạ, bạn ngồi ở bàn này nhé.",
                            nextLocalMeaning: "Yes, please sit at this table."
                        ),
                        messageReply(
                            "viet-family-food-menu",
                            vietnamese: "Cho tôi xem thực đơn",
                            english: "The menu, please",
                            nextLocalLine: "Dạ, đây là thực đơn.",
                            nextLocalMeaning: "Yes, here is the menu."
                        ),
                    ],
                    nextStepTitle: "Ask price",
                    localScenarioContext: "coffee_order_to_go"
                ),
                messageScenarioStep(
                    id: "coffee-order-price",
                    scene: "You want the price before paying.",
                    localLine: "Cà phê của bạn xong rồi.",
                    localLineMeaning: "Your coffee is ready.",
                    userGoal: "Ask how much it costs.",
                    best: messageReply(
                        "viet-family-money-how-much",
                        vietnamese: "Bao nhiêu tiền?",
                        english: "How much is it?",
                        nextLocalLine: "Ba mươi nghìn.",
                        nextLocalMeaning: "Thirty thousand."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-food-pay-now",
                            vietnamese: "Tính tiền giúp tôi",
                            english: "Please let me pay",
                            nextLocalLine: "Dạ, ba mươi nghìn.",
                            nextLocalMeaning: "Yes, thirty thousand."
                        ),
                        messageReply(
                            "viet-family-service-card",
                            vietnamese: "Tôi quẹt thẻ được không?",
                            english: "Can I pay by card?",
                            nextLocalLine: "Dạ được, bạn quẹt thẻ ở đây.",
                            nextLocalMeaning: "Yes, tap your card here."
                        ),
                    ],
                    nextStepTitle: "Pick up drink",
                    localScenarioContext: "coffee_order_price"
                ),
                messageScenarioStep(
                    id: "coffee-order-pickup",
                    scene: "The barista calls your drink at the counter.",
                    localLine: "Cà phê sữa đá của bạn đây.",
                    localLineMeaning: "Here is your iced milk coffee.",
                    userGoal: "Thank them and ask for a straw if needed.",
                    best: messageReply(
                        "viet-family-polite-thank-you",
                        vietnamese: "Cảm ơn",
                        english: "Thank you",
                        nextLocalLine: "Không có gì.",
                        nextLocalMeaning: "You are welcome."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-polite-no-thanks",
                            vietnamese: "Không, cảm ơn",
                            english: "No, thank you",
                            nextLocalLine: "Dạ, không sao.",
                            nextLocalMeaning: "Okay, no problem."
                        ),
                        messageReply(
                            "viet-family-v900-food-drin-can-i-have-napkins",
                            vietnamese: "Cho tôi khăn giấy được không?",
                            english: "Can I have napkins?",
                            nextLocalLine: "Dạ, khăn giấy ở đây.",
                            nextLocalMeaning: "Yes, napkins are here."
                        ),
                    ],
                    nextStepTitle: "Say goodbye",
                    localScenarioContext: "coffee_order_pickup"
                ),
                messageGoodbyeStep(
                    id: "coffee-order-goodbye",
                    scene: "You have your coffee and are leaving the counter.",
                    localLine: "Tạm biệt nhé.",
                    localLineMeaning: "Goodbye.",
                    nextLocalLine: "Không có gì, hẹn gặp lại.",
                    nextLocalMeaning: "You are welcome, see you again.",
                    localScenarioContext: "coffee_order_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .taxiRouteHelp,
            sceneTitle: "Taxi route and fare",
            sceneSetup: "Confirm the route, ask the driver to follow the map, handle a route mismatch, and pay cleanly.",
            steps: [
                messageScenarioStep(
                    id: "taxi-route-opening",
                    momentType: .listen,
                    scene: "You are in a taxi and the driver asks where you are going.",
                    localLine: "Xin chào, bạn muốn đi đâu?",
                    localLineMeaning: "Hello, where would you like to go?",
                    userGoal: "Show the hotel or address.",
                    best: messageReply(
                        "viet-family-v500-tran-please-take-me-to-this-hotel",
                        vietnamese: "Làm ơn đưa tôi đến khách sạn này",
                        english: "Please take me to this hotel",
                        nextLocalLine: "Được, tôi biết khách sạn này.",
                        nextLocalMeaning: "Okay, I know this hotel."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-tran-please-take-me-to-this-address",
                            vietnamese: "Làm ơn đưa tôi đến địa chỉ này",
                            english: "Please take me to this address",
                            nextLocalLine: "Được, tôi sẽ đi theo địa chỉ này.",
                            nextLocalMeaning: "Okay, I will follow this address."
                        ),
                        messageReply(
                            "viet-family-transport-destination",
                            vietnamese: "Cho tôi đến đây",
                            english: "Take me here",
                            nextLocalLine: "Được, tôi sẽ đi đến điểm này.",
                            nextLocalMeaning: "Okay, I will go to this place."
                        ),
                    ],
                    nextStepTitle: "Follow the map",
                    localScenarioContext: "taxi_route_opening"
                ),
                messageScenarioStep(
                    id: "taxi-route-map",
                    momentType: .ask,
                    scene: "You want the driver to stay with the app route.",
                    localLine: "Bạn muốn đi theo đường nào?",
                    localLineMeaning: "Which route would you like to take?",
                    userGoal: "Ask the driver to follow the map.",
                    best: messageReply(
                        "viet-family-v500-tran-please-follow-the-map",
                        vietnamese: "Làm ơn đi theo bản đồ",
                        english: "Please follow the map",
                        nextLocalLine: "Được, tôi sẽ đi theo bản đồ.",
                        nextLocalMeaning: "Okay, I will follow the map."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-transport-route",
                            vietnamese: "Đi đường này giúp tôi",
                            english: "Please go this way",
                            nextLocalLine: "Được, tôi sẽ đi đường này.",
                            nextLocalMeaning: "Okay, I will go this way."
                        ),
                        messageReply(
                            "viet-family-v900-tran-please-take-the-faster-route",
                            vietnamese: "Làm ơn đi đường nhanh hơn",
                            english: "Please take the faster route",
                            nextLocalLine: "Được, tôi sẽ chọn đường nhanh hơn.",
                            nextLocalMeaning: "Okay, I will take the faster route."
                        ),
                    ],
                    nextStepTitle: "Repair the route",
                    localScenarioContext: "taxi_route_map"
                ),
                messageScenarioStep(
                    id: "taxi-route-different",
                    momentType: .ask,
                    scene: "The route on the app no longer matches the road.",
                    localLine: "Đường này có kẹt xe một chút.",
                    localLineMeaning: "This road has a little traffic.",
                    userGoal: "Ask about the different route without escalating.",
                    best: messageReply(
                        "viet-family-v900-tran-the-app-shows-a-different-route",
                        vietnamese: "Ứng dụng hiển thị tuyến đường khác",
                        english: "The app shows a different route",
                        nextLocalLine: "Tôi hiểu, tôi sẽ quay lại tuyến đó.",
                        nextLocalMeaning: "I understand, I will go back to that route."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-tran-are-we-going-the-right-way",
                            vietnamese: "Mình đang đi đúng đường không?",
                            english: "Are we going the right way?",
                            nextLocalLine: "Đúng rồi, chúng ta vẫn đang đi đúng hướng.",
                            nextLocalMeaning: "Yes, we are still going the right way."
                        ),
                        messageReply(
                            "viet-family-v900-tran-this-is-the-wrong-address",
                            vietnamese: "Đây là sai địa chỉ",
                            english: "This is the wrong address",
                            nextLocalLine: "Xin lỗi, bạn cho tôi xem lại địa chỉ nhé.",
                            nextLocalMeaning: "Sorry, please show me the address again."
                        ),
                    ],
                    nextStepTitle: "Give turn guidance",
                    localScenarioContext: "taxi_route_different"
                ),
                messageScenarioStep(
                    id: "taxi-route-turn",
                    momentType: .ask,
                    scene: "You recognize the last few streets and need a simple turn.",
                    localLine: "Bạn muốn rẽ ở đâu?",
                    localLineMeaning: "Where would you like to turn?",
                    userGoal: "Give one clear direction.",
                    best: messageReply(
                        "viet-family-v900-tran-please-turn-right-here",
                        vietnamese: "Làm ơn rẽ phải ở đây",
                        english: "Please turn right here",
                        nextLocalLine: "Được, tôi rẽ phải ở đây.",
                        nextLocalMeaning: "Okay, I will turn right here."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-tran-please-turn-left-at-the-next-street",
                            vietnamese: "Làm ơn rẽ trái ở đường tới",
                            english: "Please turn left at the next street",
                            nextLocalLine: "Được, tôi rẽ trái ở đường tới.",
                            nextLocalMeaning: "Okay, I will turn left at the next street."
                        ),
                        messageReply(
                            "viet-family-v500-tran-please-go-straight",
                            vietnamese: "Làm ơn đi thẳng",
                            english: "Please go straight",
                            nextLocalLine: "Được, tôi đi thẳng.",
                            nextLocalMeaning: "Okay, I will go straight."
                        ),
                    ],
                    nextStepTitle: "Confirm the fare",
                    localScenarioContext: "taxi_route_turn"
                ),
                messageScenarioStep(
                    id: "taxi-route-fare",
                    momentType: .ask,
                    scene: "The ride is ending and you want to confirm payment.",
                    localLine: "Đến nơi rồi, tổng tiền là như vậy.",
                    localLineMeaning: "We have arrived, and that is the total.",
                    userGoal: "Confirm the fare and payment method.",
                    best: messageReply(
                        "viet-family-v900-tran-is-that-the-total-price",
                        vietnamese: "Đó là tổng tiền phải không?",
                        english: "Is that the total price?",
                        nextLocalLine: "Đúng rồi, đó là tổng tiền.",
                        nextLocalMeaning: "Yes, that is the total price."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-transport-cash",
                            vietnamese: "Tôi trả bằng tiền mặt",
                            english: "I'll pay cash",
                            nextLocalLine: "Được, tiền mặt được.",
                            nextLocalMeaning: "Okay, cash is fine."
                        ),
                        messageReply(
                            "viet-family-v900-tran-can-i-pay-the-fare-by-card",
                            vietnamese: "Tôi trả tiền xe bằng thẻ được không?",
                            english: "Can I pay the fare by card?",
                            nextLocalLine: "Được, bạn có thể trả bằng thẻ.",
                            nextLocalMeaning: "Yes, you can pay by card."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "taxi_route_fare"
                ),
                messageScenarioStep(
                    id: "taxi-route-app-price",
                    momentType: .ask,
                    scene: "The driver mentions payment again and you want to keep it aligned with the app.",
                    localLine: "Bạn muốn thanh toán theo ứng dụng đúng không?",
                    localLineMeaning: "You want to pay according to the app, right?",
                    userGoal: "Ask to use the Grab app price.",
                    best: messageReply(
                        "viet-family-v900-tran-please-use-the-price-in-the-grab-app",
                        vietnamese: "Vui lòng sử dụng giá trên ứng dụng Grab.",
                        english: "Please use the price in the Grab app.",
                        nextLocalLine: "Được, tôi dùng giá trong ứng dụng.",
                        nextLocalMeaning: "Okay, I will use the price in the app."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-tran-can-i-pay-by-bank-transfer",
                            vietnamese: "Tôi có thể thanh toán bằng chuyển khoản ngân hàng không?",
                            english: "Can I pay by bank transfer?",
                            nextLocalLine: "Được, bạn có thể chuyển khoản.",
                            nextLocalMeaning: "Yes, you can pay by bank transfer."
                        ),
                        messageReply(
                            "viet-family-v900-tran-please-tell-me-when-to-get-off",
                            vietnamese: "Hãy cho tôi biết khi nào nên xuống xe",
                            english: "Please tell me when to get off",
                            nextLocalLine: "Được, gần đến nơi tôi sẽ báo bạn.",
                            nextLocalMeaning: "Okay, I will tell you when we are close."
                        ),
                    ],
                    recoveryPageIDs: [
                        "viet-family-v900-tran-is-that-the-total-price",
                        "viet-family-v500-prob-help-can-you-help-me",
                    ],
                    recoveryTitle: "If payment drifts",
                    recoveryBody: "Point to the app price and ask one payment question at a time.",
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "taxi_route_app_price"
                ),
                messageGoodbyeStep(
                    id: "taxi-route-goodbye",
                    scene: "You have arrived and paid the fare.",
                    localLine: "Cảm ơn bạn, chúc bạn một ngày tốt lành.",
                    localLineMeaning: "Thank you, have a good day.",
                    nextLocalLine: "Không có gì, chúc bạn đi vui.",
                    nextLocalMeaning: "You are welcome, enjoy your trip.",
                    localScenarioContext: "taxi_route_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .driverProblemHelp,
            sceneTitle: "Driver help",
            sceneSetup: "Handle wrong-car, driver-contact, safety, and lost-ride moments without letting the thread drift.",
            steps: [
                messageScenarioStep(
                    id: "driver-problem-opening",
                    momentType: .listen,
                    scene: "A car arrives at the pickup point, but you need to confirm it first.",
                    localLine: "Xin chào, bạn đặt xe phải không?",
                    localLineMeaning: "Hello, did you book a ride?",
                    userGoal: "Check whether this is your driver.",
                    best: messageReply(
                        "viet-family-v500-tran-are-you-my-driver",
                        vietnamese: "Bạn là tài xế của tôi à?",
                        english: "Are you my driver?",
                        nextLocalLine: "Đúng rồi, bạn kiểm tra biển số xe nhé.",
                        nextLocalMeaning: "Yes, please check the car plate."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-tran-is-this-my-car",
                            vietnamese: "Đây là xe của tôi phải không?",
                            english: "Is this my car?",
                            nextLocalLine: "Bạn kiểm tra biển số trên ứng dụng nhé.",
                            nextLocalMeaning: "Please check the plate number in the app."
                        ),
                        messageReply(
                            "viet-family-v900-tran-the-car-number-is-different",
                            vietnamese: "Biển số xe khác",
                            english: "The car number is different",
                            nextLocalLine: "Vậy bạn đừng lên xe này nhé.",
                            nextLocalMeaning: "Then please do not get in this car."
                        ),
                    ],
                    nextStepTitle: "Handle the wrong car",
                    localScenarioContext: "driver_problem_opening"
                ),
                messageScenarioStep(
                    id: "driver-problem-wrong-car",
                    momentType: .ask,
                    scene: "The plate number still does not match your app.",
                    localLine: "Bạn thấy biển số không khớp à?",
                    localLineMeaning: "Does the plate number not match?",
                    userGoal: "Say this is not your car.",
                    best: messageReply(
                        "viet-family-transport-wrong-car",
                        vietnamese: "Đây không phải xe của tôi",
                        english: "This is not my car",
                        nextLocalLine: "Đúng rồi, bạn nên chờ đúng xe trong ứng dụng.",
                        nextLocalMeaning: "That is right, you should wait for the car in the app."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-tran-the-car-number-is-different",
                            vietnamese: "Biển số xe khác",
                            english: "The car number is different",
                            nextLocalLine: "Bạn chờ xe đúng biển số nhé.",
                            nextLocalMeaning: "Please wait for the car with the matching plate."
                        ),
                        messageReply(
                            "viet-family-v500-tran-please-call-the-driver",
                            vietnamese: "Gọi tài xế giúp tôi",
                            english: "Please call the driver",
                            nextLocalLine: "Được, tôi sẽ gọi tài xế trong ứng dụng.",
                            nextLocalMeaning: "Okay, I will call the driver in the app."
                        ),
                    ],
                    nextStepTitle: "Contact the driver",
                    localScenarioContext: "driver_problem_wrong_car"
                ),
                messageScenarioStep(
                    id: "driver-problem-contact",
                    momentType: .ask,
                    scene: "You need someone to contact the real driver.",
                    localLine: "Bạn có số tài xế trong ứng dụng không?",
                    localLineMeaning: "Do you have the driver's number in the app?",
                    userGoal: "Ask someone to contact the driver.",
                    best: messageReply(
                        "viet-family-v500-prob-help-can-you-contact-the-driver",
                        vietnamese: "Bạn liên hệ tài xế giúp tôi được không?",
                        english: "Can you contact the driver for me?",
                        nextLocalLine: "Được, đưa tôi xem màn hình đặt xe.",
                        nextLocalMeaning: "Yes, show me the ride screen."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-tran-the-driver-left-without-me",
                            vietnamese: "Tài xế đi mất rồi",
                            english: "The driver left without me",
                            nextLocalLine: "Bạn nên báo lỗi trong ứng dụng.",
                            nextLocalMeaning: "You should report the problem in the app."
                        ),
                        messageReply(
                            "viet-family-v900-tran-i-booked-through-the-app",
                            vietnamese: "Tôi đặt xe qua ứng dụng",
                            english: "I booked through the app",
                            nextLocalLine: "Vậy bạn mở ứng dụng để tôi xem nhé.",
                            nextLocalMeaning: "Then please open the app so I can check."
                        ),
                    ],
                    nextStepTitle: "Wait safely",
                    localScenarioContext: "driver_problem_contact"
                ),
                messageScenarioStep(
                    id: "driver-problem-safety",
                    momentType: .ask,
                    scene: "The car was wrong and you are staying in a public area while someone helps.",
                    localLine: "Bạn muốn đứng gần bảo vệ không?",
                    localLineMeaning: "Would you like to wait near security?",
                    userGoal: "Ask someone to stay nearby or call security.",
                    best: messageReply(
                        "viet-family-v500-prob-help-can-you-call-security",
                        vietnamese: "Bạn gọi bảo vệ giúp tôi được không?",
                        english: "Can you call security?",
                        nextLocalLine: "Được, tôi sẽ gọi bảo vệ ngay.",
                        nextLocalMeaning: "Yes, I will call security now."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-prob-help-please-stay-with-me",
                            vietnamese: "Làm ơn ở lại với tôi",
                            english: "Please stay with me",
                            nextLocalLine: "Được, tôi sẽ ở đây hỗ trợ bạn.",
                            nextLocalMeaning: "Yes, I will stay here and help you."
                        ),
                        messageReply(
                            "viet-family-v500-emer-safe-please-stay-near-me",
                            vietnamese: "Làm ơn ở gần tôi",
                            english: "Please stay near me",
                            nextLocalLine: "Được, tôi sẽ đứng gần bạn.",
                            nextLocalMeaning: "Okay, I will stay near you."
                        ),
                    ],
                    recoveryTitle: "If the situation feels unsafe",
                    recoveryBody: "Stay in a lit public place and ask staff or security for help.",
                    nextStepTitle: "Report the ride",
                    localScenarioContext: "driver_problem_safety"
                ),
                messageScenarioStep(
                    id: "driver-problem-report",
                    momentType: .ask,
                    scene: "The ride problem is over and you need to report what happened.",
                    localLine: "Bạn muốn báo lỗi chuyến xe không?",
                    localLineMeaning: "Do you want to report the ride problem?",
                    userGoal: "Ask for help contacting the company or writing what happened.",
                    best: messageReply(
                        "viet-family-v900-tran-can-you-help-me-contact-the-company",
                        vietnamese: "Bạn giúp tôi liên hệ công ty được không?",
                        english: "Can you help me contact the company?",
                        nextLocalLine: "Được, tôi sẽ giúp bạn gửi thông tin chuyến xe.",
                        nextLocalMeaning: "Yes, I will help you send the ride information."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-prob-help-this-is-what-happened",
                            vietnamese: "Đây là chuyện đã xảy ra",
                            english: "This is what happened",
                            nextLocalLine: "Được, tôi sẽ ghi lại thông tin này.",
                            nextLocalMeaning: "Okay, I will write down this information."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-can-you-call-security",
                            vietnamese: "Bạn gọi bảo vệ giúp tôi được không?",
                            english: "Can you call security?",
                            nextLocalLine: "Được, tôi sẽ gọi bảo vệ ngay.",
                            nextLocalMeaning: "Yes, I will call security now."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "driver_problem_report"
                ),
                messageGoodbyeStep(
                    id: "driver-problem-goodbye",
                    scene: "Someone helped you handle the driver problem.",
                    localLine: "Tôi đã gửi thông tin giúp bạn.",
                    localLineMeaning: "I sent the information for you.",
                    nextLocalLine: "Không có gì, bạn đi cẩn thận nhé.",
                    nextLocalMeaning: "You are welcome, please travel carefully.",
                    localScenarioContext: "driver_problem_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .shoppingMarketPrice,
            sceneTitle: "Market price",
            sceneSetup: "Greet a vendor, ask price, bargain warmly, choose the item, and close the purchase.",
            steps: [
                messageScenarioStep(
                    id: "shopping-market-opening",
                    momentType: .listen,
                    scene: "You are at a market stall and want to ask about one item.",
                    localLine: "Xin chào, bạn muốn xem cái nào?",
                    localLineMeaning: "Hello, which one would you like to see?",
                    userGoal: "Ask to see that item.",
                    best: messageReply(
                        "viet-family-v900-shop-can-i-see-that-one",
                        vietnamese: "Tôi xem cái kia được không?",
                        english: "Can I see that one?",
                        nextLocalLine: "Được, đây là mẫu đó.",
                        nextLocalMeaning: "Yes, here is that one."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-shop-can-you-show-me-another-one",
                            vietnamese: "Bạn cho tôi xem cái khác được không?",
                            english: "Can you show me another one?",
                            nextLocalLine: "Được, tôi lấy mẫu khác cho bạn.",
                            nextLocalMeaning: "Yes, I will get another one for you."
                        ),
                        messageReply(
                            "viet-family-shopping-just-looking",
                            vietnamese: "Tôi chỉ xem thôi",
                            english: "I'm just looking",
                            nextLocalLine: "Dạ được, bạn cứ xem thoải mái.",
                            nextLocalMeaning: "Sure, feel free to look around."
                        ),
                    ],
                    nextStepTitle: "Ask the price",
                    localScenarioContext: "shopping_market_opening"
                ),
                messageScenarioStep(
                    id: "shopping-market-price",
                    momentType: .ask,
                    scene: "The vendor hands you the item and you need the price.",
                    localLine: "Cái này đẹp, bạn muốn biết giá không?",
                    localLineMeaning: "This is nice, would you like to know the price?",
                    userGoal: "Ask for the best price.",
                    best: messageReply(
                        "viet-family-v900-shop-what-is-your-best-price",
                        vietnamese: "Giá tốt nhất là bao nhiêu?",
                        english: "What is your best price?",
                        nextLocalLine: "Giá tốt nhất là hai trăm nghìn.",
                        nextLocalMeaning: "The best price is two hundred thousand."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-shop-how-much-is-this-item",
                            vietnamese: "Món này bao nhiêu tiền?",
                            english: "How much is this item?",
                            nextLocalLine: "Món này hai trăm nghìn.",
                            nextLocalMeaning: "This item is two hundred thousand."
                        ),
                        messageReply(
                            "viet-family-money-write-total",
                            vietnamese: "Bạn viết giá giúp tôi được không?",
                            english: "Can you write the price down?",
                            nextLocalLine: "Được, tôi viết giá cho bạn.",
                            nextLocalMeaning: "Yes, I will write the price for you."
                        ),
                    ],
                    nextStepTitle: "Ask for a better price",
                    localScenarioContext: "shopping_market_price"
                ),
                messageScenarioStep(
                    id: "shopping-market-discount",
                    momentType: .ask,
                    scene: "You want to bargain but keep the tone friendly.",
                    localLine: "Giá này được chưa?",
                    localLineMeaning: "Is this price okay?",
                    userGoal: "Ask for a discount politely.",
                    best: messageReply(
                        "viet-family-v900-shop-can-you-give-me-a-discount",
                        vietnamese: "Bạn giảm giá cho tôi được không?",
                        english: "Can you give me a discount?",
                        nextLocalLine: "Tôi giảm một chút cho bạn.",
                        nextLocalMeaning: "I can lower it a little for you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-shop-can-you-lower-the-price",
                            vietnamese: "Bạn bớt giá được không?",
                            english: "Can you lower the price?",
                            nextLocalLine: "Được, tôi bớt một chút.",
                            nextLocalMeaning: "Okay, I can lower it a little."
                        ),
                        messageReply(
                            "viet-family-money-too-expensive",
                            vietnamese: "Đắt quá",
                            english: "That is too expensive",
                            nextLocalLine: "Tôi hiểu, tôi giảm giá cho bạn.",
                            nextLocalMeaning: "I understand, I will lower the price for you."
                        ),
                    ],
                    nextStepTitle: "Buy two",
                    localScenarioContext: "shopping_market_discount"
                ),
                messageScenarioStep(
                    id: "shopping-market-cheaper",
                    momentType: .ask,
                    scene: "The vendor shows a similar item and you want a cheaper option before deciding.",
                    localLine: "Bạn muốn xem mẫu khác không?",
                    localLineMeaning: "Would you like to see another style?",
                    userGoal: "Ask for a cheaper or simpler option.",
                    best: messageReply(
                        "viet-family-v900-shop-do-you-have-a-cheaper-one",
                        vietnamese: "Bạn có cái nào rẻ hơn không?",
                        english: "Do you have a cheaper one?",
                        nextLocalLine: "Có, tôi cho bạn xem mẫu rẻ hơn.",
                        nextLocalMeaning: "Yes, I will show you a cheaper one."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-shop-can-you-make-it-a-round-number",
                            vietnamese: "Bạn có thể biến nó thành một số tròn được không?",
                            english: "Can you make it a round number?",
                            nextLocalLine: "Được, tôi làm tròn giá cho bạn.",
                            nextLocalMeaning: "Okay, I can make it a round price for you."
                        ),
                        messageReply(
                            "viet-family-v900-shop-do-you-have-this-in-black",
                            vietnamese: "Bạn có cái này màu đen không?",
                            english: "Do you have this in black?",
                            nextLocalLine: "Có, tôi lấy màu đen cho bạn xem.",
                            nextLocalMeaning: "Yes, I will show you the black one."
                        ),
                    ],
                    recoveryPageIDs: [
                        "viet-family-v900-shop-can-you-give-me-a-discount",
                        "viet-family-v500-shop-how-much-is-this-item",
                    ],
                    recoveryTitle: "If bargaining feels awkward",
                    recoveryBody: "Ask for a cheaper option before naming a lower price.",
                    nextStepTitle: "Buy two",
                    localScenarioContext: "shopping_market_cheaper"
                ),
                messageScenarioStep(
                    id: "shopping-market-two",
                    momentType: .ask,
                    scene: "You may buy two if the price works.",
                    localLine: "Nếu lấy hai cái thì sao?",
                    localLineMeaning: "What if you take two?",
                    userGoal: "Offer to buy two if the price is good.",
                    best: messageReply(
                        "viet-family-v900-shop-i-will-buy-two-if-the-price-is-good",
                        vietnamese: "Giá tốt thì tôi mua hai cái",
                        english: "I will buy two if the price is good",
                        nextLocalLine: "Được, hai cái thì giá này nhé.",
                        nextLocalMeaning: "Okay, for two items, this is the price."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-mone-numb-pric-how-much-for-two-of-them",
                            vietnamese: "Hai cái bao nhiêu tiền?",
                            english: "How much for two of them?",
                            nextLocalLine: "Hai cái là ba trăm năm mươi nghìn.",
                            nextLocalMeaning: "Two are three hundred fifty thousand."
                        ),
                        messageReply(
                            "viet-family-money-another-one",
                            vietnamese: "Cho tôi thêm một cái nữa",
                            english: "Another one, please",
                            nextLocalLine: "Được, tôi lấy thêm một cái.",
                            nextLocalMeaning: "Yes, I will get one more."
                        ),
                    ],
                    nextStepTitle: "Take it",
                    localScenarioContext: "shopping_market_two"
                ),
                messageScenarioStep(
                    id: "shopping-market-take",
                    momentType: .ask,
                    scene: "The price works and you are ready to buy.",
                    localLine: "Bạn lấy cái này nhé?",
                    localLineMeaning: "Would you like to take this one?",
                    userGoal: "Say you will take it and ask for a bag.",
                    best: messageReply(
                        "viet-family-v500-shop-okay-ill-take-it",
                        vietnamese: "Được, tôi lấy cái này",
                        english: "Okay, I'll take it",
                        nextLocalLine: "Dạ, tôi gói lại cho bạn.",
                        nextLocalMeaning: "Yes, I will wrap it for you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-shop-can-you-put-it-in-a-bag",
                            vietnamese: "Bạn cho vào túi giúp tôi được không?",
                            english: "Can you put it in a bag?",
                            nextLocalLine: "Được, tôi cho vào túi.",
                            nextLocalMeaning: "Yes, I will put it in a bag."
                        ),
                        messageReply(
                            "viet-family-v900-shop-no-thank-you-ill-look-around-first",
                            vietnamese: "Không, cảm ơn, tôi xem thêm trước",
                            english: "No thank you, I'll look around first",
                            nextLocalLine: "Dạ được, bạn cứ xem thêm.",
                            nextLocalMeaning: "Sure, feel free to look around more."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "shopping_market_take"
                ),
                messageGoodbyeStep(
                    id: "shopping-market-goodbye",
                    scene: "You finish the purchase and leave the stall politely.",
                    localLine: "Cảm ơn bạn đã mua hàng.",
                    localLineMeaning: "Thank you for buying.",
                    nextLocalLine: "Không có gì, hẹn gặp lại.",
                    nextLocalMeaning: "You are welcome, see you again.",
                    localScenarioContext: "shopping_market_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .shoppingSizeGift,
            sceneTitle: "Gift and size",
            sceneSetup: "Ask for a gift, choose a size or color, use the fitting room, and pack it for travel.",
            steps: [
                messageScenarioStep(
                    id: "shopping-gift-opening",
                    momentType: .listen,
                    scene: "You enter a small shop and want help finding a gift.",
                    localLine: "Xin chào, bạn đang tìm gì?",
                    localLineMeaning: "Hello, what are you looking for?",
                    userGoal: "Say you are looking for a gift.",
                    best: messageReply(
                        "viet-family-v900-shop-im-looking-for-a-gift",
                        vietnamese: "Tôi đang tìm quà",
                        english: "I'm looking for a gift",
                        nextLocalLine: "Dạ, quà cho ai vậy?",
                        nextLocalMeaning: "Yes, who is the gift for?"
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-shop-can-you-show-me-the-inside",
                            vietnamese: "Bạn cho tôi xem bên trong được không?",
                            english: "Can you show me the inside?",
                            nextLocalLine: "Được, tôi mở ra cho bạn xem.",
                            nextLocalMeaning: "Yes, I will open it for you to see."
                        ),
                        messageReply(
                            "viet-family-v900-shop-do-you-have-a-better-quality-one",
                            vietnamese: "Bạn có loại chất lượng tốt hơn không?",
                            english: "Do you have a better quality one?",
                            nextLocalLine: "Có, tôi cho bạn xem loại tốt hơn.",
                            nextLocalMeaning: "Yes, I will show you a better quality one."
                        ),
                    ],
                    nextStepTitle: "Find the fitting room",
                    localScenarioContext: "shopping_gift_opening"
                ),
                messageScenarioStep(
                    id: "shopping-gift-fitting",
                    momentType: .ask,
                    scene: "You want to try on clothing before buying.",
                    localLine: "Bạn muốn thử không?",
                    localLineMeaning: "Would you like to try it on?",
                    userGoal: "Ask where the fitting room is.",
                    best: messageReply(
                        "viet-family-v900-shop-where-is-the-fitting-room",
                        vietnamese: "Phòng thử đồ ở đâu?",
                        english: "Where is the fitting room?",
                        nextLocalLine: "Phòng thử đồ ở bên phải.",
                        nextLocalMeaning: "The fitting room is on the right."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-shopping-try-on",
                            vietnamese: "Tôi thử cái này được không?",
                            english: "Can I try this on?",
                            nextLocalLine: "Được, phòng thử đồ ở bên phải.",
                            nextLocalMeaning: "Yes, the fitting room is on the right."
                        ),
                        messageReply(
                            "viet-family-v900-shop-this-fits-well",
                            vietnamese: "Cái này vừa",
                            english: "This fits well",
                            nextLocalLine: "Dạ, mẫu này hợp với bạn.",
                            nextLocalMeaning: "Yes, this one suits you."
                        ),
                    ],
                    nextStepTitle: "Ask for size",
                    localScenarioContext: "shopping_gift_fitting"
                ),
                messageScenarioStep(
                    id: "shopping-gift-size",
                    momentType: .ask,
                    scene: "The size is not quite right.",
                    localLine: "Kích cỡ này vừa chưa?",
                    localLineMeaning: "Does this size fit yet?",
                    userGoal: "Ask for a smaller or larger size.",
                    best: messageReply(
                        "viet-family-v900-shop-do-you-have-a-smaller-size",
                        vietnamese: "Bạn có size nhỏ hơn không?",
                        english: "Do you have a smaller size?",
                        nextLocalLine: "Có, tôi lấy size nhỏ hơn cho bạn.",
                        nextLocalMeaning: "Yes, I will get a smaller size for you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-shop-do-you-have-a-larger-size",
                            vietnamese: "Bạn có size lớn hơn không?",
                            english: "Do you have a larger size?",
                            nextLocalLine: "Có, tôi lấy size lớn hơn cho bạn.",
                            nextLocalMeaning: "Yes, I will get a larger size for you."
                        ),
                        messageReply(
                            "viet-family-shopping-size",
                            vietnamese: "Tôi muốn cỡ này",
                            english: "I want this size",
                            nextLocalLine: "Được, tôi sẽ kiểm tra kích cỡ cho bạn.",
                            nextLocalMeaning: "Yes, I will check the size for you."
                        ),
                    ],
                    nextStepTitle: "Ask for color",
                    localScenarioContext: "shopping_gift_size"
                ),
                messageScenarioStep(
                    id: "shopping-gift-color",
                    momentType: .ask,
                    scene: "The size works, but you want another color.",
                    localLine: "Bạn thích màu này không?",
                    localLineMeaning: "Do you like this color?",
                    userGoal: "Ask for another color.",
                    best: messageReply(
                        "viet-family-v900-shop-do-you-have-this-in-black",
                        vietnamese: "Bạn có màu đen không?",
                        english: "Do you have this in black?",
                        nextLocalLine: "Có, tôi lấy màu đen cho bạn.",
                        nextLocalMeaning: "Yes, I will get it in black for you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-shopping-color",
                            vietnamese: "Có màu khác không?",
                            english: "Do you have another color?",
                            nextLocalLine: "Có, tôi cho bạn xem màu khác.",
                            nextLocalMeaning: "Yes, I will show you another color."
                        ),
                        messageReply(
                            "viet-family-v900-shop-do-you-have-a-better-quality-one",
                            vietnamese: "Bạn có cái nào chất lượng hơn không?",
                            english: "Do you have a better quality one?",
                            nextLocalLine: "Có, tôi cho bạn xem loại tốt hơn.",
                            nextLocalMeaning: "Yes, I will show you a better quality one."
                        ),
                    ],
                    nextStepTitle: "Pack it",
                    localScenarioContext: "shopping_gift_color"
                ),
                messageScenarioStep(
                    id: "shopping-gift-pack",
                    momentType: .ask,
                    scene: "You chose the gift and need it packed for your luggage.",
                    localLine: "Bạn muốn gói lại không?",
                    localLineMeaning: "Would you like it wrapped?",
                    userGoal: "Ask for careful travel packing.",
                    best: messageReply(
                        "viet-family-v900-shop-can-you-pack-it-for-travel",
                        vietnamese: "Bạn gói để đi du lịch giúp tôi được không?",
                        english: "Can you pack it for travel?",
                        nextLocalLine: "Được, tôi sẽ gói chắc hơn.",
                        nextLocalMeaning: "Yes, I will pack it more securely."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-shop-can-you-wrap-it-carefully",
                            vietnamese: "Bạn gói cẩn thận giúp tôi được không?",
                            english: "Can you wrap it carefully?",
                            nextLocalLine: "Được, tôi sẽ gói cẩn thận.",
                            nextLocalMeaning: "Yes, I will wrap it carefully."
                        ),
                        messageReply(
                            "viet-family-food-pack-to-go",
                            vietnamese: "Gói mang về",
                            english: "Pack it to go",
                            nextLocalLine: "Được, tôi sẽ đóng gói cho bạn.",
                            nextLocalMeaning: "Yes, I will pack it for you."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "shopping_gift_pack"
                ),
                messageGoodbyeStep(
                    id: "shopping-gift-goodbye",
                    scene: "The gift is packed and ready to carry.",
                    localLine: "Xong rồi, món quà đã được gói cẩn thận.",
                    localLineMeaning: "Done, the gift has been wrapped carefully.",
                    nextLocalLine: "Không có gì, chúc bạn đi vui.",
                    nextLocalMeaning: "You are welcome, enjoy your trip.",
                    localScenarioContext: "shopping_gift_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .shoppingReceiptHelp,
            sceneTitle: "Receipt help",
            sceneSetup: "Use checkout phrases for card payment, receipt, wrong charge, and refund support.",
            steps: [
                messageScenarioStep(
                    id: "shopping-receipt-opening",
                    momentType: .listen,
                    scene: "You are at checkout and the cashier asks how you want to pay.",
                    localLine: "Xin chào, bạn thanh toán bằng tiền mặt hay thẻ?",
                    localLineMeaning: "Hello, will you pay by cash or card?",
                    userGoal: "Ask to pay by card.",
                    best: messageReply(
                        "viet-family-service-card",
                        vietnamese: "Tôi quẹt thẻ được không?",
                        english: "Can I pay by card?",
                        nextLocalLine: "Được, bạn quẹt thẻ ở đây.",
                        nextLocalMeaning: "Yes, tap your card here."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-mone-numb-pric-can-i-pay-by-qr-code",
                            vietnamese: "Tôi thanh toán bằng mã QR được không?",
                            english: "Can I pay by QR code?",
                            nextLocalLine: "Được, mã QR ở đây.",
                            nextLocalMeaning: "Yes, the QR code is here."
                        ),
                        messageReply(
                            "viet-family-v500-mone-numb-pric-can-i-try-another-card",
                            vietnamese: "Tôi thử thẻ khác được không?",
                            english: "Can I try another card?",
                            nextLocalLine: "Được, bạn thử thẻ khác nhé.",
                            nextLocalMeaning: "Yes, please try another card."
                        ),
                    ],
                    nextStepTitle: "Ask for receipt",
                    localScenarioContext: "shopping_receipt_opening"
                ),
                messageScenarioStep(
                    id: "shopping-receipt-print",
                    momentType: .ask,
                    scene: "Payment worked and you need proof of purchase.",
                    localLine: "Bạn cần hóa đơn không?",
                    localLineMeaning: "Do you need a receipt?",
                    userGoal: "Ask for a receipt.",
                    best: messageReply(
                        "viet-family-v500-mone-numb-pric-can-i-have-a-receipt",
                        vietnamese: "Cho tôi hóa đơn được không?",
                        english: "Can I have a receipt?",
                        nextLocalLine: "Được, tôi in hóa đơn cho bạn.",
                        nextLocalMeaning: "Yes, I will print the receipt for you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-mone-numb-pric-can-you-print-the-receipt",
                            vietnamese: "Bạn in hóa đơn giúp tôi được không?",
                            english: "Can you print the receipt?",
                            nextLocalLine: "Được, tôi in hóa đơn ngay.",
                            nextLocalMeaning: "Yes, I will print the receipt now."
                        ),
                        messageReply(
                            "viet-family-v900-mone-numb-pric-can-you-email-the-receipt",
                            vietnamese: "Bạn gửi hóa đơn qua email được không?",
                            english: "Can you email the receipt?",
                            nextLocalLine: "Được, cho tôi email của bạn.",
                            nextLocalMeaning: "Yes, please give me your email."
                        ),
                    ],
                    nextStepTitle: "Check the amount",
                    localScenarioContext: "shopping_receipt_print"
                ),
                messageScenarioStep(
                    id: "shopping-receipt-charge",
                    momentType: .ask,
                    scene: "The amount on the receipt does not match what you expected.",
                    localLine: "Bạn thấy tổng tiền chưa đúng à?",
                    localLineMeaning: "Does the total look off to you?",
                    userGoal: "Say you were charged the wrong amount.",
                    best: messageReply(
                        "viet-family-v900-mone-numb-pric-i-was-charged-the-wrong-amount",
                        vietnamese: "Tôi bị tính sai số tiền",
                        english: "I was charged the wrong amount",
                        nextLocalLine: "Xin lỗi, tôi sẽ kiểm tra lại hóa đơn.",
                        nextLocalMeaning: "Sorry, I will check the receipt again."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-money-total-wrong",
                            vietnamese: "Tổng tiền không đúng",
                            english: "The total is not right",
                            nextLocalLine: "Tôi hiểu, tôi sẽ kiểm tra lại tổng tiền.",
                            nextLocalMeaning: "I understand, I will check the total again."
                        ),
                        messageReply(
                            "viet-family-v500-mone-numb-pric-please-count-it-again",
                            vietnamese: "Làm ơn tính lại giúp tôi",
                            english: "Please count it again",
                            nextLocalLine: "Được, tôi sẽ tính lại.",
                            nextLocalMeaning: "Okay, I will count it again."
                        ),
                    ],
                    nextStepTitle: "Ask for refund",
                    localScenarioContext: "shopping_receipt_charge"
                ),
                messageScenarioStep(
                    id: "shopping-receipt-refund",
                    momentType: .ask,
                    scene: "The cashier confirms there is a payment issue.",
                    localLine: "Bạn muốn hoàn tiền phần chênh lệch không?",
                    localLineMeaning: "Would you like a refund for the difference?",
                    userGoal: "Ask them to process a refund.",
                    best: messageReply(
                        "viet-family-v900-mone-numb-pric-can-you-process-a-refund",
                        vietnamese: "Bạn hoàn tiền giúp tôi được không?",
                        english: "Can you process a refund?",
                        nextLocalLine: "Được, tôi sẽ hoàn tiền phần chênh lệch.",
                        nextLocalMeaning: "Yes, I will refund the difference."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-mone-numb-pric-can-you-refund-the-difference",
                            vietnamese: "Bạn hoàn lại phần chênh lệch được không?",
                            english: "Can you refund the difference?",
                            nextLocalLine: "Được, tôi sẽ hoàn lại phần chênh lệch.",
                            nextLocalMeaning: "Yes, I will refund the difference."
                        ),
                        messageReply(
                            "viet-family-v900-mone-numb-pric-please-cancel-that-card-payment",
                            vietnamese: "Làm ơn hủy giao dịch thẻ đó",
                            english: "Please cancel that card payment",
                            nextLocalLine: "Được, tôi sẽ kiểm tra giao dịch thẻ.",
                            nextLocalMeaning: "Okay, I will check the card payment."
                        ),
                    ],
                    nextStepTitle: "Confirm receipt",
                    localScenarioContext: "shopping_receipt_refund"
                ),
                messageScenarioStep(
                    id: "shopping-receipt-final",
                    momentType: .ask,
                    scene: "The payment issue is fixed and you need the final receipt.",
                    localLine: "Thanh toán đã xong, bạn kiểm tra hóa đơn nhé.",
                    localLineMeaning: "The payment is done; please check the receipt.",
                    userGoal: "Confirm the payment or receipt details.",
                    best: messageReply(
                        "viet-family-v900-mone-numb-pric-the-payment-went-through",
                        vietnamese: "Thanh toán đã thành công",
                        english: "The payment went through",
                        nextLocalLine: "Đúng rồi, thanh toán đã thành công.",
                        nextLocalMeaning: "Yes, the payment went through."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-mone-numb-pric-this-receipt-is-not-mine",
                            vietnamese: "Hóa đơn này không phải của tôi",
                            english: "This receipt is not mine",
                            nextLocalLine: "Xin lỗi, tôi sẽ in đúng hóa đơn cho bạn.",
                            nextLocalMeaning: "Sorry, I will print the right receipt for you."
                        ),
                        messageReply(
                            "viet-family-v500-mone-numb-pric-is-tax-included",
                            vietnamese: "Đã bao gồm thuế chưa?",
                            english: "Is tax included?",
                            nextLocalLine: "Rồi, giá này đã bao gồm thuế.",
                            nextLocalMeaning: "Yes, this price includes tax."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "shopping_receipt_final"
                ),
                messageGoodbyeStep(
                    id: "shopping-receipt-goodbye",
                    scene: "The receipt and payment are now clear.",
                    localLine: "Đây là hóa đơn mới của bạn.",
                    localLineMeaning: "Here is your updated receipt.",
                    nextLocalLine: "Không có gì, cảm ơn bạn.",
                    nextLocalMeaning: "You are welcome, thank you.",
                    localScenarioContext: "shopping_receipt_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .emergencyLostPassport,
            sceneTitle: "Lost passport",
            sceneSetup: "Ask for help, report a missing passport, find police or embassy support, and request a copy of the report.",
            steps: [
                messageScenarioStep(
                    id: "emergency-passport-opening",
                    momentType: .listen,
                    scene: "You are at a desk asking for help after realizing your passport is missing.",
                    localLine: "Xin chào, tôi có thể giúp gì cho bạn?",
                    localLineMeaning: "Hello, how can I help you?",
                    userGoal: "Say your passport is missing.",
                    best: messageReply(
                        "viet-family-v500-emer-safe-my-passport-is-missing",
                        vietnamese: "Hộ chiếu của tôi bị mất",
                        english: "My passport is missing",
                        nextLocalLine: "Tôi hiểu, bạn cần báo mất hộ chiếu.",
                        nextLocalMeaning: "I understand, you need to report a lost passport."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-emergency-passport",
                            vietnamese: "Tôi mất hộ chiếu",
                            english: "I lost my passport",
                            nextLocalLine: "Tôi hiểu, bạn cần báo với công an.",
                            nextLocalMeaning: "I understand, you need to report it to the police."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-i-need-help-now",
                            vietnamese: "Tôi cần giúp ngay",
                            english: "I need help now",
                            nextLocalLine: "Được, tôi sẽ giúp bạn bình tĩnh xử lý.",
                            nextLocalMeaning: "Yes, I will help you handle this calmly."
                        ),
                    ],
                    recoveryTitle: "If this is urgent",
                    recoveryBody: "Use the missing passport phrase first, then ask for police or embassy help.",
                    nextStepTitle: "Go to police",
                    localScenarioContext: "emergency_passport_opening"
                ),
                messageScenarioStep(
                    id: "emergency-passport-police",
                    momentType: .ask,
                    scene: "You need the police station for the report.",
                    localLine: "Bạn cần đến đồn công an để làm giấy xác nhận.",
                    localLineMeaning: "You need to go to the police station to make a report.",
                    userGoal: "Ask where the police station is.",
                    best: messageReply(
                        "viet-family-v500-prob-help-where-is-the-police-station",
                        vietnamese: "Đồn công an gần nhất ở đâu?",
                        english: "Where is the nearest police station?",
                        nextLocalLine: "Đồn công an ở gần đây, tôi sẽ chỉ đường.",
                        nextLocalMeaning: "The police station is nearby. I will show you the way."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-emergency-police-station",
                            vietnamese: "Tôi cần đến đồn công an",
                            english: "I need to go to the police station",
                            nextLocalLine: "Được, tôi sẽ chỉ đường cho bạn.",
                            nextLocalMeaning: "Okay, I will show you the way."
                        ),
                        messageReply(
                            "viet-family-v500-emer-safe-please-call-the-police",
                            vietnamese: "Hãy gọi cảnh sát",
                            english: "Please call the police",
                            nextLocalLine: "Được, tôi sẽ gọi công an giúp bạn.",
                            nextLocalMeaning: "Yes, I will call the police for you."
                        ),
                    ],
                    recoveryTitle: "If you are not near your hotel",
                    recoveryBody: "Ask staff to write the police station address before you leave.",
                    nextStepTitle: "Ask for the report",
                    localScenarioContext: "emergency_passport_police"
                ),
                messageScenarioStep(
                    id: "emergency-passport-report",
                    momentType: .ask,
                    scene: "At the report desk, you need the document for passport replacement and insurance.",
                    localLine: "Bạn cần giấy báo mất hộ chiếu phải không?",
                    localLineMeaning: "Do you need a passport-loss report?",
                    userGoal: "Ask for a passport-loss report.",
                    best: messageReply(
                        "viet-family-emergency-passport-report",
                        vietnamese: "Tôi cần giấy báo mất hộ chiếu",
                        english: "I need a passport-loss report",
                        nextLocalLine: "Được, tôi sẽ hướng dẫn bạn khai thông tin.",
                        nextLocalMeaning: "Okay, I will guide you through the information."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-prob-help-i-need-a-police-report-for-insurance",
                            vietnamese: "Tôi cần giấy báo công an cho bảo hiểm",
                            english: "I need a police report for insurance",
                            nextLocalLine: "Được, chúng tôi sẽ ghi rõ thông tin cho bảo hiểm.",
                            nextLocalMeaning: "Okay, we will include the information for insurance."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-this-is-what-happened",
                            vietnamese: "Đây là chuyện đã xảy ra",
                            english: "This is what happened",
                            nextLocalLine: "Được, bạn kể chậm từng bước nhé.",
                            nextLocalMeaning: "Okay, please explain slowly, step by step."
                        ),
                    ],
                    recoveryTitle: "If reporting feels hard",
                    recoveryBody: "Keep the story short: where you last had it, when you noticed it was missing, and your contact info.",
                    nextStepTitle: "Contact embassy",
                    localScenarioContext: "emergency_passport_report"
                ),
                messageScenarioStep(
                    id: "emergency-passport-embassy",
                    momentType: .ask,
                    scene: "After the report, you need embassy help.",
                    localLine: "Bạn đã liên hệ đại sứ quán chưa?",
                    localLineMeaning: "Have you contacted the embassy yet?",
                    userGoal: "Ask for help contacting the embassy.",
                    best: messageReply(
                        "viet-family-v500-prob-help-please-help-me-contact-my-embassy",
                        vietnamese: "Làm ơn giúp tôi liên hệ đại sứ quán",
                        english: "Please help me contact my embassy",
                        nextLocalLine: "Được, tôi sẽ giúp bạn tìm thông tin liên hệ.",
                        nextLocalMeaning: "Yes, I will help you find the contact information."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-prob-help-where-is-the-nearest-embassy",
                            vietnamese: "Đại sứ quán gần nhất ở đâu?",
                            english: "Where is the nearest embassy?",
                            nextLocalLine: "Tôi sẽ tìm địa chỉ đại sứ quán cho bạn.",
                            nextLocalMeaning: "I will find the embassy address for you."
                        ),
                        messageReply(
                            "viet-family-emergency-embassy",
                            vietnamese: "Tôi cần đại sứ quán",
                            english: "I need the embassy",
                            nextLocalLine: "Được, tôi sẽ giúp bạn tìm đại sứ quán.",
                            nextLocalMeaning: "Okay, I will help you find the embassy."
                        ),
                    ],
                    nextStepTitle: "Get a copy",
                    localScenarioContext: "emergency_passport_embassy"
                ),
                messageScenarioStep(
                    id: "emergency-passport-copy",
                    momentType: .ask,
                    scene: "Before leaving, you need a copy of the report.",
                    localLine: "Bạn cần bản sao giấy báo cáo không?",
                    localLineMeaning: "Do you need a copy of the report?",
                    userGoal: "Ask for a copy of the report.",
                    best: messageReply(
                        "viet-family-v900-prob-help-please-give-me-a-copy-of-the-report",
                        vietnamese: "Làm ơn cho tôi một bản sao báo cáo",
                        english: "Please give me a copy of the report",
                        nextLocalLine: "Được, tôi sẽ in một bản sao cho bạn.",
                        nextLocalMeaning: "Yes, I will print a copy for you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-prob-help-can-i-leave-my-contact-information",
                            vietnamese: "Tôi để lại thông tin liên hệ được không?",
                            english: "Can I leave my contact information?",
                            nextLocalLine: "Được, bạn ghi số điện thoại ở đây.",
                            nextLocalMeaning: "Yes, write your phone number here."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-please-write-down-your-name",
                            vietnamese: "Làm ơn viết tên của bạn giúp tôi",
                            english: "Please write down your name",
                            nextLocalLine: "Được, tôi sẽ viết tên và số hồ sơ.",
                            nextLocalMeaning: "Yes, I will write my name and the case number."
                        ),
                    ],
                    recoveryTitle: "Before you leave the desk",
                    recoveryBody: "Ask for a copy and a contact name; those are easier to show later than explain again.",
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "emergency_passport_copy"
                ),
                messageGoodbyeStep(
                    id: "emergency-passport-goodbye",
                    scene: "You have the report and know the next place to contact.",
                    localLine: "Bạn giữ bản sao này và liên hệ đại sứ quán nhé.",
                    localLineMeaning: "Keep this copy and contact the embassy.",
                    nextLocalLine: "Không có gì, chúc bạn xử lý thuận lợi.",
                    nextLocalMeaning: "You are welcome. I hope this gets resolved smoothly.",
                    localScenarioContext: "emergency_passport_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .emergencyLostBag,
            sceneTitle: "Lost bag report",
            sceneSetup: "Report a stolen or missing bag, ask security to check cameras, and get a report copy.",
            steps: [
                messageScenarioStep(
                    id: "emergency-bag-opening",
                    momentType: .listen,
                    scene: "You are at a hotel, mall, or station security desk after losing a bag.",
                    localLine: "Xin chào, tôi có thể giúp gì cho bạn?",
                    localLineMeaning: "Hello, how can I help you?",
                    userGoal: "Say your bag was stolen.",
                    best: messageReply(
                        "viet-family-emergency-stolen-bag",
                        vietnamese: "Túi của tôi bị lấy mất",
                        english: "My bag was stolen",
                        nextLocalLine: "Tôi hiểu, bạn bình tĩnh kể lại giúp tôi.",
                        nextLocalMeaning: "I understand. Please calmly tell me what happened."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-help-left-something",
                            vietnamese: "Tôi để quên đồ",
                            english: "I left something behind",
                            nextLocalLine: "Bạn để quên ở đâu? Tôi sẽ giúp tìm.",
                            nextLocalMeaning: "Where did you leave it? I will help look."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-can-you-help-me-look-for-it",
                            vietnamese: "Bạn giúp tôi tìm nó được không?",
                            english: "Can you help me look for it?",
                            nextLocalLine: "Được, bạn mô tả túi giúp tôi.",
                            nextLocalMeaning: "Yes, please describe the bag."
                        ),
                    ],
                    recoveryTitle: "Start with the missing item",
                    recoveryBody: "Say what is missing, then where you last saw it.",
                    nextStepTitle: "Call security",
                    localScenarioContext: "emergency_bag_opening"
                ),
                messageScenarioStep(
                    id: "emergency-bag-security",
                    momentType: .ask,
                    scene: "You need someone with authority to help.",
                    localLine: "Bạn muốn gọi bảo vệ không?",
                    localLineMeaning: "Would you like to call security?",
                    userGoal: "Ask someone to call security.",
                    best: messageReply(
                        "viet-family-v500-prob-help-can-you-call-security",
                        vietnamese: "Bạn gọi bảo vệ giúp tôi được không?",
                        english: "Can you call security?",
                        nextLocalLine: "Được, tôi sẽ gọi bảo vệ ngay.",
                        nextLocalMeaning: "Yes, I will call security now."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-emergency-police",
                            vietnamese: "Gọi công an giúp tôi",
                            english: "Please call the police",
                            nextLocalLine: "Được, nếu cần chúng tôi sẽ gọi công an.",
                            nextLocalMeaning: "Okay, if needed we will call the police."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-please-stay-with-me",
                            vietnamese: "Làm ơn ở lại với tôi",
                            english: "Please stay with me",
                            nextLocalLine: "Được, tôi sẽ ở đây hỗ trợ bạn.",
                            nextLocalMeaning: "Yes, I will stay here and help you."
                        ),
                    ],
                    recoveryTitle: "If you feel shaken",
                    recoveryBody: "Ask the first staff member to stay with you while calling security.",
                    nextStepTitle: "Check cameras",
                    localScenarioContext: "emergency_bag_security"
                ),
                messageScenarioStep(
                    id: "emergency-bag-camera",
                    momentType: .ask,
                    scene: "Security asks where the bag went missing.",
                    localLine: "Bạn muốn chúng tôi kiểm tra camera khu vực này không?",
                    localLineMeaning: "Do you want us to check the camera in this area?",
                    userGoal: "Ask them to check the security camera.",
                    best: messageReply(
                        "viet-family-v500-prob-help-can-you-check-the-security-camera",
                        vietnamese: "Bạn kiểm tra camera an ninh giúp tôi được không?",
                        english: "Can you check the security camera?",
                        nextLocalLine: "Được, chúng tôi sẽ kiểm tra camera khu vực này.",
                        nextLocalMeaning: "Yes, we will check the cameras in this area."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-prob-help-this-is-what-happened",
                            vietnamese: "Đây là chuyện đã xảy ra",
                            english: "This is what happened",
                            nextLocalLine: "Được, bạn nói chậm để tôi ghi lại.",
                            nextLocalMeaning: "Okay, please speak slowly so I can write it down."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-please-write-down-your-name",
                            vietnamese: "Làm ơn viết tên của bạn giúp tôi",
                            english: "Please write down your name",
                            nextLocalLine: "Được, tôi sẽ viết tên người hỗ trợ bạn.",
                            nextLocalMeaning: "Yes, I will write the helper's name."
                        ),
                    ],
                    recoveryTitle: "Keep the timeline simple",
                    recoveryBody: "Point to where you were standing and give the time as closely as you can.",
                    nextStepTitle: "File a report",
                    localScenarioContext: "emergency_bag_camera"
                ),
                messageScenarioStep(
                    id: "emergency-bag-report",
                    momentType: .ask,
                    scene: "Security can create a basic report for insurance.",
                    localLine: "Bạn cần báo cáo cho bảo hiểm không?",
                    localLineMeaning: "Do you need a report for insurance?",
                    userGoal: "Ask to file a report.",
                    best: messageReply(
                        "viet-family-help-file-report",
                        vietnamese: "Tôi cần làm báo cáo",
                        english: "I need to file a report",
                        nextLocalLine: "Được, chúng tôi sẽ lập báo cáo cho bạn.",
                        nextLocalMeaning: "Okay, we will make a report for you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-prob-help-i-need-a-police-report-for-insurance",
                            vietnamese: "Tôi cần giấy báo công an cho bảo hiểm",
                            english: "I need a police report for insurance",
                            nextLocalLine: "Tôi hiểu, chúng tôi sẽ hướng dẫn bạn đến công an.",
                            nextLocalMeaning: "I understand. We will guide you to the police."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-can-i-have-an-interpreter",
                            vietnamese: "Tôi có thể có phiên dịch không?",
                            english: "Can I have an interpreter?",
                            nextLocalLine: "Được, tôi sẽ tìm người hỗ trợ tiếng Anh.",
                            nextLocalMeaning: "Yes, I will find someone who can help in English."
                        ),
                    ],
                    recoveryTitle: "If the report is for insurance",
                    recoveryBody: "Ask for a printed or emailed copy before leaving.",
                    nextStepTitle: "Leave contact info",
                    localScenarioContext: "emergency_bag_report"
                ),
                messageScenarioStep(
                    id: "emergency-bag-emergency-help",
                    momentType: .ask,
                    scene: "The desk checks whether you need medical or emergency help after the bag incident.",
                    localLine: "Bạn có cần hỗ trợ khẩn cấp hoặc y tế không?",
                    localLineMeaning: "Do you need emergency or medical help?",
                    userGoal: "Ask when to seek emergency help, or name a simple medical need.",
                    best: messageReply(
                        "viet-family-v900-heal-phar-when-should-i-seek-emergency-help",
                        vietnamese: "Khi nào tôi nên tìm kiếm sự giúp đỡ khẩn cấp?",
                        english: "When should I seek emergency help?",
                        nextLocalLine: "Nếu bạn bị thương hoặc thấy không an toàn, chúng tôi gọi hỗ trợ ngay.",
                        nextLocalMeaning: "If you are injured or feel unsafe, we will call help right away."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-heal-phar-i-need-a-dentist",
                            vietnamese: "Tôi cần một nha sĩ",
                            english: "I need a dentist",
                            nextLocalLine: "Được, tôi sẽ chỉ phòng khám nha gần đây.",
                            nextLocalMeaning: "Okay, I will show you a nearby dental clinic."
                        ),
                        messageReply(
                            "viet-family-v900-heal-phar-i-need-mosquito-repellent",
                            vietnamese: "Tôi cần thuốc chống muỗi",
                            english: "I need mosquito repellent",
                            nextLocalLine: "Nhà thuốc gần đây có thuốc chống muỗi.",
                            nextLocalMeaning: "The nearby pharmacy has mosquito repellent."
                        ),
                    ],
                    recoveryPageIDs: [
                        "viet-family-v500-prob-help-i-need-help-now",
                        "viet-family-v500-prob-help-can-i-have-an-interpreter",
                    ],
                    recoveryTitle: "If you feel unsafe or hurt",
                    recoveryBody: "Ask for emergency help before continuing the report.",
                    nextStepTitle: "Leave contact info",
                    localScenarioContext: "emergency_bag_emergency_help"
                ),
                messageScenarioStep(
                    id: "emergency-bag-contact",
                    momentType: .ask,
                    scene: "The desk may need to contact you if they find the bag.",
                    localLine: "Bạn để lại số điện thoại được không?",
                    localLineMeaning: "Can you leave your phone number?",
                    userGoal: "Leave contact information and ask for a copy.",
                    best: messageReply(
                        "viet-family-v500-prob-help-can-i-leave-my-contact-information",
                        vietnamese: "Tôi để lại thông tin liên hệ được không?",
                        english: "Can I leave my contact information?",
                        nextLocalLine: "Được, bạn ghi số điện thoại ở đây.",
                        nextLocalMeaning: "Yes, write your phone number here."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-prob-help-please-give-me-a-copy-of-the-report",
                            vietnamese: "Làm ơn cho tôi một bản sao báo cáo",
                            english: "Please give me a copy of the report",
                            nextLocalLine: "Được, tôi sẽ đưa bạn một bản sao.",
                            nextLocalMeaning: "Yes, I will give you a copy."
                        ),
                        messageReply(
                            "viet-family-v900-prob-help-thank-you-for-helping-me-report-this",
                            vietnamese: "Cảm ơn bạn đã giúp tôi báo việc này",
                            english: "Thank you for helping me report this",
                            nextLocalLine: "Không có gì, chúng tôi sẽ liên hệ nếu tìm thấy túi.",
                            nextLocalMeaning: "You are welcome. We will contact you if we find the bag."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "emergency_bag_contact"
                ),
                messageGoodbyeStep(
                    id: "emergency-bag-goodbye",
                    scene: "The missing bag report is filed and the desk has your contact information.",
                    localLine: "Chúng tôi sẽ liên hệ nếu có thông tin mới.",
                    localLineMeaning: "We will contact you if there is new information.",
                    nextLocalLine: "Không có gì, mong bạn sớm tìm lại được túi.",
                    nextLocalMeaning: "You are welcome. I hope you find your bag soon.",
                    localScenarioContext: "emergency_bag_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .localGreetingMarket,
            sceneTitle: "Market hello",
            sceneSetup: "Warm hellos, light browsing, thank-you, and goodbye at a local market stall.",
            steps: [
                messageScenarioStep(
                    id: "greeting-market-opening",
                    momentType: .listen,
                    scene: "A vendor greets you at a market stall.",
                    localLine: "Xin chào, bạn muốn xem gì?",
                    localLineMeaning: "Hello, what would you like to see?",
                    userGoal: "Use a friendly neutral hello.",
                    best: messageReply(
                        "viet-family-hello-chao-ban",
                        vietnamese: "Chào bạn",
                        english: "Hello to a peer",
                        nextLocalLine: "Chào bạn, bạn cứ xem thoải mái.",
                        nextLocalMeaning: "Hello, feel free to look around."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-polite-hello",
                            vietnamese: "Xin chào",
                            english: "General hello",
                            nextLocalLine: "Xin chào, bạn cần gì cứ nói nhé.",
                            nextLocalMeaning: "Hello, let me know what you need."
                        ),
                        messageReply(
                            "viet-family-hello-good-morning",
                            vietnamese: "Chào buổi sáng",
                            english: "Good morning",
                            nextLocalLine: "Chào buổi sáng, mời bạn xem hàng.",
                            nextLocalMeaning: "Good morning, please have a look."
                        ),
                    ],
                    nextStepTitle: "Browse politely",
                    localScenarioContext: "greeting_market_opening"
                ),
                messageScenarioStep(
                    id: "greeting-market-browse",
                    momentType: .ask,
                    scene: "You want to look without committing yet.",
                    localLine: "Bạn muốn mua cái này không?",
                    localLineMeaning: "Would you like to buy this one?",
                    userGoal: "Say you are just looking.",
                    best: messageReply(
                        "viet-family-shopping-just-looking",
                        vietnamese: "Tôi chỉ xem thôi",
                        english: "I'm just looking",
                        nextLocalLine: "Dạ được, bạn cứ xem thêm.",
                        nextLocalMeaning: "Sure, feel free to look more."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-polite-no-thanks",
                            vietnamese: "Không, cảm ơn",
                            english: "No, thank you",
                            nextLocalLine: "Dạ không sao.",
                            nextLocalMeaning: "No problem."
                        ),
                        messageReply(
                            "viet-family-v500-mone-numb-pric-ill-think-about-it",
                            vietnamese: "Tôi sẽ suy nghĩ thêm",
                            english: "I'll think about it",
                            nextLocalLine: "Dạ được, bạn cứ suy nghĩ.",
                            nextLocalMeaning: "Sure, take your time."
                        ),
                    ],
                    nextStepTitle: "Acknowledge",
                    localScenarioContext: "greeting_market_browse"
                ),
                messageScenarioStep(
                    id: "greeting-market-acknowledge",
                    momentType: .ask,
                    scene: "The vendor points out a smaller item.",
                    localLine: "Cái này rẻ hơn một chút.",
                    localLineMeaning: "This one is a little cheaper.",
                    userGoal: "Acknowledge politely.",
                    best: messageReply(
                        "viet-family-polite-acknowledge",
                        vietnamese: "Dạ, được",
                        english: "Yes, okay",
                        nextLocalLine: "Dạ, nếu cần tôi lấy cho bạn xem.",
                        nextLocalMeaning: "Okay, if you need it I can show it to you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-poli-basi-okay",
                            vietnamese: "Được rồi",
                            english: "Okay",
                            nextLocalLine: "Dạ, bạn xem tiếp nhé.",
                            nextLocalMeaning: "Okay, keep looking."
                        ),
                        messageReply(
                            "viet-family-v900-poli-basi-thats-fine",
                            vietnamese: "Vậy được rồi",
                            english: "That's fine",
                            nextLocalLine: "Dạ, như vậy được nhé.",
                            nextLocalMeaning: "Yes, that works."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "greeting_market_acknowledge"
                ),
                messageScenarioStep(
                    id: "greeting-market-thanks",
                    momentType: .ask,
                    scene: "The vendor has been patient while you browsed.",
                    localLine: "Bạn cần tôi giữ món này không?",
                    localLineMeaning: "Do you need me to hold this item?",
                    userGoal: "Thank them and decline for now.",
                    best: messageReply(
                        "viet-family-polite-thank-you",
                        vietnamese: "Cảm ơn",
                        english: "Thank you",
                        nextLocalLine: "Không có gì.",
                        nextLocalMeaning: "You are welcome."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-mone-numb-pric-no-thanks-maybe-later",
                            vietnamese: "Không, cảm ơn, để sau",
                            english: "No thanks, maybe later",
                            nextLocalLine: "Dạ được, hẹn bạn lần sau.",
                            nextLocalMeaning: "Sure, maybe next time."
                        ),
                        messageReply(
                            "viet-family-v900-poli-basi-no-problem",
                            vietnamese: "Không sao",
                            english: "No problem",
                            nextLocalLine: "Dạ, cảm ơn bạn.",
                            nextLocalMeaning: "Okay, thank you."
                        ),
                    ],
                    nextStepTitle: "Close",
                    localScenarioContext: "greeting_market_thanks"
                ),
                messageScenarioStep(
                    id: "greeting-market-small-talk",
                    momentType: .ask,
                    scene: "The exchange is friendly, and you want one light local phrase before leaving.",
                    localLine: "Bạn muốn nói gì thêm không?",
                    localLineMeaning: "Would you like to say anything else?",
                    userGoal: "Use a short friendly phrase that keeps the conversation easy.",
                    best: messageReply(
                        "viet-family-hello-good-morning",
                        vietnamese: "Chào buổi sáng",
                        english: "Good morning",
                        nextLocalLine: "Chào buổi sáng, chúc bạn một ngày vui.",
                        nextLocalMeaning: "Good morning, have a nice day."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-poli-basi-no-problem",
                            vietnamese: "Không có gì",
                            english: "No problem",
                            nextLocalLine: "Dạ, không sao. Bạn cứ xem tiếp nhé.",
                            nextLocalMeaning: "No problem. Feel free to keep looking."
                        ),
                        messageReply(
                            "viet-family-v900-poli-basi-im-in-a-hurry",
                            vietnamese: "Tôi đang vội",
                            english: "I'm in a hurry",
                            nextLocalLine: "Dạ được, hẹn gặp lại bạn.",
                            nextLocalMeaning: "Okay, see you again."
                        ),
                    ],
                    recoveryPageIDs: [
                        "viet-family-polite-thank-you",
                        "viet-goodbye",
                    ],
                    recoveryTitle: "If small talk feels hard",
                    recoveryBody: "A short hello, thank-you, or goodbye is enough.",
                    nextStepTitle: "Close",
                    localScenarioContext: "greeting_market_small_talk"
                ),
                messageScenarioStep(
                    id: "greeting-market-goodbye-prep",
                    momentType: .ask,
                    scene: "You are leaving the stall.",
                    localLine: "Bạn đi nhé?",
                    localLineMeaning: "Are you leaving now?",
                    userGoal: "Say goodbye warmly.",
                    best: messageReply(
                        "viet-family-polite-goodbye",
                        vietnamese: "Tạm biệt",
                        english: "Goodbye",
                        nextLocalLine: "Tạm biệt, hẹn gặp lại.",
                        nextLocalMeaning: "Goodbye, see you again."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-hello-chao",
                            vietnamese: "Chào nhé",
                            english: "Bye for now",
                            nextLocalLine: "Chào bạn, hẹn gặp lại.",
                            nextLocalMeaning: "Bye, see you again."
                        ),
                        messageReply(
                            "viet-family-v900-shop-no-thank-you-ill-look-around-first",
                            vietnamese: "Không, cảm ơn, tôi xem chỗ khác trước",
                            english: "No thank you, I'll look around first",
                            nextLocalLine: "Dạ được, chúc bạn mua sắm vui.",
                            nextLocalMeaning: "Sure, enjoy shopping."
                        ),
                    ],
                    nextStepTitle: "Finish story",
                    localScenarioContext: "greeting_market_goodbye_prep"
                ),
                messageGoodbyeStep(
                    id: "greeting-market-goodbye",
                    scene: "The vendor responds to your goodbye.",
                    localLine: "Tạm biệt, hẹn gặp lại.",
                    localLineMeaning: "Goodbye, see you again.",
                    nextLocalLine: "Không có gì, chào bạn.",
                    nextLocalMeaning: "You are welcome, goodbye.",
                    localScenarioContext: "greeting_market_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .localGreetingHotel,
            sceneTitle: "Hotel hello",
            sceneSetup: "Use polite lobby greetings, wait language, sorry, thank-you, and goodbye with hotel staff.",
            steps: [
                messageScenarioStep(
                    id: "greeting-hotel-opening",
                    momentType: .listen,
                    scene: "You approach a hotel staff member at the front desk.",
                    localLine: "Xin chào, tôi có thể giúp gì cho bạn?",
                    localLineMeaning: "Hello, how can I help you?",
                    userGoal: "Use a polite greeting for a male staff member.",
                    best: messageReply(
                        "viet-family-hello-chao-anh",
                        vietnamese: "Chào anh",
                        english: "Hello to a male staff member",
                        nextLocalLine: "Chào bạn, bạn cần hỗ trợ gì?",
                        nextLocalMeaning: "Hello, what help do you need?"
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-acknowledge-da-chao-anh",
                            vietnamese: "Dạ, chào anh",
                            english: "Polite hello to a male staff member",
                            nextLocalLine: "Dạ, chào bạn, tôi nghe đây.",
                            nextLocalMeaning: "Hello, I am listening."
                        ),
                        messageReply(
                            "viet-family-hello-chao-chi",
                            vietnamese: "Chào chị",
                            english: "Hello to a female staff member",
                            nextLocalLine: "Chào bạn, chị có thể giúp gì?",
                            nextLocalMeaning: "Hello, how can I help?"
                        ),
                    ],
                    nextStepTitle: "Wait politely",
                    localScenarioContext: "greeting_hotel_opening"
                ),
                messageScenarioStep(
                    id: "greeting-hotel-wait",
                    momentType: .ask,
                    scene: "The front desk needs a moment to check something.",
                    localLine: "Bạn chờ tôi một chút nhé.",
                    localLineMeaning: "Please wait a moment.",
                    userGoal: "Acknowledge the wait.",
                    best: messageReply(
                        "viet-family-polite-acknowledge",
                        vietnamese: "Dạ, được",
                        english: "Yes, okay",
                        nextLocalLine: "Cảm ơn bạn đã chờ.",
                        nextLocalMeaning: "Thank you for waiting."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-poli-basi-yes",
                            vietnamese: "Dạ",
                            english: "Yes",
                            nextLocalLine: "Bạn chờ một chút nhé.",
                            nextLocalMeaning: "Please wait a moment."
                        ),
                        messageReply(
                            "viet-family-transport-wait",
                            vietnamese: "Chờ tôi năm phút",
                            english: "Wait for me five minutes",
                            nextLocalLine: "Được, tôi chờ bạn ở sảnh.",
                            nextLocalMeaning: "Okay, I will wait for you in the lobby."
                        ),
                    ],
                    nextStepTitle: "Repair politely",
                    localScenarioContext: "greeting_hotel_wait"
                ),
                messageScenarioStep(
                    id: "greeting-hotel-sorry",
                    momentType: .ask,
                    scene: "You misunderstood the staff and want to stay polite.",
                    localLine: "Bạn nghe rõ không?",
                    localLineMeaning: "Did you hear clearly?",
                    userGoal: "Ask them to repeat or slow down, then stay polite.",
                    best: messageReply(
                        "viet-family-repair-repeat",
                        vietnamese: "Làm ơn nói lại",
                        english: "Please say that again",
                        nextLocalLine: "Không sao, tôi nói lại nhé.",
                        nextLocalMeaning: "No problem, I will say it again."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-repair-slower",
                            vietnamese: "Nói chậm giúp tôi được không?",
                            english: "Could you speak a little slower, please?",
                            nextLocalLine: "Được, tôi sẽ nói chậm hơn.",
                            nextLocalMeaning: "Sure, I will speak more slowly."
                        ),
                        messageReply(
                            "viet-family-v500-poli-basi-sorry",
                            vietnamese: "Xin lỗi",
                            english: "Sorry",
                            nextLocalLine: "Không sao, bạn cứ từ từ.",
                            nextLocalMeaning: "No problem, take your time."
                        ),
                    ],
                    nextStepTitle: "Ask permission",
                    localScenarioContext: "greeting_hotel_sorry"
                ),
                messageScenarioStep(
                    id: "greeting-hotel-permission",
                    momentType: .ask,
                    scene: "You need to enter a lobby area or sit nearby.",
                    localLine: "Bạn muốn ngồi ở đây không?",
                    localLineMeaning: "Would you like to sit here?",
                    userGoal: "Ask permission politely.",
                    best: messageReply(
                        "viet-family-v900-poli-basi-can-i-sit-here",
                        vietnamese: "Tôi ngồi đây được không?",
                        english: "Can I sit here?",
                        nextLocalLine: "Được, bạn ngồi đây nhé.",
                        nextLocalMeaning: "Yes, you can sit here."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-poli-basi-can-i-come-in",
                            vietnamese: "Tôi vào được không?",
                            english: "Can I come in?",
                            nextLocalLine: "Được, mời bạn vào.",
                            nextLocalMeaning: "Yes, please come in."
                        ),
                        messageReply(
                            "viet-family-v900-poli-basi-may-i",
                            vietnamese: "Tôi xin phép",
                            english: "May I?",
                            nextLocalLine: "Dạ được, mời bạn.",
                            nextLocalMeaning: "Yes, please."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "greeting_hotel_permission"
                ),
                messageScenarioStep(
                    id: "greeting-hotel-thanks",
                    momentType: .ask,
                    scene: "The staff has helped you and you want to close warmly.",
                    localLine: "Bạn cần gì thêm không?",
                    localLineMeaning: "Do you need anything else?",
                    userGoal: "Thank them for understanding.",
                    best: messageReply(
                        "viet-family-v500-unde-repa-thank-you-for-understanding",
                        vietnamese: "Cảm ơn bạn đã thông cảm",
                        english: "Thank you for understanding",
                        nextLocalLine: "Không có gì, bạn cần gì cứ nói.",
                        nextLocalMeaning: "You are welcome, let me know if you need anything."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-polite-thank-you",
                            vietnamese: "Cảm ơn",
                            english: "Thank you",
                            nextLocalLine: "Không có gì.",
                            nextLocalMeaning: "You are welcome."
                        ),
                        messageReply(
                            "viet-family-v900-hote-acco-everything-was-good-thank-you",
                            vietnamese: "Mọi thứ đều ổn, cảm ơn",
                            english: "Everything was good, thank you",
                            nextLocalLine: "Cảm ơn bạn, chúc bạn nghỉ ngơi vui vẻ.",
                            nextLocalMeaning: "Thank you, enjoy your stay."
                        ),
                    ],
                    nextStepTitle: "Say goodbye",
                    localScenarioContext: "greeting_hotel_thanks"
                ),
                messageGoodbyeStep(
                    id: "greeting-hotel-goodbye",
                    scene: "You are leaving the front desk.",
                    localLine: "Chúc bạn một ngày tốt lành.",
                    localLineMeaning: "Have a good day.",
                    nextLocalLine: "Không có gì, tạm biệt.",
                    nextLocalMeaning: "You are welcome, goodbye.",
                    localScenarioContext: "greeting_hotel_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .localGreetingRespect,
            sceneTitle: "Respectful hello",
            sceneSetup: "Keep one respectful neighborhood-shop exchange going from hello to help, thanks, and goodbye.",
            steps: [
                messageScenarioStep(
                    id: "greeting-respect-opening",
                    momentType: .listen,
                    scene: "An older woman at a neighborhood shop smiles and greets you.",
                    localLine: "Xin chào.",
                    localLineMeaning: "Hello.",
                    userGoal: "Use a respectful hello for an older woman.",
                    best: messageReply(
                        "viet-family-acknowledge-da-chao-co",
                        vietnamese: "Dạ, chào cô",
                        english: "Respectful hello, auntie.",
                        nextLocalLine: "Chào bạn, bạn muốn xem gì?",
                        nextLocalMeaning: "Hello, what would you like to look at?"
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-hello-chao-co",
                            vietnamese: "Chào cô",
                            english: "Hello, auntie.",
                            nextLocalLine: "Chào bạn, bạn muốn xem gì?",
                            nextLocalMeaning: "Hello, what would you like to look at?"
                        ),
                        messageReply(
                            "viet-family-acknowledge-da-chao-ba",
                            vietnamese: "Dạ, chào bà",
                            english: "Respectful hello, ma'am.",
                            nextLocalLine: "Chào bạn, bạn muốn xem gì?",
                            nextLocalMeaning: "Hello, what would you like to look at?"
                        ),
                    ],
                    nextStepTitle: "Look around",
                    localScenarioContext: "greeting_respect_opening"
                ),
                messageScenarioStep(
                    id: "greeting-respect-woman",
                    momentType: .ask,
                    scene: "The shop owner keeps the same conversation going after your greeting.",
                    localLine: "Bạn muốn xem gì?",
                    localLineMeaning: "What would you like to look at?",
                    userGoal: "Say you are just looking, or ask for help.",
                    best: messageReply(
                        "viet-family-shopping-just-looking",
                        vietnamese: "Tôi chỉ xem thôi",
                        english: "I'm just looking",
                        nextLocalLine: "Dạ, bạn cứ xem tự nhiên.",
                        nextLocalMeaning: "Okay, feel free to look around."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-shop-im-looking-for-a-gift",
                            vietnamese: "Tôi đang tìm một món quà",
                            english: "I'm looking for a gift",
                            nextLocalLine: "Dạ, quà nhỏ ở kệ này.",
                            nextLocalMeaning: "Okay, small gifts are on this shelf."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-can-you-help-me",
                            vietnamese: "Cô giúp tôi được không?",
                            english: "Can you help me?",
                            nextLocalLine: "Dạ được, bạn cần tìm gì?",
                            nextLocalMeaning: "Yes, what do you need to find?"
                        ),
                    ],
                    nextStepTitle: "Ask permission",
                    localScenarioContext: "greeting_respect_woman"
                ),
                messageScenarioStep(
                    id: "greeting-respect-permission",
                    momentType: .ask,
                    scene: "You want to enter a small room or sit down before asking a question.",
                    localLine: "Bạn muốn vào xem không?",
                    localLineMeaning: "Would you like to come in and look?",
                    userGoal: "Ask permission before entering.",
                    best: messageReply(
                        "viet-family-v900-poli-basi-can-i-come-in",
                        vietnamese: "Tôi có thể vào được không?",
                        english: "Can I come in?",
                        nextLocalLine: "Được, bạn vào đi.",
                        nextLocalMeaning: "Yes, come in."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-poli-basi-can-i-sit-here",
                            vietnamese: "Tôi có thể ngồi đây được không?",
                            english: "Can I sit here?",
                            nextLocalLine: "Được, bạn ngồi đây.",
                            nextLocalMeaning: "Yes, sit here."
                        ),
                        messageReply(
                            "viet-family-v900-poli-basi-may-i",
                            vietnamese: "Tôi có thể không?",
                            english: "May I?",
                            nextLocalLine: "Được, bạn cứ tự nhiên.",
                            nextLocalMeaning: "Yes, please feel free."
                        ),
                    ],
                    nextStepTitle: "Say yes politely",
                    localScenarioContext: "greeting_respect_permission"
                ),
                messageScenarioStep(
                    id: "greeting-respect-yes",
                    momentType: .ask,
                    scene: "The person offers help and you want to respond respectfully.",
                    localLine: "Con cần cô giúp không?",
                    localLineMeaning: "Do you need me to help?",
                    userGoal: "Use a short respectful yes.",
                    best: messageReply(
                        "viet-family-v500-poli-basi-yes",
                        vietnamese: "Dạ có",
                        english: "Yes",
                        nextLocalLine: "Được, cô giúp con.",
                        nextLocalMeaning: "Okay, I will help you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-poli-basi-okay",
                            vietnamese: "Dạ được",
                            english: "Okay",
                            nextLocalLine: "Được, con nói đi.",
                            nextLocalMeaning: "Okay, please tell me."
                        ),
                        messageReply(
                            "viet-family-v900-poli-basi-thats-fine",
                            vietnamese: "Dạ, vậy được rồi",
                            english: "That's fine",
                            nextLocalLine: "Dạ, vậy nhé.",
                            nextLocalMeaning: "Okay, that's fine."
                        ),
                    ],
                    nextStepTitle: "Thank politely",
                    localScenarioContext: "greeting_respect_yes"
                ),
                messageScenarioStep(
                    id: "greeting-respect-thanks",
                    momentType: .ask,
                    scene: "The person has helped with your question.",
                    localLine: "Con hiểu chưa?",
                    localLineMeaning: "Do you understand now?",
                    userGoal: "Thank them warmly.",
                    best: messageReply(
                        "viet-family-polite-thank-you",
                        vietnamese: "Cảm ơn",
                        english: "Thank you",
                        nextLocalLine: "Không có gì.",
                        nextLocalMeaning: "You are welcome."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-unde-repa-thank-you-for-understanding",
                            vietnamese: "Cảm ơn vì đã thông cảm",
                            english: "Thank you for understanding",
                            nextLocalLine: "Không có gì, con cứ từ từ.",
                            nextLocalMeaning: "You are welcome, take your time."
                        ),
                        messageReply(
                            "viet-family-v900-poli-basi-no-problem",
                            vietnamese: "Không sao",
                            english: "No problem",
                            nextLocalLine: "Ừ, không sao đâu.",
                            nextLocalMeaning: "Yes, no problem."
                        ),
                    ],
                    nextStepTitle: "Say goodbye",
                    localScenarioContext: "greeting_respect_thanks"
                ),
                messageGoodbyeStep(
                    id: "greeting-respect-goodbye",
                    scene: "You are leaving the neighborhood shop.",
                    localLine: "Chào con nhé.",
                    localLineMeaning: "Goodbye.",
                    nextLocalLine: "Không có gì, đi vui nhé.",
                    nextLocalMeaning: "You are welcome, enjoy your day.",
                    localScenarioContext: "greeting_respect_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .walkingDirectionsHelp,
            sceneTitle: "Walking help",
            sceneSetup: "Ask for the right direction, understand a simple turn, ask someone to write it down, and find pickup.",
            steps: [
                messageScenarioStep(
                    id: "walking-help-opening",
                    momentType: .listen,
                    scene: "You are walking and need simple directions before you keep going.",
                    localLine: "Xin chào, bạn muốn đi đâu?",
                    localLineMeaning: "Where do you want to go?",
                    userGoal: "Ask for the nearest information desk.",
                    best: messageReply(
                        "viet-family-v900-dire-navi-where-is-the-nearest-information-desk",
                        vietnamese: "Bàn thông tin gần nhất ở đâu?",
                        english: "Where is the nearest information desk?",
                        nextLocalLine: "Đi thẳng rồi rẽ phải.",
                        nextLocalMeaning: "Go straight, then turn right."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-directions-pickup-point",
                            vietnamese: "Điểm đón ở đâu?",
                            english: "Where is the pickup point?",
                            nextLocalLine: "Điểm đón ở phía trước.",
                            nextLocalMeaning: "The pickup point is ahead."
                        ),
                        messageReply(
                            "viet-phrase-directions-8",
                            vietnamese: "Bạn chỉ giúp tôi được không?",
                            english: "Can you show me?",
                            nextLocalLine: "Được, tôi chỉ đường cho bạn.",
                            nextLocalMeaning: "Yes, I will show you the way."
                        ),
                    ],
                    nextStepTitle: "Follow direction",
                    localScenarioContext: "walking_help_opening"
                ),
                messageScenarioStep(
                    id: "walking-help-turn",
                    scene: "The person gives a short direction and you want to confirm the next move.",
                    localLine: "Bạn đi thẳng rồi rẽ phải.",
                    localLineMeaning: "Go straight, then turn right.",
                    userGoal: "Repeat the direction simply.",
                    best: messageReply(
                        "viet-family-v500-tran-please-go-straight",
                        vietnamese: "Đi thẳng giúp tôi",
                        english: "Please go straight",
                        nextLocalLine: "Đúng rồi, đi thẳng.",
                        nextLocalMeaning: "That's right, go straight."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-tran-please-turn-right-here",
                            vietnamese: "Vui lòng rẽ phải ở đây",
                            english: "Please turn right here",
                            nextLocalLine: "Đúng, rẽ phải ở đây.",
                            nextLocalMeaning: "Yes, turn right here."
                        ),
                        messageReply(
                            "viet-family-v900-tran-please-turn-left-at-the-next-street",
                            vietnamese: "Vui lòng rẽ trái ở đường tiếp theo",
                            english: "Please turn left at the next street",
                            nextLocalLine: "Không, rẽ phải ở đường này.",
                            nextLocalMeaning: "No, turn right at this street."
                        ),
                    ],
                    nextStepTitle: "Ask again",
                    localScenarioContext: "walking_help_turn"
                ),
                messageScenarioStep(
                    id: "walking-help-repeat",
                    scene: "You did not catch the direction the first time.",
                    localLine: "Bạn hiểu chưa?",
                    localLineMeaning: "Do you understand?",
                    userGoal: "Ask them to repeat slowly.",
                    best: messageReply(
                        "viet-family-repair-repeat",
                        vietnamese: "Làm ơn nói lại",
                        english: "Please say that again",
                        nextLocalLine: "Được, đi thẳng rồi rẽ phải.",
                        nextLocalMeaning: "Okay, go straight, then turn right."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-repair-slower",
                            vietnamese: "Nói chậm chút được không?",
                            english: "Can you speak a little slower?",
                            nextLocalLine: "Được, tôi nói chậm hơn.",
                            nextLocalMeaning: "Yes, I will speak more slowly."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-can-you-help-me",
                            vietnamese: "Bạn giúp tôi được không?",
                            english: "Can you help me?",
                            nextLocalLine: "Được, tôi giúp bạn.",
                            nextLocalMeaning: "Yes, I will help you."
                        ),
                    ],
                    nextStepTitle: "Write address",
                    localScenarioContext: "walking_help_repeat"
                ),
                messageScenarioStep(
                    id: "walking-help-write",
                    scene: "You want the address written down so you can show it to a driver.",
                    localLine: "Bạn cần địa chỉ này không?",
                    localLineMeaning: "Do you need this address?",
                    userGoal: "Ask them to write the address.",
                    best: messageReply(
                        "viet-phrase-v900-dire-navi-please-write-the-address-for-me",
                        vietnamese: "Vui lòng viết địa chỉ cho tôi",
                        english: "Please write the address for me",
                        nextLocalLine: "Được, tôi viết địa chỉ cho bạn.",
                        nextLocalMeaning: "Yes, I will write the address for you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-directions-pickup-point",
                            vietnamese: "Điểm đón ở đâu?",
                            english: "Where is the pickup point?",
                            nextLocalLine: "Điểm đón ở trước tòa nhà.",
                            nextLocalMeaning: "The pickup point is in front of the building."
                        ),
                        messageReply(
                            "viet-phrase-directions-8",
                            vietnamese: "Bạn chỉ giúp tôi được không?",
                            english: "Can you show me?",
                            nextLocalLine: "Được, tôi chỉ trên bản đồ.",
                            nextLocalMeaning: "Yes, I will show you on the map."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "walking_help_write"
                ),
                messageScenarioStep(
                    id: "walking-help-pickup",
                    scene: "You have the address, but still need the right pickup spot.",
                    localLine: "Bạn đón xe ở phía trước nhé.",
                    localLineMeaning: "Meet your ride in front.",
                    userGoal: "Confirm the pickup point.",
                    best: messageReply(
                        "viet-family-directions-pickup-point",
                        vietnamese: "Điểm đón ở đâu?",
                        english: "Where is the pickup point?",
                        nextLocalLine: "Điểm đón ở trước tòa nhà.",
                        nextLocalMeaning: "The pickup point is in front of the building."
                    ),
                    alternates: [
                        messageReply(
                            "viet-phrase-directions-8",
                            vietnamese: "Bạn chỉ giúp tôi được không?",
                            english: "Can you show me?",
                            nextLocalLine: "Được, tôi chỉ trên bản đồ.",
                            nextLocalMeaning: "Yes, I will show you on the map."
                        ),
                        messageReply(
                            "viet-family-polite-thank-you",
                            vietnamese: "Cảm ơn",
                            english: "Thank you",
                            nextLocalLine: "Không có gì.",
                            nextLocalMeaning: "You are welcome."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "walking_help_pickup"
                ),
                messageGoodbyeStep(
                    id: "walking-help-goodbye",
                    scene: "You have the direction and are ready to keep walking.",
                    localLine: "Bạn đi thẳng rồi rẽ phải nhé.",
                    localLineMeaning: "Go straight, then turn right.",
                    nextLocalLine: "Không có gì, đi cẩn thận nhé.",
                    nextLocalMeaning: "You are welcome, take care.",
                    localScenarioContext: "walking_help_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .shoppingPayCard,
            sceneTitle: "Pay by card",
            sceneSetup: "Ask about card payment, QR payment, a declined card, receipts, and canceling a mistake.",
            steps: [
                messageScenarioStep(
                    id: "pay-card-opening",
                    momentType: .listen,
                    scene: "You are at the register and want to pay without cash.",
                    localLine: "Xin chào, bạn thanh toán bằng tiền mặt hay thẻ?",
                    localLineMeaning: "Will you pay by cash or card?",
                    userGoal: "Ask to pay by card.",
                    best: messageReply(
                        "viet-family-service-card",
                        vietnamese: "Tôi quẹt thẻ được không?",
                        english: "Can I pay by card?",
                        nextLocalLine: "Dạ được, bạn quẹt thẻ ở đây.",
                        nextLocalMeaning: "Yes, tap your card here."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v900-mone-numb-pric-can-i-pay-by-qr-code",
                            vietnamese: "Tôi thanh toán bằng mã QR được không?",
                            english: "Can I pay by QR code?",
                            nextLocalLine: "Dạ được, mã QR ở đây.",
                            nextLocalMeaning: "Yes, the QR code is here."
                        ),
                        messageReply(
                            "viet-family-money-how-much",
                            vietnamese: "Bao nhiêu tiền?",
                            english: "How much is it?",
                            nextLocalLine: "Tổng cộng là hai trăm nghìn.",
                            nextLocalMeaning: "The total is two hundred thousand."
                        ),
                    ],
                    nextStepTitle: "Try again",
                    localScenarioContext: "shopping_pay_card_opening"
                ),
                messageScenarioStep(
                    id: "pay-card-retry",
                    scene: "The first payment does not work and you want to try another card.",
                    localLine: "Thẻ này chưa được.",
                    localLineMeaning: "This card did not work.",
                    userGoal: "Ask to try another card.",
                    best: messageReply(
                        "viet-family-v500-mone-numb-pric-can-i-try-another-card",
                        vietnamese: "Tôi thử thẻ khác được không?",
                        english: "Can I try another card?",
                        nextLocalLine: "Dạ được, bạn thử thẻ khác.",
                        nextLocalMeaning: "Yes, try another card."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-service-card",
                            vietnamese: "Tôi quẹt thẻ được không?",
                            english: "Can I pay by card?",
                            nextLocalLine: "Dạ được, thử lại nhé.",
                            nextLocalMeaning: "Yes, please try again."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-can-you-help-me",
                            vietnamese: "Bạn giúp tôi được không?",
                            english: "Can you help me?",
                            nextLocalLine: "Được, tôi kiểm tra máy thanh toán.",
                            nextLocalMeaning: "Yes, I will check the payment machine."
                        ),
                    ],
                    nextStepTitle: "Confirm payment",
                    localScenarioContext: "shopping_pay_card_retry"
                ),
                messageScenarioStep(
                    id: "pay-card-through",
                    scene: "The payment seems to go through and you need to confirm it.",
                    localLine: "Máy báo thành công rồi.",
                    localLineMeaning: "The machine says it succeeded.",
                    userGoal: "Confirm the payment went through.",
                    best: messageReply(
                        "viet-family-v900-mone-numb-pric-the-payment-went-through",
                        vietnamese: "Thanh toán đã thành công",
                        english: "The payment went through",
                        nextLocalLine: "Dạ đúng rồi, thanh toán thành công.",
                        nextLocalMeaning: "Yes, the payment succeeded."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-mone-numb-pric-can-i-have-a-receipt",
                            vietnamese: "Cho tôi hóa đơn được không?",
                            english: "Can I have a receipt?",
                            nextLocalLine: "Dạ, tôi in hóa đơn cho bạn.",
                            nextLocalMeaning: "Yes, I will print a receipt for you."
                        ),
                        messageReply(
                            "viet-family-v900-mone-numb-pric-please-cancel-that-card-payment",
                            vietnamese: "Vui lòng hủy thanh toán thẻ đó",
                            english: "Please cancel that card payment",
                            nextLocalLine: "Được, tôi kiểm tra giao dịch.",
                            nextLocalMeaning: "Okay, I will check the transaction."
                        ),
                    ],
                    nextStepTitle: "Get receipt",
                    localScenarioContext: "shopping_pay_card_through"
                ),
                messageScenarioStep(
                    id: "pay-card-receipt",
                    scene: "Before leaving, you want a receipt you can keep.",
                    localLine: "Bạn có cần hóa đơn không?",
                    localLineMeaning: "Do you need a receipt?",
                    userGoal: "Ask them to print the receipt.",
                    best: messageReply(
                        "viet-family-v900-mone-numb-pric-can-you-print-the-receipt",
                        vietnamese: "Bạn in hóa đơn được không?",
                        english: "Can you print the receipt?",
                        nextLocalLine: "Dạ được, tôi in ngay.",
                        nextLocalMeaning: "Yes, I will print it now."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-mone-numb-pric-can-i-have-a-receipt",
                            vietnamese: "Cho tôi hóa đơn được không?",
                            english: "Can I have a receipt?",
                            nextLocalLine: "Dạ, đây là hóa đơn.",
                            nextLocalMeaning: "Yes, here is the receipt."
                        ),
                        messageReply(
                            "viet-family-v500-shop-okay-ill-take-it",
                            vietnamese: "Được, tôi lấy cái này",
                            english: "Okay, I'll take it",
                            nextLocalLine: "Dạ, tôi bỏ vào túi cho bạn.",
                            nextLocalMeaning: "Yes, I will put it in a bag for you."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "shopping_pay_card_receipt"
                ),
                messageScenarioStep(
                    id: "pay-card-bag",
                    scene: "The payment is done and the cashier asks if this is the item you want.",
                    localLine: "Bạn lấy cái này nhé?",
                    localLineMeaning: "You will take this one, right?",
                    userGoal: "Confirm you will take it.",
                    best: messageReply(
                        "viet-family-v500-shop-okay-ill-take-it",
                        vietnamese: "Được, tôi lấy cái này",
                        english: "Okay, I'll take it",
                        nextLocalLine: "Dạ, tôi bỏ vào túi cho bạn.",
                        nextLocalMeaning: "Yes, I will put it in a bag for you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-mone-numb-pric-can-i-have-a-receipt",
                            vietnamese: "Cho tôi hóa đơn được không?",
                            english: "Can I have a receipt?",
                            nextLocalLine: "Dạ, đây là hóa đơn.",
                            nextLocalMeaning: "Yes, here is the receipt."
                        ),
                        messageReply(
                            "viet-family-polite-thank-you",
                            vietnamese: "Cảm ơn",
                            english: "Thank you",
                            nextLocalLine: "Không có gì.",
                            nextLocalMeaning: "You are welcome."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "shopping_pay_card_bag"
                ),
                messageGoodbyeStep(
                    id: "pay-card-goodbye",
                    scene: "You have paid and have the receipt.",
                    localLine: "Tạm biệt nhé.",
                    localLineMeaning: "Goodbye.",
                    nextLocalLine: "Không có gì, hẹn gặp lại.",
                    nextLocalMeaning: "You are welcome, see you again.",
                    localScenarioContext: "shopping_pay_card_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .emergencyDoctorHelp,
            sceneTitle: "Doctor help",
            sceneSetup: "Ask for a doctor, clinic, hospital, English-speaking help, and a simple interpreter fallback.",
            steps: [
                messageScenarioStep(
                    id: "doctor-help-opening",
                    momentType: .listen,
                    scene: "You are not feeling well and need medical help.",
                    localLine: "Xin chào, tôi có thể giúp gì cho bạn?",
                    localLineMeaning: "Hello, how can I help you?",
                    userGoal: "Say you need a doctor.",
                    best: messageReply(
                        "viet-family-health-doctor",
                        vietnamese: "Tôi cần bác sĩ",
                        english: "I need a doctor",
                        nextLocalLine: "Được, tôi giúp bạn gọi bác sĩ.",
                        nextLocalMeaning: "Okay, I will help you call a doctor."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-heal-phar-can-you-call-a-doctor",
                            vietnamese: "Bạn gọi bác sĩ giúp tôi được không?",
                            english: "Can you call a doctor for me?",
                            nextLocalLine: "Được, tôi gọi ngay.",
                            nextLocalMeaning: "Yes, I will call now."
                        ),
                        messageReply(
                            "viet-family-v500-heal-phar-i-need-a-clinic",
                            vietnamese: "Tôi cần phòng khám",
                            english: "I need a clinic",
                            nextLocalLine: "Có phòng khám gần đây.",
                            nextLocalMeaning: "There is a clinic nearby."
                        ),
                    ],
                    nextStepTitle: "Find hospital",
                    localScenarioContext: "doctor_help_opening"
                ),
                messageScenarioStep(
                    id: "doctor-help-hospital",
                    scene: "The person asks where you want to go for care.",
                    localLine: "Bạn muốn đến phòng khám hay bệnh viện?",
                    localLineMeaning: "Do you want to go to a clinic or hospital?",
                    userGoal: "Ask for the hospital.",
                    best: messageReply(
                        "viet-family-emergency-hospital",
                        vietnamese: "Bệnh viện ở đâu?",
                        english: "Where is the hospital?",
                        nextLocalLine: "Bệnh viện gần nhất cách đây mười phút.",
                        nextLocalMeaning: "The nearest hospital is ten minutes away."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-heal-phar-i-need-a-clinic",
                            vietnamese: "Tôi cần phòng khám",
                            english: "I need a clinic",
                            nextLocalLine: "Phòng khám ở gần đây.",
                            nextLocalMeaning: "The clinic is nearby."
                        ),
                        messageReply(
                            "viet-family-v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis",
                            vietnamese: "Có bác sĩ hoặc dược sĩ nói tiếng Anh không?",
                            english: "Is there an English-speaking doctor or pharmacist?",
                            nextLocalLine: "Tôi sẽ hỏi giúp bạn.",
                            nextLocalMeaning: "I will ask for you."
                        ),
                    ],
                    nextStepTitle: "Explain symptoms",
                    localScenarioContext: "doctor_help_hospital"
                ),
                messageScenarioStep(
                    id: "doctor-help-symptom",
                    scene: "You need to explain the simplest symptom first.",
                    localLine: "Bạn bị làm sao?",
                    localLineMeaning: "What is wrong?",
                    userGoal: "Say one simple symptom.",
                    best: messageReply(
                        "viet-family-v500-heal-phar-i-have-a-fever",
                        vietnamese: "Tôi bị sốt",
                        english: "I have a fever",
                        nextLocalLine: "Tôi hiểu rồi. Bạn cần nghỉ và gặp bác sĩ.",
                        nextLocalMeaning: "I understand. You need rest and a doctor."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-health-headache",
                            vietnamese: "Tôi bị đau đầu",
                            english: "I have a headache",
                            nextLocalLine: "Tôi hiểu rồi.",
                            nextLocalMeaning: "I understand."
                        ),
                        messageReply(
                            "viet-family-health-stomach",
                            vietnamese: "Tôi bị đau bụng",
                            english: "My stomach hurts",
                            nextLocalLine: "Tôi hiểu rồi.",
                            nextLocalMeaning: "I understand."
                        ),
                    ],
                    nextStepTitle: "Ask language help",
                    localScenarioContext: "doctor_help_symptom"
                ),
                messageScenarioStep(
                    id: "doctor-help-english",
                    scene: "You want help communicating clearly at the clinic.",
                    localLine: "Bạn có cần người phiên dịch không?",
                    localLineMeaning: "Do you need an interpreter?",
                    userGoal: "Ask for an interpreter.",
                    best: messageReply(
                        "viet-family-v500-prob-help-can-i-have-an-interpreter",
                        vietnamese: "Tôi có thể có phiên dịch không?",
                        english: "Can I have an interpreter?",
                        nextLocalLine: "Được, tôi sẽ tìm người giúp bạn.",
                        nextLocalMeaning: "Yes, I will find someone to help you."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-prob-help-can-you-help-me",
                            vietnamese: "Bạn giúp tôi được không?",
                            english: "Can you help me?",
                            nextLocalLine: "Được, tôi sẽ giúp bạn.",
                            nextLocalMeaning: "Yes, I will help you."
                        ),
                        messageReply(
                            "viet-family-repair-slower",
                            vietnamese: "Nói chậm chút được không?",
                            english: "Can you speak a little slower?",
                            nextLocalLine: "Được, tôi sẽ nói chậm hơn.",
                            nextLocalMeaning: "Yes, I will speak more slowly."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "doctor_help_english"
                ),
                messageScenarioStep(
                    id: "doctor-help-call",
                    scene: "The person is ready to call someone for you.",
                    localLine: "Tôi gọi bác sĩ giúp bạn nhé?",
                    localLineMeaning: "Should I call a doctor for you?",
                    userGoal: "Ask them to call a doctor.",
                    best: messageReply(
                        "viet-family-v500-heal-phar-can-you-call-a-doctor",
                        vietnamese: "Bạn gọi bác sĩ giúp tôi được không?",
                        english: "Can you call a doctor for me?",
                        nextLocalLine: "Được, tôi gọi ngay.",
                        nextLocalMeaning: "Yes, I will call now."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-health-doctor",
                            vietnamese: "Tôi cần bác sĩ",
                            english: "I need a doctor",
                            nextLocalLine: "Được, tôi giúp bạn gọi bác sĩ.",
                            nextLocalMeaning: "Okay, I will help you call a doctor."
                        ),
                        messageReply(
                            "viet-family-v500-prob-help-can-you-help-me",
                            vietnamese: "Bạn giúp tôi được không?",
                            english: "Can you help me?",
                            nextLocalLine: "Được, tôi sẽ giúp bạn.",
                            nextLocalMeaning: "Yes, I will help you."
                        ),
                    ],
                    nextStepTitle: "Say thanks",
                    localScenarioContext: "doctor_help_call"
                ),
                messageGoodbyeStep(
                    id: "doctor-help-goodbye",
                    scene: "Someone is helping you get medical care.",
                    localLine: "Tôi sẽ gọi bác sĩ giúp bạn.",
                    localLineMeaning: "I will call a doctor for you.",
                    nextLocalLine: "Không có gì, mong bạn khỏe hơn.",
                    nextLocalMeaning: "You are welcome, I hope you feel better.",
                    localScenarioContext: "doctor_help_goodbye"
                ),
            ]
        ),
        PracticeScenarioTemplate(
            id: .localThanksSorry,
            sceneTitle: "Thanks & sorry",
            sceneSetup: "Handle a tiny polite moment: thank someone, apologize, ask them to repeat, say no thanks, and close.",
            steps: [
                messageScenarioStep(
                    id: "thanks-sorry-opening",
                    momentType: .listen,
                    scene: "Someone gives you quick help at a counter.",
                    localLine: "Xin chào, tôi giúp bạn xong rồi.",
                    localLineMeaning: "Okay, I finished helping you.",
                    userGoal: "Say thank you.",
                    best: messageReply(
                        "viet-family-polite-thank-you",
                        vietnamese: "Cảm ơn",
                        english: "Thank you",
                        nextLocalLine: "Không có gì.",
                        nextLocalMeaning: "You are welcome."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-unde-repa-thank-you-for-understanding",
                            vietnamese: "Cảm ơn vì đã thông cảm",
                            english: "Thank you for understanding",
                            nextLocalLine: "Không có gì.",
                            nextLocalMeaning: "You are welcome."
                        ),
                        messageReply(
                            "viet-family-v900-poli-basi-no-problem",
                            vietnamese: "Không sao",
                            english: "No problem",
                            nextLocalLine: "Dạ, không sao.",
                            nextLocalMeaning: "Yes, no problem."
                        ),
                    ],
                    nextStepTitle: "Apologize",
                    localScenarioContext: "thanks_sorry_opening"
                ),
                messageScenarioStep(
                    id: "thanks-sorry-apology",
                    scene: "At the same counter, the staff gently tells you that you are in the wrong line.",
                    localLine: "Bạn đứng nhầm hàng rồi.",
                    localLineMeaning: "You are in the wrong line.",
                    userGoal: "Apologize, or ask them to repeat the instruction.",
                    best: messageReply(
                        "viet-family-v500-poli-basi-sorry",
                        vietnamese: "Xin lỗi",
                        english: "Sorry",
                        nextLocalLine: "Không sao, bạn lấy số thứ tự ở kia.",
                        nextLocalMeaning: "It's okay, take a queue number over there."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-repair-repeat",
                            vietnamese: "Làm ơn nói lại",
                            english: "Please say that again",
                            nextLocalLine: "Bạn lấy số thứ tự ở kia.",
                            nextLocalMeaning: "Take a queue number over there."
                        ),
                        messageReply(
                            "viet-family-polite-acknowledge",
                            vietnamese: "Dạ",
                            english: "Okay",
                            nextLocalLine: "Bạn lấy số ở kia nhé.",
                            nextLocalMeaning: "Please take a number over there."
                        ),
                    ],
                    nextStepTitle: "Ask again",
                    localScenarioContext: "thanks_sorry_apology"
                ),
                messageScenarioStep(
                    id: "thanks-sorry-repeat",
                    scene: "You did not hear what the person said after replying.",
                    localLine: "Bạn cần lấy số thứ tự ở kia.",
                    localLineMeaning: "You need to take a queue number over there.",
                    userGoal: "Ask them to say it again.",
                    best: messageReply(
                        "viet-family-repair-repeat",
                        vietnamese: "Làm ơn nói lại",
                        english: "Please say that again",
                        nextLocalLine: "Bạn lấy số thứ tự ở kia.",
                        nextLocalMeaning: "Take a queue number over there."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-repair-slower",
                            vietnamese: "Nói chậm chút được không?",
                            english: "Can you speak a little slower?",
                            nextLocalLine: "Được, tôi nói chậm hơn.",
                            nextLocalMeaning: "Yes, I will speak more slowly."
                        ),
                        messageReply(
                            "viet-family-v500-poli-basi-sorry",
                            vietnamese: "Xin lỗi",
                            english: "Sorry",
                            nextLocalLine: "Không sao, tôi nói lại.",
                            nextLocalMeaning: "It's okay, I will repeat it."
                        ),
                    ],
                    nextStepTitle: "Say no thanks",
                    localScenarioContext: "thanks_sorry_repeat"
                ),
                messageScenarioStep(
                    id: "thanks-sorry-no-thanks",
                    scene: "Someone offers one more item you do not need.",
                    localLine: "Bạn cần thêm gì không?",
                    localLineMeaning: "Do you need anything else?",
                    userGoal: "Say no thanks politely.",
                    best: messageReply(
                        "viet-family-polite-no-thanks",
                        vietnamese: "Không, cảm ơn",
                        english: "No, thank you",
                        nextLocalLine: "Dạ, vậy được rồi.",
                        nextLocalMeaning: "Okay, that's fine."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-polite-thank-you",
                            vietnamese: "Cảm ơn",
                            english: "Thank you",
                            nextLocalLine: "Không có gì.",
                            nextLocalMeaning: "You are welcome."
                        ),
                        messageReply(
                            "viet-family-v900-poli-basi-no-problem",
                            vietnamese: "Không sao",
                            english: "No problem",
                            nextLocalLine: "Dạ, không sao.",
                            nextLocalMeaning: "Yes, no problem."
                        ),
                    ],
                    nextStepTitle: "Say goodbye",
                    localScenarioContext: "thanks_sorry_no_thanks"
                ),
                messageScenarioStep(
                    id: "thanks-sorry-no-problem",
                    scene: "The person apologizes for a small delay.",
                    localLine: "Xin lỗi vì để bạn chờ.",
                    localLineMeaning: "Sorry for making you wait.",
                    userGoal: "Say it is no problem.",
                    best: messageReply(
                        "viet-family-v900-poli-basi-no-problem",
                        vietnamese: "Không sao",
                        english: "No problem",
                        nextLocalLine: "Cảm ơn bạn đã thông cảm.",
                        nextLocalMeaning: "Thank you for understanding."
                    ),
                    alternates: [
                        messageReply(
                            "viet-family-v500-poli-basi-okay",
                            vietnamese: "Đồng ý",
                            english: "Okay",
                            nextLocalLine: "Dạ, không sao.",
                            nextLocalMeaning: "Yes, no problem."
                        ),
                        messageReply(
                            "viet-family-v900-poli-basi-thats-fine",
                            vietnamese: "Không sao đâu",
                            english: "That's fine",
                            nextLocalLine: "Dạ, cảm ơn bạn.",
                            nextLocalMeaning: "Yes, thank you."
                        ),
                    ],
                    nextStepTitle: "Say goodbye",
                    localScenarioContext: "thanks_sorry_no_problem"
                ),
                messageGoodbyeStep(
                    id: "thanks-sorry-goodbye",
                    scene: "The short polite exchange is finished.",
                    localLine: "Tạm biệt nhé.",
                    localLineMeaning: "Goodbye.",
                    nextLocalLine: "Không có gì, hẹn gặp lại.",
                    nextLocalMeaning: "You are welcome, see you again.",
                    localScenarioContext: "thanks_sorry_goodbye"
                ),
            ]
        ),
    ]
}
