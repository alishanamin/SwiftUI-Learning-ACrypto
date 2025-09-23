//
//  MarketStatsModel.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 23/09/2025.
//

import Foundation


struct GlobalData: Codable {
    let data: MarketStats
}



// MARK: - MarketStats
struct MarketStats: Codable, Sendable {
   
    let markets: Int
    let totalMarketCap: [String: Double]
    let totalVolume: [String: Double]
    let marketCapPercentage: [String: Double]
    let marketCapChangePercentage24hUsd: Double
    let updatedAt: Int

    enum CodingKeys: String, CodingKey {
        case markets
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24hUsd = "market_cap_change_percentage_24h_usd"
        case updatedAt = "updated_at"
    }
    
    
    private func marketCap(for key: String = "usd") -> String {
        guard let value = totalMarketCap.first(where: { $0.key.lowercased() == key.lowercased() })?.value else {
            return "N/A"
        }
        return "\(value.formattedWithAbbreviations(symbol: "$"))"
    }
    
    private func marketVolume(for key: String = "usd") -> String {
        
        guard let value = totalVolume.first(where: {$0.key.lowercased() == key.lowercased()})?.value else {
            return "N/A"
        }
        return "\(value.formattedWithAbbreviations(symbol: "$"))"
    }
    
    private func btcDominance(for key: String = "usd") -> String {
        
        guard let value = marketCapPercentage.first(where: {$0.key.lowercased() == key.lowercased()})?.value else {
            return "N/A"
        }
        return "\(value.asPercentString)"
    }
    
    var marketCap: String {
        marketCap(for: "usd")
    }
    var marketVolume: String{
        marketCap(for: "usd")
    }
    
    var btcDominance: String{
        btcDominance(for: "btc")
    }
    
}
