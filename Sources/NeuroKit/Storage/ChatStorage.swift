//
//  ChatStorage.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

public protocol ChatStorage {
    func save(_ messages: [Message])
    func load() -> [Message]
}
