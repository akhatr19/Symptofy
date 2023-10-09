//
//  OptionalDatePickerField.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/2/23.
//

import SwiftUI

struct OptionalDatePickerField: View {
    
    @Binding var date: Date
    @Binding var dateSet: Bool
    @Binding var minimumDate: Date

    var body: some View {
        if dateSet {
            HStack {
                DatePicker(MedicationsLocalizedStrings.AddMedication.endDate, selection: self.$date, in: minimumDate..., displayedComponents: .date)
                Button(action: {
                    dateSet.toggle()
                }) {
                    Image(systemName: CommonImageStrings.close)
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(Color(.systemGray2))
                }
                .buttonStyle(.plain)
            }
        } else {
            Button {
                dateSet.toggle()
            } label: {
                HStack {
                    Text(MedicationsLocalizedStrings.AddMedication.endDate)
                    Spacer()
                    Text(MedicationsLocalizedStrings.AddMedication.optional)
                        .foregroundColor(Color(.placeholderText))
                }
            }
            .buttonStyle(.plain)
        }
    }
}
