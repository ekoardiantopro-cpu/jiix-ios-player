import SwiftUI

struct RootView: View {
    @EnvironmentObject private var player: PlayerController

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }

                LibraryView()
                    .tabItem {
                        Label("Library", systemImage: "music.note.list")
                    }
            }
            .tint(.accentColor)
            .preferredColorScheme(.dark)

            if let track = player.currentTrack {
                MiniPlayerView(track: track)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 56)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .sheet(isPresented: $player.isShowingNowPlaying) {
            NowPlayingView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}
