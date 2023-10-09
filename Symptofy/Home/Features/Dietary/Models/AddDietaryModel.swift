//
//  AddDietaryModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/14/23.
//

import RealmSwift

class AddDietary: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var foodItemName: String
    @Persisted var foodItemAddedDate: String
    @Persisted var foodItemConsumedDate: String
    @Persisted var foodItemConsumedTime: Int
}
