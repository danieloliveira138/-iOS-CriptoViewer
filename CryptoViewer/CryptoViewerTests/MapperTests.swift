//
//  MapperTests.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/25/26.
//

import XCTest
@testable import CryptoViewer

final class MapperTests: XCTestCase {

    // MARK: - ExchangeItemMapper

    func testExchangeItemMapper_mapsIdAndName() {
        let dto = makeExchangeDTO(id: 24, name: "Kraken", isActive: 1)
        let result = ExchangeItemMapper().map(dto)
        XCTAssertEqual(result.id, 24)
        XCTAssertEqual(result.name, "Kraken")
    }

    func testExchangeItemMapper_isActiveTrue_whenIsActiveIsOne() {
        let dto = makeExchangeDTO(isActive: 1)
        XCTAssertTrue(ExchangeItemMapper().map(dto).isActive)
    }

    func testExchangeItemMapper_isActiveFalse_whenIsActiveIsZero() {
        let dto = makeExchangeDTO(isActive: 0)
        XCTAssertFalse(ExchangeItemMapper().map(dto).isActive)
    }

    func testExchangeItemMapper_isActiveFalse_whenIsActiveIsNil() {
        let dto = makeExchangeDTO(isActive: nil)
        XCTAssertFalse(ExchangeItemMapper().map(dto).isActive)
    }

    // MARK: - ExchangeUrlMapper

    func testExchangeUrlMapper_mapsWebsiteTwitterFacebook() {
        let dto = ExchangeUrlsDTO(
            website: ["https://kraken.com"],
            twitter: ["https://twitter.com/kraken"],
            facebook: ["https://facebook.com/kraken"],
            blog: nil, chat: nil, fee: nil
        )
        let result = ExchangeUrlMapper().map(dto)
        XCTAssertEqual(result.website, ["https://kraken.com"])
        XCTAssertEqual(result.twitter, ["https://twitter.com/kraken"])
        XCTAssertEqual(result.facebook, ["https://facebook.com/kraken"])
    }

    func testExchangeUrlMapper_nilArrays_becomeEmpty() {
        let dto = ExchangeUrlsDTO(
            website: nil, twitter: nil, facebook: nil,
            blog: nil, chat: nil, fee: nil
        )
        let result = ExchangeUrlMapper().map(dto)
        XCTAssertEqual(result.website, [])
        XCTAssertEqual(result.twitter, [])
        XCTAssertEqual(result.facebook, [])
    }

    // MARK: - ExchangeInfoMapper

    func testExchangeInfoMapper_mapsAllFields() {
        let dto = makeExchangeInfoDTO(
            id: 24, name: "Kraken", slug: "kraken",
            logo: "https://logo.com/kraken.png",
            description: "A crypto exchange",
            dateLaunched: "2011-07-01",
            makerFee: 0.02, takerFee: 0.05
        )
        let result = ExchangeInfoMapper().map(dto)
        XCTAssertEqual(result.id, 24)
        XCTAssertEqual(result.name, "Kraken")
        XCTAssertEqual(result.slug, "kraken")
        XCTAssertEqual(result.logo, "https://logo.com/kraken.png")
        XCTAssertEqual(result.description, "A crypto exchange")
        XCTAssertEqual(result.dateLaunched, "2011-07-01")
        XCTAssertEqual(result.makerFee, 0.02)
        XCTAssertEqual(result.takerFee, 0.05)
    }

    func testExchangeInfoMapper_nilName_defaultsToEmptyString() {
        let dto = makeExchangeInfoDTO(id: 1, name: nil, slug: nil)
        let result = ExchangeInfoMapper().map(dto)
        XCTAssertEqual(result.name, "")
        XCTAssertEqual(result.slug, "")
    }

    func testExchangeInfoMapper_nilUrls_defaultsToEmptyArrays() {
        let dto = makeExchangeInfoDTO(id: 1, urls: nil)
        let result = ExchangeInfoMapper().map(dto)
        XCTAssertEqual(result.urls.website, [])
        XCTAssertEqual(result.urls.twitter, [])
        XCTAssertEqual(result.urls.facebook, [])
    }

    func testExchangeInfoMapper_urlsAreMappedCorrectly() {
        let urls = ExchangeUrlsDTO(
            website: ["https://kraken.com"], twitter: ["https://twitter.com/kraken"],
            facebook: nil, blog: nil, chat: nil, fee: nil
        )
        let dto = makeExchangeInfoDTO(id: 1, urls: urls)
        let result = ExchangeInfoMapper().map(dto)
        XCTAssertEqual(result.urls.website, ["https://kraken.com"])
        XCTAssertEqual(result.urls.twitter, ["https://twitter.com/kraken"])
    }

    // MARK: - ExchangeAssetsMapper

    func testExchangeAssetsMapper_mapsCurrencyFields() {
        let dto = ExchangeAssetResponseDTO(
            data: [
                ExchangeAssetDTO(
                    walletAddress: nil, balance: nil, platform: nil,
                    currency: CurrencyDTO(cryptoId: 1, priceUsd: 50000.0, symbol: "BTC", name: "Bitcoin")
                )
            ],
            status: .empty
        )
        let result = ExchangeAssetsMapper().map(dto)
        XCTAssertEqual(result.items.count, 1)
        XCTAssertEqual(result.items[0].currencyName, "Bitcoin")
        XCTAssertEqual(result.items[0].currencySymbol, "BTC")
        XCTAssertEqual(result.items[0].priceUsd, 50000.0)
    }

    func testExchangeAssetsMapper_nilData_returnsEmptyItems() {
        let dto = ExchangeAssetResponseDTO(data: nil, status: .empty)
        let result = ExchangeAssetsMapper().map(dto)
        XCTAssertTrue(result.items.isEmpty)
    }

    func testExchangeAssetsMapper_nilCurrencyFields_defaultToEmptyOrZero() {
        let dto = ExchangeAssetResponseDTO(
            data: [
                ExchangeAssetDTO(
                    walletAddress: nil, balance: nil, platform: nil,
                    currency: CurrencyDTO(cryptoId: nil, priceUsd: nil, symbol: nil, name: nil)
                )
            ],
            status: .empty
        )
        let result = ExchangeAssetsMapper().map(dto)
        XCTAssertEqual(result.items[0].currencyName, "")
        XCTAssertEqual(result.items[0].currencySymbol, "")
        XCTAssertEqual(result.items[0].priceUsd, 0.0)
    }

    func testExchangeAssetsMapper_nilCurrency_defaultToEmptyOrZero() {
        let dto = ExchangeAssetResponseDTO(
            data: [ExchangeAssetDTO(walletAddress: nil, balance: nil, platform: nil, currency: nil)],
            status: .empty
        )
        let result = ExchangeAssetsMapper().map(dto)
        XCTAssertEqual(result.items.count, 1)
        XCTAssertEqual(result.items[0].currencyName, "")
        XCTAssertEqual(result.items[0].priceUsd, 0.0)
    }

    // MARK: - Helpers

    private func makeExchangeDTO(
        id: Int = 1,
        name: String = "Test",
        isActive: Int? = 1
    ) -> ExchangeDTO {
        ExchangeDTO(
            id: id, name: name, slug: nil,
            firstHistoricalData: nil, lastHistoricalData: nil,
            isActive: isActive, isListed: nil, isRedistributable: nil
        )
    }

    private func makeExchangeInfoDTO(
        id: Int = 1,
        name: String? = "Test",
        slug: String? = "test",
        logo: String? = nil,
        description: String? = nil,
        dateLaunched: String? = nil,
        makerFee: Double? = nil,
        takerFee: Double? = nil,
        urls: ExchangeUrlsDTO? = nil
    ) -> ExchangeInfoDTO {
        ExchangeInfoDTO(
            id: id, name: name, slug: slug, logo: logo,
            description: description, dateLaunched: dateLaunched,
            notice: nil, countries: nil, fiats: nil, type: nil,
            makerFee: makerFee, takerFee: takerFee,
            weeklyVisits: nil, spotVolumeUsd: nil,
            spotVolumeLastUpdated: nil, urls: urls
        )
    }
}
