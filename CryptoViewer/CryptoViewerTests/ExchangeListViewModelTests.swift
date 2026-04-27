//
//  ExchangeListViewModelTests.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/24/26.
//

import XCTest
@testable import CryptoViewer

@MainActor
final class ExchangeListViewModelTests: XCTestCase {

    private var mockUseCase: MockExchangeUseCase!
    private var viewModel: ExchangeListViewModel!

    override func setUp() {
        super.setUp()
        mockUseCase = MockExchangeUseCase()
        viewModel = ExchangeListViewModel(useCase: mockUseCase)
    }

    override func tearDown() {
        mockUseCase = nil
        viewModel = nil
        super.tearDown()
    }

    // MARK: - fetchExchangesList

    func testFetchExchangesList_success_populatesExchanges() async {
        mockUseCase.getListResult = .success(data: [
            ExchangeItem(id: 1, name: "Kraken", isActive: true),
            ExchangeItem(id: 2, name: "Binance", isActive: false)
        ])

        await viewModel.fetchExchangesList()

        XCTAssertEqual(viewModel.exchanges.count, 2)
        XCTAssertEqual(viewModel.exchanges[0].name, "Kraken")
        XCTAssertEqual(viewModel.exchanges[1].name, "Binance")
    }

    func testFetchExchangesList_success_clearsLoadingState() async {
        mockUseCase.getListResult = .success(data: [])

        await viewModel.fetchExchangesList()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isFetchingData)
    }

    func testFetchExchangesList_error_setsError() async {
        mockUseCase.getListResult = .error(error: APIError.invalidResponse)

        await viewModel.fetchExchangesList()

        XCTAssertNotNil(viewModel.error)
        XCTAssertTrue(viewModel.exchanges.isEmpty)
    }

    func testFetchExchangesList_calledWhenExchangesNotEmpty_doesNotFetchAgain() async {
        mockUseCase.getListResult = .success(data: [
            ExchangeItem(id: 1, name: "Kraken", isActive: true)
        ])
        await viewModel.fetchExchangesList()
        let firstCallCount = mockUseCase.getListCallCount

        await viewModel.fetchExchangesList()

        XCTAssertEqual(mockUseCase.getListCallCount, firstCallCount)
    }

    func testFetchExchangesList_requestsFirstPageWithStartOne() async {
        await viewModel.fetchExchangesList()
        XCTAssertEqual(mockUseCase.getListReceivedStart.first, 1)
    }

    // MARK: - loadMoreIfNeeded

    func testLoadMoreIfNeeded_lastExchangeId_appendsNextPage() async {
        let firstPage = [
            ExchangeItem(id: 1, name: "Kraken", isActive: true),
            ExchangeItem(id: 2, name: "Binance", isActive: false)
        ]
        mockUseCase.getListResult = .success(data: firstPage)
        await viewModel.fetchExchangesList()

        let secondPage = [ExchangeItem(id: 3, name: "Coinbase", isActive: true)]
        mockUseCase.getListResult = .success(data: secondPage)
        await viewModel.loadMoreIfNeeded(exchangeId: 2)

        XCTAssertEqual(viewModel.exchanges.count, 3)
        XCTAssertEqual(viewModel.exchanges.last?.name, "Coinbase")
    }

    func testLoadMoreIfNeeded_nonLastExchangeId_doesNotFetch() async {
        mockUseCase.getListResult = .success(data: [
            ExchangeItem(id: 1, name: "Kraken", isActive: true),
            ExchangeItem(id: 2, name: "Binance", isActive: false)
        ])
        await viewModel.fetchExchangesList()
        let callCountAfterFetch = mockUseCase.getListCallCount

        await viewModel.loadMoreIfNeeded(exchangeId: 1)

        XCTAssertEqual(mockUseCase.getListCallCount, callCountAfterFetch)
    }

    func testLoadMoreIfNeeded_emptyResponse_setsHasReachedEndList() async {
        mockUseCase.getListResult = .success(data: [
            ExchangeItem(id: 1, name: "Kraken", isActive: true)
        ])
        await viewModel.fetchExchangesList()

        mockUseCase.getListResult = .success(data: [])
        await viewModel.loadMoreIfNeeded(exchangeId: 1)

        let callCountAfterEndReached = mockUseCase.getListCallCount
        await viewModel.loadMoreIfNeeded(exchangeId: 1)
        XCTAssertEqual(mockUseCase.getListCallCount, callCountAfterEndReached)
    }

    func testLoadMoreIfNeeded_whileFetchingData_doesNotFetchAgain() async {
        mockUseCase.getListResult = .success(data: [
            ExchangeItem(id: 1, name: "Kraken", isActive: true)
        ])
        await viewModel.fetchExchangesList()

        viewModel.isFetchingData = true
        let callCount = mockUseCase.getListCallCount

        await viewModel.loadMoreIfNeeded(exchangeId: 1)

        XCTAssertEqual(mockUseCase.getListCallCount, callCount)
    }

    // MARK: - refresh

    func testRefresh_clearsExchangesAndFetchesFirstPageAgain() async {
        mockUseCase.getListResult = .success(data: [
            ExchangeItem(id: 1, name: "Kraken", isActive: true)
        ])
        await viewModel.fetchExchangesList()
        XCTAssertEqual(viewModel.exchanges.count, 1)

        let freshPage = [
            ExchangeItem(id: 10, name: "Fresh Exchange", isActive: true)
        ]
        mockUseCase.getListResult = .success(data: freshPage)
        await viewModel.refresh()

        XCTAssertEqual(viewModel.exchanges.count, 1)
        XCTAssertEqual(viewModel.exchanges[0].name, "Fresh Exchange")
    }

    func testRefresh_resetsEndOfListState() async {
        mockUseCase.getListResult = .success(data: [
            ExchangeItem(id: 1, name: "Kraken", isActive: true)
        ])
        await viewModel.fetchExchangesList()
        mockUseCase.getListResult = .success(data: [])
        await viewModel.loadMoreIfNeeded(exchangeId: 1)
        let callCountAfterEndReached = mockUseCase.getListCallCount

        mockUseCase.getListResult = .success(data: [])
        await viewModel.refresh()

        XCTAssertGreaterThan(mockUseCase.getListCallCount, callCountAfterEndReached)
    }

    // MARK: - didSelectExchangeItem

    func testDidSelectExchangeItem_firesNavigationClosureWithCorrectId() {
        var receivedId: Int?
        viewModel.onNavigateToDetail = { receivedId = $0 }

        viewModel.didSelectExchangeItem(exchange: ExchangeItem(id: 42, name: "Kraken", isActive: true))

        XCTAssertEqual(receivedId, 42)
    }
}
