//
//  SymptomSummaryView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/25/23.
//

import SwiftUI
import RealmSwift

struct SymptomSummaryView: View {
    
    @ObservedObject var viewModel = SymptomsSummaryViewModel()
    @State var isAddSymptomClick = false
    @State private var isFilterClick = false

    var body: some View {
        VStack {
            if viewModel.symptomDisplayModels.isEmpty {
                NoDataView(noDataScreenType: .symptoms) {
                    isAddSymptomClick = true
                }
            }
            
            List(Array(viewModel.symptomDisplayModels.keys.sorted(by: > )), id: \.self) { slot in
                Section {
                    ForEach(viewModel.symptomDisplayModels[slot] ?? [], id: \.id) { model in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(model.symptomName ?? "")
                                .font(.title3)
                            
                            HStack(spacing: 2) {
                                Image(systemName: "clock.arrow.circlepath")
                                Text("\(getTimeStringFrom(dateString: model.symptomOccurredDate!))")
                                
                                Text("\(SymptomsLocalizedStrings.SymptomsSummary.severity) \(model.symptomSeverity)")
                                    .padding(.leading, 8)
                            }
                            .font(.callout)
                            .foregroundColor(.informationTextColor)
                        }
                        .padding(.vertical, 5)
                    }
                } header: {
                    Text(slot.displayDateInUserFormat())
                        .font(.title3)
                        .bold()
                } footer: {
                    if let medName = viewModel.symptomDisplayModels[slot]?.first?.medicationNames, !medName.isEmpty {
                        Text(medName)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle(SymptomsLocalizedStrings.SymptomsSummary.symptoms)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isAddSymptomClick) {
            AddSymptomsView()
        }
        .sheet(isPresented: $isFilterClick) {
            CustomDateFilterView() { fromDate,toDate in
                if fromDate == nil {
                    viewModel.getLatestSevenRecords()
                } else {
                    viewModel.getInitialSymptomsDisplayData(fromDate: fromDate, toDate: toDate)
                }
                isFilterClick = false
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.automatic)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        isFilterClick.toggle()
                    } label: {
                        Text(CommonLocalizedStrings.ToolBarButton.filter)
                    }
                    
                    Button {
                        isAddSymptomClick = true
                    } label: {
                        Text(CommonLocalizedStrings.ToolBarButton.add)
                    }
                }
            }
        }
        .onAppear {
            viewModel.getLatestSevenRecords()
        }
    }
}

extension SymptomSummaryView {
    func getTimeStringFrom(dateString: String) -> String {
        (dateString.getDateFromString(DateFormats.yyyy_MM_dd_HH_mm_ss)?.getDateStringForFormat(DateFormats.hh_mm_aa, timezone: nil))!
    }
}
