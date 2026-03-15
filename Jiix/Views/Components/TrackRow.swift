import SwiftUI

struct TrackRow: View {
    @EnvironmentObject private var player: PlayerController
    let track: Track
    var showsDescription = false

    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: track.artworkURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(0.08))
            }
            .frame(width: 68, height: 68)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(track.title)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text("\(track.artist) • \(track.genre)")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.68))

                if showsDescription {
                    Text(track.description)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                        .lineLimit(2)
                }

                HStack(spacing: 8) {
                    Text(track.mood)
                    Text(player.selectedEqualizerPreset.rawValue)

                    if player.isDownloaded(track) {
                        Label("Offline", systemImage: "arrow.down.circle.fill")
                    }

                    if player.isLiked(track) {
                        Label("Liked", systemImage: "heart.fill")
                    }
                }
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.55))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Text(track.durationText)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white.opacity(0.7))

                Image(systemName: "play.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.accentColor)
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}
