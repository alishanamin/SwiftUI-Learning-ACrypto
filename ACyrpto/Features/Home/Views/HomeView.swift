import SwiftUI

struct HomeView: View {

    @EnvironmentObject private var homeVM: HomeViewModel
    @State var showPortFolio: Bool = false
    @State var showPortFolioSheet: Bool = false
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path){
            VStack {
                // ===== Static Section (always visible) =====
                AppBarHeader
                    .sheet(isPresented: $showPortFolioSheet) {
                        PortFolioSheetView()
                    }.environmentObject(homeVM)
                Spacer(minLength: 10)
                HomeStatsView(showPortFolio: $showPortFolio)
                Spacer(minLength: 10)
                ModernSearchField(
                    text: $homeVM.searchText,
                    placeholder: "Search by Name and Symbol......"
                )
                Spacer(minLength: 10)
                nameHeader

                // ===== Dynamic Section (replaces list area) =====
                ZStack {
                    if homeVM.isLoading {
                        // Loader replaces list area
                        VStack {
                            Spacer()
                            ProgressView()
                                .scaleEffect(1.3)
                                .padding()
                            Spacer()
                        }
                    } else if let error = homeVM.errorMessage {
                        // Error replaces list area
                        VStack(spacing: 12) {
                            Text("⚠️ \(error)")
                                .multilineTextAlignment(.center)
                                .padding()

                            Button("Retry") {
                                homeVM.retry()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Show lists or "No Coin Found"
                        if showPortFolio {
                            if homeVM.portFolioCoinsList.isEmpty {
                                Text("⚠️ No Coin Found")
                                    .multilineTextAlignment(.center)
                                    .padding()
                            } else {
                                PortFolioCoinListView
                                    .transition(.move(edge: .trailing))
                                    
                            }
                        } else {
                            if homeVM.allCoinsList.isEmpty {
                                Text("⚠️ No Coin Found")
                                    .multilineTextAlignment(.center)
                                    .padding()
                            } else {
                                AllCoinListView
                                    .transition(.move(edge: .leading))
                            }
                        }
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                ) // fills only list area
            }
            .padding(8)
            .background(Color.theme.backgroundColor.ignoresSafeArea())
            .navigationDestination(for: CoinModel.self) { coin in
                            CoinDetailView(coin: coin)
                        }
        }
    }

    private var nameHeader: some View {
        HStack {
            // Coin Column
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .rotationEffect(
                        Angle(degrees: homeVM.sortOptions == .rankReversed ? 180 : 0)
                    )
                    .opacity(
                        (homeVM.sortOptions == .rank || homeVM.sortOptions == .rankReversed) ? 1.0 : 0.0
                    )
            }
            .onTapGesture {
                withAnimation(.easeOut) {
                    homeVM.sortOptions =  homeVM.sortOptions == .rank ? .rankReversed : .rank
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Holdings Column (only if portfolio visible)
            if showPortFolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .rotationEffect(
                            Angle(degrees: homeVM.sortOptions == .holdingsReversed ? 180 : 0)
                        )
                        .opacity(
                            (homeVM.sortOptions == .holdings || homeVM.sortOptions == .holdingsReversed) ? 1.0 : 0.0
                        )
                } .onTapGesture {
                    withAnimation(.easeOut) {
                        homeVM.sortOptions =  homeVM.sortOptions == .holdings ? .holdingsReversed : .holdings
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }

            // Price Column
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .rotationEffect(
                        Angle(degrees: homeVM.sortOptions == .priceReversed ? 180 : 0)
                    )
                    .opacity(
                        (homeVM.sortOptions == .price || homeVM.sortOptions == .priceReversed) ? 1.0 : 0.0
                    )

                Button {
                    withAnimation(.easeIn(duration: 0.2)) {
                        homeVM.refresh()
                    }
                } label: {
                    Image(systemName: "goforward")
                        .font(.caption)
                        .rotationEffect(
                            Angle(degrees: homeVM.isLoading ? 360 : 0),
                            anchor: .center
                        )
                }
            }
            .onTapGesture {
                withAnimation(.easeOut) {
                    
                    homeVM.sortOptions =  homeVM.sortOptions == .price ? .priceReversed : .price
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal)
        .font(.subheadline.bold())
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
            ForEach(homeVM.allCoinsList) { coin in
                Button {
                    path.append(coin)   // <-- Push to detail
                } label: {
                    CoinRowView(coin: coin, showHoldings: false)
                }
                .listRowInsets(
                    .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                )
            }
        }
        .refreshable { homeVM.refresh() }
        .listStyle(.plain)
    }


    private var PortFolioCoinListView: some View {
        List {
            ForEach(homeVM.portFolioCoinsList) { coin in
                Button {
                    path.append(coin)   // <-- Push to detail
                } label: {
                    CoinRowView(coin: coin, showHoldings: true)
                }
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
            .onTapGesture {
                withAnimation(.easeInOut) {
                    showPortFolioSheet.toggle()
                }
            }
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
    }
    .environmentObject(HomeViewModel())
}

