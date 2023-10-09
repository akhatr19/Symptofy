//
//  NoDataView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/5/23.
//

import SwiftUI

enum ScreenType {
    case medications
    case symptoms
    case dietary
}

struct NoDataView: View {
    
    var noDataScreenType: ScreenType
    var confirmationVM = NoDataViewModel()
    var callBack: () -> ()

    var body: some View {
        VStack {
            Spacer()

            Image(systemName: CommonImageStrings.noDataImage)
                .font(.system(size: 72))

            Spacer()

            Text(confirmationVM.getNoDataContent(noDataScreenType))
                .font(.title3)
                .multilineTextAlignment(.center)

            Spacer()

            Button(action: callBack) {
                Text(confirmationVM.getButtonText(noDataScreenType))
                    .customButton()
            }
            Spacer()
        }
        .padding()
    }
}


//struct NoDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoDataView()
//    }
//}
