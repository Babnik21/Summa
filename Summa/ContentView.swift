//
//  ContentView.swift
//  Summa
//
//  Created by Jure Babnik on 15. 7. 25.
//

import SwiftUI

// TODO: Rework intro view so that the logged-in animation is built into splash screen
// TODO: That way LogoIntroView can be removed

struct ContentView: View {
//    @StateObject var launchCoordinator = LaunchCoordinator()
    @StateObject var authViewModel = AuthViewModel()
//    @State private var showHomeScreen: Bool? = nil
    
    var body: some View {
        Group {
            if authViewModel.loadingState <= .awaitingSpinnerAnimation {
                SplashScreen(loadingState: $authViewModel.loadingState)
            } else if authViewModel.isAuthenticated ?? true && authViewModel.loadingState > .awaitingSpinnerAnimation {
                if authViewModel.loadingState < .finished {
                    LogoIntroView(isSignedIn: true, loadingState: $authViewModel.loadingState)
                } else {
                    //                HomeView()
                    Text("Hello, \(SupabaseManager.shared.client.auth.currentSession?.user.email ?? "No User")")
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
                }
            } else {
                AuthFlowView(authViewModel: authViewModel)
                    .transition(.move(edge: .bottom))
            }
        }
            .onAppear {
                Task {
                    await authViewModel.checkAuth()
                }
            }
//            .onChange(of: authViewModel.loadingState) { _, newValue in
//                if newValue == .spinnerFinished {
//                    showHomeScreen = authViewModel.isAuthenticated
//                }
//            }
    }
}

#Preview {
    ContentView()
        .appBackground()
}
