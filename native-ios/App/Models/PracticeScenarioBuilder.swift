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
                localLine: "Bạn cần tìm gì?",
                localLineMeaning: "What are you looking for?",
                userGoal: "Find baggage without a long exchange.",
                bestPageIDs: [
                    "viet-family-airport-baggage",
                ],
                alternatePageIDs: [
                    "viet-family-vpe-help-action-anh-chi-giup-toi-tim-hanh-ly-duoc-khong",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-phrase-help-1",
                ],
                nextLocalLine: "Lối này, đi thẳng rồi rẽ trái.",
                nextLocalMeaning: "This way, go straight and turn left.",
                recoveryTitle: "If the signs are unclear",
                recoveryBody: "Show your baggage tag or point at the baggage symbol.",
                nextStepTitle: "Find your ride",
                localScenarioContext: "danang_first_day_baggage"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-first-day-pickup",
                momentType: .ask,
                scene: "You are outside the airport and need the pickup area.",
                localLine: "Bạn đi xe công nghệ hả?",
                localLineMeaning: "Are you taking a ride-hailing car?",
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
                nextLocalLine: "Đi ra cửa số 3 nhé.",
                nextLocalMeaning: "Go out to Gate 3.",
                recoveryTitle: "If you cannot find the car",
                recoveryBody: "Ask someone to call the driver or show your ride screen.",
                nextStepTitle: "Get to your hotel",
                localScenarioContext: "danang_first_day_pickup"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-first-day-hotel-ride",
                momentType: .ask,
                scene: "The driver is ready. Show where you are going.",
                localLine: "Bạn đi đâu?",
                localLineMeaning: "Where are you going?",
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
                nextLocalLine: "Được rồi, tôi sẽ đưa bạn đến đó.",
                nextLocalMeaning: "Okay, I will take you there.",
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
                nextLocalLine: "Cho tôi xem xác nhận đặt phòng nhé.",
                nextLocalMeaning: "Please show me your booking confirmation.",
                recoveryTitle: "If they cannot find it",
                recoveryBody: "Show the confirmation screen and say you booked online.",
                nextStepTitle: "Order something simple",
                localScenarioContext: "danang_first_day_check_in"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-first-day-first-meal",
                momentType: .ask,
                scene: "You point to a simple meal or drink and want to order.",
                localLine: "Bạn dùng gì?",
                localLineMeaning: "What would you like?",
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
                nextLocalLine: "Có ngay.",
                nextLocalMeaning: "Coming right up.",
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
                nextLocalLine: "Bạn cho tôi xem xác nhận nhé.",
                nextLocalMeaning: "Please show me the confirmation.",
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
                nextLocalLine: "Cảm ơn, tôi kiểm tra một chút.",
                nextLocalMeaning: "Thank you, I will check now.",
                recoveryTitle: "If check-in pauses",
                recoveryBody: "Keep your passport and booking confirmation together.",
                nextStepTitle: "Ask room basics",
                localScenarioContext: "hotel_story_passport"
            ),
            PracticeScenarioStepTemplate(
                id: "hotel-story-room-basics",
                momentType: .ask,
                scene: "You have your room and need the basic details.",
                localLine: "Bạn cần gì thêm không?",
                localLineMeaning: "Do you need anything else?",
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
                localLine: "Bạn muốn đi đâu?",
                localLineMeaning: "Where would you like to go?",
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
                nextStepTitle: "Finish story",
                localScenarioContext: "hotel_story_ride"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .taxiGrabPickup,
        sceneTitle: "Taxi / Grab pickup",
        sceneSetup: "Confirm the car, find the pickup point, show the address, and get dropped off.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "taxi-story-confirm-driver",
                momentType: .listen,
                scene: "A driver rolls down the window near the pickup area.",
                localLine: "Bạn đặt xe à?",
                localLineMeaning: "Did you book a ride?",
                userGoal: "Confirm this is your driver before getting in.",
                bestPageIDs: [
                    "viet-family-v500-tran-are-you-my-driver",
                    "viet-family-v900-airp-bord-arri-i-have-an-airport-pickup-booked",
                ],
                alternatePageIDs: [
                    "viet-family-directions-pickup-point",
                    "viet-family-v500-airp-bord-arri-i-cannot-find-my-driver",
                ],
                recoveryPageIDs: [
                    "viet-family-v900-airp-bord-arri-please-call-this-driver-for-me",
                    "viet-family-v500-tran-please-call-the-driver",
                ],
                nextLocalLine: "Đúng rồi, bạn lên xe nhé.",
                nextLocalMeaning: "Yes, please get in.",
                recoveryTitle: "If the car does not match",
                recoveryBody: "Stay outside the car, show the app screen, and ask to confirm the driver.",
                nextStepTitle: "Find the pickup point",
                localScenarioContext: "taxi_story_confirm_driver"
            ),
            PracticeScenarioStepTemplate(
                id: "taxi-story-pickup-point",
                momentType: .ask,
                scene: "You are close, but the driver is waiting at another entrance.",
                localLine: "Bạn đang ở cửa nào?",
                localLineMeaning: "Which entrance are you at?",
                userGoal: "Move the pickup point without typing a message.",
                bestPageIDs: [
                    "viet-family-v900-tran-pick-me-up-at-this-entrance",
                    "viet-family-v900-tran-can-you-pick-me-up-here",
                ],
                alternatePageIDs: [
                    "viet-family-directions-pickup-point",
                    "viet-family-v500-airp-bord-arri-where-do-i-meet-the-driver",
                ],
                recoveryPageIDs: [
                    "viet-family-v500-prob-help-can-you-contact-the-driver",
                    "viet-family-v500-tran-please-call-the-driver",
                ],
                nextLocalLine: "Tôi sẽ tới cổng này.",
                nextLocalMeaning: "I will come to this gate.",
                recoveryTitle: "If you still cannot meet",
                recoveryBody: "Show the entrance number or ask nearby staff to contact the driver.",
                nextStepTitle: "Show the address",
                localScenarioContext: "taxi_story_pickup_point"
            ),
            PracticeScenarioStepTemplate(
                id: "taxi-story-address",
                momentType: .ask,
                scene: "You are in the car and show the hotel address on your phone.",
                localLine: "Địa chỉ này đúng không?",
                localLineMeaning: "Is this the address?",
                userGoal: "Confirm the destination before the car moves.",
                bestPageIDs: [
                    "viet-family-v900-tran-please-take-me-to-this-address",
                    "viet-family-v500-tran-please-take-me-to-this-hotel",
                ],
                alternatePageIDs: [
                    "viet-family-v500-tran-please-take-me-to-this-hotel",
                    "viet-family-city-danang-go-my-khe",
                ],
                recoveryPageIDs: [
                    "viet-family-vpe-help-action-anh-chi-giup-toi-xac-nhan-dia-chi-duoc-khong",
                    "viet-phrase-v900-dire-navi-please-write-the-address-for-me",
                ],
                nextLocalLine: "Đúng rồi, tôi đi theo bản đồ.",
                nextLocalMeaning: "Yes, I will follow the map.",
                recoveryTitle: "If the route looks wrong",
                recoveryBody: "Show the map pin again and ask the driver to confirm the address.",
                nextStepTitle: "Get out cleanly",
                localScenarioContext: "taxi_story_address"
            ),
            PracticeScenarioStepTemplate(
                id: "taxi-story-dropoff",
                momentType: .ask,
                scene: "You are close to the destination and want to get out here.",
                localLine: "Dừng ở đây được không?",
                localLineMeaning: "Can I stop here?",
                userGoal: "Ask for a simple drop-off and close the ride.",
                bestPageIDs: [
                    "viet-family-ves-drop-me-off-here",
                    "viet-family-city-danang-get-off-my-khe",
                ],
                alternatePageIDs: [
                    "viet-family-v900-dire-navi-where-should-the-driver-stop",
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
                nextStepTitle: "Finish story",
                localScenarioContext: "taxi_story_dropoff"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .pharmacyHelp,
        sceneTitle: "Pharmacy help",
        sceneSetup: "Find a pharmacy, explain one symptom, understand the medicine, and ask how to take it.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "pharmacy-story-find",
                momentType: .ask,
                scene: "You feel unwell near your hotel and ask the front desk for the nearest pharmacy.",
                localLine: "Bạn cần mua thuốc à?",
                localLineMeaning: "Do you need to buy medicine?",
                userGoal: "Ask for the nearest pharmacy.",
                bestPageIDs: [
                    "viet-family-health-pharmacy",
                    "viet-family-v500-heal-phar-where-is-the-pharmacy",
                ],
                alternatePageIDs: [
                    "viet-family-v900-heal-phar-is-there-a-pharmacy-nearby",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-family-health-doctor",
                ],
                nextLocalLine: "Có, hiệu thuốc ở cuối đường.",
                nextLocalMeaning: "Yes, the pharmacy is at the end of the street.",
                recoveryTitle: "If you need more help",
                recoveryBody: "Ask them to point on the map or write the pharmacy name.",
                nextStepTitle: "Explain the symptom",
                localScenarioContext: "pharmacy_story_find"
            ),
            PracticeScenarioStepTemplate(
                id: "pharmacy-story-symptom",
                momentType: .listen,
                scene: "At the counter, the pharmacist asks what is wrong.",
                localLine: "Bạn bị sao?",
                localLineMeaning: "What is wrong?",
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
                nextLocalLine: "Tôi hiểu, bạn đau đầu.",
                nextLocalMeaning: "I understand, you have a headache.",
                recoveryTitle: "If symptoms are serious",
                recoveryBody: "Ask for a clinic or doctor instead of trying to explain everything.",
                nextStepTitle: "Ask for medicine",
                localScenarioContext: "pharmacy_story_symptom"
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
                localScenarioContext: "pharmacy_story_medicine"
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
                nextStepTitle: "Finish story",
                localScenarioContext: "pharmacy_story_pay"
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
                localLine: "Bạn muốn xuống ở đâu?",
                localLineMeaning: "Where do you want to get off?",
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
                nextLocalLine: "Được, tôi sẽ dừng gần bãi biển.",
                nextLocalMeaning: "Okay, I will stop near the beach.",
                recoveryTitle: "If the driver is unsure",
                recoveryBody: "Show My Khe Beach on the map and confirm the drop-off.",
                nextStepTitle: "Beach basics",
                localScenarioContext: "danang_day_beach"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-day-beach-basics",
                momentType: .ask,
                scene: "You find a small beach stand and want to buy water before walking down to the sand.",
                localLine: "Bạn lấy gì?",
                localLineMeaning: "What would you like?",
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
                nextLocalLine: "Nước đây, hai mươi nghìn.",
                nextLocalMeaning: "Here is the water, twenty thousand.",
                recoveryTitle: "If prices are unclear",
                recoveryBody: "Point to the item and ask how much.",
                nextStepTitle: "Food stop",
                localScenarioContext: "danang_day_beach_basics"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-day-food",
                momentType: .ask,
                scene: "You stop for something simple to eat.",
                localLine: "Bạn muốn gọi món gì?",
                localLineMeaning: "What would you like to order?",
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
                nextLocalLine: "Món này không cay lắm.",
                nextLocalMeaning: "This dish is not very spicy.",
                recoveryTitle: "If you are pointing at a dish",
                recoveryBody: "Point first, then use the short order phrase.",
                nextStepTitle: "At Dragon Bridge",
                localScenarioContext: "danang_day_food"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-day-dragon-bridge",
                momentType: .ask,
                scene: "You are near Dragon Bridge and want a quick photo.",
                localLine: "Bạn muốn chụp ở đây à?",
                localLineMeaning: "Do you want to take the photo here?",
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
                nextLocalLine: "Được, đưa điện thoại cho tôi.",
                nextLocalMeaning: "Sure, give me your phone.",
                recoveryTitle: "After the photo",
                recoveryBody: "Say cảm ơn, then keep your phone visible.",
                nextStepTitle: "Get back",
                localScenarioContext: "danang_day_dragon_bridge"
            ),
            PracticeScenarioStepTemplate(
                id: "danang-day-ride-back",
                momentType: .ask,
                scene: "You are ready to get back to your hotel.",
                localLine: "Bạn cần gọi xe không?",
                localLineMeaning: "Do you need a car?",
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
                nextLocalLine: "Xe sẽ đón ở góc đường này.",
                nextLocalMeaning: "The car will pick you up at this corner.",
                recoveryTitle: "If the pickup changes",
                recoveryBody: "Ask where the pickup point is, then show the hotel map pin.",
                nextStepTitle: "Finish story",
                localScenarioContext: "danang_day_ride_back"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .restaurantOrderingPayment,
        sceneTitle: "Restaurant ordering",
        sceneSetup: "Choose a table, order simply, ask for help, and pay.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "restaurant-story-arrive",
                momentType: .ask,
                scene: "You walk in and a staff member looks over.",
                localLine: "Mấy người ạ?",
                localLineMeaning: "How many people?",
                userGoal: "Choose the first thing you need.",
                bestPageIDs: [
                    "viet-family-food-need-table",
                    "viet-family-vpe-one-item-please-cho-toi-mot-ban-cho-hai-nguoi",
                ],
                alternatePageIDs: [
                    "viet-family-food-menu",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-prob-help-can-you-help-me",
                    "viet-family-food-menu",
                ],
                nextLocalLine: "Mời bạn ngồi bàn này.",
                nextLocalMeaning: "Please sit at this table.",
                recoveryTitle: "If you are unsure",
                recoveryBody: "Start with the menu or help phrase. Keep it short.",
                nextStepTitle: "The server is ready",
                localScenarioContext: "restaurant_story_arrive"
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
                localScenarioContext: "restaurant_story_server_ready"
            ),
            PracticeScenarioStepTemplate(
                id: "restaurant-story-ingredients",
                momentType: .ask,
                scene: "You want to avoid something in the dish.",
                localLine: "Bạn có ăn được cay không?",
                localLineMeaning: "Can you eat spicy food?",
                userGoal: "Check one ingredient or keep the spice level simple.",
                bestPageIDs: [
                    "viet-family-vpe-food-has-co-dau-phong-khong",
                    "viet-phrase-food-premium-has-peanuts",
                ],
                alternatePageIDs: [
                    "viet-family-vpe-food-has-co-thit-heo-khong",
                    "viet-family-food-not-spicy",
                ],
                recoveryPageIDs: [
                    "viet-family-food-peanut-allergy",
                    "viet-phrase-v500-prob-help-can-you-help-me",
                ],
                nextLocalLine: "Tôi sẽ dặn bếp làm nhẹ thôi.",
                nextLocalMeaning: "I will ask the kitchen to make it mild.",
                recoveryTitle: "If allergies matter",
                recoveryBody: "Use the allergy phrase and show the ingredient if you can.",
                nextStepTitle: "Order a drink",
                localScenarioContext: "restaurant_story_ingredients"
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
                nextLocalLine: "Có nước lọc và trà đá.",
                nextLocalMeaning: "We have water and iced tea.",
                recoveryTitle: "If you want to keep it easy",
                recoveryBody: "Water or iced tea are short, common replies.",
                nextStepTitle: "Pay",
                localScenarioContext: "restaurant_story_drink"
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
                nextStepTitle: "Finish story",
                localScenarioContext: "restaurant_story_pay"
            ),
        ]
    ),
]
