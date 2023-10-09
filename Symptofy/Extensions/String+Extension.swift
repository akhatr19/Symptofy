//
//  String+Extension.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/3/23.
//

import Foundation

extension String {
    func getDateFromString(_ format: String) -> Date? {
        let formatter  = DateFormatter(format: format)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        return formatter.date(from: self)
    }
}
