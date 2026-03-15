import Foundation

struct Track: Identifiable, Hashable {
    let id: String
    let title: String
    let artist: String
    let artworkURL: URL
    let streamURL: URL
    let genre: String
    let mood: String
    let durationText: String
    let description: String
}

enum EqualizerPreset: String, CaseIterable, Identifiable {
    case flat = "Flat"
    case bassBoost = "Bass Boost"
    case vocal = "Vocal"
    case electronic = "Electronic"
    case lateNight = "Late Night"

    var id: String { rawValue }

    var subtitle: String {
        switch self {
        case .flat:
            return "Natural and balanced"
        case .bassBoost:
            return "Punchier lows for bigger impact"
        case .vocal:
            return "Cleaner mids for voices"
        case .electronic:
            return "Sharper highs and tighter lows"
        case .lateNight:
            return "Softer edges for quiet listening"
        }
    }

    var iconName: String {
        switch self {
        case .flat:
            return "slider.horizontal.3"
        case .bassBoost:
            return "waveform.path.ecg"
        case .vocal:
            return "music.mic"
        case .electronic:
            return "dot.radiowaves.left.and.right"
        case .lateNight:
            return "moon.stars.fill"
        }
    }
}

enum RepeatMode: String, CaseIterable {
    case off = "Repeat Off"
    case all = "Repeat All"
    case one = "Repeat One"

    var iconName: String {
        switch self {
        case .off:
            return "repeat"
        case .all:
            return "repeat"
        case .one:
            return "repeat.1"
        }
    }

    var tintOpacity: Double {
        switch self {
        case .off:
            return 0.45
        case .all, .one:
            return 1
        }
    }
}

enum DownloadState: Equatable {
    case notDownloaded
    case downloading
    case downloaded
    case failed
}
