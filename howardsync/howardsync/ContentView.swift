//
//  ContentView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import SwiftUI

struct ContentView: View {
    @State private var appState = AppState.shared
    
    var body: some View {
        Group {
            if appState.isLoggedIn {
                MainTabView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            } else {
                LoginView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: appState.isLoggedIn)
        .preferredColorScheme(appState.isDarkMode ? .dark : nil)
        .task {
            // Request notification permission on first launch
            _ = await NotificationService.shared.requestPermission()
        }
    }
}

#Preview {
    ContentView()
}
