//
//  TemperatureVSSymptomChartModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 10/14/23.
//

import Foundation

//MARK: Prepare data for Food vs Symptom Chart
struct FoodVSSymptomChartData: Codable {
    let dosageVSsymptomGraph: [FoodVSsymptomGraph]
}

struct FoodVSsymptomGraph: Codable {
    let dietaryName: String
    let graphData: [FoodVSSymptomGraphDatum]
}

struct FoodVSSymptomGraphDatum: Codable {
    let symptom: String
    let value: Int
}


//MARK: Dosage vs Symptom Chart Display Data
struct FoodVSSymptomChartDisplayData: Identifiable {
    let id = UUID()
    let symptom: String
    let value: Int

    init(month: String, value: Int) {
        self.symptom = month
        self.value = value
    }
}
