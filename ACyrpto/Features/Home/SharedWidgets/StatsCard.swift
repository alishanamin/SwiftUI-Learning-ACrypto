//
//  StatsCard.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 18/09/2025.
//

import SwiftUI

struct StatsCard: View {
    
    var stats : StatsModel

    var body: some View {
        VStack (alignment: .leading,spacing: 4){
            Text(stats.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.gray)
            Text(stats.volume)
                .font(.headline )
                .fontWeight(.bold)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(
                        degrees: (stats.percentage ?? 0) >= 0 ? 0 : 180
                    ))
                Text(stats.percentage?.asPercentString ?? "")
                    .font(.callout)
                    .fontWeight(.bold)
            }
            .foregroundColor((stats.percentage ?? 0) >= 0 ? .green : .red)
            .opacity(stats.percentage == nil ? 0 : 1)
            .frame(height: 18) 

        }
    }
}

#Preview {
    StatsCard(
        stats: StatsModel(
            title: "Market Value",
            volume: "$12.6BN",
            percentage: 34
        ),

    )
}
