//
//  LogInView.swift
//  Summa
//
//  Created by Jure Babnik on 29. 7. 25.
//

import SwiftUI

struct LogInView: View {
    @ObservedObject var launchCoordinator: LaunchCoordinator
    
    var body: some View {
        VStack {
            if launchCoordinator.loadingState < .finished {
                LogoIntroView(isSignedIn: false, launchCoordinator: launchCoordinator)
                    .offset(y: launchCoordinator.loadingState >= .logoRemoval ? -UIScreen.main.bounds.height / 2 - 200 : 0)
            }
            
            if launchCoordinator.loadingState >= .logoRemoval {
                Text("Log in")
                    .font(.headline)
                    .offset(y: launchCoordinator.loadingState < .finished ? UIScreen.main.bounds.height / 2 + 200 : 0)
            }
        }
    }
}

#Preview {
    LogInView(launchCoordinator: LaunchCoordinator())
}
