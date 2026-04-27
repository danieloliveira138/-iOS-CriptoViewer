//
//  CryptoViewerApp.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/25/26.
//

import SwiftUI

@main
struct CryptoViewerApp: App {
    @StateObject private var coordinator = AppCoordinator()

    private let useCase: ExchangeUseCase = {
        #if DEBUG
        if let raw = ProcessInfo.processInfo.environment["UITEST_SCENARIO"],
           let scenario = UITestScenario(rawValue: raw) {
            return UITestMockUseCase(scenario: scenario)
        }
        #endif
        return ExchangeUseCaseImpl()
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                ExchangeListView(useCase: useCase)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .exchangeDetail(let id):
                            ExchangeDetailsView(exchangeId: id, useCase: useCase)
                        }
                    }
            }
            .environmentObject(coordinator)
        }
    }
}

// MARK: - UI Test Support

#if DEBUG
enum UITestScenario: String {
    case listSuccess = "list-success"
    case listError = "list-error"
    case listEmpty = "list-empty"
    case detailSuccess = "detail-success"
    case detailError = "detail-error"
}

private final class UITestMockUseCase: ExchangeUseCase {
    private let scenario: UITestScenario

    init(scenario: UITestScenario) {
        self.scenario = scenario
    }

    func getExchangesList(start: Int, limit: Int) async -> Result<[ExchangeItem]> {
        switch scenario {
        case .listError:
            return .error(error: APIError.httpError(statusCode: 500))
        case .listEmpty:
            return .success(data: [])
        default:
            return .success(data: [
                ExchangeItem(id: 1, name: "Binance", isActive: true),
                ExchangeItem(id: 2, name: "Coinbase", isActive: false)
            ])
        }
    }

    func getExchangeDetail(id: Int) async -> Result<ExchangeInfo> {
        if scenario == .detailError {
            return .error(error: APIError.httpError(statusCode: 500))
        }
        return .success(data: ExchangeInfo(
            id: 1,
            name: "Binance",
            slug: "binance",
            logo: nil,
            description: "A leading crypto exchange.",
            dateLaunched: "2017-07-14T00:00:00.000Z",
            makerFee: 0.1,
            takerFee: 0.1,
            urls: ExchangeUrl(website: ["https://binance.com"], twitter: [], facebook: [])
        ))
    }
}
#endif
