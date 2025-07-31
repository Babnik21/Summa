//
//  LogoIntroSignedOut.swift
//  Summa
//
//  Created by Jure Babnik on 26. 7. 25.
//

import SwiftUI

struct LogoIntroView: View {
    let isSignedIn: Bool
    @ObservedObject var launchCoordinator: LaunchCoordinator
    
    private let strokeWidth: CGFloat = 5
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    @State private var logoScale: CGFloat = 0.9
    @State private var logoOffset: CGFloat = 0
    
    private func removeLogo() {
        withAnimation {
            launchCoordinator.loadingState = .logoRemoval
        } completion: {
            withAnimation {
                launchCoordinator.loadingState = .finished
            }
        }
    }
    
    // New animation
    private func animate() {
        withAnimation(.easeIn(duration: 0.5)) {
            logoScale = 0
        } completion: {
            if isSignedIn {
                removeLogo()
            } else {
                logoOffset = screenWidth / 2 - 50
                launchCoordinator.loadingState = .preparingTextAnimation
                withAnimation(.easeOut(duration: 0.5)) {
                    logoScale = 0.4
                } completion: {
                    withAnimation(.logoSlide(duration: 0.6)) {
                        logoOffset = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            launchCoordinator.loadingState = .textAnimation
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
            HStack(spacing: 0) {
                LogoView(
                    launchCoordinator: launchCoordinator,
                    strokeWidth: strokeWidth
                )
                    .onComplete {
                        animate()
                    }
                    .frame(width: 250 * logoScale, height: 305 * logoScale)
                    .offset(x: launchCoordinator.loadingState >= .preparingTextAnimation ? 16 : 0)
                
                if launchCoordinator.loadingState >= .preparingTextAnimation {
                    TitleTextView(launchCoordinator: launchCoordinator, animationDuration: 0.5)
                        .onComplete {
                            removeLogo()
                        }
                        .offset(x: -16)
                }
            }
                .offset(x: logoOffset)
                .onAppear {
                    launchCoordinator.loadingState = .logoAnimation
                }
    }
}

#Preview {
    LogoIntroView(isSignedIn: false, launchCoordinator: LaunchCoordinator())
}
