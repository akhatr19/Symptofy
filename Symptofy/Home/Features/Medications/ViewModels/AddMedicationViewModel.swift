//
//  AddMedicationViewModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/2/23.
//

import Foundation
import RealmSwift

final class AddMedicationViewModel: ObservableObject {
    
    @Published var medicationName = ""
    @Published var dosageValue = ""
    
    @Published var startDateValue = Date()
    @Published var initialTimeSlot = Date()
    @Published var timeSlots = [Date]()
    
    @Published var endDateValue = Date()
    @Published var endDateSet = false
    
    @Published var navigationDestination = false
    
    @ObservedResults(AddMedication.self) var addMedicationLists

    var formIsValid: Bool {
        !medicationName.isEmpty &&
        !dosageValue.isEmpty
    }

    func addMedication() {
        let addMed = AddMedication()
        let timeInMin = getRequiredData()

        for slot in timeInMin {
            let slots = MedicationFrequencyItems()
            slots.medicationTime = slot
            addMed.medicationFrequency.append(slots)
        }
        addMed.medicationAddedDate = Date().getRecordAddedFormat()
        addMed.medicationName = medicationName
        addMed.medicactionDosage = dosageValue
        addMed.startDate = startDateValue.getDateInStoreFormat()!
        if endDateSet {
            addMed.endDate = endDateValue.getDateInStoreFormat()!
        }
        print(addMed)
        $addMedicationLists.append(addMed)
        navigationDestination = true
    }

    fileprivate func getRequiredData() -> [Int] {
        timeSlots.append(initialTimeSlot)
        var timeInMin = [Int]()
        for slot in timeSlots {
            timeInMin.append(slot.getTimeInMinutes())
        }
        return timeInMin
    }
    
    func loadMedicationNames() -> [String] {
        var names = [String]()
        for med in addMedicationLists { names.append(med.medicationName) }
        let filterData = names.filter({ $0.localizedCaseInsensitiveContains(medicationName) })
        return filterData.removingDuplicates()
    }
}
