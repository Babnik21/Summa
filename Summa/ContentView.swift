//
//  ContentView.swift
//  Summa
//
//  Created by Jure Babnik on 15. 7. 25.
//

import SwiftUI

struct ContentView: View {
//    @StateObject var launchCoordinator = LaunchCoordinator()
    @StateObject var authViewModel = AuthViewModel()
//    @State private var showHomeScreen: Bool? = nil
    
    var body: some View {
        Group {
            if authViewModel.loadingState <= .awaitingSpinnerAnimation {
                SplashScreen(loadingState: $authViewModel.loadingState)
            } else if authViewModel.loginStatus == .loggedIn && authViewModel.loadingState > .awaitingSpinnerAnimation {
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
            .onOpenURL { url in
                Task {
                    await authViewModel.confirmEmailFromMagicLink(url: url)
                }
            }
    }
}

#Preview {
    ContentView()
        .appBackground()
}
