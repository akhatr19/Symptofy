//
//  MedicationsSummaryView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/25/23.
//

import SwiftUI

struct MedicationsSummaryView: View {
    
    @State private var isExpandClick = false
    @State private var isAddMedicationClick = false
    @ObservedObject var medicationsSummaryVM: MedicationsSummaryViewModel
    @State var selectedCalDate = Date()

    var body: some View {
        VStack {
            CalenderRepresentable(isExpanded: isExpandClick) { selectedDate in
                selectedCalDate = selectedDate
                medicationsSummaryVM.getDataForDate(selectedDate)
            }
            .frame(height: isExpandClick ? 400 : 125)

            if medicationsSummaryVM.medicationData.isEmpty {
                NoDataView(noDataScreenType: .medications) {
                    isAddMedicationClick = true
                }
            }

            List(Array(medicationsSummaryVM.medicationData.keys).sorted(by: <), id: \.self) { slot in
                Section {
                    ForEach(0..<(medicationsSummaryVM.medicationData[slot]?.count ?? 0), id: \.self) { med in
                        MedicationSummarySubView(medication: medicationsSummaryVM.medicationData[slot]![med],
                                                 selectedDate: selectedCalDate,
                                                 isTakenSelected: medicationsSummaryVM.medicationData[slot]![med].medicationSlot!.isTaken!,
                                                 isSkipSelected: medicationsSummaryVM.medicationData[slot]![med].medicationSlot!.isSkipped!, isTaken: medicationsSummaryVM.medicationData[slot]![med].medicationSlot!.isTaken!,
                                                 isSkip: medicationsSummaryVM.medicationData[slot]![med].medicationSlot!.isSkipped!) { isTakenClick, isSkipClick in
                            medicationsSummaryVM.updateMedicationConsumeStatus(medicationsSummaryVM.medicationData[slot]![med],
                                                                               date: selectedCalDate,
                                                                               medicationTime: slot,
                                                                               isTaken: isTakenClick, isSkipped: isSkipClick)
                        }
                    }
                } header: {
                    Text(slot.getDisplayTime())
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle(HomeScreenLocalizedStrings.MedicationCard.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isAddMedicationClick) {
            AddMedicationView(viewModel: AddMedicationViewModel())
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        isExpandClick.toggle()
                    } label: {
                        Image(systemName: CommonImageStrings.calendar)
                    }
                    .shadow(color: isExpandClick ? .accentColor : .clear, radius: 5)

                    Button {
                        isAddMedicationClick = true
                    } label: {
                        Text(CommonLocalizedStrings.ToolBarButton.add)
                    }
                }
            }
        }
        .onAppear {
            medicationsSummaryVM.getDataForDate(Date())
        }
    }
}

//struct MedicationsSummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        MedicationsSummaryView()
//    }
//}
