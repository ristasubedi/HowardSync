//
//  NotificationService.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/25/26.
//

import Foundation
import UserNotifications

/// Manages local notifications for class reminders and saved events.
class NotificationService {
    
    static let shared = NotificationService()
    
    private let center = UNUserNotificationCenter.current()
    
    // MARK: - Permission
    
    func requestPermission() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            return granted
        } catch {
            print("Notification permission error: \(error)")
            return false
        }
    }
    
    func checkPermissionStatus() async -> UNAuthorizationStatus {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }
    
    // MARK: - Class Reminders
    
    /// Schedule a notification 15 minutes before each class.
    func scheduleClassReminders(for schedule: [ClassSchedule]) {
        // Remove old class reminders first
        center.removePendingNotificationRequests(withIdentifiers:
            schedule.map { "class-\($0.id)" }
        )
        
        guard AppState.shared.notificationsEnabled else { return }
        
        for classItem in schedule {
            let content = UNMutableNotificationContent()
            content.title = "📚 \(classItem.courseCode) in 15 min"
            content.body = "\(classItem.courseName) at \(classItem.locationString)"
            content.sound = .default
            
            // Create a trigger based on the class time
            // For demo: schedule a notification 5 seconds from now for testing
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "class-\(classItem.id)",
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("Failed to schedule notification: \(error)")
                }
            }
        }
    }
    
    /// Schedule a notification for a saved event.
    func scheduleEventReminder(title: String, location: String, eventID: String) {
        guard AppState.shared.notificationsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "🎉 Event Reminder"
        content.body = "\(title) at \(location) — starting soon!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "event-\(eventID)",
            content: content,
            trigger: trigger
        )
        
        center.add(request)
    }
    
    /// Remove notification for an unsaved event.
    func removeEventReminder(eventID: String) {
        center.removePendingNotificationRequests(withIdentifiers: ["event-\(eventID)"])
    }
    
    // MARK: - Clear All
    
    func clearAllNotifications() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }
}
