//
//  MainTabView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import SwiftUI

struct MainTabView: View {
    @Binding var isLoggedIn: Bool
    @State private var selectedTab = 0
    
    let user = User.sample
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: 0) {
                HomeView(
                    user: user,
                    nextClass: ClassSchedule.sampleSchedule[0],
                    events: CampusEvent.sampleEvents
                )
            } label: {
                Label("Home", systemImage: "house.fill")
            }
            
            Tab(value: 1) {
                CampusMapView(buildings: CampusBuilding.sampleBuildings)
            } label: {
                Label("Map", systemImage: "map.fill")
            }
            
            Tab(value: 2) {
                FeedView()
            } label: {
                Label("Feed", systemImage: "calendar")
            }
            
            Tab(value: 3) {
                DiningView(diningHalls: DiningHall.sampleHalls)
            } label: {
                Label("Dining", systemImage: "fork.knife")
            }
            
            Tab(value: 4) {
                ProfileView(user: user, isLoggedIn: $isLoggedIn)
            } label: {
                Label("Profile", systemImage: "person.fill")
            }
        }
        .tint(HUTheme.bisonBlue)
    }
}

#Preview {
    MainTabView(isLoggedIn: .constant(true))
}
