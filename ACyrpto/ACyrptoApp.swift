//
//  ACyrptoApp.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 25/08/2025.
//

import SwiftUI

@main
struct ACyrptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }.environmentObject(vm)
        }
    }
}
