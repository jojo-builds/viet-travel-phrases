import XCTest
@testable import SpeakLocalNative

final class PracticeScenarioModeTests: XCTestCase {
    func testScenarioModeUsesThreeAuthoredStarterScenarios() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        XCTAssertEqual(snapshot.scenarios.map(\.id), [
            .taxiGrabPickup,
            .restaurantOrderingPayment,
            .hotelCheckInHelp,
        ])
        XCTAssertTrue(snapshot.scenarios.allSatisfy { $0.steps.count >= 1 })

        for scenario in snapshot.scenarios {
            XCTAssertFalse(scenario.sceneTitle.isEmpty)
            XCTAssertFalse(scenario.sceneSetup.isEmpty)

            for step in scenario.steps {
                XCTAssertFalse(step.scene.isEmpty)
                XCTAssertFalse(step.localLine.isEmpty)
                XCTAssertFalse(step.nextLocalLine.isEmpty)
                XCTAssertFalse(step.recovery.title.isEmpty)
                XCTAssertFalse(step.recovery.body.isEmpty)
                XCTAssertGreaterThanOrEqual(step.responseOptions.count, 2)
                XCTAssertLessThanOrEqual(step.responseOptions.count, 3)
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

        let taxi = try XCTUnwrap(snapshot.scenarios.first { $0.id == .taxiGrabPickup })
        let taxiFirstStep = try XCTUnwrap(taxi.steps.first)
        XCTAssertEqual(taxiFirstStep.localPhrase.scenarioVietnamese, "Bạn đặt xe phải không?")
        XCTAssertEqual(taxiFirstStep.bestResponse?.scenarioVietnamese, "Đúng rồi.")
        XCTAssertEqual(taxiFirstStep.bestResponse?.scenarioEnglish, "Yes, that’s right.")

        let restaurant = try XCTUnwrap(snapshot.scenarios.first { $0.id == .restaurantOrderingPayment })
        let restaurantFirstStep = try XCTUnwrap(restaurant.steps.first)
        XCTAssertEqual(restaurantFirstStep.localPhrase.scenarioVietnamese, "Bạn muốn gọi món gì?")
        XCTAssertEqual(restaurantFirstStep.bestResponse?.scenarioVietnamese, "Cho tôi một phần này.")
        XCTAssertTrue(restaurantFirstStep.responseOptions.contains {
            $0.scenarioVietnamese == "Bạn đề xuất món gì?"
        })

        let hotel = try XCTUnwrap(snapshot.scenarios.first { $0.id == .hotelCheckInHelp })
        let hotelFirstStep = try XCTUnwrap(hotel.steps.first)
        XCTAssertEqual(hotelFirstStep.localPhrase.scenarioVietnamese, "Bạn có đặt phòng chưa ạ?")
        XCTAssertEqual(hotelFirstStep.bestResponse?.scenarioVietnamese, "Tôi có đặt phòng.")
        let hotelPassportStep = try XCTUnwrap(hotel.steps.dropFirst().first)
        XCTAssertEqual(hotelPassportStep.localPhrase.scenarioVietnamese, "Cho tôi xem hộ chiếu được không?")
        XCTAssertEqual(hotelPassportStep.bestResponse?.scenarioVietnamese, "Đây là hộ chiếu của tôi.")

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
        XCTAssertEqual(snapshot.primaryScenario?.id, .taxiGrabPickup)
        XCTAssertTrue(snapshot.primaryScenario?.visibleCopy.contains("Bạn đặt xe phải không?") == true)
    }

    func testAddSavedAndRecentPagesFeedScenarioCandidates() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: ["viet-phrase-hotel-2"],
            savedPageIDs: ["viet-phrase-food-1"],
            recentPageIDs: ["viet-phrase-taxi-1"],
            progressStore: isolatedProgressStore()
        )
        let optionPageIDs = Set(snapshot.scenarios.flatMap { scenario in
            scenario.steps.flatMap { step in
                step.responseOptions.map(\.candidate.pageID)
            }
        })

        XCTAssertTrue(optionPageIDs.contains("viet-phrase-hotel-1"))
        XCTAssertTrue(optionPageIDs.contains("viet-phrase-food-1"))
        XCTAssertTrue(optionPageIDs.contains("viet-phrase-vpe-likely-replies-dung-roi"))
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
            .taxiGrabPickup,
            .restaurantOrderingPayment,
            .hotelCheckInHelp,
        ])
        XCTAssertLessThanOrEqual(snapshot.loadedFallbackCandidateCount, 36)
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
