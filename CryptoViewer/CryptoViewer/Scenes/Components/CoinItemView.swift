//
//  CoinItemView.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/25/26.
//

import SwiftUI

struct CoinItemView: View {
    let name: String
    let price: Double

    var body: some View {
        HStack {
            Text(name)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.mbTextPrimary)

            Spacer()

            Text(String(format: "$%.2f", price))
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.mbGreenAccent)
        }
        .padding(16)
        .background(Color.mbCardBg)
        .cornerRadius(12)
    }
}

#Preview {
    VStack(spacing: 8, content: {
        CoinItemView(name: "Bitcoin", price: 51.51)
        CoinItemView(name: "Cardano", price: 24.24)
        CoinItemView(name: "Ethereum", price: 11.11)
    }).padding(8)
}
