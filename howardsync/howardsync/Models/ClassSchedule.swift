//
//  ClassSchedule.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import Foundation

struct ClassSchedule: Identifiable, Codable, Hashable {
    var id: String
    var courseName: String
    var courseCode: String
    var startTime: String
    var endTime: String
    var building: String
    var roomNumber: String
    var professorName: String
    var dayOfWeek: [String]
    
    var locationString: String {
        "\(building), Room \(roomNumber)"
    }
    
    var timeString: String {
        "\(startTime) - \(endTime)"
    }
    
    var daysString: String {
        dayOfWeek.joined(separator: ", ")
    }
    
    /// Create a new ClassSchedule with auto-generated ID
    static func create(
        courseName: String,
        courseCode: String,
        startTime: String,
        endTime: String,
        building: String,
        roomNumber: String,
        professorName: String,
        dayOfWeek: [String]
    ) -> ClassSchedule {
        ClassSchedule(
            id: UUID().uuidString,
            courseName: courseName,
            courseCode: courseCode,
            startTime: startTime,
            endTime: endTime,
            building: building,
            roomNumber: roomNumber,
            professorName: professorName,
            dayOfWeek: dayOfWeek
        )
    }
    
    static let sampleSchedule: [ClassSchedule] = [
        ClassSchedule(
            id: "class-001",
            courseName: "Data Structures",
            courseCode: "CSCI 201",
            startTime: "10:00 AM",
            endTime: "11:30 AM",
            building: "Engineering Building",
            roomNumber: "301",
            professorName: "Dr. Williams",
            dayOfWeek: ["Mon", "Wed", "Fri"]
        ),
        ClassSchedule(
            id: "class-002",
            courseName: "Calculus II",
            courseCode: "MATH 156",
            startTime: "12:00 PM",
            endTime: "1:30 PM",
            building: "Academic Support Building B",
            roomNumber: "204",
            professorName: "Dr. Chen",
            dayOfWeek: ["Tue", "Thu"]
        ),
        ClassSchedule(
            id: "class-003",
            courseName: "African American History",
            courseCode: "AFAM 101",
            startTime: "2:00 PM",
            endTime: "3:30 PM",
            building: "Founders Library",
            roomNumber: "105",
            professorName: "Dr. Johnson",
            dayOfWeek: ["Mon", "Wed"]
        ),
        ClassSchedule(
            id: "class-004",
            courseName: "Intro to Philosophy",
            courseCode: "PHIL 100",
            startTime: "4:00 PM",
            endTime: "5:30 PM",
            building: "Locke Hall",
            roomNumber: "212",
            professorName: "Dr. Brown",
            dayOfWeek: ["Tue", "Thu"]
        ),
        ClassSchedule(
            id: "class-005",
            courseName: "Technical Writing",
            courseCode: "ENGL 215",
            startTime: "9:00 AM",
            endTime: "10:30 AM",
            building: "Childers Hall",
            roomNumber: "110",
            professorName: "Prof. Davis",
            dayOfWeek: ["Mon", "Wed", "Fri"]
        )
    ]
}
