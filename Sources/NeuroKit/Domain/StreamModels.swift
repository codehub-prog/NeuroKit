//
//  StreamModels.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

struct StreamResponse: Codable {
    let choices: [StreamChoice]
}

struct StreamChoice: Codable {
    let delta: Delta?
}

struct Delta: Codable {
    let content: String?
}
