//
//  HTTPClient.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/25/26.
//

import Foundation

protocol HTTPClientProtocol {
    func request<T: Decodable>(_ endpoint: ExchangeEndpoint) async throws -> T
}

final class HTTPClient: HTTPClientProtocol {
    static let shared = HTTPClient()

    private let session: URLSession

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: ExchangeEndpoint) async throws -> T {
        let urlRequest = try endpoint.makeURLRequest()
        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
