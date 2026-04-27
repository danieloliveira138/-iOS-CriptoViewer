//
//  CoinItem.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import Foundation

protocol ExchangeRepository {
    func getExchangesList(start: Int, limit: Int) async throws -> [ExchangeItem]
    func getExchangeInfo(exchangeId: Int) async throws -> ExchangeInfo
    func getExchangeAssets(exchangeId: Int) async throws -> ExchangeAssets
}
