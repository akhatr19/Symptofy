//
//  DosageVSSymptomChartView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 10/14/23.
//

import SwiftUI
import Charts

struct DosageVSSymptomChartView: View {

    @State private var data = [(medName: String, data: [DosageVSSymptomChartDisplayData])]()
    @State var fromDate: Date
    @State var toDate: Date
    @ObservedObject var vm = DosageVSSymptomChartViewModel()

    var body: some View {
        VStack {
            if fromDate.startOfDay == toDate.startOfDay {
                Text("Displaying data for \(fromDate.getDateStringForFormat(DateFormats.MMM_dd_yyyy, timezone: nil)!)")
                    .customText(isInformation: true)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
            } else {
                Text("Displaying data for \(fromDate.getDateStringForFormat(DateFormats.MMM_dd_yyyy, timezone: nil)!) - \(toDate.getDateStringForFormat(DateFormats.MMM_dd_yyyy, timezone: nil)!)")
                    .customText(isInformation: true)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
            }

            Chart(data, id:\.medName) { steps in
                ForEach(steps.data) { step in
                    BarMark (
                        x: .value("Severity", step.value),
                        y: .value("Symptom", step.symptom)
                    )
                    .foregroundStyle(by: .value("Medication name", steps.medName))
                    .position(by: .value("Medication name", steps.medName))
                    .annotation(position: .overlay, alignment: .trailingLastTextBaseline, spacing: 5) {
                        Text("\(step.value)")
                            .font(.title3)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Dosage vs Symptoms Chart")
        .onAppear {
            data = vm.getDisplayData(fromDate, toDate: toDate)
        }
    }
}

//struct DosageVSSymptomView_Previews: PreviewProvider {
//    static var previews: some View {
//        DosageVSSymptomChartView()
//    }
//}
