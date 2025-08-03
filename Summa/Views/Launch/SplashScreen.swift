//
//  SplashScreen.swift
//  Summa
//
//  Created by Jure Babnik on 28. 7. 25.
//

import SwiftUI

struct SplashScreen: View {
    @Binding var loadingState: LoadingState
    @State private var rotation: Angle = .zero
    
    private let strokeWidth: CGFloat = 5
    private let logoScale: CGFloat = 0.9
    
    func animate() {
        withAnimation(.logoSpin(duration: 1)) {
            rotation = .degrees(180)
        } completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                rotation = .zero
                if loadingState == .awaitingSpinnerAnimation {
                    loadingState = .spinnerFinished
                } else {
                    animate()
                }
            }
        }

    }
    
    var body: some View {
//        VStack {
            LogoView(
                isComplete: false,
                strokeWidth: strokeWidth
            )
                .rotationEffect(rotation)
                .frame(width: 250 * logoScale, height: 305 * logoScale)
                .onAppear {
                    animate()
                }
            
//            if launchCoordinator.loadingState == .awaitingSpinnerAnimation {
//                Text("Data is Ready")
//            }
//            
//            if launchCoordinator.loadingState == .spinnerFinished {
//                Text("Animation Finished")
//            }
//            
//            Button {
//                launchCoordinator.loadingState = .awaitingSpinnerAnimation
//            } label: {
//                Capsule()
//                    .fill(Color.blue)
//                    .frame(width: 100, height: 50)
//                    .overlay {
//                        Text("Ready")
//                            .foregroundStyle(.white)
//                    }
//            }
//            
//            Button {
//                launchCoordinator.loadingState = .loading
//                animate()
//            } label: {
//                Capsule()
//                    .fill(Color.blue)
//                    .frame(width: 100, height: 50)
//                    .overlay {
//                        Text("Reset")
//                            .foregroundStyle(.white)
//                    }
//            }
//        }
    }
}

#Preview {
    SplashScreen(loadingState: .constant(.finished))
}
