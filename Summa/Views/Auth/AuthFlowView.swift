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
    case confirmEmail
    case forgotPassword
    case loading
}

struct AuthFlowView: View {
    @State private var currentScreen: AuthScreen = .login
    @ObservedObject var launchCoordinator: LaunchCoordinator
    
    var body: some View {
        Group {
            switch currentScreen {
            case .login:
                LogInView(launchCoordinator: launchCoordinator)
                    .onToggleTap {
                        withAnimation {
                            currentScreen = .loading
                        } completion: {
                            withAnimation {
                                currentScreen = .signup
                            }
                        }
                    }
                    .transition(.move(edge: .bottom))
            case .signup:
                SignUpView()
                    .onToggleTap {
                        withAnimation {
                            currentScreen = .loading
                        } completion: {
                            withAnimation {
                                currentScreen = .login
                            }
                        }
                    }
                    .transition(.move(edge: .bottom))
            case .confirmEmail:
                EmptyView()
            case .forgotPassword:
                EmptyView()
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
