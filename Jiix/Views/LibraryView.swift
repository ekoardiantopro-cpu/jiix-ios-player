import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var player: PlayerController

    var body: some View {
        NavigationStack {
            List {
                Section("Quick Access") {
                    libraryCard(
                        title: "Liked Songs",
                        subtitle: "\(player.likedTracks.count) tracks saved",
                        icon: "heart.fill",
                        color: .pink
                    )
                    libraryCard(
                        title: "Recently Played",
                        subtitle: "\(player.recentTracks.count) tracks in history",
                        icon: "clock.fill",
                        color: .orange
                    )
                    libraryCard(
                        title: "Offline Downloads",
                        subtitle: "\(player.downloadedTracks.count) tracks on device",
                        icon: "arrow.down.circle.fill",
                        color: .blue
                    )
                    libraryCard(
                        title: "Equalizer",
                        subtitle: player.selectedEqualizerPreset.rawValue,
                        icon: player.selectedEqualizerPreset.iconName,
                        color: .purple
                    )
                }

                if !player.downloadedTracks.isEmpty {
                    Section("Offline Downloads") {
                        ForEach(player.downloadedTracks) { track in
                            trackButton(track)
                        }
                    }
                }

                if !player.likedTracks.isEmpty {
                    Section("Liked Songs") {
                        ForEach(player.likedTracks) { track in
                            trackButton(track)
                        }
                    }
                }

                if !player.recentTracks.isEmpty {
                    Section("Recently Played") {
                        ForEach(player.recentTracks.prefix(5)) { track in
                            trackButton(track)
                        }
                    }
                }

                Section("Recommended Playlist") {
                    ForEach(MusicCatalog.tracks) { track in
                        trackButton(track)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Library")
        }
    }

    private func trackButton(_ track: Track) -> some View {
        Button {
            player.play(track: track)
        } label: {
            HStack(spacing: 12) {
                AsyncImage(url: track.artworkURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.white.opacity(0.08)
                }
                .frame(width: 54, height: 54)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.headline)
                        .foregroundStyle(.white)

                    HStack(spacing: 6) {
                        Text(track.artist)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.7))

                        if player.isDownloaded(track) {
                            Image(systemName: "arrow.down.circle.fill")
                                .font(.caption)
                                .foregroundColor(.accentColor)
                        }

                        if player.isLiked(track) {
                            Image(systemName: "heart.fill")
                                .font(.caption)
                                .foregroundStyle(.pink)
                        }
                    }
                }

                Spacer()

                Image(systemName: "play.circle.fill")
                    .font(.title3)
                    .foregroundColor(.accentColor)
            }
            .padding(.vertical, 4)
        }
        .listRowBackground(Color.black)
    }

    private func libraryCard(title: String, subtitle: String, icon: String, color: Color) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(color.opacity(0.2))
                Image(systemName: icon)
                    .foregroundStyle(color)
            }
            .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundStyle(.white)
                    .font(.headline)

                Text(subtitle)
                    .foregroundStyle(.white.opacity(0.65))
                    .font(.subheadline)
            }
        }
        .listRowBackground(Color.black)
    }
}
