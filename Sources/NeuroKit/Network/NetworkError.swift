//
//  NetworkError.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case decodingError
    case serverError(String)
}
