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

        let alternateCandidates = uniqueCandidates(
            candidates.filter { candidate in
                template.alternatePageIDs.contains(candidate.pageID)
                    || template.bestPageIDs.dropFirst().contains(candidate.pageID)
            }
        )
        .filter { $0.pageID != bestCandidate.pageID }
        let options = ([bestCandidate] + alternateCandidates)
            .prefix(4)
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
            feedbackTitle: isBestFit ? "Recommended reply" : "Useful in another moment",
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

    func bestFitFeedback(_ candidate: PracticeCandidate) -> String {
        "\(candidate.vietnamese) keeps this exchange short and clear."
    }

    func alternateFeedback(_ candidate: PracticeCandidate, _ bestCandidate: PracticeCandidate) -> String {
        "\(candidate.vietnamese) may help later. This moment starts with \(bestCandidate.vietnamese)."
    }
}

private let scenarioTemplates: [PracticeScenarioTemplate] = [
    PracticeScenarioTemplate(
        id: .taxiGrabPickup,
        sceneTitle: "Taxi / Grab pickup",
        sceneSetup: "Confirm the car, find the pickup point, and recover if the ride feels unclear.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "taxi-pickup-confirm",
                scene: "A car pulls up near the pickup point and the driver looks unsure.",
                localLine: "Bạn là Jojo phải không?",
                localLineMeaning: "They are checking if you are the right passenger.",
                userGoal: "Confirm the driver or show that you are checking the ride.",
                bestPageIDs: [
                    "viet-phrase-v500-tran-are-you-my-driver",
                    "viet-phrase-v500-tran-is-this-my-car",
                    "viet-phrase-taxi-1",
                ],
                alternatePageIDs: [
                    "viet-phrase-directions-8",
                    "viet-phrase-v500-tran-please-call-the-driver",
                    "viet-phrase-v500-tran-please-wait-here",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-tran-please-call-the-driver",
                    "viet-phrase-transport-premium-wait-here",
                ],
                nextLocalLine: "Biển số xe là gì?",
                nextLocalMeaning: "They may ask you to check the license plate.",
                recoveryTitle: "If the car does not match",
                recoveryBody: "Use the driver-call or wait-here phrase instead of getting in while unsure.",
                nextStepTitle: "Check the pickup point"
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
                recoveryBody: "Use the stop-here phrase first, then open the phrase page for stronger route repair phrases.",
                nextStepTitle: "Confirm the stop"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .restaurantOrderingPayment,
        sceneTitle: "Restaurant ordering",
        sceneSetup: "Order clearly, ask for the bill, and keep the exchange moving.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "restaurant-order",
                scene: "The server is ready and the table is moving quickly.",
                localLine: "Anh/chị dùng gì?",
                localLineMeaning: "They are asking what you would like.",
                userGoal: "Order one thing clearly.",
                bestPageIDs: [
                    "viet-phrase-food-1",
                    "viet-phrase-v500-food-drin-id-like-a-bowl-of-ph-please",
                    "viet-phrase-coffee-1",
                ],
                alternatePageIDs: [
                    "viet-phrase-food-menu",
                    "viet-phrase-food-need-table",
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
                nextStepTitle: "Add or close the order"
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
                nextStepTitle: "Confirm payment"
            ),
        ]
    ),
    PracticeScenarioTemplate(
        id: .hotelCheckInHelp,
        sceneTitle: "Hotel check-in",
        sceneSetup: "Check in smoothly, show the booking, and ask for help if something is not working.",
        steps: [
            PracticeScenarioStepTemplate(
                id: "hotel-check-in",
                scene: "The host asks for your booking name and passport.",
                localLine: "Bạn có đặt phòng chưa?",
                localLineMeaning: "They are asking whether you have a reservation.",
                userGoal: "Say you are checking in or have a reservation.",
                bestPageIDs: [
                    "viet-phrase-hotel-2",
                    "viet-phrase-hotel-1",
                    "viet-phrase-v500-hote-acco-here-is-my-passport-for-check-in",
                ],
                alternatePageIDs: [
                    "viet-phrase-v500-hote-acco-i-booked-online",
                    "viet-phrase-v500-hote-acco-can-i-check-in-early",
                    "viet-phrase-hotel-3",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-hote-acco-i-booked-online",
                    "viet-phrase-hotel-premium-booking-wrong",
                ],
                nextLocalLine: "Cho tôi xem hộ chiếu nhé.",
                nextLocalMeaning: "They may ask to see your passport.",
                recoveryTitle: "If they cannot find the booking",
                recoveryBody: "Use the online-booking or booking-problem phrase and show the confirmation screen.",
                nextStepTitle: "Show the booking"
            ),
            PracticeScenarioStepTemplate(
                id: "hotel-room-help",
                scene: "You are in the room and one practical thing needs fixing.",
                localLine: "Phòng có vấn đề gì không?",
                localLineMeaning: "They are asking what is wrong with the room.",
                userGoal: "Name the room issue and ask for help.",
                bestPageIDs: [
                    "viet-phrase-hotel-8",
                    "viet-phrase-hotel-5",
                    "viet-phrase-v500-hote-acco-can-someone-come-fix-it",
                ],
                alternatePageIDs: [
                    "viet-phrase-hotel-6",
                    "viet-phrase-hotel-9",
                    "viet-phrase-v500-hote-acco-can-i-change-rooms",
                ],
                recoveryPageIDs: [
                    "viet-phrase-v500-hote-acco-can-someone-come-fix-it",
                    "viet-phrase-help-2",
                ],
                nextLocalLine: "Tôi sẽ cho người lên kiểm tra.",
                nextLocalMeaning: "They may say someone will come check it.",
                recoveryTitle: "If the problem is hard to explain",
                recoveryBody: "Use the can-someone-fix-it phrase, then point to the issue in the room.",
                nextStepTitle: "Wait for help"
            ),
        ]
    ),
]
