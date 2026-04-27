//
//  CurrencyDTO.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/24/26.
//

import Foundation

struct CurrencyDTO: Codable {
    let cryptoId: Int?
    let priceUsd: Double?
    let symbol: String?
    let name: String?
}
