//
//  CampusEvent.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import Foundation
import SwiftUI

struct CampusEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let time: String
    let location: String
    let category: EventCategory
    let color: Color
    var isSaved: Bool
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var displayDate: String {
        if isToday {
            return "Today, \(time)"
        } else {
            return "\(dateString), \(time)"
        }
    }
    
    static let sampleEvents: [CampusEvent] = [
        CampusEvent(
            title: "Homecoming Rally",
            date: Date(),
            time: "6:00 PM",
            location: "The Yard",
            category: .clubs,
            color: Color(red: 0.0, green: 0.15, blue: 0.4),
            isSaved: false
        ),
        CampusEvent(
            title: "Career Fair 2026",
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            time: "10:00 AM",
            location: "Blackburn Center",
            category: .clubs,
            color: Color(red: 0.7, green: 0.05, blue: 0.1),
            isSaved: false
        ),
        CampusEvent(
            title: "Bison Basketball vs. Hampton",
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            time: "7:00 PM",
            location: "Burr Gymnasium",
            category: .sports,
            color: Color(red: 0.4, green: 0.0, blue: 0.6),
            isSaved: true
        ),
        CampusEvent(
            title: "Coding Workshop: SwiftUI",
            date: Date(),
            time: "3:00 PM",
            location: "Engineering Building, Room 201",
            category: .clubs,
            color: Color(red: 0.0, green: 0.4, blue: 0.3),
            isSaved: false
        ),
        CampusEvent(
            title: "Open Mic Night",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            time: "8:00 PM",
            location: "Cramton Auditorium",
            category: .thisWeek,
            color: Color(red: 0.8, green: 0.3, blue: 0.0),
            isSaved: false
        ),
        CampusEvent(
            title: "NSBE General Body Meeting",
            date: Date(),
            time: "5:00 PM",
            location: "School of Business, Rm 120",
            category: .clubs,
            color: Color(red: 0.0, green: 0.2, blue: 0.5),
            isSaved: true
        )
    ]
}

enum EventCategory: String, CaseIterable {
    case today = "Today"
    case thisWeek = "This Week"
    case clubs = "Clubs"
    case sports = "Sports"
}
