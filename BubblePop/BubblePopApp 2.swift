import SwiftUI

@main
struct BubblePopApp: App {
    @StateObject private var progress = PlayerProgress()
    @StateObject private var settings = SettingsStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(progress)
                .environmentObject(settings)
        }
    }
}
