import Foundation
import Observation

@Observable @MainActor
final class AppSettings {
    static let shared = AppSettings()
    var correctionsEnabled: Bool { didSet { defaults.set(correctionsEnabled, forKey: Keys.enabled) } }
    var showExplanations: Bool { didSet { defaults.set(showExplanations, forKey: Keys.explanations) } }
    var apiURL: String { didSet { defaults.set(apiURL, forKey: Keys.apiURL) } }
    // In production, replace this development-only token with Google sign-in (or
    // another production authentication flow) and store credentials in Keychain.
    var bearerToken: String { didSet { defaults.set(bearerToken, forKey: Keys.bearerToken) } }
    private let defaults = UserDefaults.standard
    private enum Keys { static let enabled = "correctionsEnabled"; static let explanations = "showExplanations"; static let apiURL = "apiURL"; static let bearerToken = "bearerToken" }
    private init() {
        correctionsEnabled = defaults.object(forKey: Keys.enabled) as? Bool ?? true
        showExplanations = defaults.object(forKey: Keys.explanations) as? Bool ?? true
        let savedAPIURL = defaults.string(forKey: Keys.apiURL)
        if savedAPIURL == "http://127.0.0.1:8000" {
            apiURL = "https://lang-coach-s.test"
            defaults.set("https://lang-coach-s.test", forKey: Keys.apiURL)
        } else {
            apiURL = savedAPIURL ?? "https://lang-coach-s.test"
        }
        bearerToken = defaults.string(forKey: Keys.bearerToken) ?? ""
    }
}
