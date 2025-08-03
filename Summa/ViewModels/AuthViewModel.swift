//
//  AuthViewModel.swift
//  Summa
//
//  Created by Jure Babnik on 3. 8. 25.
//

import Supabase
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var loadingState: LoadingState = .loading
    @Published var isAuthenticated: Bool? = nil
    @Published var errorMessage: String?
    
    let auth = SupabaseManager.shared.client.auth
//    let data = SupabaseManager.shared.client
    
    func logIn(form: LogInForm) async {
        do {
            try await auth.signIn(email: form.email, password: form.password)
            print("Signed in")
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage ?? "")
        }
    }
    
    func signUp(form: SignUpForm) async {
        do {
            try await auth.signUp(email: form.email, password: form.password)
            print("Signed up")
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage ?? "")
        }
    }
    
    func logOut() async {
        do {
            try await auth.signOut()
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func checkAuth() async {
        do {
            let session = try await auth.refreshSession()
            isAuthenticated = !session.user.isAnonymous
            loadingState = .awaitingSpinnerAnimation
        } catch AuthError.sessionMissing {
            isAuthenticated = false
            loadingState = .awaitingSpinnerAnimation
            print("Checked auth session - Not logged in")
            print(errorMessage ?? "")
        } catch {
            errorMessage = error.localizedDescription
            print("Checked auth session - error:")
            print(errorMessage ?? "")
        }
    }
}

