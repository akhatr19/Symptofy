//
//  StringConstants.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/9/23.
//

import Foundation

struct CommonLocalizedStrings {
    struct ToolBarButton {
        static let done = "Done"
        static let add = "Add"
        static let filter = "Filter"
        static let cancel = "Cancel"
    }
    struct DateFilter {
        static let reset = "Reset"
        static let chooseDateRange = "Choose custom date range to view more Dietary items"
        static let from = "From"
        static let to = "To"
        static let apply = "Apply"
    }
}

struct HomeScreenLocalizedStrings {
    static let dashboardTitle = "Dashboard"
    
    struct MedicationCard {
        static let title = "Medications"
        static let description = "Keep a comprehensive record of all your medications at one place"
    }
    
    struct SymptomCard {
        static let title = "Symptoms"
        static let description = "Consolidate all your symptoms at one place for easy monitoring"
    }
    
    struct DietaryCard {
        static let title = "Dietary"
        static let description = "Centralize all your food tracking in a single location"
    }
}

struct MedicationsLocalizedStrings {
    struct AddMedication {
        static let addMedication = "Add Medication"
        static let medicationNamePlaceholder = "Medication name"
        static let couldnotFindMed = "Couldn't find the medication you are searching for?"
        static let considerAlternate = "Consider attempting an alternative option or add what you have already entered"
        static let addThisMedication = "Add this medication"
        static let dosageKey = "Dosage"
        static let enterDosagePlaceholder = "Enter Dosage"
        static let medicationDetailsTitle = "Medication Details"
        static let medicationDetailsFooter = "Medication name and it's Dosage."
        
        static let startDate = "Start date"
        static let time = "Time"
        static let selectTime = "Select time"
        static let addAnotherTime = "Add another time"
        static let timeSlotFooter = "When is the appropriate time to consume the medication?"
        
        static let endDate = "End date"
        static let optional = "Optional"
        static let endDateFooter = "When does the Medication end?"
        
        static let notesHeader = "Notes"
        static let notesPlaceeholder = "Add any additional notes or instructions for this medication (optional)..."
    }
    
    struct MedicationSummary {
        static let skip = "Skip"
        static let took = "Took"
        static let skipped = "Skipped"
        static let taken = "Taken"
        static let youMissed = "You missed"
    }
    
    struct Confirmation {
        static let medicationAddSuccess = "Medication has been successfully added"
        static let informationOne = "You take it at\n"
        static let informationTwo = " from\n"
        static let noEndDate = "No end date"
    }
    
    struct NoData {
        static let noMedications = "There are no medications scheduled for you today"
    }
}

struct DietaryLocalizedStrings {
    struct AddDietary {
        static let foodItemNamePlaceholder = "Enter food item"
        static let addDietary = "Add Dietary"
        static let couldnotFindFoodItem = "Couldn't find the food item you are searching for?"
        static let addThisFoodItem = "Add this food item"
        static let consumedDate = "Consumed Date"
    }
    
    struct Confirmation {
        static let dietaryAddSuccess = "Your Dietary item\n has been added"
        static let informationOne = "You consumed it at\n"
        static let informationTwo = " on\n"
    }
    
    struct NoData {
        static let noDietaryItems = "You have not added any dietary items"
    }
}

struct SymptomsLocalizedStrings {
    struct AddSymptoms {
        static let dateAndTime = "Date & Time"
        static let addSymptoms = "Add Symptoms"
        static let severityValue = "Severity Value:"
        static let severityIsLabel = "Severity is"
        static let addCustomSymptom = "Add Custom Symptom"
        static let addSymptomName = "Add Symptom Name"
        static let addCustomSymptomInfo = "Couldn't find the symptom you are looking for?\nAdd a personalised symptom"
    }

    struct SymptomsSummary {
        static let severity = "Severity:"
        static let symptoms = "Symptoms"
    }
    
    struct Confirmation {
        static let symptomAddSuccess = "Your Symptom\n have been recorded"
        static let informationOne = "You experienced these symptom(s) at\n"
        static let informationTwo = " on\n"
    }
    
    struct NoData {
        static let noSymptoms = "Today, you haven't provided any symptoms"
    }
}
