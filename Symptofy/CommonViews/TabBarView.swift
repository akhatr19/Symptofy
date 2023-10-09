//
//  TabBarView.swift
//  Symptofy
//
//  Created by Aarav Khatri on 10/8/23.
//

import SwiftUI


struct TabBarView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Dashboard", systemImage: "list.dash")
            }
            
            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar.xaxis")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
