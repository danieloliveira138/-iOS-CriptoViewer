//
//  CoinItem.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import Foundation

struct ExchangeInfo {
    let id: Int
    let name: String
    let slug: String
    let logo: String?
    let description: String?
    let dateLaunched: String?
    let makerFee: Double?
    let takerFee: Double?
    let urls: ExchangeUrl
    var tradeCoins: [CoinItem]? = nil
}
