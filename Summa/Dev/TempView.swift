//
//  TempView.swift
//  Summa
//
//  Created by Jure Babnik on 18. 7. 25.
//

import SwiftUI

struct TempView: View {
    @State private var isReady: Bool = false
    @State private var isFinished: Bool = false
    @State private var rotation: Angle = .zero
    private let strokeWidth: CGFloat = 5
    
    private let logoScale: CGFloat = 0.9
    
    func animate() {
        withAnimation(.logoSpin(duration: 1)) {
            rotation = .degrees(180)
        } completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                rotation = .zero
                if isReady {
                    isFinished = true
                } else {
                    animate()
                }
            }
        }

    }
    
    var body: some View {
        VStack {
            LogoView(
                isComplete: false,
                strokeWidth: strokeWidth
            )
                .rotationEffect(rotation)
                .frame(width: 250 * logoScale, height: 305 * logoScale)
                .onAppear {
                    animate()
                }
            
            if isReady {
                Text("Data is Ready")
            }
            
            if isFinished {
                Text("Animation Finished")
            }
            
            Button {
                isReady = true
            } label: {
                Capsule()
                    .fill(Color.blue)
                    .frame(width: 100, height: 50)
                    .overlay {
                        Text("Ready")
                            .foregroundStyle(.white)
                    }
            }
            
            Button {
                isReady = false
                isFinished = false
                animate()
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
