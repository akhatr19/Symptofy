//
//  ConfirmationViewModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/28/23.
//

import Foundation
import RealmSwift

final class ConfirmationViewModel: ObservableObject {
    
    func getConfirmationData(_ noDataScreenType: ScreenType) -> (title: String, description: String, information: String) {
        if noDataScreenType == .medications {
            @ObservedResults(AddMedication.self) var addMedicationLists
            let recentlyAddedMed = addMedicationLists.last
            let title = MedicationsLocalizedStrings.Confirmation.medicationAddSuccess
            var description = ""
            var information = MedicationsLocalizedStrings.Confirmation.informationOne
            
            if let recentMed = recentlyAddedMed {
                description = "\(recentMed.medicationName) - \(recentMed.medicactionDosage)"
            }
            
            if let medFrequency = recentlyAddedMed?.medicationFrequency {
                var slotsInt = [Int]()
                for slot in medFrequency {
                    slotsInt.append(slot.medicationTime)
                }
                
                information += MedicationsSummaryViewModel().getMedicationsTimeFromFrequencyArray(slotsInt.sorted())
                information += MedicationsLocalizedStrings.Confirmation.informationTwo
            }
            
            if let startDate = recentlyAddedMed?.startDate {
                let startDate = startDate.displayDateInUserFormat()
                information += startDate
                information += " - "
            }
            
            if let endDate = recentlyAddedMed?.endDate {
                let endDate = endDate.displayDateInUserFormat()
                information += endDate
            } else {
                information += MedicationsLocalizedStrings.Confirmation.noEndDate
            }

            return (title, description, information)
        } else if noDataScreenType == .symptoms {
            @ObservedResults(AddSymptoms.self) var addSymptomsList
            let recentlyAddedSymptom = addSymptomsList.last
            let title = SymptomsLocalizedStrings.Confirmation.symptomAddSuccess
            var description = ""
            var information = SymptomsLocalizedStrings.Confirmation.informationOne

            if let recentSymptoms = recentlyAddedSymptom?.symptoms {
                var symptomNames = [String]()
                for symptom in recentSymptoms {
                    symptomNames.append(symptom.symptomName)
                }
                description = symptomNames.joined(separator: ", ")
            }
            
            if let recentSymptomOccurredDate = recentlyAddedSymptom?.symptomOccurredDate {
                information += getTimeStringFrom(dateString: recentSymptomOccurredDate)
                information += SymptomsLocalizedStrings.Confirmation.informationTwo
                information += recentSymptomOccurredDate.getDateFromString(DateFormats.yyyy_MM_dd_HH_mm_ss)?.getDateStringForFormat(DateFormats.yyyy_MM_dd, timezone: nil)?.displayDateInUserFormat() ?? ""
            }
            return (title, description, information)
        } else {
            @ObservedResults(AddDietary.self) var addDietaryLists
            let recentlyAddedDietary = addDietaryLists.last
            let title = DietaryLocalizedStrings.Confirmation.dietaryAddSuccess
            var description = ""
            var information = DietaryLocalizedStrings.Confirmation.informationOne

            if let recentDietary = addDietaryLists.last {
                description = recentDietary.foodItemName
            }

            if let consumedTime = recentlyAddedDietary?.foodItemConsumedTime {
                information += consumedTime.getDisplayTime()
            }
            
            if let consumedDate = recentlyAddedDietary?.foodItemConsumedDate {
                information += DietaryLocalizedStrings.Confirmation.informationTwo
                information += consumedDate.displayDateInUserFormat()
            }
            return (title, description, information)
        }
    }
    
    func getTimeStringFrom(dateString: String) -> String {
        (dateString.getDateFromString(DateFormats.yyyy_MM_dd_HH_mm_ss)?.getDateStringForFormat(DateFormats.hh_mm_aa, timezone: nil))!
    }
}
