//
//  CalenderRepresentable.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/30/23.
//

import SwiftUI

struct CalenderRepresentable: UIViewRepresentable {
    
    let calendarView = CustomCalendarView()
    var isExpanded = false
    var onDateSelected: (_ selectedDate: Date) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(view: calendarView, onDateSelected: onDateSelected)
    }

    func makeUIView(context: Context) -> CustomCalendarView {
        return calendarView
    }

    func updateUIView(_ calendar: CustomCalendarView, context: Context) {
        if isExpanded {
            calendar.loadCalendarForMonthView(false)
        } else {
            calendar.loadCalendarForWeeekView(true)
        }
    }

    class Coordinator: NSObject, CustomCalendarViewDelegate {
        var onDateSelect: (_ selectedDate: Date) -> Void

        init(view: CustomCalendarView, onDateSelected: @escaping (Date) -> ()) {
            self.onDateSelect = onDateSelected
            super.init()
            view.setupCalendar(self, minimumDate: nil)
        }

        func isMedAvailableForDate(date: Date) -> Bool {
            return MedicationsSummaryViewModel().isMedicationAvailableForDate(date)
        }

        func onDateClicked(selectedDate: Date) {
            onDateSelect(selectedDate)
        }
    }
}
