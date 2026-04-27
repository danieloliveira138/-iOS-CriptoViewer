//
//  Untitled.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/25/26.
//

import SwiftUI

struct ExchangeRow: View {
    let exchange: ExchangeItem

    var body: some View {
        HStack {
            Text(exchange.name)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(exchange.isActive ? .mbTextPrimary : .mbTextDisabled)

            Spacer()

            Text(exchange.isActive ? "ACTIVE" : "OFFLINE")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(exchange.isActive ? .mbOrange : .mbTextDisabled)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(exchange.isActive
                              ? Color.mbOrange.opacity(0.15)
                              : Color.mbTextDisabled.opacity(0.15))
                )
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(Color.mbCardBg)
        .overlay(alignment: .leading) {
            if exchange.isActive {
                Rectangle()
                    .fill(Color.mbOrange)
                    .frame(width: 4)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .opacity(exchange.isActive ? 1.0 : 0.5)
    }
}

#Preview {
    VStack(spacing: 8) {
        ExchangeRow(exchange: ExchangeItem(id: 1,
                                           name: "Mercado Bitcoin",
                                           isActive: true))
        ExchangeRow(exchange: ExchangeItem(id: 2,
                                           name: "Binance",
                                           isActive: false))
    }
    .padding(8)
    .frame(width: .infinity, height: .infinity, )
    .background(Color.mbBgDark)
}
