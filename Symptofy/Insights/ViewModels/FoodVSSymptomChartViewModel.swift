//
//  FoodVSSymptomChartViewModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 10/14/23.
//

import Foundation
import RealmSwift

struct FoodVSSymptomPrepareData {
    let dietaryName: String?
    let symptomArr: [SymptomDataModel]?
}

class FoodVSSymptomChartViewModel: ObservableObject {

    fileprivate func prepareDataForGraph(_ fromDate: Date, toDate: Date) -> [FoodVSsymptomGraph] {
        var displayData = [FoodVSsymptomGraph]()
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
            let dietary = addSymptomArr.compactMap { $0.currentDietary }
            if let dietaryID = dietary.first {
                let foodItemName = DietarySummaryViewModel().getDietaryNameForSymptomChart(dietary.first!)
                return FoodVSSymptomPrepareData(dietaryName: foodItemName, symptomArr: symptomArr)
            }
            return FoodVSSymptomPrepareData(dietaryName: nil, symptomArr: symptomArr)
        }

        let finalSort = Dictionary(grouping: map, by: { $0.dietaryName })
        for key in finalSort.keys {
            var symptomArrr = [SymptomDataModel]()
            for model in finalSort[key]! {
                symptomArrr.append(contentsOf: model.symptomArr!)
            }

            let dic = Dictionary(grouping: symptomArrr) { $0.symptomsID }
            var graphData = [FoodVSSymptomGraphDatum]()

            for key in dic.keys {
                if let models = dic[key], models.count > 0 {
                    let severity = models.compactMap{ $0.symptomSeverity }.reduce(0, +)/models.count
                    let localGraphData = FoodVSSymptomGraphDatum(symptom: models.first!.symptomName,
                                                                   value: severity)
                    graphData.append(localGraphData)
                }
            }
            graphData.sort { $0.symptom < $1.symptom }

            if key != nil {
                let data = FoodVSsymptomGraph(dietaryName: key!, graphData: graphData)
                displayData.append(data)
            }
        }
        return displayData
    }

    func getDisplayData(_ fromDate: Date, toDate: Date) -> [(medName: String, data: [FoodVSSymptomChartDisplayData])] {
        let graphData = prepareDataForGraph(fromDate, toDate: toDate)
        var returnData = [(medName: String, data: [FoodVSSymptomChartDisplayData])]()
        for info in graphData {
            var infoData = [FoodVSSymptomChartDisplayData]()
            for data in info.graphData {
                let insightDataInsightData = FoodVSSymptomChartDisplayData(month: data.symptom, value: data.value)
                infoData.append(insightDataInsightData)
            }
            returnData.append((info.dietaryName, infoData))
        }
        return returnData
    }
}
