//
//  ExchangeUrlMapper.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/24/26.
//

struct ExchangeUrlMapper: Mapper {
    typealias Input  = ExchangeUrlsDTO
    typealias Output = ExchangeUrl

    func map(_ input: ExchangeUrlsDTO) -> ExchangeUrl {
        ExchangeUrl(
            website:  input.website  ?? [],
            twitter:  input.twitter  ?? [],
            facebook: input.facebook ?? []
        )
    }
}
