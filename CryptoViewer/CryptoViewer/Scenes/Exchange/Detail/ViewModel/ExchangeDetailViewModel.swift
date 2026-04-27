//
//  ExchangeDetailViewModel.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import Foundation
internal import Combine

@MainActor
final class ExchangeDetailViewModel: ObservableObject {
    @Published var exchangeInfo: ExchangeInfo? = nil
    @Published var error: Error? = nil
    
    let useCase: ExchangeUseCase
    
    init(useCase: ExchangeUseCase) {
        self.useCase = useCase
    }
    
    func load(id: Int) async {
        let response: Result<ExchangeInfo> = await useCase.getExchangeDetail(id: id)
        switch response {
        case .error(let error):
            self.error = error
        case .success(let data):
            self.exchangeInfo = data
            self.error = nil
        }
    }

    var onNavigateBack: (() -> Void)?

    func didTapBack() {
        onNavigateBack?()
    }
}
