import SwiftUI
import UIKit

struct PracticeView: View {
    @ObservedObject var intentStore: LocalUserIntentStore
    @StateObject private var progressStore: LocalPracticeProgressStore
    @StateObject private var messageStore: LocalPracticeMessageStore

    let initialMode: PracticeMode?
    let entryContext: PracticeEntryContext
    let startRequest: PracticeStartRequest?
    let isActive: Bool
    let scrollToTopTrigger: Int
    var onOpenDetail: (String) -> Void
    var onBrowseTapped: () -> Void
    var onThreadBackToOrigin: () -> Void
    var onThreadPresentationChanged: (Bool) -> Void

    @State private var deckState = PracticeDeckLoadState.loading
    @State private var activeSession: PracticeSession?
    @State private var completionSummary: PracticeCompletionSummary?
    @State private var scenarioState = PracticeScenarioLoadState.loading
    @State private var activeScenarioSession: PracticeScenarioSession?
    @State private var scenarioCompletion: PracticeScenarioCompletionSummary?
    @State private var isScenarioThreadPresented = false
    @State private var activeScenarioThreadDismissal = PracticeScenarioThreadDismissal.messagesHub
    @State private var pendingScenarioReturnID: PracticeScenarioID?
    @State private var didStartInitialMode = false
    @State private var handledStartRequestID: Int?
    @State private var deckLoadGeneration = 0
    @State private var scenarioLoadGeneration = 0
    @State private var practiceScrollResetTrigger = 0
    @State private var practiceScrollTargetID: String?
    @State private var unreadScenarioIDs = Set(PracticeScenarioID.allCases)

    init(
        intentStore: LocalUserIntentStore,
        initialMode: PracticeMode? = nil,
        entryContext: PracticeEntryContext = .standard,
        startRequest: PracticeStartRequest? = nil,
        isActive: Bool = true,
        scrollToTopTrigger: Int = 0,
        progressStore: LocalPracticeProgressStore = LocalPracticeProgressStore(),
        messageStore: LocalPracticeMessageStore = LocalPracticeMessageStore(),
        onOpenDetail: @escaping (String) -> Void,
        onBrowseTapped: @escaping () -> Void,
        onThreadBackToOrigin: @escaping () -> Void = {},
        onThreadPresentationChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self.intentStore = intentStore
        self.initialMode = initialMode
        self.entryContext = entryContext
        self.startRequest = startRequest
        self.isActive = isActive
        self.scrollToTopTrigger = scrollToTopTrigger
        self.onOpenDetail = onOpenDetail
        self.onBrowseTapped = onBrowseTapped
        self.onThreadBackToOrigin = onThreadBackToOrigin
        self.onThreadPresentationChanged = onThreadPresentationChanged
        _progressStore = StateObject(wrappedValue: progressStore)
        _messageStore = StateObject(wrappedValue: messageStore)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            PhrasePageStyle.pageBackground
                .ignoresSafeArea()

            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 18) {
                        PracticeCurrentScenarioSurface(
                            scenarioState: scenarioState,
                            unreadScenarioIDs: unreadScenarioIDs,
                            onStart: startScenario,
                            onMarkUnread: markScenarioUnread,
                            onBrowseTapped: onBrowseTapped,
                            onRetry: reloadScenarioSnapshot
                        )
                        .id(Self.scrollTopID)
                    }
                    .padding(.horizontal, PracticeLayout.horizontalPadding)
                    .padding(.top, topContentPadding)
                    .padding(.bottom, HomeLayout.bottomChromeContentClearance)
                }
                .onChange(of: scrollToTopTrigger) { _, _ in
                    scrollProxy.scrollTo(Self.scrollTopID, anchor: .top)
                }
                .onChange(of: practiceScrollResetTrigger) { _, _ in
                    let targetID = practiceScrollTargetID ?? Self.scrollTopID
                    let targetAnchor: UnitPoint = practiceScrollTargetID == nil ? .top : .center
                    withAnimation(.easeInOut(duration: 0.24)) {
                        scrollProxy.scrollTo(targetID, anchor: targetAnchor)
                    }
                    practiceScrollTargetID = nil
                }
                .accessibilityIdentifier("PracticeView")
            }

            if isScenarioThreadVisible {
                PracticeMessagesThreadHost(
                    activeScenarioSession: activeScenarioSession,
                    scenarioCompletion: scenarioCompletion,
                    isInPracticePool: isScenarioPageInPractice,
                    isSavedPhrasePage: isScenarioPageSaved,
                    onOpenPhrasePage: { pageID in
                        openScenarioPhrasePage(pageID)
                    },
                    onTogglePracticePage: toggleScenarioPracticePage,
                    onToggleSavedPhrasePage: toggleScenarioSavedPage,
                    onSelectScenarioOption: { option, step in
                        selectScenarioOption(option, for: step)
                    },
                    onPracticeAnother: startAnotherScenario,
                    onBackToPractice: dismissScenarioThread,
                    onBrowseTapped: {
                        dismissScenarioSheet()
                        onBrowseTapped()
                    },
                    onDismiss: dismissScenarioThread
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)
                .zIndex(20)
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
        .onChange(of: isScenarioThreadVisible) { _, isVisible in
            onThreadPresentationChanged(isVisible)
        }
    }

    private static let scrollTopID = "PracticeViewTop"
    private static let scenarioReplyRevealDelay: TimeInterval = 1.6
    private static let scenarioAdvanceDelayAfterReply: TimeInterval = 0.9
    private static let scenarioReturnPresentationDelay: TimeInterval = 0.85

    private var topContentPadding: CGFloat {
        40
    }

    private var isScenarioThreadVisible: Bool {
        isActive
            && isScenarioThreadPresented
            && (activeScenarioSession != nil || scenarioCompletion != nil)
    }

    private func startScenario(_ scenario: PracticeScenario) {
        presentScenarioThread(scenario)
    }

    private func startPrimaryScenario(context: PracticeEntryContext = .standard) {
        guard let scenario = scenarioState.snapshot?.starterScenario else {
            return
        }

        presentScenarioThread(scenario, context: context)
    }

    private func startAnotherScenario() {
        if let scenario = scenarioCompletion?.scenario {
            presentScenarioThread(
                scenario,
                context: scenarioCompletion?.context ?? .standard,
                reset: true,
                threadDismissal: activeScenarioThreadDismissal
            )
            return
        }

        startPrimaryScenario()
    }

    private func presentScenarioThread(
        _ scenario: PracticeScenario,
        context: PracticeEntryContext = .standard,
        reset: Bool = false,
        threadDismissal: PracticeScenarioThreadDismissal = .messagesHub
    ) {
        guard !scenario.steps.isEmpty else {
            return
        }

        unreadScenarioIDs.remove(scenario.id)
        activeScenarioThreadDismissal = threadDismissal

        if reset {
            messageStore.clear(scenario.id)
        }

        if !reset, let completion = messageStore.completion(for: scenario) {
            activeScenarioSession = nil
            scenarioCompletion = completion
            isScenarioThreadPresented = true
            return
        }

        if !reset, let restoredSession = messageStore.session(for: scenario) {
            activeScenarioSession = restoredSession
            scenarioCompletion = nil
            isScenarioThreadPresented = true
            resumePendingScenarioTimers(for: restoredSession)
            return
        }

        let session = PracticeScenarioSession(scenario: scenario, context: context)
        activeScenarioSession = session
        scenarioCompletion = nil
        isScenarioThreadPresented = true
        messageStore.save(session)
    }

    private func continueScenarioSession() {
        guard var session = activeScenarioSession else {
            return
        }

        if let currentStep = session.currentStep,
           session.selectedOptionIDs[currentStep.id] == nil {
            return
        }

        if let currentStep = session.currentStep,
           let selectedOption = session.selectedOption(for: currentStep),
           currentStep.hasLocalReply(after: selectedOption),
           !session.revealedReplyStepIDs.contains(currentStep.id) {
            return
        }

        if session.isOnLastStep {
            scenarioCompletion = PracticeScenarioCompletionSummary(
                scenario: session.scenario,
                context: session.context,
                practicedCount: session.scenario.steps.count
            )
            activeScenarioSession = nil
            messageStore.markComplete(session)
            reloadScenarioSnapshot()
            return
        }

        session.currentIndex += 1
        activeScenarioSession = session
        messageStore.save(session)
    }

    private func schedulePracticeScrollReset(targetID: String? = nil) {
        practiceScrollTargetID = targetID
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            practiceScrollResetTrigger += 1
        }
    }

    private func clearScenarioCompletion() {
        scenarioCompletion = nil
        reloadScenarioSnapshot()
    }

    private func dismissScenarioSheet() {
        isScenarioThreadPresented = false
        reloadScenarioSnapshot()
    }

    private func dismissScenarioThread() {
        switch activeScenarioThreadDismissal {
        case .messagesHub:
            dismissScenarioSheet()
        case .originRoute:
            isScenarioThreadPresented = false
            activeScenarioThreadDismissal = .messagesHub
            reloadScenarioSnapshot()
            onThreadBackToOrigin()
        }
    }

    private func isScenarioPageInPractice(_ pageID: String) -> Bool {
        intentStore.isPageInPractice(pageID)
    }

    private func isScenarioPageSaved(_ pageID: String) -> Bool {
        intentStore.isPageSaved(pageID)
    }

    private func openScenarioPhrasePage(_ pageID: String) {
        pendingScenarioReturnID = activeScenarioSession?.scenario.id ?? scenarioCompletion?.scenario.id
        isScenarioThreadPresented = false
        onOpenDetail(pageID)
    }

    private func toggleScenarioPracticePage(_ pageID: String) {
        intentStore.togglePracticePage(pageID)
        reloadScenarioSnapshot()
    }

    private func toggleScenarioSavedPage(_ pageID: String) {
        intentStore.toggleSavedPage(pageID)
        reloadScenarioSnapshot()
    }

    private func markScenarioUnread(_ scenarioID: PracticeScenarioID) {
        unreadScenarioIDs.insert(scenarioID)
    }

    private func selectScenarioOption(_ option: PracticeScenarioResponseOption, for step: PracticeScenarioStep) {
        guard var session = activeScenarioSession else {
            return
        }

        session.selectedOptionIDs[step.id] = option.id
        activeScenarioSession = session
        messageStore.save(session)
        scheduleScenarioAdvanceAfterSend(stepID: step.id)
    }

    private func scheduleScenarioAdvanceAfterSend(stepID: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.scenarioReplyRevealDelay) {
            guard
                var session = activeScenarioSession,
                session.currentStep?.id == stepID,
                session.selectedOptionIDs[stepID] != nil
            else {
                return
            }

            session.revealedReplyStepIDs.insert(stepID)
            activeScenarioSession = session
            messageStore.save(session)
            scheduleScenarioAdvanceAfterReply(stepID: stepID)
        }
    }

    private func scheduleScenarioAdvanceAfterReply(stepID: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.scenarioAdvanceDelayAfterReply) {
            guard
                let session = activeScenarioSession,
                session.currentStep?.id == stepID,
                session.selectedOptionIDs[stepID] != nil,
                session.revealedReplyStepIDs.contains(stepID)
            else {
                return
            }

            continueScenarioSession()
        }
    }

    private func resumePendingScenarioTimers(for session: PracticeScenarioSession) {
        guard
            let currentStep = session.currentStep,
            session.selectedOptionIDs[currentStep.id] != nil
        else {
            return
        }

        if session.revealedReplyStepIDs.contains(currentStep.id) {
            scheduleScenarioAdvanceAfterReply(stepID: currentStep.id)
        } else {
            scheduleScenarioAdvanceAfterSend(stepID: currentStep.id)
        }
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
                    restorePendingScenarioThreadIfReady()
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
        guard pendingScenarioReturnID == nil else {
            return
        }

        guard
            let startRequest,
            handledStartRequestID != startRequest.id,
            isActive,
            let snapshot = scenarioState.snapshot
        else {
            return
        }

        handledStartRequestID = startRequest.id
        if let scenarioID = startRequest.scenarioID,
           let scenario = snapshot.scenarios.first(where: { $0.id == scenarioID }) {
            presentScenarioThread(
                scenario,
                threadDismissal: startRequest.scenarioThreadDismissal
            )
            return
        }

        startPrimaryScenario()
    }

    private func restorePendingScenarioThreadIfReady() {
        guard
            isActive,
            let pendingScenarioReturnID,
            let scenario = scenarioState.snapshot?.scenarios.first(where: { $0.id == pendingScenarioReturnID })
        else {
            return
        }

        self.pendingScenarioReturnID = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.scenarioReturnPresentationDelay) {
            guard isActive else {
                self.pendingScenarioReturnID = scenario.id
                return
            }

            presentScenarioThread(scenario, threadDismissal: activeScenarioThreadDismissal)
        }
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

struct PracticeScenarioSession: Equatable {
    let scenario: PracticeScenario
    var context: PracticeEntryContext = .standard
    var currentIndex = 0
    var selectedOptionIDs: [String: String] = [:]
    var revealedReplyStepIDs: Set<String> = []

    var currentStep: PracticeScenarioStep? {
        guard scenario.steps.indices.contains(currentIndex) else {
            return nil
        }

        return scenario.steps[currentIndex]
    }

    var isOnLastStep: Bool {
        currentIndex >= scenario.steps.count - 1
    }

    func selectedOption(for step: PracticeScenarioStep) -> PracticeScenarioResponseOption? {
        guard let selectedOptionID = selectedOptionIDs[step.id] else {
            return nil
        }

        return step.responseOptions.first { $0.id == selectedOptionID }
    }
}

struct PracticeScenarioCompletionSummary: Equatable {
    let scenario: PracticeScenario
    let context: PracticeEntryContext
    let practicedCount: Int
}

private struct PracticeScenarioThreadRecord: Codable, Equatable {
    let scenarioID: PracticeScenarioID
    var context: PracticeEntryContext
    var currentIndex: Int
    var selectedOptionIDs: [String: String]
    var revealedReplyStepIDs: [String]
    var isComplete: Bool

    init(session: PracticeScenarioSession, isComplete: Bool = false) {
        scenarioID = session.scenario.id
        context = session.context
        currentIndex = session.currentIndex
        selectedOptionIDs = session.selectedOptionIDs
        revealedReplyStepIDs = session.revealedReplyStepIDs.sorted()
        self.isComplete = isComplete
    }

    func session(for scenario: PracticeScenario) -> PracticeScenarioSession? {
        guard !isComplete, scenario.id == scenarioID, !scenario.steps.isEmpty else {
            return nil
        }

        let optionIDsByStepID = Dictionary(
            uniqueKeysWithValues: scenario.steps.map { step in
                (step.id, Set(step.responseOptions.map(\.id)))
            }
        )
        let filteredSelectedOptionIDs = selectedOptionIDs.filter { stepID, optionID in
            optionIDsByStepID[stepID]?.contains(optionID) == true
        }
        let filteredRevealedReplyStepIDs = Set(revealedReplyStepIDs.filter { stepID in
            filteredSelectedOptionIDs[stepID] != nil
        })
        let lastStepIndex = max(scenario.steps.count - 1, 0)
        let clampedIndex = min(max(currentIndex, 0), lastStepIndex)

        return PracticeScenarioSession(
            scenario: scenario,
            context: context,
            currentIndex: clampedIndex,
            selectedOptionIDs: filteredSelectedOptionIDs,
            revealedReplyStepIDs: filteredRevealedReplyStepIDs
        )
    }

    func completion(for scenario: PracticeScenario) -> PracticeScenarioCompletionSummary? {
        guard isComplete, scenario.id == scenarioID else {
            return nil
        }

        return PracticeScenarioCompletionSummary(
            scenario: scenario,
            context: context,
            practicedCount: scenario.steps.count
        )
    }
}

final class LocalPracticeMessageStore: ObservableObject {
    private var recordsByScenarioID: [PracticeScenarioID: PracticeScenarioThreadRecord]

    private let defaults: UserDefaults
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private enum Key {
        static let threads = "SpeakLocal.Practice.messageThreads.v1"
    }

    init(defaults: UserDefaults = .standard, launchArguments: [String] = ProcessInfo.processInfo.arguments) {
        self.defaults = defaults

#if DEBUG
        if launchArguments.contains("--reset-practice-message-threads") {
            defaults.removeObject(forKey: Key.threads)
        }
#endif

        recordsByScenarioID = Self.loadRecords(defaults: defaults)
    }

    func session(for scenario: PracticeScenario) -> PracticeScenarioSession? {
        recordsByScenarioID[scenario.id]?.session(for: scenario)
    }

    func completion(for scenario: PracticeScenario) -> PracticeScenarioCompletionSummary? {
        recordsByScenarioID[scenario.id]?.completion(for: scenario)
    }

    func save(_ session: PracticeScenarioSession) {
        recordsByScenarioID[session.scenario.id] = PracticeScenarioThreadRecord(session: session)
        persist()
    }

    @discardableResult
    func markComplete(_ session: PracticeScenarioSession) -> PracticeScenarioCompletionSummary {
        let record = PracticeScenarioThreadRecord(session: session, isComplete: true)
        recordsByScenarioID[session.scenario.id] = record
        persist()

        return record.completion(for: session.scenario) ?? PracticeScenarioCompletionSummary(
            scenario: session.scenario,
            context: session.context,
            practicedCount: session.scenario.steps.count
        )
    }

    func clear(_ scenarioID: PracticeScenarioID) {
        recordsByScenarioID.removeValue(forKey: scenarioID)
        persist()
    }

    private func persist() {
        let records = recordsByScenarioID.values.sorted { lhs, rhs in
            lhs.scenarioID.rawValue < rhs.scenarioID.rawValue
        }

        guard let data = try? encoder.encode(records) else {
            return
        }

        defaults.set(data, forKey: Key.threads)
    }

    private static func loadRecords(defaults: UserDefaults) -> [PracticeScenarioID: PracticeScenarioThreadRecord] {
        guard let data = defaults.data(forKey: Key.threads),
              let records = try? JSONDecoder().decode([PracticeScenarioThreadRecord].self, from: data)
        else {
            return [:]
        }

        return Dictionary(uniqueKeysWithValues: records.map { ($0.scenarioID, $0) })
    }
}

private struct PracticeCurrentScenarioSurface: View {
    let scenarioState: PracticeScenarioLoadState
    let unreadScenarioIDs: Set<PracticeScenarioID>
    let onStart: (PracticeScenario) -> Void
    let onMarkUnread: (PracticeScenarioID) -> Void
    let onBrowseTapped: () -> Void
    let onRetry: () -> Void

    var body: some View {
        PracticeMessagesHubSurface(
            state: scenarioState,
            unreadScenarioIDs: unreadScenarioIDs,
            onStart: onStart,
            onMarkUnread: onMarkUnread,
            onBrowseTapped: onBrowseTapped,
            onRetry: onRetry
        )
    }
}

private struct PracticeMessagesHubSurface: View {
    let state: PracticeScenarioLoadState
    let unreadScenarioIDs: Set<PracticeScenarioID>
    let onStart: (PracticeScenario) -> Void
    let onMarkUnread: (PracticeScenarioID) -> Void
    let onBrowseTapped: () -> Void
    let onRetry: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            PracticeMessagesHeader()

            switch state {
            case .loading:
                PracticeLoadingCard()
            case .failed(let message):
                PracticeErrorCard(message: message, onRetry: onRetry)
            case .loaded(let snapshot):
                PracticeMessageContactGrid(
                    scenarios: snapshot.scenarios,
                    unreadScenarioIDs: unreadScenarioIDs,
                    onMarkUnread: onMarkUnread,
                    onStart: onStart
                )
            }
        }
    }
}

private struct PracticeMessagesHeader: View {
    var body: some View {
        Text("Messages")
            .font(.system(size: 32, weight: .bold))
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
        .accessibilityIdentifier("Practice.Messages.Header")
    }
}

private struct PracticeMessageContactGrid: View {
    let scenarios: [PracticeScenario]
    let unreadScenarioIDs: Set<PracticeScenarioID>
    let onMarkUnread: (PracticeScenarioID) -> Void
    let onStart: (PracticeScenario) -> Void

    private struct Section: Identifiable {
        let title: String
        let scenarios: [PracticeScenario]

        var id: String { title }
    }

    private var sections: [Section] {
        let grouped = Dictionary(grouping: scenarios) { $0.id.messageSectionTitle }

        return PracticeScenarioID.messageSectionTitles
            .compactMap { title -> Section? in
                guard let scenarios = grouped[title], !scenarios.isEmpty else {
                    return nil
                }

                return Section(
                    title: title,
                    scenarios: scenarios.sorted {
                        scenarioSortRank($0) < scenarioSortRank($1)
                    }
                )
            }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ForEach(sections) { section in
                VStack(alignment: .leading, spacing: 16) {
                    Text(section.title)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.primary)
                        .accessibilityIdentifier("Practice.Messages.Section.\(section.id)")

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 16) {
                            ForEach(section.scenarios) { scenario in
                                PracticeMessageContactButton(
                                    scenario: scenario,
                                    isUnread: unreadScenarioIDs.contains(scenario.id),
                                    onMarkUnread: { onMarkUnread(scenario.id) },
                                    onStart: { onStart(scenario) }
                                )
                                .frame(width: 102)
                            }
                        }
                        .padding(.horizontal, 1)
                    }
                    .accessibilityIdentifier("Practice.Messages.SectionRow.\(section.id)")
                }
            }
        }
        .padding(.top, 8)
        .accessibilityIdentifier("Practice.Messages.Contacts")
    }

    private func scenarioSortRank(_ scenario: PracticeScenario) -> Int {
        scenario.id.messageContactSortRank * 100 + (scenarios.firstIndex { $0.id == scenario.id } ?? Int.max)
    }
}

private struct PracticeMessageContactButton: View {
    let scenario: PracticeScenario
    let isUnread: Bool
    let onMarkUnread: () -> Void
    let onStart: () -> Void

    var body: some View {
        Button(action: onStart) {
            VStack(spacing: 10) {
                PracticeMessageAvatar(
                    scenarioID: scenario.id,
                    size: 88,
                    showsSymbol: true
                )
                .overlay(alignment: .topTrailing) {
                    if isUnread {
                        Circle()
                            .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                            .frame(width: 9, height: 9)
                            .overlay {
                                Circle()
                                    .stroke(.white, lineWidth: 2)
                            }
                            .offset(x: -6, y: 6)
                            .accessibilityLabel("Unread")
                            .accessibilityIdentifier("Practice.Message.Contact.UnreadDot.\(scenario.id.rawValue)")
                    }
                }

                Text(scenario.id.messageContactName)
                    .font(.system(size: 16, weight: isUnread ? .bold : .semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)
                    .frame(maxWidth: .infinity, minHeight: 40, alignment: .top)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(action: onMarkUnread) {
                Label("Mark Unread", systemImage: "circle.fill")
            }
        }
        .accessibilityLabel(scenario.id.messageContactName)
        .accessibilityIdentifier("Practice.Message.Contact.\(scenario.id.rawValue)")
    }
}

struct PracticeMessageAvatar: View {
    let scenarioID: PracticeScenarioID
    var size: CGFloat
    var showsSymbol: Bool = true

    var body: some View {
        ZStack {
            PracticeMessageBadgeBackdrop(scenarioID: scenarioID, size: size)

            if showsSymbol {
                Image(systemName: scenarioID.messageAvatarSymbolName)
                    .font(.system(size: size * scenarioID.messageBadgeIconScale, weight: .heavy))
                    .foregroundStyle(
                        .white,
                        .white.opacity(0.86)
                    )
                    .shadow(color: .black.opacity(0.22), radius: size * 0.05, x: 0, y: size * 0.035)
            } else {
                Text(scenarioID.messageInitials)
                    .font(.system(size: size * 0.36, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay {
            Circle()
                .strokeBorder(.white.opacity(0.92), lineWidth: max(1, size * 0.018))
        }
        .overlay {
            Circle()
                .strokeBorder(.black.opacity(0.05), lineWidth: 0.5)
        }
        .shadow(color: scenarioID.messageBadgeOverlayColor.opacity(0.18), radius: size * 0.16, x: 0, y: size * 0.08)
        .accessibilityHidden(true)
    }
}

private struct PracticeMessageBadgeBackdrop: View {
    let scenarioID: PracticeScenarioID
    let size: CGFloat

    var body: some View {
        ZStack {
            Image(scenarioID.messageBadgeBackgroundImageName)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .scaleEffect(scenarioID.messageBadgeImageScale)
                .offset(
                    x: scenarioID.messageBadgeImageOffset.width * size,
                    y: scenarioID.messageBadgeImageOffset.height * size
                )
                .saturation(0.95)
                .contrast(1.05)

            scenarioID.messageBadgeOverlayColor
                .opacity(0.36)
                .blendMode(.multiply)

            LinearGradient(
                colors: [
                    .white.opacity(0.2),
                    .white.opacity(0.02),
                    .black.opacity(0.18),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            LinearGradient(
                colors: [
                    .white.opacity(0.14),
                    .clear,
                ],
                startPoint: .top,
                endPoint: .center
            )
        }
        .frame(width: size, height: size)
        .clipped()
    }
}

private struct PracticeMessageBadgeBaseScene: View {
    let kind: PracticeMessageBadgeSceneKind
    let size: CGFloat

    var body: some View {
        ZStack {
            switch kind {
            case .airport:
                airportScene
            case .passportDesk:
                passportDeskScene
            case .airportServices:
                airportServicesScene
            case .hotelLobby:
                hotelLobbyScene
            case .hotelRoom:
                hotelRoomScene
            case .luggageLobby:
                luggageLobbyScene
            case .restaurantTable:
                restaurantTableScene
            case .beachCafe:
                beachCafeScene
            case .allergyPlate:
                allergyPlateScene
            case .road:
                roadScene
            case .routeMap:
                routeMapScene
            case .market:
                marketScene
            case .giftShop:
                giftShopScene
            case .checkout:
                checkoutScene
            case .pharmacy:
                pharmacyScene
            case .emergencyDesk:
                emergencyDeskScene
            case .greeting:
                greetingScene
            }
        }
        .frame(width: size, height: size)
    }

    private var airportScene: some View {
        ZStack {
            sceneLine(width: 0.9, height: 0.012, y: -0.26)
            sceneLine(width: 0.82, height: 0.012, y: -0.03)
            sceneLine(width: 0.012, height: 0.72, x: -0.2, y: -0.12)
            sceneLine(width: 0.012, height: 0.72, x: 0.18, y: -0.12)
            sceneCapsule(width: 0.76, height: 0.09, y: 0.31, opacity: 0.18)
            sceneCapsule(width: 0.25, height: 0.06, x: -0.24, y: 0.17, opacity: 0.16)
            sceneCapsule(width: 0.25, height: 0.06, x: 0.18, y: 0.17, opacity: 0.16)
        }
    }

    private var passportDeskScene: some View {
        ZStack {
            sceneCapsule(width: 0.86, height: 0.12, y: 0.29, opacity: 0.2)
            sceneCapsule(width: 0.58, height: 0.055, y: -0.22, opacity: 0.18)
            sceneLine(width: 0.012, height: 0.42, x: -0.25, y: 0.03)
            sceneLine(width: 0.012, height: 0.42, x: 0.25, y: 0.03)
            sceneCapsule(width: 0.16, height: 0.04, x: -0.25, y: 0.14, opacity: 0.22)
            sceneCapsule(width: 0.16, height: 0.04, x: 0.25, y: 0.14, opacity: 0.22)
        }
    }

    private var airportServicesScene: some View {
        ZStack {
            sceneLine(width: 0.78, height: 0.012, y: -0.18)
            sceneLine(width: 0.78, height: 0.012, y: 0.21)
            RoundedRectangle(cornerRadius: size * 0.035, style: .continuous)
                .fill(.white.opacity(0.13))
                .frame(width: size * 0.23, height: size * 0.45)
                .offset(x: size * 0.25, y: size * 0.04)
            sceneCapsule(width: 0.19, height: 0.055, x: 0.25, y: -0.09, opacity: 0.22)
            sceneCapsule(width: 0.2, height: 0.26, x: -0.25, y: 0.03, opacity: 0.14)
        }
    }

    private var hotelLobbyScene: some View {
        ZStack {
            sceneCapsule(width: 0.82, height: 0.12, y: 0.29, opacity: 0.22)
            sceneCapsule(width: 0.46, height: 0.2, x: -0.11, y: 0.16, opacity: 0.14)
            sceneLine(width: 0.012, height: 0.38, x: 0.31, y: 0.04)
            sceneCapsule(width: 0.13, height: 0.05, x: 0.31, y: -0.14, opacity: 0.2)
            sceneLine(width: 0.012, height: 0.2, x: -0.34, y: 0.17)
            Circle()
                .fill(.white.opacity(0.16))
                .frame(width: size * 0.11, height: size * 0.11)
                .offset(x: -size * 0.34, y: size * 0.04)
        }
    }

    private var hotelRoomScene: some View {
        ZStack {
            sceneLine(width: 0.8, height: 0.012, y: -0.24)
            sceneLine(width: 0.012, height: 0.4, x: 0.22, y: -0.13)
            sceneCapsule(width: 0.62, height: 0.18, x: -0.08, y: 0.2, opacity: 0.18)
            sceneCapsule(width: 0.25, height: 0.08, x: -0.28, y: 0.09, opacity: 0.2)
            sceneLine(width: 0.012, height: 0.28, x: 0.33, y: 0.08)
            sceneCapsule(width: 0.16, height: 0.06, x: 0.33, y: -0.08, opacity: 0.2)
        }
    }

    private var luggageLobbyScene: some View {
        ZStack {
            sceneCapsule(width: 0.76, height: 0.12, y: 0.31, opacity: 0.2)
            RoundedRectangle(cornerRadius: size * 0.035, style: .continuous)
                .stroke(.white.opacity(0.17), lineWidth: size * 0.018)
                .frame(width: size * 0.4, height: size * 0.34)
                .offset(x: size * 0.11, y: size * 0.03)
            sceneLine(width: 0.012, height: 0.52, x: -0.24, y: -0.01)
            Circle()
                .stroke(.white.opacity(0.16), lineWidth: size * 0.018)
                .frame(width: size * 0.48, height: size * 0.48)
                .offset(x: size * 0.07, y: -size * 0.04)
        }
    }

    private var restaurantTableScene: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.16), lineWidth: size * 0.018)
                .frame(width: size * 0.48, height: size * 0.48)
                .offset(x: -size * 0.16, y: size * 0.08)
            Circle()
                .stroke(.white.opacity(0.13), lineWidth: size * 0.016)
                .frame(width: size * 0.3, height: size * 0.3)
                .offset(x: size * 0.2, y: size * 0.16)
            sceneLine(width: 0.78, height: 0.012, y: 0.33)
            sceneLine(width: 0.012, height: 0.46, x: 0.31, y: -0.03)
        }
    }

    private var beachCafeScene: some View {
        ZStack {
            sceneCapsule(width: 0.92, height: 0.08, y: 0.27, opacity: 0.18)
            sceneCapsule(width: 0.82, height: 0.065, y: 0.38, opacity: 0.14)
            sceneLine(width: 0.012, height: 0.6, x: -0.27, y: -0.04, degrees: -12)
            sceneCapsule(width: 0.28, height: 0.055, x: -0.18, y: -0.29, degrees: -26, opacity: 0.18)
            sceneCapsule(width: 0.28, height: 0.055, x: -0.37, y: -0.2, degrees: 26, opacity: 0.18)
            sceneCapsule(width: 0.24, height: 0.12, x: 0.22, y: 0.11, opacity: 0.16)
        }
    }

    private var allergyPlateScene: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.16), lineWidth: size * 0.02)
                .frame(width: size * 0.62, height: size * 0.62)
                .offset(x: size * 0.15, y: size * 0.11)
            sceneCapsule(width: 0.42, height: 0.11, x: 0.16, y: 0.14, degrees: 18, opacity: 0.16)
            sceneCapsule(width: 0.32, height: 0.08, x: -0.3, y: -0.1, degrees: -26, opacity: 0.18)
            sceneCapsule(width: 0.3, height: 0.08, x: -0.18, y: -0.25, degrees: 22, opacity: 0.16)
        }
    }

    private var roadScene: some View {
        ZStack {
            sceneLine(width: 0.012, height: 1.0, x: -0.12, y: 0.08, degrees: -18)
            sceneLine(width: 0.012, height: 1.0, x: 0.2, y: 0.08, degrees: -18)
            sceneCapsule(width: 0.16, height: 0.06, x: -0.07, y: -0.22, degrees: -18, opacity: 0.2)
            sceneCapsule(width: 0.18, height: 0.06, x: 0.04, y: 0.08, degrees: -18, opacity: 0.18)
            sceneCapsule(width: 0.2, height: 0.06, x: 0.15, y: 0.36, degrees: -18, opacity: 0.16)
        }
    }

    private var routeMapScene: some View {
        ZStack {
            sceneLine(width: 0.7, height: 0.018, x: -0.06, y: -0.12, degrees: -22)
            sceneLine(width: 0.56, height: 0.018, x: 0.11, y: 0.15, degrees: 28)
            Circle()
                .fill(.white.opacity(0.2))
                .frame(width: size * 0.1, height: size * 0.1)
                .offset(x: -size * 0.3, y: -size * 0.24)
            Circle()
                .fill(.white.opacity(0.18))
                .frame(width: size * 0.08, height: size * 0.08)
                .offset(x: size * 0.33, y: size * 0.27)
            sceneLine(width: 0.012, height: 0.92, x: 0.0, y: 0.0)
        }
    }

    private var marketScene: some View {
        ZStack {
            sceneCapsule(width: 0.78, height: 0.1, y: -0.2, opacity: 0.18)
            sceneLine(width: 0.012, height: 0.5, x: -0.34, y: 0.08)
            sceneLine(width: 0.012, height: 0.5, x: 0.34, y: 0.08)
            sceneCapsule(width: 0.86, height: 0.14, y: 0.31, opacity: 0.2)
            sceneCapsule(width: 0.2, height: 0.08, x: -0.17, y: 0.12, opacity: 0.16)
            sceneCapsule(width: 0.18, height: 0.08, x: 0.18, y: 0.11, opacity: 0.16)
        }
    }

    private var giftShopScene: some View {
        ZStack {
            sceneLine(width: 0.72, height: 0.012, y: -0.22)
            sceneLine(width: 0.72, height: 0.012, y: 0.03)
            sceneLine(width: 0.72, height: 0.012, y: 0.28)
            RoundedRectangle(cornerRadius: size * 0.035, style: .continuous)
                .stroke(.white.opacity(0.17), lineWidth: size * 0.018)
                .frame(width: size * 0.28, height: size * 0.25)
                .offset(x: -size * 0.21, y: size * 0.1)
            sceneCapsule(width: 0.24, height: 0.1, x: 0.23, y: -0.09, opacity: 0.16)
        }
    }

    private var checkoutScene: some View {
        ZStack {
            sceneCapsule(width: 0.84, height: 0.13, y: 0.31, opacity: 0.22)
            RoundedRectangle(cornerRadius: size * 0.025, style: .continuous)
                .fill(.white.opacity(0.13))
                .frame(width: size * 0.28, height: size * 0.38)
                .offset(x: -size * 0.22, y: -size * 0.02)
            sceneLine(width: 0.2, height: 0.012, x: -0.22, y: -0.12)
            sceneLine(width: 0.2, height: 0.012, x: -0.22, y: -0.02)
            sceneCapsule(width: 0.3, height: 0.09, x: 0.22, y: 0.08, opacity: 0.16)
        }
    }

    private var pharmacyScene: some View {
        ZStack {
            sceneLine(width: 0.72, height: 0.012, y: -0.21)
            sceneLine(width: 0.72, height: 0.012, y: 0.08)
            RoundedRectangle(cornerRadius: size * 0.035, style: .continuous)
                .fill(.white.opacity(0.13))
                .frame(width: size * 0.46, height: size * 0.34)
                .offset(x: -size * 0.05, y: size * 0.16)
            sceneLine(width: 0.26, height: 0.035, x: 0.22, y: -0.17)
            sceneLine(width: 0.035, height: 0.26, x: 0.22, y: -0.17)
        }
    }

    private var emergencyDeskScene: some View {
        ZStack {
            sceneCapsule(width: 0.84, height: 0.13, y: 0.31, opacity: 0.22)
            sceneLine(width: 0.72, height: 0.012, y: -0.23)
            RoundedRectangle(cornerRadius: size * 0.04, style: .continuous)
                .stroke(.white.opacity(0.17), lineWidth: size * 0.018)
                .frame(width: size * 0.34, height: size * 0.4)
                .offset(x: -size * 0.19, y: size * 0.02)
            sceneCapsule(width: 0.3, height: 0.09, x: 0.23, y: 0.07, opacity: 0.16)
        }
    }

    private var greetingScene: some View {
        ZStack {
            sceneCapsule(width: 0.8, height: 0.1, y: -0.2, opacity: 0.16)
            sceneCapsule(width: 0.82, height: 0.14, y: 0.31, opacity: 0.18)
            RoundedRectangle(cornerRadius: size * 0.04, style: .continuous)
                .stroke(.white.opacity(0.16), lineWidth: size * 0.018)
                .frame(width: size * 0.34, height: size * 0.28)
                .offset(x: -size * 0.2, y: size * 0.05)
            sceneCapsule(width: 0.25, height: 0.1, x: 0.26, y: -0.02, opacity: 0.16)
            Circle()
                .fill(.white.opacity(0.15))
                .frame(width: size * 0.09, height: size * 0.09)
                .offset(x: size * 0.1, y: size * 0.03)
        }
    }

    private func sceneLine(
        width: CGFloat,
        height: CGFloat,
        x: CGFloat = 0,
        y: CGFloat = 0,
        degrees: Double = 0,
        opacity: Double = 0.18
    ) -> some View {
        Capsule()
            .fill(.white.opacity(opacity))
            .frame(width: size * width, height: max(1, size * height))
            .rotationEffect(.degrees(degrees))
            .offset(x: size * x, y: size * y)
    }

    private func sceneCapsule(
        width: CGFloat,
        height: CGFloat,
        x: CGFloat = 0,
        y: CGFloat = 0,
        degrees: Double = 0,
        opacity: Double = 0.18
    ) -> some View {
        Capsule()
            .fill(.black.opacity(opacity))
            .frame(width: size * width, height: size * height)
            .rotationEffect(.degrees(degrees))
            .offset(x: size * x, y: size * y)
    }
}

private enum PracticeMessageBadgeSceneKind {
    case airport
    case passportDesk
    case airportServices
    case hotelLobby
    case hotelRoom
    case luggageLobby
    case restaurantTable
    case beachCafe
    case allergyPlate
    case road
    case routeMap
    case market
    case giftShop
    case checkout
    case pharmacy
    case emergencyDesk
    case greeting
}

private extension PracticeScenarioID {
    var messageBadgeBackgroundImageName: String {
        switch self {
        case .danangFirstDay:
            return "HeroCategoryAirport"
        case .airportPassportControl:
            return "HeroCategoryAirport"
        case .airportSimCash:
            return "HeroCategoryFirstDay"
        case .hotelCheckInHelp, .hotelBagsTaxi:
            return "HeroCategoryHotel"
        case .hotelRoomHelp:
            return "BrowseCollectionHotel"
        case .foodAllergyHelp:
            return "BrowseCollectionFood"
        case .restaurantOrderingPayment:
            return "HeroCategoryFood"
        case .danangDay:
            return "HeroVietnamMasthead"
        case .taxiGrabPickup, .taxiRouteHelp, .driverProblemHelp:
            return "HeroCategoryGettingAround"
        case .shoppingMarketPrice:
            return "BrowseCollectionShopping"
        case .shoppingSizeGift:
            return "HomeSituationFoodShopping"
        case .shoppingReceiptHelp:
            return "HeroCategoryNumbersMoney"
        case .pharmacyHelp, .emergencyLostPassport, .emergencyLostBag:
            return "HeroCategoryEmergency"
        case .localGreetingMarket, .localGreetingHotel, .localGreetingRespect:
            return "HeroCategoryGreetings"
        }
    }

    var messageBadgeOverlayColor: Color {
        switch self {
        case .danangFirstDay:
            return Color(red: 0.08, green: 0.38, blue: 0.74)
        case .airportPassportControl:
            return Color(red: 0.05, green: 0.45, blue: 0.78)
        case .airportSimCash:
            return Color(red: 0.05, green: 0.52, blue: 0.62)
        case .hotelCheckInHelp:
            return Color(red: 0.48, green: 0.31, blue: 0.76)
        case .hotelRoomHelp:
            return Color(red: 0.55, green: 0.36, blue: 0.78)
        case .hotelBagsTaxi:
            return Color(red: 0.38, green: 0.25, blue: 0.67)
        case .restaurantOrderingPayment:
            return Color(red: 0.08, green: 0.43, blue: 0.32)
        case .danangDay:
            return Color(red: 0.2, green: 0.63, blue: 0.58)
        case .foodAllergyHelp:
            return Color(red: 0.1, green: 0.52, blue: 0.35)
        case .taxiGrabPickup, .taxiRouteHelp, .driverProblemHelp:
            return Color(red: 0.7, green: 0.42, blue: 0.08)
        case .shoppingMarketPrice, .shoppingSizeGift, .shoppingReceiptHelp:
            return Color(red: 0.72, green: 0.42, blue: 0.08)
        case .pharmacyHelp, .emergencyLostPassport, .emergencyLostBag:
            return Color(red: 0.78, green: 0.12, blue: 0.16)
        case .localGreetingMarket, .localGreetingHotel, .localGreetingRespect:
            return Color(red: 0.06, green: 0.5, blue: 0.52)
        }
    }

    var messageBadgeImageScale: CGFloat {
        switch self {
        case .hotelRoomHelp, .foodAllergyHelp, .airportPassportControl, .shoppingMarketPrice:
            return 1.18
        case .shoppingSizeGift:
            return 1.08
        default:
            return 1
        }
    }

    var messageBadgeImageOffset: CGSize {
        switch self {
        case .danangFirstDay, .airportPassportControl:
            return CGSize(width: 0, height: 0.22)
        case .airportSimCash:
            return CGSize(width: 0, height: 0.18)
        case .hotelCheckInHelp, .hotelBagsTaxi:
            return CGSize(width: 0, height: 0.26)
        case .hotelRoomHelp:
            return CGSize(width: 0.08, height: 0)
        case .restaurantOrderingPayment:
            return CGSize(width: 0, height: 0.24)
        case .foodAllergyHelp:
            return CGSize(width: 0.08, height: 0)
        case .danangDay:
            return CGSize(width: -0.08, height: 0.24)
        case .taxiGrabPickup, .taxiRouteHelp, .driverProblemHelp:
            return CGSize(width: 0, height: 0.18)
        case .shoppingReceiptHelp, .pharmacyHelp, .emergencyLostPassport, .emergencyLostBag, .localGreetingMarket, .localGreetingHotel, .localGreetingRespect:
            return CGSize(width: 0, height: 0.2)
        default:
            return .zero
        }
    }

    var messageBadgeSceneKind: PracticeMessageBadgeSceneKind {
        switch self {
        case .danangFirstDay:
            return .airport
        case .airportPassportControl:
            return .passportDesk
        case .airportSimCash:
            return .airportServices
        case .hotelCheckInHelp:
            return .hotelLobby
        case .hotelRoomHelp:
            return .hotelRoom
        case .hotelBagsTaxi:
            return .luggageLobby
        case .restaurantOrderingPayment:
            return .restaurantTable
        case .danangDay:
            return .beachCafe
        case .foodAllergyHelp:
            return .allergyPlate
        case .taxiGrabPickup, .driverProblemHelp:
            return .road
        case .taxiRouteHelp:
            return .routeMap
        case .shoppingMarketPrice:
            return .market
        case .shoppingSizeGift:
            return .giftShop
        case .shoppingReceiptHelp:
            return .checkout
        case .pharmacyHelp:
            return .pharmacy
        case .emergencyLostPassport, .emergencyLostBag:
            return .emergencyDesk
        case .localGreetingMarket, .localGreetingHotel, .localGreetingRespect:
            return .greeting
        }
    }

    var messageBadgePalette: [Color] {
        switch self {
        case .danangFirstDay:
            return [Color(red: 0.22, green: 0.52, blue: 0.9), Color(red: 0.07, green: 0.28, blue: 0.58)]
        case .airportPassportControl:
            return [Color(red: 0.98, green: 0.3, blue: 0.34), Color(red: 0.62, green: 0.08, blue: 0.16)]
        case .airportSimCash:
            return [Color(red: 0.19, green: 0.62, blue: 0.52), Color(red: 0.05, green: 0.34, blue: 0.32)]
        case .hotelCheckInHelp, .hotelRoomHelp, .hotelBagsTaxi:
            return [Color(red: 0.62, green: 0.43, blue: 0.85), Color(red: 0.28, green: 0.17, blue: 0.55)]
        case .restaurantOrderingPayment:
            return [Color(red: 0.24, green: 0.58, blue: 0.44), Color(red: 0.08, green: 0.34, blue: 0.27)]
        case .danangDay:
            return [Color(red: 0.32, green: 0.72, blue: 0.66), Color(red: 0.14, green: 0.43, blue: 0.44)]
        case .foodAllergyHelp:
            return [Color(red: 0.22, green: 0.6, blue: 0.43), Color(red: 0.08, green: 0.34, blue: 0.28)]
        case .taxiGrabPickup, .taxiRouteHelp, .driverProblemHelp:
            return [Color(red: 0.88, green: 0.58, blue: 0.18), Color(red: 0.49, green: 0.28, blue: 0.07)]
        case .shoppingMarketPrice, .shoppingSizeGift, .shoppingReceiptHelp:
            return [Color(red: 0.88, green: 0.52, blue: 0.22), Color(red: 0.52, green: 0.23, blue: 0.08)]
        case .pharmacyHelp, .emergencyLostPassport, .emergencyLostBag:
            return [Color(red: 0.94, green: 0.22, blue: 0.25), Color(red: 0.55, green: 0.06, blue: 0.13)]
        case .localGreetingMarket, .localGreetingHotel, .localGreetingRespect:
            return [Color(red: 0.17, green: 0.62, blue: 0.62), Color(red: 0.07, green: 0.32, blue: 0.39)]
        }
    }

    var messageBadgeSceneLabel: String? {
        switch self {
        case .airportPassportControl:
            return "PASSPORT"
        case .airportSimCash:
            return "SIM"
        case .hotelCheckInHelp:
            return "HOTEL"
        case .shoppingMarketPrice:
            return "MARKET"
        case .pharmacyHelp:
            return "PHARMACY"
        default:
            return nil
        }
    }

    var messageBadgeBackdropSymbolName: String {
        switch self {
        case .danangFirstDay:
            return "airplane"
        case .airportPassportControl:
            return "person.text.rectangle"
        case .airportSimCash:
            return "creditcard.and.123"
        case .hotelCheckInHelp:
            return "building.2.fill"
        case .hotelRoomHelp:
            return "bed.double.fill"
        case .hotelBagsTaxi:
            return "cart.fill"
        case .restaurantOrderingPayment:
            return "wineglass.fill"
        case .danangDay:
            return "water.waves"
        case .foodAllergyHelp:
            return "fork.knife.circle"
        case .taxiGrabPickup:
            return "car.fill"
        case .taxiRouteHelp:
            return "point.topleft.down.curvedto.point.bottomright.up"
        case .driverProblemHelp:
            return "exclamationmark.triangle.fill"
        case .shoppingMarketPrice:
            return "storefront.fill"
        case .shoppingSizeGift:
            return "shippingbox.fill"
        case .shoppingReceiptHelp:
            return "creditcard.fill"
        case .pharmacyHelp:
            return "pills.fill"
        case .emergencyLostPassport:
            return "building.columns.fill"
        case .emergencyLostBag:
            return "camera.viewfinder"
        case .localGreetingMarket:
            return "bubble.left.and.bubble.right.fill"
        case .localGreetingHotel:
            return "door.left.hand.open"
        case .localGreetingRespect:
            return "person.2.fill"
        }
    }

    var messageBadgeBackdropRotation: Double {
        switch self {
        case .danangFirstDay:
            return -12
        case .taxiRouteHelp:
            return 9
        case .danangDay:
            return -4
        default:
            return 0
        }
    }

    var messageBadgeIconScale: CGFloat {
        switch self {
        case .restaurantOrderingPayment, .danangDay, .foodAllergyHelp:
            return 0.4
        case .airportPassportControl, .airportSimCash, .hotelCheckInHelp, .hotelBagsTaxi:
            return 0.38
        default:
            return 0.42
        }
    }

}

private struct PracticeScenarioPrimaryCard: View {
    let scenario: PracticeScenario
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 14) {
                PracticeIcon(symbolName: scenario.id.symbolName, tint: scenario.id.tint)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Start here")
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

            PracticeScenarioBeatRow(beats: scenario.id.flowBeats, tint: scenario.id.tint)

            Button(action: onStart) {
                Label("Open thread", systemImage: "text.bubble.fill")
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

private struct PracticeScenarioBeatRow: View {
    let beats: [String]
    let tint: AccentTint

    var body: some View {
        HStack(spacing: 10) {
            ForEach(beats, id: \.self) { beat in
                PracticeScenarioBeatChip(title: beat, tint: tint)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("Practice.Scenario.Beats")
    }
}

private struct PracticeScenarioBeatChip: View {
    let title: String
    let tint: AccentTint

    var body: some View {
        Text(title)
            .font(.caption.weight(.bold))
            .foregroundStyle(tint.color)
            .lineLimit(1)
            .minimumScaleFactor(0.72)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .padding(.horizontal, 8)
            .background(
                tint.color.opacity(0.09),
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(.white.opacity(0.72), lineWidth: 1)
            )
            .accessibilityIdentifier("Practice.Scenario.Beat.\(title)")
    }
}

private struct PracticeScenarioModeList: View {
    let scenarios: [PracticeScenario]
    let onStart: (PracticeScenario) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Messages")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.secondary)

            VStack(spacing: 10) {
                ForEach(scenarios) { scenario in
                    Button {
                        onStart(scenario)
                    } label: {
                        PracticeScenarioModeRow(scenario: scenario)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(scenario.id.title)
                    .accessibilityIdentifier("Practice.Scenario.\(scenario.id.rawValue)")
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

                Text(scenario.sceneSetup)
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
        .frame(maxWidth: .infinity, minHeight: 86, alignment: .leading)
        .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .phraseListCard(cornerRadius: 22)
    }
}

private struct PracticeScenarioHowBuiltCard: View {
    let snapshot: PracticeScenarioDeckSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How stories help")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 0) {
                    PracticeBuildSourceColumn(
                        symbolName: "bookmark.fill",
                        tint: .blue,
                        title: "Useful phrases",
                        subtitle: "Short lines you can hear and save."
                    )

                    PracticeBuildDivider()

                    PracticeBuildSourceColumn(
                        symbolName: "clock.fill",
                        tint: .green,
                        title: "Trip context",
                        subtitle: "Stories keep the next reply clear."
                    )

                    PracticeBuildDivider()

                    PracticeBuildSourceColumn(
                        symbolName: "text.bubble.fill",
                        tint: .purple,
                        title: "Follow-ups",
                        subtitle: "Small backups when things shift."
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
        return "\(savedCount) saved, \(recentCount) recent, and \(starterCount) starter phrases can shape short, useful travel stories."
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

            Text("\(seedCount) real \(mode.cityShortName ?? "city") phrases can start this path. Saved phrases stay first.")
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
                ? "Save phrases first, then keep them here."
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

private struct PracticeScenarioStickyActionBar: View {
    let title: String
    let onContinue: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onContinue) {
                Label(title, systemImage: title == "Finish story" ? "checkmark" : "arrow.down")
                    .font(.headline.weight(.bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .background(Color.red, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .red.opacity(0.16), radius: 12, x: 0, y: 6)
            .accessibilityIdentifier("Practice.ContinueButton")
        }
        .padding(8)
        .nativeGlass(cornerRadius: 28, interactive: true)
        .accessibilityIdentifier("Practice.Story.ActionBar")
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
    static let storyComposerBottomPadding: CGFloat = 104
}

#Preview {
    PracticeView(
        intentStore: LocalUserIntentStore(),
        onOpenDetail: { _ in },
        onBrowseTapped: {}
    )
}
