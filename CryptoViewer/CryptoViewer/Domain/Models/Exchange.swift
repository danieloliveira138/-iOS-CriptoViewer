//
//  CoinItem.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import Foundation

struct ExchangeItem: Identifiable, Hashable {
    let id: Int
    let name: String
    let isActive: Bool
}
