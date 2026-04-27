//
//  ExchangeInfoMapper.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/24/26.
//

struct ExchangeInfoMapper: Mapper {
    typealias Input  = ExchangeInfoDTO
    typealias Output = ExchangeInfo

    private let urlMapper = ExchangeUrlMapper()

    func map(_ input: ExchangeInfoDTO) -> ExchangeInfo {
        ExchangeInfo(
            id:           input.id,
            name:         input.name         ?? "",
            slug:         input.slug         ?? "",
            logo:         input.logo,
            description:  input.description,
            dateLaunched: input.dateLaunched,
            makerFee:     input.makerFee,
            takerFee:     input.takerFee,
            urls:         urlMapper.map(input.urls ?? .empty)
        )
    }
}
