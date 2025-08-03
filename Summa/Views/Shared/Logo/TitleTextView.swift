//
//  TitleTextView.swift
//  Summa
//
//  Created by Jure Babnik on 23. 7. 25.
//

import SwiftUI

struct TitleTextView: View {
    @Binding var loadingState: LoadingState
    var fontSize: CGFloat = 48
    var animationDuration: Double = 1
    
    @State private var transitionStart: CGFloat = 0
    @State private var transitionEnd: CGFloat = 0
    
    var onComplete: (() -> Void)?
    
    var body: some View {
        AnimatableGradient(startPoint: transitionStart, endPoint: transitionEnd)
            .frame(width: 146, height: 100)
            .mask {
                SmallCapsText("Summa", fontSize: fontSize)
            }
            .onChange(of: loadingState) { _, newValue in
                if loadingState == .textAnimation {
                    withAnimation(.linear(duration: 0.1 * animationDuration)) {
                        transitionEnd = 0.1
                    } completion: {
                        withAnimation(.linear(duration: 0.8 * animationDuration)) {
                            transitionEnd = 1
                            transitionStart = 0.9
                        } completion: {
                            withAnimation(.linear(duration: 0.1 * animationDuration)) {
                                transitionStart = 1
                            } completion: {
                                onComplete?()
                            }
                        }
                    }
                }
            }
    }
}

extension TitleTextView {
    func onComplete(_ action: @escaping () -> Void) -> some View {
        return TitleTextView(loadingState: self.$loadingState, animationDuration: self.animationDuration, onComplete: action)
    }
}

#Preview {
    TitleTextView(loadingState: .constant(.finished))
}
