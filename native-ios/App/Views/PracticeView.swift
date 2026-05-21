import SwiftUI
import UIKit

enum PracticePresentationStyle: Equatable {
    case route
    case pullUpOverlay
}

enum PracticeMatchSnapshotLoadPolicy {
    static func shouldLoadSnapshot(isActive: Bool) -> Bool {
        isActive
    }

    static func shouldHandleStartRequest(isActive: Bool) -> Bool {
        isActive
    }
}

enum PracticeMatchPresentationPolicy {
    static func usesPullUpRoundCard(for style: PracticePresentationStyle) -> Bool {
        switch style {
        case .route, .pullUpOverlay:
            return true
        }
    }

    static func showsDirectStartCard(
        style: PracticePresentationStyle,
        hasRequestedStart: Bool,
        hasActiveSession: Bool
    ) -> Bool {
        style == .pullUpOverlay && hasRequestedStart && !hasActiveSession
    }

    static func showsHubLayer(
        style: PracticePresentationStyle,
        hasActiveSession: Bool
    ) -> Bool {
        switch style {
        case .route:
            return true
        case .pullUpOverlay:
            return !hasActiveSession
        }
    }
}

enum PracticeMatchPullUpMetrics {
    static let backdropOpacity: Double = 0.34
    static let sheetHorizontalBackgroundPadding: CGFloat = 0
}

struct PracticeView: View {
    @ObservedObject var intentStore: LocalUserIntentStore
    @StateObject private var progressStore: LocalPracticeProgressStore
    @StateObject private var messageStore: LocalPracticeMessageStore

    let initialMode: PracticeMode?
    let entryContext: PracticeEntryContext
    let startRequest: PracticeStartRequest?
    let isActive: Bool
    let scrollToTopTrigger: Int
    let topContentClearance: CGFloat
    let presentationStyle: PracticePresentationStyle
    let photoBackdropState: AdminRootPhotoBackdropState
    let isPhotoBackdropVisible: Bool
    var onOpenDetail: (String) -> Void
    var onBrowseTapped: () -> Void
    var onDismiss: () -> Void
    var onCloseMatchToOrigin: () -> Void
    var onMatchPresentationChanged: (Bool) -> Void
    var onThreadBackToOrigin: (PracticeScenarioID?) -> Void
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
    @State private var pendingScenarioReturnTurnID: String?
    @State private var scenarioReturnFocusRequest: PracticeStoryReturnFocusRequest?
    @State private var scenarioReturnFocusRequestID = 0
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
        topContentClearance: CGFloat = 0,
        presentationStyle: PracticePresentationStyle = .route,
        photoBackdropState: AdminRootPhotoBackdropState = .fallback,
        isPhotoBackdropVisible: Bool = false,
        progressStore: LocalPracticeProgressStore = LocalPracticeProgressStore(),
        messageStore: LocalPracticeMessageStore = LocalPracticeMessageStore(),
        onOpenDetail: @escaping (String) -> Void,
        onBrowseTapped: @escaping () -> Void,
        onDismiss: @escaping () -> Void = {},
        onCloseMatchToOrigin: @escaping () -> Void = {},
        onMatchPresentationChanged: @escaping (Bool) -> Void = { _ in },
        onThreadBackToOrigin: @escaping (PracticeScenarioID?) -> Void = { _ in },
        onThreadPresentationChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self.intentStore = intentStore
        self.initialMode = initialMode
        self.entryContext = entryContext
        self.startRequest = startRequest
        self.isActive = isActive
        self.scrollToTopTrigger = scrollToTopTrigger
        self.topContentClearance = topContentClearance
        self.presentationStyle = presentationStyle
        self.photoBackdropState = photoBackdropState
        self.isPhotoBackdropVisible = isPhotoBackdropVisible
        self.onOpenDetail = onOpenDetail
        self.onBrowseTapped = onBrowseTapped
        self.onDismiss = onDismiss
        self.onCloseMatchToOrigin = onCloseMatchToOrigin
        self.onMatchPresentationChanged = onMatchPresentationChanged
        self.onThreadBackToOrigin = onThreadBackToOrigin
        self.onThreadPresentationChanged = onThreadPresentationChanged
        _progressStore = StateObject(wrappedValue: progressStore)
        _messageStore = StateObject(wrappedValue: messageStore)
    }

    var body: some View {
        PracticeMatchRootView(
            intentStore: intentStore,
            isActive: isActive,
            scrollToTopTrigger: scrollToTopTrigger,
            requestedStartID: startRequest?.id ?? (initialMode == nil ? nil : -1),
            requestedSourceID: startRequest?.sourceID,
            requestedMode: startRequest?.mode ?? initialMode,
            topContentClearance: topContentClearance,
            presentationStyle: presentationStyle,
            photoBackdropState: photoBackdropState,
            isPhotoBackdropVisible: isPhotoBackdropVisible,
            onBrowseTapped: onBrowseTapped,
            onDismiss: onDismiss,
            onCloseToOrigin: onCloseMatchToOrigin,
            onPresentationChanged: onMatchPresentationChanged
        )
        .onAppear {
            onThreadPresentationChanged(false)
            onMatchPresentationChanged(false)
        }
        .onChange(of: isActive) { _, active in
            if active {
                onThreadPresentationChanged(false)
            }
            if !active {
                onMatchPresentationChanged(false)
            }
        }
        .accessibilityIdentifier("PracticeView")
    }

    private static let scrollTopID = "PracticeViewTop"
    private static let scenarioReplyRevealDelay: TimeInterval = 1.6
    private static let scenarioNextPromptDelay: TimeInterval = 0.75
    private static let scenarioNoReplyAdvanceDelay: TimeInterval = 0.35
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
        threadDismissal: PracticeScenarioThreadDismissal = .messagesHub,
        returnFocusRequest: PracticeStoryReturnFocusRequest? = nil
    ) {
        guard !scenario.steps.isEmpty else {
            return
        }

        unreadScenarioIDs.remove(scenario.id)
        activeScenarioThreadDismissal = threadDismissal
        scenarioReturnFocusRequest = returnFocusRequest

        if reset {
            messageStore.clear(scenario.id)
        }

        if !reset, let completion = messageStore.completion(for: scenario) {
            activeScenarioSession = nil
            scenarioCompletion = completion
            isScenarioThreadPresented = true
            return
        }

        if !reset, let existingSession = activeScenarioSession, existingSession.scenario.id == scenario.id {
            activeScenarioSession = existingSession
            scenarioCompletion = nil
            isScenarioThreadPresented = true
            resumePendingScenarioTimers(for: existingSession)
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

    private func advanceScenarioSessionIfReady() {
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

        guard let nextIndex = session.scenario.nextStepIndex(
            after: session.currentIndex,
            selectedOptionIDs: session.selectedOptionIDs
        ) else {
            scenarioCompletion = PracticeScenarioCompletionSummary(
                scenario: session.scenario,
                context: session.context,
                practicedCount: session.selectedOptionIDs.count
            )
            activeScenarioSession = nil
            messageStore.markComplete(session)
            reloadScenarioSnapshot()
            return
        }

        session.currentIndex = nextIndex
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
        scenarioReturnFocusRequest = nil
        onThreadPresentationChanged(false)
        reloadScenarioSnapshot()
    }

    private func dismissScenarioThread() {
        switch activeScenarioThreadDismissal {
        case .messagesHub:
            dismissScenarioSheet()
        case .originRoute:
            let scenarioID = activeScenarioSession?.scenario.id ?? scenarioCompletion?.scenario.id
            isScenarioThreadPresented = false
            scenarioReturnFocusRequest = nil
            onThreadPresentationChanged(false)
            activeScenarioThreadDismissal = .messagesHub
            reloadScenarioSnapshot()
            onThreadBackToOrigin(scenarioID)
        }
    }

    private func isScenarioPageInPractice(_ pageID: String) -> Bool {
        intentStore.isPageInPractice(pageID)
    }

    private func isScenarioPageSaved(_ pageID: String) -> Bool {
        intentStore.isPageSaved(pageID)
    }

    private func openScenarioPhrasePage(_ pageID: String, returnTurnID: String?) {
        advanceScenarioSessionIfReady()
        pendingScenarioReturnID = activeScenarioSession?.scenario.id ?? scenarioCompletion?.scenario.id
        pendingScenarioReturnTurnID = returnTurnID
        isScenarioThreadPresented = false
        onThreadPresentationChanged(false)
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
        scheduleScenarioProgressionAfterSend(
            stepID: step.id,
            initialDelay: step.hasLocalReply(after: option)
                ? Self.scenarioReplyRevealDelay
                : Self.scenarioNoReplyAdvanceDelay
        )
    }

    private func scheduleScenarioProgressionAfterSend(stepID: String, initialDelay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + initialDelay) {
            guard
                var session = activeScenarioSession,
                session.currentStep?.id == stepID,
                let currentStep = session.currentStep,
                let selectedOption = session.selectedOption(for: currentStep)
            else {
                return
            }

            if currentStep.hasLocalReply(after: selectedOption),
               !session.revealedReplyStepIDs.contains(stepID) {
                session.revealedReplyStepIDs.insert(stepID)
                activeScenarioSession = session
                messageStore.save(session)
                scheduleScenarioAutoAdvance(stepID: stepID, after: Self.scenarioNextPromptDelay)
            } else {
                scheduleScenarioAutoAdvance(stepID: stepID, after: 0)
            }
        }
    }

    private func scheduleScenarioAutoAdvance(stepID: String, after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard
                let session = activeScenarioSession,
                session.currentStep?.id == stepID,
                session.selectedOptionIDs[stepID] != nil
            else {
                return
            }

            advanceScenarioSessionIfReady()
        }
    }

    private func resumePendingScenarioTimers(for session: PracticeScenarioSession) {
        guard
            let currentStep = session.currentStep,
            let selectedOption = session.selectedOption(for: currentStep)
        else {
            return
        }

        if currentStep.hasLocalReply(after: selectedOption),
           !session.revealedReplyStepIDs.contains(currentStep.id) {
            scheduleScenarioProgressionAfterSend(
                stepID: currentStep.id,
                initialDelay: Self.scenarioReplyRevealDelay
            )
        } else {
            scheduleScenarioAutoAdvance(stepID: currentStep.id, after: Self.scenarioNoReplyAdvanceDelay)
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

        let returnTurnID = pendingScenarioReturnTurnID
        let returnFocusRequest: PracticeStoryReturnFocusRequest?
        if let returnTurnID {
            scenarioReturnFocusRequestID += 1
            returnFocusRequest = PracticeStoryReturnFocusRequest(
                id: scenarioReturnFocusRequestID,
                turnID: returnTurnID
            )
        } else {
            returnFocusRequest = nil
        }

        self.pendingScenarioReturnID = nil
        self.pendingScenarioReturnTurnID = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.scenarioReturnPresentationDelay) {
            guard isActive else {
                self.pendingScenarioReturnID = scenario.id
                self.pendingScenarioReturnTurnID = returnTurnID
                return
            }

            presentScenarioThread(
                scenario,
                threadDismissal: activeScenarioThreadDismissal,
                returnFocusRequest: returnFocusRequest
            )
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
    private static var didApplyLaunchReset = false

    private enum Key {
        static let threads = "SpeakLocal.Practice.messageThreads.v1"
    }

    init(defaults: UserDefaults = .standard, launchArguments: [String] = ProcessInfo.processInfo.arguments) {
        self.defaults = defaults

#if DEBUG
        if launchArguments.contains("--reset-practice-message-threads"), !Self.didApplyLaunchReset {
            defaults.removeObject(forKey: Key.threads)
            Self.didApplyLaunchReset = true
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

enum PracticeMessageHubLayout {
    static let itemWidth: CGFloat = 96
    static let avatarSize: CGFloat = 78
    static let itemSpacing: CGFloat = 22
    static let sectionSpacing: CGFloat = 28
    static let titleToRowSpacing: CGFloat = 18
    static let rowHorizontalInset: CGFloat = 1
    static var rowViewportHorizontalBleed: CGFloat { PracticeLayout.horizontalPadding }
    static var rowContentHorizontalInset: CGFloat { PracticeLayout.horizontalPadding + rowHorizontalInset }
    static let itemTextSpacing: CGFloat = 12
    static let labelFontSize: CGFloat = 14
    static let labelMinHeight: CGFloat = 38
    static let unreadDotSize: CGFloat = 11
    static let unreadDotOffset = CGSize(width: -7, height: 7)

    static func columnFrame(column: Int) -> CGRect {
        CGRect(
            x: rowContentHorizontalInset + CGFloat(column) * (itemWidth + itemSpacing),
            y: 0,
            width: itemWidth,
            height: avatarSize
        )
    }

    static func rowViewportWidth(contentColumnWidth: CGFloat) -> CGFloat {
        contentColumnWidth + (rowViewportHorizontalBleed * 2)
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
        VStack(alignment: .leading, spacing: PracticeMessageHubLayout.sectionSpacing) {
            ForEach(sections) { section in
                VStack(alignment: .leading, spacing: PracticeMessageHubLayout.titleToRowSpacing) {
                    Text(section.title)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.primary)
                        .accessibilityIdentifier("Practice.Messages.Section.\(section.id)")

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: PracticeMessageHubLayout.itemSpacing) {
                            ForEach(section.scenarios) { scenario in
                                PracticeMessageContactButton(
                                    scenario: scenario,
                                    isUnread: unreadScenarioIDs.contains(scenario.id),
                                    onMarkUnread: { onMarkUnread(scenario.id) },
                                    onStart: { onStart(scenario) }
                                )
                                .frame(width: PracticeMessageHubLayout.itemWidth)
                            }
                        }
                        .padding(.horizontal, PracticeMessageHubLayout.rowContentHorizontalInset)
                    }
                    .padding(.horizontal, -PracticeMessageHubLayout.rowViewportHorizontalBleed)
                    .scrollClipDisabled()
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
            VStack(spacing: PracticeMessageHubLayout.itemTextSpacing) {
                PracticeMessageAvatar(
                    scenarioID: scenario.id,
                    size: PracticeMessageHubLayout.avatarSize,
                    showsSymbol: true
                )
                .overlay(alignment: .topTrailing) {
                    if isUnread {
                        Circle()
                            .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                            .frame(
                                width: PracticeMessageHubLayout.unreadDotSize,
                                height: PracticeMessageHubLayout.unreadDotSize
                            )
                            .overlay {
                                Circle()
                                    .stroke(.white, lineWidth: 2)
                            }
                            .offset(PracticeMessageHubLayout.unreadDotOffset)
                            .accessibilityLabel("Unread")
                            .accessibilityIdentifier("Practice.Message.Contact.UnreadDot.\(scenario.id.rawValue)")
                    }
                }

                Text(scenario.id.messageContactName)
                    .font(.system(size: PracticeMessageHubLayout.labelFontSize, weight: isUnread ? .bold : .semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)
                    .frame(maxWidth: .infinity, minHeight: PracticeMessageHubLayout.labelMinHeight, alignment: .top)
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
                    .shadow(color: .black.opacity(0.12), radius: size * 0.035, x: 0, y: size * 0.02)
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
        .shadow(color: scenarioID.messageBadgeOverlayColor.opacity(0.08), radius: size * 0.09, x: 0, y: size * 0.04)
        .accessibilityHidden(true)
    }
}

private struct PracticeMessageBadgeBackdrop: View {
    let scenarioID: PracticeScenarioID
    let size: CGFloat

    var body: some View {
        ZStack {
            LinearGradient(
                colors: scenarioID.messageBadgePalette,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            PracticeMessageBadgeBaseScene(kind: scenarioID.messageBadgeSceneKind, size: size)
                .opacity(0.82)

            Image(systemName: scenarioID.messageBadgeBackdropSymbolName)
                .font(.system(size: size * scenarioID.messageBadgeBackdropSymbolScale, weight: .black))
                .foregroundStyle(.white.opacity(0.2))
                .rotationEffect(.degrees(scenarioID.messageBadgeBackdropRotation))
                .offset(
                    x: scenarioID.messageBadgeBackdropSymbolOffset.width * size,
                    y: scenarioID.messageBadgeBackdropSymbolOffset.height * size
                )

            if let label = scenarioID.messageBadgeSceneLabel {
                Text(label)
                    .font(.system(size: size * 0.112, weight: .black, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.74)
                    .foregroundStyle(.white.opacity(0.74))
                    .padding(.horizontal, size * 0.07)
                    .padding(.vertical, size * 0.025)
                    .background(.black.opacity(0.16), in: Capsule())
                    .offset(y: -size * 0.31)
            }

            scenarioID.messageBadgeOverlayColor
                .opacity(0.14)
                .blendMode(.overlay)

            LinearGradient(
                colors: [
                    .white.opacity(0.24),
                    .white.opacity(0.02),
                    .black.opacity(0.22),
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

enum PracticeMessageBadgeSceneKind: String {
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

extension PracticeScenarioID {
    var messageBadgeOverlayColor: Color {
        switch self {
        case .danangFirstDay:
            return Color(red: 0.08, green: 0.38, blue: 0.74)
        case .airportPassportControl:
            return Color(red: 0.05, green: 0.45, blue: 0.78)
        case .airportSimCash:
            return Color(red: 0.05, green: 0.52, blue: 0.62)
        case .airportWifiPower:
            return Color(red: 0.05, green: 0.46, blue: 0.58)
        case .airportBaggageProblem:
            return Color(red: 0.16, green: 0.4, blue: 0.68)
        case .hotelCheckInHelp:
            return Color(red: 0.48, green: 0.31, blue: 0.76)
        case .hotelRoomHelp:
            return Color(red: 0.55, green: 0.36, blue: 0.78)
        case .hotelBagsTaxi:
            return Color(red: 0.38, green: 0.25, blue: 0.67)
        case .hotelWifiCheckout:
            return Color(red: 0.45, green: 0.29, blue: 0.72)
        case .hotelRoomSupplies:
            return Color(red: 0.5, green: 0.34, blue: 0.7)
        case .restaurantOrderingPayment:
            return Color(red: 0.08, green: 0.43, blue: 0.32)
        case .danangDay:
            return Color(red: 0.2, green: 0.63, blue: 0.58)
        case .foodAllergyHelp:
            return Color(red: 0.1, green: 0.52, blue: 0.35)
        case .foodCoffeeOrder:
            return Color(red: 0.08, green: 0.45, blue: 0.34)
        case .foodMenuItems:
            return Color(red: 0.13, green: 0.5, blue: 0.3)
        case .taxiGrabPickup, .taxiRouteHelp, .driverProblemHelp, .walkingDirectionsHelp, .taxiFareComfort:
            return Color(red: 0.7, green: 0.42, blue: 0.08)
        case .shoppingMarketPrice, .shoppingSizeGift, .shoppingReceiptHelp, .shoppingPayCard, .shoppingMarketProduce:
            return Color(red: 0.72, green: 0.42, blue: 0.08)
        case .pharmacyHelp, .emergencyLostPassport, .emergencyLostBag, .emergencyDoctorHelp, .emergencyCallHelp:
            return Color(red: 0.78, green: 0.12, blue: 0.16)
        case .localGreetingMarket, .localGreetingHotel, .localGreetingRespect, .localThanksSorry, .localSmallTalk:
            return Color(red: 0.06, green: 0.5, blue: 0.52)
        }
    }

    var messageBadgeBackgroundSignature: String {
        [
            messageBadgePaletteID,
            messageBadgeSceneKind.rawValue,
            messageBadgeBackdropSymbolName,
            messageBadgeSceneLabel ?? "none",
        ].joined(separator: "|")
    }

    var messageAvatarArtSignature: String {
        [
            messageAvatarSymbolName,
            messageBadgeBackgroundSignature,
        ].joined(separator: "|")
    }

    var messageBadgeSceneKind: PracticeMessageBadgeSceneKind {
        switch self {
        case .danangFirstDay:
            return .airport
        case .airportPassportControl:
            return .passportDesk
        case .airportSimCash:
            return .airportServices
        case .airportWifiPower, .airportBaggageProblem:
            return .airportServices
        case .hotelCheckInHelp:
            return .hotelLobby
        case .hotelRoomHelp:
            return .hotelRoom
        case .hotelBagsTaxi:
            return .luggageLobby
        case .hotelWifiCheckout, .hotelRoomSupplies:
            return .hotelLobby
        case .restaurantOrderingPayment:
            return .restaurantTable
        case .danangDay:
            return .beachCafe
        case .foodAllergyHelp:
            return .allergyPlate
        case .foodCoffeeOrder, .foodMenuItems:
            return .beachCafe
        case .taxiGrabPickup, .driverProblemHelp:
            return .road
        case .taxiRouteHelp, .walkingDirectionsHelp, .taxiFareComfort:
            return .routeMap
        case .shoppingMarketPrice, .shoppingMarketProduce:
            return .market
        case .shoppingSizeGift:
            return .giftShop
        case .shoppingReceiptHelp, .shoppingPayCard:
            return .checkout
        case .pharmacyHelp, .emergencyDoctorHelp, .emergencyCallHelp:
            return .pharmacy
        case .emergencyLostPassport, .emergencyLostBag:
            return .emergencyDesk
        case .localGreetingMarket, .localGreetingHotel, .localGreetingRespect, .localThanksSorry, .localSmallTalk:
            return .greeting
        }
    }

    var messageBadgePaletteID: String {
        switch self {
        case .danangFirstDay:
            return "baggage-blue"
        case .airportPassportControl:
            return "passport-red"
        case .airportSimCash:
            return "sim-cash-teal"
        case .airportWifiPower:
            return "wifi-cyan"
        case .airportBaggageProblem:
            return "baggage-problem-blue"
        case .hotelCheckInHelp:
            return "hotel-checkin-violet"
        case .hotelRoomHelp:
            return "hotel-room-lavender"
        case .hotelBagsTaxi:
            return "hotel-bags-indigo"
        case .hotelWifiCheckout:
            return "hotel-checkout-mauve"
        case .hotelRoomSupplies:
            return "room-supplies-violet"
        case .restaurantOrderingPayment:
            return "restaurant-table-green"
        case .danangDay:
            return "beach-snacks-aqua"
        case .foodAllergyHelp:
            return "food-allergy-leaf"
        case .foodCoffeeOrder:
            return "coffee-order-caramel"
        case .foodMenuItems:
            return "menu-items-green"
        case .taxiGrabPickup:
            return "grab-pickup-green"
        case .taxiRouteHelp:
            return "taxi-route-amber"
        case .driverProblemHelp:
            return "driver-help-alert"
        case .walkingDirectionsHelp:
            return "walking-help-bluegreen"
        case .taxiFareComfort:
            return "taxi-fare-comfort"
        case .shoppingMarketPrice:
            return "market-price-orange"
        case .shoppingSizeGift:
            return "gift-size-rose"
        case .shoppingReceiptHelp:
            return "receipt-help-gold"
        case .shoppingPayCard:
            return "pay-card-blue"
        case .shoppingMarketProduce:
            return "market-produce-gold"
        case .pharmacyHelp:
            return "pharmacy-red-teal"
        case .emergencyLostPassport:
            return "lost-passport-navy"
        case .emergencyLostBag:
            return "lost-bag-crimson"
        case .emergencyDoctorHelp:
            return "doctor-help-clinical"
        case .emergencyCallHelp:
            return "emergency-call-red"
        case .localGreetingMarket:
            return "market-hello-teal"
        case .localGreetingHotel:
            return "hotel-hello-blue"
        case .localGreetingRespect:
            return "respect-hello-indigo"
        case .localThanksSorry:
            return "thanks-sorry-rose"
        case .localSmallTalk:
            return "small-talk-teal"
        }
    }

    var messageBadgePalette: [Color] {
        switch self {
        case .danangFirstDay:
            return [Color(red: 0.22, green: 0.52, blue: 0.9), Color(red: 0.06, green: 0.21, blue: 0.48)]
        case .airportPassportControl:
            return [Color(red: 0.96, green: 0.25, blue: 0.3), Color(red: 0.38, green: 0.09, blue: 0.2)]
        case .airportSimCash:
            return [Color(red: 0.13, green: 0.65, blue: 0.52), Color(red: 0.04, green: 0.33, blue: 0.35)]
        case .airportWifiPower:
            return [Color(red: 0.16, green: 0.58, blue: 0.82), Color(red: 0.04, green: 0.25, blue: 0.5)]
        case .airportBaggageProblem:
            return [Color(red: 0.2, green: 0.5, blue: 0.84), Color(red: 0.08, green: 0.22, blue: 0.44)]
        case .hotelCheckInHelp:
            return [Color(red: 0.6, green: 0.39, blue: 0.84), Color(red: 0.27, green: 0.15, blue: 0.55)]
        case .hotelRoomHelp:
            return [Color(red: 0.68, green: 0.48, blue: 0.86), Color(red: 0.31, green: 0.2, blue: 0.62)]
        case .hotelBagsTaxi:
            return [Color(red: 0.48, green: 0.37, blue: 0.78), Color(red: 0.17, green: 0.2, blue: 0.55)]
        case .hotelWifiCheckout:
            return [Color(red: 0.65, green: 0.38, blue: 0.66), Color(red: 0.25, green: 0.16, blue: 0.48)]
        case .hotelRoomSupplies:
            return [Color(red: 0.58, green: 0.42, blue: 0.8), Color(red: 0.24, green: 0.18, blue: 0.5)]
        case .restaurantOrderingPayment:
            return [Color(red: 0.24, green: 0.58, blue: 0.44), Color(red: 0.07, green: 0.31, blue: 0.24)]
        case .danangDay:
            return [Color(red: 0.32, green: 0.72, blue: 0.66), Color(red: 0.1, green: 0.38, blue: 0.46)]
        case .foodAllergyHelp:
            return [Color(red: 0.28, green: 0.66, blue: 0.38), Color(red: 0.08, green: 0.31, blue: 0.22)]
        case .foodCoffeeOrder:
            return [Color(red: 0.72, green: 0.49, blue: 0.28), Color(red: 0.26, green: 0.17, blue: 0.12)]
        case .foodMenuItems:
            return [Color(red: 0.24, green: 0.62, blue: 0.38), Color(red: 0.08, green: 0.28, blue: 0.2)]
        case .taxiGrabPickup:
            return [Color(red: 0.28, green: 0.64, blue: 0.36), Color(red: 0.42, green: 0.3, blue: 0.08)]
        case .taxiRouteHelp:
            return [Color(red: 0.88, green: 0.58, blue: 0.18), Color(red: 0.4, green: 0.25, blue: 0.06)]
        case .driverProblemHelp:
            return [Color(red: 0.9, green: 0.45, blue: 0.2), Color(red: 0.5, green: 0.12, blue: 0.08)]
        case .walkingDirectionsHelp:
            return [Color(red: 0.18, green: 0.56, blue: 0.68), Color(red: 0.08, green: 0.32, blue: 0.34)]
        case .taxiFareComfort:
            return [Color(red: 0.82, green: 0.52, blue: 0.16), Color(red: 0.34, green: 0.2, blue: 0.08)]
        case .shoppingMarketPrice:
            return [Color(red: 0.88, green: 0.52, blue: 0.22), Color(red: 0.43, green: 0.23, blue: 0.07)]
        case .shoppingSizeGift:
            return [Color(red: 0.9, green: 0.38, blue: 0.56), Color(red: 0.43, green: 0.16, blue: 0.4)]
        case .shoppingReceiptHelp:
            return [Color(red: 0.82, green: 0.58, blue: 0.2), Color(red: 0.34, green: 0.25, blue: 0.11)]
        case .shoppingPayCard:
            return [Color(red: 0.22, green: 0.5, blue: 0.82), Color(red: 0.18, green: 0.22, blue: 0.56)]
        case .shoppingMarketProduce:
            return [Color(red: 0.8, green: 0.58, blue: 0.2), Color(red: 0.3, green: 0.24, blue: 0.08)]
        case .pharmacyHelp:
            return [Color(red: 0.9, green: 0.24, blue: 0.26), Color(red: 0.08, green: 0.39, blue: 0.41)]
        case .emergencyLostPassport:
            return [Color(red: 0.78, green: 0.14, blue: 0.22), Color(red: 0.12, green: 0.15, blue: 0.36)]
        case .emergencyLostBag:
            return [Color(red: 0.94, green: 0.25, blue: 0.18), Color(red: 0.42, green: 0.08, blue: 0.1)]
        case .emergencyDoctorHelp:
            return [Color(red: 0.9, green: 0.22, blue: 0.28), Color(red: 0.13, green: 0.28, blue: 0.56)]
        case .emergencyCallHelp:
            return [Color(red: 0.9, green: 0.2, blue: 0.22), Color(red: 0.35, green: 0.08, blue: 0.12)]
        case .localGreetingMarket:
            return [Color(red: 0.15, green: 0.62, blue: 0.54), Color(red: 0.06, green: 0.32, blue: 0.29)]
        case .localGreetingHotel:
            return [Color(red: 0.18, green: 0.52, blue: 0.72), Color(red: 0.12, green: 0.25, blue: 0.5)]
        case .localGreetingRespect:
            return [Color(red: 0.36, green: 0.46, blue: 0.78), Color(red: 0.08, green: 0.29, blue: 0.42)]
        case .localThanksSorry:
            return [Color(red: 0.74, green: 0.36, blue: 0.5), Color(red: 0.08, green: 0.34, blue: 0.38)]
        case .localSmallTalk:
            return [Color(red: 0.16, green: 0.58, blue: 0.56), Color(red: 0.06, green: 0.28, blue: 0.34)]
        }
    }

    var messageBadgeSceneLabel: String? {
        switch self {
        case .danangFirstDay:
            return "BAGS"
        case .airportPassportControl:
            return "PASS"
        case .airportSimCash:
            return "SIM"
        case .airportWifiPower:
            return "WI-FI"
        case .airportBaggageProblem:
            return "BAGS"
        case .hotelCheckInHelp:
            return "CHECK"
        case .hotelRoomHelp:
            return "ROOM"
        case .hotelBagsTaxi:
            return "TAXI"
        case .hotelWifiCheckout:
            return "OUT"
        case .hotelRoomSupplies:
            return "SUPPLY"
        case .restaurantOrderingPayment:
            return "TABLE"
        case .danangDay:
            return "SNACKS"
        case .foodAllergyHelp:
            return "ALLERGY"
        case .foodCoffeeOrder:
            return "COFFEE"
        case .foodMenuItems:
            return "MENU"
        case .taxiGrabPickup:
            return "PICKUP"
        case .taxiRouteHelp:
            return "ROUTE"
        case .driverProblemHelp:
            return "HELP"
        case .walkingDirectionsHelp:
            return "WALK"
        case .taxiFareComfort:
            return "FARE"
        case .shoppingMarketPrice:
            return "MARKET"
        case .shoppingSizeGift:
            return "GIFT"
        case .shoppingReceiptHelp:
            return "RCPT"
        case .shoppingPayCard:
            return "CARD"
        case .shoppingMarketProduce:
            return "KILO"
        case .pharmacyHelp:
            return "MEDS"
        case .emergencyLostPassport:
            return "PASS"
        case .emergencyLostBag:
            return "BAG"
        case .emergencyDoctorHelp:
            return "DOCTOR"
        case .emergencyCallHelp:
            return "CALL"
        case .localGreetingMarket:
            return "MARKET"
        case .localGreetingHotel:
            return "HOTEL"
        case .localGreetingRespect:
            return "FORMAL"
        case .localThanksSorry:
            return "THANKS"
        case .localSmallTalk:
            return "CHAT"
        }
    }

    var messageBadgeBackdropSymbolName: String {
        switch self {
        case .danangFirstDay:
            return "airplane.arrival"
        case .airportPassportControl:
            return "person.text.rectangle"
        case .airportSimCash:
            return "creditcard.and.123"
        case .airportWifiPower:
            return "wifi"
        case .airportBaggageProblem:
            return "suitcase.fill"
        case .hotelCheckInHelp:
            return "building.2.fill"
        case .hotelRoomHelp:
            return "bed.double.fill"
        case .hotelBagsTaxi:
            return "car.fill"
        case .hotelWifiCheckout:
            return "wifi.router.fill"
        case .hotelRoomSupplies:
            return "wrench.and.screwdriver.fill"
        case .restaurantOrderingPayment:
            return "wineglass.fill"
        case .danangDay:
            return "water.waves"
        case .foodAllergyHelp:
            return "exclamationmark.triangle.fill"
        case .foodCoffeeOrder:
            return "cup.and.saucer.fill"
        case .foodMenuItems:
            return "list.bullet.rectangle.fill"
        case .taxiGrabPickup:
            return "car.fill"
        case .taxiRouteHelp:
            return "point.topleft.down.curvedto.point.bottomright.up"
        case .driverProblemHelp:
            return "exclamationmark.triangle.fill"
        case .walkingDirectionsHelp:
            return "figure.walk"
        case .taxiFareComfort:
            return "speedometer"
        case .shoppingMarketPrice:
            return "storefront.fill"
        case .shoppingSizeGift:
            return "shippingbox.fill"
        case .shoppingReceiptHelp:
            return "receipt.fill"
        case .shoppingPayCard:
            return "creditcard.fill"
        case .shoppingMarketProduce:
            return "cart.fill"
        case .pharmacyHelp:
            return "pills.fill"
        case .emergencyLostPassport:
            return "building.columns.fill"
        case .emergencyLostBag:
            return "camera.viewfinder"
        case .emergencyDoctorHelp:
            return "stethoscope"
        case .emergencyCallHelp:
            return "phone.fill"
        case .localGreetingMarket:
            return "basket.fill"
        case .localGreetingHotel:
            return "door.left.hand.open"
        case .localGreetingRespect:
            return "person.2.fill"
        case .localThanksSorry:
            return "bubble.left.and.bubble.right.fill"
        case .localSmallTalk:
            return "ellipsis.bubble.fill"
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
        case .driverProblemHelp:
            return 7
        case .walkingDirectionsHelp:
            return -8
        default:
            return 0
        }
    }

    var messageBadgeBackdropSymbolScale: CGFloat {
        switch self {
        case .airportPassportControl, .emergencyLostPassport:
            return 0.58
        case .hotelCheckInHelp, .localGreetingHotel:
            return 0.52
        case .danangFirstDay, .hotelBagsTaxi, .emergencyLostBag:
            return 0.64
        case .restaurantOrderingPayment, .foodAllergyHelp:
            return 0.56
        default:
            return 0.6
        }
    }

    var messageBadgeBackdropSymbolOffset: CGSize {
        switch self {
        case .danangFirstDay:
            return CGSize(width: 0.15, height: 0.15)
        case .airportPassportControl:
            return CGSize(width: 0.13, height: 0.1)
        case .airportSimCash:
            return CGSize(width: -0.14, height: 0.14)
        case .airportWifiPower:
            return CGSize(width: 0.12, height: 0.12)
        case .airportBaggageProblem:
            return CGSize(width: -0.12, height: 0.15)
        case .hotelCheckInHelp:
            return CGSize(width: 0.13, height: 0.16)
        case .hotelRoomHelp:
            return CGSize(width: -0.12, height: 0.14)
        case .hotelBagsTaxi:
            return CGSize(width: 0.16, height: 0.15)
        case .hotelWifiCheckout:
            return CGSize(width: 0.14, height: 0.13)
        case .hotelRoomSupplies:
            return CGSize(width: -0.12, height: 0.13)
        case .restaurantOrderingPayment:
            return CGSize(width: 0.16, height: 0.14)
        case .danangDay:
            return CGSize(width: 0.16, height: 0.16)
        case .foodAllergyHelp:
            return CGSize(width: -0.14, height: 0.16)
        case .foodCoffeeOrder:
            return CGSize(width: 0.15, height: 0.12)
        case .foodMenuItems:
            return CGSize(width: -0.12, height: 0.14)
        case .taxiGrabPickup:
            return CGSize(width: 0.16, height: 0.15)
        case .taxiRouteHelp:
            return CGSize(width: 0.06, height: 0.16)
        case .driverProblemHelp:
            return CGSize(width: 0.14, height: 0.13)
        case .walkingDirectionsHelp:
            return CGSize(width: 0.14, height: 0.14)
        case .taxiFareComfort:
            return CGSize(width: 0.12, height: 0.14)
        case .shoppingMarketPrice:
            return CGSize(width: -0.12, height: 0.15)
        case .shoppingSizeGift:
            return CGSize(width: 0.14, height: 0.12)
        case .shoppingReceiptHelp:
            return CGSize(width: -0.12, height: 0.14)
        case .shoppingPayCard:
            return CGSize(width: 0.13, height: 0.13)
        case .shoppingMarketProduce:
            return CGSize(width: -0.13, height: 0.15)
        case .pharmacyHelp:
            return CGSize(width: 0.14, height: 0.14)
        case .emergencyLostPassport:
            return CGSize(width: 0.14, height: 0.12)
        case .emergencyLostBag:
            return CGSize(width: 0.15, height: 0.14)
        case .emergencyDoctorHelp:
            return CGSize(width: 0.13, height: 0.14)
        case .emergencyCallHelp:
            return CGSize(width: 0.15, height: 0.13)
        case .localGreetingMarket:
            return CGSize(width: -0.13, height: 0.14)
        case .localGreetingHotel:
            return CGSize(width: 0.15, height: 0.13)
        case .localGreetingRespect:
            return CGSize(width: 0.14, height: 0.13)
        case .localThanksSorry:
            return CGSize(width: 0.12, height: 0.14)
        case .localSmallTalk:
            return CGSize(width: -0.12, height: 0.14)
        }
    }

    var messageBadgeIconScale: CGFloat {
        switch self {
        case .restaurantOrderingPayment, .danangDay, .foodAllergyHelp, .foodCoffeeOrder:
            return 0.4
        case .airportPassportControl, .airportSimCash, .airportWifiPower, .hotelCheckInHelp, .hotelBagsTaxi, .hotelWifiCheckout:
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
        .phraseListCard(cornerRadius: 28)
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
            .fill(Color.black.opacity(AppSurfaceDepth.controlDividerOpacity))
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
        .phraseListCard(cornerRadius: 24)
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
                .padding(.top, 1)
                .padding(.bottom, PhrasePageStyle.cardShadowBleedPadding)
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
            .background(PhrasePageStyle.glassCardFill, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: 1)
            }
            .softAmbientCardShadow()
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

                    Text("Save useful phrases as you browse so Practice can use them later.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .layoutPriority(1)
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
            return .white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity)
        }

        if option.isCorrect {
            return .green.opacity(0.32)
        }

        return isSelected ? .red.opacity(0.28) : .white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity)
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
                    .accessibilityLabel("Remove from Practice")
                }
            }
        }
        .padding(14)
        .background(PhrasePageStyle.glassCardFill, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: 1)
        }
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
            .softInteractiveControlShadow()
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
                    Label("Back to Practice", systemImage: "square.grid.2x2.fill")
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

            Text("Preparing practice rounds...")
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
            Label("Practice is unavailable", systemImage: "exclamationmark.triangle.fill")
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
        .background(PhrasePageStyle.glassCardFill, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
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

// MARK: - Match Practice v1

private enum PracticeMatchDataState {
    case loading
    case loaded(PracticeMatchSnapshot)
    case failed(String)

    var snapshot: PracticeMatchSnapshot? {
        if case .loaded(let snapshot) = self {
            return snapshot
        }

        return nil
    }
}

private struct PracticeMatchTopicSpec: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let symbolName: String
    let tint: AccentTint
    let pageIDs: [String]
    let categoryIDs: [String]
    let cityID: String?
    let candidateLimit: Int

    init(
        id: String,
        title: String,
        subtitle: String,
        symbolName: String,
        tint: AccentTint,
        pageIDs: [String],
        categoryIDs: [String],
        cityID: String? = nil,
        candidateLimit: Int = 96
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.symbolName = symbolName
        self.tint = tint
        self.pageIDs = pageIDs
        self.categoryIDs = categoryIDs
        self.cityID = cityID
        self.candidateLimit = candidateLimit
    }

    static let defaults: [PracticeMatchTopicSpec] = [
        PracticeMatchTopicSpec(
            id: "essentials",
            title: "Essentials",
            subtitle: "Hello, thanks, help",
            symbolName: "bolt.fill",
            tint: .red,
            pageIDs: [
                "viet-phrase-polite-1",
                "viet-phrase-polite-2",
                "viet-phrase-polite-5",
                "viet-phrase-polite-7",
                "viet-family-help-need-help",
                "viet-phrase-v500-unde-repa-can-you-repeat-the-last-part",
                "viet-phrase-problems-3",
                "viet-phrase-bath-1",
            ],
            categoryIDs: [
                "greetings",
                "polite-basics",
                "gratitude",
                "problems-help",
                "understanding-repair",
                "bathroom-personal-needs",
                "small-talk",
                "social-small-talk",
            ]
        ),
        PracticeMatchTopicSpec(
            id: "first-day",
            title: "First day",
            subtitle: "Airport, hotel, taxi",
            symbolName: "calendar.badge.clock",
            tint: .orange,
            pageIDs: [
                "viet-phrase-airport-2",
                "viet-phrase-airport-5",
                "viet-phrase-v500-airp-bord-arri-where-is-the-atm",
                "viet-phrase-v500-airp-bord-arri-here-is-my-passport",
                "viet-phrase-hotel-1",
                "viet-phrase-hotel-5",
                "viet-phrase-hotel-9",
                "viet-phrase-store-1",
            ],
            categoryIDs: [
                "airport-border-arrival",
                "hotel-accommodation",
                "transport",
                "food-drink",
                "phone-internet-power",
                "money-numbers-prices",
                "polite-basics",
            ],
            candidateLimit: 128
        ),
        PracticeMatchTopicSpec(
            id: "food-drinks",
            title: "Eating Out",
            subtitle: "Order, ask, pay",
            symbolName: "takeoutbag.and.cup.and.straw.fill",
            tint: .orange,
            pageIDs: [
                "viet-phrase-store-1",
                "viet-phrase-food-menu",
                "viet-phrase-coffee-7",
                "viet-phrase-v900-food-drin-please-make-it-less-spicy",
                "viet-phrase-v900-food-drin-one-fresh-coconut-please",
                "viet-phrase-food-1",
                "viet-phrase-social-9",
                "viet-phrase-food-premium-has-peanuts",
            ],
            categoryIDs: [
                "food-drink",
                "food-coffee",
                "restaurants",
                "local-dishes",
                "dish-order-diet",
            ],
            candidateLimit: 120
        ),
        PracticeMatchTopicSpec(
            id: "airport",
            title: "Airport",
            subtitle: "Arrival and baggage",
            symbolName: "airplane.arrival",
            tint: .red,
            pageIDs: [
                "viet-phrase-airport-2",
                "viet-phrase-airport-5",
                "viet-phrase-v500-airp-bord-arri-where-is-the-atm",
                "viet-phrase-v500-airp-bord-arri-here-is-my-passport",
                "viet-phrase-v500-airp-bord-arri-where-is-the-taxi-counter",
                "viet-phrase-v500-unde-repa-can-you-repeat-the-last-part",
            ],
            categoryIDs: [
                "airport-border-arrival",
                "arrivals-routes",
                "place-kind-airport",
            ]
        ),
        PracticeMatchTopicSpec(
            id: "taxi-directions",
            title: "Taxi & directions",
            subtitle: "Pickup, drop-off, maps",
            symbolName: "car.fill",
            tint: .green,
            pageIDs: [
                "viet-phrase-taxi-1",
                "viet-phrase-taxi-6",
                "viet-phrase-taxi-7",
                "viet-phrase-v500-tran-are-you-my-driver",
                "viet-phrase-v500-tran-please-follow-the-map",
                "viet-phrase-transport-stop-here-clearer",
                "viet-phrase-v500-tran-please-wait-here",
                "viet-phrase-v900-tran-can-you-pick-me-up-here",
            ],
            categoryIDs: [
                "transport",
                "directions-navigation",
                "hotel-call-taxi",
                "transport-wait-here",
                "transport-wrong-pickup-point",
            ],
            candidateLimit: 128
        ),
        PracticeMatchTopicSpec(
            id: "shopping-markets",
            title: "Shopping & markets",
            subtitle: "Prices, cash, receipts",
            symbolName: "bag.fill",
            tint: .orange,
            pageIDs: [
                "viet-phrase-store-6",
                "viet-phrase-polite-4",
                "viet-phrase-shop-5",
                "viet-phrase-v500-mone-numb-pric-how-much-for-one",
                "viet-phrase-v500-shop-can-you-lower-the-price",
                "viet-phrase-v500-shop-do-you-have-this",
                "viet-phrase-v500-shop-can-i-touch-it",
            ],
            categoryIDs: [
                "shopping",
                "shopping-markets",
                "money-numbers-prices",
                "place-kind-market",
            ],
            candidateLimit: 112
        ),
        PracticeMatchTopicSpec(
            id: "emergency",
            title: "Emergency",
            subtitle: "Help and pharmacy",
            symbolName: "cross.case.fill",
            tint: .red,
            pageIDs: [
                "viet-phrase-v500-emer-safe-i-do-not-have-my-passport",
                "viet-family-help-need-help",
                "viet-phrase-v500-emer-safe-please-call-the-police",
                "viet-phrase-v500-emer-safe-please-call-an-ambulance",
                "viet-phrase-v500-heal-phar-i-need-a-hospital",
                "viet-phrase-health-1",
                "viet-phrase-v500-emer-safe-i-need-first-aid",
            ],
            categoryIDs: [
                "emergency-safety",
                "health-pharmacy",
                "problems-help",
            ]
        ),
        PracticeMatchTopicSpec(
            id: "danang-city",
            title: "Da Nang",
            subtitle: "Beaches, bridges, markets",
            symbolName: "mappin.and.ellipse",
            tint: .blue,
            pageIDs: [
                "viet-phrase-city-danang-place-my-khe",
                "viet-phrase-city-danang-place-dragon-bridge",
                "viet-phrase-city-danang-place-han-market",
                "viet-phrase-city-danang-place-airport",
                "viet-phrase-city-danang-place-marble-mountains",
                "viet-phrase-city-danang-place-son-tra",
            ],
            categoryIDs: [
                "actual-landmarks",
                "city-guides",
                "city-page-kind-place",
                "place-kind-market",
                "place-kind-beach",
            ],
            cityID: "danang",
            candidateLimit: 120
        ),
    ]
}

struct PracticeMatchItem: Identifiable, Equatable {
    let pageID: String
    let vietnamese: String
    let english: String
    let audioKey: String
    let symbolName: String
    let tint: AccentTint
    let imageName: String?

    var id: String { pageID }

    init(
        pageID: String,
        vietnamese: String,
        english: String,
        audioKey: String,
        symbolName: String,
        tint: AccentTint,
        imageName: String? = nil
    ) {
        self.pageID = pageID
        self.vietnamese = vietnamese
        self.english = english
        self.audioKey = audioKey
        self.symbolName = symbolName
        self.tint = tint
        self.imageName = imageName
    }
}

struct PracticeMatchSource: Identifiable, Equatable {
    enum Kind: String, Equatable {
        case quick
        case practice
        case saved
        case topic
    }

    let id: String
    let kind: Kind
    let title: String
    let subtitle: String
    let symbolName: String
    let tint: AccentTint
    let items: [PracticeMatchItem]

    static let placeholder = PracticeMatchSource(
        id: "loading",
        kind: .quick,
        title: "Practice",
        subtitle: "Preparing practice rounds.",
        symbolName: "bolt.fill",
        tint: .red,
        items: []
    )

    var itemCountLabel: String {
        "\(items.count) practice-ready"
    }

    var imageBackedItems: [PracticeMatchItem] {
        items.filter { $0.imageName != nil }
    }

    var supportsImageRounds: Bool {
        imageBackedItems.count >= PracticeMatchRound.pairCount
    }

    var availableRoundModes: [PracticeMatchRoundMode] {
        if supportsImageRounds {
            return PracticeMatchRoundMode.allCases
        }

        return PracticeMatchRoundMode.textOnlyCases
    }

    func roundMode(for roundIndex: Int) -> PracticeMatchRoundMode {
        let modes = availableRoundModes
        guard !modes.isEmpty else {
            return .phraseToMeaning
        }

        return modes[abs(roundIndex) % modes.count]
    }

    var canStart: Bool {
        items.count >= PracticeMatchRound.pairCount
    }
}

private struct PracticeMatchAtmosphere {
    let imageName: String
    let tint: Color
    let glow: Color
    let surface: Color
}

private extension PracticeMatchSource {
    var atmosphere: PracticeMatchAtmosphere {
        switch id {
        case "topic:food-drinks":
            return PracticeMatchAtmosphere(
                imageName: "HeroCategoryFood",
                tint: Color(red: 0.92, green: 0.34, blue: 0.16),
                glow: Color(red: 1.0, green: 0.66, blue: 0.22),
                surface: Color(red: 1.0, green: 0.96, blue: 0.91)
            )
        case "topic:first-day":
            return PracticeMatchAtmosphere(
                imageName: "HeroCategoryFirstDay",
                tint: Color(red: 0.86, green: 0.49, blue: 0.12),
                glow: Color(red: 1.0, green: 0.72, blue: 0.24),
                surface: Color(red: 1.0, green: 0.97, blue: 0.91)
            )
        case "topic:airport":
            return PracticeMatchAtmosphere(
                imageName: "HeroCategoryAirport",
                tint: Color(red: 0.68, green: 0.18, blue: 0.16),
                glow: Color(red: 0.94, green: 0.32, blue: 0.30),
                surface: Color(red: 0.98, green: 0.95, blue: 0.94)
            )
        case "topic:taxi-directions":
            return PracticeMatchAtmosphere(
                imageName: "HeroCategoryGettingAround",
                tint: Color(red: 0.12, green: 0.48, blue: 0.33),
                glow: Color(red: 0.34, green: 0.78, blue: 0.46),
                surface: Color(red: 0.94, green: 0.98, blue: 0.95)
            )
        case "topic:shopping-markets":
            return PracticeMatchAtmosphere(
                imageName: "HeroCategoryNumbersMoney",
                tint: Color(red: 0.84, green: 0.50, blue: 0.10),
                glow: Color(red: 1.0, green: 0.70, blue: 0.24),
                surface: Color(red: 1.0, green: 0.97, blue: 0.90)
            )
        case "topic:emergency":
            return PracticeMatchAtmosphere(
                imageName: "HeroCategoryEmergency",
                tint: Color(red: 0.76, green: 0.16, blue: 0.18),
                glow: Color(red: 1.0, green: 0.28, blue: 0.28),
                surface: Color(red: 0.99, green: 0.94, blue: 0.94)
            )
        case "topic:danang-city":
            return PracticeMatchAtmosphere(
                imageName: "HeroCityDanang",
                tint: Color(red: 0.12, green: 0.42, blue: 0.64),
                glow: Color(red: 0.32, green: 0.72, blue: 0.86),
                surface: Color(red: 0.94, green: 0.98, blue: 1.0)
            )
        default:
            return PracticeMatchAtmosphere(
                imageName: "HeroCategoryEssentials",
                tint: tint.color,
                glow: Color(red: 1.0, green: 0.46, blue: 0.30),
                surface: Color(red: 0.98, green: 0.96, blue: 0.95)
            )
        }
    }
}

enum PracticeMatchRoundMode: String, CaseIterable, Equatable {
    case phraseToMeaning
    case imageToPhrase
    case audioToMeaning
    case audioToImage

    static let textOnlyCases: [PracticeMatchRoundMode] = [
        .phraseToMeaning,
        .audioToMeaning,
    ]

    var requiresImage: Bool {
        switch self {
        case .imageToPhrase, .audioToImage:
            return true
        case .phraseToMeaning, .audioToMeaning:
            return false
        }
    }

    var instruction: String {
        switch self {
        case .phraseToMeaning:
            return "Tap the Vietnamese phrase, then its meaning."
        case .imageToPhrase:
            return "Tap the image, then the phrase it shows."
        case .audioToMeaning:
            return "Listen first, then tap the meaning."
        case .audioToImage:
            return "Listen first, then tap the matching image."
        }
    }

    var badgeLabel: String {
        switch self {
        case .phraseToMeaning:
            return "Phrase"
        case .imageToPhrase:
            return "Image"
        case .audioToMeaning:
            return "Listen"
        case .audioToImage:
            return "Audio + Image"
        }
    }

    func contentKind(for side: PracticeMatchCardSide) -> PracticeMatchCardContentKind {
        switch (self, side) {
        case (.phraseToMeaning, .prompt):
            return .phrase
        case (.phraseToMeaning, .answer):
            return .meaning
        case (.imageToPhrase, .prompt):
            return .image
        case (.imageToPhrase, .answer):
            return .phrase
        case (.audioToMeaning, .prompt):
            return .audio
        case (.audioToMeaning, .answer):
            return .meaning
        case (.audioToImage, .prompt):
            return .audio
        case (.audioToImage, .answer):
            return .image
        }
    }
}

enum PracticeMatchCardContentKind {
    case phrase
    case meaning
    case audio
    case image
}

struct PracticeMatchSnapshot {
    let quickSource: PracticeMatchSource
    let practiceSource: PracticeMatchSource
    let savedSource: PracticeMatchSource
    let topicSources: [PracticeMatchSource]

    var sources: [PracticeMatchSource] {
        [quickSource, practiceSource, savedSource] + topicSources
    }

    func source(sourceID: String?, mode: PracticeMode?) -> PracticeMatchSource {
        if let sourceID,
           let source = sources.first(where: { $0.id == sourceID }) {
            return source
        }

        guard let mode else {
            return quickSource
        }

        switch mode {
        case .savedReview, .missedReview:
            return savedSource
        case .hcmcCity:
            return topicSources.first(where: { $0.id == "topic:first-day" }) ?? quickSource
        case .hanoiBucketList:
            return topicSources.first(where: { $0.id == "topic:essentials" }) ?? quickSource
        case .danangCity:
            return topicSources.first(where: { $0.id == "topic:first-day" }) ?? quickSource
        case .hoianCity:
            return topicSources.first(where: { $0.id == "topic:food-drinks" }) ?? quickSource
        case .hueCity:
            return topicSources.first(where: { $0.id == "topic:essentials" }) ?? quickSource
        }
    }

    static func load(practicePageIDs: [String], savedPageIDs: [String]) throws -> PracticeMatchSnapshot {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let quickItems = try Self.sourceItems(
            repository: repository,
            pageIDs: Self.quickPageIDs,
            categoryIDs: Self.quickCategoryIDs,
            candidateLimit: 160
        )
        let practiceItems: [PracticeMatchItem]
        if practicePageIDs.isEmpty {
            practiceItems = []
        } else {
            practiceItems = Self.uniquePracticeItems(
                from: try repository.loadPracticeCandidates(
                    pageIDs: practicePageIDs,
                    limit: max(80, practicePageIDs.count * 4)
                )
            )
        }

        let savedItems = try SavedTripPracticeCatalog.items(for: savedPageIDs).compactMap { item -> PracticeMatchItem? in
            guard let playableAudioKey = item.audioKey,
                  AudioSpeakerButton.isPlayableAudioKey(playableAudioKey)
            else {
                return nil
            }

            return PracticeMatchItem(
                pageID: item.pageID,
                vietnamese: item.vietnamese,
                english: item.english,
                audioKey: playableAudioKey,
                symbolName: item.symbolName,
                tint: item.tintName,
                imageName: item.imageName
            )
        }

        let topicSources: [PracticeMatchSource] = try PracticeMatchTopicSpec.defaults.compactMap { spec in
            var items = try Self.sourceItems(
                repository: repository,
                pageIDs: spec.pageIDs,
                categoryIDs: spec.categoryIDs,
                cityID: spec.cityID,
                candidateLimit: spec.candidateLimit
            )
            if spec.id == "food-drinks" {
                items = Self.uniquePracticeItems(from: items + Self.menuPracticeItems())
            }

            guard items.count >= PracticeMatchRound.pairCount else {
                return nil
            }

            return PracticeMatchSource(
                id: "topic:\(spec.id)",
                kind: .topic,
                title: spec.title,
                subtitle: spec.subtitle,
                symbolName: spec.symbolName,
                tint: spec.tint,
                items: items
            )
        }

        return PracticeMatchSnapshot(
            quickSource: PracticeMatchSource(
                id: "quick",
                kind: .quick,
                title: "Quick practice",
                subtitle: "Four easy phrases to match.",
                symbolName: "bolt.fill",
                tint: .red,
                items: quickItems
            ),
            practiceSource: PracticeMatchSource(
                id: "practice",
                kind: .practice,
                title: "My practice phrases",
                subtitle: practiceItems.count < PracticeMatchRound.pairCount
                    ? "Add at least 4 phrases to start your own round."
                    : "Match phrases you added to practice.",
                symbolName: "bookmark.fill",
                tint: .red,
                items: practiceItems
            ),
            savedSource: PracticeMatchSource(
                id: "saved",
                kind: .saved,
                title: "Practice Saved",
                subtitle: savedItems.count < PracticeMatchRound.pairCount
                    ? "Save 4 items to unlock your trip round."
                    : "Review the things you saved.",
                symbolName: "heart.fill",
                tint: .red,
                items: savedItems
            ),
            topicSources: topicSources
        )
    }

    private static let quickPageIDs = [
        "viet-phrase-polite-1",
        "viet-phrase-polite-2",
        "viet-phrase-polite-5",
        "viet-phrase-polite-7",
        "viet-family-help-need-help",
        "viet-phrase-v500-unde-repa-can-you-repeat-the-last-part",
        "viet-phrase-problems-3",
        "viet-phrase-bath-1",
    ]

    private static let quickCategoryIDs = [
        "greetings",
        "polite-basics",
        "gratitude",
        "problems-help",
        "understanding-repair",
        "bathroom-personal-needs",
        "airport-border-arrival",
        "hotel-accommodation",
        "transport",
        "food-drink",
    ]

    private static func sourceItems(
        repository: VietSQLiteLanguagePackRepository,
        pageIDs: [String],
        categoryIDs: [String],
        cityID: String? = nil,
        candidateLimit: Int
    ) throws -> [PracticeMatchItem] {
        var candidates = try repository.loadPracticeCandidates(
            pageIDs: pageIDs,
            limit: max(pageIDs.count * 4, pageIDs.count)
        )

        if !categoryIDs.isEmpty {
            candidates += try repository.loadPracticeCandidates(
                categoryIDs: categoryIDs,
                limit: candidateLimit
            )
        }

        if let cityID {
            candidates += try repository.loadPracticeCandidates(
                cityID: cityID,
                limit: candidateLimit
            )
        }

        return uniquePracticeItems(from: candidates)
    }

    private static func uniquePracticeItems(from candidates: [PracticeCandidate]) -> [PracticeMatchItem] {
        var seenPageIDs = Set<String>()
        var seenVietnamese = Set<String>()
        var seenEnglish = Set<String>()

        return candidates.compactMap { candidate in
            let vietnamese = candidate.vietnamese.trimmingCharacters(in: .whitespacesAndNewlines)
            let english = candidate.english.trimmingCharacters(in: .whitespacesAndNewlines)
            guard
                !vietnamese.isEmpty,
                !english.isEmpty,
                let playableAudioKey = candidate.playableAudioKey,
                vietnamese.count <= 54,
                english.count <= 70,
                vietnamese.split(separator: " ").count <= 9,
                english.split(separator: " ").count <= 11,
                seenPageIDs.insert(candidate.pageID).inserted,
                seenVietnamese.insert(vietnamese.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)).inserted,
                seenEnglish.insert(english.lowercased()).inserted
            else {
                return nil
            }

            return PracticeMatchItem(
                pageID: candidate.pageID,
                vietnamese: vietnamese,
                english: english,
                audioKey: playableAudioKey,
                symbolName: candidate.symbolName,
                tint: candidate.tintName,
                imageName: Self.imageName(forMenuCandidate: candidate)
            )
        }
    }

    private static func menuPracticeItems() -> [PracticeMatchItem] {
        let popularItems = VietnameseMenuCatalog.popularItems(for: .food, limit: 14)
            + VietnameseMenuCatalog.popularItems(for: .drink, limit: 10)
        let fallbackItems = VietnameseMenuCatalog.items(for: .food)
            + VietnameseMenuCatalog.items(for: .drink)

        var seenItemIDs = Set<String>()
        return (popularItems + fallbackItems).compactMap { item in
            guard seenItemIDs.insert(item.itemID).inserted,
                  let kind = item.kind,
                  let audioKey = AudioAssetManifest.main?.audioKey(forExactText: item.vietnameseItem),
                  AudioSpeakerButton.isPlayableAudioKey(audioKey)
            else {
                return nil
            }

            return PracticeMatchItem(
                pageID: item.detailPageID,
                vietnamese: item.vietnameseItem.trimmingCharacters(in: .whitespacesAndNewlines),
                english: item.englishTranslation.trimmingCharacters(in: .whitespacesAndNewlines),
                audioKey: audioKey,
                symbolName: kind.symbolName,
                tint: item.kind?.tintName ?? kind.tintName,
                imageName: item.menuImageName
            )
        }
    }

    private static func uniquePracticeItems(from items: [PracticeMatchItem]) -> [PracticeMatchItem] {
        var seenPageIDs = Set<String>()
        var seenVietnamese = Set<String>()
        var seenEnglish = Set<String>()

        return items.filter { item in
            seenPageIDs.insert(item.pageID).inserted
                && seenVietnamese.insert(item.vietnamese.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)).inserted
                && seenEnglish.insert(item.english.lowercased()).inserted
        }
    }

    private static func imageName(forMenuCandidate candidate: PracticeCandidate) -> String? {
        if let menuItem = VietnameseMenuCatalog.detailItem(withPageID: candidate.pageID) {
            return menuItem.menuImageName
        }
        return nil
    }
}

struct PracticeMatchPair: Identifiable, Equatable {
    let id: String
    let item: PracticeMatchItem
}

enum PracticeMatchCardSide: Equatable {
    case prompt
    case answer
}

struct PracticeMatchCard: Identifiable, Equatable {
    let id: String
    let pairID: String
    let item: PracticeMatchItem
    let side: PracticeMatchCardSide
}

struct PracticeMatchRound: Equatable {
    static let pairCount = 4

    let id: String
    let mode: PracticeMatchRoundMode
    let pairs: [PracticeMatchPair]
    let prompts: [PracticeMatchCard]
    let answers: [PracticeMatchCard]

    static func make(source: PracticeMatchSource, roundIndex: Int) -> PracticeMatchRound? {
        var generator = SystemRandomNumberGenerator()
        return make(source: source, roundIndex: roundIndex, rng: &generator)
    }

    static func make<RNG: RandomNumberGenerator>(
        source: PracticeMatchSource,
        roundIndex: Int = 0,
        avoidingItemIDs: Set<String> = [],
        rng: inout RNG
    ) -> PracticeMatchRound? {
        guard source.items.count >= pairCount else {
            return nil
        }

        let mode = source.roundMode(for: roundIndex)
        let eligibleItems = mode.requiresImage ? source.imageBackedItems : source.items
        guard eligibleItems.count >= pairCount else {
            return nil
        }

        let selected = selectedItems(
            from: eligibleItems,
            avoidingItemIDs: avoidingItemIDs,
            rng: &rng
        )
        let pairs = selected.map { item in
            PracticeMatchPair(id: item.id, item: item)
        }
        let promptCards = pairs.map { pair in
            PracticeMatchCard(
                id: "prompt:\(pair.id)",
                pairID: pair.id,
                item: pair.item,
                side: .prompt
            )
        }
        let answerCards = pairs.map { pair in
            PracticeMatchCard(
                id: "answer:\(pair.id)",
                pairID: pair.id,
                item: pair.item,
                side: .answer
            )
        }
        let prompts = promptCards.shuffled(using: &rng)
        var answers = answerCards.shuffled(using: &rng)

        if answers.map(\.pairID) == prompts.map(\.pairID), answers.count > 1 {
            answers = Array(answers.dropFirst()) + [answers[0]]
        }

        return PracticeMatchRound(
            id: [
                source.id,
                "\(roundIndex)",
                mode.rawValue,
                selected.map(\.id).joined(separator: "|"),
                prompts.map(\.id).joined(separator: "|"),
                answers.map(\.id).joined(separator: "|"),
            ].joined(separator: ":"),
            mode: mode,
            pairs: pairs,
            prompts: prompts,
            answers: answers
        )
    }

    private static func selectedItems<RNG: RandomNumberGenerator>(
        from items: [PracticeMatchItem],
        avoidingItemIDs: Set<String>,
        rng: inout RNG
    ) -> [PracticeMatchItem] {
        let shuffled = items.shuffled(using: &rng)
        let preferred = shuffled.filter { !avoidingItemIDs.contains($0.id) }

        guard preferred.count < pairCount else {
            return Array(preferred.prefix(pairCount))
        }

        let selectedIDs = Set(preferred.map(\.id))
        let fill = shuffled
            .filter { !selectedIDs.contains($0.id) }
            .prefix(pairCount - preferred.count)

        return preferred + fill
    }
}

struct PracticeMatchActiveSession: Equatable {
    let source: PracticeMatchSource
    var roundIndex: Int
    var round: PracticeMatchRound
    private var previousRounds: [PracticeMatchRound] = []
    private var recentItemIDs: [String] = []
    var selectedPromptID: String?
    var selectedAnswerID: String?
    var matchedPairIDs: Set<String> = []
    var incorrectPromptID: String?
    var incorrectAnswerID: String?
    var hintedPairID: String?

    var progressText: String {
        "\(matchedPairIDs.count) of \(PracticeMatchRound.pairCount)"
    }

    var progressFraction: CGFloat {
        CGFloat(matchedPairIDs.count) / CGFloat(PracticeMatchRound.pairCount)
    }

    var isRoundComplete: Bool {
        matchedPairIDs.count == PracticeMatchRound.pairCount
    }

    var canReturnToPreviousRound: Bool {
        !previousRounds.isEmpty
    }

    init?(source: PracticeMatchSource, roundIndex: Int = 0) {
        var generator = SystemRandomNumberGenerator()
        self.init(source: source, roundIndex: roundIndex, rng: &generator)
    }

    init?<RNG: RandomNumberGenerator>(source: PracticeMatchSource, roundIndex: Int = 0, rng: inout RNG) {
        guard let round = PracticeMatchRound.make(source: source, roundIndex: roundIndex, rng: &rng) else {
            return nil
        }

        self.source = source
        self.roundIndex = roundIndex
        self.round = round
    }

    mutating func advanceToNextRound() -> Bool {
        var generator = SystemRandomNumberGenerator()
        return advanceToNextRound(rng: &generator)
    }

    mutating func advanceToNextRound<RNG: RandomNumberGenerator>(rng: inout RNG) -> Bool {
        let nextRecentItemIDs = Self.trimmedRecentItemIDs(
            recentItemIDs + round.pairs.map(\.id),
            sourceItemCount: source.items.count
        )
        guard let nextRound = PracticeMatchRound.make(
            source: source,
            roundIndex: roundIndex + 1,
            avoidingItemIDs: Set(nextRecentItemIDs),
            rng: &rng
        ) else {
            return false
        }

        previousRounds.append(round)
        roundIndex += 1
        round = nextRound
        recentItemIDs = nextRecentItemIDs
        resetRoundState()
        return true
    }

    mutating func returnToPreviousRound() -> Bool {
        guard let previousRound = previousRounds.popLast() else {
            return false
        }

        roundIndex = max(roundIndex - 1, 0)
        round = previousRound
        resetRoundState()
        return true
    }

    private mutating func resetRoundState() {
        selectedPromptID = nil
        selectedAnswerID = nil
        matchedPairIDs = []
        incorrectPromptID = nil
        incorrectAnswerID = nil
        hintedPairID = nil
    }

    private static func trimmedRecentItemIDs(_ ids: [String], sourceItemCount: Int) -> [String] {
        let retainedCount = min(max(sourceItemCount - PracticeMatchRound.pairCount, 0), PracticeMatchRound.pairCount * 3)
        guard retainedCount > 0 else {
            return []
        }

        return Array(ids.suffix(retainedCount))
    }
}

private enum PracticeMatchDismissalTarget {
    case hub
    case originRoute
}

private struct PracticeMatchRootView: View {
    @ObservedObject var intentStore: LocalUserIntentStore
    let isActive: Bool
    let scrollToTopTrigger: Int
    let requestedStartID: Int?
    let requestedSourceID: String?
    let requestedMode: PracticeMode?
    let topContentClearance: CGFloat
    let presentationStyle: PracticePresentationStyle
    let photoBackdropState: AdminRootPhotoBackdropState
    let isPhotoBackdropVisible: Bool
    let onBrowseTapped: () -> Void
    let onDismiss: () -> Void
    let onCloseToOrigin: () -> Void
    let onPresentationChanged: (Bool) -> Void

    @State private var loadState = PracticeMatchDataState.loading
    @State private var loadGeneration = 0
    @State private var activeSession: PracticeMatchActiveSession?
    @State private var activeSessionDismissalTarget = PracticeMatchDismissalTarget.hub
    @State private var handledRequestedKey: String?

    var body: some View {
        ZStack {
            if presentationStyle == .route && !usesPhotoBackdrop {
                PhrasePageStyle.pageBackground
                    .ignoresSafeArea()
            } else {
                Color.clear
                    .ignoresSafeArea()
            }

            if PracticeMatchPresentationPolicy.showsHubLayer(
                style: presentationStyle,
                hasActiveSession: activeSession != nil
            ) {
                practiceHub
                    .allowsHitTesting(activeSession == nil)
                    .accessibilityHidden(activeSession != nil)
            }

            if let activeSession {
                PracticeMatchRoundView(
                    session: activeSession,
                    intentStore: intentStore,
                    sourceOptions: sourceOptions,
                    topContentClearance: topContentClearance,
                    presentationStyle: presentationStyle,
                    onClose: closeActiveSession,
                    onDismiss: dismissActiveSession,
                    onPreviousRound: returnToPreviousRound,
                    onSelectSource: selectSource,
                    onSelectPrompt: selectPrompt,
                    onSelectAnswer: selectAnswer,
                    onHint: revealHint,
                    onContinue: continuePractice
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1)
            }
        }
        .task {
            reloadSnapshotIfNeeded()
        }
        .onChange(of: isActive) { _, active in
            guard active else { return }
            reloadSnapshotIfNeeded()
        }
        .onChange(of: isPresentingMatch) { _, isPresented in
            onPresentationChanged(isPresented)
        }
        .onChange(of: intentStore.savedPageIDs) { _, _ in
            reloadSnapshotIfNeeded()
        }
        .onChange(of: intentStore.practicePageIDs) { _, _ in
            reloadSnapshotIfNeeded()
        }
        .onChange(of: requestedMode) { _, _ in
            startRequestedModeIfPossible()
        }
        .onChange(of: requestedSourceID) { _, _ in
            startRequestedModeIfPossible()
        }
        .onChange(of: requestedStartID) { _, _ in
            startRequestedModeIfPossible()
        }
        .onChange(of: scrollToTopTrigger) { _, _ in
            activeSession = nil
            activeSessionDismissalTarget = .hub
        }
        .onAppear {
            onPresentationChanged(isPresentingMatch)
        }
        .onDisappear {
            onPresentationChanged(false)
        }
        .accessibilityHidden(!isActive)
        .accessibilityIdentifier("Practice.Match.Root")
    }

    @ViewBuilder
    private var practiceHub: some View {
        let hub = PracticeMatchHubView(
            state: loadState,
            topContentClearance: presentationStyle == .route ? topContentClearance : 0,
            usesPhotoBackdrop: usesPhotoBackdrop,
            onStartSource: { startSource($0, dismissalTarget: .hub) },
            onBrowseTapped: onBrowseTapped,
            onRetry: reloadSnapshotIfNeeded
        )

        if PracticeMatchPresentationPolicy.showsDirectStartCard(
            style: presentationStyle,
            hasRequestedStart: requestedKey != nil,
            hasActiveSession: activeSession != nil
        ) {
            PracticeMatchPullUpCard(
                initialDetent: .medium,
                onDismiss: onDismiss
            ) {
                PracticeMatchDirectStartCard(
                    state: loadState,
                    requestedSourceTitle: requestedSourceTitle,
                    onRetry: reloadSnapshotIfNeeded,
                    onDismiss: onDismiss
                )
            }
        } else if presentationStyle == .pullUpOverlay {
            PracticeMatchPullUpCard(
                initialDetent: .medium,
                onDismiss: onDismiss
            ) {
                hub
            }
        } else if usesPhotoBackdrop {
            AdminPhotoBackdropSurfaceView(
                surface: .practice,
                backdropImageName: photoBackdropState.imageName,
                activationToken: photoBackdropState.activationToken,
                isActive: isActive && activeSession == nil,
                isVisible: isPhotoBackdropVisible && activeSession == nil,
                scrollToTopTrigger: scrollToTopTrigger
            ) { _ in
                hub
            }
        } else {
            hub
        }
    }

    private var isPresentingMatch: Bool {
        isActive && activeSession != nil
    }

    private var usesPhotoBackdrop: Bool {
        presentationStyle == .route && isPhotoBackdropVisible && activeSession == nil
    }

    private var sourceOptions: [PracticeMatchSource] {
        loadState.snapshot?.topicSources.filter(\.canStart) ?? []
    }

    private var requestedSourceTitle: String? {
        guard let snapshot = loadState.snapshot else {
            return nil
        }

        return snapshot.source(sourceID: requestedSourceID, mode: requestedMode).title
    }

    private func reloadSnapshotIfNeeded() {
        guard PracticeMatchSnapshotLoadPolicy.shouldLoadSnapshot(isActive: isActive) else {
            return
        }

        reloadSnapshot()
    }

    private func reloadSnapshot() {
        loadGeneration += 1
        let generation = loadGeneration
        let practicePageIDs = intentStore.practicePageIDs
        let savedPageIDs = intentStore.savedPageIDs

        if loadState.snapshot == nil {
            loadState = .loading
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let snapshot = try PracticeMatchSnapshot.load(
                    practicePageIDs: practicePageIDs,
                    savedPageIDs: savedPageIDs
                )
                DispatchQueue.main.async {
                    guard generation == loadGeneration else { return }
                    loadState = .loaded(snapshot)
                    startRequestedModeIfPossible()
                }
            } catch {
                DispatchQueue.main.async {
                    guard generation == loadGeneration else { return }
                    loadState = .failed(error.localizedDescription)
                }
            }
        }
    }

    private func startRequestedModeIfPossible() {
        guard PracticeMatchSnapshotLoadPolicy.shouldHandleStartRequest(isActive: isActive) else {
            return
        }
        guard let requestKey = requestedKey else {
            return
        }
        guard handledRequestedKey != requestKey else {
            return
        }
        guard let snapshot = loadState.snapshot else {
            return
        }

        let requestedSource = snapshot.source(sourceID: requestedSourceID, mode: requestedMode)
        guard requestedSource.canStart else {
            return
        }

        handledRequestedKey = requestKey
        startSource(requestedSource, dismissalTarget: .originRoute)
    }

    private var requestedKey: String? {
        if let requestedSourceID {
            return "\(requestedStartID ?? -1):source:\(requestedSourceID)"
        }

        if let requestedMode {
            return "\(requestedStartID ?? -1):mode:\(requestedMode.rawValue)"
        }

        return nil
    }

    private func startSource(_ source: PracticeMatchSource, dismissalTarget: PracticeMatchDismissalTarget) {
        guard source.canStart, let session = PracticeMatchActiveSession(source: source) else {
            return
        }

        withAnimation(.easeInOut(duration: 0.22)) {
            activeSessionDismissalTarget = dismissalTarget
            activeSession = session
        }
    }

    private func closeActiveSession() {
        let dismissalTarget = activeSessionDismissalTarget
        if presentationStyle == .pullUpOverlay, dismissalTarget == .originRoute {
            onCloseToOrigin()
            return
        }

        withAnimation(.easeInOut(duration: 0.2)) {
            activeSession = nil
            activeSessionDismissalTarget = .hub
        }

        if dismissalTarget == .originRoute {
            onCloseToOrigin()
        }
    }

    private func dismissActiveSession() {
        withAnimation(.easeInOut(duration: 0.2)) {
            activeSession = nil
            activeSessionDismissalTarget = .hub
        }
        onDismiss()
    }

    private func returnToPreviousRound() {
        guard var session = activeSession, session.returnToPreviousRound() else {
            return
        }

        withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) {
            activeSession = session
        }
    }

    private func selectSource(_ source: PracticeMatchSource) {
        guard source.canStart, let session = PracticeMatchActiveSession(source: source) else {
            return
        }

        withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) {
            activeSession = session
        }
    }

    private func selectPrompt(_ card: PracticeMatchCard) {
        guard var session = activeSession, !session.matchedPairIDs.contains(card.pairID), !session.isRoundComplete else {
            return
        }

        session.selectedPromptID = card.id
        activeSession = session
        resolveSelectionIfReady()
    }

    private func selectAnswer(_ card: PracticeMatchCard) {
        guard var session = activeSession, !session.matchedPairIDs.contains(card.pairID), !session.isRoundComplete else {
            return
        }

        session.selectedAnswerID = card.id
        activeSession = session
        resolveSelectionIfReady()
    }

    private func resolveSelectionIfReady() {
        guard var session = activeSession,
              let promptID = session.selectedPromptID,
              let answerID = session.selectedAnswerID,
              let prompt = session.round.prompts.first(where: { $0.id == promptID }),
              let answer = session.round.answers.first(where: { $0.id == answerID })
        else {
            return
        }

        if prompt.pairID == answer.pairID {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                session.matchedPairIDs.insert(prompt.pairID)
                session.hintedPairID = session.hintedPairID == prompt.pairID ? nil : session.hintedPairID
                session.selectedPromptID = nil
                session.selectedAnswerID = nil
                activeSession = session
            }
        } else {
            session.incorrectPromptID = prompt.id
            session.incorrectAnswerID = answer.id
            activeSession = session

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.62) {
                guard var current = activeSession,
                      current.round.id == session.round.id,
                      current.incorrectPromptID == prompt.id,
                      current.incorrectAnswerID == answer.id
                else {
                    return
                }

                withAnimation(.easeOut(duration: 0.16)) {
                    current.selectedPromptID = nil
                    current.selectedAnswerID = nil
                    current.incorrectPromptID = nil
                    current.incorrectAnswerID = nil
                    activeSession = current
                }
            }
        }
    }

    private func revealHint() {
        guard var session = activeSession, !session.isRoundComplete else {
            return
        }

        let hintedPairID: String?
        if let selectedPromptID = session.selectedPromptID,
           let prompt = session.round.prompts.first(where: { $0.id == selectedPromptID }),
           !session.matchedPairIDs.contains(prompt.pairID) {
            hintedPairID = prompt.pairID
        } else {
            hintedPairID = session.round.pairs.first { pair in
                !session.matchedPairIDs.contains(pair.id)
            }?.id
        }

        withAnimation(.spring(response: 0.24, dampingFraction: 0.86)) {
            session.hintedPairID = hintedPairID
            activeSession = session
        }
    }

    private func continuePractice() {
        guard var session = activeSession, session.advanceToNextRound() else {
            closeActiveSession()
            return
        }

        withAnimation(.easeInOut(duration: 0.22)) {
            activeSession = session
        }
    }
}

private struct PracticeMatchDirectStartCard: View {
    let state: PracticeMatchDataState
    let requestedSourceTitle: String?
    let onRetry: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            PracticeMatchSheetHandle()
                .padding(.top, 12)

            HStack {
                Spacer(minLength: 0)

                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .frame(width: 44, height: 44)
                        .background(PhrasePageStyle.elevatedCardFill, in: Circle())
                        .overlay {
                            Circle()
                                .stroke(.white.opacity(AppSurfaceDepth.controlStrokeOpacity), lineWidth: 1)
                        }
                        .softAmbientCardShadow()
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close practice")
                .accessibilityIdentifier("Practice.Match.DirectStart.Close")
            }
            .padding(.horizontal, PracticeLayout.horizontalPadding + AppBackSwipeGesturePolicy.edgeStartWidth)
            .padding(.top, 12)

            Spacer(minLength: 0)

            VStack(spacing: 14) {
                switch state {
                case .loading:
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(1.1)

                    Text("Preparing practice rounds...")
                        .font(.headline.weight(.black))
                        .foregroundStyle(.primary)

                    Text("Getting the cards ready.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)

                case .failed(let message):
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.orange)

                    Text("Practice is unavailable")
                        .font(.headline.weight(.black))
                        .foregroundStyle(.primary)

                    Text(message)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Button("Retry", action: onRetry)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.red)

                case .loaded:
                    Image(systemName: "square.stack.3d.up.slash")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.red)

                    Text("Not enough practice-ready items")
                        .font(.headline.weight(.black))
                        .foregroundStyle(.primary)

                    Text(unavailableMessage)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: 290)
            .padding(.horizontal, PracticeLayout.horizontalPadding)
            .accessibilityIdentifier("Practice.Match.DirectStart.Status")

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            PracticeMatchSheetBackground(
                source: PracticeMatchSource.placeholder,
                isComplete: false
            )
        }
    }

    private var unavailableMessage: String {
        if let requestedSourceTitle {
            return "\(requestedSourceTitle) needs at least four playable items."
        }

        return "This round needs at least four playable items."
    }
}

private struct PracticeMatchHubView: View {
    let state: PracticeMatchDataState
    let topContentClearance: CGFloat
    let usesPhotoBackdrop: Bool
    let onStartSource: (PracticeMatchSource) -> Void
    let onBrowseTapped: () -> Void
    let onRetry: () -> Void

    @ViewBuilder
    var body: some View {
        Group {
            if usesPhotoBackdrop {
                contentStack
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    contentStack
                }
            }
        }
        .accessibilityIdentifier("Practice.Match.Hub")
    }

    private var contentStack: some View {
        VStack(alignment: .leading, spacing: 22) {
            PracticeMatchHero()

            switch state {
            case .loading:
                PracticeLoadingCard()
            case .failed(let message):
                PracticeErrorCard(message: message, onRetry: onRetry)
            case .loaded(let snapshot):
                PracticeMatchQuickSection(
                    quickSource: snapshot.quickSource,
                    practiceSource: snapshot.practiceSource,
                    savedSource: snapshot.savedSource,
                    onStartSource: onStartSource,
                    onBrowseTapped: onBrowseTapped
                )

                PracticeMatchTopicList(
                    sources: snapshot.topicSources,
                    onStartSource: onStartSource
                )
            }
        }
        .padding(.horizontal, PracticeLayout.horizontalPadding)
        .padding(.top, (usesPhotoBackdrop ? 18 : 22) + topContentClearance)
        .padding(.bottom, HomeLayout.bottomChromeContentClearance)
    }
}

private struct PracticeMatchHero: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Practice")
                .font(.system(size: 42, weight: .black, design: .rounded))
                .foregroundStyle(.primary)

            Text("Short matching rounds from the phrasebook.")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct PracticeMatchQuickSection: View {
    let quickSource: PracticeMatchSource
    let practiceSource: PracticeMatchSource
    let savedSource: PracticeMatchSource
    let onStartSource: (PracticeMatchSource) -> Void
    let onBrowseTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            PracticeMatchSourceCard(
                source: quickSource,
                title: "Quick practice",
                subtitle: "Start with common Vietnam phrases.",
                actionTitle: "Start",
                onTap: { onStartSource(quickSource) }
            )

            if practiceSource.canStart {
                PracticeMatchSourceCard(
                    source: practiceSource,
                    title: practiceSource.title,
                    subtitle: practiceSource.subtitle,
                    actionTitle: "Start",
                    onTap: { onStartSource(practiceSource) }
                )
            } else {
                PracticeMatchPracticeEmptyCard(
                    practiceCount: practiceSource.items.count,
                    onBrowseTapped: onBrowseTapped
                )
            }

            if savedSource.canStart {
                PracticeMatchSourceCard(
                    source: savedSource,
                    title: savedSource.title,
                    subtitle: savedSource.subtitle,
                    actionTitle: "Start",
                    onTap: { onStartSource(savedSource) }
                )
            } else {
                PracticeMatchSavedEmptyCard(
                    savedCount: savedSource.items.count,
                    onBrowseTapped: onBrowseTapped
                )
            }
        }
    }
}

private struct PracticeMatchTopicList: View {
    let sources: [PracticeMatchSource]
    let onStartSource: (PracticeMatchSource) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Practice by topic")
                .font(.title2.weight(.black))
                .foregroundStyle(.primary)

            VStack(spacing: 10) {
                ForEach(sources.filter(\.canStart)) { source in
                    Button {
                        onStartSource(source)
                    } label: {
                        HStack(spacing: 12) {
                            PracticeIcon(symbolName: source.symbolName, tint: source.tint, size: 44)

                            VStack(alignment: .leading, spacing: 3) {
                                Text(source.title)
                                    .font(.headline.weight(.bold))
                                    .foregroundStyle(.primary)

                                Text(source.itemCountLabel)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }
                            .layoutPriority(1)

                            Image(systemName: "chevron.right")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.secondary.opacity(0.62))
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .phraseListCard(cornerRadius: 18)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("Practice.Match.Topic.\(source.id)")
                }
            }
        }
    }
}

private struct PracticeMatchSourceCard: View {
    let source: PracticeMatchSource
    let title: String
    let subtitle: String
    let actionTitle: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                PracticeIcon(symbolName: source.symbolName, tint: source.tint, size: 56)

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.headline.weight(.black))
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)

                    Text(source.itemCountLabel)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(source.tint.color)
                }
                .layoutPriority(1)

                Text(actionTitle)
                    .font(.caption.weight(.black))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .frame(height: 34)
                    .background(Color.red, in: Capsule(style: .continuous))
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [source.tint.color.opacity(0.12), .white.opacity(0.72)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 22, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(.white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: 1)
            }
            .softAmbientCardShadow()
        }
        .buttonStyle(.plain)
        .disabled(!source.canStart)
        .accessibilityIdentifier("Practice.Match.Source.\(source.id)")
    }
}

private struct PracticeMatchPracticeEmptyCard: View {
    let practiceCount: Int
    let onBrowseTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                PracticeIcon(symbolName: "bookmark.fill", tint: .red, size: 52)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Add phrases to practice")
                        .font(.headline.weight(.black))
                        .foregroundStyle(.primary)

                    Text("Use Browse practice entries to build a focused matching pool.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .layoutPriority(1)
            }

            Button(action: onBrowseTapped) {
                Text(practiceCount == 0 ? "Go to Browse" : "\(practiceCount) added · Go to Browse")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.red, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .phraseListCard(cornerRadius: 22)
    }
}

private struct PracticeMatchSavedEmptyCard: View {
    let savedCount: Int
    let onBrowseTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                PracticeIcon(symbolName: "heart.fill", tint: .red, size: 52)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Practice Saved")
                        .font(.headline.weight(.black))
                        .foregroundStyle(.primary)

                    Text("Save 4 phrases, foods, or drinks to start a trip round.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .layoutPriority(1)
            }

            Button(action: onBrowseTapped) {
                Text(savedCount == 0 ? "Browse Vietnam" : "\(savedCount) saved · Browse Vietnam")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.red, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .phraseListCard(cornerRadius: 22)
    }
}

private struct PracticeMatchRoundView: View {
    let session: PracticeMatchActiveSession
    @ObservedObject var intentStore: LocalUserIntentStore
    let sourceOptions: [PracticeMatchSource]
    let topContentClearance: CGFloat
    let presentationStyle: PracticePresentationStyle
    let onClose: () -> Void
    let onDismiss: () -> Void
    let onPreviousRound: () -> Void
    let onSelectSource: (PracticeMatchSource) -> Void
    let onSelectPrompt: (PracticeMatchCard) -> Void
    let onSelectAnswer: (PracticeMatchCard) -> Void
    let onHint: () -> Void
    let onContinue: () -> Void

    @State private var isTopicPickerPresented = false

    var body: some View {
        if PracticeMatchPresentationPolicy.usesPullUpRoundCard(for: presentationStyle) {
            PracticeMatchPullUpCard(
                initialDetent: .medium,
                onDismiss: pullUpDismissAction
            ) {
                roundContent(topHandlePadding: 12)
            }
            .accessibilityIdentifier("Practice.Match.Round")
        } else {
            roundContent(topHandlePadding: max(8, topContentClearance + 8))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .background {
                    PracticeMatchAtmosphereBackground(
                        source: session.source,
                        isComplete: session.isRoundComplete
                    )
                }
                .accessibilityIdentifier("Practice.Match.Round")
        }
    }

    private var pullUpDismissAction: () -> Void {
        presentationStyle == .route ? onClose : onDismiss
    }

    private func roundContent(topHandlePadding: CGFloat) -> some View {
        VStack(spacing: 0) {
            if session.isRoundComplete {
                PracticeMatchCompletionView(
                    session: session,
                    intentStore: intentStore,
                    topContentClearance: presentationStyle == .route ? topContentClearance : 0,
                    onContinue: onContinue
                )
                    .background {
                        PracticeMatchAtmosphereBackground(
                            source: session.source,
                            isComplete: true
                        )
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            } else {
                ZStack(alignment: .top) {
                    VStack(spacing: 12) {
                        PracticeMatchSheetHandle()
                            .padding(.top, topHandlePadding)

                        PracticeMatchRoundHeader(
                            session: session,
                            isTopicPickerPresented: $isTopicPickerPresented,
                            onClose: onClose,
                            onPreviousRound: onPreviousRound
                        )

                        VStack(spacing: 7) {
                            Text("Match the pairs")
                                .font(.system(size: 27, weight: .black, design: .rounded))
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)

                            Text(session.round.mode.instruction)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .padding(.top, 2)

                        PracticeMatchBoardView(
                            session: session,
                            onSelectPrompt: onSelectPrompt,
                            onSelectAnswer: onSelectAnswer
                        )

                        Button(action: onHint) {
                            Label("Need a hint?", systemImage: "lightbulb.fill")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(Color(red: 0.72, green: 0.44, blue: 0.05))
                                .padding(.horizontal, 16)
                                .frame(height: 38)
                                .nativeGlass(
                                    cornerRadius: 19,
                                    tint: session.source.atmosphere.glow.opacity(0.34),
                                    interactive: true
                                )
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .accessibilityIdentifier("Practice.Match.Hint")

                        if session.hintedPairID != nil {
                            PracticeMatchHintNotice()
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, PracticeLayout.horizontalPadding)
                    .padding(.bottom, 12)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .background {
                        PracticeMatchSheetBackground(source: session.source, isComplete: false)
                    }

                    if isTopicPickerPresented {
                        PracticeMatchTopicPickerOverlay(
                            currentSourceID: session.source.id,
                            sources: sourceOptions,
                            onDismiss: {
                                withAnimation(.spring(response: 0.24, dampingFraction: 0.88)) {
                                    isTopicPickerPresented = false
                                }
                            },
                            onSelectSource: { source in
                                withAnimation(.spring(response: 0.24, dampingFraction: 0.88)) {
                                    isTopicPickerPresented = false
                                }
                                onSelectSource(source)
                            }
                        )
                        .padding(.top, max(88, topHandlePadding + 80))
                        .transition(.opacity.combined(with: .scale(scale: 0.98, anchor: .top)))
                        .zIndex(2)
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

private enum PracticeMatchPullUpDetent: Equatable {
    case medium
    case expanded

    func height(for size: CGSize, safeAreaInsets: EdgeInsets) -> CGFloat {
        let safeTop = safeAreaInsets.top
        let maxHeight = max(size.height - max(safeTop + 42, 74), 520)
        let mediumHeight = min(max(size.height * 0.72, 584), maxHeight)

        switch self {
        case .medium:
            return mediumHeight
        case .expanded:
            return maxHeight
        }
    }
}

private struct PracticeMatchPullUpCard<Content: View>: View {
    let initialDetent: PracticeMatchPullUpDetent
    let onDismiss: () -> Void
    @ViewBuilder var content: () -> Content

    @State private var detent: PracticeMatchPullUpDetent
    @State private var dragTranslation: CGFloat = 0

    init(
        initialDetent: PracticeMatchPullUpDetent,
        onDismiss: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.initialDetent = initialDetent
        self.onDismiss = onDismiss
        self.content = content
        _detent = State(initialValue: initialDetent)
    }

    var body: some View {
        GeometryReader { proxy in
            let height = detent.height(for: proxy.size, safeAreaInsets: proxy.safeAreaInsets)
            let downwardDrag = max(0, dragTranslation)

            ZStack(alignment: .bottom) {
                Color.black.opacity(PracticeMatchPullUpMetrics.backdropOpacity)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture(perform: onDismiss)
                    .accessibilityIdentifier("Practice.Match.Backdrop")

                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .frame(width: proxy.size.width, height: height, alignment: .top)
                    .clipShape(cardShape)
                    .contentShape(cardShape)
                    .offset(y: downwardDrag)
                    .animation(.spring(response: 0.32, dampingFraction: 0.88), value: detent)
                    .highPriorityGesture(cardDragGesture())
                    .overlay(alignment: .top) {
                        ZStack {
                            Color.black.opacity(0.001)

                            PracticeMatchPanGestureSurface(
                                onChanged: { translation in
                                    updateDragTranslation(translation)
                                },
                                onEnded: { translation, predictedTranslation in
                                    settleDrag(
                                        translation: translation,
                                        predictedTranslation: predictedTranslation
                                    )
                                    dragTranslation = 0
                                }
                            )
                        }
                        .frame(height: 28)
                        .contentShape(Rectangle())
                        .accessibilityElement(children: .ignore)
                        .accessibilityIdentifier("Practice.Match.PullHandle")
                    }
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottom)
            .contentShape(Rectangle())
        }
        .ignoresSafeArea(edges: [.horizontal, .bottom])
    }

    private var cardShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            cornerRadii: RectangleCornerRadii(
                topLeading: 32,
                bottomLeading: 0,
                bottomTrailing: 0,
                topTrailing: 32
            ),
            style: .continuous
        )
    }

    private func cardDragGesture() -> some Gesture {
        DragGesture(minimumDistance: 8, coordinateSpace: .local)
            .onChanged { value in
                updateDragTranslation(value.translation.height)
            }
            .onEnded { value in
                settleDrag(
                    translation: value.translation.height,
                    predictedTranslation: value.predictedEndTranslation.height
                )
                dragTranslation = 0
            }
    }

    private func updateDragTranslation(_ translation: CGFloat) {
        let downwardTranslation = max(0, translation)
        dragTranslation = downwardTranslation

        if detent == .medium, downwardTranslation > 120 {
            dragTranslation = 0
            onDismiss()
        }
    }

    private func settleDrag(translation: CGFloat, predictedTranslation: CGFloat) {
        let isDownwardDismissal = translation > 44 || predictedTranslation > 70
        let shouldDismiss = detent == .medium && isDownwardDismissal

        if shouldDismiss {
            onDismiss()
            return
        }

        withAnimation(.spring(response: 0.32, dampingFraction: 0.88)) {
            if translation < -70 {
                detent = .expanded
            } else if isDownwardDismissal {
                detent = .medium
            } else {
                detent = initialDetent
            }
        }
    }
}

private struct PracticeMatchPanGestureSurface: UIViewRepresentable {
    let onChanged: (CGFloat) -> Void
    let onEnded: (CGFloat, CGFloat) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onChanged: onChanged, onEnded: onEnded)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true

        let recognizer = UIPanGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handlePan(_:))
        )
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)

        let swipeRecognizer = UISwipeGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleSwipeDown(_:))
        )
        swipeRecognizer.direction = .down
        swipeRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeRecognizer)

        context.coordinator.view = view
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.onChanged = onChanged
        context.coordinator.onEnded = onEnded
        context.coordinator.view = uiView
    }

    final class Coordinator: NSObject {
        var onChanged: (CGFloat) -> Void
        var onEnded: (CGFloat, CGFloat) -> Void
        weak var view: UIView?

        init(onChanged: @escaping (CGFloat) -> Void, onEnded: @escaping (CGFloat, CGFloat) -> Void) {
            self.onChanged = onChanged
            self.onEnded = onEnded
        }

        @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
            guard let view else {
                return
            }

            let translation = recognizer.translation(in: view).y
            let velocity = recognizer.velocity(in: view).y
            let predictedTranslation = translation + velocity * 0.12

            switch recognizer.state {
            case .began, .changed:
                onChanged(translation)
            case .ended, .cancelled, .failed:
                onEnded(translation, predictedTranslation)
            default:
                break
            }
        }

        @objc func handleSwipeDown(_ recognizer: UISwipeGestureRecognizer) {
            guard recognizer.state == .ended else {
                return
            }

            onEnded(160, 220)
        }
    }
}

private struct PracticeMatchAtmosphereBackground: View {
    let source: PracticeMatchSource
    let isComplete: Bool

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image(source.atmosphere.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                    .blur(radius: isComplete ? 10 : 18)
                    .saturation(isComplete ? 1.08 : 0.92)
                    .opacity(isComplete ? 0.88 : 0.66)

                Rectangle()
                    .fill(.ultraThinMaterial)
                    .opacity(isComplete ? 0.22 : 0.36)

                LinearGradient(
                    colors: [
                        Color.black.opacity(isComplete ? 0.34 : 0.18),
                        source.atmosphere.surface.opacity(isComplete ? 0.08 : 0.32),
                        Color.black.opacity(isComplete ? 0.18 : 0.05),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                RadialGradient(
                    colors: [
                        source.atmosphere.glow.opacity(isComplete ? 0.34 : 0.18),
                        Color.clear,
                    ],
                    center: .topTrailing,
                    startRadius: 8,
                    endRadius: max(proxy.size.width, proxy.size.height) * 0.8
                )

                if isComplete {
                    PracticeMatchCelebrationField(tint: source.atmosphere.glow)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
    }
}

private struct PracticeMatchCelebrationField: View {
    let tint: Color

    private struct Particle: Identifiable {
        let id: Int
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let opacity: Double
    }

    private static let particles: [Particle] = [
        Particle(id: 0, x: 0.14, y: 0.16, size: 5, opacity: 0.56),
        Particle(id: 1, x: 0.30, y: 0.12, size: 3, opacity: 0.42),
        Particle(id: 2, x: 0.77, y: 0.17, size: 6, opacity: 0.58),
        Particle(id: 3, x: 0.89, y: 0.27, size: 4, opacity: 0.50),
        Particle(id: 4, x: 0.20, y: 0.38, size: 4, opacity: 0.36),
        Particle(id: 5, x: 0.66, y: 0.36, size: 5, opacity: 0.44),
        Particle(id: 6, x: 0.82, y: 0.48, size: 3, opacity: 0.40),
        Particle(id: 7, x: 0.11, y: 0.58, size: 6, opacity: 0.34),
        Particle(id: 8, x: 0.44, y: 0.62, size: 4, opacity: 0.30),
        Particle(id: 9, x: 0.72, y: 0.70, size: 5, opacity: 0.32),
    ]

    var body: some View {
        GeometryReader { proxy in
            ForEach(Self.particles) { particle in
                Circle()
                    .fill(particle.id.isMultiple(of: 2) ? tint : Color.white)
                    .frame(width: particle.size, height: particle.size)
                    .position(
                        x: proxy.size.width * particle.x,
                        y: proxy.size.height * particle.y
                    )
                    .opacity(particle.opacity)
                    .shadow(color: tint.opacity(0.36), radius: 8, x: 0, y: 0)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

private struct PracticeMatchSheetBackground: View {
    let source: PracticeMatchSource
    let isComplete: Bool

    private var shape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            cornerRadii: RectangleCornerRadii(
                topLeading: 32,
                bottomLeading: 0,
                bottomTrailing: 0,
                topTrailing: 32
            ),
            style: .continuous
        )
    }

    var body: some View {
        ZStack {
            shape
                .fill(.regularMaterial)

            shape
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(isComplete ? 0.94 : 0.98),
                            PhrasePageStyle.pageBackground.opacity(isComplete ? 0.88 : 0.96),
                            Color.white.opacity(isComplete ? 0.82 : 0.92),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            shape
                .stroke(.white.opacity(0.54), lineWidth: 0.8)
        }
        .shadow(color: Color.black.opacity(0.10), radius: 30, x: 0, y: -10)
        .padding(.horizontal, PracticeMatchPullUpMetrics.sheetHorizontalBackgroundPadding)
        .ignoresSafeArea(edges: .bottom)
    }
}

private struct PracticeMatchRoundHeader: View {
    let session: PracticeMatchActiveSession
    @Binding var isTopicPickerPresented: Bool
    let onClose: () -> Void
    let onPreviousRound: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button(action: onPreviousRound) {
                    Image(systemName: "chevron.left")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(session.canReturnToPreviousRound ? Color.primary : Color.secondary.opacity(0.55))
                        .frame(width: 44, height: 44)
                        .background(PhrasePageStyle.elevatedCardFill, in: Circle())
                        .overlay {
                            Circle()
                                .stroke(.white.opacity(AppSurfaceDepth.controlStrokeOpacity), lineWidth: 1)
                        }
                        .softAmbientCardShadow()
                }
                .frame(width: 44, height: 44)
                .contentShape(Circle())
                .buttonStyle(.plain)
                .disabled(!session.canReturnToPreviousRound)
                .accessibilityLabel("Previous round")
                .accessibilityIdentifier("Practice.Match.PreviousRound")
                .padding(.leading, AppBackSwipeGesturePolicy.edgeStartWidth)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.24, dampingFraction: 0.88)) {
                        isTopicPickerPresented.toggle()
                    }
                } label: {
                    HStack(spacing: 7) {
                        Image(systemName: session.source.symbolName)
                            .font(.caption.weight(.black))
                            .foregroundStyle(session.source.tint.color)

                        Text(session.source.title)
                            .font(.subheadline.weight(.black))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.72)

                        Image(systemName: "chevron.down")
                            .font(.caption.weight(.black))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 34)
                    .background(PhrasePageStyle.elevatedCardFill, in: Capsule(style: .continuous))
                    .overlay {
                        Capsule(style: .continuous)
                            .stroke(.white.opacity(AppSurfaceDepth.controlStrokeOpacity), lineWidth: 1)
                    }
                    .softAmbientCardShadow()
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Change practice topic")
                .accessibilityIdentifier("Practice.Match.TopicPicker")

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .frame(width: 44, height: 44)
                        .background(PhrasePageStyle.elevatedCardFill, in: Circle())
                        .overlay {
                            Circle()
                                .stroke(.white.opacity(AppSurfaceDepth.controlStrokeOpacity), lineWidth: 1)
                        }
                        .softAmbientCardShadow()
                }
                .frame(width: 44, height: 44)
                .contentShape(Circle())
                .buttonStyle(.plain)
                .accessibilityLabel("Close practice")
                .accessibilityIdentifier("Practice.Match.Close")
                .padding(.trailing, AppBackSwipeGesturePolicy.edgeStartWidth)
            }

            PracticeMatchProgressDots(
                matchedCount: session.matchedPairIDs.count,
                totalCount: PracticeMatchRound.pairCount,
                tint: session.source.atmosphere.tint
            )

            Text(session.round.mode.badgeLabel)
                .font(.caption2.weight(.black))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
                .frame(height: 22)
                .background(session.source.atmosphere.tint.opacity(0.08), in: Capsule(style: .continuous))
                .accessibilityIdentifier("Practice.Match.ModeBadge")
        }
        .padding(.horizontal, 14)
    }
}

private struct PracticeMatchTopicPickerOverlay: View {
    let currentSourceID: String
    let sources: [PracticeMatchSource]
    let onDismiss: () -> Void
    let onSelectSource: (PracticeMatchSource) -> Void

    private var panelHeight: CGFloat {
        CGFloat(sources.count) * 58 + CGFloat(max(sources.count - 1, 0)) + 12
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.opacity(0.10)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.regularMaterial)

                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.white.opacity(0.74))

                VStack(spacing: 0) {
                    ForEach(sources) { source in
                        Button {
                            onSelectSource(source)
                        } label: {
                            HStack(spacing: 12) {
                                PracticeIcon(symbolName: source.symbolName, tint: source.tint, size: 38)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(source.title)
                                        .font(.headline.weight(.black))
                                        .foregroundStyle(.primary)
                                        .lineLimit(1)

                                    Text(source.itemCountLabel)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                }
                                .layoutPriority(1)

                                if source.id == currentSourceID {
                                    Image(systemName: "checkmark")
                                        .font(.headline.weight(.black))
                                        .foregroundStyle(.primary)
                                }
                            }
                            .padding(.horizontal, 12)
                            .frame(height: 58)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                source.id == currentSourceID ? source.atmosphere.tint.opacity(0.10) : Color.clear,
                                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                            )
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("Practice.Match.TopicOption.\(source.id)")

                        if source.id != sources.last?.id {
                            Divider()
                                .padding(.leading, 62)
                                .opacity(0.42)
                        }
                    }
                }
                .padding(6)
            }
            .frame(width: 300, height: panelHeight)
            .overlay(alignment: .top) {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(.regularMaterial)
                    .frame(width: 18, height: 18)
                    .rotationEffect(.degrees(45))
                    .offset(y: -8)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(.white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: 1)
            }
            .softAmbientCardShadow()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

private struct PracticeMatchProgressDots: View {
    let matchedCount: Int
    let totalCount: Int
    let tint: Color

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalCount, id: \.self) { index in
                Circle()
                    .fill(index < matchedCount ? tint : Color.black.opacity(0.13))
                    .frame(width: 8, height: 8)
                    .overlay {
                        Circle()
                            .stroke(.white.opacity(index < matchedCount ? 0.6 : 0), lineWidth: 1)
                    }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(matchedCount) matched")
        .accessibilityAddTraits(.isStaticText)
        .accessibilityIdentifier("Practice.Match.ProgressDots")
    }
}

private struct PracticeMatchSheetHandle: View {
    var body: some View {
        Capsule(style: .continuous)
            .fill(Color.black.opacity(0.12))
            .frame(width: 46, height: 5)
            .frame(maxWidth: .infinity)
            .accessibilityHidden(true)
    }
}

private struct PracticeMatchBoardView: View {
    let session: PracticeMatchActiveSession
    let onSelectPrompt: (PracticeMatchCard) -> Void
    let onSelectAnswer: (PracticeMatchCard) -> Void

    private let columnSpacing: CGFloat = 16
    private var cardHeight: CGFloat { session.round.mode.requiresImage ? 86 : 64 }
    private var cardSpacing: CGFloat { session.round.mode.requiresImage ? 12 : 10 }
    private var boardHeight: CGFloat {
        CGFloat(PracticeMatchRound.pairCount) * cardHeight
            + CGFloat(PracticeMatchRound.pairCount - 1) * cardSpacing
    }

    var body: some View {
        ZStack(alignment: .top) {
            PracticeMatchConnectionLayer(
                session: session,
                cardHeight: cardHeight,
                cardSpacing: cardSpacing,
                columnSpacing: columnSpacing
            )
            .allowsHitTesting(false)

            HStack(alignment: .top, spacing: columnSpacing) {
                VStack(spacing: cardSpacing) {
                    ForEach(session.round.prompts) { card in
                        PracticeMatchCardButton(
                            card: card,
                            mode: session.round.mode,
                            state: cardState(card),
                            height: cardHeight,
                            onTap: { onSelectPrompt(card) }
                        )
                    }
                }

                VStack(spacing: cardSpacing) {
                    ForEach(session.round.answers) { card in
                        PracticeMatchCardButton(
                            card: card,
                            mode: session.round.mode,
                            state: cardState(card),
                            height: cardHeight,
                            onTap: { onSelectAnswer(card) }
                        )
                    }
                }
            }
        }
        .frame(height: boardHeight)
        .animation(.spring(response: 0.30, dampingFraction: 0.84), value: session.matchedPairIDs)
        .animation(.easeInOut(duration: 0.18), value: session.hintedPairID)
        .accessibilityIdentifier("Practice.Match.Board")
    }

    private func cardState(_ card: PracticeMatchCard) -> PracticeMatchCardVisualState {
        if session.matchedPairIDs.contains(card.pairID) {
            return .matched
        }
        if session.incorrectPromptID == card.id || session.incorrectAnswerID == card.id {
            return .incorrect
        }
        if session.hintedPairID == card.pairID {
            return .hinted
        }
        if session.selectedPromptID == card.id || session.selectedAnswerID == card.id {
            return .selected
        }

        return .normal
    }
}

private enum PracticeMatchCardVisualState {
    case normal
    case selected
    case matched
    case incorrect
    case hinted
}

private struct PracticeMatchCardButton: View {
    let card: PracticeMatchCard
    let mode: PracticeMatchRoundMode
    let state: PracticeMatchCardVisualState
    let height: CGFloat
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                PracticeMatchCardContent(
                    card: card,
                    contentKind: contentKind,
                    textColor: textColor,
                    height: height
                )

                statusIcon
                    .padding(5)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background {
                cardSurface
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(stroke, lineWidth: state == .normal ? 1 : 1.35)
            }
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .offset(x: state == .incorrect ? -4 : 0)
            .scaleEffect(cardScale)
            .softAmbientCardShadow()
            .animation(
                state == .incorrect
                    ? .linear(duration: 0.08).repeatCount(4, autoreverses: true)
                    : .spring(response: 0.24, dampingFraction: 0.82),
                value: state
            )
        }
        .buttonStyle(.plain)
        .disabled(state == .matched)
        .accessibilityIdentifier("Practice.Match.Card.\(card.id)")
    }

    private var contentKind: PracticeMatchCardContentKind {
        mode.contentKind(for: card.side)
    }

    private var textColor: Color {
        state == .matched ? .primary.opacity(0.78) : .primary
    }

    @ViewBuilder
    private var statusIcon: some View {
        if state == .matched {
            Image(systemName: "checkmark.circle.fill")
                .font(.headline.weight(.black))
                .foregroundStyle(.green)
                .shadow(color: .green.opacity(0.22), radius: 6, x: 0, y: 2)
        } else if state == .hinted {
            Image(systemName: "lightbulb.fill")
                .font(.headline.weight(.black))
                .foregroundStyle(Color(red: 0.88, green: 0.61, blue: 0.08))
        }
    }

    @ViewBuilder
    private var cardSurface: some View {
        let shape = RoundedRectangle(cornerRadius: 16, style: .continuous)

        shape
            .fill(.ultraThinMaterial)

        shape
            .fill(
                LinearGradient(
                    colors: backgroundColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private var backgroundColors: [Color] {
        switch state {
        case .normal:
            return [
                Color.white.opacity(0.86),
                Color.white.opacity(0.66),
            ]
        case .selected:
            return [
                card.item.tint.color.opacity(0.16),
                Color.white.opacity(0.78),
            ]
        case .matched:
            return [
                Color.green.opacity(0.18),
                Color.white.opacity(0.60),
            ]
        case .incorrect:
            return [
                Color.red.opacity(0.18),
                Color.white.opacity(0.72),
            ]
        case .hinted:
            return [
                Color.yellow.opacity(0.24),
                Color.white.opacity(0.72),
            ]
        }
    }

    private var stroke: Color {
        switch state {
        case .normal:
            return .white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity)
        case .selected:
            return card.item.tint.color.opacity(0.48)
        case .matched:
            return Color.green.opacity(0.48)
        case .incorrect:
            return Color.red.opacity(0.62)
        case .hinted:
            return Color.orange.opacity(0.44)
        }
    }

    private var cardScale: CGFloat {
        switch state {
        case .selected:
            return 1.024
        case .matched:
            return 0.992
        case .incorrect:
            return 1.0
        case .hinted:
            return 1.012
        case .normal:
            return 1.0
        }
    }

}

private struct PracticeMatchCardContent: View {
    let card: PracticeMatchCard
    let contentKind: PracticeMatchCardContentKind
    let textColor: Color
    let height: CGFloat

    var body: some View {
        switch contentKind {
        case .phrase:
            HStack(spacing: 8) {
                Text(card.item.vietnamese)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(textColor)
                    .lineLimit(2)
                    .minimumScaleFactor(0.68)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                AudioSpeakerButton(
                    tint: card.item.tint,
                    size: 28,
                    audioKey: card.item.audioKey,
                    accessibilityIdentifier: "Practice.Match.Audio.\(card.item.pageID)"
                )
                .frame(width: 32)
            }
            .padding(.horizontal, 9)
            .frame(maxWidth: .infinity, minHeight: height)
        case .meaning:
            Text(card.item.english)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(textColor)
                .lineLimit(2)
                .minimumScaleFactor(0.68)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, minHeight: height, alignment: .leading)
        case .audio:
            PracticeMatchAudioPrompt(
                tint: card.item.tint,
                audioKey: card.item.audioKey,
                pageID: card.item.pageID
            )
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, minHeight: height)
        case .image:
            PracticeMatchImagePrompt(
                imageName: card.item.imageName,
                symbolName: card.item.symbolName,
                tint: card.item.tint,
                height: height
            )
            .padding(6)
            .frame(maxWidth: .infinity, minHeight: height)
        }
    }
}

private struct PracticeMatchAudioPrompt: View {
    let tint: AccentTint
    let audioKey: String
    let pageID: String

    var body: some View {
        HStack(spacing: 8) {
            AudioSpeakerButton(
                tint: tint,
                size: 34,
                audioKey: audioKey,
                accessibilityIdentifier: "Practice.Match.AudioPrompt.\(pageID)"
            )

            PracticeMatchWaveform(tint: tint)
                .frame(maxWidth: .infinity)
        }
    }
}

private struct PracticeMatchWaveform: View {
    let tint: AccentTint

    private let bars: [CGFloat] = [0.32, 0.64, 0.42, 0.82, 0.5, 0.72, 0.38, 0.58, 0.45]

    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            ForEach(Array(bars.enumerated()), id: \.offset) { _, scale in
                Capsule(style: .continuous)
                    .fill(tint.color.opacity(0.42))
                    .frame(width: 3, height: 24 * scale)
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityHidden(true)
    }
}

private struct PracticeMatchImagePrompt: View {
    let imageName: String?
    let symbolName: String
    let tint: AccentTint
    let height: CGFloat

    private var imageSize: CGFloat { max(height - 8, 52) }

    var body: some View {
        Group {
            if let imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    tint.color.opacity(0.14)

                    Image(systemName: symbolName)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(tint.color)
                }
            }
        }
        .frame(width: imageSize, height: imageSize)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .softAmbientCardShadow()
        .frame(maxWidth: .infinity)
        .frame(height: imageSize)
        .accessibilityHidden(true)
    }
}

private struct PracticeMatchConnectionLayer: View {
    let session: PracticeMatchActiveSession
    let cardHeight: CGFloat
    let cardSpacing: CGFloat
    let columnSpacing: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let columnWidth = max((proxy.size.width - columnSpacing) / 2, 1)
            Canvas { context, size in
                for pair in session.round.pairs {
                    let visual = visualStyle(for: pair.id)
                    guard visual.shouldDraw,
                          let promptIndex = session.round.prompts.firstIndex(where: { $0.pairID == pair.id }),
                          let answerIndex = session.round.answers.firstIndex(where: { $0.pairID == pair.id })
                    else {
                        continue
                    }

                    let start = CGPoint(
                        x: columnWidth - 1,
                        y: centerY(for: promptIndex)
                    )
                    let end = CGPoint(
                        x: columnWidth + columnSpacing + 1,
                        y: centerY(for: answerIndex)
                    )
                    var path = Path()
                    path.move(to: start)
                    let controlOffset = max(columnSpacing * 0.7, 16)
                    path.addCurve(
                        to: end,
                        control1: CGPoint(x: start.x + controlOffset, y: start.y),
                        control2: CGPoint(x: end.x - controlOffset, y: end.y)
                    )
                    context.stroke(
                        path,
                        with: .color(visual.color.opacity(0.22)),
                        style: StrokeStyle(
                            lineWidth: visual.lineWidth + 5,
                            lineCap: .round,
                            dash: visual.dash
                        )
                    )
                    context.stroke(
                        path,
                        with: .color(visual.color),
                        style: StrokeStyle(
                            lineWidth: visual.lineWidth,
                            lineCap: .round,
                            dash: visual.dash
                        )
                    )
                }
            }
        }
    }

    private func centerY(for index: Int) -> CGFloat {
        CGFloat(index) * (cardHeight + cardSpacing) + (cardHeight / 2)
    }

    private func visualStyle(for pairID: String) -> PracticeMatchConnectionVisual {
        if session.matchedPairIDs.contains(pairID) {
            return PracticeMatchConnectionVisual(
                shouldDraw: true,
                color: .green.opacity(0.72),
                lineWidth: 2.4,
                dash: []
            )
        }

        if session.hintedPairID == pairID {
            return PracticeMatchConnectionVisual(
                shouldDraw: true,
                color: .orange.opacity(0.66),
                lineWidth: 2.0,
                dash: [5, 7]
            )
        }

        return PracticeMatchConnectionVisual(
            shouldDraw: false,
            color: .clear,
            lineWidth: 0,
            dash: []
        )
    }
}

private struct PracticeMatchConnectionVisual {
    let shouldDraw: Bool
    let color: Color
    let lineWidth: CGFloat
    let dash: [CGFloat]
}

private struct PracticeMatchHintNotice: View {
    var body: some View {
        Label("One pair is softly highlighted.", systemImage: "lightbulb.fill")
            .font(.subheadline.weight(.bold))
            .foregroundStyle(Color(red: 0.70, green: 0.46, blue: 0.08))
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.yellow.opacity(0.28), lineWidth: 1)
            }
    }
}

private struct PracticeMatchCompletionView: View {
    let session: PracticeMatchActiveSession
    @ObservedObject var intentStore: LocalUserIntentStore
    let topContentClearance: CGFloat
    let onContinue: () -> Void

    @State private var rewardPulse = false

    var body: some View {
        VStack(spacing: 12) {
            PracticeMatchRewardIcon(
                tint: session.source.atmosphere.glow,
                isActive: rewardPulse
            )
            .padding(.top, max(46, topContentClearance + 34))

            VStack(spacing: 6) {
                Text("Nice match!")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.20), radius: 8, x: 0, y: 4)

                Text("You matched all 4 pairs.")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.88))
                    .multilineTextAlignment(.center)
            }

            Spacer(minLength: 0)

            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("You matched")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.top, 10)
                        .padding(.bottom, 4)

                    ForEach(session.round.pairs) { pair in
                        PracticeMatchCompletionRow(pair: pair, intentStore: intentStore)

                        if pair.id != session.round.pairs.last?.id {
                            Divider()
                                .padding(.leading, 68)
                                .opacity(0.42)
                        }
                    }
                }
                .background(.white.opacity(0.30), in: RoundedRectangle(cornerRadius: 18, style: .continuous))

                Button(action: onContinue) {
                    Text("Next round")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                colors: [Color.red, Color(red: 1.0, green: 0.31, blue: 0.20)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("Practice.Match.Continue")
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(.white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: 1)
            }
            .softAmbientCardShadow()
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.spring(response: 0.46, dampingFraction: 0.70).delay(0.04)) {
                rewardPulse = true
            }
        }
        .accessibilityIdentifier("Practice.Match.Complete")
    }
}

private struct PracticeMatchRewardIcon: View {
    let tint: Color
    let isActive: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(tint.opacity(0.22))
                .frame(width: 102, height: 102)
                .scaleEffect(isActive ? 1.12 : 0.84)
                .opacity(isActive ? 0.52 : 0.22)

            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.green.opacity(0.96),
                            Color(red: 0.60, green: 0.84, blue: 0.32),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 76, height: 76)
                .overlay {
                    Circle()
                        .stroke(.white.opacity(0.78), lineWidth: 2)
                }
                .shadow(color: Color.green.opacity(0.32), radius: 18, x: 0, y: 8)

            Image(systemName: "checkmark")
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .scaleEffect(isActive ? 1.0 : 0.72)
        }
        .animation(.spring(response: 0.46, dampingFraction: 0.70), value: isActive)
        .accessibilityHidden(true)
    }
}

private struct PracticeMatchCompletionRow: View {
    let pair: PracticeMatchPair
    @ObservedObject var intentStore: LocalUserIntentStore

    var body: some View {
        HStack(spacing: 10) {
            PracticeMatchSummaryThumbnail(item: pair.item)

            VStack(alignment: .leading, spacing: 3) {
                Text(pair.item.vietnamese)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.76)

                Text(pair.item.english)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.76)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 4) {
                AudioSpeakerButton(
                    tint: pair.item.tint,
                    size: 26,
                    audioKey: pair.item.audioKey,
                    accessibilityIdentifier: "Practice.Match.Complete.Audio.\(pair.item.pageID)"
                )
                .frame(width: 34, height: 34)

                PracticeMatchSaveButton(
                    isSaved: intentStore.isPageSaved(pair.item.pageID),
                    pageID: pair.item.pageID,
                    onTap: { intentStore.toggleSavedPage(pair.item.pageID) }
                )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
    }
}

private struct PracticeMatchSummaryThumbnail: View {
    let item: PracticeMatchItem

    var body: some View {
        Group {
            if let imageName = item.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    item.tint.color.opacity(0.14)

                    Image(systemName: item.symbolName)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(item.tint.color)
                }
            }
        }
        .frame(width: 48, height: 48)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(.white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: 1)
        }
        .accessibilityHidden(true)
    }
}

private struct PracticeMatchSaveButton: View {
    let isSaved: Bool
    let pageID: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Image(systemName: isSaved ? "heart.fill" : "heart")
                .font(.subheadline.weight(.black))
                .foregroundStyle(.red)
                .frame(width: 34, height: 34)
                .background(PhrasePageStyle.elevatedCardFill, in: Circle())
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isSaved ? "Remove from Saved" : "Save to My Trip")
        .accessibilityIdentifier("Practice.Match.Complete.Save.\(pageID)")
    }
}

#Preview {
    PracticeView(
        intentStore: LocalUserIntentStore(),
        onOpenDetail: { _ in },
        onBrowseTapped: {}
    )
}
