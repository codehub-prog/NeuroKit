//
//  NeuroConfiguration.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

public struct NeuroConfiguration {
    
    public let systemPrompt: String
    public let model: String
    
    public init(systemPrompt: String, model: String = "gpt-4o-mini") {
        self.systemPrompt = systemPrompt
        self.model = model
    }
}


public extension NeuroConfiguration {
    
    @MainActor static let travel = NeuroConfiguration(
        systemPrompt: "You are a travel expert AI helping with trips and trekking."
    )
    
    @MainActor static let dating = NeuroConfiguration(
        systemPrompt: "You are a dating coach helping users with conversations."
    )
}
