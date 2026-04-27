//
//  ExchangeUseCaseTests.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import XCTest
@testable import CryptoViewer

final class ExchangeUseCaseTests: XCTestCase {

    private var mockRepository: MockExchangeRepository!
    private var useCase: ExchangeUseCaseImpl!

    override func setUp() {
        super.setUp()
        mockRepository = MockExchangeRepository()
        useCase = ExchangeUseCaseImpl(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }

    // MARK: - getExchangesList

    func testGetExchangesList_success_returnsSuccessResult() async {
        mockRepository.exchangesListToReturn = [
            ExchangeItem(id: 1, name: "Kraken", isActive: true)
        ]

        let result = await useCase.getExchangesList(start: 1, limit: 20)

        guard case .success(let items) = result else {
            return XCTFail("Expected success")
        }
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].name, "Kraken")
    }

    func testGetExchangesList_repositoryThrows_returnsErrorResult() async {
        mockRepository.exchangesListError = APIError.invalidResponse

        let result = await useCase.getExchangesList(start: 1, limit: 20)

        guard case .error = result else {
            return XCTFail("Expected error")
        }
    }

    func testGetExchangesList_emptyList_returnsSuccessWithEmptyArray() async {
        mockRepository.exchangesListToReturn = []

        let result = await useCase.getExchangesList(start: 1, limit: 20)

        guard case .success(let items) = result else {
            return XCTFail("Expected success")
        }
        XCTAssertTrue(items.isEmpty)
    }

    // MARK: - getExchangeDetail

    func testGetExchangeDetail_success_returnsInfoWithTradeCoins() async {
        mockRepository.exchangeInfoToReturn = .mock(id: 24, name: "Kraken")
        mockRepository.exchangeAssetsToReturn = ExchangeAssets(items: [
            ExchangeAsset(currencyName: "Bitcoin", currencySymbol: "BTC", priceUsd: 50000.0)
        ])

        let result = await useCase.getExchangeDetail(id: 24)

        guard case .success(let info) = result else {
            return XCTFail("Expected success")
        }
        XCTAssertEqual(info.id, 24)
        XCTAssertEqual(info.name, "Kraken")
        XCTAssertEqual(info.tradeCoins?.count, 1)
        XCTAssertEqual(info.tradeCoins?.first?.name, "Bitcoin (BTC)")
        XCTAssertEqual(info.tradeCoins?.first?.price, 50000.0)
    }

    func testGetExchangeDetail_infoRequestFails_returnsError() async {
        mockRepository.exchangeInfoError = APIError.emptyResponse
        mockRepository.exchangeAssetsToReturn = ExchangeAssets(items: [])

        let result = await useCase.getExchangeDetail(id: 1)

        guard case .error = result else {
            return XCTFail("Expected error")
        }
    }

    func testGetExchangeDetail_assetsRequestFails_returnsSuccessWithNilTradeCoins() async {
        mockRepository.exchangeInfoToReturn = .mock(id: 1)
        mockRepository.exchangeAssetsError = APIError.invalidResponse

        let result = await useCase.getExchangeDetail(id: 1)

        guard case .success(let info) = result else {
            return XCTFail("Expected success")
        }
        XCTAssertNil(info.tradeCoins)
    }

    func testGetExchangeDetail_duplicateAssets_areDeduplicatedInTradeCoins() async {
        mockRepository.exchangeInfoToReturn = .mock(id: 1)
        mockRepository.exchangeAssetsToReturn = ExchangeAssets(items: [
            ExchangeAsset(currencyName: "Bitcoin", currencySymbol: "BTC", priceUsd: 50000.0),
            ExchangeAsset(currencyName: "Bitcoin", currencySymbol: "BTC", priceUsd: 50000.0),
            ExchangeAsset(currencyName: "Ethereum", currencySymbol: "ETH", priceUsd: 3000.0)
        ])

        let result = await useCase.getExchangeDetail(id: 1)

        guard case .success(let info) = result else {
            return XCTFail("Expected success")
        }
        XCTAssertEqual(info.tradeCoins?.count, 2)
    }

    func testGetExchangeDetail_tradeCoinsNameFormat_includesSymbolInParentheses() async {
        mockRepository.exchangeInfoToReturn = .mock(id: 1)
        mockRepository.exchangeAssetsToReturn = ExchangeAssets(items: [
            ExchangeAsset(currencyName: "Ethereum", currencySymbol: "ETH", priceUsd: 3000.0)
        ])

        let result = await useCase.getExchangeDetail(id: 1)

        guard case .success(let info) = result else {
            return XCTFail("Expected success")
        }
        XCTAssertEqual(info.tradeCoins?.first?.name, "Ethereum (ETH)")
    }
}
