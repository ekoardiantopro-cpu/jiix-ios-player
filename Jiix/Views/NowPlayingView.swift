import Foundation
import SwiftUI

struct NowPlayingView: View {
    @EnvironmentObject private var player: PlayerController

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.07, green: 0.16, blue: 0.13), .black, Color(red: 0.12, green: 0.08, blue: 0.16)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            if let track = player.currentTrack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        Capsule()
                            .fill(.white.opacity(0.35))
                            .frame(width: 44, height: 5)
                            .padding(.top, 8)

                        AsyncImage(url: track.artworkURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(Color.white.opacity(0.08))
                        }
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                        .shadow(color: .black.opacity(0.4), radius: 24, y: 16)

                        VStack(spacing: 8) {
                            Text(track.title)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)

                            Text(track.artist)
                                .font(.title3)
                                .foregroundStyle(.white.opacity(0.7))

                            Text(track.description)
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.65))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }

                        quickStatus(for: track)

                        VStack(spacing: 10) {
                            Slider(
                                value: Binding(
                                    get: { player.currentTime / max(player.duration, 1) },
                                    set: { player.seek(to: $0) }
                                ),
                                in: 0...1
                            )
                            .tint(.accentColor)

                            HStack {
                                Text(formatTime(player.currentTime))
                                Spacer()
                                Text(formatTime(player.duration))
                            }
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.65))
                        }
                        .padding(.horizontal, 24)

                        HStack(spacing: 18) {
                            secondaryControl(
                                systemName: player.isShuffleEnabled ? "shuffle.circle.fill" : "shuffle.circle",
                                isActive: player.isShuffleEnabled
                            ) {
                                player.isShuffleEnabled.toggle()
                            }

                            controlButton(systemName: "backward.fill") {
                                player.playPrevious()
                            }

                            Button {
                                player.togglePlayback()
                            } label: {
                                Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 72))
                                    .foregroundStyle(.white)
                            }

                            controlButton(systemName: "forward.fill") {
                                player.playNext()
                            }

                            secondaryControl(
                                systemName: player.repeatMode.iconName,
                                isActive: player.repeatMode != .off
                            ) {
                                player.cycleRepeatMode()
                            }
                        }

                        featurePanel(for: track)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 28)
                }
            }
        }
    }

    private func quickStatus(for track: Track) -> some View {
        HStack(spacing: 10) {
            statusBadge(
                title: player.isDownloaded(track) ? "Offline Ready" : "Streaming",
                icon: player.isDownloaded(track) ? "arrow.down.circle.fill" : "waveform"
            )
            statusBadge(title: player.selectedEqualizerPreset.rawValue, icon: player.selectedEqualizerPreset.iconName)
            statusBadge(title: player.repeatMode.rawValue, icon: player.repeatMode.iconName)
        }
    }

    private func featurePanel(for track: Track) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Player Tools")
                .font(.headline)
                .foregroundStyle(.white)

            HStack(spacing: 12) {
                toolButton(
                    title: player.isLiked(track) ? "Liked" : "Favorite",
                    icon: player.isLiked(track) ? "heart.fill" : "heart",
                    color: .pink
                ) {
                    player.toggleLike(for: track)
                }

                toolButton(
                    title: downloadTitle(for: track),
                    icon: downloadIcon(for: track),
                    color: .accentColor
                ) {
                    handleDownload(for: track)
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Equalizer")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.72))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(EqualizerPreset.allCases) { preset in
                            Button {
                                player.setEqualizerPreset(preset)
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    Label(preset.rawValue, systemImage: preset.iconName)
                                        .font(.subheadline.weight(.semibold))
                                    Text(preset.subtitle)
                                        .font(.caption)
                                        .lineLimit(2)
                                }
                                .foregroundStyle(.white)
                                .padding(14)
                                .frame(width: 170, alignment: .leading)
                                .background(player.selectedEqualizerPreset == preset ? Color.accentColor.opacity(0.85) : Color.white.opacity(0.07))
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }

            Toggle(isOn: $player.offlineOnlyEnabled) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Offline only mode")
                        .foregroundStyle(.white)
                    Text("Saat aktif, queue memprioritaskan track yang sudah diunduh.")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.58))
                }
            }
            .tint(.accentColor)
        }
        .padding(18)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
    }

    private func statusBadge(title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(Color.white.opacity(0.08))
            .clipShape(Capsule())
    }

    private func toolButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.white.opacity(0.06))
                .foregroundStyle(color)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func controlButton(systemName: String, action: @escaping @MainActor () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .font(.system(size: 28))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color.white.opacity(0.08))
                .clipShape(Circle())
        }
    }

    private func secondaryControl(systemName: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 24))
                .foregroundStyle(isActive ? Color.accentColor : Color.white.opacity(0.55))
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
    }

    private func downloadTitle(for track: Track) -> String {
        switch player.downloadState(for: track) {
        case .notDownloaded:
            return "Download"
        case .downloading:
            return "Downloading"
        case .downloaded:
            return "Remove Offline"
        case .failed:
            return "Retry Download"
        }
    }

    private func downloadIcon(for track: Track) -> String {
        switch player.downloadState(for: track) {
        case .notDownloaded:
            return "arrow.down.circle"
        case .downloading:
            return "arrow.triangle.2.circlepath.circle"
        case .downloaded:
            return "trash.circle"
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

    private func formatTime(_ seconds: Double) -> String {
        guard seconds.isFinite else { return "0:00" }
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let remainder = totalSeconds % 60
        return "\(minutes):" + String(format: "%02d", remainder)
    }
}
