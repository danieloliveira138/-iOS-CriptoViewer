//
//  ExchangeDTO.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import Foundation

struct ExchangeDTO: Codable {
    let id: Int
    let name: String
    let slug: String?
    let firstHistoricalData: String?
    let lastHistoricalData: String?
    let isActive: Int?
    let isListed: Int?
    let isRedistributable: Int?
}
