import Foundation
import Observation

@Observable @MainActor
final class CorrectionManager {
    let settings = AppSettings.shared
    private let accessibility = AccessibilityService()
    private let detector = SentenceDetector()
    private let apiClient = APIClient()
    private let popupManager = PopupManager()
    private var poller: Timer?
    private var pendingTask: Task<Void, Never>?
    private var pendingSentence: String?
    private var lastSubmittedSentence = ""
    private var hasLoggedUnavailableFocusedField = false
    private(set) var correctionsToday = 0
    var isEnabled: Bool { settings.correctionsEnabled }
    var accessibilityGranted: Bool { accessibility.hasPermission }
    init() {
        print("LangCoach: Accessibility permission is \(accessibility.hasPermission ? "granted" : "not granted")")
        startMonitoring()
    }
    func startMonitoring() {
        poller?.invalidate()
        poller = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.inspectFocusedField() }
        }
    }
    func requestAccessibilityPermission() { accessibility.requestPermission() }
    private func inspectFocusedField() {
        guard settings.correctionsEnabled else { return }
        guard accessibility.hasPermission else {
            logUnavailableFocusedField("Accessibility permission is not granted")
            return
        }
        guard let field = accessibility.focusedEditableField() else {
            logUnavailableFocusedField("no readable focused editable field")
            return
        }
        hasLoggedUnavailableFocusedField = false
        guard let sentence = detector.completedSentence(in: field.value) else {
            pendingTask?.cancel()
            pendingTask = nil
            pendingSentence = nil
            return
        }
        guard sentence != lastSubmittedSentence else { return }
        // Polling continues while the user pauses after punctuation. Do not restart
        // the debounce for the same unchanged sentence on every poll.
        guard pendingSentence != sentence else { return }
        print("LangCoach: completed sentence detected")
        pendingTask?.cancel()
        pendingSentence = sentence
        pendingTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(650))
            guard !Task.isCancelled, let self, let current = self.accessibility.focusedEditableField(), self.detector.completedSentence(in: current.value) == sentence else { return }
            self.pendingTask = nil
            self.pendingSentence = nil
            self.lastSubmittedSentence = sentence
            await self.check(sentence, field: current)
        }
    }

    private func logUnavailableFocusedField(_ reason: String) {
        guard !hasLoggedUnavailableFocusedField else { return }
        hasLoggedUnavailableFocusedField = true
        print("LangCoach: monitoring paused; \(reason)")
    }
    private func check(_ sentence: String, field: AccessibilityService.EditableField) async {
        do {
            let correction = try await apiClient.check(
                sentence: sentence,
                apiURL: settings.apiURL,
                bearerToken: settings.bearerToken
            )
            present(correction, field: field)
        } catch {
            print("LangCoach: grammar check failed: \(error.localizedDescription)")
        }
    }
    private func present(_ correction: CorrectionResponse, field: AccessibilityService.EditableField) {
        guard correction.changed else { return }
        popupManager.show(correction: correction, showsExplanation: settings.showExplanations, onIgnore: {}, onReplace: { [weak self] in
            guard let self else { return }
            if self.accessibility.replace(correction.original, with: correction.corrected, in: field.element) { self.correctionsToday += 1 }
        })
    }
}
