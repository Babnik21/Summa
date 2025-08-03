//
//  AuthFlowView.swift
//  Summa
//
//  Created by Jure Babnik on 31. 7. 25.
//

import SwiftUI

enum AuthScreen {
    case login
    case signup
    case forgotPassword
    case loading
}

struct AuthFlowView: View {
    @State private var currentScreen: AuthScreen = .login
    @ObservedObject var authViewModel: AuthViewModel
    
    func transition(via state1: AuthScreen, to state2: AuthScreen) {
        withAnimation(.easeIn(duration: 0.15)) {
            currentScreen = state1
        } completion: {
            withAnimation(.easeOut(duration: 0.15)) {
                currentScreen = state2
            }
        }
    }
    
    var body: some View {
        Group {
            switch currentScreen {
            case .login:
                LogInView(loadingState: $authViewModel.loadingState, errorMessage: $authViewModel.errorMessage)
                    .onLoginTap({ form in
                        Task {
                            await authViewModel.logIn(form: form)
                        }
                    })
                    .onGoogleTap {
                        print("User: \(authViewModel.auth.currentSession?.user.email ?? "No Email")")
                    }
                    .onAppleTap {
                        print("current screen: \(currentScreen)")
                        print("loading state : \(authViewModel.loadingState)")
                    }
                    .onToggleTap {
                        authViewModel.errorMessage = nil
                        transition(via: .loading, to: .signup)
                    }
                    .onForgotPasswordTap {
                        authViewModel.errorMessage = nil
                        transition(via: .loading, to: .forgotPassword)
                    }
                    .transition(.move(edge: .leading))
            case .signup:
                SignUpView(errorMessage: $authViewModel.errorMessage)
                    .onSignupTap({ form in
                        Task {
                            await authViewModel.signUp(form: form)
                        }
                    })
                    .onToggleTap {
                        authViewModel.errorMessage = nil
                        transition(via: .loading, to: .login)
                    }
                    .transition(.move(edge: .trailing))
            case .forgotPassword:
                ForgotPasswordView(status: .constant(.awaiting), errorMessage: $authViewModel.errorMessage)
                    .onReturnTap {
                        transition(via: .loading, to: .login)
                    }
                    .transition(.move(edge: .trailing))
            case .loading:
                EmptyView()
            }
        }
    }
}

#Preview {
    AuthFlowView(authViewModel: AuthViewModel())
        .appBackground()
}
