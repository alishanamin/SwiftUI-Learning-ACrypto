//
//  CoinDetailView.swift
//  ACrypto
//
//  Created by Alishan Muhammad Amin on 30/09/2025.
//

import SwiftUI

struct CoinDetailView: View {

    // MARK: - Properties
    @StateObject private var viewModel: CoinDetailViewModel
    @State private var showFullDescription = false
    
    private let gridColumns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let gridSpacing: CGFloat = 24
    
    // MARK: - Initializer
    init(coin: CoinModel) {
        _viewModel = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                
                CoinGraphView(coin: viewModel.coin)
                   
                
                sectionHeader("About \(viewModel.coin.symbol.uppercased())")
                descriptionSection
                
                Divider()
                
                sectionHeader("Overview")
                overviewSection
                
                Divider()
                
                sectionHeader("Additional Details")
                additionalDetailsSection
                
                Divider()
                linksView
                
                
            }
            .padding()
        }
        
        .navigationTitle(viewModel.coin.name.uppercased())
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 6) {
                    Text(viewModel.coin.symbol.uppercased())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    CoinLogo(url: viewModel.coin.image)
                }
            }
        }
    }
}

// MARK: - Subviews
private extension CoinDetailView {
    
    // MARK: Description
    var descriptionSection: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let error = viewModel.errorMessage {
                errorView(message: error)
            } else {
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.descriptionText)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .lineLimit(showFullDescription ? nil : 3)
                        .animation(.easeOut, value: showFullDescription)
                    
                    Button(showFullDescription ? "Read less..." : "Read more...") {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.blue)
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: Overview
    var overviewSection: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                errorView(message: error)
            } else {
                LazyVGrid(columns: gridColumns, alignment: .leading, spacing: gridSpacing) {
                    ForEach(viewModel.overViewStats) { stat in
                        StatsCard(stats: stat)
                    }
                }
            }
        }
    }
    
    // MARK: Additional Details
    var additionalDetailsSection: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                errorView(message: error)
            } else {
                LazyVGrid(columns: gridColumns, alignment: .leading, spacing: gridSpacing) {
                    ForEach(viewModel.additionalOverViewStats) { stat in
                        StatsCard(stats: stat)
                    }
                }
            }
        }
    }
    
    // MARK: Header
    func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
    }
    
    // MARK: Error View
    func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .font(.largeTitle)
            
            Text("Something went wrong")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: Links View
    var linksView : some View {
        VStack(alignment: .leading){
            if let url = URL(string: viewModel.webLink), !viewModel.webLink.isEmpty {
                Link(destination: url) {
                    Label("Website", systemImage: "link")
                        .font(.headline)
                        .foregroundStyle(.blue)
                        .accessibilityLabel("Open official website for \(viewModel.coin.name)")
                }
                .buttonStyle(.plain)
            }
            if let url = URL(string: viewModel.reddirectURL), !viewModel.reddirectURL.isEmpty {
                Link(destination: url) {
                    Label("Reddirect", systemImage: "link")
                        .font(.headline)
                        .foregroundStyle(.blue)
                        .accessibilityLabel("Open official website for \(viewModel.coin.name)")
                }
                .buttonStyle(.plain)
            }
            
        }
    }
    
}

// MARK: - CoinLogo
private struct CoinLogo: View {
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .transition(.opacity)
            case .failure(_):
                Image(systemName: "bitcoinsign.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.gray.opacity(0.4))
            default:
                ProgressView()
            }
        }
        .frame(width: 30, height: 30)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
        .shadow(radius: 1)
        .accessibilityHidden(true)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        CoinDetailView(coin: .mock)
    }
}

