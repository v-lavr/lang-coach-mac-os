import SwiftUI

/// Kept as the Settings scene's root so the application never needs a main window.
struct ContentView: View {
    var body: some View {
        SettingsView()
            .frame(width: 440)
            .padding()
    }
}

#Preview { ContentView() }
