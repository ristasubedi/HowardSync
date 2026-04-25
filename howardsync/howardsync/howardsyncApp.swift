//
//  howardsyncApp.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import SwiftUI
import FirebaseCore

@main
struct howardsyncApp: App {

    init() {
        // Configure Firebase before any view is rendered
        FirebaseApp.configure()
        // Eagerly initialize AuthService so the auth-state listener is registered immediately.
        // This ensures session persistence works on app re-launch.
        _ = AuthService.shared
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
