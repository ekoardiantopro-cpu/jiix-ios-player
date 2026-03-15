import Foundation

enum MusicCatalog {
    static let featuredMixTitle = "JIIX Daily Mix"

    static let tracks: [Track] = [
        Track(
            id: "skyline-pulse",
            title: "Skyline Pulse",
            artist: "Aurora Lane",
            artworkURL: URL(string: "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?auto=format&fit=crop&w=900&q=80")!,
            streamURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!,
            genre: "Pop",
            mood: "Drive",
            durationText: "06:13",
            description: "Bright electro-pop anthem for late night city drives."
        ),
        Track(
            id: "neon-afterglow",
            title: "Neon Afterglow",
            artist: "Mira Sol",
            artworkURL: URL(string: "https://images.unsplash.com/photo-1501386761578-eac5c94b800a?auto=format&fit=crop&w=900&q=80")!,
            streamURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3")!,
            genre: "Dance",
            mood: "Party",
            durationText: "05:31",
            description: "Club-inspired beat with glossy synth layers."
        ),
        Track(
            id: "midnight-code",
            title: "Midnight Code",
            artist: "Polar Echo",
            artworkURL: URL(string: "https://images.unsplash.com/photo-1516280440614-37939bbacd81?auto=format&fit=crop&w=900&q=80")!,
            streamURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3")!,
            genre: "Electronic",
            mood: "Focus",
            durationText: "05:03",
            description: "Steady rhythm and clean textures for deep work."
        ),
        Track(
            id: "golden-hour-run",
            title: "Golden Hour Run",
            artist: "Vela Coast",
            artworkURL: URL(string: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=900&q=80")!,
            streamURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3")!,
            genre: "Indie",
            mood: "Workout",
            durationText: "04:48",
            description: "Warm guitars with a tempo built for movement."
        ),
        Track(
            id: "velvet-signals",
            title: "Velvet Signals",
            artist: "Noir June",
            artworkURL: URL(string: "https://images.unsplash.com/photo-1499364615650-ec38552f4f34?auto=format&fit=crop&w=900&q=80")!,
            streamURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3")!,
            genre: "R&B",
            mood: "Chill",
            durationText: "06:42",
            description: "Smooth vocal textures and low-lit bass lines."
        ),
        Track(
            id: "atlas-hearts",
            title: "Atlas Hearts",
            artist: "Northline",
            artworkURL: URL(string: "https://images.unsplash.com/photo-1498036882173-b41c28a8ba34?auto=format&fit=crop&w=900&q=80")!,
            streamURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3")!,
            genre: "Alternative",
            mood: "Travel",
            durationText: "05:54",
            description: "Wide-screen hooks with cinematic momentum."
        )
    ]

    static let moods = ["Focus", "Party", "Drive", "Workout", "Chill", "Travel"]
}
