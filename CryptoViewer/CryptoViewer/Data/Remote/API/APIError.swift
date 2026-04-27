//
//  APIError.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/24/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case emptyResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL:             return "Invalid URL."
        case .invalidResponse:        return "Invalid server response."
        case .httpError(let code):    return "HTTP error \(code)."
        case .decodingError(let err): return "Decoding failed: \(err.localizedDescription)"
        case .emptyResponse:          return "The server returned an empty response."
        }
    }
}
