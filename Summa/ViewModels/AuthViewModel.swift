//
//  AuthViewModel.swift
//  Summa
//
//  Created by Jure Babnik on 3. 8. 25.
//

import Supabase
import Combine
import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var loadingState: LogoAnimationState = .loading
    @Published var loginStatus: LoginStatus = .none
    @Published var authRequestStatus: AuthRequestStatus = .awaiting
    @Published var isResettingPassword: Bool = false
    @Published var authScreen: AuthScreen = .login
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    let auth: AuthClient
    
    private var authListenerTask: Task<Void, Never>?
    
    init() {
        self.auth = SupabaseManager.shared.client.auth
        
        Task {
            await loadInitialSession()
        }
        
        // Listen for auth state changes
        self.authListenerTask = Task {
            for await state in auth.authStateChanges {
                print("State changed at: \(Date()), event: \(state.event)")
                await updateLoginStatus()
            }
        }
    }
    
    func transition(to state: AuthScreen) {
        transition(via: .transition, to: state)
    }
    
    func transition(via state1: AuthScreen, to state2: AuthScreen) {
        self.authScreen = state1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.authScreen = state2
        }
    }
    
    func loadInitialSession() async {
        do {
            defer {
                loadingState = .awaitingSpinnerAnimation
                isLoading = false
            }
            isLoading = true
            let session = try await auth.refreshSession()
            loginStatus = session.user.confirmedAt != nil ? .loggedIn : .loggedOut
        } catch AuthError.sessionMissing {
            loginStatus = .loggedOut
            print("Checked auth session - Not logged in")
            print(errorMessage ?? "")
        } catch {
            loginStatus = .loggedOut
            errorMessage = error.localizedDescription
            print("Checked auth session - error:")
            print(errorMessage ?? "")
        }
    }
    
    func updateLoginStatus() async {
        await authDoCatch({
            let session = try await auth.session
            if session.user.confirmedAt != nil {
                loginStatus = .loggedIn
            } else {
                print("session is not nil but email is not confirmed.")
                loginStatus = .loggedOut
                authScreen = .confirmEmail(session.user.email ?? "No Email")
            }
        })
//        do {
//            let session = try await auth.session
//            if session.user.confirmedAt != nil {
//                loginStatus = .loggedIn
//            } else {
//                print("session is not nil but email is not confirmed.")
//                loginStatus = .loggedOut
//                authScreen = .confirmEmail(session.user.email ?? "No Email")
//            }
//        } catch let error as AuthError {
//            handleAuthError(error)
//        } catch {
//            handleError(error)
//        }
    }
    
    func logIn(form: LogInForm, onSuccess: (() -> Void)? = nil, onError: ((Error) -> Void)? = nil) async {
        await authDoCatch({
            try await auth.signIn(email: form.email, password: form.password)
            print("Signed in")
        }, onSuccess: onSuccess, onError: onError)
//        do {
//            defer {
//                isLoading = false
//            }
//            isLoading = true
//            try await auth.signIn(email: form.email, password: form.password)
//            onSuccess?()
//            print("Signed in")
//        } catch let error as AuthError {
//            handleAuthError(error, email: form.email)
//            onError?()
//        } catch {
//            handleError(error)
//            onError?()
//        }
    }
    
    func signUp(form: SignUpForm, onSuccess: (() -> Void)? = nil, onError: ((Error) -> Void)? = nil) async {
        await authDoCatch({
            try await auth.signUp(email: form.email, password: form.password, data: [
                "first_name": .string(form.firstName),
                "last_name": .string(form.lastName)
            ], redirectTo: URL(string: "summa://confirm-email"))
            print("Signed up")
            authScreen = .confirmEmail(form.email.lowercased())
        }, onSuccess: onSuccess, onError: onError)
//        do {
//            defer {
//                isLoading = false
//            }
//            isLoading = true
//            try await auth.signUp(email: form.email, password: form.password, data: [
//                "first_name": .string(form.firstName),
//                "last_name": .string(form.lastName)
//            ], redirectTo: URL(string: "summa://confirm-email"))
//            print("Signed up")
//            authScreen = .confirmEmail(form.email.lowercased())
//            onSuccess?()
//        } catch let error as AuthError {
//            handleAuthError(error)
//            onError?()
//        } catch {
//            handleError(error)
//            onError?()
//        }
    }
    
    func logOut(onSuccess: (() -> Void)? = nil, onError: ((Error) -> Void)? = nil) async {
        await authDoCatch({
            try await auth.signOut()
            loginStatus = .loggedOut
        }, onSuccess: onSuccess, onError: onError)
//        do {
//            defer {
//                isLoading = false
//            }
//            isLoading = true
//            try await auth.signOut()
//            loginStatus = .loggedOut
//            onSuccess?()
//        } catch let error as AuthError {
//            handleAuthError(error)
//            onError?()
//        } catch {
//            handleError(error)
//            onError?()
//        }
    }
    
    func sendConfirmation(email: String, onSuccess: (() -> Void)? = nil, onError: ((Error) -> Void)? = nil) async {
        await authDoCatch({
            try await auth.resend(
                email: email,
                type: .signup,
                emailRedirectTo: URL(string: "summa://confirm-email")
            )
            authRequestStatus = .success
        }, onSuccess: onSuccess, onError: onError)
//        do {
//            defer {
//                isLoading = false
//            }
//            isLoading = true
//            try await auth.resend(
//                email: email,
//                type: .signup,
//                emailRedirectTo: URL(string: "summa://confirm-email")
//            )
//            onSuccess?()
//        } catch let error as AuthError {
//            handleAuthError(error)
//            onError?()
//        } catch {
//            handleError(error)
//            onError?()
//        }
    }
    
    func sendPasswordReset(email: String, onSuccess: (() -> Void)? = nil, onError: ((Error) -> Void)? = nil) async {
        await authDoCatch({
            try await auth.resetPasswordForEmail(
                email,
                redirectTo: URL(string: "summa://reset-password")
            )
            print("Password reset email sent.")
        }, onSuccess: onSuccess, onError: onError)
//        do {
//            defer {
//                isLoading = false
//            }
//            isLoading = true
//            try await auth.resetPasswordForEmail(
//                email,
//                redirectTo: URL(string: "summa://reset-password")
//            )
//            print("Password reset email sent.")
//            onSuccess?()
//        } catch let error as AuthError {
//            handleAuthError(error)
//            onError?()
//        } catch {
//            handleError(error)
//            onError?()
//        }
    }
    
    func updatePassword(newPassword: String, onSuccess: (() -> Void)? = nil, onError: ((Error) -> Void)? = nil) async {
        await authDoCatch({
            try await auth.update(user: UserAttributes(password: newPassword))
            print("Password updated successfully.")
            isResettingPassword = false
        }, onSuccess: onSuccess, onError: onError)
//        do {
//            try await auth.update(user: UserAttributes(password: newPassword))
//            print("Password updated successfully.")
//            isResettingPassword = false
//            onSuccess?()
//        } catch let error as AuthError {
//            handleAuthError(error)
//            onError?()
//        } catch {
//            handleError(error)
//            onError?()
//        }
    }
    
    func handleUrl(url: URL, onSuccess: (() -> Void)? = nil, onError: ((Error) -> Void)? = nil) async {
        await authDoCatch({
            try await auth.session(from: url)
            print("Confirmed email and logged in from email url")
        }, onSuccess: onSuccess, onError: onError)
//        do {
//            defer {
//                isLoading = false
//            }
//            isLoading = true
//            try await auth.session(from: url)
//            print("Confirmed email and logged in from email url")
//            onSuccess?()
//        } catch let error as AuthError {
//            handleAuthError(error)
//            onError?()
//        } catch {
//            handleError(error)
//            onError?()
//        }
    }
}

// MARK: Common Error Handling
extension AuthViewModel {
    private func authDoCatch(_ block: () async throws -> Void, onSuccess: (() -> Void)? = nil, onError: ((Error) -> Void)? = nil) async {
        do {
            defer {
                isLoading = false
            }
            isLoading = true
            try await block()
            onSuccess?()
        } catch let error as AuthError {
            handleAuthError(error)
            onError?(error)
        } catch {
            handleError(error)
            onError?(error)
        }
    }
    
    
    private func handleAuthError(_ error: AuthError, email: String? = nil) {
        switch error {
        case .sessionMissing:
            authScreen = .login
        case .api(message: let message, errorCode: let code, underlyingData: _, underlyingResponse: _):
            switch code {
            case .emailExists:
                errorMessage = "Email already exists"
            case .invalidCredentials:
                errorMessage = "Invalid email or password"
            case .samePassword:
                errorMessage = "New password must be different from current password"
            case .weakPassword:
                errorMessage = "Please chooes a stronger password"
            case .emailNotConfirmed:
                authScreen = .confirmEmail(email?.lowercased() ?? "")
            case .sessionNotFound, .sessionExpired:
                authScreen = .login
            default:
                errorMessage = error.localizedDescription
                print(errorMessage ?? "")
                print(message)
            }
        default:
            errorMessage = error.localizedDescription
            print(errorMessage ?? "")
            print(error)
        }
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        print(errorMessage ?? "")
        print(error)
    }
}
