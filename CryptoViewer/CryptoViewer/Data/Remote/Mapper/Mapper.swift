//
//  Mapper.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/25/26.
//

protocol Mapper {
    associatedtype Input
    associatedtype Output
    func map(_ input: Input) -> Output
}
