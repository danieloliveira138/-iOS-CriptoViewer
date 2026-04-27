//
//  ExchangeUseCaseProtocol.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/27/26.
//

protocol ExchangeUseCase {
    func getExchangesList(start: Int, limit: Int) async -> Result<[ExchangeItem]>
    func getExchangeDetail(id: Int) async -> Result<ExchangeInfo>
}
