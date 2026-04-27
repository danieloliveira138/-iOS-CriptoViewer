//
//  ExchangeItemMapper.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/25/26.
//

struct ExchangeItemMapper: Mapper {
    typealias Input  = ExchangeDTO
    typealias Output = ExchangeItem

    func map(_ input: ExchangeDTO) -> ExchangeItem {
        ExchangeItem(
            id:       input.id,
            name:     input.name,
            isActive: (input.isActive ?? 0) != 0
        )
    }
}
