//
//  MainTabView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var appState = AppState.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: 0) {
                HomeView()
            } label: {
                Label("Home", systemImage: "house.fill")
            }
            
            Tab(value: 1) {
                CampusMapView(buildings: CampusBuilding.sampleBuildings)
            } label: {
                Label("Map", systemImage: "map.fill")
            }
            
            Tab(value: 2) {
                NavigationStack {
                    FeedView()
                }
            } label: {
                Label("Feed", systemImage: "calendar")
            }
            
            Tab(value: 3) {
                DiningView()
            } label: {
                Label("Dining", systemImage: "fork.knife")
            }
            
            Tab(value: 4) {
                ProfileView()
            } label: {
                Label("Profile", systemImage: "person.fill")
            }
        }
        .tint(HUTheme.bisonBlue)
    }
}

#Preview {
    MainTabView()
}
