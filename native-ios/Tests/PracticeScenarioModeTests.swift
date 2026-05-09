import XCTest
@testable import SpeakLocalNative

final class PracticeScenarioModeTests: XCTestCase {
    func testStoryTranscriptStartsWithSceneLocalCueAndChoiceSet() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let firstDay = try XCTUnwrap(snapshot.scenarios.first { $0.id == .danangFirstDay })
        let firstStep = try XCTUnwrap(firstDay.steps.first)
        let turns = PracticeStoryTranscript.turns(
            for: firstDay,
            currentIndex: 0,
            selectedOptionIDs: [:]
        )

        XCTAssertEqual(firstDay.id, .danangFirstDay)
        XCTAssertEqual(snapshot.starterScenario?.id, .danangFirstDay)
        XCTAssertEqual(turns.map(\.role), [.scene, .localSpeaker, .choiceSet])
        XCTAssertEqual(turns.first?.text, firstStep.scene)
        XCTAssertEqual(turns[1].vietnamese, firstStep.localLine)
        XCTAssertFalse(firstStep.localLine.isEmpty)
        XCTAssertNil(turns.first { $0.role == .travelerReply })

        let choiceTurn = try XCTUnwrap(turns.first { $0.role == .choiceSet })
        XCTAssertGreaterThanOrEqual(choiceTurn.responseOptions.count, 2)
        XCTAssertLessThanOrEqual(choiceTurn.responseOptions.count, 3)
        XCTAssertTrue(choiceTurn.responseOptions.allSatisfy { !$0.scenarioVietnamese.isEmpty })
        XCTAssertFalse(choiceTurn.responseOptions.contains { option in
            option.candidate.pageID.contains("bathroom")
                || option.scenarioEnglish.localizedCaseInsensitiveContains("bathroom")
        })
    }

    func testStoryTranscriptAddsTravelerBubbleThenWaitsForLocalReplyAfterSend() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let firstDay = try XCTUnwrap(snapshot.scenarios.first { $0.id == .danangFirstDay })
        let firstStep = try XCTUnwrap(firstDay.steps.first)
        let selectedOption = try XCTUnwrap(firstStep.bestResponse)
        let waitingTurns = PracticeStoryTranscript.turns(
            for: firstDay,
            currentIndex: 0,
            selectedOptionIDs: [firstStep.id: selectedOption.id]
        )

        XCTAssertEqual(waitingTurns.map(\.role), [.scene, .localSpeaker, .travelerReply, .localTyping])
        let travelerTurn = try XCTUnwrap(waitingTurns.first { $0.role == .travelerReply })
        XCTAssertEqual(travelerTurn.vietnamese, selectedOption.scenarioVietnamese)
        XCTAssertEqual(travelerTurn.english, selectedOption.scenarioEnglish)
        XCTAssertEqual(travelerTurn.source?.pageID, selectedOption.candidate.pageID)
        XCTAssertNil(waitingTurns.first { $0.role == .choiceSet })
        XCTAssertNil(waitingTurns.first { $0.role == .recovery })

        let repliedTurns = PracticeStoryTranscript.turns(
            for: firstDay,
            currentIndex: 0,
            selectedOptionIDs: [firstStep.id: selectedOption.id],
            revealedReplyStepIDs: [firstStep.id]
        )

        XCTAssertEqual(repliedTurns.map(\.role), [.scene, .localSpeaker, .travelerReply, .localSpeaker])
        let localReply = repliedTurns[3]
        XCTAssertEqual(localReply.vietnamese, firstStep.nextLocalLine)
        XCTAssertFalse(firstStep.nextLocalLine.isEmpty)
    }

    func testScenarioModeUsesAuthoredStarterStories() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        XCTAssertEqual(snapshot.scenarios.map(\.id), [
            .danangFirstDay,
            .hotelCheckInHelp,
            .taxiGrabPickup,
            .pharmacyHelp,
            .danangDay,
            .restaurantOrderingPayment,
        ])
        XCTAssertTrue(snapshot.scenarios.allSatisfy { $0.steps.count >= 4 })

        for scenario in snapshot.scenarios {
            XCTAssertFalse(scenario.sceneTitle.isEmpty)
            XCTAssertFalse(scenario.sceneSetup.isEmpty)
            XCTAssertGreaterThanOrEqual(scenario.id.flowBeats.count, 4)

            for step in scenario.steps {
                XCTAssertFalse(step.scene.isEmpty)
                XCTAssertFalse(step.recovery.title.isEmpty)
                XCTAssertFalse(step.recovery.body.isEmpty)
                XCTAssertGreaterThanOrEqual(step.responseOptions.count, 2)
                XCTAssertLessThanOrEqual(step.responseOptions.count, 4)
                if step.momentType == .listen {
                    XCTAssertFalse(step.localLine.isEmpty)
                    XCTAssertFalse(step.localLineMeaning.isEmpty)
                }
                XCTAssertTrue(step.responseOptions.allSatisfy { option in
                    option.candidate.pageID.hasPrefix("viet-phrase-")
                        || option.candidate.pageID.hasPrefix("viet-family-")
                })
                XCTAssertTrue(step.responseOptions.contains(where: \.isBestFit))
            }
        }
    }

    func testScenarioCopyAvoidsSchoolQuizAndIncorrectLanguage() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let visibleCopy = snapshot.visibleCopy.joined(separator: "\n").lowercased()

        let bannedPhrases = [
            "answer",
            "check fit",
            "correct",
            "good fit",
            "incorrect",
            "missed",
            "quiz",
            "phrase pages",
            "reply options",
            "review missed",
            "score",
            "source page",
            "trivia",
            "try saying",
            "wrong answer",
        ]

        for bannedPhrase in bannedPhrases {
            XCTAssertFalse(
                visibleCopy.contains(bannedPhrase),
                "Scenario Mode visible copy should not contain '\(bannedPhrase)'."
            )
        }
    }

    func testScenarioModeUsesContextReadyPhraseCopy() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        let firstDay = try XCTUnwrap(snapshot.scenarios.first { $0.id == .danangFirstDay })
        XCTAssertEqual(firstDay.sceneSetup, "Land, get a ride, check in, and order your first meal.")
        XCTAssertEqual(firstDay.id.flowBeats, ["Airport", "Ride", "Hotel", "Food"])
        XCTAssertEqual(firstDay.steps.map(\.momentType), [.ask, .ask, .ask, .listen, .ask])
        let firstDayBaggage = try XCTUnwrap(firstDay.steps.first)
        XCTAssertEqual(firstDayBaggage.scene, "You have just landed in Da Nang. First, find baggage claim.")
        XCTAssertEqual(firstDayBaggage.bestResponse?.scenarioVietnamese, "Lấy hành lý ở đâu?")

        let hotel = try XCTUnwrap(snapshot.scenarios.first { $0.id == .hotelCheckInHelp })
        XCTAssertEqual(hotel.sceneSetup, "Check in, show documents, ask room basics, and fix small issues.")
        XCTAssertEqual(hotel.id.flowBeats, ["Booking", "Passport", "Wi-Fi", "Room help"])
        XCTAssertEqual(hotel.steps.map(\.momentType), [.listen, .listen, .ask, .recovery, .ask])
        let hotelFirstStep = try XCTUnwrap(hotel.steps.first)
        XCTAssertEqual(hotelFirstStep.localPhrase.scenarioVietnamese, "Bạn có đặt phòng chưa?")
        XCTAssertEqual(hotelFirstStep.bestResponse?.scenarioVietnamese, "Tôi có đặt phòng")
        let hotelPassportStep = try XCTUnwrap(hotel.steps.dropFirst().first)
        XCTAssertEqual(hotelPassportStep.localPhrase.scenarioVietnamese, "Cho tôi xem hộ chiếu được không?")
        XCTAssertEqual(hotelPassportStep.bestResponse?.scenarioVietnamese, "Đây là hộ chiếu của tôi")

        let taxi = try XCTUnwrap(snapshot.scenarios.first { $0.id == .taxiGrabPickup })
        XCTAssertEqual(taxi.sceneSetup, "Confirm the car, find the pickup point, show the address, and get dropped off.")
        XCTAssertEqual(taxi.id.flowBeats, ["Confirm car", "Pickup point", "Route", "Drop-off"])
        XCTAssertEqual(taxi.steps.map(\.momentType), [.listen, .ask, .ask, .ask])

        let pharmacy = try XCTUnwrap(snapshot.scenarios.first { $0.id == .pharmacyHelp })
        XCTAssertEqual(pharmacy.sceneSetup, "Find a pharmacy, explain one symptom, understand the medicine, and ask how to take it.")
        XCTAssertEqual(pharmacy.id.flowBeats, ["Find help", "Symptoms", "Medicine", "Directions"])
        XCTAssertEqual(pharmacy.steps.map(\.momentType), [.ask, .listen, .ask, .ask])

        let danangDay = try XCTUnwrap(snapshot.scenarios.first { $0.id == .danangDay })
        XCTAssertEqual(danangDay.sceneSetup, "Beach, food, Dragon Bridge, and getting back.")
        XCTAssertEqual(danangDay.id.flowBeats, ["Beach", "Food", "Photo", "Ride back"])
        XCTAssertEqual(danangDay.steps.map(\.momentType), [.ask, .ask, .ask, .ask, .ask])
        XCTAssertTrue(danangDay.visibleCopy.contains("You are near Dragon Bridge and want a quick photo."))

        let visibleCopy = snapshot.visibleCopy.joined(separator: "\n")
        XCTAssertFalse(visibleCopy.contains("Jojo"))
        XCTAssertFalse(visibleCopy.localizedCaseInsensitiveContains("anh/chị"))
        XCTAssertFalse(visibleCopy.contains("Bạn là Jojo"))
        XCTAssertFalse(visibleCopy.contains("Cho tôi nhận phòng"))
    }

    func testPersonalQueuePriorityFeedsScenarioModeBeforeTripFallback() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let progressStore = isolatedProgressStore()
        let missedPageID = "viet-phrase-v500-tran-are-you-my-driver"
        let missedCandidate = try XCTUnwrap(
            repository.loadPracticeCandidates(pageIDs: [missedPageID], limit: 1).first
        )
        let missedPromptID = PracticePromptGenerator.stablePromptID(
            kind: .englishToVietnamese,
            candidate: missedCandidate
        )
        progressStore.record(promptID: missedPromptID, isCorrect: false)

        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: ["viet-phrase-hotel-2"],
            savedPageIDs: ["viet-phrase-food-1"],
            recentPageIDs: ["viet-phrase-taxi-1"],
            progressStore: progressStore
        )

        XCTAssertEqual(snapshot.rankedQueueSources.prefix(4), [
            .missedReview,
            .addedPractice,
            .savedRecent,
            .tripFallback,
        ])
        XCTAssertEqual(snapshot.primaryScenario?.queueSource, .missedReview)
        XCTAssertTrue(snapshot.scenarios.contains { $0.queueSource == .missedReview })
    }

    func testAddSavedAndRecentPagesFeedScenarioCandidates() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let requestedPageIDs = [
            "viet-family-hotel-reservation",
            "viet-family-food-pay-now",
            "viet-family-service-water",
        ]
        let expectedCanonicalPageIDs = Set(
            try requestedPageIDs.map { pageID in
                try repository.canonicalPageID(forPageIDOrAlias: pageID)
            }
        )
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: ["viet-family-hotel-reservation"],
            savedPageIDs: ["viet-family-food-pay-now"],
            recentPageIDs: ["viet-family-service-water"],
            progressStore: isolatedProgressStore()
        )
        let optionPageIDs = Set(snapshot.scenarios.flatMap { scenario in
            scenario.steps.flatMap { step in
                step.responseOptions.map(\.candidate.pageID)
            }
        })

        XCTAssertTrue(expectedCanonicalPageIDs.isSubset(of: optionPageIDs))
        XCTAssertGreaterThan(snapshot.queueCounts[.addedPractice, default: 0], 0)
        XCTAssertGreaterThan(snapshot.queueCounts[.savedRecent, default: 0], 0)
    }

    func testTripFallbackIsBoundedToStarterScenarioCategories() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        XCTAssertEqual(snapshot.loadedFallbackScenarioIDs, [
            .danangFirstDay,
            .hotelCheckInHelp,
            .taxiGrabPickup,
            .pharmacyHelp,
            .danangDay,
            .restaurantOrderingPayment,
        ])
        XCTAssertLessThanOrEqual(snapshot.loadedFallbackCandidateCount, 128)
    }

    func testRepositoryLoadsPracticeCandidatesByCategory() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let candidates = try repository.loadPracticeCandidates(
            categoryIDs: ["transport"],
            limit: 12
        )

        XCTAssertFalse(candidates.isEmpty)
        XCTAssertLessThanOrEqual(candidates.count, 12)
        XCTAssertTrue(candidates.allSatisfy { $0.categoryIDs.contains("transport") })
    }

    private func isolatedProgressStore() -> LocalPracticeProgressStore {
        let suiteName = "PracticeScenarioModeTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        addTeardownBlock {
            defaults.removePersistentDomain(forName: suiteName)
        }
        return LocalPracticeProgressStore(defaults: defaults)
    }
}
