//
//  AppCoordinator.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/24/26.
//

import SwiftUI
internal import Combine

// All navigable destinations in the app.
// Add a new case here whenever a new screen is reachable via the coordinator.
enum AppRoute: Hashable {
    case exchangeDetail(Int)
}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    func showExchangeDetail(id: Int) {
        path.append(AppRoute.exchangeDetail(id))
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
