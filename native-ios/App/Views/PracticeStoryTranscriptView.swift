import SwiftUI

struct PracticeStoryTranscriptView: View {
    let turns: [PracticeStoryTurn]
    let tint: AccentTint
    let isInPracticePool: (String) -> Bool
    let isSavedPhrasePage: (String) -> Bool
    let onOpenPhrasePage: (String) -> Void
    let onTogglePracticePage: (String) -> Void
    let onToggleSavedPhrasePage: (String) -> Void

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
                        isSavedPhrasePage: isSavedPhrasePage,
                        onOpenPhrasePage: onOpenPhrasePage,
                        onTogglePracticePage: onTogglePracticePage,
                        onToggleSavedPhrasePage: onToggleSavedPhrasePage
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
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: 12)
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
    let isSavedPhrasePage: (String) -> Bool
    let onOpenPhrasePage: (String) -> Void
    let onTogglePracticePage: (String) -> Void
    let onToggleSavedPhrasePage: (String) -> Void

    private var isTraveler: Bool {
        turn.role == .travelerReply
    }

    private var pageID: String? {
        turn.source?.pageID
    }

    private var hasPhraseActions: Bool {
        pageID != nil
    }

    private var playbackAudioKey: String? {
        turn.playbackAudioKey
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isTraveler {
                Spacer(minLength: 52)
            }

            VStack(alignment: isTraveler ? .trailing : .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    if !isTraveler, playbackAudioKey != nil {
                        AudioSpeakerButton(
                            tint: tint,
                            size: 38,
                            audioKey: playbackAudioKey,
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
                                .accessibilityIdentifier("Practice.Story.Text.\(isTraveler ? "traveler" : "local").\(turn.id).vietnamese")
                        }

                        if let english = turn.english, !english.isEmpty {
                            Text(english)
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(isTraveler ? .white.opacity(0.82) : .secondary)
                                .multilineTextAlignment(isTraveler ? .trailing : .leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .accessibilityIdentifier("Practice.Story.Text.\(isTraveler ? "traveler" : "local").\(turn.id).english")
                        }
                    }

                    if isTraveler, playbackAudioKey != nil {
                        AudioSpeakerButton(
                            tint: .red,
                            size: 38,
                            audioKey: playbackAudioKey,
                            accessibilityIdentifier: "Practice.Story.Audio.\(turn.id)"
                        )
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(maxWidth: 302, alignment: isTraveler ? .trailing : .leading)
            .background(bubbleFill, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay {
                if !isTraveler {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(.white.opacity(0.72), lineWidth: 1)
                }
            }
            .compositingGroup()
            .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("Practice.Story.Bubble.\(isTraveler ? "traveler" : "local").\(turn.stepID)")
            .contextMenu {
                if let pageID, hasPhraseActions {
                    Button {
                        onToggleSavedPhrasePage(pageID)
                    } label: {
                        Label(
                            isSavedPhrasePage(pageID) ? "Remove from Saved Phrases" : "Save to Saved Phrases",
                            systemImage: isSavedPhrasePage(pageID) ? "bookmark.slash" : "bookmark"
                        )
                    }

                    Button {
                        onOpenPhrasePage(pageID)
                    } label: {
                        Label("Open Phrase Page", systemImage: "doc.text.magnifyingglass")
                    }
                }
            }

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
        guard let selectedOptionID else {
            return nil
        }

        return options.first { $0.id == selectedOptionID }
    }

    private var selectedOptionID: String? {
        if let pendingOptionID, options.contains(where: { $0.id == pendingOptionID }) {
            return pendingOptionID
        }

        return options.first?.id
    }

    private var canSend: Bool {
        pendingOption != nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            selectedPhraseBar

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 10) {
                    ForEach(options) { option in
                        PracticeStoryChoiceChip(
                            option: option,
                            isSelected: option.id == selectedOptionID,
                            onSelect: { pendingOptionID = option.id }
                        )
                    }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 2)
            }
            .scrollClipDisabled()
        }
        .padding(.horizontal, 14)
        .padding(.top, 14)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.90), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.78), lineWidth: 1)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("Practice.Story.Composer")
    }

    private var selectedPhraseBar: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(pendingOption?.scenarioVietnamese ?? "")
                .font(.system(size: 23, weight: .regular))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityIdentifier("Practice.Story.SelectedPhrase")

            Spacer(minLength: 8)

            Button(action: {
                if let pendingOption {
                    onSend(pendingOption)
                }
            }) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 21, weight: .heavy))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(canSend ? Color(red: 0.07, green: 0.50, blue: 1.0) : Color.secondary.opacity(0.32))
                    )
            }
            .buttonStyle(.plain)
            .disabled(!canSend)
            .accessibilityLabel("Send phrase")
            .accessibilityIdentifier("Practice.Story.Send")
        }
        .padding(.leading, 18)
        .padding(.trailing, 10)
        .padding(.vertical, 10)
        .frame(minHeight: 60)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color(.separator).opacity(0.22), lineWidth: 1)
        }
    }
}

private struct PracticeStoryChoiceChip: View {
    let option: PracticeScenarioResponseOption
    let isSelected: Bool
    let onSelect: () -> Void

    private var minWidth: CGFloat {
        isSelected ? 236 : 132
    }

    private var maxWidth: CGFloat {
        isSelected ? 312 : 176
    }

    var body: some View {
        Button(action: onSelect) {
            Text(option.scenarioEnglish)
                .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                .foregroundStyle(isSelected ? Color(red: 0.02, green: 0.37, blue: 0.95) : .primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .frame(minWidth: minWidth, maxWidth: maxWidth)
                .frame(minHeight: 58)
                .background(chipBackground, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(
                            isSelected ? Color(red: 0.02, green: 0.37, blue: 0.95) : Color(.separator).opacity(0.34),
                            lineWidth: isSelected ? 2 : 1
                        )
                }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Practice.Story.Choice.\(option.id)")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    }

    private var chipBackground: some ShapeStyle {
        isSelected
            ? AnyShapeStyle(Color.white.opacity(0.98))
            : AnyShapeStyle(Color.white.opacity(0.96))
    }
}
