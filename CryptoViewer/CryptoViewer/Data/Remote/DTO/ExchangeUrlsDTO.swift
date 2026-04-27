//
//  ExchangeUrlsDTO.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import Foundation

struct ExchangeUrlsDTO: Codable {
    let website: [String]?
    let twitter: [String]?
    let facebook: [String]?
    let blog: [String]?
    let chat: [String]?
    let fee: [String]?
}

extension ExchangeUrlsDTO {
    static let empty = ExchangeUrlsDTO(
        website: nil, twitter: nil, facebook: nil,
        blog: nil, chat: nil, fee: nil
    )
}
