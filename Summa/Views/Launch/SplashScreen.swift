//
//  SplashScreen.swift
//  Summa
//
//  Created by Jure Babnik on 28. 7. 25.
//

import SwiftUI

struct SplashScreen: View {
    @Binding var loadingState: LogoAnimationState
    @Binding var loginStatus: LoginStatus
    
    @State var rotation: Angle = .zero
    @State var logoScale: CGFloat = 0.9
    @State var logoOffset: CGFloat = 0
    private let screenWidth = UIScreen.main.bounds.width
    let strokeWidth: CGFloat = 5
    
    var onComplete: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 0) {
            LogoView(
                loadingState: $loadingState,
                strokeWidth: strokeWidth
            )
            .onComplete {
                finishAnimation {
                    onComplete?()
                }
            }
            .rotationEffect(rotation)
            .frame(width: 250 * logoScale, height: 305 * logoScale)
            .offset(x: loadingState >= .preparingTextAnimation ? 16 : 0)
            .onAppear {
                animate()
            }
            
            if loadingState >= .preparingTextAnimation {
                TitleTextView(loadingState: $loadingState, animationDuration: 0.5)
                    .onComplete {
                        removeLogo {
                            onComplete?()
                        }
                    }
                    .offset(x: -16)
            }
        }
            .offset(x: logoOffset, y: loadingState >= .logoRemoval ? -UIScreen.main.bounds.height / 2 - 200 : 0)

    }
}

extension SplashScreen {
    func onComplete(_ action: @escaping () -> Void) -> SplashScreen {
        return SplashScreen(loadingState: self.$loadingState, loginStatus: self.$loginStatus, rotation: self.rotation, logoScale: self.logoScale, logoOffset: self.logoOffset, onComplete: action)
    }
}

// Animation functions
extension SplashScreen {
    private func animate() {
        withAnimation(.logoSpin(duration: 1)) {
            rotation = .degrees(180)
        } completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                rotation = .zero
                if loadingState == .awaitingSpinnerAnimation {
                    loadingState = .logoAnimation
                } else {
                    animate()
                }
            }
        }
    }
    
    private func finishAnimation(_ completion: @escaping () -> Void) {
        withAnimation(.easeIn(duration: 0.3)) {
            logoScale = 0
        } completion: {
            if loginStatus == .loggedIn {
                loadingState = .finished
                completion()
            } else {
                animateText(completion)
            }
        }
    }
    
    private func animateText(_ completion: @escaping () -> Void) {
        logoOffset = screenWidth / 2 - 50
        loadingState = .preparingTextAnimation
        withAnimation(.easeOut(duration: 0.5)) {
            logoScale = 0.4
        } completion: {
            withAnimation(.logoSlide(duration: 0.6)) {
                logoOffset = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    loadingState = .textAnimation
                }
            }
        }
    }
    
    private func removeLogo(_ completion: @escaping () -> Void) {
        withAnimation(.easeIn(duration: 0.3)) {
            loadingState = .logoRemoval
        } completion: {
            withAnimation {
                loadingState = .finished
            } completion: {
                completion()
            }
        }
    }
}

#Preview {
    SplashScreen(loadingState: .constant(.finished), loginStatus: .constant(.loggedIn))
}
