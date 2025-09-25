import SwiftUI

struct PortFolioSheetView: View {
    @EnvironmentObject private var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedCoin: CoinModel? = nil
    @State private var amountText: String = ""
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    ModernSearchField(
                        text: $homeVM.searchText,
                        placeholder: "Search by Name and Symbol..."
                    )
                    
                    CoinHList
                    
                    if let coin = selectedCoin {
                        SelectedCoinDetailsView(
                            coin: coin,
                            amountText: $amountText,
                            currentValue: getCurrentValue()
                        )
                        .transaction { t in
                            t.animation = nil
                        }
                    }
                }
                .padding()
                .font(.headline)
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: dismiss.callAsFunction) {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack (spacing: 10){
                        Image(systemName: "checkmark")
                        Text("SAVE")
                    }.padding(5)
                        .opacity(
                            selectedCoin != nil &&  selectedCoin?.currentHoldings != Double(
                                amountText
                            ) ? 1.0 : 0.0
                        )
                }
            }
        }
    }
    
    private func getCurrentValue() -> Double {
        guard let quantity = Double(amountText) else { return 0 }
        return quantity * (selectedCoin?.currentPrice ?? 0)
    }
}

extension PortFolioSheetView {
    var CoinHList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(homeVM.allCointsList) { coin in
                    CoinLogoTextWidget(coin: coin)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                            }
                        }
                        .padding(5)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    Color.green,
                                    lineWidth: selectedCoin?.id == coin.id ? 2 : 0
                                )
                        }
                }
            }
        }
    }
}

private struct SelectedCoinDetailsView: View {
    let coin: CoinModel
    @Binding var amountText: String
    let currentValue: Double
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Selected Price of \(coin.name)(\(coin.symbol)):")
                Spacer()
                Text(coin.currentPrice.toCurrencyStringFormat(code: "$"))
                    .fontWeight(.semibold)
            }
            
            Divider()
            
            HStack {
                Text("Portfolio Value:")
                    .lineLimit(1)
                Spacer()
                TextField("Ex 1.5", text: $amountText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current Value:")
                Spacer()
                Text(currentValue.toCurrencyStringFormat(code: "$"))
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    PortFolioSheetView()
        .environmentObject(HomeViewModel())
}

