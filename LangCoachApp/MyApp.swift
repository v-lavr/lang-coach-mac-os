import SwiftUI

@main
struct LangCoachApp: App {
    @State private var correctionManager = CorrectionManager()

    var body: some Scene {
        MenuBarExtra("LangCoach", systemImage: correctionManager.isEnabled ? "text.badge.checkmark" : "text.badge.xmark") {
            MenuBarView(manager: correctionManager)
        }
        .menuBarExtraStyle(.menu)

        Settings {
            ContentView()
                .environment(correctionManager)
        }
    }
}
