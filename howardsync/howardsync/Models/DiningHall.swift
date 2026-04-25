//
//  DiningHall.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import Foundation

struct DiningHall: Identifiable {
    let id = UUID()
    let name: String
    let isOpen: Bool
    let waitTimeMinutes: Int
    let busynessLevel: Double // 0.0 to 1.0
    let mealPeriod: String
    let menuItems: [MenuItem]
    
    var statusText: String {
        isOpen ? "OPEN" : "CLOSED"
    }
    
    var waitTimeText: String {
        isOpen ? "~\(waitTimeMinutes) minutes" : "N/A"
    }
    
    static let sampleHalls: [DiningHall] = [
        DiningHall(
            name: "Blackburn",
            isOpen: true,
            waitTimeMinutes: 15,
            busynessLevel: 0.65,
            mealPeriod: "Lunch",
            menuItems: [
                MenuItem(name: "Grilled Chicken", category: .entree),
                MenuItem(name: "Caesar Salad", category: .side),
                MenuItem(name: "Mac & Cheese", category: .side),
                MenuItem(name: "Fresh Fruit Bar", category: .dessert),
                MenuItem(name: "Jerk Chicken", category: .entree),
                MenuItem(name: "Steamed Rice", category: .side),
                MenuItem(name: "Collard Greens", category: .side),
                MenuItem(name: "Sweet Potato Pie", category: .dessert)
            ]
        ),
        DiningHall(
            name: "Bethune Annex",
            isOpen: true,
            waitTimeMinutes: 8,
            busynessLevel: 0.35,
            mealPeriod: "Lunch",
            menuItems: [
                MenuItem(name: "Pasta Primavera", category: .entree),
                MenuItem(name: "Garden Salad", category: .side),
                MenuItem(name: "Garlic Bread", category: .side),
                MenuItem(name: "Chocolate Cake", category: .dessert),
                MenuItem(name: "BBQ Pulled Pork", category: .entree),
                MenuItem(name: "Corn on the Cob", category: .side),
                MenuItem(name: "Baked Beans", category: .side),
                MenuItem(name: "Ice Cream", category: .dessert)
            ]
        )
    ]
}

struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let category: MenuCategory
}

enum MenuCategory: String, CaseIterable {
    case entree = "Entrée"
    case side = "Sides"
    case dessert = "Desserts"
}
