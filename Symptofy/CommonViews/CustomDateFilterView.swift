//
//  CustomDateFilterView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 9/12/23.
//

import SwiftUI

struct CustomDateFilterView: View {

    @State var startDate = Date()
    @State var endDate = Date()
    var completion: (_ fromDate: Date?, _ toDate: Date?) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(CommonLocalizedStrings.DateFilter.reset) {
                    completion(nil, nil)
                }
                .bold()
                .foregroundColor(.buttonBackgroundColor)
            }
            Text(CommonLocalizedStrings.DateFilter.chooseDateRange)
                .padding([.top, .horizontal])
                .multilineTextAlignment(.center)
                .customText(isInformation: true)
            
            Divider()
            DatePicker(CommonLocalizedStrings.DateFilter.from, selection: $startDate, in: Date().getDateByAddingMonths(-3)...Date(), displayedComponents: .date)
                .customText(isInformation: true)
                .padding(.horizontal)
            
            DatePicker(CommonLocalizedStrings.DateFilter.to, selection: $endDate, in: startDate...Date(), displayedComponents: .date)
                .customText(isInformation: true)
                .padding(.horizontal)
            
            HStack {
                Button {
                    completion(startDate, endDate)
                } label: {
                    Text(CommonLocalizedStrings.DateFilter.apply)
                        .customButton()
                }
                .padding()
            }
            Spacer()
        }
        .padding()
    }
}
