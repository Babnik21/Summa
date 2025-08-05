//
//  AuthViewModel.swift
//  Summa
//
//  Created by Jure Babnik on 3. 8. 25.
//

import Supabase
import Combine
import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var loadingState: LoadingState = .loading
    @Published var loginStatus: LoginStatus = .loading
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
                print("State changed at: \(Date()), state: \(state)")
                await updateLoginStatus()
            }
        }
    }
    
    func loadInitialSession() async {
        print("Updating login status initially")
        do {
            let session = try await auth.refreshSession()
            loginStatus = session.user.confirmedAt != nil ? .loggedIn : .pendingConfirmation
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
            loginStatus = session.user.confirmedAt != nil ? .loggedIn : .pendingConfirmation
        } catch AuthError.sessionMissing {
            loginStatus = .loggedOut
        } catch {
            loginStatus = .loggedOut
            errorMessage = error.localizedDescription
            print(errorMessage ?? "")
        }
    }
    
    func logIn(form: LogInForm) async {
        do {
            try await auth.signIn(email: form.email, password: form.password)
            print("Signed in")
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage ?? "")
        }
    }
    
    func signUp(form: SignUpForm) async {
        do {
            try await auth.signUp(email: form.email, password: form.password)
            print("Signed up")
//            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage ?? "")
        }
    }
    
    func logOut() async {
        do {
            try await auth.signOut()
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage ?? "")
        }
    }
    
    func confirmEmailFromMagicLink(url: URL) async {
        do {
            try await auth.session(from: url)
            print("Confirmed email and logged in from magic link")
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage ?? "")
        }
    }
}

