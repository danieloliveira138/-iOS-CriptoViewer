//
//  ExchangeInfoDTO.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import Foundation

struct ExchangeInfoDTO: Codable {
    let id: Int
    let name: String?
    let slug: String?
    let logo: String?
    let description: String?
    let dateLaunched: String?
    let notice: String?
    let countries: [String]?
    let fiats: [String]?
    let type: String?
    let makerFee: Double?
    let takerFee: Double?
    let weeklyVisits: Int?
    let spotVolumeUsd: Double?
    let spotVolumeLastUpdated: String?
    let urls: ExchangeUrlsDTO?
}
