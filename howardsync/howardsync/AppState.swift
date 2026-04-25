//
//  AppState.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/25/26.
//

import SwiftUI

/// Central state manager for the app. Persists user data, saved events, schedule, and preferences.
@Observable
class AppState {
    
    // MARK: - Singleton
    static let shared = AppState()
    
    // MARK: - Auth State
    var isLoggedIn: Bool {
        didSet { UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn") }
    }
    
    // MARK: - User Profile
    var currentUser: User {
        didSet { saveUser() }
    }
    
    // MARK: - Saved Events
    var savedEventIDs: Set<String> {
        didSet { saveSavedEventIDs() }
    }
    
    // MARK: - Class Schedule
    var classSchedule: [ClassSchedule] {
        didSet { saveSchedule() }
    }
    
    // MARK: - Preferences
    var isDarkMode: Bool {
        didSet { UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode") }
    }
    
    var notificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled") }
    }
    
    // MARK: - Init
    
    private init() {
        let defaults = UserDefaults.standard
        
        self.isLoggedIn = defaults.bool(forKey: "isLoggedIn")
        self.isDarkMode = defaults.bool(forKey: "isDarkMode")
        self.notificationsEnabled = defaults.bool(forKey: "notificationsEnabled")
        
        // Load user
        if let userData = defaults.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
        } else {
            self.currentUser = .sample
        }
        
        // Load saved event IDs
        if let ids = defaults.stringArray(forKey: "savedEventIDs") {
            self.savedEventIDs = Set(ids)
        } else {
            self.savedEventIDs = []
        }
        
        // Load schedule
        if let scheduleData = defaults.data(forKey: "classSchedule"),
           let schedule = try? JSONDecoder().decode([ClassSchedule].self, from: scheduleData) {
            self.classSchedule = schedule
        } else {
            self.classSchedule = ClassSchedule.sampleSchedule
        }
    }
    
    // MARK: - Persistence Helpers
    
    private func saveUser() {
        if let data = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(data, forKey: "currentUser")
        }
    }
    
    private func saveSavedEventIDs() {
        UserDefaults.standard.set(Array(savedEventIDs), forKey: "savedEventIDs")
    }
    
    private func saveSchedule() {
        if let data = try? JSONEncoder().encode(classSchedule) {
            UserDefaults.standard.set(data, forKey: "classSchedule")
        }
    }
    
    // MARK: - Event Actions
    
    func toggleSaveEvent(_ eventID: String) {
        if savedEventIDs.contains(eventID) {
            savedEventIDs.remove(eventID)
        } else {
            savedEventIDs.insert(eventID)
        }
    }
    
    func isEventSaved(_ eventID: String) -> Bool {
        savedEventIDs.contains(eventID)
    }
    
    // MARK: - Schedule Actions
    
    func addClass(_ newClass: ClassSchedule) {
        classSchedule.append(newClass)
    }
    
    func updateClass(_ updated: ClassSchedule) {
        if let index = classSchedule.firstIndex(where: { $0.id == updated.id }) {
            classSchedule[index] = updated
        }
    }
    
    func deleteClass(at offsets: IndexSet) {
        classSchedule.remove(atOffsets: offsets)
    }
    
    func deleteClass(id: String) {
        classSchedule.removeAll { $0.id == id }
    }
    
    // MARK: - Auth Actions
    
    func logout() {
        isLoggedIn = false
    }
    
    func login() {
        isLoggedIn = true
    }
}
