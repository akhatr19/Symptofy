//
//  MedicationRecordModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/10/23.
//

import Foundation
import RealmSwift

class MedicationRecordModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
//    @Persisted var medicationName: String?
    @Persisted var medicationRecordedDate: String?
    @Persisted var medicationRecordedList: List<RecordedMedicationList> = List<RecordedMedicationList>()
}

class RecordedMedicationList: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId        //id: which is in MedicationFrequencyItems Realm Model
    @Persisted var extraID: String?                      //extraID: above ID + medicationTime eg: d1464b9f939eb3961ed037_750
    @Persisted var medicationTime: Int?
    @Persisted var statusLoggedDate: String?
    @Persisted var isTaken: Bool?
    @Persisted var isSkipped: Bool?
}
