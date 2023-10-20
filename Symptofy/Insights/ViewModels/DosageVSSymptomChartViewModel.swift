//
//  DosageVSSymptomChartViewModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 10/14/23.
//

import Foundation
import RealmSwift

struct DosageVSSymptomPrepareData {
    let medicationName: String?
    let symptomArr: [SymptomDataModel]?
}

class DosageVSSymptomChartViewModel: ObservableObject {

    fileprivate func prepareDataForGraph(_ fromDate: Date, toDate: Date) -> [DosageVSsymptomGraph] {
        var displayData = [DosageVSsymptomGraph]()
        let availabelSymptoms = DosageVSSymptomSummaryViewModel().getAvailableSymptomsForFrequency(fromDate, toDate: toDate)
        let grouping = Dictionary(grouping: availabelSymptoms) { $0.symptomOccurredDate.getDateFromString(DateFormats.yyyy_MM_dd_HH_mm_ss)!.getDateStringForFormat(DateFormats.yyyy_MM_dd, timezone: nil)! }
        let map = grouping.map { date, addSymptomArr in
         let symptoms = addSymptomArr.flatMap { $0.symptoms }
            let dic = Dictionary(grouping: symptoms) { $0.symptomsID }
            var symptomArr = [SymptomDataModel]()
            for key in dic.keys {
                if let models = dic[key], models.count > 0 {
                    let symptom = SymptomDataModel()
                    symptom.symptomsID = key
                    symptom.symptomName = models.first!.symptomName
                    symptom.symptomSeverity = models.compactMap{ $0.symptomSeverity }.reduce(0, +)/models.count
                    symptom.symptomOccurredDate = models.first!.symptomOccurredDate
                    symptomArr.append(symptom)
                }
            }
            let meds = addSymptomArr.flatMap { $0.currentMedications }
            let ids = List<ObjectId>()
            for med in meds {
                ids.append(med)
            }
            let medicationName = MedicationsSummaryViewModel().getMedicationNameForSymptomSummary(ids)
            return DosageVSSymptomPrepareData(medicationName: medicationName, symptomArr: symptomArr)
        }

        let finalSort = Dictionary(grouping: map, by: { $0.medicationName })
        for key in finalSort.keys {
            if key == nil || key!.isEmpty {
                continue
            }
            var symptomArrr = [SymptomDataModel]()
            for model in finalSort[key]! {
                symptomArrr.append(contentsOf: model.symptomArr!)
            }

            let dic = Dictionary(grouping: symptomArrr) { $0.symptomsID }
            var graphData = [DosageVSsymptomGraphDatum]()

            for key in dic.keys {
                if let models = dic[key], models.count > 0 {
                    let severity = models.compactMap{ $0.symptomSeverity }.reduce(0, +)/models.count
                    let localGraphData = DosageVSsymptomGraphDatum(symptom: models.first!.symptomName,
                                                                   value: severity)
                    graphData.append(localGraphData)
                }
            }
            graphData.sort { $0.symptom < $1.symptom }
            let data = DosageVSsymptomGraph(medicationName: key!, graphData: graphData)
            displayData.append(data)
        }
        return displayData
    }

    func getDisplayData(_ fromDate: Date, toDate: Date) -> [(medName: String, data: [DosageVSSymptomChartDisplayData])] {
        let graphData = prepareDataForGraph(fromDate, toDate: toDate)
        var returnData = [(medName: String, data: [DosageVSSymptomChartDisplayData])]()
        for info in graphData {
            var infoData = [DosageVSSymptomChartDisplayData]()
            for data in info.graphData {
                let insightDataInsightData = DosageVSSymptomChartDisplayData(month: data.symptom, value: data.value)
                infoData.append(insightDataInsightData)
            }
            returnData.append((info.medicationName, infoData))
        }
        return returnData
    }
}
