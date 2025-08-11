//
//  ContentView.swift
//  Summa
//
//  Created by Jure Babnik on 15. 7. 25.
//

import SwiftUI

enum AppState {
    case initializing
    case mainTab
//    case passwordReset
    case auth
}

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()
    @State var appState: AppState = .initializing
//    @State var isKeyboardVisible = false
    
//    @State private var offset = 0.0
    
    var body: some View {
        VStack {
            switch appState {
            case .mainTab:
                if authViewModel.isResettingPassword {
                    ResetPasswordView(isLoading: $authViewModel.isLoading, errorMessage: $authViewModel.errorMessage)
                        .onConfirmTap { form in
                            Task {
                                await authViewModel.updatePassword(newPassword: form.password, onSuccess: {
                                    authViewModel.isResettingPassword = false
                                    appState = .mainTab
                                })
                            }
                        }
                        .onReturnTap {
                            Task {
                                await authViewModel.logOut()
                            }
                            authViewModel.authRequestStatus = .awaiting
                        }
                } else {
                    Text("Hello, \(authViewModel.auth.currentSession?.user.email ?? "No User")")
                        .transition(.move(edge: .bottom))
                    
                    Button {
                        Task {
                            await authViewModel.logOut(onSuccess: {
                                appState = .auth
                            })
                        }
                    } label: {
                        Text("Sign Out")
                            .tint(.primary)
                    }
                    .transition(.move(edge: .bottom))
                }
            case .auth:
                AuthFlowView(authViewModel: authViewModel)
                    .transition(.move(edge: .bottom))
            case .initializing:
                SplashScreen(loadingState: $authViewModel.loadingState, loginStatus: $authViewModel.loginStatus)
                    .onComplete {
                        appState = authViewModel.loginStatus == .loggedIn ? .mainTab : .auth
                    }
            }
        }
            .animation(.easeInOut(duration: 0.3), value: appState)
            .onOpenURL { url in
                Task {
                    await authViewModel.handleUrl(url: url, onSuccess: {
                        if url.absoluteString.starts(with: "summa://reset-password") {
                            print("Resetting password")
                            withAnimation {
                                authViewModel.isResettingPassword = true
                            }
                        }
                    })
                }
            }
            .onChange(of: authViewModel.loginStatus) { _, newValue in
                if appState != .initializing {
                    appState = newValue == .loggedIn ? .mainTab : .auth
                }
            }
        
        Text("appState: \(appState)")
        
        Text("loginStatus: \(authViewModel.loginStatus)")
        
        Text("authScreen: \(authViewModel.authScreen)")
    }
}

#Preview {
    ContentView()
        .appBackground()
}
