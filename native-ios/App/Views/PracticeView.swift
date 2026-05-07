import SwiftUI
import UIKit

struct PracticeView: View {
    @ObservedObject var intentStore: LocalUserIntentStore
    @StateObject private var progressStore: LocalPracticeProgressStore

    let initialMode: PracticeMode?
    let entryContext: PracticeEntryContext
    let startRequest: PracticeStartRequest?
    let isActive: Bool
    let scrollToTopTrigger: Int
    var onOpenDetail: (String) -> Void
    var onBrowseTapped: () -> Void

    @State private var deckState = PracticeDeckLoadState.loading
    @State private var activeSession: PracticeSession?
    @State private var completionSummary: PracticeCompletionSummary?
    @State private var scenarioState = PracticeScenarioLoadState.loading
    @State private var activeScenarioSession: PracticeScenarioSession?
    @State private var scenarioCompletion: PracticeScenarioCompletionSummary?
    @State private var didStartInitialMode = false
    @State private var handledStartRequestID: Int?
    @State private var deckLoadGeneration = 0
    @State private var scenarioLoadGeneration = 0
    @State private var practiceScrollResetTrigger = 0

    init(
        intentStore: LocalUserIntentStore,
        initialMode: PracticeMode? = nil,
        entryContext: PracticeEntryContext = .standard,
        startRequest: PracticeStartRequest? = nil,
        isActive: Bool = true,
        scrollToTopTrigger: Int = 0,
        progressStore: LocalPracticeProgressStore = LocalPracticeProgressStore(),
        onOpenDetail: @escaping (String) -> Void,
        onBrowseTapped: @escaping () -> Void
    ) {
        self.intentStore = intentStore
        self.initialMode = initialMode
        self.entryContext = entryContext
        self.startRequest = startRequest
        self.isActive = isActive
        self.scrollToTopTrigger = scrollToTopTrigger
        self.onOpenDetail = onOpenDetail
        self.onBrowseTapped = onBrowseTapped
        _progressStore = StateObject(wrappedValue: progressStore)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 18) {
                        PracticeCurrentScenarioSurface(
                            activeScenarioSession: activeScenarioSession,
                            scenarioCompletion: scenarioCompletion,
                            scenarioState: scenarioState,
                            explicitPracticeCount: intentStore.practicePageIDs.count,
                            savedPageCount: intentStore.savedPageIDs.count,
                            recentPageCount: intentStore.recentPageIDs.count,
                            isInPracticePool: isScenarioPageInPractice,
                            onOpenPhrasePage: openScenarioPhrasePage,
                            onTogglePracticePage: toggleScenarioPracticePage,
                            onContinueScenario: continueScenarioSession,
                            onPracticeAnother: startAnotherScenario,
                            onBackToPractice: clearScenarioCompletion,
                            onStart: startScenario,
                            onBrowseTapped: onBrowseTapped,
                            onRetry: reloadScenarioSnapshot
                        )
                        .id(Self.scrollTopID)
                    }
                    .padding(.horizontal, PracticeLayout.horizontalPadding)
                    .padding(.top, 76)
                    .padding(.bottom, HomeLayout.bottomChromeContentClearance)
                }
                .onChange(of: scrollToTopTrigger) { _, _ in
                    scrollProxy.scrollTo(Self.scrollTopID, anchor: .top)
                }
                .onChange(of: practiceScrollResetTrigger) { _, _ in
                    withAnimation(.easeInOut(duration: 0.24)) {
                        scrollProxy.scrollTo(Self.scrollTopID, anchor: .top)
                    }
                }
            }
        }
        .task {
            if isActive {
                reloadScenarioSnapshot()
            } else {
                prewarmScenarioSnapshot()
            }
        }
        .onChange(of: isActive) { _, active in
            if active {
                reloadScenarioSnapshot()
                startRequestedScenarioIfReady()
            } else {
                prewarmScenarioSnapshot()
            }
        }
        .onChange(of: startRequest) { _, _ in
            startRequestedScenarioIfReady()
        }
        .onChange(of: intentStore.practicePageIDs) { _, _ in
            reloadOrPrewarmScenarioSnapshot()
        }
        .onChange(of: intentStore.savedPageIDs) { _, _ in
            reloadOrPrewarmScenarioSnapshot()
        }
        .onChange(of: intentStore.recentPageIDs) { _, _ in
            reloadOrPrewarmScenarioSnapshot()
        }
        .accessibilityIdentifier("PracticeView")
    }

    private static let scrollTopID = "PracticeViewTop"

    private func startScenario(_ scenario: PracticeScenario) {
        guard !scenario.steps.isEmpty else {
            return
        }

        activeScenarioSession = PracticeScenarioSession(scenario: scenario)
        scenarioCompletion = nil
        schedulePracticeScrollReset()
    }

    private func startPrimaryScenario(context: PracticeEntryContext = .standard) {
        guard let scenario = scenarioState.snapshot?.primaryScenario else {
            return
        }

        activeScenarioSession = PracticeScenarioSession(scenario: scenario, context: context)
        scenarioCompletion = nil
        schedulePracticeScrollReset()
    }

    private func startAnotherScenario() {
        startPrimaryScenario()
    }

    private func continueScenarioSession() {
        guard var session = activeScenarioSession else {
            return
        }

        if session.isOnLastStep {
            scenarioCompletion = PracticeScenarioCompletionSummary(
                scenario: session.scenario,
                context: session.context,
                practicedCount: session.scenario.steps.count
            )
            activeScenarioSession = nil
            reloadScenarioSnapshot()
            schedulePracticeScrollReset()
            return
        }

        session.currentIndex += 1
        activeScenarioSession = session
        schedulePracticeScrollReset()
    }

    private func schedulePracticeScrollReset() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            practiceScrollResetTrigger += 1
        }
    }

    private func clearScenarioCompletion() {
        scenarioCompletion = nil
        reloadScenarioSnapshot()
    }

    private func isScenarioPageInPractice(_ pageID: String) -> Bool {
        intentStore.isPageInPractice(pageID)
    }

    private func openScenarioPhrasePage(_ pageID: String) {
        onOpenDetail(pageID)
    }

    private func toggleScenarioPracticePage(_ pageID: String) {
        intentStore.togglePracticePage(pageID)
        reloadScenarioSnapshot()
    }

    private func reloadOrPrewarmScenarioSnapshot() {
        if isActive {
            reloadScenarioSnapshot()
        } else {
            prewarmScenarioSnapshot()
        }
    }

    private func prewarmScenarioSnapshot() {
        let missedPromptIDs = progressStore.missedPromptIDs

        PracticeScenarioBuilder.prewarm(
            practicePageIDs: intentStore.practicePageIDs,
            savedPageIDs: intentStore.savedPageIDs,
            recentPageIDs: intentStore.recentPageIDs,
            missedPromptIDs: missedPromptIDs
        )
    }

    private func reloadScenarioSnapshot() {
        scenarioLoadGeneration += 1
        let loadGeneration = scenarioLoadGeneration
        let practicePageIDs = intentStore.practicePageIDs
        let savedPageIDs = intentStore.savedPageIDs
        let recentPageIDs = intentStore.recentPageIDs
        let missedPromptIDs = progressStore.missedPromptIDs

        if scenarioState.snapshot == nil {
            scenarioState = .loading
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let snapshot = try PracticeScenarioBuilder.loadSnapshot(
                    practicePageIDs: practicePageIDs,
                    savedPageIDs: savedPageIDs,
                    recentPageIDs: recentPageIDs,
                    missedPromptIDs: missedPromptIDs
                )

                DispatchQueue.main.async {
                    guard scenarioLoadGeneration == loadGeneration else {
                        return
                    }

                    scenarioState = .loaded(snapshot)
                    scheduleInitialModeStartIfNeeded()
                    startRequestedScenarioIfReady()
                }
            } catch {
                DispatchQueue.main.async {
                    guard scenarioLoadGeneration == loadGeneration else {
                        return
                    }

                    scenarioState = .failed(error.localizedDescription)
                }
            }
        }
    }

    private func startSession(_ mode: PracticeMode, context: PracticeEntryContext = .standard) {
        guard let deck = deckState.snapshot else {
            return
        }

        let prompts = context == .placement ? deck.placementPrompts : deck.prompts(for: mode)
        guard !prompts.isEmpty else {
            return
        }

        activeSession = PracticeSession(mode: mode, prompts: prompts, context: context)
        completionSummary = nil
    }

    private func scheduleInitialModeStartIfNeeded() {
        guard !didStartInitialMode else {
            return
        }

        didStartInitialMode = true

        Task { @MainActor in
            await Task.yield()
            startInitialMode()
        }
    }

    private func startInitialMode() {
        if entryContext == .placement {
            startPrimaryScenario(context: .placement)
            return
        }

        guard initialMode != nil else {
            return
        }

        startPrimaryScenario()
    }

    private func startRequestedScenarioIfReady() {
        guard
            let startRequest,
            handledStartRequestID != startRequest.id,
            isActive,
            scenarioState.snapshot != nil
        else {
            return
        }

        handledStartRequestID = startRequest.id
        startPrimaryScenario()
    }

    private func selectOption(_ option: PracticeAnswerOption) {
        guard var session = activeSession, session.selectedOptionID == nil, let prompt = session.currentPrompt else {
            return
        }

        progressStore.record(prompt: prompt, selectedOption: option)
        session.selectedOptionID = option.id
        session.correctCount += option.isCorrect ? 1 : 0
        session.missedCount += option.isCorrect ? 0 : 1
        activeSession = session
    }

    private func continueSession() {
        guard var session = activeSession else {
            return
        }

        if session.isOnLastPrompt {
            completionSummary = PracticeCompletionSummary(
                mode: session.mode,
                context: session.context,
                practicedCount: session.prompts.count,
                correctCount: session.correctCount,
                missedCount: session.missedCount,
                readyCount: progressStore.readyCount(in: session.prompts.map(\.id))
            )
            activeSession = nil
            reloadDeck()
            return
        }

        session.currentIndex += 1
        session.selectedOptionID = nil
        activeSession = session
    }

    private func clearCompletion() {
        completionSummary = nil
        reloadDeck()
    }

    private func togglePracticePage(_ pageID: String) {
        intentStore.togglePracticePage(pageID)
        reloadDeck()
    }

    private func reloadOrPrewarmDeck() {
        if isActive {
            reloadDeck()
        } else {
            prewarmDeck()
        }
    }

    private func prewarmDeck() {
        PracticeDeckSnapshot.prewarm(
            practicePageIDs: intentStore.practicePageIDs,
            savedPageIDs: intentStore.savedPageIDs,
            readyPromptIDs: progressStore.readyPromptIDs,
            missedPromptIDs: progressStore.missedPromptIDs
        )
    }

    private func reloadDeck() {
        deckLoadGeneration += 1
        let loadGeneration = deckLoadGeneration
        let practicePageIDs = intentStore.practicePageIDs
        let savedPageIDs = intentStore.savedPageIDs
        let readyPromptIDs = progressStore.readyPromptIDs
        let missedPromptIDs = progressStore.missedPromptIDs
        let cacheKey = PracticeDeckSnapshot.cacheKey(
            practicePageIDs: practicePageIDs,
            savedPageIDs: savedPageIDs,
            readyPromptIDs: readyPromptIDs,
            missedPromptIDs: missedPromptIDs
        )

        if let snapshot = PracticeDeckSnapshot.cachedSnapshot(for: cacheKey) {
            deckState = .loaded(snapshot)
            scheduleInitialModeStartIfNeeded()
            startRequestedScenarioIfReady()
            return
        }

        if deckState.snapshot == nil {
            deckState = .loading
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let snapshot = try PracticeDeckSnapshot.load(
                    practicePageIDs: practicePageIDs,
                    savedPageIDs: savedPageIDs,
                    readyPromptIDs: readyPromptIDs,
                    missedPromptIDs: missedPromptIDs
                )

                DispatchQueue.main.async {
                    guard deckLoadGeneration == loadGeneration else {
                        return
                    }

                    deckState = .loaded(snapshot)
                    PracticeDeckSnapshot.storeCachedSnapshot(snapshot, for: cacheKey)
                    scheduleInitialModeStartIfNeeded()
                    startRequestedScenarioIfReady()
                }
            } catch {
                DispatchQueue.main.async {
                    guard deckLoadGeneration == loadGeneration else {
                        return
                    }

                    deckState = .failed(error.localizedDescription)
                }
            }
        }
    }
}

fileprivate struct PracticeDeckCacheKey: Hashable {
    let practicePageIDs: [String]
    let savedPageIDs: [String]
    let readyPromptIDs: [String]
    let missedPromptIDs: [String]
}

fileprivate enum PracticeDeckSnapshotCache {
    private static let lock = NSLock()
    private static var snapshots: [PracticeDeckCacheKey: PracticeDeckSnapshot] = [:]
    private static var inFlightKeys = Set<PracticeDeckCacheKey>()

    static func snapshot(for key: PracticeDeckCacheKey) -> PracticeDeckSnapshot? {
        lock.lock()
        defer { lock.unlock() }
        return snapshots[key]
    }

    static func beginLoading(_ key: PracticeDeckCacheKey) -> Bool {
        lock.lock()
        defer { lock.unlock() }

        guard snapshots[key] == nil, !inFlightKeys.contains(key) else {
            return false
        }

        inFlightKeys.insert(key)
        return true
    }

    static func store(_ snapshot: PracticeDeckSnapshot, for key: PracticeDeckCacheKey) {
        lock.lock()
        defer { lock.unlock() }

        snapshots[key] = snapshot
        inFlightKeys.remove(key)

        if snapshots.count > 4, let oldestKey = snapshots.keys.first {
            snapshots.removeValue(forKey: oldestKey)
        }
    }

    static func finishLoading(_ key: PracticeDeckCacheKey) {
        lock.lock()
        defer { lock.unlock() }
        inFlightKeys.remove(key)
    }
}

private enum PracticeDeckLoadState {
    case loading
    case loaded(PracticeDeckSnapshot)
    case failed(String)

    var snapshot: PracticeDeckSnapshot? {
        if case .loaded(let snapshot) = self {
            return snapshot
        }

        return nil
    }
}

struct PracticeDeckSnapshot {
    let cityPrompts: [PracticeMode: [PracticePrompt]]
    let placementPrompts: [PracticePrompt]
    let savedPrompts: [PracticePrompt]
    let missedPrompts: [PracticePrompt]
    let cityReadyCounts: [PracticeMode: Int]
    let cityMissedCounts: [PracticeMode: Int]
    let citySeedCounts: [PracticeMode: Int]

    var bucketPrompts: [PracticePrompt] {
        cityPrompts[.hanoiBucketList] ?? []
    }

    var bucketReadyCount: Int {
        cityReadyCounts[.hanoiBucketList] ?? 0
    }

    var bucketMissedCount: Int {
        cityMissedCounts[.hanoiBucketList] ?? 0
    }

    var hanoiSeedCount: Int {
        citySeedCounts[.hanoiBucketList] ?? 0
    }

    func prompts(for mode: PracticeMode) -> [PracticePrompt] {
        if mode.isCityMode {
            return cityPrompts[mode] ?? []
        } else if mode == .savedReview {
            return savedPrompts
        } else {
            return missedPrompts
        }
    }

    static func load(
        practicePageIDs: [String],
        savedPageIDs: [String],
        progressStore: LocalPracticeProgressStore
    ) throws -> PracticeDeckSnapshot {
        try load(
            practicePageIDs: practicePageIDs,
            savedPageIDs: savedPageIDs,
            readyPromptIDs: progressStore.readyPromptIDs,
            missedPromptIDs: progressStore.missedPromptIDs
        )
    }

    static func load(
        practicePageIDs: [String],
        savedPageIDs: [String],
        readyPromptIDs: Set<String>,
        missedPromptIDs: Set<String>
    ) throws -> PracticeDeckSnapshot {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let explicitCandidates = practicePageIDs.isEmpty
            ? []
            : try repository.loadPracticeCandidates(
                pageIDs: practicePageIDs,
                limit: max(24, practicePageIDs.count)
            )
        let cityCandidates = try Dictionary(uniqueKeysWithValues: PracticeMode.cityModes.map { mode in
            (
                mode,
                try repository.loadPracticeCandidates(
                    cityID: mode.cityID,
                    limit: 24
                )
            )
        })
        let audioStarterCandidates = try repository.loadPracticeCandidates(requiringAudio: true, limit: 24)
        let savedCandidates = savedPageIDs.isEmpty
            ? []
            : try repository.loadPracticeCandidates(
                pageIDs: savedPageIDs,
                limit: max(24, savedPageIDs.count)
            )
        let generalCandidates = try repository.loadPracticeCandidates(limit: 120)
        let explicitPageIDSet = Set(explicitCandidates.map(\.pageID))
        let savedOnlyPageIDSet = Set(savedCandidates.map(\.pageID)).subtracting(explicitPageIDSet)
        let allCityCandidates = uniqueCandidates(PracticeMode.cityModes.flatMap { cityCandidates[$0] ?? [] })
        let distractors = uniqueCandidates(explicitCandidates + allCityCandidates + audioStarterCandidates + savedCandidates + generalCandidates)
        let cityPrompts = Dictionary(uniqueKeysWithValues: PracticeMode.cityModes.map { mode in
            let candidates = uniqueCandidates((cityCandidates[mode] ?? []) + explicitCandidates)
                .filter { candidate in
                    explicitPageIDSet.contains(candidate.pageID) || !savedOnlyPageIDSet.contains(candidate.pageID)
                }
            let prompts = PracticePromptGenerator.prompts(
                mode: mode,
                candidates: candidates,
                distractors: distractors,
                limit: 8
            )

            return (mode, prompts)
        })
        let placementPrompts = PracticePromptGenerator.placementPrompts(
            candidates: uniqueCandidates((cityCandidates[.hanoiBucketList] ?? []) + audioStarterCandidates),
            distractors: distractors,
            limit: 3
        )
        let savedPrompts = PracticePromptGenerator.prompts(
            mode: .savedReview,
            candidates: savedCandidates,
            distractors: distractors,
            limit: 8
        )
        let missedPrompts = PracticePromptGenerator.missedPrompts(
            candidates: distractors,
            distractors: distractors,
            missedPromptIDs: missedPromptIDs,
            limit: 8
        )

        return PracticeDeckSnapshot(
            cityPrompts: cityPrompts,
            placementPrompts: placementPrompts,
            savedPrompts: savedPrompts,
            missedPrompts: missedPrompts,
            cityReadyCounts: Dictionary(uniqueKeysWithValues: PracticeMode.cityModes.map { mode in
                (mode, Self.countReadyPrompts((cityPrompts[mode] ?? []).map(\.id), readyPromptIDs: readyPromptIDs))
            }),
            cityMissedCounts: Dictionary(uniqueKeysWithValues: PracticeMode.cityModes.map { mode in
                (mode, Self.countMissedPrompts((cityPrompts[mode] ?? []).map(\.id), missedPromptIDs: missedPromptIDs))
            }),
            citySeedCounts: Dictionary(uniqueKeysWithValues: PracticeMode.cityModes.map { mode in
                (mode, cityCandidates[mode]?.count ?? 0)
            })
        )
    }

    fileprivate static func cacheKey(
        practicePageIDs: [String],
        savedPageIDs: [String],
        readyPromptIDs: Set<String>,
        missedPromptIDs: Set<String>
    ) -> PracticeDeckCacheKey {
        PracticeDeckCacheKey(
            practicePageIDs: practicePageIDs,
            savedPageIDs: savedPageIDs,
            readyPromptIDs: readyPromptIDs.sorted(),
            missedPromptIDs: missedPromptIDs.sorted()
        )
    }

    fileprivate static func cachedSnapshot(for key: PracticeDeckCacheKey) -> PracticeDeckSnapshot? {
        PracticeDeckSnapshotCache.snapshot(for: key)
    }

    fileprivate static func storeCachedSnapshot(_ snapshot: PracticeDeckSnapshot, for key: PracticeDeckCacheKey) {
        PracticeDeckSnapshotCache.store(snapshot, for: key)
    }

    fileprivate static func prewarm(
        practicePageIDs: [String],
        savedPageIDs: [String],
        readyPromptIDs: Set<String>,
        missedPromptIDs: Set<String>
    ) {
        let key = cacheKey(
            practicePageIDs: practicePageIDs,
            savedPageIDs: savedPageIDs,
            readyPromptIDs: readyPromptIDs,
            missedPromptIDs: missedPromptIDs
        )

        guard PracticeDeckSnapshotCache.beginLoading(key) else {
            return
        }

        DispatchQueue.global(qos: .utility).async {
            do {
                let snapshot = try load(
                    practicePageIDs: practicePageIDs,
                    savedPageIDs: savedPageIDs,
                    readyPromptIDs: readyPromptIDs,
                    missedPromptIDs: missedPromptIDs
                )
                PracticeDeckSnapshotCache.store(snapshot, for: key)
            } catch {
                PracticeDeckSnapshotCache.finishLoading(key)
            }
        }
    }

    private static func uniqueCandidates(_ candidates: [PracticeCandidate]) -> [PracticeCandidate] {
        var seenPageIDs = Set<String>()

        return candidates.filter { candidate in
            seenPageIDs.insert(candidate.pageID).inserted
        }
    }

    private static func countReadyPrompts(_ promptIDs: [String], readyPromptIDs: Set<String>) -> Int {
        promptIDs.filter { readyPromptIDs.contains($0) }.count
    }

    private static func countMissedPrompts(_ promptIDs: [String], missedPromptIDs: Set<String>) -> Int {
        promptIDs.filter { missedPromptIDs.contains($0) }.count
    }
}

private struct PracticeSession: Equatable {
    let mode: PracticeMode
    let prompts: [PracticePrompt]
    let context: PracticeEntryContext
    var currentIndex = 0
    var selectedOptionID: String?
    var correctCount = 0
    var missedCount = 0

    var currentPrompt: PracticePrompt? {
        guard prompts.indices.contains(currentIndex) else {
            return nil
        }

        return prompts[currentIndex]
    }

    var isOnLastPrompt: Bool {
        currentIndex >= prompts.count - 1
    }
}

private struct PracticeCompletionSummary: Equatable {
    let mode: PracticeMode
    let context: PracticeEntryContext
    let practicedCount: Int
    let correctCount: Int
    let missedCount: Int
    let readyCount: Int
}

private struct PracticeScenarioSession: Equatable {
    let scenario: PracticeScenario
    var context: PracticeEntryContext = .standard
    var currentIndex = 0

    var currentStep: PracticeScenarioStep? {
        guard scenario.steps.indices.contains(currentIndex) else {
            return nil
        }

        return scenario.steps[currentIndex]
    }

    var isOnLastStep: Bool {
        currentIndex >= scenario.steps.count - 1
    }
}

private struct PracticeScenarioCompletionSummary: Equatable {
    let scenario: PracticeScenario
    let context: PracticeEntryContext
    let practicedCount: Int
}

private struct PracticeCurrentScenarioSurface: View {
    let activeScenarioSession: PracticeScenarioSession?
    let scenarioCompletion: PracticeScenarioCompletionSummary?
    let scenarioState: PracticeScenarioLoadState
    let explicitPracticeCount: Int
    let savedPageCount: Int
    let recentPageCount: Int
    let isInPracticePool: (String) -> Bool
    let onOpenPhrasePage: (String) -> Void
    let onTogglePracticePage: (String) -> Void
    let onContinueScenario: () -> Void
    let onPracticeAnother: () -> Void
    let onBackToPractice: () -> Void
    let onStart: (PracticeScenario) -> Void
    let onBrowseTapped: () -> Void
    let onRetry: () -> Void

    var body: some View {
        if let activeScenarioSession, let currentStep = activeScenarioSession.currentStep {
            PracticeScenarioSessionSurface(
                session: activeScenarioSession,
                step: currentStep,
                isInPracticePool: isInPracticePool,
                onOpenPhrasePage: onOpenPhrasePage,
                onTogglePracticePage: onTogglePracticePage,
                onContinue: onContinueScenario
            )
        } else if let scenarioCompletion {
            PracticeScenarioCompletionSurface(
                summary: scenarioCompletion,
                onPracticeAnother: onPracticeAnother,
                onBackToPractice: onBackToPractice,
                onBrowseTapped: onBrowseTapped
            )
        } else {
            PracticeScenarioHubSurface(
                state: scenarioState,
                explicitPracticeCount: explicitPracticeCount,
                savedPageCount: savedPageCount,
                recentPageCount: recentPageCount,
                onStart: onStart,
                onBrowseTapped: onBrowseTapped,
                onRetry: onRetry
            )
        }
    }
}

private struct PracticeScenarioHubSurface: View {
    let state: PracticeScenarioLoadState
    let explicitPracticeCount: Int
    let savedPageCount: Int
    let recentPageCount: Int
    let onStart: (PracticeScenario) -> Void
    let onBrowseTapped: () -> Void
    let onRetry: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            PracticeScenarioHeader()

            switch state {
            case .loading:
                PracticeLoadingCard()
            case .failed(let message):
                PracticeErrorCard(message: message, onRetry: onRetry)
            case .loaded(let snapshot):
                if let primary = snapshot.primaryScenario {
                    PracticeScenarioPrimaryCard(
                        scenario: primary,
                        explicitPracticeCount: explicitPracticeCount,
                        savedPageCount: savedPageCount,
                        recentPageCount: recentPageCount,
                        onStart: { onStart(primary) }
                    )
                }

                PracticeScenarioModeList(
                    scenarios: snapshot.scenarios,
                    onStart: onStart
                )

                PracticeScenarioHowBuiltCard(snapshot: snapshot)
                PracticeBrowseCard(onBrowseTapped: onBrowseTapped)
            }
        }
    }
}

private struct PracticeScenarioHeader: View {
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 9) {
                HStack(spacing: 8) {
                    Image(systemName: "figure.walk.motion")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.red)

                    Text("SCENARIO MODE")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Text("Practice what happens next")
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.68)

                Text("Short travel moments built from your saved phrases, recent phrases, and useful follow-ups.")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)

            MeloCompanionMark(stage: .base, size: 72)
                .padding(.top, 16)
        }
        .accessibilityIdentifier("Practice.Scenario.Header")
    }
}

private struct PracticeScenarioPrimaryCard: View {
    let scenario: PracticeScenario
    let explicitPracticeCount: Int
    let savedPageCount: Int
    let recentPageCount: Int
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 14) {
                PracticeIcon(symbolName: scenario.id.symbolName, tint: scenario.id.tint)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Continue rehearsal")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)

                    Text(scenario.sceneTitle)
                        .font(.title2.weight(.black))
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    Text(scenario.sceneSetup)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
            }

            HStack(spacing: 10) {
                PracticeMetricPill(title: "steps", value: "\(scenario.steps.count)")
                PracticeMetricPill(title: "saved", value: "\(max(explicitPracticeCount, savedPageCount))")
                PracticeMetricPill(title: "follow-up", value: "\(max(scenario.steps.count - 1, 1))")
            }

            Text("\(savedPageCount) saved and \(recentPageCount) recent phrase page\(savedPageCount + recentPageCount == 1 ? "" : "s") can become short scenes when you want to rehearse.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Button(action: onStart) {
                Label("Start scene", systemImage: "play.fill")
                    .font(.headline.weight(.bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .background(Color.red, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .phraseListCard(cornerRadius: 28, strokeOpacity: 0.05)
        .accessibilityIdentifier("Practice.Scenario.Primary")
    }
}

private struct PracticeScenarioModeList: View {
    let scenarios: [PracticeScenario]
    let onStart: (PracticeScenario) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Try a scenario")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.secondary)

            VStack(spacing: 10) {
                ForEach(scenarios) { scenario in
                    PracticeScenarioModeRow(scenario: scenario)
                        .onTapGesture {
                            onStart(scenario)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityAddTraits(.isButton)
                        .accessibilityLabel(scenario.id.title)
                        .accessibilityIdentifier("Practice.Scenario.\(scenario.id.rawValue)")
                        .accessibilityAction {
                            onStart(scenario)
                        }
                }
            }
        }
    }
}

private struct PracticeScenarioModeRow: View {
    let scenario: PracticeScenario

    var body: some View {
        HStack(spacing: 14) {
            PracticeIcon(symbolName: scenario.id.symbolName, tint: scenario.id.tint, size: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(scenario.id.title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.primary)

                Text(scenario.queueSource.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .layoutPriority(1)

            Text("\(scenario.steps.count)")
                .font(.headline.weight(.black))
                .foregroundStyle(.red)
                .frame(width: 40, height: 40)
                .nativeGlass(cornerRadius: 20)

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 86, alignment: .leading)
        .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .phraseListCard(cornerRadius: 22)
    }
}

private struct PracticeScenarioHowBuiltCard: View {
    let snapshot: PracticeScenarioDeckSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How scenarios are built")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 0) {
                    PracticeBuildSourceColumn(
                        symbolName: "bookmark.fill",
                        tint: .blue,
                        title: "Saved phrases",
                        subtitle: "What you've saved to keep."
                    )

                    PracticeBuildDivider()

                    PracticeBuildSourceColumn(
                        symbolName: "clock.fill",
                        tint: .green,
                        title: "Recent phrases",
                        subtitle: "What you've used most recently."
                    )

                    PracticeBuildDivider()

                    PracticeBuildSourceColumn(
                        symbolName: "text.bubble.fill",
                        tint: .purple,
                        title: "Helpful follow-ups",
                        subtitle: "Smart additions to keep scenes flowing."
                    )
                }

                Divider()
                    .opacity(0.5)

                Text(summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .phraseListCard(cornerRadius: 24)
        }
        .accessibilityIdentifier("Practice.Scenario.HowBuilt")
    }

    private var summary: String {
        let savedCount = snapshot.queueCounts[.addedPractice, default: 0]
        let recentCount = snapshot.queueCounts[.savedRecent, default: 0]
        let starterCount = snapshot.queueCounts[.tripFallback, default: 0]
        return "\(savedCount) saved, \(recentCount) recent, and \(starterCount) starter phrases can become short, useful travel scenes."
    }
}

private struct PracticeBuildSourceColumn: View {
    let symbolName: String
    let tint: AccentTint
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PracticeIcon(symbolName: symbolName, tint: tint, size: 34)

            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct PracticeBuildDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.black.opacity(0.08))
            .frame(width: 1)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
    }
}

private struct PracticeScenarioSessionSurface: View {
    let session: PracticeScenarioSession
    let step: PracticeScenarioStep
    let isInPracticePool: (String) -> Bool
    let onOpenPhrasePage: (String) -> Void
    let onTogglePracticePage: (String) -> Void
    let onContinue: () -> Void

    private var recommendedOption: PracticeScenarioResponseOption? {
        step.bestResponse
    }

    private var otherOptions: [PracticeScenarioResponseOption] {
        step.responseOptions.filter { option in
            option.id != recommendedOption?.id
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text(session.context == .placement ? "PLACEMENT" : "SCENARIO MODE")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(session.scenario.id.title)
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)
            }

            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .top, spacing: 14) {
                    PracticeIcon(symbolName: session.scenario.id.symbolName, tint: session.scenario.id.tint)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Moment \(session.currentIndex + 1) of \(session.scenario.steps.count)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)

                        Text(step.scene)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .layoutPriority(1)
                }

                PracticeScenarioLocalLine(step: step)

                if let recommendedOption {
                    PracticeScenarioReplySection(
                        title: "Best quick reply",
                        options: [recommendedOption],
                        style: .recommended,
                        isInPracticePool: isInPracticePool,
                        onOpenPhrasePage: onOpenPhrasePage,
                        onTogglePracticePage: onTogglePracticePage
                    )
                }

                if !otherOptions.isEmpty {
                    PracticeScenarioReplySection(
                        title: "More ways to say it",
                        options: otherOptions,
                        style: .standard,
                        isInPracticePool: isInPracticePool,
                        onOpenPhrasePage: onOpenPhrasePage,
                        onTogglePracticePage: onTogglePracticePage
                    )
                }

                PracticeScenarioRecoveryPanel(
                    recovery: step.recovery,
                    isInPracticePool: isInPracticePool,
                    onOpenPhrasePage: onOpenPhrasePage,
                    onTogglePracticePage: onTogglePracticePage
                )

                PracticeFloatingContinueButton(
                    title: session.isOnLastStep ? "Finish scene" : "Next moment",
                    onContinue: onContinue
                )
            }
            .padding(18)
            .phraseListCard(cornerRadius: 24)
        }
        .accessibilityIdentifier("Practice.Scenario.Session")
    }
}

private struct PracticeScenarioLocalLine: View {
    let step: PracticeScenarioStep

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("You hear")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            Text(step.localPhrase.scenarioVietnamese)
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundStyle(.primary)
                .lineLimit(3)
                .minimumScaleFactor(0.68)

            Text(step.localPhrase.scenarioEnglish)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(.white.opacity(0.52), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private enum PracticeScenarioReplyStyle: Equatable {
    case recommended
    case standard
}

private struct PracticeScenarioReplySection: View {
    let title: String
    let options: [PracticeScenarioResponseOption]
    let style: PracticeScenarioReplyStyle
    let isInPracticePool: (String) -> Bool
    let onOpenPhrasePage: (String) -> Void
    let onTogglePracticePage: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.secondary)

            ForEach(options) { option in
                PracticeScenarioReplyRow(
                    option: option,
                    style: style,
                    isSaved: isInPracticePool(option.candidate.pageID),
                    onOpenPhrasePage: { onOpenPhrasePage(option.candidate.pageID) },
                    onTogglePracticePage: { onTogglePracticePage(option.candidate.pageID) }
                )
            }
        }
    }
}

private struct PracticeScenarioReplyRow: View {
    let option: PracticeScenarioResponseOption
    let style: PracticeScenarioReplyStyle
    let isSaved: Bool
    let onOpenPhrasePage: () -> Void
    let onTogglePracticePage: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Button(action: onOpenPhrasePage) {
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: style == .recommended ? "text.bubble.fill" : "bubble.left.and.text.bubble.right.fill")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(rowTint.color)
                        .frame(width: 34, height: 34)
                        .nativeGlass(cornerRadius: 17, tint: rowTint.color.opacity(0.14))

                    VStack(alignment: .leading, spacing: 3) {
                        Text(option.scenarioVietnamese)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.76)

                        Text(option.scenarioEnglish)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .layoutPriority(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier(style == .recommended ? "Practice.Reply.Recommended" : "Practice.Reply.Other")

            if let audioKey = option.audioKey {
                AudioSpeakerButton(
                    tint: rowTint,
                    size: 38,
                    audioKey: audioKey,
                    accessibilityIdentifier: "Practice.Option.Audio"
                )
            }

            Button(action: onTogglePracticePage) {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .font(.headline.weight(.bold))
                    .frame(width: 38, height: 38)
            }
            .buttonStyle(.plain)
            .foregroundStyle(isSaved ? Color.green : Color.secondary)
            .nativeGlass(cornerRadius: 19, interactive: true)
            .accessibilityLabel(isSaved ? "Saved for later" : "Save for later")
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(rowBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(rowStroke, lineWidth: 1)
        }
    }

    private var rowBackground: Color {
        style == .recommended ? rowTint.color.opacity(0.10) : .white.opacity(0.58)
    }

    private var rowStroke: Color {
        style == .recommended ? rowTint.color.opacity(0.28) : Color.black.opacity(0.05)
    }

    private var rowTint: AccentTint {
        style == .recommended ? .green : option.candidate.tintName
    }
}

private struct PracticeScenarioRecoveryPanel: View {
    let recovery: PracticeScenarioRecovery
    let isInPracticePool: (String) -> Bool
    let onOpenPhrasePage: (String) -> Void
    let onTogglePracticePage: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("If unsure")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.secondary)

            Text(recovery.body)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            if let recoveryCandidate = recovery.candidate {
                PracticeScenarioReplyRow(
                    option: PracticeScenarioResponseOption(
                        id: "recovery:\(recoveryCandidate.pageID)",
                        candidate: recoveryCandidate,
                        isBestFit: false,
                        scenarioCopy: PracticeScenarioPhraseCopy(
                            scenarioVietnamese: recoveryCandidate.vietnamese,
                            scenarioEnglish: recoveryCandidate.english,
                            scenarioRole: .ifUnsure,
                            scenarioContext: "scenario_recovery",
                            sourcePhraseID: recoveryCandidate.phraseID
                        ),
                        feedbackTitle: "",
                        feedbackBody: ""
                    ),
                    style: .standard,
                    isSaved: isInPracticePool(recoveryCandidate.pageID),
                    onOpenPhrasePage: { onOpenPhrasePage(recoveryCandidate.pageID) },
                    onTogglePracticePage: { onTogglePracticePage(recoveryCandidate.pageID) }
                )
            }
        }
        .padding(14)
        .background(Color.blue.opacity(0.06), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct PracticeScenarioCompletionSurface: View {
    let summary: PracticeScenarioCompletionSummary
    let onPracticeAnother: () -> Void
    let onBackToPractice: () -> Void
    let onBrowseTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text(summary.context == .placement ? "PLACEMENT" : "SCENARIO MODE")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text("Scene complete")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.74)
            }

            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 14) {
                    MeloCompanionMark(stage: .completion, size: 76)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(summary.scenario.id.title)
                            .font(.title3.weight(.black))
                            .foregroundStyle(.primary)

                        Text("You practiced the scene, kept the exchange short, and saved useful next-step phrases.")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                    }
                    .layoutPriority(1)
                }

                HStack(spacing: 10) {
                    PracticeMetricPill(title: "Moments", value: "\(summary.practicedCount)")
                    PracticeMetricPill(title: "Phrases", value: "\(summary.scenario.phrasePageIDs.count)")
                    PracticeMetricPill(title: "Scenes", value: "1")
                }

                Button(action: onPracticeAnother) {
                    Label("Practice another scene", systemImage: "figure.walk.motion")
                        .font(.headline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.white)
                .background(Color.red, in: RoundedRectangle(cornerRadius: 19, style: .continuous))

                Button(action: onBackToPractice) {
                    Label("Back to Practice", systemImage: "text.bubble.fill")
                        .font(.headline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.red)
                .nativeGlass(cornerRadius: 18, interactive: true)
            }
            .padding(18)
            .phraseListCard(cornerRadius: 24)

            let recommendedOptions = summary.scenario.steps.compactMap(\.bestResponse)
            if !recommendedOptions.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Related phrases")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.secondary)

                    ForEach(recommendedOptions.prefix(3), id: \.id) { option in
                        PracticeScenarioCompletionPhraseRow(option: option)
                    }
                }
            }

            Button(action: onBrowseTapped) {
                Label("Find another phrase", systemImage: "plus.circle.fill")
                    .font(.headline.weight(.bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.red)
            .nativeGlass(cornerRadius: 18, interactive: true)
        }
        .accessibilityIdentifier("Practice.Scenario.Completion")
    }
}

private struct PracticeScenarioCompletionPhraseRow: View {
    let option: PracticeScenarioResponseOption

    var body: some View {
        HStack(spacing: 12) {
            PracticeIcon(symbolName: option.candidate.symbolName, tint: option.candidate.tintName, size: 38)

            VStack(alignment: .leading, spacing: 3) {
                Text(option.scenarioVietnamese)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                Text(option.scenarioEnglish)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .layoutPriority(1)
        }
        .padding(12)
        .phraseListCard(cornerRadius: 18)
    }
}

private struct PracticeHubSurface: View {
    let deckState: PracticeDeckLoadState
    let explicitPracticeCount: Int
    let savedPageCount: Int
    let onStart: (PracticeMode) -> Void
    let onBrowseTapped: () -> Void
    let onRetry: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            PracticeHeader()

            switch deckState {
            case .loading:
                PracticeLoadingCard()
            case .failed(let message):
                PracticeErrorCard(message: message, onRetry: onRetry)
            case .loaded(let deck):
                PracticeCityModeCard(
                    mode: .hanoiBucketList,
                    promptCount: deck.prompts(for: .hanoiBucketList).count,
                    readyCount: deck.cityReadyCounts[.hanoiBucketList] ?? 0,
                    reviewCount: deck.cityMissedCounts[.hanoiBucketList] ?? 0,
                    seedCount: deck.citySeedCounts[.hanoiBucketList] ?? 0,
                    explicitPracticeCount: explicitPracticeCount,
                    onStart: { onStart(.hanoiBucketList) }
                )

                PracticeCityPathStrip(
                    deck: deck,
                    onStart: onStart
                )

                PracticeReviewModeRow(
                    mode: .savedReview,
                    count: deck.savedPrompts.count,
                    contextCount: savedPageCount,
                    isEnabled: !deck.savedPrompts.isEmpty,
                    onStart: { onStart(.savedReview) }
                )

                PracticeReviewModeRow(
                    mode: .missedReview,
                    count: deck.missedPrompts.count,
                    contextCount: deck.bucketMissedCount,
                    isEnabled: !deck.missedPrompts.isEmpty,
                    onStart: { onStart(.missedReview) }
                )

                PracticeBrowseCard(onBrowseTapped: onBrowseTapped)
            }
        }
    }
}

private struct PracticeHeader: View {
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 9) {
                HStack(spacing: 8) {
                    Image(systemName: "text.bubble.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.red)

                    Text("PRACTICE")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Text("Rehearse one useful phrase")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.74)

                Text("Start with Hanoi, review saved pages separately, and let missed prompts come back calmly.")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)

            MeloCompanionMark(stage: .base, size: 70)
                .padding(.top, 8)
        }
    }
}

private struct PracticeCityModeCard: View {
    let mode: PracticeMode
    let promptCount: Int
    let readyCount: Int
    let reviewCount: Int
    let seedCount: Int
    let explicitPracticeCount: Int
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                PracticeIcon(symbolName: symbolName, tint: tint)

                VStack(alignment: .leading, spacing: 6) {
                    Text(mode.title)
                        .font(.title2.weight(.black))
                        .foregroundStyle(.primary)

                    Text(mode.subtitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
            }

                HStack(spacing: 10) {
                    PracticeMetricPill(title: "Ready", value: "\(readyCount)")
                    PracticeMetricPill(title: "Repeat", value: "\(reviewCount)")
                    PracticeMetricPill(title: "Saved", value: "\(explicitPracticeCount)")
                }

            Text("\(seedCount) real \(mode.cityShortName ?? "city") phrases can start this path. Saved phrase pages stay first.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Button(action: onStart) {
                Label(promptCount == 0 ? "No prompts yet" : "Continue practicing", systemImage: "play.fill")
                    .font(.headline.weight(.bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .background(Color.red, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .disabled(promptCount == 0)
            .opacity(promptCount == 0 ? 0.56 : 1)
        }
        .padding(18)
        .phraseListCard(cornerRadius: 24, strokeOpacity: 0.05)
        .accessibilityIdentifier("Practice.City.\(mode.rawValue)")
    }

    private var symbolName: String {
        switch mode {
        case .hcmcCity:
            return "tram.fill"
        case .hanoiBucketList:
            return "leaf.fill"
        case .danangCity:
            return "water.waves"
        case .hoianCity:
            return "sparkles"
        case .hueCity:
            return "building.columns.fill"
        case .savedReview, .missedReview:
            return "mappin.and.ellipse"
        }
    }

    private var tint: AccentTint {
        switch mode {
        case .hcmcCity:
            return .red
        case .hanoiBucketList:
            return .green
        case .danangCity:
            return .blue
        case .hoianCity:
            return .orange
        case .hueCity:
            return .purple
        case .savedReview, .missedReview:
            return .red
        }
    }
}

private struct PracticeCityPathStrip: View {
    let deck: PracticeDeckSnapshot
    let onStart: (PracticeMode) -> Void

    private var secondaryModes: [PracticeMode] {
        PracticeMode.cityModes.filter { $0 != .hanoiBucketList }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Other city paths")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(secondaryModes) { mode in
                        PracticeCityPathChip(
                            mode: mode,
                            promptCount: deck.prompts(for: mode).count,
                            readyCount: deck.cityReadyCounts[mode] ?? 0,
                            onStart: { onStart(mode) }
                        )
                    }
                }
                .padding(.vertical, 1)
            }
        }
    }
}

private struct PracticeCityPathChip: View {
    let mode: PracticeMode
    let promptCount: Int
    let readyCount: Int
    let onStart: () -> Void

    var body: some View {
        Button(action: onStart) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    PracticeIcon(symbolName: symbolName, tint: tint, size: 34)

                    Text(mode.cityShortName ?? mode.title)
                        .font(.subheadline.weight(.black))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                }

                Text("\(promptCount) phrases")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                if readyCount > 0 {
                    Text("\(readyCount) ready")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(tint.color)
                }
            }
            .frame(width: 138, alignment: .leading)
            .padding(12)
            .background(.white.opacity(0.58), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(promptCount == 0)
        .opacity(promptCount == 0 ? 0.56 : 1)
        .accessibilityIdentifier("Practice.CityPath.\(mode.rawValue)")
    }

    private var symbolName: String {
        switch mode {
        case .hcmcCity:
            return "tram.fill"
        case .hanoiBucketList:
            return "leaf.fill"
        case .danangCity:
            return "water.waves"
        case .hoianCity:
            return "sparkles"
        case .hueCity:
            return "building.columns.fill"
        case .savedReview, .missedReview:
            return "mappin.and.ellipse"
        }
    }

    private var tint: AccentTint {
        switch mode {
        case .hcmcCity:
            return .red
        case .hanoiBucketList:
            return .green
        case .danangCity:
            return .blue
        case .hoianCity:
            return .orange
        case .hueCity:
            return .purple
        case .savedReview, .missedReview:
            return .red
        }
    }
}

private struct PracticeReviewModeRow: View {
    let mode: PracticeMode
    let count: Int
    let contextCount: Int
    let isEnabled: Bool
    let onStart: () -> Void

    var body: some View {
        Button(action: onStart) {
            HStack(spacing: 14) {
                PracticeIcon(
                    symbolName: mode == .savedReview ? "heart.fill" : "arrow.counterclockwise.circle.fill",
                    tint: mode == .savedReview ? .red : .orange
                )

                VStack(alignment: .leading, spacing: 5) {
                    Text(mode.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .layoutPriority(1)

                Text("\(count)")
                    .font(.headline.weight(.black))
                    .foregroundStyle(isEnabled ? .red : .secondary)
                    .frame(width: 42, height: 42)
                    .nativeGlass(cornerRadius: 21)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .phraseListCard(cornerRadius: 22)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.64)
    }

    private var subtitle: String {
        if mode.isCityMode {
            return mode.subtitle
        }

        switch mode {
        case .savedReview:
            return contextCount == 0
                ? "Save phrase pages first, then keep them here."
                : "\(contextCount) saved page\(contextCount == 1 ? "" : "s") ready to revisit."
        case .missedReview:
            return count == 0
                ? "Phrases worth repeating will collect here after a scene."
                : "Revisit \(count) phrase\(count == 1 ? "" : "s") without pressure."
        case .hcmcCity, .hanoiBucketList, .danangCity, .hoianCity, .hueCity:
            return mode.subtitle
        }
    }
}

private struct PracticeBrowseCard: View {
    let onBrowseTapped: () -> Void

    var body: some View {
        Button(action: onBrowseTapped) {
            HStack(spacing: 14) {
                PracticeIcon(symbolName: "plus.circle.fill", tint: .blue)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Add from a phrase screen")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Save useful phrases as you browse so Practice is ready when you need it.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .layoutPriority(1)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .phraseListCard(cornerRadius: 22)
        }
        .buttonStyle(.plain)
    }
}

private struct PracticeSessionSurface: View {
    let session: PracticeSession
    let prompt: PracticePrompt
    let selectedOptionID: String?
    let isInPracticePool: Bool
    let onSelectOption: (PracticeAnswerOption) -> Void
    let onContinue: () -> Void
    let onOpenSource: () -> Void
    let onTogglePractice: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text(session.context == .placement ? "PLACEMENT" : prompt.mode.title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(session.context == .placement ? "Phrase pace check" : prompt.kind.title)
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)
            }

            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .top, spacing: 14) {
                    PracticeIcon(symbolName: prompt.candidate.symbolName, tint: prompt.candidate.tintName)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Phrase \(session.currentIndex + 1) of \(session.prompts.count)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)

                        Text(prompt.instruction)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.primary)
                    }
                    .layoutPriority(1)

                    if let audioKey = prompt.audioKey {
                        AudioSpeakerButton(tint: prompt.candidate.tintName, size: 46, audioKey: audioKey)
                    }
                }

                Text(prompt.promptText)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(4)
                    .minimumScaleFactor(0.62)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let cityContext = prompt.source.cityContextLabel {
                    Label(cityContext, systemImage: "mappin.and.ellipse")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                VStack(spacing: 10) {
                    ForEach(prompt.options) { option in
                        PracticeAnswerOptionButton(
                            option: option,
                            isSelected: selectedOptionID == option.id,
                            hasAnswered: selectedOptionID != nil,
                            onSelect: { onSelectOption(option) }
                        )
                    }
                }

                if let selectedOption = prompt.options.first(where: { $0.id == selectedOptionID }) {
                    PracticeFeedbackCard(
                        prompt: prompt,
                        selectedOption: selectedOption,
                        isInPracticePool: isInPracticePool,
                        onOpenSource: onOpenSource,
                        onTogglePractice: onTogglePractice
                    )
                }
            }
            .padding(18)
            .phraseListCard(cornerRadius: 24)
        }
        .accessibilityIdentifier("Practice.Session")
    }
}

private struct PracticeAnswerOptionButton: View {
    let option: PracticeAnswerOption
    let isSelected: Bool
    let hasAnswered: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: symbolName)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(symbolColor)
                    .frame(width: 34, height: 34)
                    .nativeGlass(cornerRadius: 17)

                VStack(alignment: .leading, spacing: 3) {
                    Text(option.text)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.76)

                    Text(option.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .layoutPriority(1)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(optionBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(optionStroke, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(hasAnswered)
        .accessibilityIdentifier(option.isCorrect ? "Practice.Option.Recommended" : "Practice.Option.Alternative")
    }

    private var symbolName: String {
        guard hasAnswered else {
            return "circle"
        }

        if option.isCorrect {
            return "checkmark.circle.fill"
        }

        return isSelected ? "xmark.circle.fill" : "circle"
    }

    private var symbolColor: Color {
        guard hasAnswered else {
            return .secondary
        }

        if option.isCorrect {
            return .green
        }

        return isSelected ? .red : .secondary
    }

    private var optionBackground: Color {
        guard hasAnswered else {
            return .white.opacity(0.58)
        }

        if option.isCorrect {
            return .green.opacity(0.12)
        }

        return isSelected ? .red.opacity(0.10) : .white.opacity(0.44)
    }

    private var optionStroke: Color {
        guard hasAnswered else {
            return Color.black.opacity(0.05)
        }

        if option.isCorrect {
            return .green.opacity(0.32)
        }

        return isSelected ? .red.opacity(0.28) : Color.black.opacity(0.05)
    }
}

private struct PracticeFeedbackCard: View {
    let prompt: PracticePrompt
    let selectedOption: PracticeAnswerOption
    let isInPracticePool: Bool
    let onOpenSource: () -> Void
    let onTogglePractice: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: selectedOption.isCorrect ? "checkmark.seal.fill" : "arrow.counterclockwise.circle.fill")
                .font(.headline.weight(.bold))
                .foregroundStyle(selectedOption.isCorrect ? .green : .red)

            Text(prompt.answerExplanation)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 10) {
                Button(action: onOpenSource) {
                    Label("Phrase page", systemImage: "doc.text.magnifyingglass")
                        .font(.subheadline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.red)
                .nativeGlass(cornerRadius: 18, interactive: true)

                if isInPracticePool {
                    Button(action: onTogglePractice) {
                        Image(systemName: "minus.circle.fill")
                            .font(.headline.weight(.bold))
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .nativeGlass(cornerRadius: 18, interactive: true)
                    .accessibilityLabel("Remove from practice")
                }
            }
        }
        .padding(14)
        .background(.white.opacity(0.55), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var title: String {
        selectedOption.isCorrect ? "Nice. Keep that phrase close." : "Good catch. This one will come back."
    }
}

private struct PracticeFloatingContinueButton: View {
    let title: String
    let onContinue: () -> Void

    var body: some View {
        Button(action: onContinue) {
            Label(title, systemImage: "arrow.right")
                .font(.headline.weight(.bold))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(Color.red, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .red.opacity(0.22), radius: 18, x: 0, y: 8)
        .accessibilityIdentifier("Practice.ContinueButton")
    }
}

private struct PracticeCompletionSurface: View {
    let summary: PracticeCompletionSummary
    let onContinue: () -> Void
    let onMissedReview: () -> Void
    let onBrowseTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text(summary.context == .placement ? "PLACEMENT" : summary.mode.title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(summary.context == .placement ? "Placement check complete" : "Practice updated")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.74)
            }

            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 14) {
                    MeloCompanionMark(stage: summary.context == .placement ? .base : .completion, size: 78)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(summary.context == .placement ? "Melo found your starting pace" : "Melo saved the useful bits")
                            .font(.title3.weight(.black))
                            .foregroundStyle(.primary)

                        Text(rewardCopy)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                    }
                    .layoutPriority(1)
                }

                HStack(spacing: 10) {
                    PracticeMetricPill(title: "Practiced", value: "\(summary.practicedCount)")
                    PracticeMetricPill(title: "Kept", value: "\(summary.correctCount)")
                    PracticeMetricPill(title: "Ready", value: "\(summary.readyCount)")
                }

                Button(action: onContinue) {
                    Label("Back to Practice", systemImage: "text.bubble.fill")
                        .font(.headline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.white)
                .background(Color.red, in: RoundedRectangle(cornerRadius: 19, style: .continuous))

                if summary.missedCount > 0 {
                    Button(action: onMissedReview) {
                        Label("Practice again", systemImage: "arrow.counterclockwise.circle.fill")
                            .font(.headline.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.red)
                    .nativeGlass(cornerRadius: 18, interactive: true)
                } else {
                    Button(action: onBrowseTapped) {
                        Label("Add another phrase", systemImage: "plus.circle.fill")
                            .font(.headline.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.red)
                    .nativeGlass(cornerRadius: 18, interactive: true)
                }
            }
            .padding(18)
            .phraseListCard(cornerRadius: 24)
        }
        .accessibilityIdentifier("Practice.Completion")
    }

    private var rewardCopy: String {
        if summary.context == .placement {
            return "This short check uses real Vietnamese phrases so onboarding can pace Practice without hiding the phrasebook."
        }

        if summary.readyCount > 0 {
            return "A phrase reached ready status. The mascot hook can later show Melo picking up a small Vietnam accent."
        }

        if summary.missedCount > 0 {
            return "Phrases worth repeating are saved privately so you can try them again without pressure."
        }

        return "Repeated phrases build quiet readiness. Two clean passes marks a phrase ready."
    }
}

private struct PracticeLoadingCard: View {
    var body: some View {
        HStack(spacing: 14) {
            ProgressView()
                .tint(.red)

            Text("Preparing phrase-sourced practice...")
                .font(.headline.weight(.bold))
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .phraseListCard(cornerRadius: 22)
    }
}

private struct PracticeErrorCard: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Practice data is unavailable", systemImage: "exclamationmark.triangle.fill")
                .font(.headline.weight(.bold))
                .foregroundStyle(.orange)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button("Retry", action: onRetry)
                .font(.headline.weight(.bold))
                .foregroundStyle(.red)
        }
        .padding(18)
        .phraseListCard(cornerRadius: 22)
    }
}

private struct PracticeIcon: View {
    let symbolName: String
    let tint: AccentTint
    var size: CGFloat = 46

    var body: some View {
        Image(systemName: symbolName)
            .font(.headline.weight(.semibold))
            .foregroundStyle(tint.color)
            .frame(width: size, height: size)
            .nativeGlass(cornerRadius: size / 2, tint: tint.color, interactive: true)
    }
}

private struct PracticeMetricPill: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.headline.weight(.black))
                .foregroundStyle(.primary)

            Text(title)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.78)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 54)
        .background(.white.opacity(0.52), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private enum MeloCompanionStage {
    case base
    case jade
    case completion

    var imageName: String {
        switch self {
        case .base:
            return "melo-base-traveler"
        case .jade:
            return "melo-early-vietnam-jade"
        case .completion:
            return "melo-completion-lantern"
        }
    }
}

private struct MeloCompanionMark: View {
    let stage: MeloCompanionStage
    var size: CGFloat = 58

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MeloBundleImage(imageName: stage.imageName, size: size)

            Circle()
                .fill(Color.yellow)
                .frame(width: max(size * 0.13, 7), height: max(size * 0.13, 7))
                .overlay {
                    Circle()
                        .stroke(Color.red.opacity(0.28), lineWidth: 1)
                }
        }
        .frame(width: size, height: size)
        .nativeGlass(cornerRadius: size / 2, tint: Color.red, interactive: false)
        .accessibilityLabel("Melo companion")
    }
}

private struct MeloBundleImage: View {
    let imageName: String
    let size: CGFloat

    var body: some View {
        Group {
            if let image = Self.image(named: imageName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                fallbackMark
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(.white.opacity(0.72), lineWidth: 1)
        }
    }

    private var fallbackMark: some View {
        ZStack {
            Circle()
                .fill(Color.red.opacity(0.12))

            Text("M")
                .font(.system(size: max(size * 0.42, 20), weight: .black, design: .rounded))
                .foregroundStyle(.red)
        }
    }

    private static func image(named imageName: String) -> UIImage? {
        guard let url = Bundle.main.url(forResource: imageName, withExtension: "png") else {
            return nil
        }

        return UIImage(contentsOfFile: url.path)
    }
}

private enum PracticeLayout {
    static let horizontalPadding: CGFloat = 20
    static let floatingContinueBottomPadding: CGFloat = 92
}

#Preview {
    PracticeView(
        intentStore: LocalUserIntentStore(),
        onOpenDetail: { _ in },
        onBrowseTapped: {}
    )
}
