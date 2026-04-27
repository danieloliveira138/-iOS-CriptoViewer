//
//  ExchangeEndpoint.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import Foundation

enum ExchangeEndpoint {
    case exchangeList(start: Int, limit: Int)
    case exchangeInfo(id: Int)
    case exchangeAssets(id: Int)

    func makeURLRequest() throws -> URLRequest {
        guard var components = URLComponents(string: APIConfig.baseURL + path) else {
            throw APIError.invalidURL
        }
        components.queryItems = queryItems

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Secrets.apiKey,      forHTTPHeaderField: "X-CMC_PRO_API_KEY")
        request.setValue("application/json",    forHTTPHeaderField: "Accept")
        return request
    }

    private var path: String {
        switch self {
        case .exchangeList:   return "v1/exchange/map"
        case .exchangeInfo:   return "v1/exchange/info"
        case .exchangeAssets: return "v1/exchange/assets"
        }
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case .exchangeList(let start, let limit):
            return [URLQueryItem(name: "start", value: "\(start)"),
                    URLQueryItem(name: "limit", value: "\(limit)")]
        case .exchangeInfo(let id), .exchangeAssets(let id):
            return [URLQueryItem(name: "id", value: "\(id)")]
        }
    }
}
