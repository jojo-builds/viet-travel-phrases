import SwiftUI

struct PracticeStoryTranscriptView: View {
    let turns: [PracticeStoryTurn]
    let tint: AccentTint
    let isInPracticePool: (String) -> Bool
    let onOpenPhrasePage: (String) -> Void
    let onTogglePracticePage: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(turns) { turn in
                switch turn.role {
                case .scene:
                    PracticeStorySceneLine(turn: turn)
                        .id("PracticeStoryLine.\(turn.stepID)")
                case .localSpeaker, .travelerReply:
                    PracticeStoryBubble(
                        turn: turn,
                        tint: tint,
                        isInPracticePool: isInPracticePool,
                        onOpenPhrasePage: onOpenPhrasePage,
                        onTogglePracticePage: onTogglePracticePage
                    )
                    .transition(rowTransition(for: turn))
                case .localTyping:
                    PracticeStoryTypingBubble(turn: turn)
                        .transition(rowTransition(for: turn))
                case .choiceSet:
                    EmptyView()
                case .recovery:
                    EmptyView()
                case .system:
                    EmptyView()
                }
            }
        }
        .animation(.easeOut(duration: 0.24), value: turns.map(\.id))
        .accessibilityIdentifier("Practice.Story.Transcript")
    }

    private func rowTransition(for turn: PracticeStoryTurn) -> AnyTransition {
        if turn.role == .travelerReply {
            return .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .opacity
            )
        }

        return .asymmetric(
            insertion: .move(edge: .leading).combined(with: .opacity),
            removal: .opacity
        )
    }
}

private struct PracticeStorySceneLine: View {
    let turn: PracticeStoryTurn

    var body: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.16))
            .frame(maxWidth: .infinity)
            .frame(height: 1)
        .padding(.vertical, 8)
        .accessibilityLabel(turn.text ?? "Conversation break")
        .accessibilityIdentifier("Practice.Story.Scene.\(turn.stepID)")
    }
}

private struct PracticeStoryChoiceHint: View {
    let turn: PracticeStoryTurn

    var body: some View {
        if let text = turn.text, !text.isEmpty {
            Text(text)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 2)
                .accessibilityIdentifier("Practice.Story.ChoiceHint.\(turn.stepID)")
        }
    }
}

private struct PracticeStoryRecoveryLine: View {
    let turn: PracticeStoryTurn

    var body: some View {
        if let text = turn.text, !text.isEmpty {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.orange)

                Text(text)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white.opacity(0.46), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .accessibilityIdentifier("Practice.Story.Recovery.\(turn.stepID)")
        }
    }
}

private struct PracticeStoryBubble: View {
    let turn: PracticeStoryTurn
    let tint: AccentTint
    let isInPracticePool: (String) -> Bool
    let onOpenPhrasePage: (String) -> Void
    let onTogglePracticePage: (String) -> Void

    private var isTraveler: Bool {
        turn.role == .travelerReply
    }

    private var pageID: String? {
        turn.source?.pageID
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isTraveler {
                Spacer(minLength: 52)
            }

            VStack(alignment: isTraveler ? .trailing : .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    if !isTraveler, AudioSpeakerButton.isPlayableAudioKey(turn.audioKey) {
                        AudioSpeakerButton(
                            tint: tint,
                            size: 38,
                            audioKey: turn.audioKey,
                            accessibilityIdentifier: "Practice.Story.Audio.\(turn.id)"
                        )
                    }

                    VStack(alignment: isTraveler ? .trailing : .leading, spacing: 4) {
                        if let vietnamese = turn.vietnamese, !vietnamese.isEmpty {
                            Text(vietnamese)
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(isTraveler ? .white : .primary)
                                .multilineTextAlignment(isTraveler ? .trailing : .leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        if let english = turn.english, !english.isEmpty {
                            Text(english)
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(isTraveler ? .white.opacity(0.82) : .secondary)
                                .multilineTextAlignment(isTraveler ? .trailing : .leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    if isTraveler, AudioSpeakerButton.isPlayableAudioKey(turn.audioKey) {
                        AudioSpeakerButton(
                            tint: .red,
                            size: 38,
                            audioKey: turn.audioKey,
                            accessibilityIdentifier: "Practice.Story.Audio.\(turn.id)"
                        )
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(maxWidth: 302, alignment: isTraveler ? .trailing : .leading)
            .background(bubbleFill, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(.white.opacity(isTraveler ? 0.24 : 0.72), lineWidth: 1)
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("Practice.Story.Bubble.\(isTraveler ? "traveler" : "local").\(turn.stepID)")

            if !isTraveler {
                Spacer(minLength: 52)
            }
        }
        .frame(maxWidth: .infinity, alignment: isTraveler ? .trailing : .leading)
    }

    private var bubbleFill: some ShapeStyle {
        isTraveler
            ? AnyShapeStyle(Color(red: 0.07, green: 0.50, blue: 1.0).gradient)
            : AnyShapeStyle(Color(.systemGray5).opacity(0.96))
    }

    private var speakerBadge: some View {
        Image(systemName: "person.crop.circle.fill")
            .font(.system(size: 30, weight: .semibold))
            .foregroundStyle(.secondary)
            .frame(width: 34, height: 34)
            .accessibilityHidden(true)
    }

    private var detailsMenu: some View {
        Menu {
            if let pageID {
                Button("Open phrase") {
                    onOpenPhrasePage(pageID)
                }

                Button(isInPracticePool(pageID) ? "Remove from saved practice" : "Save for practice") {
                    onTogglePracticePage(pageID)
                }
            }
        } label: {
            Label("Details", systemImage: "ellipsis")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.86))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(.white.opacity(0.14), in: Capsule())
        }
    }
}

private struct PracticeStoryTypingBubble: View {
    let turn: PracticeStoryTurn
    @State private var isAnimating = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 34, height: 34)
                .accessibilityHidden(true)

            HStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color.secondary.opacity(isAnimating ? 0.42 : 0.82))
                        .frame(width: 7, height: 7)
                        .scaleEffect(isAnimating ? 0.74 : 1.08)
                        .animation(
                            .easeInOut(duration: 0.52)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.15),
                            value: isAnimating
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .background(Color.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(.white.opacity(0.68), lineWidth: 1)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Waiting for reply")
            .accessibilityIdentifier("Practice.Story.Typing.\(turn.stepID)")

            Spacer(minLength: 38)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            isAnimating = true
        }
    }
}

struct PracticeStoryComposer: View {
    let step: PracticeScenarioStep
    let onSend: (PracticeScenarioResponseOption) -> Void

    @State private var pendingOptionID: String?

    private var options: [PracticeScenarioResponseOption] {
        Array(step.responseOptions.prefix(3))
    }

    private var pendingOption: PracticeScenarioResponseOption? {
        guard let pendingOptionID else {
            return nil
        }

        return options.first { $0.id == pendingOptionID }
    }

    private var canSend: Bool {
        pendingOptionID != nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(options) { option in
                    PracticeStoryChoiceChip(
                        option: option,
                        isSelected: option.id == pendingOptionID,
                        onSelect: { pendingOptionID = option.id }
                    )
                }

                HStack {
                    Spacer()

                    Button(action: {
                        if let pendingOption {
                            onSend(pendingOption)
                        }
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundStyle(canSend ? Color(red: 0.07, green: 0.50, blue: 1.0) : Color.secondary.opacity(0.36))
                            .frame(width: 46, height: 46)
                    }
                    .buttonStyle(.plain)
                    .disabled(!canSend)
                    .accessibilityLabel("Send phrase")
                    .accessibilityIdentifier("Practice.Story.Send")
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.72), lineWidth: 1)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("Practice.Story.Composer")
    }
}

private struct PracticeStoryChoiceChip: View {
    let option: PracticeScenarioResponseOption
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(option.scenarioVietnamese)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.78)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(option.scenarioEnglish)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 8)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(isSelected ? Color(red: 0.07, green: 0.50, blue: 1.0) : Color.secondary.opacity(0.34))
            }
            .padding(.horizontal, 13)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(chipBackground, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? Color(red: 0.07, green: 0.50, blue: 1.0).opacity(0.32) : Color.white.opacity(0.68), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Practice.Story.Choice.\(option.id)")
    }

    private var chipBackground: some ShapeStyle {
        isSelected
            ? AnyShapeStyle(Color(.systemGray6).opacity(1.0))
            : AnyShapeStyle(Color(.systemGray6).opacity(0.76))
    }
}
