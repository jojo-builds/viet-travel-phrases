import SwiftUI

struct PracticeMessagesThreadHost: View {
    let activeScenarioSession: PracticeScenarioSession?
    let scenarioCompletion: PracticeScenarioCompletionSummary?
    let isInPracticePool: (String) -> Bool
    let onOpenPhrasePage: (String) -> Void
    let onTogglePracticePage: (String) -> Void
    let onSelectScenarioOption: (PracticeScenarioResponseOption, PracticeScenarioStep) -> Void
    let onPracticeAnother: () -> Void
    let onBackToPractice: () -> Void
    let onBrowseTapped: () -> Void
    let onDismiss: () -> Void

    private var scenario: PracticeScenario? {
        activeScenarioSession?.scenario ?? scenarioCompletion?.scenario
    }

    var body: some View {
        ZStack {
            PhrasePageStyle.pageBackground
            .ignoresSafeArea()

            VStack(spacing: 0) {
                if let scenario {
                    PracticeMessagesThreadHeader(
                        scenario: scenario,
                        onBack: onDismiss
                    )
                }

                PracticeMessagesThreadContent(
                    activeScenarioSession: activeScenarioSession,
                    scenarioCompletion: scenarioCompletion,
                    isInPracticePool: isInPracticePool,
                    onOpenPhrasePage: onOpenPhrasePage,
                    onTogglePracticePage: onTogglePracticePage,
                    onSelectScenarioOption: onSelectScenarioOption,
                    onPracticeAnother: onPracticeAnother,
                    onBackToPractice: onBackToPractice,
                    onBrowseTapped: onBrowseTapped
                )
            }
        }
        .accessibilityIdentifier("Practice.Messages.Thread")
    }
}

private struct PracticeMessagesThreadHeader: View {
    let scenario: PracticeScenario
    let onBack: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(width: 64, height: 64)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .background(.white.opacity(0.74), in: Circle())
                .accessibilityLabel("Back to Messages")
                .accessibilityIdentifier("Practice.Messages.Back")

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)

            VStack(spacing: 0) {
                PracticeMessageAvatar(
                    scenarioID: scenario.id,
                    size: 86,
                    showsSymbol: true
                )
                .padding(.top, 6)
                .offset(y: 22)
                .zIndex(1)

                VStack(spacing: 2) {
                    HStack(spacing: 6) {
                        Text(scenario.id.messageContactName)
                            .font(.system(size: 25, weight: .bold))
                            .foregroundStyle(.primary)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.secondary)
                    }

                    Text(scenario.id.messageLocation)
                        .font(.callout.weight(.medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)
                }
                .padding(.horizontal, 22)
                .padding(.top, 34)
                .padding(.bottom, 14)
                .background(.white.opacity(0.76), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(.white.opacity(0.8), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.06), radius: 18, x: 0, y: 8)
            }
            .frame(maxWidth: 260)
        }
        .frame(height: 176, alignment: .top)
        .accessibilityIdentifier("Practice.Messages.ThreadHeader")
    }
}

struct PracticeMessagesThreadContent: View {
    let activeScenarioSession: PracticeScenarioSession?
    let scenarioCompletion: PracticeScenarioCompletionSummary?
    let isInPracticePool: (String) -> Bool
    let onOpenPhrasePage: (String) -> Void
    let onTogglePracticePage: (String) -> Void
    let onSelectScenarioOption: (PracticeScenarioResponseOption, PracticeScenarioStep) -> Void
    let onPracticeAnother: () -> Void
    let onBackToPractice: () -> Void
    let onBrowseTapped: () -> Void

    var body: some View {
        Group {
            if let activeScenarioSession, let currentStep = activeScenarioSession.currentStep {
                PracticeStorySessionSurface(
                    session: activeScenarioSession,
                    showsHeader: false,
                    isInPracticePool: isInPracticePool,
                    onOpenPhrasePage: onOpenPhrasePage,
                    onTogglePracticePage: onTogglePracticePage,
                    onSelectOption: { option in onSelectScenarioOption(option, currentStep) }
                )
            } else if let scenarioCompletion {
                ScrollView(.vertical, showsIndicators: false) {
                    PracticeStoryCompletionSurface(
                        summary: scenarioCompletion,
                        onPracticeAnother: onPracticeAnother,
                        onBackToPractice: onBackToPractice,
                        onBrowseTapped: onBrowseTapped
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 22)
                    .padding(.bottom, 28)
                }
            } else {
                EmptyView()
            }
        }
    }
}

struct PracticeStorySessionSurface: View {
    let session: PracticeScenarioSession
    var showsHeader = true
    let isInPracticePool: (String) -> Bool
    let onOpenPhrasePage: (String) -> Void
    let onTogglePracticePage: (String) -> Void
    let onSelectOption: (PracticeScenarioResponseOption) -> Void

    private static let transcriptBottomID = "Practice.Story.Transcript.Bottom"

    private var turns: [PracticeStoryTurn] {
        PracticeStoryTranscript.turns(
            for: session.scenario,
            currentIndex: session.currentIndex,
            selectedOptionIDs: session.selectedOptionIDs,
            revealedReplyStepIDs: session.revealedReplyStepIDs
        )
    }

    var body: some View {
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

            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        PracticeStoryTranscriptView(
                            turns: turns,
                            tint: session.scenario.id.tint,
                            isInPracticePool: isInPracticePool,
                            onOpenPhrasePage: onOpenPhrasePage,
                            onTogglePracticePage: onTogglePracticePage
                        )

                        Color.clear
                            .frame(height: 1)
                            .id(Self.transcriptBottomID)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, showsHeader ? 6 : 4)
                    .padding(.bottom, 18)
                }
                .onAppear {
                    scrollToBottom(scrollProxy, animated: false)
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
                        PhrasePageStyle.pageBackground.opacity(0.10),
                        PhrasePageStyle.pageBackground,
                        PhrasePageStyle.pageBackground,
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

    private func scrollToBottom(_ proxy: ScrollViewProxy, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
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

    var body: some View {
        if let currentStep, currentSelectedOption == nil {
            PracticeStoryComposer(
                step: currentStep,
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
                .background(.white.opacity(0.62), in: Circle())
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
                    .background(.white.opacity(0.7), in: Circle())

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
            .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
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
                .background(.white.opacity(0.62), in: Capsule())

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
