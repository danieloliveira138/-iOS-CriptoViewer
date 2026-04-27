//
//  ExchangeAssetsMapper.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/24/26.
//

struct ExchangeAssetsMapper: Mapper {
    typealias Input  = ExchangeAssetResponseDTO
    typealias Output = ExchangeAssets

    func map(_ input: ExchangeAssetResponseDTO) -> ExchangeAssets {
        let items = (input.data ?? []).map { dto in
            ExchangeAsset(
                currencyName:   dto.currency?.name     ?? "",
                currencySymbol: dto.currency?.symbol   ?? "",
                priceUsd:       dto.currency?.priceUsd ?? 0.0
            )
        }
        return ExchangeAssets(items: items)
    }
}
