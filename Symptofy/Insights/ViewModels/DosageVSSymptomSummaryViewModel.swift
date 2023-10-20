//
//  DosageVSSymptomSummaryViewModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 10/14/23.
//

import Foundation
import RealmSwift

class DosageVSSymptomSummaryViewModel: ObservableObject {

    @ObservedResults(AddSymptoms.self) var addedSymptomData

    func getAvailableSymptomsForFrequency(_ fromDate: Date, toDate: Date) -> [AddSymptoms] {
        var availabelSymptoms = [AddSymptoms]()
        for symptom in addedSymptomData {
            let symptomDate = symptom.symptomOccurredDate.getDateFromString(DateFormats.yyyy_MM_dd_HH_mm_ss)!
            if (symptomDate.compare(fromDate) == .orderedDescending || symptomDate.compare(fromDate) == .orderedSame) &&
                (toDate.timeIntervalSince1970 == 0 || symptomDate.compare(toDate) == .orderedAscending || symptomDate.compare(toDate) == .orderedSame) {
                availabelSymptoms.append(symptom)
            }
        }
        return availabelSymptoms
    }

    func getDisplayData(_ fromDate: Date, toDate: Date) -> [String: [DosageVSSymptomSummaryInformation]]{
        var displayData = [String: [DosageVSSymptomSummaryInformation]]()
        let availabelSymptoms = getAvailableSymptomsForFrequency(fromDate, toDate: toDate)
        for symp in availabelSymptoms {
            let medicationName = MedicationsSummaryViewModel().getMedicationNameForSymptomSummary(symp.currentMedications)
            for symptom in symp.symptoms {
                var timeeDict = displayData[medicationName] ?? [DosageVSSymptomSummaryInformation]()
                let dataData = DosageVSSymptomSummaryInformation(symptomName: symptom.symptomName,
                                                                 symptomSeverity: "\(symptom.symptomSeverity)")
                timeeDict.append(dataData)
                displayData[medicationName] = timeeDict
            }
        }
        return displayData
    }
}
