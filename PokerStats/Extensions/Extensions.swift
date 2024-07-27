//
//  DateFormatter+Extensions.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/4/24.
//

import Foundation

extension DateFormatter {
    static var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

extension Date {
    func shorten() -> String {
        return DateFormatter.shortFormatter.string(from: self)
    }
}

extension NumberFormatter {
    static var dollarFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current // Optional: Set to specific locale if needed
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
    static var Formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current // Optional: Set to specific locale if needed
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }
}

extension Int {
    func toDollars() -> String {
        guard let val = NumberFormatter.dollarFormatter.string(from: self as NSNumber) else {
            return "$0"
        }
        return val
    }
}

extension Float {
    func toOneDecimal() -> String {
        String(format: "%.1f", self)
    }
    
    func toMinutes() -> String {
        let totalSeconds = Int(floor(self * 60))

        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return formattedTime
    }
}
