//
//  MedicationsSummaryViewModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/3/23.
//

import Foundation
import RealmSwift

class MedicationsSummaryViewModel: ObservableObject {

    @Published private(set) var medicationData = [Int: [MedicationDisplay]]()
    @ObservedResults(MedicationRecordModel.self) var medicationRecords

    func getDataForDate(_ date: Date) {
        medicationData = getMedicationsDisplaySections(date)
    }

    fileprivate func getAllMedications() -> [AddMedication] {
        let realm = RealmDatabase.sharedInstance().getRealmDB()
        let result = realm.objects(AddMedication.self)
        var medicationData = [AddMedication]()
        result.forEach { med in
            medicationData.append(med)
        }
        return medicationData
    }

    fileprivate func getMedicationsDisplaySections(_ date: Date) -> [Int: [MedicationDisplay]] {
        var medDisplayData = [Int: [MedicationDisplay]]()
        let medList = getAllMedications()
        
        for medication in medList {
            let startDate = medication.startDate.getDateFromString(DateFormats.yyyy_MM_dd)!
            var endDate: Date?
            if medication.endDate != nil {
                endDate = medication.endDate!.getDateFromString(DateFormats.yyyy_MM_dd)
            }
            
            if (date.compare(startDate) == .orderedDescending || date.compare(startDate) == .orderedSame) &&
                (endDate == nil || endDate?.timeIntervalSince1970 == 0 || date.compare(endDate!) == .orderedAscending || date.compare(endDate!) == .orderedSame) {
                for slot in medication.medicationFrequency  {
                    var timeeDict = medDisplayData[slot.medicationTime] ?? [MedicationDisplay]()
                    let isSkippedOr = isSkippedOrTaken(date, slotID: slot.id, medicationTime: slot.medicationTime)
//                    let _ = print("\(medication.medicationName) at \(slot.medicationTime.getDisplayTime()) ==== skipped is\(isSkippedOr.isSkipped) ==== taken is\(isSkippedOr.isTaken)")

                    var dataData = MedicationDisplay()
                    dataData.id = medication.id
                    dataData.medicationName = medication.medicationName
                    dataData.medicactionDosage = medication.medicactionDosage
                    dataData.startDate = medication.startDate
                    dataData.endDate = medication.endDate
                    
                    var slotsData = MedicationSlotData()
                    slotsData.id = slot.id
                    slotsData.statusLoggedDate = slot.statusLoggedDate
                    slotsData.isTaken = isSkippedOr.isTaken
                    slotsData.isSkipped = isSkippedOr.isSkipped
                    
                    dataData.medicationSlot = slotsData
                    
                    timeeDict.append(dataData)
                    medDisplayData[slot.medicationTime] = timeeDict
                }
            }
        }
        return medDisplayData
    }

    func isMedicationAvailableForDate(_ date: Date) -> Bool {
        let medList = getAllMedications()
        for medication in medList {
            let startDate = medication.startDate.getDateFromString(DateFormats.yyyy_MM_dd)!
            var endDate: Date?
            if medication.endDate != nil {
                endDate = medication.endDate!.getDateFromString(DateFormats.yyyy_MM_dd)
            }
            
            if (date.compare(startDate) == .orderedDescending || date.compare(startDate) == .orderedSame) &&
                (endDate == nil || endDate?.timeIntervalSince1970 == 0 || date.compare(endDate!) == .orderedAscending || date.compare(endDate!) == .orderedSame) {
                return true
            }
        }
        return false
    }
    
    func getMedicationsTimeFromFrequencyArray(_ frequency: [Int]) -> String {
        var selectedTime = ""
        for i in 0..<frequency.count {
            if i > 0 {
                selectedTime += ", "
            }
            selectedTime += frequency[i].getDisplayTime()
        }
        return selectedTime
    }
    
    func updateMedicationConsumeStatus(_ medication: MedicationDisplay, date: Date, medicationTime: Int, isTaken: Bool, isSkipped: Bool) {
        let recordMed = MedicationRecordModel()
        let recordMedList = RecordedMedicationList()
        let todayDateWithoutTime = date.getDateInStoreFormat()!
        
        if medicationRecords.count > 0 {
            let availableDataForDate = List<MedicationRecordModel>()
            for med in medicationRecords {
                if med.medicationRecordedDate == todayDateWithoutTime {
                    availableDataForDate.append(med)
                }
            }
            print(availableDataForDate)
            
            if availableDataForDate.count > 0 {
                let availableObjectForTheDate = availableDataForDate[0]
                let searchableExtraID = getExtraIDForMedicationRecord(medication.medicationSlot!.id!, medicationTime: medicationTime)
                let index = availableObjectForTheDate.medicationRecordedList.firstIndex { $0.extraID == searchableExtraID }

                do {
                    let realm = RealmDatabase.sharedInstance().getRealmDB()
                    guard let internalRecordMed = realm.object(ofType: MedicationRecordModel.self,
                                                            forPrimaryKey: availableObjectForTheDate.id) else {
                        return
                    }
                
                    try realm.write {
                        if index != nil {
                            //same day trying to update same medication
                            internalRecordMed.medicationRecordedList[index!].isTaken = isTaken
                            internalRecordMed.medicationRecordedList[index!].isSkipped = isSkipped
                        }
                        else {
                            //same day trying to update different medication
                            recordMedList.extraID = getExtraIDForMedicationRecord(medication.medicationSlot!.id!,
                                                                                  medicationTime: medicationTime)
                            recordMedList.medicationTime = medicationTime
                            recordMedList.statusLoggedDate = Date().getRecordAddedFormat()
                            recordMedList.isTaken = isTaken
                            recordMedList.isSkipped = isSkipped
                            internalRecordMed.medicationRecordedList.append(recordMedList)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                // new day 1st time
                do {
                    let realm = RealmDatabase.sharedInstance().getRealmDB()
                    try realm.write {
                        recordMed.medicationRecordedDate = todayDateWithoutTime
                        
                        recordMedList.extraID = getExtraIDForMedicationRecord(medication.medicationSlot!.id!,
                                                                              medicationTime: medicationTime)
                        recordMedList.medicationTime = medicationTime
                        recordMedList.statusLoggedDate = Date().getRecordAddedFormat()
                        recordMedList.isTaken = isTaken
                        recordMedList.isSkipped = isSkipped
                        recordMed.medicationRecordedList.append(recordMedList)
                        $medicationRecords.append(recordMed)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            //1st time
            recordMed.medicationRecordedDate = todayDateWithoutTime
            
            recordMedList.extraID = getExtraIDForMedicationRecord(medication.medicationSlot!.id!, medicationTime: medicationTime)
            recordMedList.medicationTime = medicationTime
            recordMedList.statusLoggedDate = Date().getRecordAddedFormat()
            recordMedList.isTaken = isTaken
            recordMedList.isSkipped = isSkipped
            recordMed.medicationRecordedList.append(recordMedList)
            $medicationRecords.append(recordMed)
        }
        print(medicationRecords)
    }
    
    fileprivate func getExtraIDForMedicationRecord(_ medicationID: ObjectId, medicationTime: Int) -> String {
        return "\(medicationID)_\(medicationTime)"
    }
    
    fileprivate func isSkippedOrTaken(_ date: Date, slotID: ObjectId, medicationTime: Int) -> (isSkipped: Bool, isTaken: Bool) {
        if medicationRecords.count > 0 {
            let selectedDate = date.getDateStringForFormat(DateFormats.yyyy_MM_dd, timezone: nil)
            let availableDataForDate = List<MedicationRecordModel>()
            for med in medicationRecords {
                if med.medicationRecordedDate == selectedDate {
                    availableDataForDate.append(med)
                }
            }

            if availableDataForDate.count > 0 {
                for medRecordsList in availableDataForDate.first!.medicationRecordedList {
                    let savedExtraID = getExtraIDForMedicationRecord(slotID, medicationTime: medicationTime)
                    if medRecordsList.extraID == savedExtraID {
                        return (medRecordsList.isSkipped ?? false, medRecordsList.isTaken ?? false)
                    }
                }
            }
            return(false, false)
        }
        return(false, false)
    }
}

extension MedicationsSummaryViewModel {
    func getMedicationIdsForSymptom(_ date: Date) -> List<ObjectId> {
        let ids = List<ObjectId>()
        let medications = getAllMedications()
        for medication in medications {
            let startDate = medication.startDate.getDateFromString(DateFormats.yyyy_MM_dd)!
            var endDate: Date?
            if medication.endDate != nil {
                endDate = medication.endDate!.getDateFromString(DateFormats.yyyy_MM_dd)
            }
            
            if (date.compare(startDate) == .orderedDescending || date.compare(startDate) == .orderedSame) &&
                (endDate == nil || endDate?.timeIntervalSince1970 == 0 || date.compare(endDate!) == .orderedAscending || date.compare(endDate!) == .orderedSame) {
                ids.append(medication.id)
            }
        }
        return ids
    }
}

extension MedicationsSummaryViewModel {
    func getMedicationNameForSymptomSummaryDisplay(_ objectID:  List<ObjectId>) -> String {
        let medications = getAllMedications()
        var medNames = [String]()
        let _ = medications.filter { medication in
            let contains = objectID.contains(medication.id)
            if contains {
                medNames.append(medication.medicationName)
            }
            return contains
        }
        let joinedMeds = medNames.joined(separator: ", ")
        return joinedMeds
    }
}
