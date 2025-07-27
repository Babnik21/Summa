//
//  LogoView.swift
//  Summa
//
//  Created by Jure Babnik on 23. 7. 25.
//

import SwiftUI

struct LogoView: View {
    @Binding var animationTrigger: Bool
    
    @State private var backgroundPhase: LogoPhase
    @State private var foregroundPhase: LogoPhase
    var strokeWidth: CGFloat = 8
    var onComplete: (() -> Void)?
    
    init(animationTrigger: Binding<Bool>, strokeWidth: CGFloat = 8, onComplete: (() -> Void)? = nil) {
        _animationTrigger = animationTrigger
        self.backgroundPhase = animationTrigger.wrappedValue ? .complete : .deltoid
        self.foregroundPhase = animationTrigger.wrappedValue ? .complete : .none
        self.strokeWidth = strokeWidth
        self.onComplete = onComplete
    }
    
    init (isComplete: Bool, strokeWidth: CGFloat = 8) {
        _animationTrigger = .constant(false)
        self.backgroundPhase = isComplete ? .complete : .deltoid
        self.foregroundPhase = isComplete ? .complete : .none
        self.strokeWidth = strokeWidth
    }
    
    private func playAnimation() {
        withAnimation(.logoCustom(duration: 0.2)) {
            backgroundPhase = .chevron
            foregroundPhase = .deltoid
        } completion: {
            withAnimation(.logoCustomReverse(duration: 0.2)) {
                foregroundPhase = .chevron
            } completion: {
                withAnimation(.linear(duration: 0.2)) {
                    backgroundPhase = .movedChevron
                    foregroundPhase = .movedChevron
                } completion: {
                    withAnimation(.logoCustom(duration: 0.2)) {
                        backgroundPhase = .sigma
                    } completion: {
                        withAnimation(.logoCustomReverse(duration: 0.6)) {
                            backgroundPhase = .complete
                        }
                        
                        withAnimation(.logoCustom(duration: 0.2)) {
                            foregroundPhase = .sigma
                        } completion: {
                            withAnimation(.logoCustomReverse(duration: 0.2)) {
                                foregroundPhase = .complete
                            } completion: {
                                onComplete?()
                            }
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            LineShape(phase: backgroundPhase)
                .fill(.black)
            
            LineShape(phase: foregroundPhase)
                .inset(by: strokeWidth)
                .fill(.white)
        }
        .onChange(of: animationTrigger) { oldValue, newValue in
            if oldValue == false && newValue == true {
                playAnimation()
            } else {
                backgroundPhase = .deltoid
                foregroundPhase = .none
            }
        }
    }
}

extension LogoView {
    func onComplete(onComplete: @escaping () -> Void) -> LogoView {
        return LogoView(animationTrigger: self.$animationTrigger, strokeWidth: self.strokeWidth, onComplete: onComplete)
    }
}

