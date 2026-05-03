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
                XCTAssertTrue(step.responseOptions.allSatisfy { option in
                    option.candidate.pageID.hasPrefix("viet-phrase-")
                        && !option.feedbackTitle.isEmpty
                        && !option.feedbackBody.isEmpty
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

        XCTAssertFalse(visibleCopy.contains("incorrect"))
        XCTAssertFalse(visibleCopy.contains("wrong answer"))
        XCTAssertFalse(visibleCopy.contains("quiz"))
        XCTAssertFalse(visibleCopy.contains("trivia"))
        XCTAssertFalse(visibleCopy.contains("bucket list"))
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
        XCTAssertTrue(snapshot.primaryScenario?.steps.contains { step in
            step.responseOptions.contains { $0.candidate.pageID == missedPageID }
        } == true)
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

        XCTAssertTrue(optionPageIDs.contains("viet-phrase-hotel-2"))
        XCTAssertTrue(optionPageIDs.contains("viet-phrase-food-1"))
        XCTAssertTrue(optionPageIDs.contains("viet-phrase-taxi-1"))
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
