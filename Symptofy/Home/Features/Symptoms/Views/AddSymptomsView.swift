//
//  AddSymptomsView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/25/23.
//

import SwiftUI

struct AddSymptomsView: View {
    
    @ObservedObject var viewModel = AddSymptomsViewModel()
    @State var addCustomSymptom = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            DatePicker(SymptomsLocalizedStrings.AddSymptoms.dateAndTime, selection: $viewModel.symptomEntryDate,
                       in: Date().getDateByAddingDays(-7)...Date())
                .customText(isInformation: true)
                .padding(.horizontal)
                .padding(.top, 5)
            Divider()
            
            List {
                ForEach(viewModel.symptoms) { symptom in
                    SymptomSummaryItemView(showSlider: symptom.symptomSeverity > 0, symptom: symptom, value: Double(symptom.symptomSeverity)) { model in
                        let smModel = viewModel.symptoms.filter { $0.symptomsID == model.symptomsID }.first
                        smModel?.symptomSeverity = model.symptomSeverity
                        viewModel.enableOrDisableAddButton()
                    }
                }
                HStack {
                    Text(SymptomsLocalizedStrings.AddSymptoms.addCustomSymptomInfo)
                        .customText(isInformation: true)
                    Spacer()
                    Button {
                        addCustomSymptom = true
                    } label: {
                        Text(CommonLocalizedStrings.ToolBarButton.add)
                    }
                    .buttonStyle(.bordered)
                    .tint(.buttonBackgroundColor)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle(SymptomsLocalizedStrings.AddSymptoms.addSymptoms)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $addCustomSymptom) {
            CustomSymptomView() { symptomName, severity in
                addCustomSymptom = false
                if symptomName != nil {
                    viewModel.addCustomSymptom(symptomName: symptomName!, severity: severity ?? 0)
                    viewModel.enableOrDisableAddButton()
                }
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.automatic)
        }
        .navigationDestination(isPresented: $viewModel.navigationDestination) {
            ConfirmationView(noDataScreenType: .symptoms)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(CommonLocalizedStrings.ToolBarButton.done) {
                    viewModel.addSymptomData()
                }
                .bold()
                .disabled(viewModel.disableDoneButton)
            }
        }
        .onAppear {
            viewModel.getCurrentLocationTemp()
            let models = SymptomDataManager.getSymptomsFromJson()
            models.append(objectsIn: viewModel.getAllCustomSymptoms())
            viewModel.symptoms = models
        }
    }
}
