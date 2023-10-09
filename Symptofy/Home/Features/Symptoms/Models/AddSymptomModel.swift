//
//  AddSymptomModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/21/23.
//

import Foundation
import RealmSwift

class AddSymptoms: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var symptomAddedDate: String
    @Persisted var symptomOccurredDate: String
    @Persisted var symptoms: List<SymptomDataModel> = List<SymptomDataModel>()
    @Persisted var temperature: String
    @Persisted var currentMedications: List<ObjectId> = List<ObjectId>()
    @Persisted var currentDietary: List<ObjectId> = List<ObjectId>()
}

class SymptomDataModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var symptomsID: Int
    @Persisted var symptomName: String
    @Persisted var symptomSeverity: Int = 0
    @Persisted var symptomAddedDate: String
    @Persisted var symptomOccurredDate: String
}

class CustomSymptom: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var symptomsID: Int
    @Persisted var symptomName: String
}

struct SymptomDisplayModel {
    var id: ObjectId? // id from AddSymptoms realm model
//    var symptomAddedDate: String?
    var symptomOccurredDate: String?
    var symptoms = [SymptomDisplayObject]()
}

struct SymptomDisplayObject {
    var id: ObjectId?
    var symptomsID: Int?
    var symptomName: String?
    var symptomSeverity: Int = 0
//    var symptomAddedDate: String?
    var symptomOccurredDate: String?
    var medicationNames: String?
}
