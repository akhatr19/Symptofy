//
//  SymptomsSummaryViewModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/29/23.
//

import Foundation
import RealmSwift

class SymptomsSummaryViewModel: ObservableObject {
    
    @Published private(set) var symptomDisplayModels = [String: [SymptomDisplayObject]]()
    
    func getInitialSymptomsDisplayData( fromDate: Date? = nil, toDate: Date? = nil) {
        var models = [SymptomDisplayModel]()
        let symptomsList = fromDate == nil ? getAllSymptomsData() : getSavedSymptoms(fromDate!, toDate!)
        for addedSymptom in symptomsList {
            var symptom = SymptomDisplayModel()
            let medicationNames = MedicationsSummaryViewModel().getMedicationNameForSymptomSummaryDisplay(addedSymptom.currentMedications)
            symptom.symptomOccurredDate = addedSymptom.symptomOccurredDate
            symptom.id = addedSymptom.id
            for object in addedSymptom.symptoms {
                let symtmObj = SymptomDisplayObject(id: object.id, symptomsID: object.symptomsID, symptomName: object.symptomName, symptomSeverity: object.symptomSeverity, symptomOccurredDate: object.symptomOccurredDate, medicationNames: medicationNames)
                symptom.symptoms.append(symtmObj)
                
            }
            models.append(symptom)
        }
        symptomDisplayModels = Dictionary.init(grouping: models.flatMap({ $0.symptoms })) { ($0.symptomOccurredDate!.getDateFromString(DateFormats.yyyy_MM_dd_HH_mm_ss)?.getDateStringForFormat(DateFormats.yyyy_MM_dd, timezone: nil))! }
    }

    func getLatestSevenRecords() {
        var models = [SymptomDisplayModel]()
        let symptomsList = getAllSymptomsData().sorted { $0.symptomOccurredDate > $1.symptomOccurredDate }
        for addedSymptom in symptomsList {
            var symptom = SymptomDisplayModel()
            let medicationNames = MedicationsSummaryViewModel().getMedicationNameForSymptomSummaryDisplay(addedSymptom.currentMedications)
            symptom.symptomOccurredDate = addedSymptom.symptomOccurredDate
            symptom.id = addedSymptom.id
            for object in addedSymptom.symptoms {
                let symtmObj = SymptomDisplayObject(id: object.id, symptomsID: object.symptomsID, symptomName: object.symptomName, symptomSeverity: object.symptomSeverity, symptomOccurredDate: object.symptomOccurredDate, medicationNames: medicationNames)
                symptom.symptoms.append(symtmObj)
                
            }
            models.append(symptom)
        }
        let dict = Dictionary.init(grouping: models.flatMap({ $0.symptoms })) { ($0.symptomOccurredDate!.getDateFromString(DateFormats.yyyy_MM_dd_HH_mm_ss)?.getDateStringForFormat(DateFormats.yyyy_MM_dd, timezone: nil))! }
        symptomDisplayModels = [:]
        for key in dict.keys.sorted(by: { $0.getDateFromString(DateFormats.yyyy_MM_dd)! > $1.getDateFromString(DateFormats.yyyy_MM_dd)!}) {
            symptomDisplayModels[key] = dict[key]
            if symptomDisplayModels.count == 7 {
                break
            }
        }
        
    }
}

extension SymptomsSummaryViewModel {
    fileprivate func getAllSymptomsData() -> [AddSymptoms] {
        let realm = RealmDatabase.sharedInstance().getRealmDB()
        let result = realm.objects(AddSymptoms.self)
        var symptomsData = [AddSymptoms]()
        result.forEach { symptmData in
            symptomsData.append(symptmData)
        }
        print(symptomsData)
        return symptomsData
    }

    fileprivate func getSavedSymptoms(_ fromDate: Date, _ toDate: Date) -> [AddSymptoms] {
        var symptomsData = [AddSymptoms]()
        let symptomsDataList = getAllSymptomsData()
        
        for symptomData in symptomsDataList {
            let date = symptomData.symptomOccurredDate.getDateFromString(DateFormats.yyyy_MM_dd_HH_mm_ss)!
            let startOfFromDate = Calendar.current.startOfDay(for: fromDate)
            let endOfToDate = Calendar.current.startOfDay(for: toDate)
            let endDate = Calendar.current.date(byAdding: .hour, value: 24, to: endOfToDate)
            if startOfFromDate <= date && date < endDate!{
                symptomsData.append(symptomData)
            }
        }
        return symptomsData
    }
}
