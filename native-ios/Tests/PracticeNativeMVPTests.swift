import XCTest
@testable import SpeakLocalNative

final class PracticeNativeMVPTests: XCTestCase {
    func testPromptGenerationUsesRealPhrasePageAudioData() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let audioCandidates = try repository.loadPracticeCandidates(requiringAudio: true, limit: 12)
        let distractors = try repository.loadPracticeCandidates(limit: 40)

        XCTAssertFalse(audioCandidates.isEmpty)

        let prompts = PracticePromptGenerator.prompts(
            mode: .hanoiBucketList,
            candidates: audioCandidates,
            distractors: distractors,
            limit: 4
        )
        let listenPrompt = try XCTUnwrap(prompts.first { $0.kind == .listenAndPick })

        XCTAssertNotNil(listenPrompt.audioKey)
        XCTAssertTrue(listenPrompt.source.pageID.hasPrefix("viet-phrase-"))
        XCTAssertFalse(listenPrompt.options.filter(\.isCorrect).isEmpty)
        XCTAssertGreaterThanOrEqual(listenPrompt.options.count, 2)
    }

    func testGeneratedPromptsPreserveHanoiCityMetadata() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let hanoiCandidates = try repository.loadPracticeCandidates(cityID: "hanoi", limit: 8)

        let candidate = try XCTUnwrap(hanoiCandidates.first)
        XCTAssertEqual(candidate.source.cityID, "hanoi")
        XCTAssertEqual(candidate.source.cityName, "Hanoi")
        XCTAssertNotNil(candidate.source.citySubcategoryID)
        XCTAssertNotNil(candidate.source.citySubcategoryTitle)
        XCTAssertNotNil(candidate.source.placeID)
        XCTAssertNotNil(candidate.source.placeName)

        let prompt = try XCTUnwrap(
            PracticePromptGenerator.prompts(
                mode: .hanoiBucketList,
                candidates: hanoiCandidates,
                distractors: hanoiCandidates,
                limit: 1
            ).first
        )

        XCTAssertEqual(prompt.source.cityID, "hanoi")
        XCTAssertEqual(prompt.source.citySubcategoryID, candidate.source.citySubcategoryID)
        XCTAssertEqual(prompt.source.placeID, candidate.source.placeID)
    }

    func testVietnameseToEnglishOptionsDoNotExposeVietnameseAnswerSubtitles() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let candidates = try repository.loadPracticeCandidates(cityID: "hanoi", limit: 12)
        let vietnamesePhrases = Set(candidates.map(\.vietnamese))

        let prompt = try XCTUnwrap(
            PracticePromptGenerator.prompts(
                mode: .hanoiBucketList,
                candidates: candidates,
                distractors: candidates,
                limit: 12
            ).first { $0.kind == .vietnameseToEnglish }
        )

        XCTAssertEqual(prompt.promptText, prompt.candidate.vietnamese)
        XCTAssertFalse(prompt.options.contains { vietnamesePhrases.contains($0.subtitle) })
        XCTAssertFalse(prompt.options.contains { $0.subtitle == prompt.promptText })
    }

    func testSavedReviewStaysSeparateFromExplicitPracticePool() throws {
        let store = isolatedProgressStore()

        let snapshot = try PracticeDeckSnapshot.load(
            practicePageIDs: [],
            savedPageIDs: ["viet-phrase-polite-2"],
            progressStore: store
        )

        XCTAssertFalse(snapshot.savedPrompts.isEmpty)
        XCTAssertTrue(snapshot.savedPrompts.contains { $0.source.pageID == "viet-phrase-polite-2" })
        XCTAssertFalse(snapshot.bucketPrompts.contains { $0.source.pageID == "viet-phrase-polite-2" })
    }

    func testEmptySavedReviewDoesNotUseGeneralFallbackCandidates() throws {
        let store = isolatedProgressStore()

        let snapshot = try PracticeDeckSnapshot.load(
            practicePageIDs: [],
            savedPageIDs: [],
            progressStore: store
        )

        XCTAssertTrue(snapshot.savedPrompts.isEmpty)
        XCTAssertFalse(snapshot.bucketPrompts.isEmpty)
    }

    func testMissedPromptsReappearInMissedReview() throws {
        let store = isolatedProgressStore()
        let firstSnapshot = try PracticeDeckSnapshot.load(
            practicePageIDs: ["viet-phrase-polite-1"],
            savedPageIDs: [],
            progressStore: store
        )
        let missedPrompt = try XCTUnwrap(firstSnapshot.bucketPrompts.first)

        store.record(promptID: missedPrompt.id, isCorrect: false)

        let secondSnapshot = try PracticeDeckSnapshot.load(
            practicePageIDs: ["viet-phrase-polite-1"],
            savedPageIDs: [],
            progressStore: store
        )

        XCTAssertTrue(secondSnapshot.missedPrompts.contains { $0.id == missedPrompt.id })
    }

    func testLocalPracticeProgressPersistsInIsolatedUserDefaults() {
        let suiteName = "PracticeNativeMVPTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        let store = LocalPracticeProgressStore(defaults: defaults)
        store.record(promptID: "practice:englishToVietnamese:viet-phrase-polite-1:main", isCorrect: false)

        let restoredStore = LocalPracticeProgressStore(defaults: defaults)
        let progress = restoredStore.progress(for: "practice:englishToVietnamese:viet-phrase-polite-1:main")

        XCTAssertEqual(progress?.seenCount, 1)
        XCTAssertEqual(progress?.missedCount, 1)
        XCTAssertEqual(progress?.lastResult, .missed)
        XCTAssertTrue(restoredStore.missedPromptIDs.contains("practice:englishToVietnamese:viet-phrase-polite-1:main"))
    }

    private func isolatedProgressStore() -> LocalPracticeProgressStore {
        let suiteName = "PracticeNativeMVPTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        addTeardownBlock {
            defaults.removePersistentDomain(forName: suiteName)
        }
        return LocalPracticeProgressStore(defaults: defaults)
    }
}
