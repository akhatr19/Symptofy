//
//  FrequencyView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 10/14/23.
//

import SwiftUI

enum DashboardSegmentPicker: String, CustomStringConvertible, CaseIterable {
    case daily
    case weekly
    case monthly
    case threeMonths
    case sixMonths

    var description: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Week"
        case .monthly:
            return "Month"
        case .threeMonths:
            return "3 Months"
        case .sixMonths:
            return "6 Months"
        }
    }
}

struct FrequencyView: View {

    @State private var segmentSelection: DashboardSegmentPicker = .weekly
    @State private var dateRange = ""
    @State private var fromDate: Date = Date.current
    @State private var toDate: Date = Date.current
    @State private var componentCurrentDateRange = DateInterval(start: Date.current, end: Date.current)
    @State private var dateDisplayLbl = ""
    @State private var quarters = [[Int]]()
    @State private var currentQuarter = [Int]()
    @State private var halfYears = [[Int]]()
    @State private var currentHalfYear = [Int]()
    @State private var componentMonthPosition = -1
    @State private var isNextButtonEnabled = false
    @State private var isPreviousButtonEnabled = false
    var callBack: (_ dateInterval: DateInterval, _ frequency: DashboardSegmentPicker) -> ()

    @State var componentDate: Date = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let currentDate = calendar.startOfDay(for: Date())
        return currentDate
    }()


//    init() {
//        UISegmentedControl.appearance()
//            .selectedSegmentTintColor = .buttonBackgroundColor
//        UISegmentedControl.appearance()
//            .setTitleTextAttributes([.foregroundColor: UIColor.normalTextColor!], for: .normal)
//        UISegmentedControl.appearance()
//            .setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
//    }
    var body: some View {
        VStack {
            Picker("", selection: $segmentSelection) {
                ForEach(DashboardSegmentPicker.allCases, id: \.self) { option in
                    Text(option.description)
                        .font(.title3)
                }
            }
            .tint(.green)
            .pickerStyle(.segmented)

            HStack {
                Button {
                    previousButtonTap()
                } label: {
                    Image(systemName: "chevron.backward")
                }
                .disabled(!isPreviousButtonEnabled)
                .opacity(isPreviousButtonEnabled ? 1 : 0.3)

                Spacer()

                Text(dateDisplayLbl)
                    .font(.title3)
                    .fontWeight(.semibold)

                Spacer()

                Button {
                    nextButtonTap()
                } label: {
                    Image(systemName: "chevron.forward")
                }
                .disabled(!isNextButtonEnabled)
                .opacity(isNextButtonEnabled ? 1 : 0.3)
            }
            .padding([.horizontal, .top])
            .foregroundColor(.buttonBackgroundColor)
        }
        .padding(.horizontal)
        .onChange(of: segmentSelection, perform: { newValue in
            frequencyChanged()
        })
        .onAppear {
            setUpData()
        }
    }

    func setUpData() {
        generatePreviousDateRangeWithIndex(currentDate: componentDate)
        quarters = generateQuarters(componentDate)
        halfYears = generateHalfYears(componentDate)
        configureNextAndPreviousButtons()
    }

    func configureNextAndPreviousButtons() {
        buttonsEnableOrDisable()
    }

    func resetDate() {
        if componentDate > Date.current {
            componentDate = Date.current
        }
    }

    func frequencyChanged() {
        componentDate = Date.current
        generatePreviousDateRangeWithIndex(currentDate: componentDate, isFrequencyChanged: true)
        buttonsEnableOrDisable()
    }
}

//MARK: Previous data
extension FrequencyView {
    func previousButtonTap() {
        resetDate()
        assignToPreviousDateRange(currentDate: componentDate)
        generatePreviousDateRangeWithIndex(currentDate: componentDate)
        buttonsEnableOrDisable()
    }

    func generateQuarters(_ componentCurrentDate: Date) -> [[Int]] {
        var current = componentCurrentDate
        var dateQuarter = [[Int]]()
        for _ in 0...3 {
            var quarter = [Int]()
            for _ in 0...2 {
                quarter.append(current.month)
                current = Date.currentCalendar.date(byAdding: .month, value: -1, to: current) ?? Date.current
            }
            dateQuarter.append(quarter.reversed())
        }
        return dateQuarter
    }

    func generateHalfYears(_ componentCurrentDate: Date) -> [[Int]] {
        var current = componentCurrentDate
        var dateQuarter = [[Int]]()
        for _ in 0...6 {
            var quarter = [Int]()
            for _ in 0...5 {
                quarter.append(current.month)
                current = Date.currentCalendar.date(byAdding: .month, value: -1, to: current) ?? Date.current
            }
            dateQuarter.append(quarter.reversed())

            if dateQuarter.count == 2 {
                break
            }
        }
        return dateQuarter
    }

    func assignToPreviousDateRange(currentDate: Date) {
        guard let previousDate = getPreviousDate(currentDate: currentDate, isFrequencyChanged: true) else {
            return
        }
        componentDate = previousDate
    }

    func getPreviousDate(currentDate: Date, isFrequencyChanged: Bool) -> Date? {
        var previousDate: Date?
        switch segmentSelection {
        case .daily:
            previousDate = Date.currentCalendar.date(byAdding: .day, value: -1, to: currentDate)
        case .weekly:
            previousDate = Date.currentCalendar.date(byAdding: .day, value: -7, to: currentDate)
        case .monthly:
            previousDate = Date.currentCalendar.date(byAdding: .month, value: -1, to: currentDate)
        case .threeMonths:
            if isFrequencyChanged {
                previousDate = currentDate
            } else {
                previousDate = Date.currentCalendar.date(byAdding: .month, value: -3, to: currentDate)
                componentDate = previousDate ?? Date.current
            }
        case .sixMonths:
            if isFrequencyChanged {
                previousDate = currentDate
            } else {
                previousDate = Date.currentCalendar.date(byAdding: .month, value: -6, to: currentDate)
                componentDate = previousDate ?? Date.current
            }
        }
        return previousDate
    }

    @discardableResult
    fileprivate func generatePreviousDateRangeWithIndex(currentDate: Date, isFrequencyChanged: Bool = false) -> String {
        dateRange = getPreviousDateRange(currentDate: currentDate, isFrequencyChanged: isFrequencyChanged)
        dateDisplayLbl = dateRange
        return dateRange
    }

    func getPreviousDateRange(currentDate: Date, isFrequencyChanged: Bool) -> String {
        var formattedDate = ""
        guard let startDate = getPreviousDate(currentDate: currentDate, isFrequencyChanged: isFrequencyChanged) else {
            return formattedDate
        }
        switch segmentSelection {
        case .daily:
            fromDate = currentDate
            toDate = currentDate
            componentCurrentDateRange = DateInterval(start: fromDate, end: toDate.endOfDay!)
            let dateInterval = DateInterval(start: fromDate, end: toDate.endOfDay!)
            callBack(dateInterval, .daily)
        case .weekly:
            fromDate = currentDate.startOfWeek!
            toDate = currentDate.endOfWeek!
            if toDate > Date.current {
                toDate = Date.current
            }
            componentCurrentDateRange = DateInterval(start: fromDate, end: toDate.endOfDay!)
            let dateInterval = DateInterval(start: fromDate, end: toDate.endOfDay!)
            callBack(dateInterval, .weekly)
        case .monthly:
            fromDate = currentDate.startOfMonth!
            toDate = currentDate.endOfMonth!
            if toDate > Date.current {
                toDate = Date.current
            }
            componentCurrentDateRange = DateInterval(start: fromDate, end: toDate.endOfDay!)
            let dateInterval = DateInterval(start: fromDate, end: toDate.endOfDay!)
            callBack(dateInterval, .monthly)
        case .threeMonths:
            fromDate = setComponentsCurrentThreeMonthsQuarter(startDate).0.start
            toDate = setComponentsCurrentThreeMonthsQuarter(startDate).0.end
            if toDate > Date.current {
                toDate = Date.current
            }
            componentCurrentDateRange = DateInterval(start: fromDate, end: toDate.endOfDay!)
            let dateInterval = DateInterval(start: fromDate, end: toDate.endOfDay!)
            callBack(dateInterval, .threeMonths)
        case .sixMonths:
            fromDate = setComponentsCurrentHalfYear(startDate).0.start
            toDate = setComponentsCurrentHalfYear(startDate).0.end
            if toDate > Date.current {
                toDate = Date.current
            }
            componentCurrentDateRange = DateInterval(start: fromDate, end: toDate.endOfDay!)
            let dateInterval = DateInterval(start: fromDate, end: toDate.endOfDay!)
            callBack(dateInterval, .threeMonths)
        }
        formattedDate = formatDate(from: fromDate, to: toDate)
        if segmentSelection == .threeMonths {
            formattedDate = setComponentsCurrentThreeMonthsQuarter(startDate).1
        }
        if segmentSelection == .sixMonths {
            formattedDate = setComponentsCurrentHalfYear(startDate).1
        }
        return formattedDate
    }
}

//MARK: Next data
extension FrequencyView {
    func nextButtonTap() {
        resetDate()
        generateNextDateRangeWithIndex(currentDate: componentDate)
        assignToNextDateRange(currentDate: componentDate)
        buttonsEnableOrDisable()
    }

    @discardableResult
    fileprivate func generateNextDateRangeWithIndex(currentDate: Date, isFrequencyChanged: Bool = false) -> String {
        dateRange = getNextDateRange(currentDate: currentDate)
        dateDisplayLbl = dateRange
        return dateRange
    }

    func getNextDateRange(currentDate: Date) -> String {
        var formattedDate = ""
        guard let nextDate = getNextDate(currentDate: currentDate) else {
            return formattedDate
        }
        switch segmentSelection {
        case .daily:
            fromDate = nextDate
            toDate = nextDate
            componentCurrentDateRange = DateInterval(start: fromDate, end: toDate.endOfDay!)
            let dateInterval = DateInterval(start: fromDate, end: toDate.endOfDay!)
            callBack(dateInterval, .daily)
        case .weekly:
            fromDate = nextDate.startOfWeek!
            toDate = nextDate.endOfWeek!
            if toDate > Date.current {
                toDate = Date.current
            }
            componentCurrentDateRange = DateInterval(start: fromDate, end: toDate.endOfDay!)
            let dateInterval = DateInterval(start: fromDate, end: toDate.endOfDay!)
            callBack(dateInterval, .weekly)
        case .monthly:
            fromDate = nextDate.startOfMonth!
            toDate = nextDate.endOfMonth!
            if toDate > Date.current {
                toDate = Date.current
            }
            componentCurrentDateRange = DateInterval(start: fromDate, end: toDate.endOfDay!)
            let dateInterval = DateInterval(start: fromDate, end: toDate.endOfDay!)
            callBack(dateInterval, .monthly)
        case .threeMonths:
            fromDate = setComponentsCurrentThreeMonthsQuarter(nextDate).0.start
            toDate = setComponentsCurrentThreeMonthsQuarter(nextDate).0.end
            if toDate > Date.current {
                toDate = Date.current
            }
            componentCurrentDateRange = DateInterval(start: fromDate, end: toDate.endOfDay!)
            let dateInterval = DateInterval(start: fromDate, end: toDate.endOfDay!)
            callBack(dateInterval, .threeMonths)
        case .sixMonths:
            fromDate = setComponentsCurrentHalfYear(nextDate).0.start
            toDate = setComponentsCurrentHalfYear(nextDate).0.end
            if toDate > Date.current {
                toDate = Date.current
            }
            componentCurrentDateRange = DateInterval(start: fromDate, end: toDate.endOfDay!)
            let dateInterval = DateInterval(start: fromDate, end: toDate.endOfDay!)
            callBack(dateInterval, .threeMonths)
        }
        formattedDate = formatDate(from: fromDate, to: toDate)
        if segmentSelection == .threeMonths {
            formattedDate = setComponentsCurrentThreeMonthsQuarter(nextDate).1
        }
        if segmentSelection == .sixMonths {
            formattedDate = setComponentsCurrentHalfYear(nextDate).1
        }
        return formattedDate
    }

    func getNextDate(currentDate: Date) -> Date? {
        var nextDate: Date?
        switch segmentSelection {
        case .daily:
            nextDate = Date.currentCalendar.date(byAdding: .day, value: 1, to: currentDate)
        case .weekly:
            nextDate = Date.currentCalendar.date(byAdding: .day, value: 7, to: currentDate)
        case .monthly:
            nextDate = Date.currentCalendar.date(byAdding: .month, value: 1, to: currentDate)
        case .threeMonths:
            nextDate = Date.currentCalendar.date(byAdding: .month, value: 3, to: currentDate)
        case .sixMonths:
            nextDate = Date.currentCalendar.date(byAdding: .month, value: 6, to: currentDate)
        }
        return nextDate
    }

    func assignToNextDateRange(currentDate: Date) {
        guard let nextDate = getNextDate(currentDate: currentDate) else {
            return
        }
        componentDate = nextDate
    }
}

//MARK: Common methods for 3 months
extension FrequencyView {
    func setComponentsCurrentThreeMonthsQuarter(_ componentDate: Date) -> (DateInterval, String) {
        let componentMonth = componentDate.month
        var formattedString = ""
        quarters.forEach { quarter in
            if quarter.contains(componentMonth) {
                currentQuarter = quarter
            }
        }

        for (index, month) in currentQuarter.enumerated() {
            if month == componentMonth {
                componentMonthPosition = index
            }
        }

        let interval = calculateIntervalForQuarterPosition(componentMonthPosition, date: componentDate)
        formattedString = (interval.start.year == interval.end.year) ? "\(interval.start.shortMonthName) \(interval.start.day) - \(interval.end.shortMonthName) \(interval.end.day), \(interval.end.year)" : "\(interval.start.shortMonthName) \(interval.start.day), \(interval.start.year) - \(interval.end.shortMonthName) \(interval.end.day), \(interval.end.year)"
        return (interval, formattedString)
    }

    func calculateIntervalForQuarterPosition(_ position: Int, date: Date) -> DateInterval {
        var interval = DateInterval(start: Date.current, end: Date.current)
        switch position {
        case 0:
            interval.start = (date.startOfMonth?.startOfDay)!
            interval.end = Date.currentCalendar.date(byAdding: .month, value: 2, to: date)?.endOfMonth ?? date
        case 1:
            interval.start = Date.currentCalendar.date(byAdding: .month, value: -1, to: date)?.startOfMonth?.startOfDay ?? date.startOfDay!
            interval.end = Date.currentCalendar.date(byAdding: .month, value: 1, to: date)?.endOfMonth ?? date
        case 2:
            interval.start = Date.currentCalendar.date(byAdding: .month, value: -2, to: date)?.startOfMonth?.startOfDay ?? date.startOfDay!
            interval.end = date.endOfMonth!
        default:
            break
        }
        return interval
    }
}

//MARK: Common methods for 6 months
extension FrequencyView {
    func setComponentsCurrentHalfYear(_ componentDate: Date) -> (DateInterval, String) {
        let componentMonth = componentDate.month
        var formattedString = ""
        halfYears.forEach { quarter in
            if quarter.contains(componentMonth) {
                currentHalfYear = quarter
            }
        }

        for (index, month) in currentHalfYear.enumerated() {
            if month == componentMonth {
                componentMonthPosition = index
            }
        }

        let interval = calculateIntervalForHalfYearPosition(componentMonthPosition, date: componentDate)
        formattedString = (interval.start.year == interval.end.year) ? "\(interval.start.shortMonthName) \(interval.start.day) - \(interval.end.shortMonthName) \(interval.end.day), \(interval.end.year)" : "\(interval.start.shortMonthName) \(interval.start.day), \(interval.start.year) - \(interval.end.shortMonthName) \(interval.end.day), \(interval.end.year)"
        return (interval, formattedString)
    }

    func calculateIntervalForHalfYearPosition(_ position: Int, date: Date) -> DateInterval {
        var interval = DateInterval(start: Date.current, end: Date.current)
        switch position {
        case 0:
            interval.start = (date.startOfMonth?.startOfDay)!
            interval.end = Date.currentCalendar.date(byAdding: .month, value: 2, to: date)?.endOfMonth ?? date
        case 1:
            interval.start = Date.currentCalendar.date(byAdding: .month, value: -1, to: date)?.startOfMonth?.startOfDay ?? date.startOfDay!
            interval.end = Date.currentCalendar.date(byAdding: .month, value: 1, to: date)?.endOfMonth ?? date
        case 2:
            interval.start = Date.currentCalendar.date(byAdding: .month, value: -2, to: date)?.startOfMonth?.startOfDay ?? date.startOfDay!
            interval.end = Date.currentCalendar.date(byAdding: .month, value: 2, to: date)?.endOfMonth ?? date
        case 3:
            interval.start = Date.currentCalendar.date(byAdding: .month, value: -3, to: date)?.startOfMonth?.startOfDay ?? date.startOfDay!
            interval.end = Date.currentCalendar.date(byAdding: .month, value: 3, to: date)?.endOfMonth ?? date
        case 4:
            interval.start = Date.currentCalendar.date(byAdding: .month, value: -4, to: date)?.startOfMonth?.startOfDay ?? date.startOfDay!
            interval.end = Date.currentCalendar.date(byAdding: .month, value: 4, to: date)?.endOfMonth ?? date
        case 5:
            interval.start = Date.currentCalendar.date(byAdding: .month, value: -5, to: date)?.startOfMonth?.startOfDay ?? date.startOfDay!
            interval.end = date.endOfMonth!
        default:
            break
        }
        return interval
    }
}

//MARK: Common methods for date format
extension FrequencyView {
    func formatDate(from: Date, to: Date) -> String {
        let currentDay = to.day
        let currentMonthNumber = to.month
        let currentYear = to.year
        var currentMonth = ""
        var startWeekMonth = ""
        var endWeekMonth = ""
        var formattedDate = ""
        let start = to.startOfWeek!
        let end = to.endOfWeek!
        let startDayOfWeek = start.day
        let startMonthNumberOfWeek = start.month
        let startYearOfWeek = start.year
        let endDayOfWeek = end.day
        let endMonthNumberrOfWeek = end.month
        let endYearOfWeek = end.year
        var months = [String]()

        switch segmentSelection {
        case .daily, .monthly:
            months = Calendar.current.monthSymbols
        case .weekly, .threeMonths, .sixMonths:
            months = Calendar.current.shortMonthSymbols
        }

        for (index, month) in months.enumerated() {
            if index == currentMonthNumber - 1 {
                currentMonth = month
            }
            if index == startMonthNumberOfWeek - 1 {
                startWeekMonth = month
            }
            if index == endMonthNumberrOfWeek - 1 {
                endWeekMonth = month
            }
        }

        switch segmentSelection {
        case .daily:
            if to.startOfDay!.compare(Date.current) == .orderedSame {
                formattedDate = "Today"
            } else {
                formattedDate = "\(currentMonth) \(currentDay), \(currentYear)"
            }
        case .weekly:
            if startYearOfWeek == endYearOfWeek {
                formattedDate = (startMonthNumberOfWeek == endMonthNumberrOfWeek) ? "\(startWeekMonth) \(startDayOfWeek) - \(endDayOfWeek), \(startYearOfWeek)" : "\(startWeekMonth) \(startDayOfWeek) - \(endWeekMonth) \(endDayOfWeek), \(startYearOfWeek)"
            } else {
                formattedDate = "\(startWeekMonth) \(startDayOfWeek), \(startYearOfWeek) - \(endWeekMonth) \(endDayOfWeek), \(endYearOfWeek)"
            }
        case .monthly:
            formattedDate = "\(currentMonth) \(currentYear)"
        case .threeMonths:
            formattedDate = ""
        case .sixMonths:
            formattedDate = ""
        }
        return formattedDate
    }
}

//MARK: Button's Enable/Disable
extension FrequencyView {
    func buttonsEnableOrDisable() {
        isNextButtonEnabled = checkNextButtonStatus(date: componentDate)
        isPreviousButtonEnabled = checkPreviousButtonStatus(date: componentDate)
    }

    func checkNextButtonStatus(date: Date) -> Bool {
        let month = date.month
        let year = date.year
        let currentDate = Date.current
        let currentMonth = currentDate.month
        let currentYear = currentDate.year

        switch segmentSelection {
        case .daily:
            let result = !(date >= currentDate)
            return result
        case .weekly:
            let startDateOfWeek = date.startOfWeek
            let endDateOfWeek = date.endOfWeek
            var result = true
            if currentDate == startDateOfWeek || currentDate == endDateOfWeek {
                result = false
            } else if currentDate > startDateOfWeek! && currentDate < endDateOfWeek! {
                result = false
            } else if startDateOfWeek! > currentDate && endDateOfWeek! > currentDate {
                result = false
            }
            return result
        case .monthly:
            return !(month >= currentMonth && year >= currentYear)
        case .threeMonths:
            let interval = calculateIntervalForQuarterPosition(componentMonthPosition, date: componentDate)
            return !(Date.current.isInDateRange(interval.start, date2: interval.end))
        case .sixMonths:
            let interval = calculateIntervalForHalfYearPosition(componentMonthPosition, date: componentDate)
            return !(Date.current.isInDateRange(interval.start, date2: interval.end))
        }
    }

    func checkPreviousButtonStatus(date: Date) -> Bool {
        guard let customDate = Date.getCustomDate(day: 1, month: 1, year: 1990) else {
            return true
        }
        let month = date.month
        let year = date.year
        let restrictedMonth = customDate.month
        let restrictedYear = customDate.year

        switch segmentSelection {
        case .daily:
            let result = date > customDate
            return result
        case .weekly:
            let startDateOfWeek = date.startOfWeek
            let endDateOfWeek = date.endOfWeek
            var result = true
            if customDate == startDateOfWeek || customDate == endDateOfWeek {
                result = false
            } else if customDate > startDateOfWeek! && customDate < endDateOfWeek! {
                result = false
            }
            return result
        case .monthly:
            return (month > restrictedMonth) || (year > restrictedYear)
        case .threeMonths:
            guard let datePriorFromThreeMonth = Date.currentCalendar.date(byAdding: .month, value: -3, to: date) else {
                return true
            }
            let result = datePriorFromThreeMonth >= customDate
            return result
        case .sixMonths:
            guard let datePriorFromThreeMonth = Date.currentCalendar.date(byAdding: .month, value: -6, to: date) else {
                return true
            }
            let result = datePriorFromThreeMonth >= customDate
            return result
        }
    }
}

//struct FrequencyView_Previews: PreviewProvider {
//    static var previews: some View {
//        FrequencyView()
//    }
//}
