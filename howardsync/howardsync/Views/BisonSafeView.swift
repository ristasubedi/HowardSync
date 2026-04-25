//
//  BisonSafeView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/25/26.
//

import SwiftUI
import CoreLocation

struct BisonSafeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showShareLocation = false
    @State private var locationString = "Getting location..."
    @State private var pulseAnimation = false
    
    private let emergencyContacts: [(String, String, String)] = [
        ("Campus Police", "202-806-1100", "shield.checkered"),
        ("DC Police (911)", "911", "phone.badge.checkmark"),
        ("Health Center", "202-806-7540", "cross.case"),
        ("Counseling Center", "202-806-6870", "heart.text.square"),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Emergency SOS Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(HUTheme.bisonRed.opacity(0.15))
                                .frame(width: 120, height: 120)
                                .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                                .opacity(pulseAnimation ? 0.5 : 1.0)
                            
                            Circle()
                                .fill(HUTheme.bisonRed.opacity(0.3))
                                .frame(width: 90, height: 90)
                            
                            Image(systemName: "shield.checkered")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                pulseAnimation = true
                            }
                        }
                        
                        Text("Bison Safe")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(HUTheme.bisonRed)
                        
                        Text("Emergency services & campus safety")
                            .font(HUTheme.bodyFont)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 16)
                    
                    // Quick Actions
                    VStack(spacing: 12) {
                        // Call Campus Police
                        Button {
                            callNumber("2028061100")
                        } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: "phone.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(HUTheme.bisonRed)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Call Campus Police")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("Howard University Police Dept.")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(18)
                            .background(
                                LinearGradient(
                                    colors: [HUTheme.bisonRed, Color(red: 0.65, green: 0.05, blue: 0.15)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        // Share Location
                        Button {
                            shareCurrentLocation()
                        } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(HUTheme.bisonBlue.opacity(0.12))
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: "location.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(HUTheme.bisonBlue)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Share My Location")
                                        .font(.system(size: 18, weight: .bold))
                                    
                                    Text("Send your GPS coordinates")
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(HUTheme.bisonBlue)
                            }
                            .padding(18)
                            .background(HUTheme.adaptiveCardBg)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                    
                    // Emergency Contacts
                    VStack(alignment: .leading, spacing: 14) {
                        Text("EMERGENCY CONTACTS")
                            .font(HUTheme.smallCaptionFont)
                            .foregroundColor(.secondary)
                            .tracking(1)
                            .padding(.horizontal)
                        
                        VStack(spacing: 2) {
                            ForEach(emergencyContacts, id: \.0) { name, number, icon in
                                Button {
                                    callNumber(number.replacingOccurrences(of: "-", with: ""))
                                } label: {
                                    HStack(spacing: 14) {
                                        ZStack {
                                            Circle()
                                                .fill(HUTheme.bisonRed.opacity(0.1))
                                                .frame(width: 40, height: 40)
                                            
                                            Image(systemName: icon)
                                                .font(.system(size: 16))
                                                .foregroundColor(HUTheme.bisonRed)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(name)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.primary)
                                            
                                            Text(number)
                                                .font(.system(size: 13))
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "phone.circle.fill")
                                            .font(.system(size: 28))
                                            .foregroundColor(HUTheme.safeGreen)
                                    }
                                    .padding(14)
                                    .background(HUTheme.adaptiveCardBg)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Safety Tips
                    VStack(alignment: .leading, spacing: 14) {
                        Text("SAFETY TIPS")
                            .font(HUTheme.smallCaptionFont)
                            .foregroundColor(.secondary)
                            .tracking(1)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            safetyTip("Always walk in well-lit areas at night")
                            safetyTip("Save Campus Police number in your phone")
                            safetyTip("Use the buddy system when walking late")
                            safetyTip("Report suspicious activity immediately")
                            safetyTip("Know the location of emergency blue lights on campus")
                        }
                        .padding(18)
                        .background(HUTheme.adaptiveCardBg)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .background(HUTheme.groupedBackground)
            .navigationTitle("Bison Safe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(HUTheme.bisonBlue)
                }
            }
            .sheet(isPresented: $showShareLocation) {
                ShareSheet(items: [locationString])
            }
        }
    }
    
    private func safetyTip(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 14))
                .foregroundColor(HUTheme.safeGreen)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
    }
    
    private func callNumber(_ number: String) {
        if let url = URL(string: "tel://\(number)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareCurrentLocation() {
        // Use Howard University's coordinates as default
        let latitude = 38.9225
        let longitude = -77.0197
        locationString = "🆘 I'm at Howard University campus. My location: https://maps.apple.com/?ll=\(latitude),\(longitude) — sent via Bison Safe"
        showShareLocation = true
    }
}

#Preview {
    BisonSafeView()
}
