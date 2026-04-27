//
//  ExchangeStatusDTO.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/24/26.
//

import Foundation

struct ExchangeStatusDTO: Codable {
    let timestamp: String?
    let errorCode: Int?
    let errorMessage: String?
    let elapsed: Int?
    let creditCount: Int?
    let notice: String?
}
