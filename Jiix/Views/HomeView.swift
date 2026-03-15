import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var player: PlayerController
    private let featuredTracks = Array(MusicCatalog.tracks.prefix(4))

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    heroSection
                    smartControlsSection
                    moodSection
                    recentSection
                    offlineSection
                    trendingSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 140)
            }
            .background(
                LinearGradient(
                    colors: [Color(red: 0.05, green: 0.09, blue: 0.08), .black, Color(red: 0.07, green: 0.11, blue: 0.09)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("JIIX")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "bell.badge.fill")
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
        }
    }

    private var smartControlsSection: some View {
        HStack(spacing: 14) {
            dashboardCard(
                title: "Offline Mode",
                value: player.offlineOnlyEnabled ? "On" : "Auto",
                subtitle: "\(player.downloadedTracks.count) songs ready",
                icon: "arrow.down.circle.fill",
                color: Color(red: 0.12, green: 0.42, blue: 0.78)
            ) {
                player.offlineOnlyEnabled.toggle()
            }

            dashboardCard(
                title: "Equalizer",
                value: player.selectedEqualizerPreset.rawValue,
                subtitle: player.selectedEqualizerPreset.subtitle,
                icon: player.selectedEqualizerPreset.iconName,
                color: Color(red: 0.55, green: 0.18, blue: 0.76)
            ) {
                cycleEqualizer()
            }
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.accentColor, Color(red: 0.05, green: 0.2, blue: 0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 220)

            VStack(alignment: .leading, spacing: 12) {
                Text("Featured Mix")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.8))

                Text(MusicCatalog.featuredMixTitle)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Fresh electronic pop, smooth late-night R&B, dan playlist kerja fokus.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    if let firstTrack = MusicCatalog.tracks.first {
                        player.play(track: firstTrack)
                    }
                } label: {
                    Label("Play Now", systemImage: "play.fill")
                        .font(.headline)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(Capsule())
                }
            }
            .padding(24)
        }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Continue Listening")
                .font(.title3.bold())
                .foregroundStyle(.white)

            if player.recentTracks.isEmpty {
                Text("Putar lagu pertama Anda, nanti riwayat dan shortcut cepat akan muncul di sini.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.62))
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            } else {
                ForEach(player.recentTracks.prefix(3)) { track in
                    Button {
                        player.play(track: track)
                    } label: {
                        TrackRow(track: track, showsDescription: true)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var offlineSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Offline Ready")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                Spacer()

                Text("\(player.downloadedTracks.count) saved")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.65))
            }

            if player.downloadedTracks.isEmpty {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.down.circle.dotted")
                        .font(.title2)
                        .foregroundColor(.accentColor)

                    Text("Unduh trek favorit dari Search atau Now Playing untuk diputar tanpa internet.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.68))
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(player.downloadedTracks.prefix(5)) { track in
                            Button {
                                player.play(track: track)
                            } label: {
                                offlineCard(for: track)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }

    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Browse by Mood")
                .font(.title3.bold())
                .foregroundStyle(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(MusicCatalog.moods, id: \.self) { mood in
                        Text(mood)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.08))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Trending Now")
                .font(.title3.bold())
                .foregroundStyle(.white)

            ForEach(featuredTracks) { track in
                Button {
                    player.play(track: track)
                } label: {
                    TrackRow(track: track)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func dashboardCard(title: String, value: String, subtitle: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)

                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.7))

                Text(value)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, minHeight: 132, alignment: .leading)
            .padding(18)
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func offlineCard(for track: Track) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: track.artworkURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.white.opacity(0.08)
            }
            .frame(width: 150, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            Text(track.title)
                .font(.headline)
                .foregroundStyle(.white)
                .lineLimit(1)

            Text(track.artist)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.65))
                .lineLimit(1)

            Label("Offline", systemImage: "arrow.down.circle.fill")
                .font(.caption.weight(.semibold))
                .foregroundColor(.accentColor)
        }
        .frame(width: 150, alignment: .leading)
    }

    private func cycleEqualizer() {
        let presets = EqualizerPreset.allCases
        guard let currentIndex = presets.firstIndex(of: player.selectedEqualizerPreset) else {
            player.setEqualizerPreset(.flat)
            return
        }

        let nextIndex = presets.index(after: currentIndex)
        let preset = nextIndex == presets.endIndex ? presets[0] : presets[nextIndex]
        player.setEqualizerPreset(preset)
    }
}
