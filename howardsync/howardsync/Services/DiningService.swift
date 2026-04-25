//
//  DiningService.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/25/26.
//

import Foundation

// MARK: - Protocol

protocol DiningServiceProtocol {
    func fetchDiningHalls() async throws -> [DiningHall]
}

// MARK: - Mock Service

/// Mock dining service that returns sample data with simulated network delay.
/// Menus change based on the current meal period.
class MockDiningService: DiningServiceProtocol {
    
    enum MealPeriod: String {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case closed = "Closed"
    }
    
    static let shared = MockDiningService()
    
    var currentMealPeriod: MealPeriod {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 7..<11: return .breakfast
        case 11..<16: return .lunch
        case 16..<21: return .dinner
        default: return .closed
        }
    }
    
    func fetchDiningHalls() async throws -> [DiningHall] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 800_000_000) // 0.8s
        
        let period = currentMealPeriod
        
        return [
            DiningHall(
                name: "Blackburn",
                isOpen: period != .closed,
                waitTimeMinutes: period == .closed ? 0 : Int.random(in: 5...25),
                busynessLevel: period == .closed ? 0 : Double.random(in: 0.2...0.9),
                mealPeriod: period.rawValue,
                menuItems: blackburnMenu(for: period)
            ),
            DiningHall(
                name: "Bethune Annex",
                isOpen: period != .closed,
                waitTimeMinutes: period == .closed ? 0 : Int.random(in: 3...15),
                busynessLevel: period == .closed ? 0 : Double.random(in: 0.1...0.7),
                mealPeriod: period.rawValue,
                menuItems: bethuneMenu(for: period)
            )
        ]
    }
    
    private func blackburnMenu(for period: MealPeriod) -> [MenuItem] {
        switch period {
        case .breakfast:
            return [
                MenuItem(name: "Scrambled Eggs", category: .entree),
                MenuItem(name: "Turkey Sausage", category: .entree),
                MenuItem(name: "Pancakes & Syrup", category: .entree),
                MenuItem(name: "Hash Browns", category: .side),
                MenuItem(name: "Fresh Fruit Bowl", category: .side),
                MenuItem(name: "Yogurt Parfait", category: .dessert),
            ]
        case .lunch:
            return [
                MenuItem(name: "Grilled Chicken", category: .entree),
                MenuItem(name: "Jerk Chicken", category: .entree),
                MenuItem(name: "Caesar Salad", category: .side),
                MenuItem(name: "Mac & Cheese", category: .side),
                MenuItem(name: "Collard Greens", category: .side),
                MenuItem(name: "Sweet Potato Pie", category: .dessert),
                MenuItem(name: "Fresh Fruit Bar", category: .dessert),
            ]
        case .dinner:
            return [
                MenuItem(name: "Baked Salmon", category: .entree),
                MenuItem(name: "Beef Stew", category: .entree),
                MenuItem(name: "Steamed Rice", category: .side),
                MenuItem(name: "Roasted Vegetables", category: .side),
                MenuItem(name: "Cornbread", category: .side),
                MenuItem(name: "Peach Cobbler", category: .dessert),
            ]
        case .closed:
            return []
        }
    }
    
    private func bethuneMenu(for period: MealPeriod) -> [MenuItem] {
        switch period {
        case .breakfast:
            return [
                MenuItem(name: "Omelette Station", category: .entree),
                MenuItem(name: "Waffles", category: .entree),
                MenuItem(name: "Bacon", category: .side),
                MenuItem(name: "Grits", category: .side),
                MenuItem(name: "Banana Muffin", category: .dessert),
            ]
        case .lunch:
            return [
                MenuItem(name: "Pasta Primavera", category: .entree),
                MenuItem(name: "BBQ Pulled Pork", category: .entree),
                MenuItem(name: "Garden Salad", category: .side),
                MenuItem(name: "Garlic Bread", category: .side),
                MenuItem(name: "Corn on the Cob", category: .side),
                MenuItem(name: "Chocolate Cake", category: .dessert),
            ]
        case .dinner:
            return [
                MenuItem(name: "Fried Catfish", category: .entree),
                MenuItem(name: "Chicken Alfredo", category: .entree),
                MenuItem(name: "Baked Beans", category: .side),
                MenuItem(name: "Coleslaw", category: .side),
                MenuItem(name: "Ice Cream", category: .dessert),
            ]
        case .closed:
            return []
        }
    }
}
