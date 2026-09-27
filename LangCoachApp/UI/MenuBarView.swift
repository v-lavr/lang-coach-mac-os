import AppKit
import SwiftUI

struct MenuBarView: View {
    @Bindable var manager: CorrectionManager
    @Environment(\.openSettings) private var openSettings
    var body: some View {
        @Bindable var settings = manager.settings
        Toggle("Enable Corrections", isOn: $settings.correctionsEnabled)
        Text("Corrections today: \(manager.correctionsToday)")
        Button(manager.isLoadingRecommendations ? "Loading recommendations…" : "Get grammar recommendations") {
            manager.loadRecommendations()
        }
        .disabled(manager.isLoadingRecommendations)
        Divider()
        Button("Settings…") { openSettings() }
        Divider()
        Button("Quit LangCoach") { NSApplication.shared.terminate(nil) }
    }
}
