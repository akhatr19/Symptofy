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
        ZStack {
            if isSelected {
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 40)
                    .foregroundColor(color)
                
                Text(text)
                    .foregroundColor(.buttonTextColor)
                    .font(.headline)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.buttonBackgroundColor, lineWidth: 1)
                    .frame(height: 40)
                
                if text == MedicationsLocalizedStrings.MedicationSummary.skip {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.red, lineWidth: 1)
                        .frame(height: 40)

                    Text(text)
                        .foregroundColor(.red)
                        .font(.headline)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.buttonBackgroundColor, lineWidth: 1)
                        .frame(height: 40)

                    Text(text)
                        .foregroundColor(.buttonBackgroundColor)
                        .font(.headline)
                }
            }
        }
    }
}
