//
//  WebService.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/7/24.
//

import Foundation

enum WebServiceError: Error {
    case badURL
    case badRequest
    case decodingError
}

struct WebService {
    func getRequest<T: Decodable>(endpoint: String) async throws -> T {
        guard let url = URL(string: endpoint) else {
            throw WebServiceError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WebServiceError.badRequest
        }
        
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            throw WebServiceError.decodingError
        }
        
        return decodedData
    }
}
