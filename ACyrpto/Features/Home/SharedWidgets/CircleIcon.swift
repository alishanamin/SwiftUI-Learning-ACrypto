//
//  CircleIcon.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 25/08/2025.
//

import SwiftUI

struct CircleIcon: View {
    let iconName: String
    var body: some View {
        Circle()
            .frame(height: 46)
            .foregroundColor(Color.theme.backgroundColor)
            .shadow(radius: 5)
            .overlay {
                Image(systemName: iconName)
                    .font(.system(size: 20))
                    .foregroundColor(Color.theme.accentColor)
            }
    }
}

#Preview {
    CircleIcon(iconName: "heart.fill")
        
        
}
