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
                        .frame(width: 54, height: 54)
                        .accessibilityHidden(true)
                }

                Spacer(minLength: 88)

                AudioSpeedSegmentedControl()
            }
            .padding(.leading, 16)
            .padding(.trailing, 12)
            .frame(maxWidth: .infinity)
            .frame(height: 78)
            .background {
                Capsule(style: .continuous)
                    .fill(.white.opacity(0.34))
                    .shadow(color: .black.opacity(0.10), radius: 24, x: 0, y: 14)
                    .shadow(color: .white.opacity(0.92), radius: 10, x: 0, y: -6)
            }
            .overlay {
                Capsule(style: .continuous)
                    .stroke(.white.opacity(0.58), lineWidth: 1)
            }
            .nativeGlass(cornerRadius: 39)

            if playableAudioKey != nil {
                raisedPlayButton
                    .offset(x: -52, y: -3)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 108)
        .background(playerVisibilityReporter)
    }

    private var favoriteButton: some View {
        Button {
            onToggleSaved?()
        } label: {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.48))
                    .shadow(color: .black.opacity(0.09), radius: 12, x: 0, y: 8)

                Image(systemName: isSaved ? "heart.fill" : "heart")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.red)
            }
            .frame(width: 54, height: 54)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .nativeGlass(cornerRadius: 27, interactive: true)
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
                            .stroke(.white.opacity(0.76), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.11), radius: 22, x: 0, y: 13)
                    .shadow(color: .white.opacity(0.90), radius: 10, x: 0, y: -7)

                Circle()
                    .fill(.white.opacity(0.82))
                    .frame(width: 70, height: 70)
                    .overlay {
                        Circle()
                            .stroke(.white.opacity(0.74), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.08), radius: 15, x: 0, y: 10)

                Image(systemName: "play.fill")
                    .font(.system(size: 29, weight: .bold))
                    .foregroundStyle(Color.red)
                    .offset(x: 3)
            }
            .frame(width: 96, height: 96)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .nativeGlass(cornerRadius: 48, tint: .white, interactive: true)
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
        textSize: 14,
        textHeight: 29,
        underlineWidth: 22,
        underlineHeight: 4,
        itemWidth: 48,
        itemHeight: 42,
        dividerHeight: 34,
        horizontalPadding: 5,
        verticalPadding: 4,
        controlHeight: 52,
        cornerRadius: 26
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
                        .fill(Color.black.opacity(0.08))
                        .frame(width: 1, height: metrics.dividerHeight)
                }
            }
        }
        .padding(.horizontal, metrics.horizontalPadding)
        .padding(.vertical, metrics.verticalPadding)
        .frame(height: metrics.controlHeight)
        .background {
            Capsule(style: .continuous)
                .fill(.white.opacity(0.42))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)
        }
        .overlay {
            Capsule(style: .continuous)
                .stroke(.white.opacity(0.66), lineWidth: 1)
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
