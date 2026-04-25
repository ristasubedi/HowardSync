//
//  DiningView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import SwiftUI

struct DiningView: View {
    @State private var diningHalls: [DiningHall] = DiningHall.sampleHalls
    @State private var selectedHallIndex = 0
    @State private var showFullMenu = false
    @State private var isLoading = true
    @State private var mealPeriod = "Lunch"
    
    private let diningService = MockDiningService.shared
    
    private var selectedHall: DiningHall {
        guard selectedHallIndex < diningHalls.count else {
            return DiningHall.sampleHalls[0]
        }
        return diningHalls[selectedHallIndex]
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Dining")
                        .font(.system(size: 28, weight: .bold))
                    
                    Text("Today's menus & wait times")
                        .font(HUTheme.bodyFont)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Meal Period Indicator
                HStack(spacing: 8) {
                    Image(systemName: mealPeriodIcon)
                        .font(.system(size: 14))
                    Text(mealPeriod)
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(HUTheme.bisonBlue)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(HUTheme.bisonBlue.opacity(0.1))
                .clipShape(Capsule())
                .padding(.horizontal)
                
                // Hall selector
                HStack(spacing: 0) {
                    ForEach(Array(diningHalls.enumerated()), id: \.element.id) { index, hall in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedHallIndex = index
                            }
                        } label: {
                            Text(hall.name)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(selectedHallIndex == index ? HUTheme.bisonBlue : .secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    selectedHallIndex == index
                                    ? HUTheme.adaptiveCardBg
                                    : Color.clear
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding(4)
                .background(Color(UIColor.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                
                if isLoading {
                    // Loading State
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading menu...")
                            .font(HUTheme.captionFont)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 60)
                } else {
                    // Status Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Status")
                                .font(.system(size: 20, weight: .semibold))
                            
                            Spacer()
                            
                            Text(selectedHall.statusText)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(selectedHall.isOpen ? HUTheme.safeGreen : HUTheme.bisonRed)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 5)
                                .background(
                                    (selectedHall.isOpen ? HUTheme.safeGreen : HUTheme.bisonRed).opacity(0.12)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        
                        // Wait time
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(HUTheme.warningOrange.opacity(0.12))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "clock")
                                    .font(.system(size: 18))
                                    .foregroundColor(HUTheme.warningOrange)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Wait Time")
                                    .font(.system(size: 15, weight: .semibold))
                                
                                Text(selectedHall.waitTimeText)
                                    .font(HUTheme.captionFont)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Busyness
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(HUTheme.bisonBlue.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "person.2")
                                    .font(.system(size: 16))
                                    .foregroundColor(HUTheme.bisonBlue)
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Busyness")
                                    .font(.system(size: 15, weight: .semibold))
                                
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color(UIColor.systemGray5))
                                            .frame(height: 8)
                                        
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(busynessColor)
                                            .frame(width: geo.size.width * selectedHall.busynessLevel, height: 8)
                                            .animation(.easeInOut(duration: 0.5), value: selectedHall.busynessLevel)
                                    }
                                }
                                .frame(height: 8)
                            }
                        }
                    }
                    .padding(20)
                    .cardStyle()
                    .padding(.horizontal)
                    
                    // Menu Preview
                    VStack(alignment: .leading, spacing: 16) {
                        Text("TODAY'S MENU")
                            .font(HUTheme.smallCaptionFont)
                            .foregroundColor(.white.opacity(0.7))
                            .tracking(1)
                        
                        HStack {
                            Text(mealPeriod)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button {
                                showFullMenu = true
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        
                        // Menu items (first 4)
                        if selectedHall.menuItems.isEmpty {
                            Text("No items available")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.6))
                        } else {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(selectedHall.menuItems.prefix(4)) { item in
                                    HStack(spacing: 10) {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 8, height: 8)
                                        
                                        Text(item.name)
                                            .font(.system(size: 15))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        
                        // View Full Menu button
                        Button {
                            showFullMenu = true
                        } label: {
                            Text("View Full Menu")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(HUTheme.bisonBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding(20)
                    .background(
                        LinearGradient(
                            colors: [HUTheme.darkNavy, HUTheme.bisonBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 100)
            }
        }
        .background(HUTheme.groupedBackground)
        .refreshable {
            await loadDiningData()
        }
        .sheet(isPresented: $showFullMenu) {
            FullMenuView(hall: selectedHall)
        }
        .task {
            await loadDiningData()
        }
    }
    
    private func loadDiningData() async {
        isLoading = true
        do {
            let halls = try await diningService.fetchDiningHalls()
            withAnimation {
                diningHalls = halls
                mealPeriod = diningService.currentMealPeriod.rawValue
                isLoading = false
            }
        } catch {
            withAnimation {
                isLoading = false
            }
        }
    }
    
    private var busynessColor: Color {
        switch selectedHall.busynessLevel {
        case 0..<0.35: return HUTheme.safeGreen
        case 0.35..<0.65: return HUTheme.warningOrange
        default: return HUTheme.bisonRed
        }
    }
    
    private var mealPeriodIcon: String {
        switch mealPeriod {
        case "Breakfast": return "sunrise"
        case "Lunch": return "sun.max"
        case "Dinner": return "moon.stars"
        default: return "moon.zzz"
        }
    }
}

// MARK: - Full Menu View

struct FullMenuView: View {
    let hall: DiningHall
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(MenuCategory.allCases, id: \.self) { category in
                    let items = hall.menuItems.filter { $0.category == category }
                    if !items.isEmpty {
                        Section(category.rawValue) {
                            ForEach(items) { item in
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(HUTheme.bisonBlue.opacity(0.15))
                                        .frame(width: 36, height: 36)
                                        .overlay(
                                            Image(systemName: iconFor(category))
                                                .font(.system(size: 14))
                                                .foregroundColor(HUTheme.bisonBlue)
                                        )
                                    
                                    Text(item.name)
                                        .font(.system(size: 16))
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .navigationTitle("\(hall.name) Menu")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(HUTheme.bisonBlue)
                }
            }
        }
    }
    
    private func iconFor(_ category: MenuCategory) -> String {
        switch category {
        case .entree: return "fork.knife"
        case .side: return "leaf"
        case .dessert: return "birthday.cake"
        }
    }
}

#Preview {
    DiningView()
}
