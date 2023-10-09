//
//  DietarySummaryModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/16/23.
//

import RealmSwift

struct DietaryDisplay {
    var id: ObjectId?   //id: which is in AddDietary Realm Model
    var foodItemName: String?
    var foodItemConsumedDate: String?
    var foodItemConsumedTime: String?
}
