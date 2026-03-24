//
//  NeuroViewModel.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

import SwiftUI
import Combine

@MainActor
final class NeuroViewModel: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    @Published var isTyping: Bool = false
    
    private let neuro: NeuroKit
    
    init(neuro: NeuroKit) {
        self.neuro = neuro
    }
    
    // MARK: - Send (Normal)
    func send(_ text: String) {
        appendUserMessage(text)
        isTyping = true
        
        Task {
            do {
                let reply = try await neuro.send(text)
                appendAIMessage(reply)
            } catch {
                appendAIMessage("Error: \(error.localizedDescription)")
            }
            isTyping = false
        }
    }
    
    // MARK: - Streaming (if added later)
    func stream(_ text: String) {
        appendUserMessage(text)
        isTyping = true
        
        Task {
            do {
                var aiText = ""
                appendAIMessage("") // placeholder
                
                let index = messages.count - 1
                
                for try await chunk in neuro.stream(text) {
                    aiText += chunk
                    messages[index].text = aiText
                }
            } catch {
                appendAIMessage("Error: \(error.localizedDescription)")
            }
            
            isTyping = false
        }
    }
    
    // MARK: - Helpers
    private func appendUserMessage(_ text: String) {
        messages.append(ChatMessage(text: text, isUser: true))
    }
    
    private func appendAIMessage(_ text: String) {
        messages.append(ChatMessage(text: text, isUser: false))
    }
}
