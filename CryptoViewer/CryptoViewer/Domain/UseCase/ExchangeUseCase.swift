//
//  ExchangeUseCase.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import Foundation

class ExchangeUseCaseImpl: ExchangeUseCase {
    let repository: ExchangeRepository
    
    init(repository: ExchangeRepository = ExchangeRepositoryImpl()) {
        self.repository = repository
    }
    
    func getExchangesList(start: Int, limit: Int) async -> Result<[ExchangeItem]> {
        var response: [ExchangeItem]
        do {
            response = try await self.repository.getExchangesList(start: start, limit: limit)
        } catch {
            return Result.error(error: error)
        }
        return Result.success(data: response)
    }
    
    func getExchangeDetail(id: Int) async -> Result<ExchangeInfo> {
        async let infoRequest = repository.getExchangeInfo(exchangeId: id)
        async let assetsRequest = repository.getExchangeAssets(exchangeId: id)

        var response: ExchangeInfo
        do {
            response = try await infoRequest
        } catch {
            return Result.error(error: error)
        }
        do {
            let assets = try await assetsRequest
            var seen = Set<CoinItem>()
            response.tradeCoins = assets.items
                .map { CoinItem(name: $0.currencyName + " (" + $0.currencySymbol + ")", price: $0.priceUsd) }
                .filter { seen.insert($0).inserted }
        } catch {
            print(error.localizedDescription)
        }
        return Result.success(data: response)
    }
}
