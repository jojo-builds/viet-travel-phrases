import AVFoundation
import Foundation

struct AudioAssetManifestEntry: Decodable, Equatable {
    let fileName: String
    let text: String
}

struct AudioAssetManifest {
    static let main = load(bundle: .main)

    private let entries: [String: AudioAssetManifestEntry]
    private let bundle: Bundle

    init(entries: [String: AudioAssetManifestEntry], bundle: Bundle = .main) {
        self.entries = entries
        self.bundle = bundle
    }

    func entry(for audioKey: String?) -> AudioAssetManifestEntry? {
        guard let audioKey else {
            return nil
        }

        return entries[audioKey]
    }

    func url(for audioKey: String?) -> URL? {
        guard let fileName = entry(for: audioKey)?.fileName else {
            return nil
        }

        return bundle.url(forResource: fileName, withExtension: nil, subdirectory: "Audio")
            ?? bundle.url(forResource: fileName, withExtension: nil)
    }

    func audioKey(forExactText text: String) -> String? {
        let normalizedText = Self.normalizedAudioText(text)

        return entries
            .filter { key, entry in
                Self.normalizedAudioText(entry.text) == normalizedText && url(for: key) != nil
            }
            .map(\.key)
            .sorted { left, right in
                if left.count != right.count {
                    return left.count < right.count
                }

                return left < right
            }
            .first
    }

    func hasPlayableEntry(for audioKey: String?, matchingText text: String) -> Bool {
        guard
            let audioKey,
            let entry = entry(for: audioKey),
            Self.normalizedAudioText(entry.text) == Self.normalizedAudioText(text)
        else {
            return false
        }

        return url(for: audioKey) != nil
    }

    private static func load(bundle: Bundle) -> AudioAssetManifest? {
        guard let url = bundle.url(forResource: "viet-audio-manifest", withExtension: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let entries = try JSONDecoder().decode([String: AudioAssetManifestEntry].self, from: data)
            return AudioAssetManifest(entries: entries, bundle: bundle)
        } catch {
            assertionFailure("Unable to load audio manifest: \(error)")
            return nil
        }
    }

    private static func normalizedAudioText(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}

final class AudioPlaybackService {
    static let shared = AudioPlaybackService()

    private let manifest: AudioAssetManifest?
    private var player: AVAudioPlayer?

    init(manifest: AudioAssetManifest? = .main) {
        self.manifest = manifest
    }

    func play(audioKey: String?, rate: Double = 1.0) {
        guard
            let url = manifest?.url(for: audioKey),
            FileManager.default.fileExists(atPath: url.path)
        else {
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.enableRate = true
            player.rate = Float(rate)
            player.prepareToPlay()
            player.play()
            self.player = player
        } catch {
            assertionFailure("Unable to play audio \(url.lastPathComponent): \(error)")
        }
    }
}
