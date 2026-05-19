import SwiftUI

enum PracticeStorySessionStartPosition: Equatable {
    case top

    var stackAlignment: Alignment {
        .top
    }
}

enum PracticeStorySessionLayoutPolicy {
    static func startPosition(for session: PracticeScenarioSession) -> PracticeStorySessionStartPosition {
        .top
    }

    static func shouldScrollToBottomOnAppear(for session: PracticeScenarioSession) -> Bool {
        session.currentIndex > 0
            || !session.selectedOptionIDs.isEmpty
            || !session.revealedReplyStepIDs.isEmpty
    }
}

struct PracticeStoryReturnFocusRequest: Equatable {
    let id: Int
    let turnID: String
}

struct PracticeMessagesThreadHost: View {
    let activeScenarioSession: PracticeScenarioSession?
    let scenarioCompletion: PracticeScenarioCompletionSummary?
    let returnFocusRequest: PracticeStoryReturnFocusRequest?
    let isInPracticePool: (String) -> Bool
    let isSavedPhrasePage: (String) -> Bool
    let onOpenPhrasePage: PracticeStoryOpenPhrasePageAction
    let onTogglePracticePage: (String) -> Void
    let onToggleSavedPhrasePage: (String) -> Void
    let onSelectScenarioOption: (PracticeScenarioResponseOption, PracticeScenarioStep) -> Void
    let onPracticeAnother: () -> Void
    let onBackToPractice: () -> Void
    let onBrowseTapped: () -> Void
    let onDismiss: () -> Void
    let onReturnFocusConsumed: () -> Void

    private var scenario: PracticeScenario? {
        activeScenarioSession?.scenario ?? scenarioCompletion?.scenario
    }

    var body: some View {
        GeometryReader { proxy in
            let pageWidth = max(proxy.size.width, 1)

            ZStack(alignment: .top) {
                PhrasePageStyle.pageBackground
                    .ignoresSafeArea()

                PracticeMessagesThreadContent(
                    activeScenarioSession: activeScenarioSession,
                    scenarioCompletion: scenarioCompletion,
                    returnFocusRequest: returnFocusRequest,
                    topContentPadding: scenario == nil ? 0 : PracticeMessagesThreadHeaderLayout.contentClearance,
                    isInPracticePool: isInPracticePool,
                    isSavedPhrasePage: isSavedPhrasePage,
                    onOpenPhrasePage: onOpenPhrasePage,
                    onTogglePracticePage: onTogglePracticePage,
                    onToggleSavedPhrasePage: onToggleSavedPhrasePage,
                    onSelectScenarioOption: onSelectScenarioOption,
                    onPracticeAnother: onPracticeAnother,
                    onBackToPractice: onBackToPractice,
                    onBrowseTapped: onBrowseTapped,
                    onReturnFocusConsumed: onReturnFocusConsumed
                )

                threadBackSwipeCaptureEdge(width: pageWidth)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .zIndex(AppChromeLayout.searchForegroundMorphZIndex)

                if let scenario {
                    PracticeMessagesThreadHeader(
                        scenario: scenario
                    )
                    .zIndex(AppChromeLayout.searchForegroundMorphZIndex)

                    PracticeMessagesThreadBackButton(action: onDismiss)
                        .padding(.leading, AppChromeLayout.topAdminHorizontalPadding)
                        .padding(.top, AppChromeLayout.topAdminTopPadding)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .zIndex(AppChromeLayout.searchForegroundMorphZIndex + 1)
                }

                threadAccessibilityMarker
            }
        }
    }

    private var threadAccessibilityMarker: some View {
        Text("Messages thread")
            .font(.caption2)
            .frame(width: 1, height: 1)
            .opacity(0.001)
            .allowsHitTesting(false)
            .accessibilityIdentifier("Practice.Messages.Thread")
            .accessibilityLabel("Messages thread")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func threadBackSwipeCaptureEdge(width: CGFloat) -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: AppBackSwipeGesturePolicy.edgeStartWidth)
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(threadBackSwipeGesture(width: width))
            .accessibilityHidden(true)
    }

    private func threadBackSwipeGesture(width: CGFloat) -> some Gesture {
        DragGesture(
            minimumDistance: AppBackSwipeGesturePolicy.minimumDistance,
            coordinateSpace: .local
        )
        .onEnded { value in
            guard AppBackSwipeGesturePolicy.shouldCommitBackSwipe(
                translation: value.translation,
                predictedEndTranslation: value.predictedEndTranslation,
                width: width
            ) else {
                return
            }

            onDismiss()
        }
    }
}

private enum PracticeMessagesThreadHeaderLayout {
    static let height: CGFloat = AppChromeLayout.topAdminHitTestEnvelopeHeight
    static let backdropHeight: CGFloat = AppChromeLayout.topSeparationHeight + 38
    static let controlSize: CGFloat = AppChromeLayout.topAdminControlSize
    static let avatarSize: CGFloat = 62
    static let contentClearance: CGFloat = 128
    static let nameCapsuleHeight: CGFloat = 28
}

private struct PracticeMessagesThreadHeader: View {
    let scenario: PracticeScenario

    var body: some View {
        headerControls
            .padding(.horizontal, AppChromeLayout.topAdminHorizontalPadding)
            .padding(.top, AppChromeLayout.topAdminTopPadding)
            .frame(height: PracticeMessagesThreadHeaderLayout.height, alignment: .top)
            .background(alignment: .top) {
                LinearGradient(
                    colors: [
                        PhrasePageStyle.pageBackground.opacity(0.96),
                        PhrasePageStyle.pageBackground.opacity(0.72),
                        PhrasePageStyle.pageBackground.opacity(0.0),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: PracticeMessagesThreadHeaderLayout.backdropHeight)
                .ignoresSafeArea(edges: .top)
                .allowsHitTesting(false)
            }
    }

    @ViewBuilder
    private var headerControls: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: 18) {
                controlRow
            }
        } else {
            controlRow
        }
    }

    private var controlRow: some View {
        HStack(alignment: .top, spacing: 0) {
            Color.clear
                .frame(
                    width: PracticeMessagesThreadHeaderLayout.controlSize,
                    height: PracticeMessagesThreadHeaderLayout.controlSize
                )
                .accessibilityHidden(true)

            Spacer(minLength: 0)

            PracticeMessagesThreadProfileControl(scenario: scenario)

            Spacer(minLength: 0)

            Color.clear
                .frame(
                    width: PracticeMessagesThreadHeaderLayout.controlSize,
                    height: PracticeMessagesThreadHeaderLayout.controlSize
                )
                .accessibilityHidden(true)
        }
    }
}

private struct PracticeMessagesThreadBackButton: View {
    let action: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppChromeLayout.topAdminControlCornerRadius, style: .continuous)
                .fill(.white.opacity(0.62))

            Image(systemName: "chevron.left")
                .font(.system(size: 23, weight: .semibold))
                .foregroundStyle(.primary)
        }
        .frame(
            width: PracticeMessagesThreadHeaderLayout.controlSize,
            height: PracticeMessagesThreadHeaderLayout.controlSize
        )
        .overlay {
            RoundedRectangle(cornerRadius: AppChromeLayout.topAdminControlCornerRadius, style: .continuous)
                .stroke(.white.opacity(0.78), lineWidth: 1)
        }
        .softAmbientCardShadow(opacity: 0.045, radius: 12, y: 6)
        .contentShape(RoundedRectangle(cornerRadius: AppChromeLayout.topAdminControlCornerRadius, style: .continuous))
        .onTapGesture(perform: action)
        .accessibilityElement()
        .accessibilityLabel("Back to Messages")
        .accessibilityIdentifier("Practice.Messages.Back")
        .accessibilityAddTraits(.isButton)
    }
}

private struct PracticeMessagesThreadProfileControl: View {
    let scenario: PracticeScenario

    var body: some View {
        VStack(spacing: 5) {
            PracticeMessageAvatar(
                scenarioID: scenario.id,
                size: PracticeMessagesThreadHeaderLayout.avatarSize,
                showsSymbol: true
            )

            Text(scenario.id.messageContactName)
                .font(.system(size: 14, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.78)
                .padding(.horizontal, 11)
                .frame(height: PracticeMessagesThreadHeaderLayout.nameCapsuleHeight)
                .nativeGlass(
                    cornerRadius: PracticeMessagesThreadHeaderLayout.nameCapsuleHeight / 2,
                    tint: .white.opacity(0.34)
                )
        }
        .frame(maxWidth: 150)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(scenario.id.messageContactName), \(scenario.id.messageLocation)")
    }
}

struct PracticeMessagesThreadContent: View {
    let activeScenarioSession: PracticeScenarioSession?
    let scenarioCompletion: PracticeScenarioCompletionSummary?
    let returnFocusRequest: PracticeStoryReturnFocusRequest?
    let topContentPadding: CGFloat
    let isInPracticePool: (String) -> Bool
    let isSavedPhrasePage: (String) -> Bool
    let onOpenPhrasePage: PracticeStoryOpenPhrasePageAction
    let onTogglePracticePage: (String) -> Void
    let onToggleSavedPhrasePage: (String) -> Void
    let onSelectScenarioOption: (PracticeScenarioResponseOption, PracticeScenarioStep) -> Void
    let onPracticeAnother: () -> Void
    let onBackToPractice: () -> Void
    let onBrowseTapped: () -> Void
    let onReturnFocusConsumed: () -> Void

    var body: some View {
        Group {
            if let activeScenarioSession, let currentStep = activeScenarioSession.currentStep {
                PracticeStorySessionSurface(
                    session: activeScenarioSession,
                    showsHeader: false,
                    returnFocusRequest: returnFocusRequest,
                    topContentPadding: topContentPadding,
                    isInPracticePool: isInPracticePool,
                    isSavedPhrasePage: isSavedPhrasePage,
                    onOpenPhrasePage: onOpenPhrasePage,
                    onTogglePracticePage: onTogglePracticePage,
                    onToggleSavedPhrasePage: onToggleSavedPhrasePage,
                    onSelectOption: { option in onSelectScenarioOption(option, currentStep) },
                    onReturnFocusConsumed: onReturnFocusConsumed
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            } else if let scenarioCompletion {
                ScrollView(.vertical, showsIndicators: false) {
                    PracticeStoryCompletionSurface(
                        summary: scenarioCompletion,
                        onPracticeAnother: onPracticeAnother,
                        onBackToPractice: onBackToPractice,
                        onBrowseTapped: onBrowseTapped
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, topContentPadding + 22)
                    .padding(.bottom, 28)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            } else {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct PracticeStorySessionSurface: View {
    let session: PracticeScenarioSession
    var showsHeader = true
    var returnFocusRequest: PracticeStoryReturnFocusRequest?
    var topContentPadding: CGFloat = 0
    let isInPracticePool: (String) -> Bool
    let isSavedPhrasePage: (String) -> Bool
    let onOpenPhrasePage: PracticeStoryOpenPhrasePageAction
    let onTogglePracticePage: (String) -> Void
    let onToggleSavedPhrasePage: (String) -> Void
    let onSelectOption: (PracticeScenarioResponseOption) -> Void
    let onReturnFocusConsumed: () -> Void
    @State private var scrollRequestID = 0
    @State private var handledReturnFocusRequestID: Int?
    @State private var selectedDefinitionToken: PracticeStoryDefinitionToken?

    private static let transcriptBottomID = "Practice.Story.Transcript.Bottom"
    private static let scrollDelayNanoseconds: UInt64 = 50_000_000

    private var turns: [PracticeStoryTurn] {
        PracticeStoryTranscript.turns(
            for: session.scenario,
            currentIndex: session.currentIndex,
            selectedOptionIDs: session.selectedOptionIDs,
            revealedReplyStepIDs: session.revealedReplyStepIDs
        )
    }

    private var startPosition: PracticeStorySessionStartPosition {
        PracticeStorySessionLayoutPolicy.startPosition(for: session)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            if selectedDefinitionToken != nil {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedDefinitionToken = nil
                    }
                    .zIndex(0)
            }

            VStack(alignment: .leading, spacing: 0) {
                if showsHeader {
                    PracticeStoryHeader(
                        scenario: session.scenario,
                        isPlacement: session.context == .placement
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    .padding(.bottom, 14)
                }

                GeometryReader { geometry in
                    ScrollViewReader { scrollProxy in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 0) {
                                PracticeStoryTranscriptView(
                                    turns: turns,
                                    tint: session.scenario.id.tint,
                                    isInPracticePool: isInPracticePool,
                                    isSavedPhrasePage: isSavedPhrasePage,
                                    onOpenPhrasePage: onOpenPhrasePage,
                                    onTogglePracticePage: onTogglePracticePage,
                                    onToggleSavedPhrasePage: onToggleSavedPhrasePage,
                                    selectedDefinitionToken: $selectedDefinitionToken
                                )

                                Color.clear
                                    .frame(height: 1)
                                    .id(Self.transcriptBottomID)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, topContentPadding + (showsHeader ? 6 : 4))
                            .padding(.bottom, 18)
                            .frame(
                                maxWidth: .infinity,
                                minHeight: geometry.size.height,
                                alignment: startPosition.stackAlignment
                            )
                        }
                        .onAppear {
                            if scrollToReturnFocusIfNeeded(scrollProxy, animated: false) {
                                return
                            }

                            if PracticeStorySessionLayoutPolicy.shouldScrollToBottomOnAppear(for: session) {
                                scrollToBottom(scrollProxy, animated: false)
                            }
                        }
                        .onChange(of: returnFocusRequest) { _, _ in
                            _ = scrollToReturnFocusIfNeeded(scrollProxy, animated: false)
                        }
                        .onChange(of: session.currentIndex) { _, _ in
                            scrollToBottom(scrollProxy, animated: true)
                        }
                        .onChange(of: session.selectedOptionIDs) { _, _ in
                            scrollToBottom(scrollProxy, animated: true)
                        }
                        .onChange(of: session.revealedReplyStepIDs) { _, _ in
                            scrollToBottom(scrollProxy, animated: true)
                        }
                    }
                }
            }
            .zIndex(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .simultaneousGesture(
            TapGesture().onEnded {
                if selectedDefinitionToken != nil {
                    selectedDefinitionToken = nil
                }
            }
        )
        .safeAreaInset(edge: .bottom, spacing: 0) {
            PracticeStoryComposerSurface(
                session: session,
                onSelectOption: onSelectOption
            )
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 14)
            .background {
                LinearGradient(
                    colors: [
                        PhrasePageStyle.pageBackground.opacity(0.0),
                        PhrasePageStyle.pageBackground.opacity(0.34),
                        PhrasePageStyle.pageBackground.opacity(0.62),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("Practice.Story.Session")
    }

    @discardableResult
    private func scrollToReturnFocusIfNeeded(_ proxy: ScrollViewProxy, animated: Bool) -> Bool {
        guard
            let returnFocusRequest,
            handledReturnFocusRequestID != returnFocusRequest.id
        else {
            return false
        }

        handledReturnFocusRequestID = returnFocusRequest.id

        guard turns.contains(where: { $0.id == returnFocusRequest.turnID }) else {
            onReturnFocusConsumed()
            return false
        }

        scrollRequestID += 1
        let requestID = scrollRequestID

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: Self.scrollDelayNanoseconds)
            guard requestID == scrollRequestID else {
                return
            }

            if animated {
                withAnimation(.easeOut(duration: 0.24)) {
                    proxy.scrollTo(returnFocusRequest.turnID, anchor: .center)
                }
            } else {
                proxy.scrollTo(returnFocusRequest.turnID, anchor: .center)
            }
            onReturnFocusConsumed()
        }

        return true
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy, animated: Bool) {
        scrollRequestID += 1
        let requestID = scrollRequestID

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: Self.scrollDelayNanoseconds)
            guard requestID == scrollRequestID else {
                return
            }

            if animated {
                withAnimation(.easeOut(duration: 0.24)) {
                    proxy.scrollTo(Self.transcriptBottomID, anchor: .bottom)
                }
            } else {
                proxy.scrollTo(Self.transcriptBottomID, anchor: .bottom)
            }
        }
    }
}

struct PracticeStoryComposerSurface: View {
    let session: PracticeScenarioSession
    let onSelectOption: (PracticeScenarioResponseOption) -> Void

    private var currentStep: PracticeScenarioStep? {
        session.currentStep
    }

    private var currentSelectedOption: PracticeScenarioResponseOption? {
        guard
            let currentStep,
            let selectedOptionID = session.selectedOptionIDs[currentStep.id]
        else {
            return nil
        }

        return currentStep.responseOptions.first { $0.id == selectedOptionID }
    }

    private var currentResponseOptions: [PracticeScenarioResponseOption] {
        guard let currentStep else {
            return []
        }

        return session.scenario.visibleResponseOptions(
            for: currentStep,
            selectedOptionIDs: session.selectedOptionIDs
        )
    }

    var body: some View {
        if let currentStep, currentSelectedOption == nil {
            PracticeStoryComposer(
                step: currentStep,
                responseOptions: currentResponseOptions,
                onSend: onSelectOption
            )
            .id(currentStep.id)
        }
    }
}

private struct PracticeStoryHeader: View {
    let scenario: PracticeScenario
    let isPlacement: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: scenario.id.symbolName)
                .font(.headline.weight(.bold))
                .foregroundStyle(scenario.id.tint.color)
                .frame(width: 44, height: 44)
                .background(PhrasePageStyle.glassCardFill, in: Circle())
                .overlay {
                    Circle().stroke(.white.opacity(0.7), lineWidth: 1)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text("MESSAGES")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(scenario.title)
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)

                Text(scenario.sceneSetup)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
    }
}

struct PracticeStoryCompletionSurface: View {
    let summary: PracticeScenarioCompletionSummary
    let onPracticeAnother: () -> Void
    let onBackToPractice: () -> Void
    let onBrowseTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: "checkmark.message.fill")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.green)
                    .frame(width: 64, height: 64)
                    .background(PhrasePageStyle.elevatedCardFill, in: Circle())

                Text("Conversation complete")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(.primary)
                    .accessibilityIdentifier("Practice.Story.Complete")

                Text("You sent \(summary.practicedCount) useful replies in this thread.")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(PhrasePageStyle.cardFill, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(.white.opacity(0.74), lineWidth: 1)
            }

            VStack(spacing: 10) {
                Button(action: onPracticeAnother) {
                    Label("Restart conversation", systemImage: "arrow.clockwise")
                        .font(.headline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.white)
                .background(summary.scenario.id.tint.color, in: Capsule())

                Button(action: onBackToPractice) {
                    Label("Back to Messages", systemImage: "text.bubble.fill")
                        .font(.subheadline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.primary)
                .background(PhrasePageStyle.glassCardFill, in: Capsule())

                Button(action: onBrowseTapped) {
                    Label("Browse phrases", systemImage: "magnifyingglass")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
        }
        .accessibilityIdentifier("Practice.Story.Completion")
    }
}
