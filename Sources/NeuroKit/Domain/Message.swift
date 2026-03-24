//
//  Message.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

public struct Message: Codable, Hashable {
    public let role: Role
    public let content: String
}

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    var text: String
    let isUser: Bool
}
