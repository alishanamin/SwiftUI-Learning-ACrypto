//
//  CurrencyExtension.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 28/08/2025.
//

import Foundation

// MARK: - NumberFormatter Extensions
extension NumberFormatter {
    
    /// Formatter with 2 decimal places
    static var twoDecimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter
    }
    
    /// Formatter with 4 decimal places
    static var fourDecimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 4
        formatter.maximumFractionDigits = 4
        formatter.numberStyle = .decimal
        return formatter
    }
    
    /// Formatter with 6 decimal places
    static var sixDecimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 6
        formatter.maximumFractionDigits = 6
        formatter.numberStyle = .decimal
        return formatter
    }
    
    /// Percentage formatter (e.g. 25.60%)
    static var percentage: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    /// Grouped number formatter (e.g. 116,000.00)
    static var grouped: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    /// Currency formatter (uses device locale, e.g. $1,234.57)
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    /// Currency formatter with custom code (e.g. PKR 1,234.57)
    static func currency(code: String) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = code
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    static func currencyFormat(code: String) -> NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = code
        f.minimumFractionDigits = 0      // don’t force .00
        f.maximumFractionDigits = 2      // show up to 2 if needed
        return f
    }
}

// MARK: - Double Extensions
extension Double {
    
    /// Format using any NumberFormatter
    func format(using formatter: NumberFormatter) -> String {
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    /// Format with fixed decimal places (faster than NumberFormatter if you just need precision)
    func toString(decimals: Int = 2) -> String {
        return String(format: "%.\(decimals)f", self)
    }
    
    /// Convert to percentage string (e.g. 0.256 -> "25.60%")
    func toPercentageString(decimals: Int = 2) -> String {
        return (self).format(using: NumberFormatter.percentage)
    }
    /// Formats a double into percentage string (e.g. -0.78 -> "-0.78%")
    var asPercentString: String {
        String(format: "%.2f%%", self)
    }
    /// Format large numbers into readable strings (e.g. 1_200 -> "1.2K", 1_000_000 -> "1M")
    func formattedWithAbbreviations(symbol: String? = nil, decimals: Int = 2) -> String {
            let num = abs(self)
            let sign = (self < 0) ? "-" : ""
            
            let formatter: (Double, String) -> String = { value, suffix in
                return "\(sign)\(symbol ?? "")\(value.toString(decimals: decimals))\(suffix)"
            }
            
            switch num {
            case 1_000_000_000_000...:
                return formatter(num / 1_000_000_000_000, "T")
            case 1_000_000_000...:
                return formatter(num / 1_000_000_000, "B")
            case 1_000_000...:
                return formatter(num / 1_000_000, "M")
            case 1_000...:
                return formatter(num / 1_000, "K")
            default:
                return "\(sign)\(symbol ?? "")\(self.toString(decimals: decimals))"
            }
        }
    
    /// Convert to grouped string (e.g. 116000 -> "116,000.00")
    func toGroupedString() -> String {
        return self.format(using: NumberFormatter.grouped)
    }
    
    /// Convert to currency string using device locale
    func toCurrencyString() -> String {
        return self.format(using: NumberFormatter.currency)
    }
    
    /// Convert to currency string with custom code (e.g. "PKR 1,234.57")
    func toCurrencyString(code: String) -> String {
        return self.format(using: NumberFormatter.currency(code: code))
    }
    
    func toCurrencyStringFormat(code: String) -> String {
            let formatter = NumberFormatter.currencyFormat(code: code)
            return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        }
}


