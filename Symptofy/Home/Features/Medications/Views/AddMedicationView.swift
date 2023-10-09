//
//  AddMedicationView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/26/23.
//

import SwiftUI

struct AddMedicationView: View {
    
    @ObservedObject var viewModel: AddMedicationViewModel
    @State private var notes = ""
    @State private var medicationName = ""
    @FocusState private var focused: Bool

    var body: some View {
        if medicationName.isEmpty {
            VStack {
                TextField(MedicationsLocalizedStrings.AddMedication.medicationNamePlaceholder, text: $viewModel.medicationName)
                    .customTextField(.alphabet)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()
                    .focused(self.$focused)
                Divider()
                
                if viewModel.medicationName.count > 1 && viewModel.loadMedicationNames().isEmpty {
                    addNewMedicationView
                }
                
                suggestedMedications
            }
            .padding()
            .onAppear {
                self.focused = true
            }
            Spacer()
        } else {
            Form {
                medicationDetails
                startDateAndSlotDetails
                endDateDetails
                //notesDetails
            }
            .navigationDestination(isPresented: $viewModel.navigationDestination) {
                ConfirmationView(noDataScreenType: .medications)
            }
            .navigationTitle(MedicationsLocalizedStrings.AddMedication.addMedication)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(CommonLocalizedStrings.ToolBarButton.done) {
                        viewModel.addMedication()
                    }
                    .bold()
                    .disabled(!viewModel.formIsValid)
                }
            }
        }
    }
}

private extension AddMedicationView {
    var addNewMedicationView: some View {
        VStack {
            Text(MedicationsLocalizedStrings.AddMedication.couldnotFindMed)
                .customText(true)
                .padding()
            
            Text(MedicationsLocalizedStrings.AddMedication.considerAlternate)
                .customText(isInformation: true)
            
            Button {
                medicationName = viewModel.medicationName
                focused = false
            } label: {
                Text(MedicationsLocalizedStrings.AddMedication.addThisMedication)
                    .customButton()
            }
            .padding()
        }
        .frame(height: 250)
        .multilineTextAlignment(.center)
    }
}

private extension AddMedicationView {
    var suggestedMedications: some View {
        List(viewModel.loadMedicationNames(), id: \.self) { suggestion in
            Text(suggestion)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .onTapGesture {
                    medicationName = suggestion
                    viewModel.medicationName = suggestion
                    focused = false
                }
        }
    }
}

private extension AddMedicationView {
    var medicationDetails: some View {
        Section {
            Text(medicationName)
                .customText(true)

            HStack {
                Text(MedicationsLocalizedStrings.AddMedication.dosageKey)
                    .customText(isInformation: true)
                Spacer()
                TextField(MedicationsLocalizedStrings.AddMedication.enterDosagePlaceholder, text: $viewModel.dosageValue)
                    .multilineTextAlignment(.trailing)
                    .customTextField(.alphabet)
            }
        } header: {
            Text(MedicationsLocalizedStrings.AddMedication.medicationDetailsTitle)
        } footer: {
            Text(MedicationsLocalizedStrings.AddMedication.medicationDetailsFooter)
        }
    }
}

private extension AddMedicationView {
    var startDateAndSlotDetails: some View {
        Section {
            DatePicker(MedicationsLocalizedStrings.AddMedication.startDate, selection: $viewModel.startDateValue, in: Date()..., displayedComponents: .date)
                .customText(isInformation: true)

            DatePicker(MedicationsLocalizedStrings.AddMedication.time, selection: $viewModel.initialTimeSlot, displayedComponents: .hourAndMinute)
                .customText(isInformation: true)

            TimingSlotSection(list: $viewModel.timeSlots)
        } footer: {
            Text(MedicationsLocalizedStrings.AddMedication.timeSlotFooter)
        }
    }
    
    var endDateDetails: some View {
        Section {
            OptionalDatePickerField(date: $viewModel.endDateValue, dateSet: $viewModel.endDateSet,
                                    minimumDate: $viewModel.startDateValue)
                .customText(isInformation: true)
        } footer: {
            Text(MedicationsLocalizedStrings.AddMedication.endDateFooter)
        }
    }
}

private extension AddMedicationView {
    var notesDetails: some View {
        Section {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $notes)
                    .frame(minHeight: 80)
                
                Text(MedicationsLocalizedStrings.AddMedication.notesPlaceeholder)
                    .foregroundColor(Color(.placeholderText))
                    .padding(.top, 8)
                    .padding(.leading, 3)
                    .opacity(notes.isEmpty ? 1 : 0)
            }
        } header: {
            Text(MedicationsLocalizedStrings.AddMedication.notesHeader)
        }
    }
}

//struct AddMedicationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMedicationView()
//    }
//}
