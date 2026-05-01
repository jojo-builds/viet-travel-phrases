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

    func testCityPracticeFiltersCoverExpandedCityLibrary() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let expectedCityIDs = ["hcmc", "hanoi", "danang", "hoian", "hue"]

        for cityID in expectedCityIDs {
            let candidates = try repository.loadPracticeCandidates(cityID: cityID, limit: 180)

            XCTAssertEqual(candidates.count, 150, cityID)
            XCTAssertTrue(candidates.allSatisfy { $0.source.cityID == cityID }, cityID)
            XCTAssertTrue(candidates.allSatisfy { $0.source.citySubcategoryID != nil }, cityID)
            XCTAssertTrue(candidates.allSatisfy { $0.source.placeID != nil }, cityID)
        }
    }

    func testSnapshotCityModesStartFromCitySpecificPrompts() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let snapshot = try PracticeDeckSnapshot.load(
            practicePageIDs: ["viet-phrase-hello-alo"],
            savedPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        for mode in PracticeMode.cityModes {
            let prompts = snapshot.prompts(for: mode)
            let cityID = try XCTUnwrap(mode.cityID)
            let candidates = try repository.loadPracticeCandidates(cityID: cityID, limit: 180)
            let cityVietnamese = Set(candidates.map(\.vietnamese))
            let cityEnglish = Set(candidates.map(\.english))

            XCTAssertEqual(prompts.count, 8, mode.rawValue)
            XCTAssertTrue(prompts.allSatisfy { $0.source.cityID == cityID }, mode.rawValue)
            XCTAssertTrue(prompts.allSatisfy { prompt in
                switch prompt.kind {
                case .englishToVietnamese, .listenAndPick:
                    return prompt.options.allSatisfy { cityVietnamese.contains($0.text) }
                case .vietnameseToEnglish:
                    return prompt.options.allSatisfy { cityEnglish.contains($0.text) }
                case .missingToken:
                    return true
                }
            }, mode.rawValue)
        }
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

    func testPlacementPromptsStayPhraseLearningFocused() throws {
        let snapshot = try PracticeDeckSnapshot.load(
            practicePageIDs: [],
            savedPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let phraseLearningKinds: [PracticePromptKind] = [.listenAndPick, .englishToVietnamese, .vietnameseToEnglish]

        XCTAssertEqual(snapshot.placementPrompts.count, 3)
        XCTAssertTrue(snapshot.placementPrompts.allSatisfy { prompt in
            phraseLearningKinds.contains(prompt.kind)
                && prompt.source.pageID.hasPrefix("viet-phrase-")
                && prompt.source.cityID == "hanoi"
                && prompt.options.contains(where: \.isCorrect)
        })
        XCTAssertFalse(snapshot.placementPrompts.contains { prompt in
            prompt.instruction.localizedCaseInsensitiveContains("where would you")
                || prompt.instruction.localizedCaseInsensitiveContains("travel trivia")
        })
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
