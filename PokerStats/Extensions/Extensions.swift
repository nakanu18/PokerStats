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
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

extension Double {
    func dollars() -> String {
        guard let val = NumberFormatter.dollarFormatter.string(from: self as NSNumber) else {
            return "$0.00"
        }
        return val
    }
}
