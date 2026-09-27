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

struct RecommendationResponse: Codable, Sendable {
    let recommendations: [GrammarRecommendation]
}

struct GrammarRecommendation: Codable, Sendable {
    let type: String
    let title: String
    let explanation: String
    let practice: String
    let examples: [String]
}
