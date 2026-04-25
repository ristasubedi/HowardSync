//
//  CampusEvent.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import Foundation
import SwiftUI

struct CampusEvent: Identifiable {
    let id: String
    let title: String
    let description: String
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
    
    var categoryBadge: String {
        switch category {
        case .today: return "📅 Today"
        case .thisWeek: return "🗓 This Week"
        case .clubs: return "🎓 Club"
        case .sports: return "🏀 Sports"
        }
    }
    
    static let sampleEvents: [CampusEvent] = [
        CampusEvent(
            id: "event-001",
            title: "Homecoming Rally",
            description: "Join fellow Bison for the annual Homecoming Rally on The Yard! Enjoy live performances, food trucks, and the HU Marching Band. Don't miss the crowning of Homecoming King & Queen.",
            date: Date(),
            time: "6:00 PM",
            location: "The Yard",
            category: .clubs,
            color: Color(red: 0.0, green: 0.15, blue: 0.4),
            isSaved: false
        ),
        CampusEvent(
            id: "event-002",
            title: "Career Fair 2026",
            description: "Connect with top employers from tech, finance, healthcare, and more. Bring your resume and dress professionally. Over 50 companies represented including Google, Microsoft, and Goldman Sachs.",
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            time: "10:00 AM",
            location: "Blackburn Center",
            category: .clubs,
            color: Color(red: 0.7, green: 0.05, blue: 0.1),
            isSaved: false
        ),
        CampusEvent(
            id: "event-003",
            title: "Bison Basketball vs. Hampton",
            description: "Cheer on our Bison as they take on the Hampton Pirates in this MEAC conference matchup! Student section opens at 6:30 PM. Flash your Bison ID for free entry.",
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            time: "7:00 PM",
            location: "Burr Gymnasium",
            category: .sports,
            color: Color(red: 0.4, green: 0.0, blue: 0.6),
            isSaved: true
        ),
        CampusEvent(
            id: "event-004",
            title: "Coding Workshop: SwiftUI",
            description: "Learn the fundamentals of SwiftUI and build your first iOS app in this hands-on workshop led by the CS department. Bring your MacBook with Xcode installed. Beginners welcome!",
            date: Date(),
            time: "3:00 PM",
            location: "Engineering Building, Room 201",
            category: .clubs,
            color: Color(red: 0.0, green: 0.4, blue: 0.3),
            isSaved: false
        ),
        CampusEvent(
            id: "event-005",
            title: "Open Mic Night",
            description: "Show off your talent at Cramton's monthly Open Mic Night! Singers, poets, comedians, and musicians all welcome. Sign up at the door. Free snacks and drinks provided.",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            time: "8:00 PM",
            location: "Cramton Auditorium",
            category: .thisWeek,
            color: Color(red: 0.8, green: 0.3, blue: 0.0),
            isSaved: false
        ),
        CampusEvent(
            id: "event-006",
            title: "NSBE General Body Meeting",
            description: "National Society of Black Engineers general body meeting. Discuss upcoming conference attendance, community service projects, and networking events. All engineering majors welcome.",
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
