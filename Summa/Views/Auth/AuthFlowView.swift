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
    @State private var errorMessage: String?
    @ObservedObject var launchCoordinator: LaunchCoordinator
//    @ObservedObject var authViewModel: AuthViewModel
    
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
                LogInView(launchCoordinator: launchCoordinator, errorMessage: $errorMessage)
                    .onToggleTap {
                        transition(via: .loading, to: .signup)
                    }
                    .onForgotPasswordTap {
                        transition(via: .loading, to: .forgotPassword)
                    }
                    .transition(.move(edge: .leading))
            case .signup:
                SignUpView(errorMessage: $errorMessage)
                    .onToggleTap {
                        transition(via: .loading, to: .login)
                    }
                    .transition(.move(edge: .trailing))
            case .forgotPassword:
                ForgotPasswordView(status: .constant(.awaiting), errorMessage: $errorMessage)
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
    AuthFlowView(launchCoordinator: LaunchCoordinator())
        .appBackground()
}
