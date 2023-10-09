//
//  SymptofyApp.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/4/23.
//



import SwiftUI

@main
struct SymptofyApp: App {
    let configureRealm = RealmDatabase.sharedInstance()

    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
    }
}
