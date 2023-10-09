//
//  EndDateSelection.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/31/23.
//

import SwiftUI

struct TimingSlotSection: View {
    @Binding var list: [Date]
    @State var startDate = Date()

    func getBinding(forIndex index: Int) -> Binding<Date> {
        return Binding<Date>(get: { list[index] },
                               set: { list[index] = $0 })
    }
    
    var body: some View {
        ForEach(0..<list.count, id: \.self) { index in
            NewTimeAdded(startDate: getBinding(forIndex: index)) {
                self.list.remove(at: index)
            }
        }
        AddAnotherTimeOption {
            self.list.append(Date())
        }
    }
}

fileprivate struct NewTimeAdded: View {
    
    @Binding var startDate: Date
    var removeAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: removeAction) {
                Image(systemName: CommonImageStrings.minus)
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
            DatePicker(MedicationsLocalizedStrings.AddMedication.time, selection: $startDate, displayedComponents: .hourAndMinute)
                .customText(isInformation: true)
        }
    }
}

fileprivate struct AddAnotherTimeOption: View {
    var addAction: () -> Void
    
    var body: some View {
        Button(action: addAction) {
            HStack {
                Image(systemName: CommonImageStrings.plus)
                    .foregroundColor(Color.buttonBackgroundColor)
                Text(MedicationsLocalizedStrings.AddMedication.addAnotherTime)
                    .customText(isInformation: true)
                Spacer()
                Text(MedicationsLocalizedStrings.AddMedication.selectTime)
                    .foregroundColor(Color(.placeholderText))
            }
        }
        .buttonStyle(.plain)
    }
}
