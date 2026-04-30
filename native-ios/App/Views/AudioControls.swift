import SwiftUI

struct AudioSpeakerButton: View {
    let tint: AccentTint
    var size: CGFloat = 48
    var audioKey: String? = nil

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

    var body: some View {
        Button {
            if let resolvedAudioKey {
                AudioPlaybackService.shared.play(audioKey: resolvedAudioKey)
            }
        } label: {
            Image(systemName: resolvedAudioKey == nil ? "speaker.slash.fill" : "speaker.wave.2.fill")
                .font(.system(size: size * 0.36, weight: .semibold))
                .foregroundStyle(resolvedAudioKey == nil ? Color.secondary.opacity(0.72) : tint.audioColor)
                .frame(width: size, height: size)
        }
        .buttonStyle(.plain)
        .disabled(resolvedAudioKey == nil)
        .nativeGlass(cornerRadius: size / 2, interactive: resolvedAudioKey != nil)
        .accessibilityLabel(resolvedAudioKey == nil ? "Audio not available yet" : "Play audio")
    }
}

struct PlaybackDockView: View {
    var audioKey: String? = nil
    var isSaved = false
    var onToggleSaved: (() -> Void)? = nil

    @AppStorage(AudioPlaybackPreference.speedKey) private var selectedSpeed = AudioPlaybackPreference.defaultSpeed
    private let speeds = AudioPlaybackPreference.speeds

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                favoriteButton

                Spacer(minLength: 88)

                speedSegmentedControl
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

            raisedPlayButton
                .offset(x: -52, y: -3)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 108)
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

                Image(systemName: playableAudioKey == nil ? "speaker.slash.fill" : "play.fill")
                    .font(.system(size: 29, weight: .bold))
                    .foregroundStyle(playableAudioKey == nil ? Color.secondary.opacity(0.72) : Color.red)
                    .offset(x: playableAudioKey == nil ? 0 : 3)
            }
            .frame(width: 96, height: 96)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .disabled(playableAudioKey == nil)
        .nativeGlass(cornerRadius: 48, tint: .white, interactive: playableAudioKey != nil)
        .accessibilityLabel(playableAudioKey == nil ? "Audio not available yet" : "Play phrase audio")
    }

    private var selectedRate: Double {
        AudioPlaybackPreference.rate(for: selectedSpeed)
    }

    private var speedSegmentedControl: some View {
        let currentSpeed = AudioPlaybackPreference.normalizedSpeed(selectedSpeed)

        return HStack(spacing: 0) {
            ForEach(speeds.indices, id: \.self) { index in
                let speed = speeds[index]

                Button {
                    selectedSpeed = speed
                } label: {
                    VStack(spacing: 3) {
                        Text(speed)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(currentSpeed == speed ? .red : .primary)
                            .frame(height: 29)

                        Capsule(style: .continuous)
                            .fill(currentSpeed == speed ? Color.red : Color.clear)
                            .frame(width: 22, height: 4)
                    }
                    .frame(width: 48, height: 42)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if index < speeds.count - 1 {
                    Rectangle()
                        .fill(Color.black.opacity(0.08))
                        .frame(width: 1, height: 34)
                }
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 4)
        .frame(height: 52)
        .background {
            Capsule(style: .continuous)
                .fill(.white.opacity(0.42))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)
        }
        .overlay {
            Capsule(style: .continuous)
                .stroke(.white.opacity(0.66), lineWidth: 1)
        }
        .nativeGlass(cornerRadius: 26, interactive: true)
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
