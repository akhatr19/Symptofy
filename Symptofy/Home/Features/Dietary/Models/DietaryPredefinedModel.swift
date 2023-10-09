//
//  DietaryPredefinedModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/16/23.
//

import RealmSwift

class DietaryPredefinedList: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var foodItemName: String
}

struct DietaryPredefinedData: Codable {
    let dietaryItems: [DietaryPredefinedObject]
}

struct DietaryPredefinedObject: Codable {
    var id: Int
    var foodItemName: String
}
