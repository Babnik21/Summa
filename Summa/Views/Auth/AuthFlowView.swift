//
//  AuthFlowView.swift
//  Summa
//
//  Created by Jure Babnik on 31. 7. 25.
//

import SwiftUI

struct AuthFlowView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            switch authViewModel.authScreen {
            case .login:
                LogInView(authViewModel: authViewModel)
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
                SignUpView(authViewModel: authViewModel)
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
                ConfirmEmailView(email: email, authViewModel: authViewModel)
                    .onResendTap {
                        Task {
                            await authViewModel.sendConfirmation(email: email, onSuccess: {
                                authViewModel.authRequestStatus = .success
                            }, onError: { error in
                                authViewModel.authRequestStatus = .error(error)
                            })
                        }
                    }
                    .onSignOutTap {
                        Task {
                            await authViewModel.logOut()
                        }
                        authViewModel.authRequestStatus = .awaiting
                    }
            case .forgotPassword:
                ForgotPasswordView(authViewModel: authViewModel)
                    .onConfirmTap{ form in
                        Task {
                            await authViewModel.sendPasswordReset(email: form.email, onSuccess: {
                                authViewModel.authRequestStatus = .success
                            }, onError: { error in
                                authViewModel.authRequestStatus = .error(error)
                            })
                        }
                    }
                    .onReturnTap {
                        authViewModel.transition(via: .transition, to: .login)
                        authViewModel.authRequestStatus = .awaiting
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
