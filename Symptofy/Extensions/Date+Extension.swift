//
//  Date+Extension.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/30/23.
//

import Foundation

extension Date {
    func getTimeInMinutes() -> Int {
        let currentTime: DateComponents = Calendar.current.dateComponents([.hour, .minute], from: self)
        var time = 0
        if let hour = currentTime.hour {
            time += hour * 60
        }
        if let minute = currentTime.minute {
            time += minute
        }
        return time
    }
    
    func getDateFromMinutes(_ timeInMinutes: Int) -> Date {
        return Calendar.current.startOfDay(for: self).addingTimeInterval(TimeInterval(timeInMinutes * 60))
    }
    
    func getDateStringForFormat(_ format: String, timezone: String?) -> String? {
        let formatter  = DateFormatter(format: format)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if timezone == nil {
            formatter.timeZone = TimeZone.autoupdatingCurrent
        } else {
            formatter.timeZone = TimeZone.init(identifier: timezone!)!
        }
        return formatter.string(from: self)
    }
    
    func getDateByAddingMonths(_ noOfMonths: Int) -> Date {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components( [.hour, .minute, .second, .day, .month, .year], from: self)

        var dateComponenets = DateComponents()
        dateComponenets.day = components.day
        dateComponenets.month = components.month! + noOfMonths
        dateComponenets.year = components.year!

        let desiredDate = calendar.date(from: dateComponenets)
        return desiredDate!
    }
    
    func getDateByAddingDays(_ days: Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: days, to: self, options: [])!
    }
}
