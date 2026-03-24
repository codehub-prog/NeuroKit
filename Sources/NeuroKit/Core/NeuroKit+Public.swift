//
//  NeuroKit+Public.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

public extension NeuroKit {
    
    func send(_ text: String) async throws -> String {
        messages.append(Message(role: .user, content: text))
        
        let reply = try await streamService.send(messages: messages)
        
        messages.append(Message(role: .assistant, content: reply))
        
        storage.save(messages)
        
        return reply
    }
    
    @MainActor func stream(_ text: String) -> AsyncThrowingStream<String, Error> {
        
        messages.append(Message(role: .user, content: text))
        
        return AsyncThrowingStream { continuation in
            
            Task {
                do {
                    var fullResponse = ""
                    
                    for try await chunk in streamService.stream(messages: messages) {
                        fullResponse += chunk
                        continuation.yield(chunk)
                    }
                    
                    messages.append(Message(role: .assistant, content: fullResponse))
                    storage.save(messages)
                    
                    continuation.finish()
                    
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    func reset() {
        messages.removeAll()
        storage.save(messages)
    }
}
