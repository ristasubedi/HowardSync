//
//  EventDetailView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/25/26.
//

import SwiftUI

struct EventDetailView: View {
    let event: CampusEvent
    @Environment(\.dismiss) private var dismiss
    @State private var appState = AppState.shared
    @State private var showShareSheet = false
    @State private var heartScale: CGFloat = 1.0
    
    private var isSaved: Bool {
        appState.isEventSaved(event.id)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Banner
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [event.color, event.color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 260)
                    
                    // Decorative circles
                    Circle()
                        .fill(Color.white.opacity(0.06))
                        .frame(width: 200, height: 200)
                        .offset(x: 200, y: -50)
                    
                    Circle()
                        .fill(Color.white.opacity(0.04))
                        .frame(width: 150, height: 150)
                        .offset(x: -40, y: 160)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        
                        // Category badge
                        Text(event.categoryBadge)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                        
                        Spacer().frame(height: 12)
                        
                        Text(event.title)
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(3)
                    }
                    .padding(24)
                }
                
                // Details Section
                VStack(alignment: .leading, spacing: 24) {
                    // Date & Time
                    HStack(spacing: 16) {
                        DetailRow(
                            icon: "calendar",
                            iconColor: HUTheme.bisonBlue,
                            title: "Date",
                            value: event.dateString
                        )
                        
                        Spacer()
                        
                        DetailRow(
                            icon: "clock",
                            iconColor: HUTheme.warningOrange,
                            title: "Time",
                            value: event.time
                        )
                    }
                    
                    Divider()
                    
                    // Location
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(HUTheme.safeGreen.opacity(0.12))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(HUTheme.safeGreen)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Location")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text(event.location)
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    
                    Divider()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About This Event")
                            .font(.system(size: 18, weight: .bold))
                        
                        Text(event.description)
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        // Save Button
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                heartScale = 1.3
                                appState.toggleSaveEvent(event.id)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.spring(response: 0.3)) {
                                    heartScale = 1.0
                                }
                            }
                            
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            
                            // Schedule/remove notification
                            if appState.isEventSaved(event.id) {
                                NotificationService.shared.scheduleEventReminder(
                                    title: event.title,
                                    location: event.location,
                                    eventID: event.id
                                )
                            } else {
                                NotificationService.shared.removeEventReminder(eventID: event.id)
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: isSaved ? "heart.fill" : "heart")
                                    .font(.system(size: 18))
                                    .scaleEffect(heartScale)
                                
                                Text(isSaved ? "Saved" : "Save Event")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundColor(isSaved ? .white : HUTheme.bisonRed)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(isSaved ? HUTheme.bisonRed : HUTheme.bisonRed.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        
                        // Share Button
                        Button {
                            showShareSheet = true
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 16))
                                
                                Text("Share Event")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundColor(HUTheme.bisonBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(HUTheme.bisonBlue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(24)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(HUTheme.groupedBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        heartScale = 1.3
                        appState.toggleSaveEvent(event.id)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.spring(response: 0.3)) {
                            heartScale = 1.0
                        }
                    }
                } label: {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(isSaved ? HUTheme.bisonRed : .white)
                        .scaleEffect(heartScale)
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            let shareText = "Check out \(event.title) at \(event.location) on \(event.dateString) at \(event.time)! 🦬 #HowardSync"
            ShareSheet(items: [shareText])
        }
    }
}

// MARK: - Detail Row

struct DetailRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
            }
        }
    }
}

// MARK: - Share Sheet (UIKit wrapper)

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        EventDetailView(event: CampusEvent.sampleEvents[0])
    }
}
