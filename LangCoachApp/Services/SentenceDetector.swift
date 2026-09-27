import Foundation

struct SentenceDetector {
    func completedSentence(in text: String) -> String? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let last = trimmed.last, ".?!".contains(last) else { return nil }
        let beforeLast = trimmed.dropLast()
        let start = beforeLast.lastIndex(where: { ".?!".contains($0) }).map { trimmed.index(after: $0) } ?? trimmed.startIndex
        let sentence = String(trimmed[start...]).trimmingCharacters(in: .whitespacesAndNewlines)
        return sentence.isEmpty ? nil : sentence
    }
}
