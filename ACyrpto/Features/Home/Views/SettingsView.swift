//
//  SettingsView.swift
//  ACrypto
//
//  Created by ALI SHAN Muhammad Amin on 09/10/2025.
//

import SwiftUI

struct SettingsView: View {
    
    let linkedinProfileURL = "https://www.linkedin.com/in/alishan786"
    let coinGeckoURL = "https://www.coingecko.com"
    let codeSeekYT = "https://www.youtube.com/@codeseek2947"
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            List {
                
                // MARK: - About ACrypto
                Section("About ACrypto") {
                    VStack(alignment: .leading, spacing: 10) {
                        Image("logo")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Text(
                            "Acrypto — A sleek SwiftUI crypto tracker built with MVVM, Core Data, and Combine (Publishers/Subscribers) for real-time price updates and portfolio insights."
                        )
                    }
                    .padding(.vertical, 5)
                }
                
                // MARK: - About CoinGecko
                Section("About CoinGecko") {
                    VStack(alignment: .leading, spacing: 10) {
                        Image("coingecko")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Text(
                            "CoinGecko provides a fundamental analysis of the crypto market. In addition to tracking price, volume and market capitalisation, CoinGecko tracks community growth, open-source code development, major events and on-chain metrics."
                        )
                    }
                    .padding(.vertical, 5)
                }
                
                // MARK: - About Me
                aboutMeSection
                Section("Useful Links") {
                    
                    Link(
                        "🔗 LinkedIn Profile",
                        destination: URL(
                            string: "https://www.linkedin.com/in/alishan786"
                        )!
                    )
                    Link(
                        "▶️ CodeSeek YouTube",
                        destination: URL(
                            string: "https://www.youtube.com/@codeseek2947"
                        )!
                    )
                    Link(
                        "🌐 CoinGecko",
                        destination: URL(string: "https://www.coingecko.com")!
                    )
                }
               
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: dismiss.callAsFunction) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}


extension SettingsView {
    private var aboutMeSection: some View {
        Section("About Me") {
            VStack(alignment: .leading, spacing: 10) {
                AsyncImage(
                    url: URL(
                        string: "https://avatars.githubusercontent.com/u/61986083?v=4"
                    )
                ) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    ProgressView()
                }

                Text("Experienced Mobile App Developer with 6+ years in Flutter (since Nov 2019), currently working as Senior Software Engineer – AVP at Faysal Bank Ltd. I specialize in building scalable, user-focused mobile apps with Flutter/Dart and Swift. Former Flutter Lead at GDSC-DSU and ex-Senior Developer at Synergates. Passionate about tech education—YouTube creator at CodeSeek, instructor at Bano Qabil, and active contributor on Stack Overflow. Always learning, always building.")
                    .font(.callout)
                    .foregroundColor(.secondary)

                
                
            }
            .padding(.vertical, 5)
        }

    }

}
