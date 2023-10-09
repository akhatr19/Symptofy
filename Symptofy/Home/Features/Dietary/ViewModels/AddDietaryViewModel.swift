//
//  AddDietaryViewModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/14/23.
//

import Foundation
import RealmSwift

final class AddDietaryiewModel: ObservableObject {
    
    @Published var foodItemName = ""
    @Published var foodItemConsumedDate = Date()
    @Published var foodItemConsumedTime = Date()
    @Published var navigationDestination = false
    @Published var dietaryPredefinedList = [DietaryPredefinedObject]()
    @ObservedResults(AddDietary.self) var addDietaryItems

    var formIsValid: Bool {
        !foodItemName.isEmpty
    }
    
    init() {
        loadDietaryData()
    }

    fileprivate func loadDietaryData()  {
        guard let url = Bundle.main.path(forResource: "Dietary", ofType: "json") else {
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: url), options: .mappedIfSafe)
            let users = try JSONDecoder().decode(DietaryPredefinedData.self, from: data)
            self.dietaryPredefinedList = users.dietaryItems
        } catch {
            print(error.localizedDescription)
        }
    }

    func addDietary() {
        let items = AddDietary()
        items.foodItemAddedDate = Date().getRecordAddedFormat()
        items.foodItemName = foodItemName
        items.foodItemConsumedDate = foodItemConsumedDate.getDateInStoreFormat()!
        items.foodItemConsumedTime = foodItemConsumedTime.getTimeInMinutes()
        print(items)
        $addDietaryItems.append(items)
        navigationDestination = true
    }
    
    func loadFoodItemNames() -> [String] {
        var names = [String]()
        for med in dietaryPredefinedList { names.append(med.foodItemName) }
        let filterData = names.filter({ $0.localizedCaseInsensitiveContains(foodItemName) })
        return filterData.removingDuplicates()
    }
}
