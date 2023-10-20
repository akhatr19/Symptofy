//
//  TemperatureVSSymptomChartViewModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 10/14/23.
//


import Foundation

class TemperatureVSSymptomChartViewModel: ObservableObject {

    fileprivate func prepareDataForGraph(_ fromDate: Date, toDate: Date) -> [TempVSsymptomGraph] {
        var prepareData = [TempVSsymptomGraph]()
        let availabelSymptoms = DosageVSSymptomSummaryViewModel().getAvailableSymptomsForFrequency(fromDate, toDate: toDate)
        for symp in availabelSymptoms {
            for symptom in symp.symptoms {
                let data = TempVSsymptomGraph(temp: "\(symp.temperature)ºF",
                                              symptom: symptom.symptomName,
                                              value: symptom.symptomSeverity)
                prepareData.append(data)
            }
        }
        let sortedData = prepareData.sorted(by: { $0.temp < $1.temp })
        return sortedData
    }

    func getDisplayData(_ fromDate: Date, toDate: Date) -> [(symptomName: String, data: [TempVSSymptomChartDisplayData])] {
        let graphData = prepareDataForGraph(fromDate, toDate: toDate)
        var returnData = [(symptomName: String, data: [TempVSSymptomChartDisplayData])]()
        for info in graphData {
            var infoData = [TempVSSymptomChartDisplayData]()
            let insightDataInsightData = TempVSSymptomChartDisplayData(temp: info.temp, value: info.value)
            infoData.append(insightDataInsightData)
            returnData.append((info.symptom, infoData))
        }
        return returnData
    }
}
