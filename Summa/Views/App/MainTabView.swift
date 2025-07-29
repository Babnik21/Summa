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
            switch launchCoordinator.loadingState {
            case .logoAnimation:
                LogoIntroView(isSignedIn: true, launchCoordinator: launchCoordinator)
            case .finished:
//                HomeView()
                EmptyView()
            default:
                Text("Error")
            }
        case false:
            LogoIntroView(isSignedIn: false, launchCoordinator: launchCoordinator)
        default:
            SplashScreen(launchCoordinator: launchCoordinator)
                .onChange(of: launchCoordinator.loadingState) { _, newValue in
                    if newValue == .spinnerFinished {
                        isSignedIn = false
                    }
                }
        }
    }
}

#Preview {
    MainTabView()
}
