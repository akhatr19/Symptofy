//
//  InsightsView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/24/23.
//

import SwiftUI

struct InsightsView: View {
    
    @State private var navigateToSummaryView = false
    @State private var navigateToDosageVSSymptomChartView = false
    
    @State private var foodVSSymptomCount = 0
    @State private var dosageSymptomCount = 0
    @State private var tempVSSymptomCount = 0
    @State private var timeVSSymptomCount = 0

    @State private var fromDate = Date()
    @State private var toDate = Date()
    @ObservedObject var dosageVSSymptomSummaryVM = DosageVSSymptomChartViewModel()
    @ObservedObject var foodVSSymptomChartVM = FoodVSSymptomChartViewModel()
    @ObservedObject var timeVSSymptomChartVM = TimeVSSymptomChartViewModel()
    @ObservedObject var tempVSSymptomChartVM = TemperatureVSSymptomChartViewModel()

    var body: some View {
        VStack {
            FrequencyView { dateInterval, frequency in
                fromDate = dateInterval.start
                toDate = dateInterval.end
                dosageSymptomCount = dosageVSSymptomSummaryVM.getDisplayData(dateInterval.start, toDate: dateInterval.end).count
                foodVSSymptomCount = foodVSSymptomChartVM.getDisplayData(dateInterval.start, toDate: dateInterval.end).count
                timeVSSymptomCount = timeVSSymptomChartVM.getDisplayData(dateInterval.start, toDate: dateInterval.end).count
                tempVSSymptomCount = tempVSSymptomChartVM.getDisplayData(dateInterval.start, toDate: dateInterval.end).count
            }
            
            List {
                Section {
                    VStack(alignment: .leading) {
                        Text("Dosage vs Symptoms")
                        HStack {
                            VStack(alignment: .leading) {
                                Text("View summary")
                                    .bold()

                                Text(dosageSymptomCount > 0 ? "\(dosageSymptomCount) item(s)" : "No Data")
                                    .padding(.top, 2)
                                    .font(.title3)
                                    .foregroundColor(.informationTextColor)
                            }
                            .modifier(DosagevsSymptomUI())
                            .onTapGesture {
                                navigateToSummaryView = dosageSymptomCount > 0
                            }

                            Spacer()

                            VStack {
                                Image(systemName: "chart.bar.doc.horizontal.fill")
                                    .font(.largeTitle)
                                
                                Text("View chart")
                                    .padding(.top)
                                    .bold()
                                    .multilineTextAlignment(.leading)
                            }
                            .modifier(DosagevsSymptomUI())
                            .onTapGesture {
                                navigateToDosageVSSymptomChartView = dosageSymptomCount > 0
                            }
                        }
                    }
                    NavigationLink {
                        FoodVSSymptomChartView(fromDate: fromDate, toDate: toDate)
                    } label: {
                        Text("Food vs Symptoms")
                    }
                    .disabled(!(foodVSSymptomCount > 0))
                    
                    NavigationLink {
                        TimeVSSymptomChartView(fromDate: fromDate, toDate: toDate)
                    } label: {
                        Text("Time vs Symptoms")
                    }
                    .disabled(!(timeVSSymptomCount > 0))

                    NavigationLink {
                        TemperatureVSSymptomChartView(fromDate: fromDate, toDate: toDate)
                    } label: {
                        Text("Temperature vs Symptoms")
                    }
                    .disabled(!(tempVSSymptomCount > 0))
                }
            }
//            Spacer()
        }
        .navigationDestination(isPresented: $navigateToSummaryView) {
            DosageVSSymptomSummaryView(fromDate: fromDate, toDate: toDate)
        }
        .navigationDestination(isPresented: $navigateToDosageVSSymptomChartView) {
            DosageVSSymptomChartView(fromDate: fromDate, toDate: toDate)
        }
        .navigationTitle("Insights")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView()
    }
}

struct DosagevsSymptomUI: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(Color.buttonBackgroundColor.opacity(0.2))
            .cornerRadius(12)
    }
}
