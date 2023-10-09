//
//  CustomCalendarView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/30/23.
//

import UIKit
import JTAppleCalendar

protocol CustomCalendarViewDelegate: AnyObject {
    func onDateClicked(selectedDate: Date)
    func isMedAvailableForDate(date: Date) -> Bool
}

class CustomCalendarView: UIView {
    
    var isWeekSelected = true
    var minimumDate: Date?
    var selectedDate = Date()
    weak var customCalendarViewDelegate: CustomCalendarViewDelegate?

    lazy var separatorView: CommonSeperatorView = {
        return CommonSeperatorView()
    }()

    lazy var sundayLabel: CommonLabel = {
        let label = CommonLabel()
        label.text = "S"
        label.isHeading1 = true
        return label
    }()

    lazy var mondayLabel: CommonLabel = {
        let label = CommonLabel()
        label.text = "M"
        label.isHeading1 = true
        return label
    }()

    lazy var tuesdayLabel: CommonLabel = {
        let label = CommonLabel()
        label.text = "T"
        label.isHeading1 = true
        return label
    }()

    lazy var wednesdayLabel: CommonLabel = {
        let label = CommonLabel()
        label.text = "W"
        label.isHeading1 = true
        return label
    }()

    lazy var thursdayLabel: CommonLabel = {
        let label = CommonLabel()
        label.text = "T"
        label.isHeading1 = true
        return label
    }()

    lazy var fridayLabel: CommonLabel = {
        let label = CommonLabel()
        label.text = "F"
        label.isHeading1 = true
        return label
    }()
    
    lazy var saturdayLabel: CommonLabel = {
        let label = CommonLabel()
        label.text = "S"
        label.isHeading1 = true
        return label
    }()

    lazy var weekStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sundayLabel, mondayLabel, tuesdayLabel, wednesdayLabel, thursdayLabel, fridayLabel, saturdayLabel])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var weekView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var weekBottomSeparator: CommonSeperatorView = {
        return CommonSeperatorView()
    }()

    lazy var calendar: JTACMonthView = {
        let view = JTACMonthView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var selectedDateDisplayString: CommonLabel = {
        let label = CommonLabel()
        label.isHeading2 = true
        return label
    }()

    lazy var bottomView: CommonSeperatorView = {
        return CommonSeperatorView()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .oneBackgroundColor
        weekView.addSubview(weekStackView)
        addSubview(weekView)
        addSubview(weekBottomSeparator)
        addSubview(calendar)
        addSubview(selectedDateDisplayString)
        addSubview(bottomView)
        commonInit()
        setUpAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) has not been implemented")
    }

    private func setUpAutoLayout() {
        NSLayoutConstraint.activate([
            weekView.leftAnchor.constraint(equalTo: leftAnchor),
            weekView.rightAnchor.constraint(equalTo: rightAnchor),
            weekView.topAnchor.constraint(equalTo: topAnchor),
            weekView.heightAnchor.constraint(equalToConstant: 30),
            
            weekStackView.leftAnchor.constraint(equalTo: weekView.leftAnchor),
            weekStackView.rightAnchor.constraint(equalTo: weekView.rightAnchor),
            weekStackView.topAnchor.constraint(equalTo: weekView.topAnchor),
            weekStackView.bottomAnchor.constraint(equalTo: weekView.bottomAnchor),

            weekBottomSeparator.leftAnchor.constraint(equalTo: leftAnchor),
            weekBottomSeparator.rightAnchor.constraint(equalTo: rightAnchor),
            weekBottomSeparator.topAnchor.constraint(equalTo: weekView.bottomAnchor),
            weekBottomSeparator.heightAnchor.constraint(equalToConstant: 0.5),

            calendar.leftAnchor.constraint(equalTo: leftAnchor),
            calendar.rightAnchor.constraint(equalTo: rightAnchor),
            calendar.topAnchor.constraint(equalTo: weekBottomSeparator.bottomAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 350),

            selectedDateDisplayString.leftAnchor.constraint(equalTo: leftAnchor),
            selectedDateDisplayString.rightAnchor.constraint(equalTo: rightAnchor),
            selectedDateDisplayString.topAnchor.constraint(equalTo: calendar.bottomAnchor),
            selectedDateDisplayString.heightAnchor.constraint(equalToConstant: 30),
            
            bottomView.leftAnchor.constraint(equalTo: leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: rightAnchor),
            bottomView.topAnchor.constraint(equalTo: selectedDateDisplayString.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 0.5),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1)
        ])
    }
}

extension CustomCalendarView {
    private func commonInit() {
        calendar.register(CustomCalendarViewDateCell.self, forCellWithReuseIdentifier: CustomCalendarViewDateCell.reuseID)
        calendar.register(CustomCalendarViewDateHeader.self, forSupplementaryViewOfKind: "CustomCalendarDateHeader",
                          withReuseIdentifier: CustomCalendarViewDateHeader.reuseID)
    }

    func setupCalendar(_ delegate: CustomCalendarViewDelegate, minimumDate: Date?) {
        calendar.ibCalendarDelegate = self
        calendar.ibCalendarDataSource = self
        self.customCalendarViewDelegate = delegate
        self.minimumDate = minimumDate
        calendar.allowsMultipleSelection = false
        calendar.selectDates([Date()])
        calendar.scrollingMode = .stopAtEachCalendarFrame
        calendar.showsHorizontalScrollIndicator = false
        calendar.showsVerticalScrollIndicator = false
        selectedDateDisplayString.text = selectedDate.getDateStringForFormat(DateFormats.EEEE_MMMM_d_yyyy, timezone: nil)
    }
    
    func loadCalendarForWeeekView(_ isWeekSelected: Bool) {
        self.isWeekSelected = isWeekSelected
        weekBottomSeparator.isHidden = true
        calendar.scrollDirection = .horizontal
        calendar.heightAnchor.constraint(equalToConstant: 55).isActive = true

        UIView.animate(withDuration: 0, animations: {
            self.layoutIfNeeded()
        }) { _ in
            self.calendar.reloadData(withAnchor: self.selectedDate)
        }
    }
    
    func loadCalendarForMonthView(_ isWeekSelected: Bool) {
        self.isWeekSelected = isWeekSelected
        weekBottomSeparator.isHidden = false
        calendar.scrollDirection = .vertical
        calendar.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        UIView.animate(withDuration: 0, animations: {
            self.layoutIfNeeded()
        }) { _ in
            self.calendar.reloadData(withAnchor: self.selectedDate, completionHandler: {
                self.calendar.scrollToDate(self.selectedDate)
            })
        }
    }
}

extension CustomCalendarView: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let startDate = Date().getDateByAddingMonths(-12)
        let endDate = Date().getDateByAddingMonths(3)
        if isWeekSelected {
            return ConfigurationParameters(startDate: startDate,
                                           endDate: endDate,
                                           numberOfRows: 1,
                                           generateInDates: .forFirstMonthOnly,
                                           generateOutDates: .off,
                                           hasStrictBoundaries: false)
        } else {
            return ConfigurationParameters(startDate: startDate,
                                           endDate: endDate,
                                           numberOfRows: 6,
                                           generateInDates: .forAllMonths,
                                           generateOutDates: .tillEndOfGrid)
        }
    }

    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        if minimumDate == nil { return true }
        return date.compare(minimumDate!) == .orderedAscending || date.compare(minimumDate!) == .orderedSame
    }

    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let dateCell = cell as? CustomCalendarViewDateCell  else { return }
        handleSelection(cell: dateCell, cellState: cellState)
        self.selectedDate = date
        selectedDateDisplayString.text = selectedDate.getDateStringForFormat(DateFormats.EEEE_MMMM_d_yyyy, timezone: nil)
        customCalendarViewDelegate?.onDateClicked(selectedDate: date)
    }

    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let dateCell = cell as? CustomCalendarViewDateCell  else { return }
        handleSelection(cell: dateCell, cellState: cellState)
    }
}

extension CustomCalendarView: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let dateCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CustomCalendarViewDateCell.reuseID, for: indexPath) as! CustomCalendarViewDateCell
        self.calendar(calendar, willDisplay: dateCell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return dateCell
    }

    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState, date: date)
    }

    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let headerCell = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: CustomCalendarViewDateHeader.reuseID, for: indexPath) as! CustomCalendarViewDateHeader
        headerCell.monthTitle.text = range.start.getDateStringForFormat(DateFormats.MMMM_yyyy, timezone: nil)
        return headerCell
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        if isWeekSelected {
            return MonthSize(defaultSize: 0)
        }
        return MonthSize(defaultSize: 20)
    }
}

extension CustomCalendarView {
    func configureCell(view: JTACDayCell?, cellState: CellState, date: Date) {
        guard let dateCell = view as? CustomCalendarViewDateCell  else { return }
        dateCell.dateLabel.text = cellState.text
        if cellState.dateBelongsTo == .thisMonth {
            dateCell.parentView.isHidden = false
        } else {
            dateCell.parentView.isHidden = true
        }
        if isWeekSelected {
            dateCell.separatorView.isHidden = true
        } else {
            dateCell.separatorView.isHidden = false
        }
        dateCell.eventView.isHidden = !customCalendarViewDelegate!.isMedAvailableForDate(date: date)
        handleSelection(cell: dateCell, cellState: cellState)
    }

    func handleSelection(cell: CustomCalendarViewDateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.isHidden = false
            cell.dateLabel.textColor = .oneBackgroundColor
        } else {
            cell.selectedView.isHidden = true
            cell.dateLabel.textColor = .normalTextColor
        }
    }
}
