//
//  CircleAnimationView.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 25/08/2025.
//

import SwiftUI

struct CircleAnimationView: View {
    
    @Binding var isAnimation: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .scale(isAnimation ? 1.5 : 0)
            .opacity(isAnimation ? 0 : 1)
            .animation(
                isAnimation ? .easeOut(duration: 0.8): .none,
                value: isAnimation
            )
    }
}


#Preview {
    CircleAnimationView(
        isAnimation: .constant(true)
        
    ).foregroundColor(.red)
        .frame(width: 100,height: 100)
}
