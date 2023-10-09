//
//  MedicationSummarySubView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/7/23.
//

import SwiftUI
import RealmSwift

struct MedicationSummarySubView: View {

    var medication: MedicationDisplay
    var selectedDate: Date
    @State var isTakenSelected: Bool
    @State var isSkipSelected: Bool
    var isTaken: Bool
    var isSkip: Bool
    @State var skipText = MedicationsLocalizedStrings.MedicationSummary.skip
    @State var takenText = MedicationsLocalizedStrings.MedicationSummary.took
    var takenOrSkipBtnClick: ( _ isTakenClick: Bool, _ isSkipClick: Bool) -> ()

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(medication.medicationName!)
                .font(.title3)

            Text(medication.medicactionDosage!)
                .font(.callout)
                .foregroundColor(.informationTextColor)
            
            if selectedDate.getDateInStoreFormat()!.compare(Date().getDateInStoreFormat()!) == .orderedSame {
                HStack {
                    SelectButton(isSelected: $isSkipSelected, color: .red, text: $skipText)
                        .onTapGesture {
                            isSkipSelected.toggle()
                            takenOrSkipBtnClick(false, isSkipSelected)
                            setSkipText()
                        }
                    
                    SelectButton(isSelected: $isTakenSelected, color: .buttonBackgroundColor, text: $takenText)
                        .onTapGesture {
                            isTakenSelected.toggle()
                            takenOrSkipBtnClick(isTakenSelected, false)
                            setTakenText()
                        }
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
            } else if selectedDate.getDateInStoreFormat()!.compare(Date().getDateInStoreFormat()!) == .orderedAscending {
                if isSkip {
                    HStack {
                        Image(systemName: "xmark.circle")
                        Text(MedicationsLocalizedStrings.MedicationSummary.skipped)
                    }
                    .font(.caption)
                    .padding([.horizontal, .vertical], 5)
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 12, style: .circular).fill(.red))
                } else if isTaken {
                    HStack {
                        Image(systemName: "checkmark.circle")
                        Text(MedicationsLocalizedStrings.MedicationSummary.taken)
                    }
                    .font(.caption)
                    .padding([.horizontal, .vertical], 5)
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 12, style: .circular).fill(Color.buttonBackgroundColor))
                } else {
                    HStack {
                        Image(systemName: "exclamationmark.circle")
                        Text(MedicationsLocalizedStrings.MedicationSummary.youMissed)
                    }
                    .font(.caption)
                    .padding([.horizontal, .vertical], 5)
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 12, style: .circular).fill(.orange))
                }
            }
        }
        .onAppear {
            if isSkipSelected {
                selectedSkipText()
            }
            
            if isTakenSelected {
                selectedTookText()
            }
        }
    }

    fileprivate func setSkipText() {
        if isSkipSelected {
            selectedSkipText()
        } else {
            unSelectedSkipText()
        }
    }
    
    fileprivate func setTakenText() {
        if isTakenSelected {
            selectedTookText()
        } else {
            unSelectedTookText()
        }
    }
    
    fileprivate func selectedSkipText() {
        isTakenSelected = false
        skipText = MedicationsLocalizedStrings.MedicationSummary.skipped
        takenText = MedicationsLocalizedStrings.MedicationSummary.took
    }
    
    fileprivate func selectedTookText() {
        isSkipSelected = false
        skipText = MedicationsLocalizedStrings.MedicationSummary.skip
        takenText = MedicationsLocalizedStrings.MedicationSummary.taken
    }
    
    fileprivate func unSelectedSkipText() {
        skipText = MedicationsLocalizedStrings.MedicationSummary.skip
    }
    
    fileprivate func unSelectedTookText() {
        takenText = MedicationsLocalizedStrings.MedicationSummary.took
    }
}
