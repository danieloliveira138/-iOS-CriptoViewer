//
//  ExchangeDetailViewModelTests.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import XCTest
@testable import CryptoViewer

@MainActor
final class ExchangeDetailViewModelTests: XCTestCase {

    private var mockUseCase: MockExchangeUseCase!
    private var viewModel: ExchangeDetailViewModel!

    override func setUp() {
        super.setUp()
        mockUseCase = MockExchangeUseCase()
        viewModel = ExchangeDetailViewModel(useCase: mockUseCase)
    }

    override func tearDown() {
        mockUseCase = nil
        viewModel = nil
        super.tearDown()
    }

    // MARK: - load

    func testLoad_success_setsExchangeInfo() async {
        mockUseCase.getDetailResult = .success(data: .mock(id: 24, name: "Kraken"))

        await viewModel.load(id: 24)

        XCTAssertNotNil(viewModel.exchangeInfo)
        XCTAssertEqual(viewModel.exchangeInfo?.id, 24)
        XCTAssertEqual(viewModel.exchangeInfo?.name, "Kraken")
    }

    func testLoad_success_passesCorrectIdToUseCase() async {
        await viewModel.load(id: 42)
        XCTAssertEqual(mockUseCase.getDetailReceivedIds.first, 42)
    }

    func testLoad_error_setsErrorAndKeepsExchangeInfoNil() async {
        mockUseCase.getDetailResult = .error(error: APIError.emptyResponse)

        await viewModel.load(id: 1)

        XCTAssertNotNil(viewModel.error)
        XCTAssertNil(viewModel.exchangeInfo)
    }

    func testLoad_success_clearsAnyPreviousError() async {
        mockUseCase.getDetailResult = .error(error: APIError.invalidResponse)
        await viewModel.load(id: 1)
        XCTAssertNotNil(viewModel.error)

        mockUseCase.getDetailResult = .success(data: .mock())
        await viewModel.load(id: 1)

        XCTAssertNil(viewModel.error)
    }

    func testLoad_success_setsTradeCoins() async {
        let coins = [CoinItem(name: "Bitcoin (BTC)", price: 50000.0)]
        mockUseCase.getDetailResult = .success(data: .mock(tradeCoins: coins))

        await viewModel.load(id: 1)

        XCTAssertEqual(viewModel.exchangeInfo?.tradeCoins?.count, 1)
        XCTAssertEqual(viewModel.exchangeInfo?.tradeCoins?.first?.name, "Bitcoin (BTC)")
    }

    // MARK: - didTapBack

    func testDidTapBack_firesOnNavigateBackClosure() {
        var backCalled = false
        viewModel.onNavigateBack = { backCalled = true }

        viewModel.didTapBack()

        XCTAssertTrue(backCalled)
    }

    func testDidTapBack_withoutClosureSet_doesNotCrash() {
        viewModel.onNavigateBack = nil
        viewModel.didTapBack()
    }
}
