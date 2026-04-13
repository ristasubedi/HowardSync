//
//  ClassSchedule.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import Foundation

struct ClassSchedule: Identifiable {
    let id = UUID()
    let courseName: String
    let courseCode: String
    let startTime: String
    let endTime: String
    let building: String
    let roomNumber: String
    let professorName: String
    let dayOfWeek: [String]
    
    var locationString: String {
        "\(building), Room \(roomNumber)"
    }
    
    var timeString: String {
        "\(startTime) - \(endTime)"
    }
    
    static let sampleSchedule: [ClassSchedule] = [
        ClassSchedule(
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
