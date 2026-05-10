import Foundation

enum PracticeScenarioBuilder {
    private static let personalCandidateLimit = 12
    private static let fallbackCandidateLimit = 128

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
        return PracticeScenarioResponseOption(
            id: "\(template.id):\(candidate.pageID):\(index)",
            candidate: candidate,
            isBestFit: isBestFit,
            scenarioCopy: template.scenarioCopy(
                for: candidate,
                isBestFit: isBestFit,
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
        let copy = scenarioResponseCopies[candidate.pageID] ?? scenarioResponseCopies.first { templatePageID, _ in
            (canonicalPageIDsByTemplateID[templatePageID] ?? templatePageID) == candidate.pageID
        }?.value
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

        return PracticeScenarioPhraseCopy(
            scenarioVietnamese: copy.vietnamese,
            scenarioEnglish: copy.english,
            scenarioRole: copy.role ?? role,
            scenarioContext: copy.context ?? id,
            sourcePhraseID: candidate.phraseID
        )
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
}

private func messageGoodbyeStep(
    id: String,
    scene: String,
    localLine: String,
    localLineMeaning: String,
    userGoal: String = "Say thank you and close the conversation.",
    nextLocalLine: String = "Tạm biệt",
    nextLocalMeaning: String = "Goodbye.",
    recoveryTitle: String = "If you only remember one thing",
    recoveryBody: String = "A smile plus cảm ơn is enough for most quick service moments.",
    localScenarioContext: String
) -> PracticeScenarioStepTemplate {
    PracticeScenarioStepTemplate(
        id: id,
        momentType: .ask,
        scene: scene,
        localLine: localLine,
        localLineMeaning: localLineMeaning,
        userGoal: userGoal,
        bestPageIDs: [
            "viet-thank-you",
            "viet-family-polite-thank-you",
        ],
        alternatePageIDs: [
            "viet-goodbye",
            "viet-thanks-cam-on-nhieu",
        ],
        recoveryPageIDs: [
            "viet-thank-you",
            "viet-goodbye",
        ],
        nextLocalLine: nextLocalLine,
        nextLocalMeaning: nextLocalMeaning,
        recoveryTitle: recoveryTitle,
        recoveryBody: recoveryBody,
        nextStepTitle: "Finish story",
        localScenarioContext: localScenarioContext
    )
}

private let scenarioTemplates: [PracticeScenarioTemplate] = [
    PracticeScenarioTemplate(
        id: .danangFirstDay,
        sceneTitle: "Airport arrival help",
        sceneSetup: "Ask airport staff for baggage, pickup, driver help, water, and a polite close.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "airport-story-opening",
                momentType: .ask,
                scene: "You have just landed in Da Nang and need one clear first step.",
                localLine: "Xin chào, bạn cần hỗ trợ gì ở sân bay?",
                localLineMeaning: "Hello, what airport help do you need?",
                userGoal: "Ask for baggage claim first.",
                bestPageIDs: [
                    "viet-family-airport-baggage",
                ],
                alternatePageIDs: [
                    "viet-family-vpe-help-action-anh-chi-giup-toi-tim-hanh-ly-duoc-khong",
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
                localScenarioContext: "airport_story_opening"
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
                    "viet-family-airport-baggage",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-family-vpe-help-action-anh-chi-giup-toi-tim-hanh-ly-duoc-khong",
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
                    "viet-family-vpe-help-action-anh-chi-giup-toi-tim-hanh-ly-duoc-khong": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn giúp tôi tìm hành lý được không?",
                        english: "Can you help me find my luggage?"
                    ),
                    "viet-family-airport-baggage": PracticeScenarioPhraseTemplate(
                        vietnamese: "Lấy hành lý ở đâu?",
                        english: "Where is baggage claim?"
                    ),
                    "viet-phrase-v500-prob-help-can-you-help-me": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn giúp tôi được không?",
                        english: "Can you help me?"
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
                    "viet-family-vpe-help-action-anh-chi-giup-toi-tim-diem-don-duoc-khong",
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
                localScenarioContext: "airport_story_pickup_area"
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
                        english: "Please call the driver for me"
                    ),
                    "viet-family-v500-tran-please-call-the-driver": PracticeScenarioPhraseTemplate(
                        vietnamese: "Gọi tài xế giúp tôi",
                        english: "Please call the driver for me"
                    ),
                    "viet-family-v500-prob-help-can-you-contact-the-driver": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn liên hệ tài xế giúp tôi được không?",
                        english: "Can you contact the driver for me?"
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
                        english: "Do you have bottled water?"
                    ),
                    "viet-phrase-v900-airp-bord-arri-where-can-i-buy-a-bottle-of-water": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi có thể mua một chai nước ở đâu?",
                        english: "Where can I buy a bottle of water?"
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
                localScenarioContext: "airport_story_goodbye"
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
                nextLocalLine: "Dạ, bạn cho tôi xem xác nhận đặt phòng nhé.",
                nextLocalMeaning: "Yes, please show me your booking confirmation.",
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
                        english: "I booked online"
                    ),
                    "viet-phrase-v900-hote-acco-the-reservation-is-under-this-name": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tên đặt phòng là tên này",
                        english: "The reservation is under this name"
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
                        vietnamese: "Tên đặt phòng là tên này",
                        english: "The reservation is under this name"
                    ),
                    "viet-family-hotel-reservation": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ, tôi có đặt phòng",
                        english: "Yes, I have a reservation"
                    ),
                    "viet-phrase-v500-hote-acco-i-booked-online": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi đã đặt phòng online",
                        english: "I booked online"
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
                    "viet-phrase-v500-hote-acco-i-booked-online",
                    "viet-family-hotel-reservation",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-phrase-v500-prob-help-can-you-help-me",
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
                        english: "Here is my passport for check-in"
                    ),
                    "viet-phrase-v500-hote-acco-i-booked-online": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đây là xác nhận đặt phòng",
                        english: "Here is my booking confirmation"
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
                    "viet-family-vpe-help-action-anh-chi-giup-toi-xac-nhan-so-phong-duoc-khong",
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
                localScenarioContext: "hotel_story_room_basics"
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
                localScenarioContext: "hotel_story_room_help"
            ),
            PracticeScenarioStepTemplate(
                id: "hotel-story-ride",
                momentType: .ask,
                scene: "You are leaving the hotel and need help with a ride.",
                localLine: "Bạn cần gọi xe đi đâu?",
                localLineMeaning: "Where do you need a car to?",
                userGoal: "Ask for a taxi or show where you want to go.",
                bestPageIDs: [
                    "viet-family-ves-call-taxi-for-me",
                    "viet-phrase-hotel-9",
                ],
                alternatePageIDs: [
                    "viet-phrase-v900-tran-please-take-me-to-this-address",
                    "viet-family-city-danang-where-dragon-bridge",
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
                        english: "I want to go to this address"
                    ),
                    "viet-family-city-danang-where-dragon-bridge": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi muốn đến Cầu Rồng",
                        english: "I want to go to Dragon Bridge"
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
                        english: "Yes, I booked this ride"
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
                        english: "Can you pick me up here?"
                    ),
                    "viet-family-directions-pickup-point": PracticeScenarioPhraseTemplate(
                        vietnamese: "Điểm đón ở đâu?",
                        english: "Where is the pickup point?"
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
                        english: "Yes, this address"
                    ),
                    "viet-family-v500-airp-bord-arri-please-take-me-to-the-hotel-listed-on-this-booki": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ đúng, khách sạn trong đặt phòng này",
                        english: "Yes, the hotel on this booking"
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
                        english: "Yes, please follow this address"
                    ),
                    "viet-family-v500-tran-please-follow-the-map": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ, đi theo bản đồ giúp tôi",
                        english: "Yes, please follow the map"
                    ),
                    "viet-family-v500-tran-please-take-me-to-this-hotel": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đến khách sạn này giúp tôi",
                        english: "Please go to this hotel"
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
                    "viet-family-ves-drop-me-off-here",
                    "viet-family-transport-stop-here",
                    "viet-family-city-danang-get-off-my-khe",
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
                    "viet-family-ves-drop-me-off-here": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi xuống ở đây được không?",
                        english: "Can you drop me off here?"
                    ),
                    "viet-family-transport-stop-here": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dừng ở đây được rồi",
                        english: "You can stop here"
                    ),
                    "viet-family-v500-tran-i-will-pay-the-driver-in-cash": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi trả bằng tiền mặt",
                        english: "I'll pay cash"
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
                        english: "My stomach hurts"
                    ),
                    "viet-family-v500-heal-phar-i-feel-nauseous": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi cảm thấy buồn nôn",
                        english: "I feel nauseous"
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
                        english: "No, I have a headache"
                    ),
                    "viet-family-health-stomach": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi đau bụng",
                        english: "My stomach hurts"
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
                        english: "I am allergic to this medicine"
                    ),
                    "viet-family-v500-heal-phar-i-need-a-clinic": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi cần phòng khám",
                        english: "I need a clinic"
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
                        english: "How many times per day should I take it?"
                    ),
                    "viet-family-health-allergy": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi bị dị ứng thuốc này",
                        english: "I am allergic to this medicine"
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
                        english: "Can I pay by card?"
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
                        english: "Do you have bottled water?"
                    ),
                    "viet-family-money-how-much": PracticeScenarioPhraseTemplate(
                        vietnamese: "Nước suối bao nhiêu tiền?",
                        english: "How much is bottled water?"
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
                        english: "How much are the chair and umbrella?"
                    ),
                    "viet-family-service-sunscreen": PracticeScenarioPhraseTemplate(
                        vietnamese: "Có kem chống nắng không?",
                        english: "Do you have sunscreen?"
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
                        english: "Can I pay by card?"
                    ),
                    "viet-family-transport-cash": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi trả bằng tiền mặt",
                        english: "I'll pay cash"
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
                    "viet-family-food-not-spicy",
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
                        english: "One portion of this, please"
                    ),
                    "viet-family-food-not-spicy": PracticeScenarioPhraseTemplate(
                        vietnamese: "Không cay nhé",
                        english: "Not spicy, please"
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
                    "viet-family-vpe-food-has-co-dau-phong-khong",
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
                        english: "No, thank you"
                    ),
                    "viet-family-vpe-food-has-co-dau-phong-khong": PracticeScenarioPhraseTemplate(
                        vietnamese: "Có đậu phộng không?",
                        english: "Does it have peanuts?"
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
                        english: "Can I pay by card?"
                    ),
                    "viet-family-transport-cash": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi trả bằng tiền mặt",
                        english: "I'll pay cash"
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
                    "viet-family-vpe-one-item-please-cho-toi-mot-ban-cho-hai-nguoi",
                    "viet-family-food-menu",
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
                    "viet-family-food-menu": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi xem thực đơn được không?",
                        english: "Can I see the menu?"
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
                        english: "What do you recommend?"
                    ),
                    "viet-thanks-khong-cam-on": PracticeScenarioPhraseTemplate(
                        vietnamese: "Không, cảm ơn",
                        english: "No, thank you"
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
                    "viet-family-ves-order-cao-lau-portion",
                ],
                alternatePageIDs: [
                    "viet-family-food-menu",
                    "viet-phrase-v900-food-drin-what-do-you-recommend",
                    "viet-family-vpe-food-has-co-dau-phong-khong",
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
                    "viet-family-ves-order-cao-lau-portion": PracticeScenarioPhraseTemplate(
                        vietnamese: "Dạ, cho tôi một phần cao lầu",
                        english: "One portion of cao lau, please"
                    ),
                    "viet-family-food-menu": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi xem thực đơn được không?",
                        english: "Can I see the menu?"
                    ),
                    "viet-phrase-v900-food-drin-what-do-you-recommend": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn đề xuất món gì?",
                        english: "What do you recommend?"
                    ),
                    "viet-family-vpe-food-has-co-dau-phong-khong": PracticeScenarioPhraseTemplate(
                        vietnamese: "Có đậu phộng không?",
                        english: "Does it have peanuts?"
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
                    "viet-family-vpe-food-has-co-dau-phong-khong",
                ],
                alternatePageIDs: [
                    "viet-family-vpe-food-has-co-dau-phong-khong",
                    "viet-family-vpe-food-has-co-thit-heo-khong",
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
                    "viet-family-vpe-food-has-co-dau-phong-khong": PracticeScenarioPhraseTemplate(
                        vietnamese: "Có đậu phộng không?",
                        english: "Does it have peanuts?"
                    ),
                    "viet-family-vpe-food-has-co-thit-heo-khong": PracticeScenarioPhraseTemplate(
                        vietnamese: "Có thịt heo không?",
                        english: "Does it have pork?"
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
                    "viet-family-vpe-one-item-please-cho-toi-mot-tra-da",
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
                    "viet-family-vpe-one-item-please-cho-toi-mot-tra-da": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi trà đá",
                        english: "Iced tea, please"
                    ),
                    "viet-thanks-khong-cam-on": PracticeScenarioPhraseTemplate(
                        vietnamese: "Không, cảm ơn",
                        english: "No, thank you"
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
                        english: "Can I pay by card?"
                    ),
                    "viet-family-transport-cash": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi trả bằng tiền mặt",
                        english: "I'll pay cash"
                    ),
                ]
            ),
            messageGoodbyeStep(
                id: "restaurant-story-goodbye",
                scene: "You have paid and are leaving the table.",
                localLine: "Cảm ơn bạn.",
                localLineMeaning: "Thank you.",
                userGoal: "Say thanks and goodbye before you leave.",
                nextLocalLine: "Tạm biệt, hẹn gặp lại.",
                nextLocalMeaning: "Goodbye, see you again.",
                localScenarioContext: "restaurant_story_goodbye"
            ),
        ]
    ),
]
