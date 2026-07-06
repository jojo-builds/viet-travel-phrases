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

#if DEBUG
    private static let lookupCountLock = NSLock()
    private static var playbackResolutionLookupCount = 0

    static var playbackResolutionLookupCountForTesting: Int {
        lookupCountLock.lock()
        defer { lookupCountLock.unlock() }
        return playbackResolutionLookupCount
    }

    static func resetLookupCountsForTesting() {
        lookupCountLock.lock()
        playbackResolutionLookupCount = 0
        lookupCountLock.unlock()
    }

    private static func recordPlaybackResolutionLookupForTesting() {
        lookupCountLock.lock()
        playbackResolutionLookupCount += 1
        lookupCountLock.unlock()
    }
#endif

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
#if DEBUG
        Self.recordPlaybackResolutionLookupForTesting()
#endif
        return audioKeysByNormalizedText[Self.normalizedAudioText(text)]?.first
    }

    func hasPlayableEntry(for audioKey: String?, matchingText text: String) -> Bool {
#if DEBUG
        Self.recordPlaybackResolutionLookupForTesting()
#endif
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
            .trimmingCharacters(in: CharacterSet(charactersIn: ".。!?！？"))
    }
}

protocol AudioPlayable: AnyObject {
    var enableRate: Bool { get set }
    var rate: Float { get set }
    var currentTime: TimeInterval { get set }
    var isPlaying: Bool { get }

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
    private let minimumReplayInterval: TimeInterval
    private let currentTime: () -> TimeInterval
    private var player: AudioPlayable?
    private var playerURL: URL?
    private var playerRate: Float?
    private var lastPlaybackRequest: PlaybackRequest?
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
        },
        minimumReplayInterval: TimeInterval = 0.18,
        currentTime: @escaping () -> TimeInterval = {
            ProcessInfo.processInfo.systemUptime
        }
    ) {
        self.manifest = manifest
        self.configureAudioSession = configureAudioSession
        self.makePlayer = makePlayer
        self.minimumReplayInterval = minimumReplayInterval
        self.currentTime = currentTime
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
            let requestTime = currentTime()

            if shouldCoalesceRapidReplay(url: url, rate: requestedRate, at: requestTime) {
                return true
            }

            if let player, playerURL == url, playerRate == requestedRate {
                let didStart = replay(player, rate: requestedRate)
                if !didStart {
                    clearCachedPlayer()
                } else {
                    recordPlaybackRequest(url: url, rate: requestedRate, at: requestTime)
                }
                return didStart
            }

            player?.stop()
            let player = try makePlayer(url)
            player.enableRate = true
            player.rate = requestedRate
            guard player.prepareToPlay() else {
                return false
            }
            let didStart = player.play()
            guard didStart else {
                return false
            }
            self.player = player
            playerURL = url
            playerRate = requestedRate
            recordPlaybackRequest(url: url, rate: requestedRate, at: requestTime)
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
        guard player.prepareToPlay() else {
            return false
        }
        return player.play()
    }

    private func clearCachedPlayer() {
        player = nil
        playerURL = nil
        playerRate = nil
        lastPlaybackRequest = nil
    }

    private func shouldCoalesceRapidReplay(url: URL, rate: Float, at requestTime: TimeInterval) -> Bool {
        guard
            minimumReplayInterval > 0,
            let lastPlaybackRequest,
            lastPlaybackRequest.url == url,
            lastPlaybackRequest.rate == rate
        else {
            return false
        }

        if player?.isPlaying == true {
            return true
        }

        return requestTime - lastPlaybackRequest.time < minimumReplayInterval
    }

    private func recordPlaybackRequest(url: URL, rate: Float, at requestTime: TimeInterval) {
        lastPlaybackRequest = PlaybackRequest(url: url, rate: rate, time: requestTime)
    }

    private struct PlaybackRequest {
        let url: URL
        let rate: Float
        let time: TimeInterval
    }
}
