import Foundation

struct CheckRequest: Codable { let text: String }

struct CorrectionResponse: Codable, Sendable {
    let changed: Bool
    let original: String
    let corrected: String
    let errors: [CorrectionError]
}

struct CorrectionError: Codable, Sendable {
    let type: String
    let original: String
    let replacement: String
    let explanation: String
}
