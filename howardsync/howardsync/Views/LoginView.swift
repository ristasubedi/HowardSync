//
//  LoginView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var isAnimating = false
    @State private var showError = false
    
    var body: some View {
        ZStack {
            // Background gradient
            HUTheme.bisonGradient
                .ignoresSafeArea()
            
            // Subtle pattern overlay
            Circle()
                .fill(Color.white.opacity(0.03))
                .frame(width: 400, height: 400)
                .offset(x: -150, y: -300)
            
            Circle()
                .fill(Color.white.opacity(0.03))
                .frame(width: 300, height: 300)
                .offset(x: 180, y: 350)
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 80)
                
                // Logo
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(width: 80, height: 80)
                            .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
                        
                        Text("H")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundColor(HUTheme.bisonBlue)
                    }
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    
                    VStack(spacing: 6) {
                        Text("Howard Sync")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Your campus, connected")
                            .font(HUTheme.captionFont)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .opacity(isAnimating ? 1.0 : 0.0)
                }
                
                Spacer()
                    .frame(height: 60)
                
                // Input Fields
                VStack(spacing: 16) {
                    // Email field
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.white.opacity(0.5))
                            .frame(width: 20)
                        
                        TextField("Email or Student ID", text: $email)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    .padding()
                    .background(Color.white.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    
                    // Password field
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white.opacity(0.5))
                            .frame(width: 20)
                        
                        SecureField("Password", text: $password)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 32)
                .offset(y: isAnimating ? 0 : 30)
                .opacity(isAnimating ? 1.0 : 0.0)
                
                Spacer()
                    .frame(height: 32)
                
                // Buttons
                VStack(spacing: 14) {
                    // Sign In button
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            isLoggedIn = true
                        }
                    } label: {
                        Text("Sign In")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(HUTheme.bisonBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                    
                    // SSO button
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            isLoggedIn = true
                        }
                    } label: {
                        Text("Howard University SSO")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(HUTheme.bisonRed)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.horizontal, 32)
                .offset(y: isAnimating ? 0 : 30)
                .opacity(isAnimating ? 1.0 : 0.0)
                
                Spacer()
                    .frame(height: 20)
                
                // Forgot password
                Button {
                    // TODO: Implement forgot password
                } label: {
                    Text("Forgot Password?")
                        .font(HUTheme.captionFont)
                        .foregroundColor(.white.opacity(0.7))
                }
                .opacity(isAnimating ? 1.0 : 0.0)
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
