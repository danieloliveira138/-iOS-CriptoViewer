//
//  ExchangeRepositoryImpl.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/24/26.
//

import Foundation

final class ExchangeRepositoryImpl: ExchangeRepository {
    private let httpClient: HTTPClientProtocol
    private let exchangeItemMapper   = ExchangeItemMapper()
    private let exchangeInfoMapper   = ExchangeInfoMapper()
    private let exchangeAssetsMapper = ExchangeAssetsMapper()

    init(httpClient: HTTPClientProtocol = HTTPClient.shared) {
        self.httpClient = httpClient
    }

    func getExchangesList(start: Int, limit: Int) async throws -> [ExchangeItem] {
        let response: ExchangeMapResponseDTO = try await httpClient.request(
            .exchangeList(start: start, limit: limit)
        )
        guard let data = response.data else {
            throw APIError.emptyResponse
        }
        return data.map { exchangeItemMapper.map($0) }
    }

    func getExchangeInfo(exchangeId: Int) async throws -> ExchangeInfo {
        let response: ExchangeInfoResponseDTO = try await httpClient.request(
            .exchangeInfo(id: exchangeId)
        )
        guard let dto = response.data?["\(exchangeId)"] else {
            throw APIError.emptyResponse
        }
        return exchangeInfoMapper.map(dto)
    }

    func getExchangeAssets(exchangeId: Int) async throws -> ExchangeAssets {
        let response: ExchangeAssetResponseDTO = try await httpClient.request(
            .exchangeAssets(id: exchangeId)
        )
        return exchangeAssetsMapper.map(response)
    }
}
