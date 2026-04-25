//
//  FeedView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import SwiftUI

struct FeedView: View {
    @State private var events: [CampusEvent] = CampusEvent.sampleEvents
    @State private var selectedCategory: EventCategory = .today
    @State private var appState = AppState.shared
    
    private var filteredEvents: [CampusEvent] {
        switch selectedCategory {
        case .today:
            return events.filter { $0.isToday }
        case .thisWeek:
            return events
        case .clubs:
            return events.filter { $0.category == .clubs }
        case .sports:
            return events.filter { $0.category == .sports }
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Bison Feed")
                        .font(.system(size: 28, weight: .bold))
                    
                    Text("Discover campus events")
                        .font(HUTheme.bodyFont)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Category filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(EventCategory.allCases, id: \.self) { category in
                            CategoryPill(
                                title: category.rawValue,
                                isSelected: selectedCategory == category
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedCategory = category
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Event Cards
                LazyVStack(spacing: 20) {
                    ForEach(filteredEvents) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            EventCard(event: event, appState: appState)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                }
                
                if filteredEvents.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary.opacity(0.4))
                        
                        Text("No events found")
                            .font(HUTheme.headlineFont)
                            .foregroundColor(.secondary)
                        
                        Text("Check back later for upcoming events")
                            .font(HUTheme.captionFont)
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                }
                
                Spacer(minLength: 100)
            }
        }
        .background(HUTheme.groupedBackground)
    }
}

// MARK: - Category Pill

struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(isSelected ? HUTheme.bisonBlue : Color(UIColor.systemGray6))
                .clipShape(Capsule())
        }
    }
}

// MARK: - Event Card

struct EventCard: View {
    let event: CampusEvent
    var appState: AppState
    @State private var heartScale: CGFloat = 1.0
    
    private var isSaved: Bool {
        appState.isEventSaved(event.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Color banner
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [event.color, event.color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 140)
                    .overlay(
                        // Decorative circle
                        Circle()
                            .fill(Color.white.opacity(0.06))
                            .frame(width: 100, height: 100)
                            .offset(x: 60, y: -30)
                        , alignment: .topTrailing
                    )
                
                // Heart button
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        heartScale = 1.4
                        appState.toggleSaveEvent(event.id)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.spring(response: 0.3)) {
                            heartScale = 1.0
                        }
                    }
                    
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.black.opacity(0.3))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: isSaved ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                            .foregroundColor(isSaved ? HUTheme.bisonRed : .white)
                            .scaleEffect(heartScale)
                    }
                }
                .padding(12)
            }
            
            // Event info
            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    Text(event.displayDate)
                        .font(HUTheme.captionFont)
                }
                .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                        .font(.system(size: 12))
                    Text(event.location)
                        .font(HUTheme.captionFont)
                }
                .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .background(HUTheme.adaptiveCardBg)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        FeedView()
    }
}
