import SwiftUI

struct CoinLogoTextWidget: View {
    let coin: CoinModel
    
    var body: some View {
        VStack(spacing: 6) {
            CoinLogo(url: coin.image)
            
            Text(coin.symbol.uppercased())
                .font(.callout.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .accessibilityLabel("\(coin.symbol) symbol")
            
            Text(coin.name.uppercased())
                .font(.caption.weight(.medium))
                .foregroundColor(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .accessibilityLabel(coin.name)
        }
        .frame(width: 80)
    }
}

private struct CoinLogo: View {
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 60, height: 60)
        .clipShape(Circle())
        .overlay(
            Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .shadow(radius: 1)
        .accessibilityHidden(true)
    }
}

#Preview {
    CoinLogoTextWidget(coin: CoinModel.mock)
}

