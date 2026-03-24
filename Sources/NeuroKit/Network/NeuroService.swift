//
//  NeuroService.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

final class NeuroService: Sendable {
    
    private let model: String
    private let apiKey: String
    private let client = HTTPClient()
    
    init(model: String, apiKey: String) {
        self.model = model
        self.apiKey = apiKey
    }
    
    @MainActor func send(messages: [Message]) async throws -> String {
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": model,
            "messages": messages.map {
                ["role": $0.role.rawValue, "content": $0.content]
            }
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let data = try await client.send(request: request)
        
        let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        return decoded.choices.first?.message.content ?? ""
    }
}
