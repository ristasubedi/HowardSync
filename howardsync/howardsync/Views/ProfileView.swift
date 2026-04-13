//
//  ProfileView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import SwiftUI

struct ProfileView: View {
    let user: User
    @Binding var isLoggedIn: Bool
    @State private var showLogoutConfirm = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Profile")
                        .font(.system(size: 28, weight: .bold))
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Profile Card
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        // Avatar
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 64, height: 64)
                            
                            Text(user.initials)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(HUTheme.bisonBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(user.major)
                                .font(HUTheme.captionFont)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Class of \(user.graduationYear)")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Spacer()
                    }
                    
                    // Stats
                    HStack(spacing: 0) {
                        StatItem(value: "\(user.eventsCount)", label: "Events")
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 1, height: 40)
                        
                        StatItem(value: "\(user.classesCount)", label: "Classes")
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 1, height: 40)
                        
                        StatItem(value: String(format: "%.1f", user.gpa), label: "GPA")
                    }
                }
                .padding(20)
                .background(
                    LinearGradient(
                        colors: [HUTheme.darkNavy, HUTheme.bisonBlue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)
                
                // Menu Items
                VStack(spacing: 2) {
                    ProfileMenuItem(
                        icon: "bell",
                        iconColor: HUTheme.warningOrange,
                        title: "Notification Preferences"
                    )
                    
                    ProfileMenuItem(
                        icon: "heart",
                        iconColor: HUTheme.bisonRed,
                        title: "Saved Events"
                    )
                    
                    ProfileMenuItem(
                        icon: "calendar",
                        iconColor: HUTheme.bisonBlue,
                        title: "My Schedule"
                    )
                    
                    ProfileMenuItem(
                        icon: "gearshape",
                        iconColor: .secondary,
                        title: "Settings"
                    )
                }
                .padding(.horizontal)
                
                // Logout
                Button {
                    showLogoutConfirm = true
                } label: {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(HUTheme.bisonRed.opacity(0.1))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 16))
                                .foregroundColor(HUTheme.bisonRed)
                        }
                        
                        Text("Log Out")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(HUTheme.bisonRed)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(HUTheme.bisonRed.opacity(0.4))
                    }
                    .padding(16)
                    .background(HUTheme.bisonRed.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal)
                
                // App version
                Text("Howard Sync v1.0 • Sprint 1")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary.opacity(0.5))
                    .padding(.top, 8)
                
                Spacer(minLength: 100)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .alert("Log Out", isPresented: $showLogoutConfirm) {
            Button("Log Out", role: .destructive) {
                withAnimation(.spring(response: 0.3)) {
                    isLoggedIn = false
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to log out?")
        }
    }
}

// MARK: - Stat Item

struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Profile Menu Item

struct ProfileMenuItem: View {
    let icon: String
    let iconColor: Color
    let title: String
    
    var body: some View {
        Button {
            // TODO: Navigate to respective screen
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary.opacity(0.4))
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    ProfileView(user: .sample, isLoggedIn: .constant(true))
}
