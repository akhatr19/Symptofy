//
//  DosageVSSymptomChartSummaryView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 10/14/23.
//

import SwiftUI

struct DosageVSSymptomSummaryView: View {

    @ObservedObject var vm = DosageVSSymptomSummaryViewModel()
    @State private var data = [String: [DosageVSSymptomSummaryInformation]]()
    @State var fromDate: Date
    @State var toDate: Date

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
            List(Array(data.keys).sorted(by: <), id: \.self) { medName in
                Section {
                    ForEach(0..<(data[medName]?.count ?? 0), id: \.self) { symptom in
                        VStack {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(data[medName]![symptom].symptomName)
                                        .font(.title3)
                                }
                                Spacer()
                                VStack(alignment: .center) {
                                    Text("Severity")
                                    Text(data[medName]![symptom].symptomSeverity)
                                }
                                .padding()
                                .background(Color.buttonBackgroundColor.opacity(0.2))
                            }
                        }
                    }
                } header: {
                    Text(medName)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Dosage vs Symptoms Summary")
        .onAppear {
            data = vm.getDisplayData(fromDate, toDate: toDate)
        }
    }
}

//struct InsightsSummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        DosageVSSymptomSummaryView()
//    }
//}
