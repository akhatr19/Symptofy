//
//  NoDataViewModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/20/23.
//

import Foundation

final class NoDataViewModel: ObservableObject {
    
    func getNoDataContent(_ noDataScreenType: ScreenType) -> String {
        if noDataScreenType == .medications {
            return MedicationsLocalizedStrings.NoData.noMedications
        } else if noDataScreenType == .symptoms {
            return SymptomsLocalizedStrings.NoData.noSymptoms
        } else {
            return DietaryLocalizedStrings.NoData.noDietaryItems
        }
    }
    
    func getButtonText(_ noDataScreenType: ScreenType) -> String {
        if noDataScreenType == .medications {
            return MedicationsLocalizedStrings.AddMedication.addMedication
        } else if noDataScreenType == .symptoms {
            return SymptomsLocalizedStrings.AddSymptoms.addSymptoms
        } else {
            return DietaryLocalizedStrings.AddDietary.addDietary
        }
    }
}
