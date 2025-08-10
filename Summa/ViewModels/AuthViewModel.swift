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

enum AuthScreen: Equatable {
    case login
    case signup
    case forgotPassword
    case confirmEmail(String)
    case transition
    
    static func == (lhs: AuthScreen, rhs: AuthScreen) -> Bool {
        switch (lhs, rhs) {
            case (.login, .login), (.signup, .signup), (.forgotPassword, .forgotPassword), (.confirmEmail( _), .confirmEmail( _)):
            return true
        default:
            return false
        }
    }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var loadingState: LogoAnimationState = .loading
    @Published var loginStatus: LoginStatus = .none
    @Published var authScreen: AuthScreen = .login
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    let auth: AuthClient
//    let data = SupabaseManager.shared.client
    
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
        print("Updating login status initially")
        do {
            defer {
                isLoading = false
            }
            isLoading = true
            let session = try await auth.refreshSession()
            loginStatus = session.user.confirmedAt != nil ? .loggedIn : .loggedOut
            loadingState = .awaitingSpinnerAnimation
        } catch AuthError.sessionMissing {
            loginStatus = .loggedOut
            loadingState = .awaitingSpinnerAnimation
            print("Checked auth session - Not logged in")
            print(errorMessage ?? "")
        } catch {
            loginStatus = .loggedOut
            loadingState = .awaitingSpinnerAnimation
            errorMessage = error.localizedDescription
            print("Checked auth session - error:")
            print(errorMessage ?? "")
        }
    }
    
    func updateLoginStatus() async {
        do {
            let session = try await auth.session
            if session.user.confirmedAt != nil {
                loginStatus = .loggedIn
            } else {
                loginStatus = .loggedOut
                authScreen = .confirmEmail(session.user.email ?? "No Email")
            }
        } catch let error as AuthError {
            handleAuthError(error)
        } catch {
            handleError(error)
        }
    }
    
    func logIn(form: LogInForm, onSuccess: (() -> Void)? = nil, onError: (() -> Void)? = nil) async {
        do {
            defer {
                isLoading = false
            }
            isLoading = true
            try await auth.signIn(email: form.email, password: form.password)
            onSuccess?()
            print("Signed in")
        } catch let error as AuthError {
            handleAuthError(error, email: form.email)
            onError?()
        } catch {
            handleError(error)
            onError?()
        }
    }
    
    func signUp(form: SignUpForm, onSuccess: (() -> Void)? = nil, onError: (() -> Void)? = nil) async {
        do {
            defer {
                isLoading = false
            }
            isLoading = true
            try await auth.signUp(email: form.email, password: form.password, data: [
                "first_name": .string(form.firstName),
                "last_name": .string(form.lastName)
            ])
            print("Signed up")
            authScreen = .confirmEmail(form.email.lowercased())
            onSuccess?()
        } catch let error as AuthError {
            handleAuthError(error)
            onError?()
        } catch {
            handleError(error)
            onError?()
        }
    }
    
    func logOut(onSuccess: (() -> Void)? = nil, onError: (() -> Void)? = nil) async {
        do {
            defer {
                isLoading = false
            }
            isLoading = true
            try await auth.signOut()
            authScreen = .login
            onSuccess?()
        } catch let error as AuthError {
            handleAuthError(error)
            onError?()
        } catch {
            handleError(error)
            onError?()
        }
    }
    
    func resendConfirmation(email: String, onSuccess: (() -> Void)? = nil, onError: (() -> Void)? = nil) async {
        do {
            defer {
                isLoading = false
            }
            isLoading = true
            try await auth.resend(
                email: email,
                type: .signup
//                emailRedirectTo: URL(string: "my-app-scheme://")
            )
            onSuccess?()
        } catch let error as AuthError {
            handleAuthError(error)
            onError?()
        } catch {
            handleError(error)
            onError?()
        }
    }
    
    func confirmEmail(url: URL) async {
        do {
            defer {
                isLoading = false
            }
            isLoading = true
            try await auth.session(from: url)
            print("Confirmed email and logged in from email url")
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage ?? "")
        }
    }
}

// Handle Auth Errors
extension AuthViewModel {
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
