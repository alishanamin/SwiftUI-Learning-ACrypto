//
//  CoinGraphView.swift
//  ACrypto
//
//  Created by Alishan Muhammad Amin on 06/10/2025.
//

import SwiftUI

struct CoinGraphView: View {
    private let data: [Double]
    private let minY: Double
    private let maxY: Double
    private let strokeColor: Color
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        self.data = coin.sparklineIn7D?.price ?? []
        self.minY = data.min() ?? 0
        self.maxY = data.max() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        self.strokeColor = priceChange > 0 ? Color.green : Color.red
    }
    
    var body: some View {
        VStack(spacing: 8) {
            chartView
                .frame(height: 220)
                .background(chartBackground)
                .overlay(alignment: .leading) {
                    chartOverlay
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: strokeColor.opacity(0.25), radius: 6, x: 0, y: 4)
        }
        .padding(5)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2)) {
                percentage = 1.0
            }
        }
    }
}

#Preview {
    CoinGraphView(coin: CoinModel.mock)
}

extension CoinGraphView {
    
    private var chartView: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width
            let stepX = width / CGFloat(max(data.count - 1, 1))
            let yRange = maxY - minY
            
            Path { path in
                for index in data.indices {
                    let x = stepX * CGFloat(index)
                    let y = (1 - CGFloat((data[index] - minY) / yRange)) * height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(
                LinearGradient(
                    colors: [strokeColor.opacity(0.9), strokeColor.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
            )
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        strokeColor.opacity(0.2),
                        strokeColor.opacity(0.05),
                        .clear
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .mask(
                    Path { path in
                        for index in data.indices {
                            let x = stepX * CGFloat(index)
                            let y = (1 - CGFloat((data[index] - minY) / yRange)) * height
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                        path.addLine(to: CGPoint(x: width, y: height))
                        path.addLine(to: CGPoint(x: 0, y: height))
                        path.closeSubpath()
                    }
                    .trimmedPath(from: 0, to: percentage)
                )
            )
        }
    }
    
    private var chartBackground: some View {
        ZStack {
            Color(.systemBackground)
            
            VStack {
                Spacer()
                ForEach(0..<3) { _ in
                    Divider()
                        .background(Color.gray.opacity(0.15))
                    Spacer()
                }
            }
            
            HStack {
                Spacer()
                Divider()
                    .background(Color.gray.opacity(0.15))
                Spacer()
            }
        }
    }
    
    private var chartOverlay: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(maxY.toCurrencyStringFormat(code: "$"))
            Spacer()
            let midValue = (maxY + minY) / 2
            Text(midValue.toCurrencyStringFormat(code: "$"))
            Spacer()
            Text(minY.toCurrencyStringFormat(code: "$"))
        }
        .font(.caption2)
        .foregroundStyle(.secondary)
        .padding(5)
    }
}

