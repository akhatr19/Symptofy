//
//  AddSymptomsViewModel.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/29/23.
//

import Foundation
import RealmSwift
import CoreLocation

final class AddSymptomsViewModel: NSObject, ObservableObject {
    
    @Published var symptoms: List<SymptomDataModel> = List<SymptomDataModel>()
    @Published var navigationDestination = false
    @Published var symptomEntryDate = Date()
    @Published var disableDoneButton = true
    var temp = ""

    @ObservedResults(AddSymptoms.self) var addedSymptomData
    @ObservedResults(CustomSymptom.self) var customSymptomData

    func addSymptomData() {
        let addSymptoms = AddSymptoms()
        addSymptoms.symptomAddedDate = Date().getRecordAddedFormat()
        addSymptoms.symptomOccurredDate = symptomEntryDate.getDateStringForFormat((DateFormats.yyyy_MM_dd_HH_mm_ss), timezone: nil) ?? ""
        addSymptoms.temperature = temp.isEmpty ? UserDefaults.standard.value(forKey: "currentTemperature") as? String ?? "" : temp
        addSymptoms.currentMedications = MedicationsSummaryViewModel().getMedicationIdsForSymptom(symptomEntryDate.startOfDay!)
        addSymptoms.currentDietary = DietarySummaryViewModel().getFoodIdsForSymptom(symptomEntryDate)
        for item in symptoms.filter({$0.symptomSeverity > 0}) {
            item.symptomOccurredDate = addSymptoms.symptomOccurredDate
            addSymptoms.symptoms.append(item)
        }
        $addedSymptomData.append(addSymptoms)
        navigationDestination = true
    }

    func getAllCustomSymptoms() -> List<SymptomDataModel> {
        let models = List<SymptomDataModel>()
        let realm = RealmDatabase.sharedInstance().getRealmDB()
        let result = realm.objects(CustomSymptom.self)
        result.forEach { symptmData in
            let model = SymptomDataModel()
            model.symptomsID = symptmData.symptomsID
            model.symptomName = symptmData.symptomName
            models.append(model)
        }
        return models
    }

    func addCustomSymptom(symptomName: String, severity: Int) {
        let customSymptom = CustomSymptom()
        customSymptom.symptomsID = symptoms.count + 1
        customSymptom.symptomName = symptomName
        $customSymptomData.append(customSymptom)
        prepareDisplayModelFromCustomSymptom(symptomName: symptomName, severity: severity)
    }

    func prepareDisplayModelFromCustomSymptom(symptomName: String, severity: Int) {
        let model = SymptomDataModel()
        model.symptomsID = symptoms.count + 1
        model.symptomName = symptomName
        model.symptomSeverity = severity
        symptoms.append(model)
    }

    func enableOrDisableAddButton() {
        disableDoneButton = symptoms.filter({$0.symptomSeverity > 0}).count == 0
    }

    func getCurrentLocationTemp() {
        WeatherApiManager.sharedInstace().getLocation(delegate: self)
    }

    func openWeatherWebserviceCall(_ location: CLLocationCoordinate2D) {
        WeatherApiManager.sharedInstace().getTemparature(lat: "\(location.latitude)",
                                                         lon: "\(location.longitude)") { value in
            self.temp = value.getFormattedString(fraction: 2)
            UserDefaults.standard.set(self.temp, forKey: "currentTemperature")
        }
    }
}

extension AddSymptomsViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        openWeatherWebserviceCall(locValue)
    }
}
