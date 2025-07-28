//
//  MainTabView.swift
//  Summa
//
//  Created by Jure Babnik on 28. 7. 25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var launchCoordinator = LaunchCoordinator()
//    @StateObject var authviewModel = AuthViewModel()
    @State private var isSignedIn: Bool? = nil
    
    var body: some View {
        switch isSignedIn {
        case true:
            Text("Signed in")
        case false:
            LogoIntroSignedOut()
        default:
            SplashScreen(launchCoordinator: launchCoordinator)
                .onChange(of: launchCoordinator.loadingState) { _, newValue in
                    if newValue == .finished {
                        isSignedIn = false
                    }
                }
        }
    }
}

#Preview {
    MainTabView()
}
