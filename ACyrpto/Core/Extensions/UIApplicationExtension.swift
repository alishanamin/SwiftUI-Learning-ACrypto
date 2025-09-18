//
//  UIApplicationExtension.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 18/09/2025.
//

import Foundation
import SwiftUI


extension UIApplication {
    
    func hideKeyboard() {
        UIApplication.shared
            .sendAction(#selector(UIResponder.resignFirstResponder),
                        to: nil, from: nil, for: nil)
    }
    
}
