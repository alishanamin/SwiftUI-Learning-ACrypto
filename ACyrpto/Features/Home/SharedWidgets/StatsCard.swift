//
//  StatsCard.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 18/09/2025.
//

import SwiftUI

struct StatsCard: View {
    
    var stats : StatisticModel

    var body: some View {
        VStack (alignment: .leading,spacing: 4){
            Text(stats.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.gray)
            Text(stats.value)
                .font(.headline )
                .fontWeight(.bold)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(
                        degrees: (stats.percentageChange ?? 0) >= 0 ? 0 : 180
                    ))
                Text(stats.percentageChange?.asPercentString ?? "")
                    .font(.callout)
                    .fontWeight(.bold)
            }
            .foregroundColor((stats.percentageChange ?? 0) >= 0 ? .green : .red)
            .opacity(stats.percentageChange == nil ? 0 : 1)
            .frame(height: 18) 

        }
    }
}

#Preview {
    StatsCard(
        stats: StatisticModel(
            title: "Market Value",
            value: "$12.6BN",
            percentageChange: 34
        ),

    )
}
