import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var player: PlayerController
    @State private var query = ""
    @State private var selectedMood = "All"

    private var filteredTracks: [Track] {
        MusicCatalog.tracks.filter { track in
            let matchesQuery = query.isEmpty ||
                track.title.localizedCaseInsensitiveContains(query) ||
                track.artist.localizedCaseInsensitiveContains(query) ||
                track.genre.localizedCaseInsensitiveContains(query) ||
                track.mood.localizedCaseInsensitiveContains(query)
            let matchesMood = selectedMood == "All" || track.mood == selectedMood
            return matchesQuery && matchesMood
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                searchBar
                moodFilter

                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(filteredTracks) { track in
                            VStack(spacing: 10) {
                                Button {
                                    player.play(track: track)
                                } label: {
                                    TrackRow(track: track, showsDescription: true)
                                }
                                .buttonStyle(.plain)

                                actionBar(for: track)
                            }
                        }
                    }
                    .padding(.bottom, 140)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Search")
        }
    }

    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.7))

            TextField("Cari lagu, artis, mood", text: $query)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(.white)
        }
        .padding(14)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var moodFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(["All"] + MusicCatalog.moods, id: \.self) { mood in
                    Button {
                        selectedMood = mood
                    } label: {
                        Text(mood)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(selectedMood == mood ? Color.accentColor : Color.white.opacity(0.08))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func actionBar(for track: Track) -> some View {
        HStack(spacing: 10) {
            actionButton(
                title: player.isLiked(track) ? "Liked" : "Favorite",
                icon: player.isLiked(track) ? "heart.fill" : "heart",
                color: .pink
            ) {
                player.toggleLike(for: track)
            }

            actionButton(
                title: titleForDownload(track),
                icon: iconForDownload(track),
                color: .accentColor
            ) {
                handleDownload(for: track)
            }
        }
    }

    private func actionButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.05))
                .foregroundStyle(color)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func titleForDownload(_ track: Track) -> String {
        switch player.downloadState(for: track) {
        case .notDownloaded:
            return "Download"
        case .downloading:
            return "Downloading"
        case .downloaded:
            return "Saved Offline"
        case .failed:
            return "Retry Download"
        }
    }

    private func iconForDownload(_ track: Track) -> String {
        switch player.downloadState(for: track) {
        case .notDownloaded:
            return "arrow.down.circle"
        case .downloading:
            return "arrow.triangle.2.circlepath.circle"
        case .downloaded:
            return "checkmark.circle.fill"
        case .failed:
            return "exclamationmark.triangle.fill"
        }
    }

    private func handleDownload(for track: Track) {
        switch player.downloadState(for: track) {
        case .downloaded:
            player.deleteDownload(for: track)
        case .downloading:
            break
        case .notDownloaded, .failed:
            player.download(track: track)
        }
    }
}
