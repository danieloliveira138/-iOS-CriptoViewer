//
//  ExchangeMapResponseDTO.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/24/26.
//

import Foundation

struct ExchangeMapResponseDTO: Codable {
    let data: [ExchangeDTO]?
    let status: ExchangeStatusDTO
}
