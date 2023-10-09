//
//  SymptomSummaryViewModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/29/23.
//

import SwiftUI

struct SymptomSummaryItemView: View {
    
    @State var showSlider = false
    @State var symptom: SymptomDataModel!
    @State var value: Double = 0.0
    var completion: (_ model: SymptomDataModel) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(symptom.symptomName)
                        .font(.title3)

                    if !showSlider && value > 0 {
                        Text("\(SymptomsLocalizedStrings.AddSymptoms.severityValue) \(Int(ceil(value)))")
                            .font(.callout)
                            .foregroundColor(.informationTextColor)
                    }
                }
                Spacer()
                if value > 0 {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.buttonBackgroundColor)
                }
            }
            if showSlider {
                SliderView(value: $value) { _ in
                    symptom.symptomSeverity = Int(ceil(value))
                    completion(symptom)
                }
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 5)
        .contentShape(Rectangle())
        .onTapGesture {
            showSlider.toggle()
        }
    }
}
