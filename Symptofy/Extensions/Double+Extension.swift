//
//  Double+Extension.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/21/23.
//

import Foundation

extension Double {
    func getFormattedString(fraction: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
        formatter.maximumFractionDigits = fraction
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
