//
//  ContentView.swift
//  Summa
//
//  Created by Jure Babnik on 15. 7. 25.
//

import SwiftUI

struct ContentView: View {
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
            AuthFlowView(launchCoordinator: launchCoordinator)
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
    ContentView()
        .appBackground()
}
