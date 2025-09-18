//
//  HomeStatsView.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 18/09/2025.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var homeVM: HomeViewModel
    @Binding var  showPortFolio: Bool
    
    var body: some View {
        HStack{
            ForEach(homeVM.statsList) { stats in
                StatsCard(stats: stats)
                    .frame(width: UIScreen.main.bounds.width / 3.2)
            }
        }
    
        .frame(width: UIScreen.main.bounds.width,
               alignment: !showPortFolio ? .leading : .trailing
        )
    }
}

#Preview {
    HomeStatsView(showPortFolio: .constant(false))
        .environmentObject(HomeViewModel())
}

