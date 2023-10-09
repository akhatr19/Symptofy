//
//  SymptomLookupModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/21/23.
//

import Foundation
import RealmSwift

struct SymptomLookupModel: Codable {
    var symptoms: [SymptomModel]?
}

struct SymptomModel: Codable, Identifiable {
    var id: Int?
    var symptomName: String?
    var symptomIcon: String?
}

struct SymptomDataManager {
    static func getSymptomsFromJson() -> List<SymptomDataModel> {
        var models = [SymptomModel]()
        if let bundlePath = Bundle.main.path(forResource: "SymptomsLookup", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: bundlePath), options: .mappedIfSafe)
                  let symptomLookupModel = try JSONDecoder().decode(SymptomLookupModel.self, from: jsonData)
                models = symptomLookupModel.symptoms ?? []
            } catch {
               print(error)
            }
        }
        
        let list = List<SymptomDataModel>()
        for model in models {
            let sdm = SymptomDataModel()
            sdm.symptomName = model.symptomName!
            sdm.symptomsID = model.id!
            list.append(sdm)
        }
        return list
    }
}
