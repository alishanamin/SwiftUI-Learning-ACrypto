//
//  CoinRowView.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 28/08/2025.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHoldings : Bool
    
    var body: some View {
        HStack (alignment: .center,spacing: 0){
            Text("\(coin.marketCapRank ?? 2)")
                .frame(minWidth: 30)
                .font(.callout)
                .padding(.trailing,5)
            
            AsyncImage(url: URL(string: coin.image)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 35, height: 35)
            .clipShape(Circle())
            Text("\(coin.symbol.uppercased())")
                .frame(minWidth: 20)
                .font(.callout)
                .padding(.leading,6)
                .fontWeight(.bold)
            Spacer()
            if showHoldings{
                VStack (alignment: .trailing){
                    Text(
                        coin.currentPrice.format(using: .currency(code: "$"))
                    ).fontWeight(.bold)
                    Text(
                        coin.priceChangePercentage24hInCurrency?.asPercentString ?? "N/A"
                    )
                }
            }
            VStack (alignment: .trailing){
                Text(coin.currentPrice.toCurrencyStringFormat(code: "$")).fontWeight(.bold)
                Text(
                    coin.priceChangePercentage24hInCurrency?.asPercentString ?? "N/A"
                        
                ).foregroundStyle(.red)

                
            }.frame(minWidth: UIScreen.main.bounds.width/3)
        }
    }
}

#Preview("Light Mode") {
    CoinRowView(coin: CoinModel.mock, showHoldings: false)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    CoinRowView(coin: CoinModel.mock, showHoldings: true)
        .preferredColorScheme(.dark)
}

// MARK: - Mock Coin for Preview
extension CoinModel {
    static let mock = CoinModel(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
        currentPrice: 1,
        marketCap: 1200000000000,
        marketCapRank: 1,
        fullyDilutedValuation: 1300000000000,
        totalVolume: 35000000000,
        high24h: 65000,
        low24h: 63000,
        priceChange24h: -500.23,
        priceChangePercentage24h: -0.78,
        marketCapChange24h: -10000000000,
        marketCapChangePercentage24h: -0.82,
        circulatingSupply: 19000000,
        totalSupply: 21000000,
        maxSupply: 21000000,
        ath: 69000,
        athChangePercentage: -7.89,
        athDate: "2013-07-06T00:00:00.000Z",
        // Example ATH date
        atl: 67.81,
        atlChangePercentage: 94765.12,
        atlDate: "2013-07-06T00:00:00.000Z",
        // Example ATL date
        roi: nil,
        lastUpdated: "2013-07-06T00:00:00.000Z",
        sparklineIn7D: nil,
        priceChangePercentage24hInCurrency: -0.78,
        currentHoldings: 0
    )
}
