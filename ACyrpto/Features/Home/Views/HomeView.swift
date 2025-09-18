//
//  HomeView.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 25/08/2025.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject private var homeVM: HomeViewModel

    @State var showPortFolio: Bool = false

    var body: some View {
        ZStack {

            // Background
            Color.theme.backgroundColor.ignoresSafeArea()

            // ===== Main Content =====
            VStack {
                AppBarHeader
                Spacer(minLength: 10)
                HomeStatsView(showPortFolio: $showPortFolio)
                Spacer(minLength: 10)
                ModernSearchField(
                    text: $homeVM.searchText,
                    placeholder: "Search by Name and Symbol......"
                )
                Spacer(minLength: 10)
                nameHeader
                if showPortFolio {
                    PortFolioCoinListView
                        .transition(.move(edge: .trailing))

                } else {
                    AllCoinListView
                        .transition(.move(edge: .leading))
                        
                }
            }

            // ===== Error Overlay =====
            if let error = homeVM.errorMessage {
                VStack(spacing: 12) {
                    Text("⚠️ \(error)")
                        .multilineTextAlignment(.center)
                        .padding()

                    Button {
                        homeVM.retry()
                    } label: {
                        Text("Retry")
                    }

                }

            }

            // ===== Loader Overlay =====
            if homeVM.isLoading {

                ProgressView()

            }
        }.padding()

    }

    private var nameHeader: some View {
        HStack {
            Text("Coin")
            Spacer()

            if showPortFolio {
                Text("Holdings")

            }

            Text("Price")
                .frame(
                    width: UIScreen.main.bounds.width / 3,
                    alignment: .trailing
                )

        }
        .padding(.horizontal)
        .font(.body)
        .foregroundColor(.blue)
    }

    private var AppBarHeader: some View {
        HStack {
            portfolioButton
            Spacer()
            Text(showPortFolio ? "Portfolio" : "Live Prices")
                .font(.title2.bold())
            Spacer()

            chevronButton
        }
        .padding(.horizontal)
    }

    private var AllCoinListView: some View {
        List {
            ForEach(homeVM.allCointsList) { coin in
                CoinRowView(coin: coin, showHoldings: false)
                    .listRowInsets(
                        .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                    )
            }
        }
        .refreshable {
            homeVM.refresh()
        }
        .listStyle(.plain)

    }

    private var PortFolioCoinListView: some View {
        List {
            ForEach(homeVM.portFolioCointsList) { coin in
                CoinRowView(coin: coin, showHoldings: true)
                    .listRowInsets(
                        .init(top: 10, leading: 5, bottom: 10, trailing: 0)
                    )
            }
        }
        .listStyle(.plain)
    }

    private var portfolioButton: some View {
        CircleIcon(iconName: showPortFolio ? "plus" : "info")
            .background(
                CircleAnimationView(isAnimation: $showPortFolio)
                    .foregroundColor(.red)
                    .frame(width: 60, height: 60)
            )

    }

    private var chevronButton: some View {
        CircleIcon(iconName: "chevron.right")
            .rotationEffect(.degrees(showPortFolio ? 180 : 0))
            .animation(.easeOut(duration: 0.3), value: showPortFolio)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    showPortFolio.toggle()
                }
            }
    }

}

#Preview {
    NavigationView {
        HomeView()
    }.environmentObject(HomeViewModel())
}
