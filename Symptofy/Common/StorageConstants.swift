//
//  StorageConstants.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/16/23.
//

import Foundation


extension Date {
    func getDateInStoreFormat() -> String? {
        return self.getDateStringForFormat(DateFormats.yyyy_MM_dd, timezone: nil)
    }
    
    func getRecordAddedFormat() -> String {
        return self.getDateStringForFormat("yyyy-MM-dd'T'HH:mm:ss", timezone: nil)!
    }
}

extension Int {
    func getDisplayTime() -> String {
        let time = Date().getDateFromMinutes(self)
        return time.getDateStringForFormat(DateFormats.hh_mm_aa, timezone: nil)!
    }
}

extension String {
    func displayDateInUserFormat() -> String {
        let date = self.getDateFromString(DateFormats.yyyy_MM_dd)?.getDateStringForFormat(DateFormats.MMM_dd_yyyy, timezone: nil)
        return date!
    }
}
