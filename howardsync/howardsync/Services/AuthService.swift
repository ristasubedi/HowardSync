//
//  AuthService.swift
//  howardsync
//
//  Created by HowardSync on 4/25/26.
//

import SwiftUI
import FirebaseAuth

/// Wraps FirebaseAuth and publishes auth state changes to the rest of the app.
@Observable
final class AuthService {

    // MARK: - Singleton
    static let shared = AuthService()

    // MARK: - Published State
    /// The currently signed-in Firebase user, or nil if signed out.
    private(set) var firebaseUser: FirebaseAuth.User?

    /// Convenience: true when a user session is active.
    var isSignedIn: Bool { firebaseUser != nil }

    // MARK: - Private
    private var authStateHandle: AuthStateDidChangeListenerHandle?

    private init() {
        // Listen for Firebase auth state changes (handles app-relaunch persistence)
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            self.firebaseUser = user
            if let user {
                // Sync Firebase user into AppState
                self.syncToAppState(firebaseUser: user)
            }
        }
    }

    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: - Sign In

    /// Signs in with email and password.
    /// - Throws: Firebase `AuthErrorCode` on failure.
    func signIn(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        syncToAppState(firebaseUser: result.user)
    }

    // MARK: - Sign Up

    /// Creates a new Firebase account. Restricted to @bison.howard.edu emails.
    /// - Throws: `AuthServiceError.invalidDomain` if email is not a Howard address,
    ///           or Firebase `AuthErrorCode` on other failures.
    func signUp(email: String, password: String, displayName: String) async throws {
        // Domain restriction
        guard email.lowercased().hasSuffix("@bison.howard.edu") else {
            throw AuthServiceError.invalidDomain
        }

        let result = try await Auth.auth().createUser(withEmail: email, password: password)

        // Set display name
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = displayName.trimmingCharacters(in: .whitespaces)
        try await changeRequest.commitChanges()

        syncToAppState(firebaseUser: result.user)
    }

    // MARK: - Sign Out

    /// Signs out the current user.
    func signOut() throws {
        try Auth.auth().signOut()
        // firebaseUser will become nil via the state listener
        AppState.shared.clearSession()
    }

    // MARK: - Password Reset

    /// Sends a password-reset email to the given address.
    func sendPasswordReset(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    // MARK: - Helpers

    /// Maps the Firebase user into AppState so the rest of the app can use local user data.
    private func syncToAppState(firebaseUser: FirebaseAuth.User) {
        let displayName = firebaseUser.displayName ?? ""
        let email = firebaseUser.email ?? ""
        let uid = firebaseUser.uid

        // Only overwrite the stored user if it differs (avoid unnecessary saves)
        var user = AppState.shared.currentUser
        if user.id != uid || user.name != displayName || user.email != email {
            user = User(
                id: uid,
                name: displayName.isEmpty ? email.components(separatedBy: "@").first ?? "Bison" : displayName,
                email: email,
                major: AppState.shared.currentUser.major,
                graduationYear: AppState.shared.currentUser.graduationYear,
                gpa: AppState.shared.currentUser.gpa,
                eventsCount: AppState.shared.currentUser.eventsCount,
                classesCount: AppState.shared.currentUser.classesCount
            )
            AppState.shared.currentUser = user
        }
        AppState.shared.setLoggedIn(true)
    }
}

// MARK: - Custom Errors

enum AuthServiceError: LocalizedError {
    case invalidDomain

    var errorDescription: String? {
        switch self {
        case .invalidDomain:
            return "Please use your @bison.howard.edu email address to create an account."
        }
    }
}

// MARK: - Firebase Error → Friendly Message

extension AuthErrorCode {
    /// Returns a user-friendly message for common Firebase Auth errors.
    var friendlyMessage: String {
        switch self {
        case .wrongPassword:
            return "Incorrect password. Please try again."
        case .invalidEmail:
            return "That doesn't look like a valid email address."
        case .userNotFound:
            return "No account found with that email. Try signing up."
        case .emailAlreadyInUse:
            return "An account with this email already exists. Try signing in."
        case .weakPassword:
            return "Password must be at least 6 characters."
        case .networkError:
            return "Network error. Check your connection and try again."
        case .tooManyRequests:
            return "Too many attempts. Please wait a moment and try again."
        case .userDisabled:
            return "This account has been disabled. Contact support."
        default:
            return "Something went wrong. Please try again."
        }
    }
}

/// Convenience: extract a friendly message from any Error thrown by FirebaseAuth.
func firebaseErrorMessage(_ error: Error) -> String {
    if let authError = error as? AuthServiceError {
        return authError.localizedDescription
    }
    let nsError = error as NSError
    if let code = AuthErrorCode(rawValue: nsError.code) {
        return code.friendlyMessage
    }
    return error.localizedDescription
}
