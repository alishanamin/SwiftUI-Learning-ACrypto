//
//  StatsModel.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 18/09/2025.
//

import Foundation


struct StatsModel: Identifiable {
    
    let id = UUID().uuidString
    let title: String
    let volume: String
    let percentage: Double?
    
    
    init(title: String, volume: String, percentage: Double? = nil) {
        self.title = title
        self.volume = volume
        self.percentage = percentage
    }
    
    
}


