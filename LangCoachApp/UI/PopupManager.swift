import AppKit
import SwiftUI

@MainActor
final class PopupManager {
    private var panel: NSPanel?
    func show(correction: CorrectionResponse, showsExplanation: Bool, onIgnore: @escaping () -> Void, onReplace: @escaping () -> Void) {
        panel?.close()
        let panel = NSPanel(contentRect: NSRect(x: 0, y: 0, width: 390, height: 230), styleMask: [.titled, .closable, .nonactivatingPanel], backing: .buffered, defer: false)
        panel.title = "LangCoach suggestion"
        panel.level = .floating
        panel.isReleasedWhenClosed = false
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.contentView = NSHostingView(rootView: CorrectionPopup(correction: correction, showsExplanation: showsExplanation, ignore: { panel.close(); onIgnore() }, replace: { panel.close(); onReplace() }))
        panel.center(); panel.makeKeyAndOrderFront(nil)
        self.panel = panel
    }
}

private struct CorrectionPopup: View {
    let correction: CorrectionResponse
    let showsExplanation: Bool
    let ignore: () -> Void
    let replace: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Suggested correction").font(.headline)
            Text(correction.original).foregroundStyle(.secondary).strikethrough()
            Text(correction.corrected).fontWeight(.medium)
            if showsExplanation, let explanation = correction.errors.first?.explanation { Text(explanation).font(.caption).foregroundStyle(.secondary) }
            Spacer()
            HStack { Spacer(); Button("Ignore", action: ignore); Button("Replace", action: replace).keyboardShortcut(.defaultAction) }
        }.padding(18)
    }
}
