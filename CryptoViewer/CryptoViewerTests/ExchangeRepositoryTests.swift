//
//  ExchangeRepositoryTests.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/25/26.
//

import XCTest
@testable import CryptoViewer

final class ExchangeRepositoryTests: XCTestCase {

    private var mockClient: MockHTTPClient!
    private var repository: ExchangeRepositoryImpl!

    override func setUp() {
        super.setUp()
        mockClient = MockHTTPClient()
        repository = ExchangeRepositoryImpl(httpClient: mockClient)
    }

    override func tearDown() {
        mockClient = nil
        repository = nil
        super.tearDown()
    }

    // MARK: - getExchangesList

    func testGetExchangesList_success_returnsMappedItems() async throws {
        mockClient.handler = { _ in
            ExchangeMapResponseDTO(
                data: [
                    ExchangeDTO(id: 1, name: "Kraken", slug: nil, firstHistoricalData: nil,
                                lastHistoricalData: nil, isActive: 1, isListed: nil, isRedistributable: nil),
                    ExchangeDTO(id: 2, name: "Binance", slug: nil, firstHistoricalData: nil,
                                lastHistoricalData: nil, isActive: 0, isListed: nil, isRedistributable: nil)
                ],
                status: .empty
            )
        }

        let result = try await repository.getExchangesList(start: 1, limit: 20)

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, 1)
        XCTAssertEqual(result[0].name, "Kraken")
        XCTAssertTrue(result[0].isActive)
        XCTAssertEqual(result[1].id, 2)
        XCTAssertFalse(result[1].isActive)
    }

    func testGetExchangesList_nilData_throwsEmptyResponse() async {
        mockClient.handler = { _ in
            ExchangeMapResponseDTO(data: nil, status: .empty)
        }

        do {
            _ = try await repository.getExchangesList(start: 1, limit: 20)
            XCTFail("Expected emptyResponse error")
        } catch let error as APIError {
            XCTAssertEqual(error, .emptyResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testGetExchangesList_httpClientThrows_propagatesError() async {
        mockClient.handler = { _ in throw APIError.invalidResponse }

        do {
            _ = try await repository.getExchangesList(start: 1, limit: 20)
            XCTFail("Expected error to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, .invalidResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - getExchangeInfo

    func testGetExchangeInfo_success_returnsMappedExchangeInfo() async throws {
        let exchangeId = 24
        mockClient.handler = { _ in
            ExchangeInfoResponseDTO(
                data: [
                    "\(exchangeId)": ExchangeInfoDTO(
                        id: exchangeId, name: "Kraken", slug: "kraken",
                        logo: "https://logo.com", description: "Desc",
                        dateLaunched: "2011-07-01", notice: nil, countries: nil,
                        fiats: nil, type: nil, makerFee: 0.02, takerFee: 0.05,
                        weeklyVisits: nil, spotVolumeUsd: nil,
                        spotVolumeLastUpdated: nil, urls: nil
                    )
                ],
                status: .empty
            )
        }

        let result = try await repository.getExchangeInfo(exchangeId: exchangeId)

        XCTAssertEqual(result.id, exchangeId)
        XCTAssertEqual(result.name, "Kraken")
        XCTAssertEqual(result.makerFee, 0.02)
        XCTAssertEqual(result.takerFee, 0.05)
    }

    func testGetExchangeInfo_missingKey_throwsEmptyResponse() async {
        mockClient.handler = { _ in
            ExchangeInfoResponseDTO(data: ["999": ExchangeInfoDTO(
                id: 999, name: nil, slug: nil, logo: nil, description: nil,
                dateLaunched: nil, notice: nil, countries: nil, fiats: nil, type: nil,
                makerFee: nil, takerFee: nil, weeklyVisits: nil, spotVolumeUsd: nil,
                spotVolumeLastUpdated: nil, urls: nil
            )], status: .empty)
        }

        do {
            _ = try await repository.getExchangeInfo(exchangeId: 1)
            XCTFail("Expected emptyResponse error")
        } catch let error as APIError {
            XCTAssertEqual(error, .emptyResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testGetExchangeInfo_nilData_throwsEmptyResponse() async {
        mockClient.handler = { _ in
            ExchangeInfoResponseDTO(data: nil, status: .empty)
        }

        do {
            _ = try await repository.getExchangeInfo(exchangeId: 1)
            XCTFail("Expected emptyResponse error")
        } catch let error as APIError {
            XCTAssertEqual(error, .emptyResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - getExchangeAssets

    func testGetExchangeAssets_success_returnsMappedAssets() async throws {
        mockClient.handler = { _ in
            ExchangeAssetResponseDTO(
                data: [
                    ExchangeAssetDTO(
                        walletAddress: nil, balance: nil, platform: nil,
                        currency: CurrencyDTO(cryptoId: 1, priceUsd: 50000.0, symbol: "BTC", name: "Bitcoin")
                    )
                ],
                status: .empty
            )
        }

        let result = try await repository.getExchangeAssets(exchangeId: 1)

        XCTAssertEqual(result.items.count, 1)
        XCTAssertEqual(result.items[0].currencyName, "Bitcoin")
        XCTAssertEqual(result.items[0].currencySymbol, "BTC")
        XCTAssertEqual(result.items[0].priceUsd, 50000.0)
    }

    func testGetExchangeAssets_nilData_returnsEmptyItems() async throws {
        mockClient.handler = { _ in
            ExchangeAssetResponseDTO(data: nil, status: .empty)
        }

        let result = try await repository.getExchangeAssets(exchangeId: 1)

        XCTAssertTrue(result.items.isEmpty)
    }
}

// MARK: - APIError Equatable

extension APIError: Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse),
             (.emptyResponse, .emptyResponse):
            return true
        case (.httpError(let a), .httpError(let b)):
            return a == b
        default:
            return false
        }
    }
}
