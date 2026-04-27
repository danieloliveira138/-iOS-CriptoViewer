//
//  CoinItem.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

struct CoinItem: Identifiable, Hashable {
    let name: String
    let price: Double
    var id: String { name }
}
