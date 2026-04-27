//
//  CoinItem.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import Foundation

struct ExchangeAssets {
    let items: [ExchangeAsset]
}

struct ExchangeAsset {
    let currencyName: String
    let currencySymbol: String
    let priceUsd: Double
}
