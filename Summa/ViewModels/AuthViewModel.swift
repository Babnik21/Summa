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
    case loading
    
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
        transition(via: .loading, to: state)
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
        print("Updating login status")
        do {
            let session = try await auth.session
            if session.user.confirmedAt != nil {
                loginStatus = .loggedIn
            } else {
                loginStatus = .loggedOut
                authScreen = .confirmEmail(session.user.email ?? "No Email")
            }
        } catch AuthError.sessionMissing {
            loginStatus = .loggedOut
        } catch {
            loginStatus = .loggedOut
            errorMessage = error.localizedDescription
            print(errorMessage ?? "")
        }
    }
    
    func logIn(form: LogInForm, onSuccess: (() -> Void)? = nil, onError: (() -> Void)? = nil) async {
        do {
            try await auth.signIn(email: form.email, password: form.password)
            onSuccess?()
            print("Signed in")
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage ?? "")
            onError?()
        }
    }
    
    func signUp(form: SignUpForm, onSuccess: (() -> Void)? = nil, onError: (() -> Void)? = nil) async {
        do {
            try await auth.signUp(email: form.email, password: form.password)
            print("Signed up")
            authScreen = .confirmEmail(form.email.lowercased())
            onSuccess?()
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage ?? "")
            onError?()
        }
    }
    
    func logOut(onSuccess: (() -> Void)? = nil, onError: (() -> Void)? = nil) async {
        do {
            try await auth.signOut()
            onSuccess?()
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage ?? "")
            onError?()
        }
    }
    
    func confirmEmail(url: URL) async {
        do {
            try await auth.session(from: url)
            print("Confirmed email and logged in from email url")
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage ?? "")
        }
    }
}

