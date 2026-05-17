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

            XCTAssertGreaterThanOrEqual(candidates.count, 140, cityID)
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

    func testSavedPracticeItemsIncludeMenuDrinks() throws {
        let items = try SavedTripPracticeCatalog.items(
            for: [
                "viet-menu-drink-ca-phe-sua-da",
                "viet-menu-drink-ca-phe-den-da",
                "viet-menu-drink-nuoc-mia",
                "viet-menu-drink-tra-da",
            ]
        )

        XCTAssertEqual(
            items.map(\.pageID),
            [
                "viet-menu-drink-ca-phe-sua-da",
                "viet-menu-drink-ca-phe-den-da",
                "viet-menu-drink-nuoc-mia",
                "viet-menu-drink-tra-da",
            ]
        )
        XCTAssertEqual(items.map(\.vietnamese), ["Cà phê sữa đá", "Cà phê đen đá", "Nước mía", "Trà đá"])
        XCTAssertTrue(items.allSatisfy { $0.kind == .drinks })
    }

    func testMatchPracticeSourcesOnlyExposePlayableAudioBackedItems() throws {
        let snapshot = try PracticeMatchSnapshot.load(
            practicePageIDs: [
                "viet-phrase-ves-call-taxi-for-me",
                "viet-phrase-taxi-1",
                "viet-phrase-v500-tran-please-stop-right-here",
                "viet-phrase-v500-tran-please-wait-here",
                "viet-phrase-v500-tran-are-you-my-driver",
            ],
            savedPageIDs: [
                "viet-phrase-ves-drop-me-off-here",
                "viet-phrase-polite-1",
                "viet-phrase-polite-2",
                "viet-phrase-polite-5",
                "viet-phrase-polite-7",
            ]
        )
        let requiredSources = [snapshot.quickSource, snapshot.practiceSource, snapshot.savedSource] + snapshot.topicSources
        var failures: [String] = []

        for source in requiredSources where source.canStart {
            for item in source.items {
                if !AudioSpeakerButton.isPlayableAudioKey(item.audioKey) {
                    failures.append("\(source.id) exposes \(item.pageID) without playable audio")
                }
            }
        }

        XCTAssertTrue(failures.isEmpty, failures.joined(separator: "\n"))
        XCTAssertFalse(snapshot.practiceSource.items.contains { $0.pageID == "viet-phrase-ves-call-taxi-for-me" })
        XCTAssertFalse(snapshot.savedSource.items.contains { $0.pageID == "viet-phrase-ves-drop-me-off-here" })
        XCTAssertTrue(snapshot.topicSources.contains { $0.id == "topic:taxi-directions" && $0.canStart })
        XCTAssertTrue(snapshot.topicSources.contains { $0.id == "topic:shopping-markets" && $0.canStart })
        XCTAssertTrue(snapshot.topicSources.contains { $0.id == "topic:emergency" && $0.canStart })
        XCTAssertTrue(snapshot.topicSources.contains { $0.id == "topic:danang-city" && $0.canStart })
        XCTAssertGreaterThan(snapshot.quickSource.items.count, 40)
        XCTAssertGreaterThan(snapshot.topicSources.first { $0.id == "topic:essentials" }?.items.count ?? 0, 40)
        XCTAssertGreaterThan(snapshot.topicSources.first { $0.id == "topic:first-day" }?.items.count ?? 0, 40)
        XCTAssertGreaterThan(snapshot.topicSources.first { $0.id == "topic:taxi-directions" }?.items.count ?? 0, 40)
        XCTAssertGreaterThan(snapshot.topicSources.first { $0.id == "topic:danang-city" }?.items.count ?? 0, 20)

        let foodSource = try XCTUnwrap(snapshot.topicSources.first { $0.id == "topic:food-drinks" })
        XCTAssertGreaterThanOrEqual(foodSource.imageBackedItems.count, PracticeMatchRound.pairCount)
        XCTAssertTrue(foodSource.imageBackedItems.contains { $0.pageID.hasPrefix("viet-menu-") })
    }

    func testAirportBrowsePracticeStarterCanOpenMatchRound() throws {
        let descriptor = try XCTUnwrap(BrowseSearchDestinations.collectionDescriptor(for: .category("airport")))

        switch descriptor.practiceAction {
        case .practiceSource(let sourceID):
            let snapshot = try PracticeMatchSnapshot.load(practicePageIDs: [], savedPageIDs: [])
            let source = try XCTUnwrap(snapshot.topicSources.first { $0.id == sourceID })

            XCTAssertEqual(sourceID, "topic:airport")
            XCTAssertTrue(source.canStart)
            XCTAssertGreaterThanOrEqual(source.items.count, 4)
        case .addStarterPages, .practiceMode, .practiceScenario:
            XCTFail("Airport Browse practice entry should use the audio-backed airport match topic.")
        }
    }

    func testMatchRoundSamplesFourItemsFromFullSourcePool() throws {
        let source = makeMatchSource(itemCount: 84)
        let firstFourIDs = Set(source.items.prefix(4).map(\.id))

        let sampledRounds = try (0..<8).map { seed in
            var generator = SeededPracticeRandomNumberGenerator(seed: UInt64(seed + 1))
            return try XCTUnwrap(PracticeMatchRound.make(source: source, rng: &generator))
        }
        let selectionSignatures = Set(sampledRounds.map { round in
            round.pairs.map(\.id).joined(separator: "|")
        })

        XCTAssertGreaterThan(selectionSignatures.count, 1)
        XCTAssertTrue(sampledRounds.contains { round in
            !Set(round.pairs.map(\.id)).isSubset(of: firstFourIDs)
        })
        XCTAssertTrue(sampledRounds.allSatisfy { $0.pairs.count == 4 })
    }

    func testMatchRoundShufflesPromptAndAnswerSidesIndependently() throws {
        let source = makeMatchSource(itemCount: 16)
        var generator = SeededPracticeRandomNumberGenerator(seed: 11)

        let round = try XCTUnwrap(PracticeMatchRound.make(source: source, rng: &generator))
        let promptPairIDs = round.prompts.map(\.pairID)
        let answerPairIDs = round.answers.map(\.pairID)

        XCTAssertEqual(Set(promptPairIDs), Set(answerPairIDs))
        XCTAssertNotEqual(promptPairIDs, answerPairIDs)
    }

    func testMatchRoundRotatesThroughImageAndAudioModesWhenImagesExist() throws {
        let source = makeMatchSource(itemCount: 16, imageEvery: 1)
        var generator = SeededPracticeRandomNumberGenerator(seed: 13)

        let firstRound = try XCTUnwrap(PracticeMatchRound.make(source: source, roundIndex: 0, rng: &generator))
        let imageRound = try XCTUnwrap(PracticeMatchRound.make(source: source, roundIndex: 1, rng: &generator))
        let listeningRound = try XCTUnwrap(PracticeMatchRound.make(source: source, roundIndex: 2, rng: &generator))
        let audioImageRound = try XCTUnwrap(PracticeMatchRound.make(source: source, roundIndex: 3, rng: &generator))

        XCTAssertEqual(firstRound.mode, .phraseToMeaning)
        XCTAssertEqual(imageRound.mode, .imageToPhrase)
        XCTAssertEqual(listeningRound.mode, .audioToMeaning)
        XCTAssertEqual(audioImageRound.mode, .audioToImage)
        XCTAssertTrue(imageRound.pairs.allSatisfy { $0.item.imageName != nil })
        XCTAssertTrue(audioImageRound.pairs.allSatisfy { $0.item.imageName != nil })
    }

    func testMatchRoundSkipsImageModesWhenSourceHasNoImages() throws {
        let source = makeMatchSource(itemCount: 16)
        var generator = SeededPracticeRandomNumberGenerator(seed: 14)

        let firstRound = try XCTUnwrap(PracticeMatchRound.make(source: source, roundIndex: 0, rng: &generator))
        let secondRound = try XCTUnwrap(PracticeMatchRound.make(source: source, roundIndex: 1, rng: &generator))
        let thirdRound = try XCTUnwrap(PracticeMatchRound.make(source: source, roundIndex: 2, rng: &generator))

        XCTAssertEqual(firstRound.mode, .phraseToMeaning)
        XCTAssertEqual(secondRound.mode, .audioToMeaning)
        XCTAssertEqual(thirdRound.mode, .phraseToMeaning)
    }

    func testMatchRoundAvoidsImmediateRepeatsWhenSourceHasEnoughItems() throws {
        let source = makeMatchSource(itemCount: 12)
        let currentRoundIDs = Set(source.items.prefix(PracticeMatchRound.pairCount).map(\.id))
        var generator = SeededPracticeRandomNumberGenerator(seed: 22)

        let nextRound = try XCTUnwrap(
            PracticeMatchRound.make(
                source: source,
                avoidingItemIDs: currentRoundIDs,
                rng: &generator
            )
        )

        XCTAssertTrue(Set(nextRound.pairs.map(\.id)).isDisjoint(with: currentRoundIDs))
    }

    func testMatchSessionAdvancesAndCanReturnToPreviousRound() throws {
        let source = makeMatchSource(itemCount: 12)
        var initialGenerator = SeededPracticeRandomNumberGenerator(seed: 31)
        var nextGenerator = SeededPracticeRandomNumberGenerator(seed: 32)
        var session = try XCTUnwrap(PracticeMatchActiveSession(source: source, rng: &initialGenerator))
        let firstRound = session.round

        session.matchedPairIDs = Set(firstRound.pairs.map(\.id))

        XCTAssertTrue(session.advanceToNextRound(rng: &nextGenerator))
        XCTAssertEqual(session.roundIndex, 1)
        XCTAssertNotEqual(session.round.id, firstRound.id)
        XCTAssertTrue(session.matchedPairIDs.isEmpty)
        XCTAssertTrue(session.canReturnToPreviousRound)
        XCTAssertTrue(Set(session.round.pairs.map(\.id)).isDisjoint(with: Set(firstRound.pairs.map(\.id))))

        XCTAssertTrue(session.returnToPreviousRound())
        XCTAssertEqual(session.roundIndex, 0)
        XCTAssertEqual(session.round, firstRound)
        XCTAssertTrue(session.matchedPairIDs.isEmpty)
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

    private func makeMatchSource(itemCount: Int, imageEvery: Int? = nil) -> PracticeMatchSource {
        PracticeMatchSource(
            id: "topic:essentials",
            kind: .topic,
            title: "Essentials",
            subtitle: "Test phrases",
            symbolName: "sparkles",
            tint: .red,
            items: (0..<itemCount).map { index in
                PracticeMatchItem(
                    pageID: "viet-test-practice-\(index)",
                    vietnamese: "Cau \(index)",
                    english: "Phrase \(index)",
                    audioKey: "viet-test-practice-\(index)",
                    symbolName: "sparkles",
                    tint: .red,
                    imageName: imageEvery.flatMap { index % $0 == 0 ? "HeroMenuFoodPhoBo" : nil }
                )
            }
        )
    }
}

private struct SeededPracticeRandomNumberGenerator: RandomNumberGenerator {
    var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}
