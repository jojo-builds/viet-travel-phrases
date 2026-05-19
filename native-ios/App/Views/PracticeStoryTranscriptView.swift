import SwiftUI

typealias PracticeStoryOpenPhrasePageAction = (_ pageID: String, _ returnTurnID: String?) -> Void

struct PracticeStoryTranscriptView: View {
    let turns: [PracticeStoryTurn]
    let tint: AccentTint
    let isInPracticePool: (String) -> Bool
    let isSavedPhrasePage: (String) -> Bool
    let onOpenPhrasePage: PracticeStoryOpenPhrasePageAction
    let onTogglePracticePage: (String) -> Void
    let onToggleSavedPhrasePage: (String) -> Void
    @Binding var selectedDefinitionToken: PracticeStoryDefinitionToken?

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
                        selectedDefinitionToken: $selectedDefinitionToken,
                        isInPracticePool: isInPracticePool,
                        isSavedPhrasePage: isSavedPhrasePage,
                        onOpenPhrasePage: onOpenPhrasePage,
                        onTogglePracticePage: onTogglePracticePage,
                        onToggleSavedPhrasePage: onToggleSavedPhrasePage
                    )
                    .id(turn.id)
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
        .frame(maxWidth: .infinity, alignment: .topLeading)
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
            .background(PhrasePageStyle.glassCardFill, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .accessibilityIdentifier("Practice.Story.Recovery.\(turn.stepID)")
        }
    }
}

private struct PracticeStoryBubble: View {
    let turn: PracticeStoryTurn
    let tint: AccentTint
    @Binding var selectedDefinitionToken: PracticeStoryDefinitionToken?
    let isInPracticePool: (String) -> Bool
    let isSavedPhrasePage: (String) -> Bool
    let onOpenPhrasePage: PracticeStoryOpenPhrasePageAction
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
        let bubbleShape = RoundedRectangle(cornerRadius: 22, style: .continuous)

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
                            PracticeStoryVietnameseLine(
                                turn: turn,
                                vietnamese: vietnamese,
                                isTraveler: isTraveler,
                                selectedToken: $selectedDefinitionToken
                            )
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
            .background(bubbleFill, in: bubbleShape)
            .overlay {
                if !isTraveler {
                    bubbleShape
                        .stroke(.white.opacity(0.72), lineWidth: 1)
                }
            }
            .compositingGroup()
            .contentShape(bubbleShape)
            .simultaneousGesture(
                TapGesture().onEnded {
                    selectedDefinitionToken = nil
                }
            )
            .contentShape(.contextMenuPreview, bubbleShape)
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
                        onOpenPhrasePage(pageID, turn.id)
                    } label: {
                        Label("Open Details", systemImage: "doc.text.magnifyingglass")
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

private struct PracticeStoryVietnameseLine: View {
    let turn: PracticeStoryTurn
    let vietnamese: String
    let isTraveler: Bool
    @Binding var selectedToken: PracticeStoryDefinitionToken?

    private var definitionTokens: [PracticeStoryDefinitionToken] {
        PracticeStoryBreakdownDefinitions.tokens(for: turn)
    }

    var body: some View {
        if definitionTokens.isEmpty {
            Text(vietnamese)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(isTraveler ? .white : .primary)
                .multilineTextAlignment(isTraveler ? .trailing : .leading)
                .fixedSize(horizontal: false, vertical: true)
        } else {
            ZStack(alignment: isTraveler ? .topTrailing : .topLeading) {
                PracticeStoryDefinitionFlowLayout(
                    horizontalSpacing: 5,
                    verticalSpacing: 4,
                    alignment: isTraveler ? .trailing : .leading
                ) {
                    ForEach(definitionTokens) { token in
                        PracticeStoryDefinitionTokenButton(
                            token: token,
                            isTraveler: isTraveler,
                            selectedToken: $selectedToken
                        )
                    }
                }
                .zIndex(1)
            }
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityElement(children: .contain)
        }
    }
}

private struct PracticeStoryDefinitionTokenButton: View {
    let token: PracticeStoryDefinitionToken
    let isTraveler: Bool
    @Binding var selectedToken: PracticeStoryDefinitionToken?

    var body: some View {
        Button {
            let nextSelection = selectedToken?.id == token.id ? nil : token
            DispatchQueue.main.async {
                selectedToken = nextSelection
            }
        } label: {
            Text(token.vietnamese)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(isTraveler ? .white : .primary)
                .lineLimit(1)
                .fixedSize()
                .padding(.bottom, 4)
                .overlay(alignment: .bottom) {
                    PracticeStoryDottedUnderline(color: underlineColor)
                        .offset(y: 1)
                }
                .overlay(alignment: .top) {
                    if selectedToken?.id == token.id {
                        PracticeStoryDefinitionCallout(token: token)
                            .offset(y: -94)
                            .transition(.opacity.combined(with: .scale(scale: 0.98, anchor: .bottom)))
                            .allowsHitTesting(false)
                            .zIndex(2)
                    }
                }
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(token.vietnamese), \(token.english)")
        .accessibilityHint("Shows meaning")
        .accessibilityIdentifier("Practice.Story.DefinitionToken.\(token.id)")
        .zIndex(selectedToken?.id == token.id ? 2 : 1)
    }

    private var underlineColor: Color {
        isTraveler
            ? .white.opacity(0.76)
            : Color(red: 0.07, green: 0.50, blue: 1.0).opacity(0.72)
    }
}

private struct PracticeStoryDefinitionCallout: View {
    let token: PracticeStoryDefinitionToken

    var body: some View {
        VStack(spacing: 0) {
            PracticeStoryDefinitionPopover(token: token)

            PracticeStoryDefinitionCalloutTail()
                .fill(PhrasePageStyle.cardFill)
                .frame(width: 28, height: 16)
                .overlay {
                    PracticeStoryDefinitionCalloutTail()
                        .stroke(.white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: 1)
                }
                .offset(y: -1)
        }
        .softAmbientCardShadow()
        .accessibilityElement(children: .contain)
    }
}

private struct PracticeStoryDefinitionPopover: View {
    let token: PracticeStoryDefinitionToken

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(token.vietnamese)
                .font(.headline.weight(.bold))
                .foregroundStyle(.primary)
                .accessibilityIdentifier("Practice.Story.DefinitionCallout.Vietnamese")

            Text(token.english)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityIdentifier("Practice.Story.DefinitionCallout.English")
        }
        .padding(16)
        .frame(minWidth: 172, maxWidth: 260, alignment: .leading)
        .background(PhrasePageStyle.cardFill, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("Practice.Story.DefinitionPopover.\(token.id)")
    }
}

private struct PracticeStoryDefinitionCalloutTail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

private struct PracticeStoryDottedUnderline: View {
    let color: Color

    var body: some View {
        Canvas { context, size in
            var path = Path()
            path.move(to: CGPoint(x: 0, y: size.height / 2))
            path.addLine(to: CGPoint(x: size.width, y: size.height / 2))
            context.stroke(
                path,
                with: .color(color),
                style: StrokeStyle(lineWidth: 1.35, lineCap: .round, dash: [1, 3])
            )
        }
        .frame(height: 2)
    }
}

private struct PracticeStoryDefinitionFlowLayout: Layout {
    enum Alignment {
        case leading
        case trailing
    }

    var horizontalSpacing: CGFloat
    var verticalSpacing: CGFloat
    var alignment: Alignment

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        let maxWidth = proposal.width ?? CGFloat.greatestFiniteMagnitude
        let rows = rows(for: subviews, maxWidth: maxWidth)
        let width = proposal.width.map { min($0, rows.map(\.width).max() ?? 0) } ?? (rows.map(\.width).max() ?? 0)
        let height = rows.reduce(CGFloat(0)) { result, row in
            result + row.height
        } + CGFloat(max(0, rows.count - 1)) * verticalSpacing

        return CGSize(width: width, height: height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        let rows = rows(for: subviews, maxWidth: bounds.width)
        var y = bounds.minY

        for row in rows {
            var x = bounds.minX
            if alignment == .trailing {
                x += max(0, bounds.width - row.width)
            }

            for item in row.items {
                subviews[item.index].place(
                    at: CGPoint(x: x, y: y),
                    anchor: .topLeading,
                    proposal: ProposedViewSize(item.size)
                )
                x += item.size.width + horizontalSpacing
            }

            y += row.height + verticalSpacing
        }
    }

    private func rows(for subviews: Subviews, maxWidth: CGFloat) -> [Row] {
        guard !subviews.isEmpty else {
            return []
        }

        let resolvedMaxWidth = maxWidth.isFinite && maxWidth > 0 ? maxWidth : CGFloat.greatestFiniteMagnitude
        var rows: [Row] = []
        var current = Row()

        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let nextWidth = current.items.isEmpty
                ? size.width
                : current.width + horizontalSpacing + size.width

            if !current.items.isEmpty, nextWidth > resolvedMaxWidth {
                rows.append(current)
                current = Row()
            }

            current.append(Item(index: index, size: size), spacing: horizontalSpacing)
        }

        if !current.items.isEmpty {
            rows.append(current)
        }

        return rows
    }

    private struct Item {
        let index: Int
        let size: CGSize
    }

    private struct Row {
        var items: [Item] = []
        var width: CGFloat = 0
        var height: CGFloat = 0

        mutating func append(_ item: Item, spacing: CGFloat) {
            if !items.isEmpty {
                width += spacing
            }

            items.append(item)
            width += item.size.width
            height = max(height, item.size.height)
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
            .background(PhrasePageStyle.elevatedCardFill, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(.white.opacity(PhrasePageStyle.cardEdgeStrokeOpacity), lineWidth: 1)
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
    let responseOptions: [PracticeScenarioResponseOption]
    let onSend: (PracticeScenarioResponseOption) -> Void

    @State private var pendingOptionID: String?

    init(
        step: PracticeScenarioStep,
        responseOptions: [PracticeScenarioResponseOption]? = nil,
        onSend: @escaping (PracticeScenarioResponseOption) -> Void
    ) {
        self.step = step
        self.responseOptions = responseOptions ?? Array(step.responseOptions.prefix(4))
        self.onSend = onSend
    }

    private var options: [PracticeScenarioResponseOption] {
        Array(responseOptions.prefix(4))
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
        composerGlassGroup
            .padding(.horizontal, 14)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity)
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("Practice.Story.Composer")
    }

    @ViewBuilder
    private var composerGlassGroup: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: 12) {
                composerContent
            }
        } else {
            composerContent
        }
    }

    private var composerContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            selectedPhraseBar

            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 10) {
                        ForEach(options) { option in
                            PracticeStoryChoiceChip(
                                option: option,
                                isSelected: option.id == selectedOptionID,
                                onSelect: { pendingOptionID = option.id }
                            )
                            .id(option.id)
                        }

                        Color.clear
                            .frame(width: PracticeStoryChoiceStripLayout.trailingFocusSpace)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, PracticeStoryChoiceStripLayout.horizontalPadding)
                    .padding(.bottom, 2)
                }
                .scrollClipDisabled()
                .frame(height: PracticeStoryChoiceStripLayout.height)
                .onAppear {
                    focusSelectedChoice(with: scrollProxy, animated: false)
                }
                .onChange(of: selectedOptionID) { _, _ in
                    focusSelectedChoice(with: scrollProxy, animated: true)
                }
            }
        }
    }

    @ViewBuilder
    private var selectedPhraseBar: some View {
        let shape = RoundedRectangle(cornerRadius: 24, style: .continuous)

        HStack(alignment: .center, spacing: 12) {
            Text(pendingOption?.scenarioVietnamese ?? "")
                .font(.system(size: 22, weight: .regular))
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
        .padding(.vertical, 9)
        .frame(minHeight: 56)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground).opacity(0.42), in: shape)
        .nativeGlass(cornerRadius: 24, tint: .white, interactive: true)
        .overlay {
            shape
                .stroke(.white.opacity(0.70), lineWidth: 0.9)
                .blendMode(.screen)

            shape
                .stroke(Color(.separator).opacity(0.18), lineWidth: 0.7)
        }
        .softAmbientCardShadow()
    }

    private func focusSelectedChoice(with scrollProxy: ScrollViewProxy, animated: Bool) {
        guard let selectedOptionID else {
            return
        }

        let focus = {
            scrollProxy.scrollTo(selectedOptionID, anchor: .leading)
        }

        if animated {
            withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
                focus()
            }
        } else {
            focus()
        }
    }
}

private enum PracticeStoryChoiceStripLayout {
    static let horizontalPadding: CGFloat = 14
    static let trailingFocusSpace: CGFloat = 260
    static let height: CGFloat = 70
}

private struct PracticeStoryChoiceChip: View {
    let option: PracticeScenarioResponseOption
    let isSelected: Bool
    let onSelect: () -> Void

    private var minWidth: CGFloat {
        isSelected ? 224 : 126
    }

    private var maxWidth: CGFloat {
        isSelected ? 300 : 172
    }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 20, style: .continuous)

        Button(action: onSelect) {
            Text(option.scenarioEnglish)
                .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                .foregroundStyle(isSelected ? Color(red: 0.02, green: 0.37, blue: 0.95) : .primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .frame(minWidth: minWidth, maxWidth: maxWidth)
                .frame(minHeight: 52)
                .background(chipBackground, in: shape)
                .nativeGlass(cornerRadius: 20, tint: chipGlassTint, interactive: true)
                .overlay {
                    shape
                        .stroke(
                            isSelected ? Color(red: 0.02, green: 0.37, blue: 0.95) : Color(.separator).opacity(0.34),
                            lineWidth: isSelected ? 2 : 1
                        )
                }
                .softAmbientCardShadow()
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("Practice.Story.Choice.\(option.id)")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    }

    private var chipBackground: some ShapeStyle {
        isSelected
            ? AnyShapeStyle(Color.white.opacity(0.54))
            : AnyShapeStyle(Color.white.opacity(0.32))
    }

    private var chipGlassTint: Color {
        isSelected
            ? Color(red: 0.84, green: 0.92, blue: 1.0)
            : .white
    }
}
