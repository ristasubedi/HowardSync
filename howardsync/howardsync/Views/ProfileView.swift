//
//  ProfileView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import SwiftUI

struct ProfileView: View {
    @State private var appState = AppState.shared
    @State private var showLogoutConfirm = false
    @State private var showEditProfile = false
    @State private var showSavedEvents = false
    @State private var showSchedule = false
    @State private var showNotificationSettings = false
    
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
                            
                            Text(appState.currentUser.initials)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(HUTheme.bisonBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(appState.currentUser.name)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(appState.currentUser.major)
                                .font(HUTheme.captionFont)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Class of \(appState.currentUser.graduationYear)")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Spacer()
                        
                        // Edit button
                        Button {
                            showEditProfile = true
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    // Stats
                    HStack(spacing: 0) {
                        StatItem(value: "\(appState.currentUser.eventsCount)", label: "Events")
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 1, height: 40)
                        
                        StatItem(value: "\(appState.currentUser.classesCount)", label: "Classes")
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 1, height: 40)
                        
                        StatItem(value: String(format: "%.1f", appState.currentUser.gpa), label: "GPA")
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
                    ) {
                        showNotificationSettings = true
                    }
                    
                    ProfileMenuItem(
                        icon: "heart",
                        iconColor: HUTheme.bisonRed,
                        title: "Saved Events"
                    ) {
                        showSavedEvents = true
                    }
                    
                    ProfileMenuItem(
                        icon: "calendar",
                        iconColor: HUTheme.bisonBlue,
                        title: "My Schedule"
                    ) {
                        showSchedule = true
                    }
                    
                    // Dark Mode Toggle
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color.purple.opacity(0.12))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: appState.isDarkMode ? "moon.fill" : "sun.max")
                                .font(.system(size: 16))
                                .foregroundColor(.purple)
                        }
                        
                        Text("Dark Mode")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Toggle("", isOn: Binding(
                            get: { appState.isDarkMode },
                            set: { newValue in
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    appState.isDarkMode = newValue
                                }
                            }
                        ))
                        .tint(HUTheme.bisonBlue)
                    }
                    .padding(16)
                    .background(HUTheme.adaptiveCardBg)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    ProfileMenuItem(
                        icon: "gearshape",
                        iconColor: .secondary,
                        title: "Settings"
                    ) {}
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
                Text("Howard Sync v2.0 • Sprint 2")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary.opacity(0.5))
                    .padding(.top, 8)
                
                Spacer(minLength: 100)
            }
        }
        .background(HUTheme.groupedBackground)
        .alert("Log Out", isPresented: $showLogoutConfirm) {
            Button("Log Out", role: .destructive) {
                withAnimation(.spring(response: 0.3)) {
                    appState.logout()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to log out?")
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileView()
        }
        .sheet(isPresented: $showSavedEvents) {
            SavedEventsView()
        }
        .sheet(isPresented: $showSchedule) {
            ScheduleView()
        }
        .sheet(isPresented: $showNotificationSettings) {
            NotificationSettingsView()
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
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
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
            .background(HUTheme.adaptiveCardBg)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

// MARK: - Edit Profile View

struct EditProfileView: View {
    @State private var appState = AppState.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var major = ""
    @State private var gradYear = ""
    @State private var email = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Information") {
                    TextField("Full Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section("Academic") {
                    TextField("Major", text: $major)
                    TextField("Graduation Year", text: $gradYear)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.secondary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        appState.currentUser.name = name
                        appState.currentUser.major = major
                        appState.currentUser.graduationYear = gradYear
                        appState.currentUser.email = email
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(HUTheme.bisonBlue)
                }
            }
            .onAppear {
                name = appState.currentUser.name
                major = appState.currentUser.major
                gradYear = appState.currentUser.graduationYear
                email = appState.currentUser.email
            }
        }
    }
}

// MARK: - Notification Settings View

struct NotificationSettingsView: View {
    @State private var appState = AppState.shared
    @Environment(\.dismiss) private var dismiss
    @State private var permissionStatus = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Enable Notifications", isOn: Binding(
                        get: { appState.notificationsEnabled },
                        set: { newValue in
                            appState.notificationsEnabled = newValue
                            if newValue {
                                Task {
                                    _ = await NotificationService.shared.requestPermission()
                                }
                            } else {
                                NotificationService.shared.clearAllNotifications()
                            }
                        }
                    ))
                    .tint(HUTheme.bisonBlue)
                } header: {
                    Text("General")
                } footer: {
                    Text("Receive reminders for your classes and saved events.")
                }
                
                Section("Notification Types") {
                    HStack {
                        Image(systemName: "book")
                            .foregroundColor(HUTheme.bisonBlue)
                        Text("Class Reminders")
                        Spacer()
                        Text("15 min before")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(HUTheme.warningOrange)
                        Text("Event Reminders")
                        Spacer()
                        Text("Saved events")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button("Open System Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .foregroundColor(HUTheme.bisonBlue)
                } footer: {
                    Text("To change system-level notification permissions, open Settings.")
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(HUTheme.bisonBlue)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
