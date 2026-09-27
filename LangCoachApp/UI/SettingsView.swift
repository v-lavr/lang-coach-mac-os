import SwiftUI

struct SettingsView: View {
    @Environment(CorrectionManager.self) private var manager
    var body: some View {
        @Bindable var settings = manager.settings
        Form {
            Toggle("Enable corrections", isOn: $settings.correctionsEnabled)
            Toggle("Show explanations", isOn: $settings.showExplanations)
            TextField("API URL", text: $settings.apiURL)
            SecureField("Bearer token", text: $settings.bearerToken)
            Text("For development only. The real app should use Google sign-in or another production authentication flow.")
                .font(.caption)
                .foregroundStyle(.secondary)
            LabeledContent("Accessibility") {
                if manager.accessibilityGranted { Text("Granted").foregroundStyle(.green) }
                else { Button("Grant Permission") { manager.requestAccessibilityPermission() } }
            }
            if !manager.accessibilityGranted { Text("LangCoach needs Accessibility permission to read and replace text in TextEdit.").font(.caption).foregroundStyle(.secondary) }
        }.formStyle(.grouped)
    }
}
