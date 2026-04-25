//
//  LoginView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import SwiftUI

struct LoginView: View {
    // MARK: - State
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var displayName = ""

    @State private var isSignUpMode = false
    @State private var isAnimating = false
    @State private var isLoading = false

    // Error banner
    @State private var showError = false
    @State private var errorMessage = ""

    // Forgot-password banner
    @State private var showResetBanner = false
    @State private var resetBannerMessage = ""

    // MARK: - Body
    var body: some View {
        ZStack {
            // Background
            HUTheme.bisonGradient
                .ignoresSafeArea()

            Circle()
                .fill(Color.white.opacity(0.03))
                .frame(width: 400, height: 400)
                .offset(x: -150, y: -300)

            Circle()
                .fill(Color.white.opacity(0.03))
                .frame(width: 300, height: 300)
                .offset(x: 180, y: 350)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer().frame(height: 80)

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

                            Text(isSignUpMode ? "Create your account" : "Your campus, connected")
                                .font(HUTheme.captionFont)
                                .foregroundColor(.white.opacity(0.7))
                                .animation(.easeInOut, value: isSignUpMode)
                        }
                        .opacity(isAnimating ? 1.0 : 0.0)
                    }

                    Spacer().frame(height: 50)

                    // Input Fields
                    VStack(spacing: 14) {

                        // Full Name (sign-up only)
                        if isSignUpMode {
                            inputField(
                                icon: "person.fill",
                                placeholder: "Full Name",
                                text: $displayName,
                                keyboardType: .default,
                                contentType: .name,
                                isSecure: false
                            )
                            .transition(.asymmetric(
                                insertion: .move(edge: .top).combined(with: .opacity),
                                removal: .move(edge: .top).combined(with: .opacity)
                            ))
                        }

                        // Email
                        inputField(
                            icon: "envelope.fill",
                            placeholder: isSignUpMode ? "bison.howard.edu email" : "Email or Student ID",
                            text: $email,
                            keyboardType: .emailAddress,
                            contentType: .emailAddress,
                            isSecure: false
                        )

                        // Password
                        inputField(
                            icon: "lock.fill",
                            placeholder: "Password",
                            text: $password,
                            keyboardType: .default,
                            contentType: isSignUpMode ? .newPassword : .password,
                            isSecure: true
                        )

                        // Confirm Password (sign-up only)
                        if isSignUpMode {
                            inputField(
                                icon: "lock.rotation",
                                placeholder: "Confirm Password",
                                text: $confirmPassword,
                                keyboardType: .default,
                                contentType: .newPassword,
                                isSecure: true
                            )
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .move(edge: .bottom).combined(with: .opacity)
                            ))
                        }

                        // Error Banner
                        if showError {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 13))
                                Text(errorMessage)
                                    .font(.system(size: 13, weight: .medium))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .foregroundColor(.yellow)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        // Password Reset Banner
                        if showResetBanner {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 13))
                                Text(resetBannerMessage)
                                    .font(.system(size: 13, weight: .medium))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .foregroundColor(.green)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(.horizontal, 32)
                    .offset(y: isAnimating ? 0 : 30)
                    .opacity(isAnimating ? 1.0 : 0.0)

                    Spacer().frame(height: 28)

                    // Buttons
                    VStack(spacing: 14) {

                        // Primary: Sign In / Create Account
                        Button {
                            isSignUpMode ? signUp() : signIn()
                        } label: {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: HUTheme.bisonBlue))
                                } else {
                                    Text(isSignUpMode ? "Create Account" : "Sign In")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(HUTheme.bisonBlue)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                        .disabled(isLoading)

                        // SSO (sign-in mode only — HU SAML not yet configured)
                        if !isSignUpMode {
                            Button {
                                // TODO: HU SAML/SSO — requires institutional IdP setup
                            } label: {
                                Text("Howard University SSO")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(HUTheme.bisonRed)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .disabled(isLoading)
                            .transition(.opacity)
                        }
                    }
                    .padding(.horizontal, 32)
                    .offset(y: isAnimating ? 0 : 30)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.25), value: isSignUpMode)

                    Spacer().frame(height: 20)

                    // Footer Links
                    VStack(spacing: 12) {
                        // Forgot Password (sign-in only)
                        if !isSignUpMode {
                            Button {
                                handleForgotPassword()
                            } label: {
                                Text("Forgot Password?")
                                    .font(HUTheme.captionFont)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .transition(.opacity)
                        }

                        // Toggle sign-in / sign-up
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isSignUpMode.toggle()
                                clearFields()
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(isSignUpMode ? "Already have an account?" : "Don't have an account?")
                                    .foregroundColor(.white.opacity(0.6))
                                Text(isSignUpMode ? "Sign In" : "Sign Up")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                            .font(.system(size: 14))
                        }
                    }
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.25), value: isSignUpMode)

                    Spacer().frame(height: 40)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }

    // MARK: - Input Field Builder

    @ViewBuilder
    private func inputField(
        icon: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType,
        contentType: UITextContentType,
        isSecure: Bool
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 20)

            if isSecure {
                SecureField(placeholder, text: text)
                    .foregroundColor(.white)
                    .textContentType(contentType)
            } else {
                TextField(placeholder, text: text)
                    .foregroundColor(.white)
                    .autocapitalization(contentType == .emailAddress ? .none : .words)
                    .keyboardType(keyboardType)
                    .textContentType(contentType)
            }
        }
        .padding()
        .background(Color.white.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }

    // MARK: - Actions

    private func signIn() {
        clearBanners()
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            show(error: "Please enter your email and password.")
            return
        }
        isLoading = true
        Task {
            do {
                try await AuthService.shared.signIn(email: trimmedEmail, password: password)
            } catch {
                await MainActor.run { show(error: firebaseErrorMessage(error)) }
            }
            await MainActor.run { isLoading = false }
        }
    }

    private func signUp() {
        clearBanners()
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        let trimmedName  = displayName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { show(error: "Please enter your full name."); return }
        guard !trimmedEmail.isEmpty else { show(error: "Please enter your email address."); return }
        guard password == confirmPassword else { show(error: "Passwords don't match."); return }
        guard password.count >= 6 else { show(error: "Password must be at least 6 characters."); return }
        isLoading = true
        Task {
            do {
                try await AuthService.shared.signUp(
                    email: trimmedEmail,
                    password: password,
                    displayName: trimmedName
                )
            } catch {
                await MainActor.run { show(error: firebaseErrorMessage(error)) }
            }
            await MainActor.run { isLoading = false }
        }
    }

    private func handleForgotPassword() {
        clearBanners()
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        guard !trimmedEmail.isEmpty else {
            show(error: "Enter your email above, then tap Forgot Password.")
            return
        }
        Task {
            do {
                try await AuthService.shared.sendPasswordReset(email: trimmedEmail)
                await MainActor.run {
                    withAnimation {
                        resetBannerMessage = "Reset link sent to \(trimmedEmail)"
                        showResetBanner = true
                    }
                }
            } catch {
                await MainActor.run { show(error: firebaseErrorMessage(error)) }
            }
        }
    }

    // MARK: - Helpers

    private func show(error: String) {
        withAnimation {
            errorMessage = error
            showError = true
        }
    }

    private func clearBanners() {
        withAnimation {
            showError = false
            showResetBanner = false
        }
    }

    private func clearFields() {
        email = ""
        password = ""
        confirmPassword = ""
        displayName = ""
        clearBanners()
    }
}

#Preview {
    LoginView()
}
