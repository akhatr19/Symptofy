//
//  AddMedicationModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/2/23.
//

import Foundation
import RealmSwift

class AddMedication: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var medicationAddedDate: String
    @Persisted var medicationName: String
    @Persisted var medicactionDosage: String
    @Persisted var startDate: String
    @Persisted var endDate: String?
    @Persisted var medicationFrequency: List<MedicationFrequencyItems> = List<MedicationFrequencyItems>()
}

class MedicationFrequencyItems: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var medicationTime: Int
    @Persisted var statusLoggedDate: String?
    @Persisted var isTaken: Bool?
    @Persisted var isSkipped: Bool?
}


struct MedicationDisplay {
    var id: ObjectId?   //id: which is in AddMedication Realm Model
    var medicationName: String?
    var medicactionDosage: String?
    var startDate: String?
    var endDate: String?
    var medicationSlot: MedicationSlotData?
}

struct MedicationSlotData {
    var id: ObjectId?   //id: which is in MedicationFrequencyItems Realm Model
    var statusLoggedDate: String?
    var isTaken: Bool?
    var isSkipped: Bool?
}
