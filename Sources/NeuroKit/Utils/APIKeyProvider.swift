//
//  APIKeyProvider.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

public protocol APIKeyProvider {
    func getAPIKey() -> String
}
