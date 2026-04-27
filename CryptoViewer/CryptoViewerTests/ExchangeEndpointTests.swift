//
//  ExchangeEndpointTests.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/24/26.
//

import XCTest
@testable import CryptoViewer

final class ExchangeEndpointTests: XCTestCase {

    // MARK: - HTTP Method

    func testAllEndpoints_useGETMethod() throws {
        let endpoints: [ExchangeEndpoint] = [
            .exchangeList(start: 1, limit: 20),
            .exchangeInfo(id: 1),
            .exchangeAssets(id: 1)
        ]
        for endpoint in endpoints {
            let request = try endpoint.makeURLRequest()
            XCTAssertEqual(request.httpMethod, "GET", "Expected GET for \(endpoint)")
        }
    }

    // MARK: - Headers

    func testAllEndpoints_includeAPIKeyHeader() throws {
        let endpoints: [ExchangeEndpoint] = [
            .exchangeList(start: 1, limit: 20),
            .exchangeInfo(id: 1),
            .exchangeAssets(id: 1)
        ]
        for endpoint in endpoints {
            let request = try endpoint.makeURLRequest()
            XCTAssertNotNil(
                request.value(forHTTPHeaderField: "X-CMC_PRO_API_KEY"),
                "Missing API key header for \(endpoint)"
            )
        }
    }

    func testAllEndpoints_includeJSONAcceptHeader() throws {
        let endpoints: [ExchangeEndpoint] = [
            .exchangeList(start: 1, limit: 20),
            .exchangeInfo(id: 1),
            .exchangeAssets(id: 1)
        ]
        for endpoint in endpoints {
            let request = try endpoint.makeURLRequest()
            XCTAssertEqual(
                request.value(forHTTPHeaderField: "Accept"),
                "application/json",
                "Missing Accept header for \(endpoint)"
            )
        }
    }

    // MARK: - Paths

    func testExchangeList_usesCorrectPath() throws {
        let request = try ExchangeEndpoint.exchangeList(start: 1, limit: 20).makeURLRequest()
        XCTAssertTrue(request.url?.absoluteString.contains("v1/exchange/map") == true)
    }

    func testExchangeInfo_usesCorrectPath() throws {
        let request = try ExchangeEndpoint.exchangeInfo(id: 1).makeURLRequest()
        XCTAssertTrue(request.url?.absoluteString.contains("v1/exchange/info") == true)
    }

    func testExchangeAssets_usesCorrectPath() throws {
        let request = try ExchangeEndpoint.exchangeAssets(id: 1).makeURLRequest()
        XCTAssertTrue(request.url?.absoluteString.contains("v1/exchange/assets") == true)
    }

    // MARK: - Query Parameters

    func testExchangeList_includesStartQueryParam() throws {
        let request = try ExchangeEndpoint.exchangeList(start: 5, limit: 20).makeURLRequest()
        let items = queryItems(from: request)
        XCTAssertTrue(items.contains(URLQueryItem(name: "start", value: "5")))
    }

    func testExchangeList_includesLimitQueryParam() throws {
        let request = try ExchangeEndpoint.exchangeList(start: 1, limit: 20).makeURLRequest()
        let items = queryItems(from: request)
        XCTAssertTrue(items.contains(URLQueryItem(name: "limit", value: "20")))
    }

    func testExchangeInfo_includesIdQueryParam() throws {
        let request = try ExchangeEndpoint.exchangeInfo(id: 42).makeURLRequest()
        let items = queryItems(from: request)
        XCTAssertTrue(items.contains(URLQueryItem(name: "id", value: "42")))
    }

    func testExchangeAssets_includesIdQueryParam() throws {
        let request = try ExchangeEndpoint.exchangeAssets(id: 99).makeURLRequest()
        let items = queryItems(from: request)
        XCTAssertTrue(items.contains(URLQueryItem(name: "id", value: "99")))
    }

    // MARK: - Helpers

    private func queryItems(from request: URLRequest) -> [URLQueryItem] {
        guard let url = request.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return []
        }
        return components.queryItems ?? []
    }
}
