//
//  DietarySummaryViewModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/15/23.
//

import Foundation
import RealmSwift

final class DietarySummaryViewModel: ObservableObject {
    
    @Published private(set) var dietaryData = [String: [DietaryDisplay]]()
    @ObservedResults(AddDietary.self) var dietaryRecords

    func getDataForDate(_ startDate: Date? = nil , endDate: Date? = nil) {
        let allDietaryData = getDietaryDisplaySections(startDate, endDate: endDate)
        var localDietaryData = [String: [DietaryDisplay]]()
        
        for key in allDietaryData.keys.sorted(by: { $0.getDateFromString(DateFormats.yyyy_MM_dd)! > $1.getDateFromString(DateFormats.yyyy_MM_dd)! }) {
            localDietaryData[key] = allDietaryData[key]
            if localDietaryData.count == 7 && startDate == nil {
                break
            }
        }
        dietaryData = localDietaryData
    }

    fileprivate func getAllDietaries() -> [AddDietary] {
        let realm = RealmDatabase.sharedInstance().getRealmDB()
        let result = realm.objects(AddDietary.self)
        var dietaryList = [AddDietary]()
        result.forEach { med in
            dietaryList.append(med)
        }
        return dietaryList
    }

    fileprivate func getDietaryDisplaySections(_ startDate: Date? = nil, endDate: Date? = nil) -> [String: [DietaryDisplay]] {
        var dietaryDisplayData = [String: [DietaryDisplay]]()
        let dietaryList = getAllDietaries()
        for dietaryItem in dietaryList {
            let date = dietaryItem.foodItemConsumedDate.getDateFromString(DateFormats.yyyy_MM_dd)!
            if startDate == nil {
                let timeDict = getDataForDay(dietaryItem, dietaryDisplayData: dietaryDisplayData)
                dietaryDisplayData[dietaryItem.foodItemConsumedDate] = timeDict
            } else {
                let startOfFromDate = Calendar.current.startOfDay(for: startDate!)
                let endOfToDate = Calendar.current.startOfDay(for: endDate!)
                let endDate = Calendar.current.date(byAdding: .hour, value: 24, to: endOfToDate)
                if startOfFromDate <= date && date < endDate! {
                    let timeDict = getDataForDay(dietaryItem, dietaryDisplayData: dietaryDisplayData)
                    dietaryDisplayData[dietaryItem.foodItemConsumedDate] = timeDict
                }
            }
        }
        return dietaryDisplayData
    }
    
    func getDataForDay(_ dietaryItem: AddDietary, dietaryDisplayData: [String: [DietaryDisplay]]) -> [DietaryDisplay] {
        var timeDict = dietaryDisplayData[dietaryItem.foodItemConsumedDate] ?? [DietaryDisplay]()
        var dataData = DietaryDisplay()
        dataData.id = dietaryItem.id
        dataData.foodItemConsumedDate = dietaryItem.foodItemConsumedDate
        dataData.foodItemConsumedTime = dietaryItem.foodItemConsumedTime.getDisplayTime()
        dataData.foodItemName = dietaryItem.foodItemName
        timeDict.append(dataData)
        return timeDict
    }
    
    //MARK: Get Food item ID to save into Symptom table
    func getFoodIdsForSymptom(_ date: Date) -> ObjectId? {
        let dateString = date.getDateStringForFormat(DateFormats.yyyy_MM_dd, timezone: nil)!
        let minutes = date.getTimeInMinutes() - 240
        let ids = List<ObjectId>()
        let dietaries = getAllDietaries()
        for dietary in dietaries {
            if dietary.foodItemConsumedDate == dateString &&
                minutes <= dietary.foodItemConsumedTime {
                let startDate = dietary.foodItemConsumedDate.getDateFromString(DateFormats.yyyy_MM_dd)!
                if date.compare(startDate) == .orderedDescending &&
                    dietary.foodItemConsumedTime <= (minutes + 240) {
                    ids.append(dietary.id)
                }
            }
        }
        return ids.last
    }
    
    //MARK: Get Dietary Name to display in Graph
    func getDietaryNameForSymptomChart(_ objectID: ObjectId) -> String {
        var foodName = ""
        let dietaryItems = getAllDietaries()
        let _ = dietaryItems.filter { dietaryItem in
            let contains = objectID == dietaryItem.id
            if objectID == dietaryItem.id {
                foodName = "\(dietaryItem.foodItemName)"
            }
            return contains
        }
        return foodName
    }
}
