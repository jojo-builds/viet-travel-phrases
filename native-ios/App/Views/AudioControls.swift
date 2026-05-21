import SwiftUI

struct AudioSpeakerButton: View {
    let tint: AccentTint
    var size: CGFloat = 48
    var audioKey: String? = nil
    var accessibilityIdentifier: String? = nil

    static let minimumHitSize: CGFloat = 44

    static func tapTargetSize(for visualSize: CGFloat) -> CGFloat {
        max(visualSize, minimumHitSize)
    }

    static func isPlayableAudioKey(_ audioKey: String?) -> Bool {
        playableAudioKey(audioKey) != nil
    }

    static func playableAudioKey(_ audioKey: String?) -> String? {
        guard
            let audioKey,
            AudioAssetManifest.main?.url(for: audioKey) != nil
        else {
            return nil
        }

        return audioKey
    }

    private var resolvedAudioKey: String? {
        Self.playableAudioKey(audioKey)
    }

    @ViewBuilder
    var body: some View {
        if resolvedAudioKey != nil {
            if let accessibilityIdentifier {
                button
                    .accessibilityIdentifier(accessibilityIdentifier)
            } else {
                button
            }
        }
    }

    private var button: some View {
        Button {
            if let resolvedAudioKey {
                AudioPlaybackService.shared.play(audioKey: resolvedAudioKey, rate: selectedRate)
            }
        } label: {
            Image(systemName: "speaker.wave.2.fill")
                .font(.system(size: size * 0.36, weight: .semibold))
                .foregroundStyle(tint.audioColor)
                .frame(width: size, height: size)
                .nativeGlass(cornerRadius: size / 2, interactive: true)
                .frame(width: Self.tapTargetSize(for: size), height: Self.tapTargetSize(for: size))
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Play audio")
    }

    private var selectedRate: Double {
        AudioPlaybackPreference.currentRate()
    }
}

struct PlaybackDockView: View {
    var audioKey: String? = nil
    var isSaved = false
    var onToggleSaved: (() -> Void)? = nil
    var showsFavoriteButton = true
    var visibilityRoute: AppRoute? = nil

    @AppStorage(AudioPlaybackPreference.speedKey) private var selectedSpeed = AudioPlaybackPreference.defaultSpeed

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                if showsFavoriteButton {
                    favoriteButton
                } else {
                    Color.clear
                        .frame(width: PlaybackDockLayout.sideButtonSize, height: PlaybackDockLayout.sideButtonSize)
                        .accessibilityHidden(true)
                }

                Spacer(minLength: PlaybackDockLayout.centerSpacing)

                AudioSpeedSegmentedControl()
            }
            .padding(.leading, PlaybackDockLayout.leadingPadding)
            .padding(.trailing, PlaybackDockLayout.trailingPadding)
            .frame(maxWidth: .infinity)
            .frame(height: PlaybackDockLayout.capsuleHeight)
            .background {
                Capsule(style: .continuous)
                    .fill(.white.opacity(0.34))
                    .overlay {
                        Capsule(style: .continuous)
                            .stroke(.white.opacity(AppSurfaceDepth.controlStrokeOpacity), lineWidth: 1)
                    }
                    .softInteractiveControlShadow()
            }
            .nativeGlass(cornerRadius: PlaybackDockLayout.capsuleCornerRadius)

            if playableAudioKey != nil {
                raisedPlayButton
                    .offset(x: PlaybackDockLayout.playOffsetX, y: PlaybackDockLayout.playOffsetY)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: PlaybackDockLayout.dockHeight)
        .background(playerVisibilityReporter)
    }

    private var favoriteButton: some View {
        Button {
            onToggleSaved?()
        } label: {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.48))
                    .overlay {
                        Circle()
                            .stroke(.white.opacity(AppSurfaceDepth.controlStrokeOpacity), lineWidth: 1)
                    }
                    .softInteractiveControlShadow()

                Image(systemName: isSaved ? "heart.fill" : "heart")
                    .font(.system(size: PlaybackDockLayout.favoriteIconSize, weight: .semibold))
                    .foregroundStyle(.red)
            }
            .frame(width: PlaybackDockLayout.sideButtonSize, height: PlaybackDockLayout.sideButtonSize)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .nativeGlass(cornerRadius: PlaybackDockLayout.sideButtonCornerRadius, interactive: true)
        .accessibilityLabel(isSaved ? "Unsave phrase page" : "Save phrase page")
    }

    private var playableAudioKey: String? {
        AudioSpeakerButton.playableAudioKey(audioKey)
    }

    private var raisedPlayButton: some View {
        Button {
            if let playableAudioKey {
                AudioPlaybackService.shared.play(audioKey: playableAudioKey, rate: selectedRate)
            }
        } label: {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.46))
                    .overlay {
                        Circle()
                            .stroke(.white.opacity(AppSurfaceDepth.controlStrokeOpacity), lineWidth: 1)
                    }
                    .softInteractiveControlShadow()

                Circle()
                    .fill(.white.opacity(0.82))
                    .frame(width: PlaybackDockLayout.playInnerCircleSize, height: PlaybackDockLayout.playInnerCircleSize)
                    .overlay {
                        Circle()
                            .stroke(.white.opacity(AppSurfaceDepth.controlStrokeOpacity), lineWidth: 1)
                    }

                Image(systemName: "play.fill")
                    .font(.system(size: PlaybackDockLayout.playIconSize, weight: .bold))
                    .foregroundStyle(Color.red)
                    .offset(x: 3)
            }
            .frame(width: PlaybackDockLayout.playButtonSize, height: PlaybackDockLayout.playButtonSize)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .nativeGlass(cornerRadius: PlaybackDockLayout.playButtonCornerRadius, tint: .white, interactive: true)
        .accessibilityLabel("Play phrase audio")
    }

    private var selectedRate: Double {
        AudioPlaybackPreference.rate(for: selectedSpeed)
    }

    @ViewBuilder
    private var playerVisibilityReporter: some View {
        if let visibilityRoute {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: PhraseAudioPlayerAnchorPreferenceKey.self,
                    value: [
                        PhraseAudioPlayerAnchor(
                            route: visibilityRoute,
                            frame: proxy.frame(in: .global)
                        )
                    ]
                )
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
    }
}

enum PlaybackDockLayout {
    static let leadingPadding: CGFloat = 12
    static let trailingPadding: CGFloat = 10
    static let sideButtonSize: CGFloat = 50
    static let sideButtonCornerRadius: CGFloat = sideButtonSize / 2
    static let favoriteIconSize: CGFloat = 21
    static let centerSpacing: CGFloat = 72
    static let capsuleHeight: CGFloat = 72
    static let capsuleCornerRadius: CGFloat = capsuleHeight / 2
    static let dockHeight: CGFloat = 100
    static let playButtonSize: CGFloat = 88
    static let playButtonCornerRadius: CGFloat = playButtonSize / 2
    static let playInnerCircleSize: CGFloat = 64
    static let playIconSize: CGFloat = 27
    static let playOffsetX: CGFloat = -46
    static let playOffsetY: CGFloat = -3

    static func minimumWidth(speedControlWidth: CGFloat) -> CGFloat {
        leadingPadding + sideButtonSize + centerSpacing + speedControlWidth + trailingPadding
    }
}

struct AudioSpeedControlMetrics {
    let textSize: CGFloat
    let textHeight: CGFloat
    let underlineWidth: CGFloat
    let underlineHeight: CGFloat
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    let dividerHeight: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let controlHeight: CGFloat
    let cornerRadius: CGFloat

    static let regular = AudioSpeedControlMetrics(
        textSize: 13.5,
        textHeight: 27,
        underlineWidth: 20,
        underlineHeight: 3.5,
        itemWidth: 44,
        itemHeight: 39,
        dividerHeight: 32,
        horizontalPadding: 4.5,
        verticalPadding: 3.5,
        controlHeight: 48,
        cornerRadius: 24
    )

    static let topAdmin = AudioSpeedControlMetrics(
        textSize: 13,
        textHeight: 26,
        underlineWidth: 20,
        underlineHeight: 3.5,
        itemWidth: 43,
        itemHeight: 38,
        dividerHeight: 31,
        horizontalPadding: 4.5,
        verticalPadding: 3.5,
        controlHeight: AppChromeLayout.topAdminControlSize,
        cornerRadius: AppChromeLayout.topAdminControlCornerRadius
    )

    func minimumControlWidth(itemCount: Int) -> CGFloat {
        horizontalPadding * 2
            + itemWidth * CGFloat(itemCount)
            + CGFloat(max(0, itemCount - 1))
    }
}

struct AudioSpeedSegmentedControl: View {
    var metrics = AudioSpeedControlMetrics.regular

    @AppStorage(AudioPlaybackPreference.speedKey) private var selectedSpeed = AudioPlaybackPreference.defaultSpeed
    private let speeds = AudioPlaybackPreference.speeds

    var body: some View {
        let currentSpeed = AudioPlaybackPreference.normalizedSpeed(selectedSpeed)

        return HStack(spacing: 0) {
            ForEach(speeds.indices, id: \.self) { index in
                let speed = speeds[index]

                Button {
                    selectedSpeed = speed
                } label: {
                    VStack(spacing: 3) {
                        Text(speed)
                            .font(.system(size: metrics.textSize, weight: .bold))
                            .foregroundStyle(currentSpeed == speed ? .red : .primary)
                            .frame(height: metrics.textHeight)

                        Capsule(style: .continuous)
                            .fill(currentSpeed == speed ? Color.red : Color.clear)
                            .frame(width: metrics.underlineWidth, height: metrics.underlineHeight)
                    }
                    .frame(width: metrics.itemWidth, height: metrics.itemHeight)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if index < speeds.count - 1 {
                    Rectangle()
                        .fill(Color.black.opacity(AppSurfaceDepth.controlDividerOpacity))
                        .frame(width: 1, height: metrics.dividerHeight)
                }
            }
        }
        .padding(.horizontal, metrics.horizontalPadding)
        .padding(.vertical, metrics.verticalPadding)
        .frame(height: metrics.controlHeight)
        .background {
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    Capsule(style: .continuous)
                        .stroke(.white.opacity(AppSurfaceDepth.controlStrokeOpacity), lineWidth: 1)
                }
                .softInteractiveControlShadow()
        }
        .nativeGlass(cornerRadius: metrics.cornerRadius, interactive: true)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Audio speed")
        .accessibilityIdentifier("AudioSpeedControl")
    }
}

struct PinnedAudioSpeedControl: View {
    var body: some View {
        AudioSpeedSegmentedControl(metrics: .topAdmin)
            .accessibilityIdentifier("PinnedAudioSpeedControl")
    }
}

struct PhraseAudioPlayerAnchor: Equatable {
    let route: AppRoute
    let frame: CGRect
}

struct PhraseAudioPlayerAnchorPreferenceKey: PreferenceKey {
    static var defaultValue: [PhraseAudioPlayerAnchor] = []

    static func reduce(value: inout [PhraseAudioPlayerAnchor], nextValue: () -> [PhraseAudioPlayerAnchor]) {
        value.append(contentsOf: nextValue())
    }
}

struct PinnedAudioSpeedChromeState: Equatable {
    let route: AppRoute?
    let isVisible: Bool

    static let hidden = PinnedAudioSpeedChromeState(route: nil, isVisible: false)
}

enum PinnedAudioSpeedChromePolicy {
    static func canShowPinnedControl(
        on route: AppRoute,
        hasStaticBackButton: Bool,
        isSearchPresented: Bool
    ) -> Bool {
        guard !isSearchPresented else {
            return false
        }

        return route == .home || hasStaticBackButton
    }

    static func state(
        for anchors: [PhraseAudioPlayerAnchor],
        currentRoute: AppRoute
    ) -> PinnedAudioSpeedChromeState {
        let anchor = anchors.first { $0.route == currentRoute }
        let isVisible = shouldShowPinnedControl(for: anchor, currentRoute: currentRoute)

        return PinnedAudioSpeedChromeState(
            route: isVisible ? currentRoute : nil,
            isVisible: isVisible
        )
    }

    static func shouldShowPinnedControl(
        chromeState: PinnedAudioSpeedChromeState,
        currentRoute: AppRoute,
        hasStaticBackButton: Bool,
        isSearchPresented: Bool,
        isMenuSectionChromeVisible: Bool = false
    ) -> Bool {
        guard canShowPinnedControl(
            on: currentRoute,
            hasStaticBackButton: hasStaticBackButton,
            isSearchPresented: isSearchPresented
        ) else {
            return false
        }

        return (chromeState.route == currentRoute && chromeState.isVisible)
            || isMenuSectionChromeVisible
    }

    static func shouldShowPinnedControl(
        for anchor: PhraseAudioPlayerAnchor?,
        currentRoute: AppRoute
    ) -> Bool {
        guard let anchor, anchor.route == currentRoute else {
            return false
        }

        return anchor.frame.maxY <= AppChromeLayout.pinnedAudioSpeedRevealY
    }
}

enum AudioPlaybackPreference {
    static let speedKey = "SpeakLocal.audio.playbackSpeed"
    static let defaultSpeed = "1.0x"
    static let speeds = ["0.5x", "0.75x", "1.0x"]

    static func normalizedSpeed(_ speed: String) -> String {
        speeds.contains(speed) ? speed : defaultSpeed
    }

    static func rate(for speed: String) -> Double {
        switch normalizedSpeed(speed) {
        case "0.5x":
            return 0.5
        case "0.75x":
            return 0.75
        default:
            return 1.0
        }
    }

    static func currentSpeed(defaults: UserDefaults = .standard) -> String {
        normalizedSpeed(defaults.string(forKey: speedKey) ?? defaultSpeed)
    }

    static func currentRate(defaults: UserDefaults = .standard) -> Double {
        rate(for: currentSpeed(defaults: defaults))
    }
}

struct PannableLineText: View {
    let text: String
    let font: Font
    let color: Color
    var lineHeight: CGFloat = 20

    var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(color)
            .lineLimit(1)
            .truncationMode(.tail)
            .frame(maxWidth: .infinity, minHeight: lineHeight, alignment: .leading)
    }
}
