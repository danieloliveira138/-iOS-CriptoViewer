//
//  Result.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

enum Result<Data> {
    case success(data: Data)
    case error(error: Error)
}
