//
//  Mocks.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/25/26.
//

import Foundation
@testable import CryptoViewer

// MARK: - MockHTTPClient

final class MockHTTPClient: HTTPClientProtocol {
    var handler: ((ExchangeEndpoint) throws -> Any)?

    func request<T: Decodable>(_ endpoint: ExchangeEndpoint) async throws -> T {
        guard let result = try handler?(endpoint) as? T else {
            throw APIError.invalidResponse
        }
        return result
    }
}

// MARK: - MockExchangeRepository

final class MockExchangeRepository: ExchangeRepository {
    var exchangesListToReturn: [ExchangeItem] = []
    var exchangesListError: Error?

    var exchangeInfoToReturn: ExchangeInfo?
    var exchangeInfoError: Error?

    var exchangeAssetsToReturn: ExchangeAssets = ExchangeAssets(items: [])
    var exchangeAssetsError: Error?

    func getExchangesList(start: Int, limit: Int) async throws -> [ExchangeItem] {
        if let error = exchangesListError { throw error }
        return exchangesListToReturn
    }

    func getExchangeInfo(exchangeId: Int) async throws -> ExchangeInfo {
        if let error = exchangeInfoError { throw error }
        return exchangeInfoToReturn!
    }

    func getExchangeAssets(exchangeId: Int) async throws -> ExchangeAssets {
        if let error = exchangeAssetsError { throw error }
        return exchangeAssetsToReturn
    }
}

// MARK: - MockExchangeUseCase

final class MockExchangeUseCase: ExchangeUseCase {
    var getListResult: Result<[ExchangeItem]> = .success(data: [])
    var getDetailResult: Result<ExchangeInfo> = .success(data: .mock())

    private(set) var getListCallCount = 0
    private(set) var getListReceivedStart: [Int] = []
    private(set) var getDetailReceivedIds: [Int] = []

    func getExchangesList(start: Int, limit: Int) async -> Result<[ExchangeItem]> {
        getListCallCount += 1
        getListReceivedStart.append(start)
        return getListResult
    }

    func getExchangeDetail(id: Int) async -> Result<ExchangeInfo> {
        getDetailReceivedIds.append(id)
        return getDetailResult
    }
}

// MARK: - Test Fixtures

extension ExchangeInfo {
    static func mock(
        id: Int = 1,
        name: String = "Test Exchange",
        slug: String = "test-exchange",
        makerFee: Double? = 0.1,
        takerFee: Double? = 0.2,
        tradeCoins: [CoinItem]? = nil
    ) -> ExchangeInfo {
        ExchangeInfo(
            id: id,
            name: name,
            slug: slug,
            logo: "https://example.com/logo.png",
            description: "A test exchange description",
            dateLaunched: "2020-01-01T00:00:00.000Z",
            makerFee: makerFee,
            takerFee: takerFee,
            urls: ExchangeUrl(website: ["https://test.com"], twitter: [], facebook: []),
            tradeCoins: tradeCoins
        )
    }
}

extension ExchangeStatusDTO {
    static let empty = ExchangeStatusDTO(
        timestamp: nil, errorCode: nil, errorMessage: nil,
        elapsed: nil, creditCount: nil, notice: nil
    )
}
