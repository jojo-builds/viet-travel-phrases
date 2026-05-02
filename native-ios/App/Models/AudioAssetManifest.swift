import AVFoundation
import Foundation

struct AudioAssetManifestEntry: Decodable, Equatable {
    let fileName: String
    let text: String
}

struct AudioAssetManifest {
    static let main = load(bundle: .main)

    private let entries: [String: AudioAssetManifestEntry]
    private let playableURLs: [String: URL]
    private let audioKeysByNormalizedText: [String: [String]]

    init(entries: [String: AudioAssetManifestEntry], bundle: Bundle = .main) {
        self.entries = entries

        var resolvedURLs: [String: URL] = [:]
        var textKeys: [String: [String]] = [:]

        for (key, entry) in entries {
            guard
                let url = bundle.url(forResource: entry.fileName, withExtension: nil, subdirectory: "Audio")
                    ?? bundle.url(forResource: entry.fileName, withExtension: nil)
            else {
                continue
            }

            resolvedURLs[key] = url
            textKeys[Self.normalizedAudioText(entry.text), default: []].append(key)
        }

        playableURLs = resolvedURLs
        audioKeysByNormalizedText = textKeys.mapValues { keys in
            keys.sorted { left, right in
                if left.count != right.count {
                    return left.count < right.count
                }

                return left < right
            }
        }
    }

    func entry(for audioKey: String?) -> AudioAssetManifestEntry? {
        guard let audioKey else {
            return nil
        }

        return entries[audioKey]
    }

    func url(for audioKey: String?) -> URL? {
        guard let audioKey else {
            return nil
        }

        return playableURLs[audioKey]
    }

    func audioKey(forExactText text: String) -> String? {
        audioKeysByNormalizedText[Self.normalizedAudioText(text)]?.first
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

protocol AudioPlayable: AnyObject {
    var enableRate: Bool { get set }
    var rate: Float { get set }
    var currentTime: TimeInterval { get set }

    func stop()

    @discardableResult
    func prepareToPlay() -> Bool

    @discardableResult
    func play() -> Bool
}

extension AVAudioPlayer: AudioPlayable {}

final class AudioPlaybackService {
    static let shared = AudioPlaybackService()

    private let manifest: AudioAssetManifest?
    private let configureAudioSession: () throws -> Void
    private let makePlayer: (URL) throws -> AudioPlayable
    private var player: AudioPlayable?
    private var playerURL: URL?
    private var playerRate: Float?
    private var hasConfiguredAudioSession = false

    init(
        manifest: AudioAssetManifest? = .main,
        configureAudioSession: @escaping () throws -> Void = {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        },
        makePlayer: @escaping (URL) throws -> AudioPlayable = { url in
            try AVAudioPlayer(contentsOf: url)
        }
    ) {
        self.manifest = manifest
        self.configureAudioSession = configureAudioSession
        self.makePlayer = makePlayer
    }

    @discardableResult
    func play(audioKey: String?, rate: Double = 1.0) -> Bool {
        guard
            let url = manifest?.url(for: audioKey),
            FileManager.default.fileExists(atPath: url.path)
        else {
            return false
        }

        do {
            try configureAudioSessionIfNeeded()
            let requestedRate = Float(rate)

            if let player, playerURL == url, playerRate == requestedRate {
                return replay(player, rate: requestedRate)
            }

            player?.stop()
            let player = try makePlayer(url)
            player.enableRate = true
            player.rate = requestedRate
            player.prepareToPlay()
            let didStart = player.play()
            self.player = player
            playerURL = url
            playerRate = requestedRate
            return didStart
        } catch {
            assertionFailure("Unable to play audio \(url.lastPathComponent): \(error)")
            return false
        }
    }

    private func configureAudioSessionIfNeeded() throws {
        guard !hasConfiguredAudioSession else {
            return
        }

        try configureAudioSession()
        hasConfiguredAudioSession = true
    }

    private func replay(_ player: AudioPlayable, rate: Float) -> Bool {
        player.stop()
        player.currentTime = 0
        player.enableRate = true
        player.rate = rate
        player.prepareToPlay()
        return player.play()
    }
}
