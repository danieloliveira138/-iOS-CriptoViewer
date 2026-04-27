//
//  ExchangeAssetDTO.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import Foundation

struct ExchangeAssetDTO: Codable {
    let walletAddress: String?
    let balance: Double?
    let platform: PlatformDTO?
    let currency: CurrencyDTO?
}
