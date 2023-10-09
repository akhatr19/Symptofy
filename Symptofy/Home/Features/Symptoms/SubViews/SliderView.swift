//
//  SliderView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/29/23.
//

import SwiftUI

struct SliderView: View {
    
    @Binding var value: Double
    var completion: (_ changed: Bool) -> Void
    
    var body: some View {
        VStack {
            Text("\(SymptomsLocalizedStrings.SymptomsSummary.severity) \(Int(ceil(value)))")
                .customText(isInformation: true)

            Slider(value: $value, in: 0...10, onEditingChanged: { changed in
                completion(changed)
            }, minimumValueLabel: Text("0"), maximumValueLabel: Text("10")) {
                Text("\(SymptomsLocalizedStrings.AddSymptoms.severityIsLabel) \(value, specifier: "%.f")")
            }
        }
    }
}
