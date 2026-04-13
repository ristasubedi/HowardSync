//
//  Theme.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import SwiftUI

enum HUTheme {
    // Howard University Brand Colors
    static let bisonBlue = Color(red: 0.0, green: 0.12, blue: 0.37)       // #001F5F
    static let bisonRed = Color(red: 0.78, green: 0.05, blue: 0.18)       // #C70D2E
    static let bisonWhite = Color.white
    
    // Extended Palette
    static let darkNavy = Color(red: 0.0, green: 0.08, blue: 0.25)        // #001440
    static let lightBlue = Color(red: 0.92, green: 0.95, blue: 1.0)       // #EBF2FF
    static let cardBackground = Color(red: 0.97, green: 0.97, blue: 0.98) // #F8F8FA
    static let subtleGray = Color(red: 0.6, green: 0.6, blue: 0.65)
    static let safeGreen = Color(red: 0.15, green: 0.68, blue: 0.38)
    static let warningOrange = Color(red: 0.95, green: 0.55, blue: 0.15)
    
    // Gradient for login/header
    static let bisonGradient = LinearGradient(
        colors: [darkNavy, bisonBlue, Color(red: 0.0, green: 0.2, blue: 0.55)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Text Styles
    static let titleFont = Font.system(size: 28, weight: .bold, design: .default)
    static let headlineFont = Font.system(size: 20, weight: .semibold, design: .default)
    static let bodyFont = Font.system(size: 16, weight: .regular, design: .default)
    static let captionFont = Font.system(size: 13, weight: .medium, design: .default)
    static let smallCaptionFont = Font.system(size: 11, weight: .semibold, design: .default)
}

// MARK: - Reusable Card Modifier

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
