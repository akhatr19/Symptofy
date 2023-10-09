//
//  AddDietView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/25/23.
//

import SwiftUI

struct AddDietView: View {
    
    @State private var foodItemName = ""
    @FocusState private var focused: Bool
    @ObservedObject var viewModel = AddDietaryiewModel()

    var body: some View {
        if foodItemName.isEmpty {
            VStack {
                TextField(DietaryLocalizedStrings.AddDietary.foodItemNamePlaceholder, text: $viewModel.foodItemName)
                    .customTextField(.alphabet)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()
                    .focused(self.$focused)
                Divider()
                
                if viewModel.foodItemName.count > 1 && viewModel.loadFoodItemNames().isEmpty {
                    addNewFoodItemView
                }

                suggestedFoodItems
            }
            .padding()
            .onAppear {
                self.focused = true
            }
            Spacer()
        } else {
            Form {
                dietaryDetails
            }
            .navigationDestination(isPresented: $viewModel.navigationDestination) {
                ConfirmationView(noDataScreenType: .dietary)
            }
            .navigationTitle(DietaryLocalizedStrings.AddDietary.addDietary)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(CommonLocalizedStrings.ToolBarButton.done) {
                        viewModel.addDietary()
                    }
                    .bold()
                    .disabled(!viewModel.formIsValid)
                }
            }
        }
    }
}

private extension AddDietView {
    var addNewFoodItemView: some View {
        VStack {
            Text(DietaryLocalizedStrings.AddDietary.couldnotFindFoodItem)
                .customText(true)
                .padding()
            
            Text(MedicationsLocalizedStrings.AddMedication.considerAlternate)
                .customText(isInformation: true)
            
            Button {
                foodItemName = viewModel.foodItemName
                focused = false
            } label: {
                Text(DietaryLocalizedStrings.AddDietary.addThisFoodItem)
                    .customButton()
            }
            .padding()
        }
        .frame(height: 250)
        .multilineTextAlignment(.center)
    }
}

private extension AddDietView {
    var dietaryDetails: some View {
        Section {
            Text(foodItemName)
                .customText(true)

            DatePicker(DietaryLocalizedStrings.AddDietary.consumedDate, selection: $viewModel.foodItemConsumedDate, in: Date().getDateByAddingDays(-7)...Date(),
                       displayedComponents: .date)
            .customText(isInformation: true)

            DatePicker(MedicationsLocalizedStrings.AddMedication.time,
                       selection: $viewModel.foodItemConsumedTime,
                       displayedComponents: .hourAndMinute)
            .customText(isInformation: true)
        }
    }
}

private extension AddDietView {
    var suggestedFoodItems: some View {
        List(viewModel.loadFoodItemNames(), id: \.self) { suggestion in
            Text(suggestion)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .onTapGesture {
                    foodItemName = suggestion
                    viewModel.foodItemName = suggestion
                    focused = false
                }
        }
    }
}

//struct AddDietView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddDietView()
//    }
//}
