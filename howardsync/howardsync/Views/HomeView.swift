//
//  HomeView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import SwiftUI

struct HomeView: View {
    let user: User
    let nextClass: ClassSchedule
    let events: [CampusEvent]
    
    @State private var showBisonSafe = false
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning,"
        case 12..<17: return "Good afternoon,"
        default: return "Good evening,"
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                // Greeting
                VStack(alignment: .leading, spacing: 2) {
                    Text(greeting)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(user.name.split(separator: " ").first.map(String.init) ?? user.name)
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Next Class Card
                nextClassCard
                
                // Bison Safe
                bisonSafeCard
                
                // Dining Preview
                diningPreviewCard
                
                // Upcoming Events
                upcomingEventsCard
                
                Spacer(minLength: 100)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .alert("Bison Safe", isPresented: $showBisonSafe) {
            Button("Call Campus Police", role: .destructive) {}
            Button("Share Location", role: .none) {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Emergency services and safety features")
        }
    }
    
    // MARK: - Next Class Card
    
    private var nextClassCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("NEXT CLASS")
                .font(HUTheme.smallCaptionFont)
                .foregroundColor(.white.opacity(0.8))
                .tracking(1)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(nextClass.courseCode)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.system(size: 13))
                        Text(nextClass.timeString)
                            .font(HUTheme.captionFont)
                    }
                    .foregroundColor(.white.opacity(0.85))
                    
                    Text(nextClass.locationString)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.85))
                }
                
                Spacer()
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "location.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 14, weight: .semibold))
                }
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [HUTheme.bisonBlue, Color(red: 0.0, green: 0.2, blue: 0.55)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal)
    }
    
    // MARK: - Bison Safe Card
    
    private var bisonSafeCard: some View {
        Button {
            showBisonSafe = true
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(HUTheme.bisonRed.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "shield.checkered")
                        .font(.system(size: 22))
                        .foregroundColor(HUTheme.bisonRed)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Bison Safe")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(HUTheme.bisonRed)
                    
                    Text("Campus Safety & Emergency")
                        .font(HUTheme.captionFont)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(HUTheme.bisonRed.opacity(0.5))
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(16)
            .background(HUTheme.bisonRed.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.horizontal)
    }
    
    // MARK: - Dining Preview
    
    private var diningPreviewCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("DINING")
                        .font(HUTheme.smallCaptionFont)
                        .foregroundColor(.secondary)
                        .tracking(1)
                    
                    Text("Blackburn")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Text("View today's menu")
                        .font(HUTheme.captionFont)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    Text("15 min")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(HUTheme.warningOrange)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(HUTheme.warningOrange.opacity(0.12))
                .clipShape(Capsule())
            }
            
            HStack {
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary.opacity(0.5))
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .padding(18)
        .cardStyle()
        .padding(.horizontal)
    }
    
    // MARK: - Upcoming Events
    
    private var upcomingEventsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("UPCOMING EVENTS")
                        .font(HUTheme.smallCaptionFont)
                        .foregroundColor(.secondary)
                        .tracking(1)
                    
                    Text("Today")
                        .font(.system(size: 20, weight: .semibold))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary.opacity(0.5))
                    .font(.system(size: 14, weight: .semibold))
            }
            
            let todayEvents = events.filter { $0.isToday }.prefix(2)
            ForEach(Array(todayEvents)) { event in
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(event.color)
                        .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.title)
                            .font(.system(size: 15, weight: .semibold))
                        
                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.system(size: 11))
                                Text(event.displayDate)
                                    .font(.system(size: 12))
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "mappin")
                                    .font(.system(size: 11))
                                Text(event.location)
                                    .font(.system(size: 12))
                            }
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(18)
        .cardStyle()
        .padding(.horizontal)
    }
}

#Preview {
    HomeView(
        user: .sample,
        nextClass: ClassSchedule.sampleSchedule[0],
        events: CampusEvent.sampleEvents
    )
}
