//
//  ConfirmationView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/20/23.
//

import SwiftUI

struct ConfirmationView: View {
    var noDataScreenType: ScreenType
    var confirmationVM = ConfirmationViewModel()

    var body: some View {
        VStack {
            Spacer()

            Image(systemName: CommonImageStrings.checkMark)
                .font(.system(size: 72))

            Spacer()

            Text(confirmationVM.getConfirmationData(noDataScreenType).title)
                .multilineTextAlignment(.center)
                .customText(true)

            Text(confirmationVM.getConfirmationData(noDataScreenType).description)
                .multilineTextAlignment(.center)
                .customText(true)
                .padding(.vertical)

            Text(confirmationVM.getConfirmationData(noDataScreenType).information)
                .multilineTextAlignment(.center)
                .customText(isInformation: true)

            Spacer()

            Button {
                if noDataScreenType == .medications {
                    UIApplication.shared.popToView(HomeScreenLocalizedStrings.MedicationCard.title)
                } else if noDataScreenType == .symptoms {
                    UIApplication.shared.popToView(SymptomsLocalizedStrings.SymptomsSummary.symptoms)
                } else if noDataScreenType == .dietary {
                    UIApplication.shared.popToView(HomeScreenLocalizedStrings.DietaryCard.title)
                }
            } label: {
                Text(CommonLocalizedStrings.ToolBarButton.done)
                    .customButton()
            }
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

//struct ConfirmationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmationView()
//    }
//}
