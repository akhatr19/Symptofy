//
//  TemperatureVSSymptomChartView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 10/13/23.
//

import Foundation

import SwiftUI
import Charts

struct TemperatureVSSymptomChartView: View {

    @State private var data = [(symptomName: String, data: [TempVSSymptomChartDisplayData])]()
    @State var fromDate: Date
    @State var toDate: Date
    @ObservedObject var vm = TemperatureVSSymptomChartViewModel()

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
            ScrollView(.horizontal) {
                Chart(data, id: \.symptomName) { steps in
                    ForEach(steps.data) {
                        LineMark(
                            x: .value("Temperature", $0.temperature),
                            y: .value("Severity", $0.value)
                        )
                        .foregroundStyle(by: .value("Symptom name", steps.symptomName))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(minWidth: 20 * CGFloat(data.count))
                .padding()
            }
        }
        .navigationTitle("Temp vs Symptoms Chart")
        .onAppear {
            data = vm.getDisplayData(fromDate, toDate: toDate)
        }
    }
}

//struct TemperatureVSSymptomView_Previews: PreviewProvider {
//    static var previews: some View {
//        TemperatureVSSymptomChartView()
//    }
//}
