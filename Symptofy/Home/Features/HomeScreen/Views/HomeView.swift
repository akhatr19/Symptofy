//
//  HomeView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/21/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        List {
            medicationsView()
            symptomsView()
            dietaryView()
        }
        .navigationTitle(HomeScreenLocalizedStrings.dashboardTitle)
    }
}

extension HomeView {
    @ViewBuilder
    private func medicationsView() -> some View {
        NavigationLink(destination: MedicationsSummaryView(medicationsSummaryVM: MedicationsSummaryViewModel())) {
            HStack(spacing: 12) {
                HomeReusableView(imageName: MedicationImageStrings.pillsFill,
                                 title: HomeScreenLocalizedStrings.MedicationCard.title,
                                 description: HomeScreenLocalizedStrings.MedicationCard.description)
            }
        }
    }
}

extension HomeView {
    @ViewBuilder
    private func symptomsView() -> some View {
        NavigationLink(destination: SymptomSummaryView()) {
            HStack(spacing: 22) {
                HomeReusableView(imageName: MedicationImageStrings.homeSymptomCardIcon,
                                 title: HomeScreenLocalizedStrings.SymptomCard.title,
                                 description: HomeScreenLocalizedStrings.SymptomCard.description)
            }
        }
    }
}

extension HomeView {
    @ViewBuilder
    private func dietaryView() -> some View {
        NavigationLink(destination: DietarySummaryView()) {
            HStack(spacing: 28) {
                HomeReusableView(imageName: MedicationImageStrings.homeDietaryCardIcon,
                                 title: HomeScreenLocalizedStrings.DietaryCard.title,
                                 description: HomeScreenLocalizedStrings.DietaryCard.description)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
