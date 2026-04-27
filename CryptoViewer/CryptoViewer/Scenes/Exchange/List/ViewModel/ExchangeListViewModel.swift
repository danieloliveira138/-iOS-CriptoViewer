//
//  ExchangeListViewModel.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/24/26.
//

import SwiftUI
internal import Combine

@MainActor
final class ExchangeListViewModel: ObservableObject {
    private static let pageSize = 20
    @Published var exchanges: [ExchangeItem] = []
    @Published var isLoading: Bool = false
    @Published var isFetchingData: Bool = false
    @Published var error: Error? = nil
    private var hasReachEndList: Bool = false
    
    let useCase: ExchangeUseCase

    init(useCase: ExchangeUseCase) {
        self.useCase = useCase
    }
    
    func fetchExchangesList() async {
        guard exchanges.isEmpty else { return }
        self.isLoading = true
        self.isFetchingData = true
        let start = 1
        let limit = Self.pageSize
        let result = await useCase.getExchangesList(start: start, limit: limit)
        switch(result) {
        case .error(let error):
            self.error = error
        case .success(let data):
            self.exchanges = data
        }
        self.isLoading = false
        self.isFetchingData = false
    }
    
    func refresh() async {
        exchanges = []
        hasReachEndList = false
        isFetchingData = false
        await fetchExchangesList()
    }

    func loadMoreIfNeeded(exchangeId: Int) async {
        guard !hasReachEndList && !isFetchingData else { return }
        
        if exchangeId == self.exchanges.last?.id {
            self.isFetchingData = true
            
            let start = exchanges.count + 1
            let limit = Self.pageSize
            let response = await useCase.getExchangesList(start: start, limit: limit)
        
            switch(response) {
            case .success(let data):
                if data.isEmpty {
                    hasReachEndList = true
                } else {
                    self.exchanges.append(contentsOf: data)
                }
            case .error(let error):
                self.error = error
            }
            self.isFetchingData = false
        }
    }
    
    var onNavigateToDetail: ((Int) -> Void)?

    func didSelectExchangeItem(exchange: ExchangeItem) {
        onNavigateToDetail?(exchange.id)
    }
}
