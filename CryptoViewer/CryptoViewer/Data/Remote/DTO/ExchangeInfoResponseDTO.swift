//
//  ExchangeInfoResponseDTO.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/25/26.
//

import Foundation

struct ExchangeInfoResponseDTO: Codable {
    let data: [String: ExchangeInfoDTO]?
    let status: ExchangeStatusDTO
}
