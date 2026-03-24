//
//  NeuroKit.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

public actor NeuroKit {
    
    private let service: NeuroService
    private let streamService: NeuroStreamService
    private let storage: ChatStorage
    
    private var messages: [Message] = []
    
    public init(
        configuration: NeuroConfiguration,
        apiKeyProvider: APIKeyProvider,
        storage: ChatStorage = InMemoryChatStorage()
    ) {
        self.service = NeuroService(
            model: configuration.model,
            apiKey: apiKeyProvider.getAPIKey()
        )
        
        self.streamService = NeuroStreamService(
            model: configuration.model,
            apiKey: apiKeyProvider.getAPIKey()
        )
        
        self.storage = storage
        
        self.messages = storage.load()
        
        if messages.isEmpty {
            messages.append(
                Message(role: .system, content: configuration.systemPrompt)
            )
        }
    }
}

public extension NeuroKit {
    
    func send(_ text: String) async throws -> String {
        
        messages.append(Message(role: .user, content: text))
        
        let snapshot = messages
        
        let reply = try await service.send(messages: snapshot)
        
        messages.append(Message(role: .assistant, content: reply))
        
        storage.save(messages)
        
        return reply
    }
}


public extension NeuroKit {
    
    func stream(_ text: String) -> AsyncThrowingStream<String, Error> {
        
        AsyncThrowingStream { continuation in
            
            Task {
                do {

                    self.appendUserMessage(text)
                    
                    let currentMessages = self.messages
                    
                    var fullResponse = ""
                    
                    for try await chunk in await self.streamService.stream(messages: currentMessages) {
                        fullResponse += chunk
                        continuation.yield(chunk)
                    }
                    
                    self.appendAIMessage(fullResponse)
                    
                    continuation.finish()
                    
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

private extension NeuroKit {
    
    func appendUserMessage(_ text: String) {
        messages.append(Message(role: .user, content: text))
    }
    
    func appendAIMessage(_ text: String) {
        messages.append(Message(role: .assistant, content: text))
        storage.save(messages)
    }
}

public extension NeuroKit {
    
    func reset() {
        messages.removeAll()
        storage.save(messages)
    }
}
