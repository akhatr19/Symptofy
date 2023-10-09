//
//  DateFormatter+Extension.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/30/23.
//

import Foundation

extension DateFormatter {
    convenience init(format: String, timezone: TimeZone? = TimeZone.current) {
        self.init()
        self.timeZone = timezone
        self.dateFormat = format
    }
}
