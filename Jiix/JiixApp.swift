import SwiftUI

@main
struct JiixApp: App {
    @StateObject private var player = PlayerController()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(player)
        }
    }
}
