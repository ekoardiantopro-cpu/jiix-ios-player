import AVFoundation
import MediaPlayer
import SwiftUI

@MainActor
final class PlayerController: ObservableObject {
    @Published private(set) var queue: [Track] = MusicCatalog.tracks
    @Published private(set) var currentTrack: Track?
    @Published private(set) var isPlaying = false
    @Published private(set) var currentTime: Double = 0
    @Published private(set) var duration: Double = 1
    @Published private(set) var likedTrackIDs: Set<String> = []
    @Published private(set) var recentTrackIDs: [String] = []
    @Published private(set) var downloadStates: [String: DownloadState] = [:]
    @Published var selectedEqualizerPreset: EqualizerPreset = .flat
    @Published var repeatMode: RepeatMode = .all
    @Published var isShuffleEnabled = false
    @Published var offlineOnlyEnabled = false
    @Published var isShowingNowPlaying = false

    private let player = AVPlayer()
    private var timeObserver: Any?

    init() {
        configureAudioSession()
        installObservers()
        seedDownloads()
        currentTrack = queue.first
    }

    func play(track: Track) {
        if currentTrack != track {
            currentTrack = track
            registerRecent(track)
            load(track: track, autoplay: true)
        } else {
            if player.currentItem == nil {
                load(track: track, autoplay: true)
            } else {
                player.play()
                isPlaying = true
            }
        }
        isShowingNowPlaying = true
    }

    func togglePlayback() {
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

    func playNext() {
        guard let currentTrack else { return }

        if repeatMode == .one {
            play(track: currentTrack)
            return
        }

        let sourceQueue = playableQueue
        guard let currentIndex = sourceQueue.firstIndex(of: currentTrack), !sourceQueue.isEmpty else { return }

        if isShuffleEnabled, sourceQueue.count > 1 {
            let remaining = sourceQueue.filter { $0 != currentTrack }
            if let randomTrack = remaining.randomElement() {
                play(track: randomTrack)
            }
            return
        }

        let nextIndex = sourceQueue.index(after: currentIndex)
        if nextIndex == sourceQueue.endIndex {
            if repeatMode == .all, let firstTrack = sourceQueue.first {
                play(track: firstTrack)
            } else {
                player.pause()
                isPlaying = false
            }
            return
        }

        play(track: sourceQueue[nextIndex])
    }

    func playPrevious() {
        guard let currentTrack else { return }
        if currentTime > 5 {
            seek(to: 0)
            return
        }

        let sourceQueue = playableQueue
        guard let currentIndex = sourceQueue.firstIndex(of: currentTrack), !sourceQueue.isEmpty else { return }
        let previousIndex = currentIndex == sourceQueue.startIndex ? sourceQueue.index(before: sourceQueue.endIndex) : sourceQueue.index(before: currentIndex)
        play(track: sourceQueue[previousIndex])
    }

    func seek(to progress: Double) {
        guard duration > 0 else { return }
        let newTime = CMTime(seconds: progress * duration, preferredTimescale: 600)
        player.seek(to: newTime)
    }

    func toggleLike(for track: Track) {
        if likedTrackIDs.contains(track.id) {
            likedTrackIDs.remove(track.id)
        } else {
            likedTrackIDs.insert(track.id)
        }
    }

    func isLiked(_ track: Track) -> Bool {
        likedTrackIDs.contains(track.id)
    }

    func download(track: Track) {
        let state = downloadStates[track.id] ?? .notDownloaded
        guard state != .downloading, state != .downloaded else { return }
        downloadStates[track.id] = .downloading

        let destinationURL = localFileURL(for: track)
        Task {
            do {
                try FileManager.default.createDirectory(
                    at: downloadsDirectory,
                    withIntermediateDirectories: true,
                    attributes: nil
                )

                let (temporaryURL, _) = try await URLSession.shared.download(from: track.streamURL)

                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(at: destinationURL)
                }

                try FileManager.default.moveItem(at: temporaryURL, to: destinationURL)
                downloadStates[track.id] = .downloaded
            } catch {
                downloadStates[track.id] = .failed
            }
        }
    }

    func deleteDownload(for track: Track) {
        let destinationURL = localFileURL(for: track)
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try? FileManager.default.removeItem(at: destinationURL)
        }
        downloadStates[track.id] = .notDownloaded
    }

    func downloadState(for track: Track) -> DownloadState {
        if let state = downloadStates[track.id] {
            return state
        }
        return FileManager.default.fileExists(atPath: localFileURL(for: track).path) ? .downloaded : .notDownloaded
    }

    func isDownloaded(_ track: Track) -> Bool {
        downloadState(for: track) == .downloaded
    }

    func cycleRepeatMode() {
        switch repeatMode {
        case .off:
            repeatMode = .all
        case .all:
            repeatMode = .one
        case .one:
            repeatMode = .off
        }
    }

    func setEqualizerPreset(_ preset: EqualizerPreset) {
        selectedEqualizerPreset = preset
    }

    func updateQueue(with tracks: [Track]) {
        queue = tracks
        if currentTrack == nil, let firstTrack = tracks.first {
            currentTrack = firstTrack
            load(track: firstTrack, autoplay: false)
        }
    }

    var likedTracks: [Track] {
        MusicCatalog.tracks.filter { likedTrackIDs.contains($0.id) }
    }

    var recentTracks: [Track] {
        recentTrackIDs.compactMap { id in
            MusicCatalog.tracks.first(where: { $0.id == id })
        }
    }

    var downloadedTracks: [Track] {
        MusicCatalog.tracks.filter { isDownloaded($0) }
    }

    var playableQueue: [Track] {
        if offlineOnlyEnabled {
            let offlineTracks = queue.filter { isDownloaded($0) }
            return offlineTracks.isEmpty ? queue : offlineTracks
        }
        return queue
    }

    private func load(track: Track, autoplay: Bool) {
        let item = AVPlayerItem(url: playbackURL(for: track))
        player.replaceCurrentItem(with: item)
        currentTime = 0
        duration = 1
        updateNowPlaying(for: track)

        if autoplay {
            player.play()
            isPlaying = true
        } else {
            player.pause()
            isPlaying = false
        }
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }

    private func installObservers() {
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self else { return }
            let seconds = time.seconds
            if seconds.isFinite {
                self.currentTime = seconds
            }

            if let itemDuration = self.player.currentItem?.duration.seconds, itemDuration.isFinite, itemDuration > 0 {
                self.duration = itemDuration
            }
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTrackEnded),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }

    private func seedDownloads() {
        for track in MusicCatalog.tracks {
            if FileManager.default.fileExists(atPath: localFileURL(for: track).path) {
                downloadStates[track.id] = .downloaded
            }
        }
    }

    private var downloadsDirectory: URL {
        let baseURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first ?? FileManager.default.temporaryDirectory
        return baseURL.appendingPathComponent("JiixDownloads", isDirectory: true)
    }

    private func localFileURL(for track: Track) -> URL {
        let fileExtension = track.streamURL.pathExtension.isEmpty ? "mp3" : track.streamURL.pathExtension
        return downloadsDirectory.appendingPathComponent(track.id).appendingPathExtension(fileExtension)
    }

    private func playbackURL(for track: Track) -> URL {
        let localURL = localFileURL(for: track)
        if FileManager.default.fileExists(atPath: localURL.path) {
            return localURL
        }
        return track.streamURL
    }

    private func registerRecent(_ track: Track) {
        recentTrackIDs.removeAll { $0 == track.id }
        recentTrackIDs.insert(track.id, at: 0)
        if recentTrackIDs.count > 12 {
            recentTrackIDs = Array(recentTrackIDs.prefix(12))
        }
    }

    private func updateNowPlaying(for track: Track) {
        let info: [String: Any] = [
            MPMediaItemPropertyTitle: track.title,
            MPMediaItemPropertyArtist: track.artist,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPMediaItemPropertyAlbumTitle: selectedEqualizerPreset.rawValue
        ]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    @objc private func handleTrackEnded() {
        playNext()
    }
}
