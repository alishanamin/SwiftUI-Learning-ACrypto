//
//  CoinDetailView.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 30/09/2025.
//

import SwiftUI

struct CoinDetailView: View {

    @StateObject private var vm: CoinDetailViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
       
    ]
    private let spacing: CGFloat = 30
    
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }

   
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading){
                
                Text("")
                    .frame(height: 150)
                headerTitleText(title: "OverView")
                Divider()
                if vm.isLoading {
                    ProgressView()
                } else if let error = vm.errorMessage {
                    errorView(message: error)
                } else {
                    overViewGrid
                }
                Spacer(minLength: 20)
                headerTitleText(title: "Addiontal Details")
                Divider()
                if vm.isLoading {
                    ProgressView()
                } else if let error = vm.errorMessage {
                    errorView(message: error)
                } else {
                    addiontalViewGried
                }
                
            
            }
            .padding()
        }
        .navigationTitle(vm.coin.name.uppercased())
        .navigationBarTitleDisplayMode(.large)
            
            
    }
}

extension CoinDetailView {
    
    private func headerTitleText(title: String) -> some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var overViewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing) {
            ForEach(vm.overViewStats) { stats in
                StatsCard(
                    stats: stats
                )
            }
        }
    }
    
    private var addiontalViewGried: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing) {
            ForEach(vm.additionalOverViewStats) { stats in
                StatsCard(
                    stats: stats
                )
            }
        }
    }
    private func errorView(message: String) -> some View {
         VStack(spacing: 12) {
             Image(systemName: "exclamationmark.triangle.fill")
                 .foregroundColor(.orange)
                 .font(.largeTitle)
             Text("Something went wrong")
                 .font(.headline)
             Text(message)
                 .font(.subheadline)
                 .foregroundColor(.secondary)
                 .multilineTextAlignment(.center)
             
             .buttonStyle(.borderedProminent)
         }
         .frame(maxWidth: .infinity, minHeight: 150)
         .padding()
     }
}

#Preview {
    NavigationView {
        CoinDetailView(
            coin: CoinModel.mock
        )
    }
}



