//
//  TransactionCoinsList.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/25/26.
//

import SwiftUI

struct TradeCoinsList: View {
    var coinsList: [CoinItem]?
    
    init(coinsList: [CoinItem]?) {
        self.coinsList = coinsList
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let coins = coinsList, !coins.isEmpty {
                Text("Trade Coins")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.mbOrange)
                VStack(spacing: 12) {
                    ForEach(coins) { coin in
                        CoinItemView(name: coin.name, price: coin.price)
                    }
                }.padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        let coins = [CoinItem(name: "Bitcoin", price: 222323.2423232)]
        TradeCoinsList(coinsList: coins)
    }
    
}
