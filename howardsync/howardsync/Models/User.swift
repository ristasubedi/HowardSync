//
//  User.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var name: String
    var email: String
    var major: String
    var graduationYear: String
    var gpa: Double
    var eventsCount: Int
    var classesCount: Int
    
    var initials: String {
        let components = name.split(separator: " ")
        let first = components.first?.prefix(1) ?? ""
        let last = components.count > 1 ? components.last?.prefix(1) ?? "" : ""
        return "\(first)\(last)".uppercased()
    }
    
    static let sample = User(
        id: "HU2026001",
        name: "Jordan Smith",
        email: "jordan.smith@bison.howard.edu",
        major: "Computer Science",
        graduationYear: "2026",
        gpa: 3.8,
        eventsCount: 12,
        classesCount: 5
    )
}
