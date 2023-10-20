//
//  DosageVSSymptomChartModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 10/14/23.
//

import Foundation


//MARK: Prepare data for Dosage vs Symptom Chart
struct DosageVSSymptomChartData: Codable {
    let dosageVSsymptomGraph: [DosageVSsymptomGraph]
}

struct DosageVSsymptomGraph: Codable {
    let medicationName: String
    let graphData: [DosageVSsymptomGraphDatum]
}

struct DosageVSsymptomGraphDatum: Codable {
    let symptom: String
    let value: Int
}

//MARK: Dosage vs Symptom Chart Display Data
struct DosageVSSymptomChartDisplayData: Identifiable {
    let id = UUID()
    let symptom: String
    let value: Int

    init(month: String, value: Int) {
        self.symptom = month
        self.value = value
    }
}
