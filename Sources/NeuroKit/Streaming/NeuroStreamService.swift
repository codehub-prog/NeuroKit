//
//  NeuroStreamService.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

final class NeuroStreamService: Sendable {
    
    private let apiKey: String
    private let model: String
    
    init(model: String, apiKey: String) {
        self.model = model
        self.apiKey = apiKey
    }
    
    @MainActor func stream(messages: [Message]) -> AsyncThrowingStream<String, Error> {
        
        let model = self.model
        
        return AsyncThrowingStream { continuation in
            
            let task = Task {
                do {
                    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let body: [String: Any] = [
                        "model": model,
                        "stream": true,
                        "messages": messages.map {
                            ["role": $0.role.rawValue, "content": $0.content]
                        }
                    ]
                    
                    request.httpBody = try JSONSerialization.data(withJSONObject: body)
                    
                    let (bytes, response) = try await URLSession.shared.bytes(for: request)
                    
                    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                        continuation.finish(throwing: URLError(.badServerResponse))
                        return
                    }
                    
                    for try await line in bytes.lines {
                        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        guard !trimmed.isEmpty else { continue }
                        
                        if trimmed == "data: [DONE]" {
                            continuation.finish()
                            return
                        }
                        
                        if trimmed.hasPrefix("data: ") {
                            let jsonString = String(trimmed.dropFirst(6))
                            
                            if let data = jsonString.data(using: .utf8),
                               let chunk = try? JSONDecoder().decode(StreamResponse.self, from: data),
                               let text = chunk.choices.first?.delta?.content {
                                
                                continuation.yield(text)
                            }
                        }
                    }
                    
                    continuation.finish()
                    
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }
}
