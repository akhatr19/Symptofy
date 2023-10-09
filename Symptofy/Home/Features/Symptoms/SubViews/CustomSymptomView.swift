//
//  CustomSymptomView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/29/23.
//

import SwiftUI

struct CustomSymptomView: View {
    @State var symptomName: String = ""
    @State var value: Double = 0.0
    @State var symptomSeverity: Int = 0
    
    var completion: (_ symptomName: String?, _ symptomSeverity: Int?) -> Void
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Spacer()
                Button(CommonLocalizedStrings.ToolBarButton.cancel) {
                    completion(nil, nil)
                }
                .foregroundColor(.buttonBackgroundColor)
            }
            Text(SymptomsLocalizedStrings.AddSymptoms.addCustomSymptom)
                .padding([.top, .horizontal])
                .multilineTextAlignment(.center)
                .customText(isInformation: true)
            Divider()
            VStack(spacing: 10) {
                TextField(SymptomsLocalizedStrings.AddSymptoms.addSymptomName, text: $symptomName)
                    .textFieldStyle(.roundedBorder)
                SliderView(value: $value) { _ in
                   symptomSeverity = Int(ceil(value))
                }
            }
            HStack {
                Button {
                    completion(symptomName, symptomSeverity)
                } label: {
                    Text(CommonLocalizedStrings.ToolBarButton.add)
                        .customButton()
                }
                .padding()
                .disabled(symptomName.trimmingCharacters(in: .whitespaces).count == 0)
                .opacity(symptomName.trimmingCharacters(in: .whitespaces).count == 0 ? 0.5 : 1.0)
            }
            Spacer()
        }
        .padding()
    }
}
