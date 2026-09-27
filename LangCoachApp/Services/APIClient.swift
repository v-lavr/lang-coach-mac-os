import Foundation

enum APIClientError: LocalizedError {
    case invalidURL, invalidResponse, serverStatus(Int)
    var errorDescription: String? {
        switch self { case .invalidURL: "The API URL is invalid."; case .invalidResponse: "The server returned an invalid response."; case .serverStatus(let code): "The server returned status \(code)." }
    }
}

struct APIClient {
    func check(sentence: String, apiURL: String, bearerToken: String) async throws -> CorrectionResponse {
        let baseURL = apiURL.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard let url = URL(string: "\(baseURL)/api/check") else {
            throw APIClientError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let token = bearerToken.trimmingCharacters(in: .whitespacesAndNewlines)
        if !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = try JSONEncoder().encode(CheckRequest(text: sentence))

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIClientError.serverStatus(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(CorrectionResponse.self, from: data)
        } catch {
            throw APIClientError.invalidResponse
        }
    }

    func recommendations(apiURL: String, bearerToken: String) async throws -> RecommendationResponse {
        let baseURL = apiURL.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard let url = URL(string: "\(baseURL)/api/recommendations") else {
            throw APIClientError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let token = bearerToken.trimmingCharacters(in: .whitespacesAndNewlines)
        if !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIClientError.serverStatus(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(RecommendationResponse.self, from: data)
        } catch {
            throw APIClientError.invalidResponse
        }
    }
}
