import Foundation

enum PracticeScenarioBuilder {
    private static let personalCandidateLimit = 12
    private static let fallbackCandidateLimit = 36

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
        let scenarios = scenarioTemplates.compactMap { template in
            makeScenario(
                template: template,
                candidatesBySource: candidatesBySource,
                rankedSources: rankedSources
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
        rankedSources: [PracticeScenarioQueueSource]
    ) -> PracticeScenario? {
        let source = rankedSources.first { source in
            source != .tripFallback
                && containsCandidateForScenario(candidatesBySource[source] ?? [], template: template)
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
                sourceCandidates: sourceCandidates
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
        sourceCandidates: [PracticeCandidate]
    ) -> PracticeScenarioStep? {
        let bestCandidate = firstCandidate(
            pageIDs: template.bestPageIDs,
            in: uniqueCandidates(sourceCandidates + candidates)
        )
        guard let bestCandidate else {
            return nil
        }

        let alternatePageIDs = uniquePageIDs(template.alternatePageIDs + Array(template.bestPageIDs.dropFirst()))
        let alternateCandidates = uniqueCandidates(
            alternatePageIDs.compactMap { pageID in
                firstCandidate(pageIDs: [pageID], in: candidates)
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
                    index: index
                )
            }

        guard options.count >= 2 else {
            return nil
        }

        let recoveryCandidate = firstCandidate(pageIDs: template.recoveryPageIDs, in: candidates)

        return PracticeScenarioStep(
            id: template.id,
            scenarioID: scenarioID,
            queueSource: queueSource,
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
        index: Int
    ) -> PracticeScenarioResponseOption {
        let isBestFit = candidate.pageID == bestCandidate.pageID
        return PracticeScenarioResponseOption(
            id: "\(template.id):\(candidate.pageID):\(index)",
            candidate: candidate,
            isBestFit: isBestFit,
            scenarioCopy: template.scenarioCopy(for: candidate, isBestFit: isBestFit),
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
        template: PracticeScenarioTemplate
    ) -> Bool {
        candidates.contains { candidate in
            template.requiredPageIDs.contains(candidate.pageID)
                || !Set(candidate.categoryIDs).isDisjoint(with: Set(template.id.categoryIDs))
        }
    }

    private static func firstCandidate(
        pageIDs: [String],
        in candidates: [PracticeCandidate]
    ) -> PracticeCandidate? {
        for pageID in pageIDs {
            if let candidate = candidates.first(where: { $0.pageID == pageID }) {
                return candidate
            }
        }

        return nil
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

    func scenarioCopy(for candidate: PracticeCandidate, isBestFit: Bool) -> PracticeScenarioPhraseCopy? {
        let copy = scenarioResponseCopies[candidate.pageID]
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
        id: .taxiGrabPickup,
        sceneTitle: "Taxi / Grab pickup",
        sceneSetup: "Confirm the driver, find the pickup point, and stay safe if the car looks wrong.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "taxi-pickup-confirm",
                scene: "A car pulls up near the pickup point and the driver looks unsure.",
                localLine: "Bạn đặt xe phải không?",
                localLineMeaning: "Did you book a ride?",
                userGoal: "Confirm the ride without giving extra personal details.",
                bestPageIDs: [
                    "viet-phrase-vpe-likely-replies-dung-roi",
                    "viet-phrase-v500-tran-is-this-my-car",
                    "viet-phrase-directions-8",
                ],
                alternatePageIDs: [
                    "viet-phrase-v500-tran-is-this-my-car",
                    "viet-phrase-directions-8",
                    "viet-phrase-v500-tran-please-call-the-driver",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-tran-please-call-the-driver",
                    "viet-phrase-transport-premium-wait-here",
                ],
                nextLocalLine: "Biển số xe là gì?",
                nextLocalMeaning: "They may ask you to check the license plate.",
                recoveryTitle: "If the car does not match",
                recoveryBody: "Stay outside and ask them to call the driver.",
                nextStepTitle: "Check the pickup point",
                localScenarioContext: "taxi_pickup_confirm",
                scenarioResponseCopies: [
                    "viet-phrase-vpe-likely-replies-dung-roi": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đúng rồi.",
                        english: "Yes, that’s right.",
                        role: .bestQuickReply,
                        context: "taxi_pickup_confirm"
                    ),
                    "viet-phrase-v500-tran-is-this-my-car": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đây có phải xe của tôi không?",
                        english: "Is this my car?",
                        role: .moreReply,
                        context: "taxi_pickup_confirm"
                    ),
                    "viet-phrase-directions-8": PracticeScenarioPhraseTemplate(
                        vietnamese: "Điểm đón ở đâu?",
                        english: "Where is the pickup point?",
                        role: .moreReply,
                        context: "taxi_pickup_confirm"
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "taxi-route-recover",
                scene: "The ride moves away from the route and you need to redirect without sounding panicked.",
                localLine: "Đường này nhanh hơn.",
                localLineMeaning: "They are saying this route is faster.",
                userGoal: "Ask them to follow your map or stop safely.",
                bestPageIDs: [
                    "viet-phrase-v500-tran-please-follow-the-map",
                    "viet-phrase-transport-premium-route-wrong",
                    "viet-phrase-v900-dire-navi-i-think-i-went-the-wrong-way",
                ],
                alternatePageIDs: [
                    "viet-phrase-v500-tran-please-stop-right-here",
                    "viet-phrase-transport-lost",
                    "viet-phrase-taxi-4",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-tran-please-stop-right-here",
                    "viet-phrase-v500-tran-i-feel-unsafe-please-stop",
                ],
                nextLocalLine: "Bạn muốn dừng ở đâu?",
                nextLocalMeaning: "They may ask where you want to stop.",
                recoveryTitle: "If the route still feels off",
                recoveryBody: "Ask to stop first, then use a stronger route-repair phrase if needed.",
                nextStepTitle: "Confirm the stop",
                localScenarioContext: "taxi_route_recover"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .restaurantOrderingPayment,
        sceneTitle: "Restaurant ordering",
        sceneSetup: "Ask for the menu, order one thing, and pay without a long exchange.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "restaurant-order",
                scene: "The server is ready and the table is moving quickly.",
                localLine: "Bạn muốn gọi món gì?",
                localLineMeaning: "What would you like to order?",
                userGoal: "Order one thing or ask for the menu.",
                bestPageIDs: [
                    "viet-phrase-food-1",
                    "viet-phrase-v500-food-drin-id-like-a-bowl-of-ph-please",
                    "viet-phrase-coffee-1",
                ],
                alternatePageIDs: [
                    "viet-phrase-food-menu",
                    "viet-phrase-v900-food-drin-what-do-you-recommend",
                    "viet-phrase-food-3",
                ],
                recoveryPageIDs: [
                    "viet-phrase-food-menu",
                    "viet-phrase-food-5",
                ],
                nextLocalLine: "Có lấy thêm gì không?",
                nextLocalMeaning: "They may ask if you want anything else.",
                recoveryTitle: "If you are not ready",
                recoveryBody: "Ask for the menu first, then come back to the short order phrase.",
                nextStepTitle: "Add or close the order",
                localScenarioContext: "restaurant_order",
                scenarioResponseCopies: [
                    "viet-phrase-food-1": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi một phần này.",
                        english: "One portion of this, please.",
                        role: .bestQuickReply,
                        context: "restaurant_order"
                    ),
                    "viet-phrase-food-menu": PracticeScenarioPhraseTemplate(
                        vietnamese: "Cho tôi xem thực đơn được không?",
                        english: "Can I see the menu?",
                        role: .moreReply,
                        context: "restaurant_order"
                    ),
                    "viet-phrase-v900-food-drin-what-do-you-recommend": PracticeScenarioPhraseTemplate(
                        vietnamese: "Bạn đề xuất món gì?",
                        english: "What do you recommend?",
                        role: .moreReply,
                        context: "restaurant_order"
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "restaurant-payment",
                scene: "The food is done and you need to pay without a long explanation.",
                localLine: "Tính tiền luôn không?",
                localLineMeaning: "They are checking if you want to pay now.",
                userGoal: "Ask for the bill or settle payment.",
                bestPageIDs: [
                    "viet-phrase-coffee-7",
                    "viet-phrase-price-8",
                    "viet-phrase-food-17",
                ],
                alternatePageIDs: [
                    "viet-phrase-v500-mone-numb-pric-can-i-have-a-receipt",
                    "viet-phrase-v500-mone-numb-pric-can-i-try-another-card",
                    "viet-phrase-v500-mone-numb-pric-please-write-the-price",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-mone-numb-pric-can-i-have-a-receipt",
                    "viet-phrase-v500-mone-numb-pric-please-write-the-price",
                ],
                nextLocalLine: "Tiền mặt hay thẻ?",
                nextLocalMeaning: "They may ask whether you will use cash or card.",
                recoveryTitle: "If the total is unclear",
                recoveryBody: "Ask them to write the price before you negotiate or hand over cash.",
                nextStepTitle: "Confirm payment",
                localScenarioContext: "restaurant_payment"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .hotelCheckInHelp,
        sceneTitle: "Hotel check-in",
        sceneSetup: "Confirm your booking, show your passport, and handle room details.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "hotel-check-in",
                scene: "The host checks whether you have a reservation.",
                localLine: "Bạn có đặt phòng chưa ạ?",
                localLineMeaning: "Do you have a reservation?",
                userGoal: "Reply directly and show the booking if needed.",
                bestPageIDs: [
                    "viet-phrase-hotel-1",
                    "viet-phrase-v500-hote-acco-i-booked-online",
                    "viet-phrase-v500-airp-bord-arri-here-is-my-passport",
                ],
                alternatePageIDs: [
                    "viet-phrase-v500-hote-acco-i-booked-online",
                    "viet-phrase-v500-airp-bord-arri-here-is-my-passport",
                    "viet-phrase-hotel-2",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-hote-acco-i-booked-online",
                    "viet-phrase-hotel-premium-booking-wrong",
                ],
                nextLocalLine: "Cho tôi xem hộ chiếu được không?",
                nextLocalMeaning: "They may ask to see your passport.",
                recoveryTitle: "If they cannot find the booking",
                recoveryBody: "Use the online-booking or booking-problem phrase and show the confirmation screen.",
                nextStepTitle: "Show the booking",
                localScenarioContext: "hotel_check_in_booking",
                scenarioResponseCopies: [
                    "viet-phrase-hotel-1": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi có đặt phòng.",
                        english: "I have a reservation.",
                        role: .bestQuickReply,
                        context: "hotel_check_in_booking"
                    ),
                    "viet-phrase-v500-hote-acco-i-booked-online": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi đã đặt trực tuyến.",
                        english: "I booked online.",
                        role: .moreReply,
                        context: "hotel_check_in_booking"
                    ),
                    "viet-phrase-v500-airp-bord-arri-here-is-my-passport": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đây là hộ chiếu của tôi.",
                        english: "Here is my passport.",
                        role: .moreReply,
                        context: "hotel_check_in_booking"
                    ),
                ]
            ),
            PracticeScenarioStepTemplate(
                id: "hotel-passport",
                scene: "The host needs to see your passport before check-in continues.",
                localLine: "Cho tôi xem hộ chiếu được không?",
                localLineMeaning: "Can I see your passport?",
                userGoal: "Show the passport with one short line.",
                bestPageIDs: [
                    "viet-phrase-v500-airp-bord-arri-here-is-my-passport",
                    "viet-phrase-v500-hote-acco-i-booked-online",
                ],
                alternatePageIDs: [
                    "viet-phrase-v500-hote-acco-i-booked-online",
                    "viet-phrase-hotel-1",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-hote-acco-i-booked-online",
                    "viet-phrase-hotel-premium-booking-wrong",
                ],
                nextLocalLine: "Cảm ơn.",
                nextLocalMeaning: "They may thank you and continue the check-in.",
                recoveryTitle: "If the booking is still unclear",
                recoveryBody: "Show the booking screen and say you booked online.",
                nextStepTitle: "Finish check-in",
                localScenarioContext: "hotel_check_in_passport",
                scenarioResponseCopies: [
                    "viet-phrase-v500-airp-bord-arri-here-is-my-passport": PracticeScenarioPhraseTemplate(
                        vietnamese: "Đây là hộ chiếu của tôi.",
                        english: "Here is my passport.",
                        role: .bestQuickReply,
                        context: "hotel_check_in_passport"
                    ),
                    "viet-phrase-v500-hote-acco-i-booked-online": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi đã đặt trực tuyến.",
                        english: "I booked online.",
                        role: .moreReply,
                        context: "hotel_check_in_passport"
                    ),
                    "viet-phrase-hotel-1": PracticeScenarioPhraseTemplate(
                        vietnamese: "Tôi có đặt phòng.",
                        english: "I have a reservation.",
                        role: .moreReply,
                        context: "hotel_check_in_passport"
                    ),
                ]
            ),
        ]
    ),
]
