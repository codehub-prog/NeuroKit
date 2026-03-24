//
//  HTTPClient.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

final class HTTPClient {
    
    func send(request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse,
              200...299 ~= http.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        return data
    }
}
