//
//  TimeVSSymptomChartViewModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 10/14/23.
//

import Foundation

class TimeVSSymptomChartViewModel: ObservableObject {

    fileprivate func prepareDataForGraph(_ fromDate: Date, toDate: Date) -> [TimeVSsymptomGraph] {
        var prepareData = [TimeVSsymptomGraph]()
        let availabelSymptoms = DosageVSSymptomSummaryViewModel().getAvailableSymptomsForFrequency(fromDate, toDate: toDate)
        for symp in availabelSymptoms {
            for symptom in symp.symptoms {
                let data = TimeVSsymptomGraph(time: "\(getTimeStringFrom(dateString: symptom.symptomOccurredDate))",
                                              symptom: symptom.symptomName,
                                              value: symptom.symptomSeverity)
                prepareData.append(data)
            }
        }
        let sortedData = prepareData.sorted(by: { $0.time < $1.time })
        return sortedData
    }

    func getDisplayData(_ fromDate: Date, toDate: Date) -> [(medName: String, data: [TimeVSSymptomChartDisplayData])] {
        let graphData = prepareDataForGraph(fromDate, toDate: toDate)
        var returnData = [(medName: String, data: [TimeVSSymptomChartDisplayData])]()
        for info in graphData {
            var infoData = [TimeVSSymptomChartDisplayData]()
            let insightDataInsightData = TimeVSSymptomChartDisplayData(time: info.time, value: info.value)
            infoData.append(insightDataInsightData)
            returnData.append((info.symptom, infoData))
        }
        return returnData
    }
}

extension TimeVSSymptomChartViewModel {
    func getTimeStringFrom(dateString: String) -> String {
        (dateString.getDateFromString(DateFormats.yyyy_MM_dd_HH_mm_ss)?.getDateStringForFormat(DateFormats.HH_mm, timezone: nil))!
    }
}
