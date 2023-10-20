//
//  TimeVSSymptomChartView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 10/13/23.
//

import SwiftUI
import Charts

struct TimeVSSymptomChartView: View {

    @State private var data = [(medName: String, data: [TimeVSSymptomChartDisplayData])]()
    @State var fromDate: Date
    @State var toDate: Date
    @ObservedObject var vm = TimeVSSymptomChartViewModel()

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
                Chart(data, id: \.medName) { steps in
                    ForEach(steps.data) {
                        LineMark(
                            x: .value("Symptom", $0.time),
                            y: .value("Severity", $0.value)
                        )
                        .foregroundStyle(by: .value("Medication name", steps.medName))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(minWidth: 30 * CGFloat(data.count))
                .padding()
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Time vs Symptoms Chart")
        .onAppear {
            data = vm.getDisplayData(fromDate, toDate: toDate)
        }
    }
}

//struct TimeVSSymptomView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeVSSymptomChartView()
//    }
//}
