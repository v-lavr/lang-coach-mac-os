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

    func show(recommendations: [GrammarRecommendation]) {
        panel?.close()
        let panel = NSPanel(contentRect: NSRect(x: 0, y: 0, width: 480, height: 420), styleMask: [.titled, .closable, .nonactivatingPanel], backing: .buffered, defer: false)
        panel.title = "LangCoach recommendations"
        panel.level = .floating
        panel.isReleasedWhenClosed = false
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.contentView = NSHostingView(rootView: RecommendationsPopup(recommendations: recommendations))
        panel.center()
        panel.makeKeyAndOrderFront(nil)
        self.panel = panel
    }
}

private struct RecommendationsPopup: View {
    let recommendations: [GrammarRecommendation]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Grammar recommendations")
                    .font(.headline)

                if recommendations.isEmpty {
                    Text("Write and correct more sentences to receive recommendations.")
                        .foregroundStyle(.secondary)
                }

                ForEach(Array(recommendations.enumerated()), id: \.offset) { _, recommendation in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(recommendation.title)
                            .fontWeight(.medium)
                        Text(recommendation.explanation)
                        Text("Practice: \(recommendation.practice)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        ForEach(Array(recommendation.examples.enumerated()), id: \.offset) { _, example in
                            Text("• \(example)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(18)
        }
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
