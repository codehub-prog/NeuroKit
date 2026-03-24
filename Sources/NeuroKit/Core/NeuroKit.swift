//
//  NeuroKit.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

public final class NeuroKit {
    
    let streamService: NeuroStreamService
    let storage: ChatStorage
    var messages: [Message] = []
    
    public init(
        configuration: NeuroConfiguration,
        apiKeyProvider: APIKeyProvider,
        storage: ChatStorage = InMemoryChatStorage()
    ) {
        self.streamService = NeuroStreamService(
            model: configuration.model,
            apiKeyProvider: apiKeyProvider
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
