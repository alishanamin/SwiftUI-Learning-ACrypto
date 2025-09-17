//
//  ContentView.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 25/08/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .foregroundColor(Color.theme.secondaryTextColor)
                .onTapGesture {
                    LoggerService.shared.e("Fetching API data…")
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
