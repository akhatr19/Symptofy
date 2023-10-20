//
//  TimeVSSymptomChartModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 10/14/23.
//

import Foundation

//MARK: Prepare data for Time vs Symptom Chart
struct TimeVSSymptomChartData: Codable {
    let timeVSsymptomGraph: [TimeVSsymptomGraph]
}

struct TimeVSsymptomGraph: Codable {
    let time: String
    let symptom: String
    let value: Int
}


//MARK: Time vs Symptom Chart Display Data
struct TimeVSSymptomChartDisplayData: Identifiable {
    let id = UUID()
    let time: String
    let value: Int

    init(time: String, value: Int) {
        self.time = time
        self.value = value
    }
}
