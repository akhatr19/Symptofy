//
//  CommonCapsuleBottom.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/20/23.
//

import SwiftUI

struct SelectButton: View {
    
    @Binding var isSelected: Bool
    @State var color: Color
    @Binding var text: String
    
    var body: some View {
        if isSelected {
            Spacer()
            if text == MedicationsLocalizedStrings.MedicationSummary.skipped {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            }
            Spacer()
        } else {
            Spacer()
            if text == MedicationsLocalizedStrings.MedicationSummary.skip {
                Image(systemName: "xmark")
                    .font(.largeTitle)
            } else {
                Image(systemName: "checkmark")
                    .font(.largeTitle)
            }
            Spacer()
        }
    }
}
