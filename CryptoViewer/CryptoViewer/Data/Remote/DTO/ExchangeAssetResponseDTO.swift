//
//  ExchangeAssetResponseDTO.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import Foundation

struct ExchangeAssetResponseDTO: Codable {
    let data: [ExchangeAssetDTO]?
    let status: ExchangeStatusDTO
}
