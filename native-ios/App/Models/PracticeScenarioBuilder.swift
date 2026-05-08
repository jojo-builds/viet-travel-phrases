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
        let options = ([bestCandidate] + alternateCandidates.prefix(2))
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
        "\(candidate.vietnamese) may help later. This moment starts with \(bestCandidate.vietnamese)."
    }
}

private struct PracticeScenarioPhraseTemplate {
    let vietnamese: String
    let english: String
    var role: PracticeScenarioPhraseRole?
    var context: String?
}

private let scenarioTemplates: [PracticeScenarioTemplate] = [
    PracticeScenarioTemplate(
        id: .danangFirstDay,
        sceneTitle: "First day in Da Nang",
        sceneSetup: "Land, get a ride, check in, and order your first meal.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "danang-first-day-baggage",
                momentType: .ask,
                scene: "You have just landed in Da Nang. First, find baggage claim.",
                localLine: "",
                localLineMeaning: "",
                userGoal: "Find baggage without a long exchange.",
                bestPageIDs: [
                    "viet-family-airport-baggage",
                    "viet-family-vpe-where-place-khu-lay-hanh-ly-o-dau",
                ],
                alternatePageIDs: [
                    "viet-family-vpe-help-action-anh-chi-giup-toi-tim-hanh-ly-duoc-khong",
                    "viet-family-bathroom-where",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-phrase-help-1",
                ],
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "If the signs are unclear",
                recoveryBody: "Show your baggage tag or point at the baggage symbol.",
                nextStepTitle: "Find your ride",
                localScenarioContext: "danang_first_day_baggage"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-first-day-pickup",
                momentType: .ask,
                scene: "You are outside the airport and need the pickup area.",
                localLine: "",
                localLineMeaning: "",
                userGoal: "Find where the car should meet you.",
                bestPageIDs: [
                    "viet-family-airport-pickup",
                    "viet-phrase-directions-8",
                ],
                alternatePageIDs: [
                    "viet-phrase-v900-airp-bord-arri-where-is-the-grab-pickup-point",
                    "viet-family-vpe-help-action-anh-chi-giup-toi-tim-diem-don-duoc-khong",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v900-airp-bord-arri-please-call-this-driver-for-me",
                    "viet-phrase-v500-tran-please-call-the-driver",
                ],
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "If you cannot find the car",
                recoveryBody: "Ask someone to call the driver or show your ride screen.",
                nextStepTitle: "Get to your hotel",
                localScenarioContext: "danang_first_day_pickup"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-first-day-hotel-ride",
                momentType: .ask,
                scene: "The driver is ready. Show where you are going.",
                localLine: "",
                localLineMeaning: "",
                userGoal: "Get to your hotel with the address visible.",
                bestPageIDs: [
                    "viet-phrase-v500-tran-please-take-me-to-this-hotel",
                    "viet-phrase-v500-airp-bord-arri-please-take-me-to-the-hotel-listed-on-this-booki",
                ],
                alternatePageIDs: [
                    "viet-phrase-v900-tran-please-take-me-to-this-address",
                    "viet-family-ves-drop-me-off-here",
                ],
                recoveryPageIDs: [
                    "viet-family-vpe-help-action-anh-chi-giup-toi-xac-nhan-dia-chi-duoc-khong",
                    "viet-phrase-v900-dire-navi-please-write-the-address-for-me",
                ],
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "If the driver looks unsure",
                recoveryBody: "Show the hotel address or map pin before adding more words.",
                nextStepTitle: "Check in",
                localScenarioContext: "danang_first_day_hotel_ride"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-first-day-check-in",
                momentType: .listen,
                scene: "At the hotel desk, the host asks about your booking.",
                localLine: "Bạn có đặt phòng chưa?",
                localLineMeaning: "Do you have a reservation?",
                userGoal: "Reply directly and show the booking screen if needed.",
                bestPageIDs: [
                    "viet-family-hotel-reservation",
                    "viet-phrase-v500-hote-acco-i-booked-online",
                ],
                alternatePageIDs: [
                    "viet-phrase-v500-hote-acco-i-booked-online",
                    "viet-family-v500-airp-bord-arri-here-is-my-passport",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-phrase-v500-hote-acco-i-booked-online",
                ],
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "If they cannot find it",
                recoveryBody: "Show the confirmation screen and say you booked online.",
                nextStepTitle: "Order something simple",
                localScenarioContext: "danang_first_day_check_in"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-first-day-first-meal",
                momentType: .ask,
                scene: "You point to a simple meal or drink and want to order.",
                localLine: "",
                localLineMeaning: "",
                userGoal: "Order one thing and keep the exchange short.",
                bestPageIDs: [
                    "viet-family-food-one-portion",
                    "viet-family-ves-order-cao-lau-portion",
                ],
                alternatePageIDs: [
                    "viet-family-service-water",
                    "viet-family-food-pay-now",
                ],
                recoveryPageIDs: [
                    "viet-family-food-menu",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "If the menu is hard",
                recoveryBody: "Point to the item first, then play the phrase.",
                nextStepTitle: "Finish story",
                localScenarioContext: "danang_first_day_first_meal"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .hotelCheckInHelp,
        sceneTitle: "At the hotel",
        sceneSetup: "Check in, show documents, ask room basics, and fix small issues.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "hotel-story-reservation",
                momentType: .listen,
                scene: "The host asks if you have a booking.",
                localLine: "Bạn có đặt phòng chưa?",
                localLineMeaning: "Do you have a reservation?",
                userGoal: "Give the short reservation reply.",
                bestPageIDs: [
                    "viet-family-hotel-reservation",
                    "viet-phrase-v500-hote-acco-i-booked-online",
                ],
                alternatePageIDs: [
                    "viet-phrase-v500-hote-acco-i-booked-online",
                    "viet-phrase-v900-hote-acco-the-reservation-is-under-this-name",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "If they cannot find it",
                recoveryBody: "Show the confirmation screen and keep the booking phrase ready.",
                nextStepTitle: "Show your passport",
                localScenarioContext: "hotel_story_reservation"
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
                    "viet-phrase-v500-hote-acco-i-booked-online",
                    "viet-family-hotel-reservation",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "If check-in pauses",
                recoveryBody: "Keep your passport and booking confirmation together.",
                nextStepTitle: "Ask room basics",
                localScenarioContext: "hotel_story_passport"
            ),
            PracticeScenarioStepTemplate(
                id: "hotel-story-room-basics",
                momentType: .ask,
                scene: "You have your room and need the basic details.",
                localLine: "",
                localLineMeaning: "",
                userGoal: "Ask for Wi-Fi, check-out, or room details.",
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
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "If the reply is unclear",
                recoveryBody: "Ask them to point, write it down, or show the key card.",
                nextStepTitle: "Handle room help",
                localScenarioContext: "hotel_story_room_basics"
            ),
            PracticeScenarioStepTemplate(
                id: "hotel-story-room-help",
                momentType: .recovery,
                scene: "Something in the room needs a quick fix.",
                localLine: "",
                localLineMeaning: "",
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
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "If you need a fallback",
                recoveryBody: "Use the help phrase, then show the room problem.",
                nextStepTitle: "Get a ride",
                localScenarioContext: "hotel_story_room_help"
            ),
            PracticeScenarioStepTemplate(
                id: "hotel-story-ride",
                momentType: .ask,
                scene: "You are leaving the hotel and need help with a ride.",
                localLine: "",
                localLineMeaning: "",
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
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "If the place name is hard",
                recoveryBody: "Show the map pin and keep the ride phrase short.",
                nextStepTitle: "Finish story",
                localScenarioContext: "hotel_story_ride"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .danangDay,
        sceneTitle: "Da Nang day",
        sceneSetup: "Beach, food, Dragon Bridge, and getting back.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "danang-day-beach",
                momentType: .ask,
                scene: "You are leaving your hotel and heading to My Khe Beach.",
                localLine: "",
                localLineMeaning: "",
                userGoal: "Get to the beach or confirm the drop-off.",
                bestPageIDs: [
                    "viet-family-city-danang-get-off-my-khe",
                    "viet-family-city-danang-go-my-khe",
                ],
                alternatePageIDs: [
                    "viet-family-city-danang-go-my-khe",
                    "viet-family-ves-drop-me-off-here",
                ],
                recoveryPageIDs: [
                    "viet-family-city-danang-place-my-khe",
                    "viet-family-vpe-help-action-anh-chi-giup-toi-xac-nhan-dia-chi-duoc-khong",
                ],
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "If the driver is unsure",
                recoveryBody: "Show My Khe Beach on the map and confirm the drop-off.",
                nextStepTitle: "Beach basics",
                localScenarioContext: "danang_day_beach"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-day-beach-basics",
                momentType: .ask,
                scene: "You are at the beach and need water or a basic question.",
                localLine: "",
                localLineMeaning: "",
                userGoal: "Ask for something simple without overexplaining.",
                bestPageIDs: [
                    "viet-family-service-water",
                    "viet-family-food-bottled-water",
                ],
                alternatePageIDs: [
                    "viet-family-money-how-much",
                    "viet-family-bathroom-where",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v900-airp-bord-arri-where-can-i-buy-a-bottle-of-water",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "If prices are unclear",
                recoveryBody: "Point to the item and ask how much.",
                nextStepTitle: "Food stop",
                localScenarioContext: "danang_day_beach_basics"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-day-food",
                momentType: .ask,
                scene: "You stop for something simple to eat.",
                localLine: "",
                localLineMeaning: "",
                userGoal: "Order one thing and adjust spice if needed.",
                bestPageIDs: [
                    "viet-family-food-one-portion",
                    "viet-family-ves-order-cao-lau-portion",
                ],
                alternatePageIDs: [
                    "viet-family-food-not-spicy",
                    "viet-family-food-pay-now",
                ],
                recoveryPageIDs: [
                    "viet-family-food-menu",
                    "viet-family-vpe-food-has-co-dau-phong-khong",
                ],
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "If you are pointing at a dish",
                recoveryBody: "Point first, then use the short order phrase.",
                nextStepTitle: "At Dragon Bridge",
                localScenarioContext: "danang_day_food"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-day-dragon-bridge",
                momentType: .ask,
                scene: "You are near Dragon Bridge and want a quick photo.",
                localLine: "",
                localLineMeaning: "",
                userGoal: "Ask for a photo or find the bridge.",
                bestPageIDs: [
                    "viet-family-ves-take-photo-for-me",
                    "viet-family-vpe-help-action-anh-chi-giup-toi-chup-anh-giup-toi-duoc-khong",
                ],
                alternatePageIDs: [
                    "viet-family-city-danang-where-dragon-bridge",
                    "viet-family-ves-drop-near-dragon-bridge",
                ],
                recoveryPageIDs: [
                    "viet-family-city-danang-place-dragon-bridge",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "After the photo",
                recoveryBody: "Say cảm ơn, then keep your phone visible.",
                nextStepTitle: "Get back",
                localScenarioContext: "danang_day_dragon_bridge"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-day-ride-back",
                momentType: .ask,
                scene: "You are ready to get back to your hotel.",
                localLine: "",
                localLineMeaning: "",
                userGoal: "Get a ride back or confirm the pickup point.",
                bestPageIDs: [
                    "viet-family-ves-call-taxi-for-me",
                    "viet-phrase-hotel-9",
                ],
                alternatePageIDs: [
                    "viet-family-vpe-help-action-anh-chi-giup-toi-dua-toi-ve-khach-san-duoc-khong",
                    "viet-phrase-directions-8",
                ],
                recoveryPageIDs: [
                    "viet-family-repair-understand",
                    "viet-phrase-v500-tran-please-call-the-driver",
                ],
                nextLocalLine: "",
                nextLocalMeaning: "",
                recoveryTitle: "If the pickup changes",
                recoveryBody: "Ask where the pickup point is, then show the hotel map pin.",
                nextStepTitle: "Finish story",
                localScenarioContext: "danang_day_ride_back"
            ),
        ]
    ),
]
