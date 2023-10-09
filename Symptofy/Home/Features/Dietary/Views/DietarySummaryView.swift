//
//  DietarySummaryView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/25/23.
//

import SwiftUI

struct DietarySummaryView: View {

    @ObservedObject var dietarySummaryVM = DietarySummaryViewModel()
    @State private var isAddDietaryClick = false
    @State private var isFilterClick = false

    var body: some View {
        VStack {
            if dietarySummaryVM.dietaryData.isEmpty {
                NoDataView(noDataScreenType: .dietary) {
                    isAddDietaryClick = true
                }
            }

            List(Array(dietarySummaryVM.dietaryData.keys).sorted(by: >), id: \.self) { slot in
                Section {
                    ForEach(dietarySummaryVM.dietaryData[slot] ?? [], id: \.id) { med in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(med.foodItemName ?? "")
                                .font(.title3)

                            Text(med.foodItemConsumedTime ?? "")
                                .font(.callout)
                                .foregroundColor(.informationTextColor)
                        }
                    }
                } header: {
                    Text(slot.displayDateInUserFormat())
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle(HomeScreenLocalizedStrings.DietaryCard.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isAddDietaryClick) {
            AddDietView()
        }
        .sheet(isPresented: $isFilterClick) {
            CustomDateFilterView() { fromDate,toDate in
                dietarySummaryVM.getDataForDate(fromDate, endDate: toDate)
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
                        isAddDietaryClick = true
                    } label: {
                        Text(CommonLocalizedStrings.ToolBarButton.add)
                    }
                }
            }
        }
        .onAppear {
            dietarySummaryVM.getDataForDate()
        }
    }
}

struct DietarySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DietarySummaryView()
    }
}
