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
    case auth
}

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()
    @State var appState: AppState = .initializing
    
//    @State private var offset = 0.0
    
    var body: some View {
        VStack {
            switch appState {
            case .mainTab:
                // This will be merged into MainTabView

                    //                HomeView()
                Text("Hello, \(authViewModel.auth.currentSession?.user.email ?? "No User")")
                    .transition(.move(edge: .bottom))

                Button {
                    Task {
                        await authViewModel.logOut()
                    }
                } label: {
                    Text("Sign Out")
                        .tint(.primary)
                }
                    .transition(.move(edge: .bottom))
            case .auth:
                AuthFlowView(authViewModel: authViewModel)
                    .transition(.move(edge: .bottom))
            case .initializing:
                SplashScreen(loadingState: $authViewModel.loadingState, loginStatus: $authViewModel.loginStatus)
                    .onComplete {
                        appState = authViewModel.loginStatus == .loggedIn ? .mainTab : .auth
                    }
            }
            
//            if authViewModel.loadingState <= .awaitingSpinnerAnimation {
//                SplashScreen(loadingState: $authViewModel.loadingState)
//            } else if authViewModel.loginStatus == .loggedIn && authViewModel.loadingState > .awaitingSpinnerAnimation {
//                if authViewModel.loadingState < .finished {
//                    LogoIntroView(isSignedIn: true, loadingState: $authViewModel.loadingState)
//                } else {
//                    //                HomeView()
//                    Text("Hello, \(SupabaseManager.shared.client.auth.currentSession?.user.email ?? "No User")")
////                        .transition(.move(edge: .bottom))
// 
//                    Button {
//                        Task {
//                            await authViewModel.logOut()
//                        }
//                    } label: {
//                        Text("Sign Out")
//                            .tint(.primary)
//                    }
////                    .transition(.move(edge: .bottom))
//                }
//            } else {
//                AuthFlowView(authViewModel: authViewModel)
////                    .transition(.move(edge: .bottom))
//            }
        }
            .animation(.easeInOut(duration: 0.3), value: appState)
            .onOpenURL { url in
                Task {
                    await authViewModel.confirmEmail(url: url)
                }
            }
            .onChange(of: authViewModel.loginStatus) { _, newValue in
                if appState != .initializing {
                    appState = newValue == .loggedIn ? .mainTab : .auth
                }
            }
    }
}

#Preview {
    ContentView()
        .appBackground()
}
