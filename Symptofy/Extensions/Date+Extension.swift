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
    
    public static var currentCalendar: Calendar {
        return Calendar.current
    }
    
    public static var current: Date {
        let day = Calendar.current.component(.day, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let year = Calendar.current.component(.year, from: Date())
        let dateComponents = DateComponents(calendar: .current, timeZone: .current, year: year, month: month, day: day)
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    var startOfDay: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        return gregorian.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return gregorian.date(byAdding: components, to: startOfDay!)!
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else {
            return nil
        }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else {
            return nil
        }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)
    }
    
    var startDayOfNextWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else {
            return nil
        }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }

    var endDayOfNextWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else {
            return nil
        }
        return gregorian.date(byAdding: .day, value: 13, to: sunday)
    }

    var startOfMonth: Date? {
        return Calendar(identifier: .gregorian).date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))
    }
    
    var endOfMonth: Date? {
        return Calendar(identifier: .gregorian).date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth!)
    }
    
    var currentCalendar: Calendar {
        return Calendar.current
    }
    
    var month: Int {
        return Date.currentCalendar.component(.month, from: self)
    }
    
    var year: Int {
        return Date.currentCalendar.component(.year, from: self)
    }
    var day: Int {
        return Date.currentCalendar.component(.day, from: self)
    }

    var shortMonthName: String {
        return Date.currentCalendar.shortMonthSymbols[self.month - 1]
    }
    
    func isInDateRange(_ date1: Date, date2: Date) -> Bool {
        let contains = (date1...date2).contains(self)
        return contains
    }
    
    static func getCustomDate(day: Int, month: Int, year: Int) -> Date? {
        var dateComponenets = DateComponents()
        dateComponenets.day = day
        dateComponenets.month = month
        dateComponenets.year = year
        guard let customDate = Calendar.current.date(from: dateComponenets) else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormats.MMM_dd_yyyy
        let formattedDateInStringFormat = formatter.string(from: customDate)
        let requiredDate = formatter.date(from: formattedDateInStringFormat)
        return requiredDate
    }
}
