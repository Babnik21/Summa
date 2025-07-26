//
//  TempView.swift
//  Summa
//
//  Created by Jure Babnik on 18. 7. 25.
//

import SwiftUI


struct TempView: View {
    @State private var logoAnimationTrigger: Bool = false
    @State private var showText: Bool = false
    @State private var textAnimationTrigger: Bool = false
    
    private let strokeWidth: CGFloat = 5
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    @State private var logoScale: CGFloat = 1
    @State private var logoOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            
            HStack(spacing: 0) {
                LogoView(
                    animationTrigger: $logoAnimationTrigger,
                    strokeWidth: strokeWidth
                )
                    .onComplete {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showText = true
                            logoOffset = screenWidth / 2 - 50
                            logoScale = 0.4
                        } completion: {
                            withAnimation(.logoSlide(duration: 0.6)) {
                                logoOffset = 0
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    textAnimationTrigger = true
                                }
                            }
                        }
                    }
                    .frame(width: 250 * logoScale, height: 305 * logoScale)
                    .offset(x: showText ? 16 : 0)
                
                if showText {
                    TitleTextView(animationTrigger: $textAnimationTrigger, animationDuration: 0.5)
                        .offset(x: -16)
                }
            }
            .offset(x: logoOffset)

            
            Button {
                logoAnimationTrigger = true
            } label: {
                Capsule()
                    .fill(Color.blue)
                    .frame(width: 100, height: 50)
                    .overlay {
                        Text("Animate")
                            .foregroundStyle(.white)
                    }
            }
        
            Button {
                logoAnimationTrigger = false
                textAnimationTrigger = false
                showText = false
                logoScale = 1
            } label: {
                Capsule()
                    .fill(Color.blue)
                    .frame(width: 100, height: 50)
                    .overlay {
                        Text("Reset")
                            .foregroundStyle(.white)
                    }
            }
        }
    }
}

#Preview {
    TempView()
}
