//
//  AuthFlowView.swift
//  Summa
//
//  Created by Jure Babnik on 31. 7. 25.
//

import SwiftUI

// TODO: Disable buttons when loading

struct AuthFlowView: View {
//    @State private var currentScreen: AuthScreen = .login
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            switch authViewModel.authScreen {
            case .login:
                LogInView(isLoading: $authViewModel.isLoading, errorMessage: $authViewModel.errorMessage)
                    .onLoginTap({ form in
                        Task {
                            await authViewModel.logIn(form: form)
                        }
                    })
                    .onGoogleTap {
                        print("User: \(authViewModel.auth.currentSession?.user.email ?? "No Email")")
                    }
                    .onAppleTap {
                        print("current screen: \(authViewModel.authScreen)")
                        print("loading state : \(authViewModel.loadingState)")
                    }
                    .onToggleTap {
                        authViewModel.errorMessage = nil
                        authViewModel.transition(via: .transition, to: .signup)
                    }
                    .onForgotPasswordTap {
                        authViewModel.errorMessage = nil
                        authViewModel.transition(via: .transition, to: .forgotPassword)
                    }
            case .signup:
                SignUpView(isLoading: $authViewModel.isLoading, errorMessage: $authViewModel.errorMessage)
                    .onSignupTap({ form in
                        Task {
                            await authViewModel.signUp(form: form)
                        }
                    })
                    .onToggleTap {
                        authViewModel.errorMessage = nil
                        authViewModel.transition(via: .transition, to: .login)
                    }
            case .confirmEmail (let email):
                ConfirmEmailView(email: email, errorMessage: $authViewModel.errorMessage)
                    .onResendTap {
                        //TODO: Resend Email
                        Task {
                            await authViewModel.resendConfirmation(email: email)
                        }
                    }
                    .onSignOutTap {
                        Task {
                            await authViewModel.logOut()
                        }
                    }
            case .forgotPassword:
                ForgotPasswordView(status: .constant(.awaiting), errorMessage: $authViewModel.errorMessage)
                    .onReturnTap {
                        authViewModel.transition(via: .transition, to: .login)
                    }
            case .transition:
                EmptyView()
            }
        }
            .transition(.move(edge: .bottom))
            .animation(.easeInOut(duration: 0.15), value: authViewModel.authScreen)
    }
}

#Preview {
    AuthFlowView(authViewModel: AuthViewModel())
        .appBackground()
}
