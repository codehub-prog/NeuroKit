//
//  InMemoryChatStorage.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

public final class InMemoryChatStorage: ChatStorage {
    
    private var cache: [Message] = []
    
    public init() {}
    
    public func save(_ messages: [Message]) {
        cache = messages
    }
    
    public func load() -> [Message] {
        return cache
    }
}
