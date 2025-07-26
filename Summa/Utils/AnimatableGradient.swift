//
//  AnimatableGradient.swift
//  Summa
//
//  Created by Jure Babnik on 25. 7. 25.
//

import SwiftUI

struct AnimatableGradient: View, Animatable {
    var startColor: Color
    var endColor: Color
    var startPoint: CGFloat
    var endPoint: CGFloat
    
    public init(
        startColor: Color = .black,
        endColor: Color = .clear,
        startPoint: CGFloat = 0,
        endPoint: CGFloat = 0
    ) {
        self.startColor = startColor
        self.endColor = endColor
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(startPoint, endPoint) }
        set {
            startPoint = newValue.first
            endPoint = newValue.second
        }
    }
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(stops:[
                Gradient.Stop(color: startColor, location: startPoint),
                Gradient.Stop(color: endColor, location: endPoint)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

struct AnimatableGradientModifier: AnimatableModifier {
    var startColor: Color
    var endColor: Color
    var startPoint: CGFloat
    var endPoint: CGFloat

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(startPoint, endPoint) }
        set {
            startPoint = newValue.first
            endPoint = newValue.second
        }
    }

    func body(content: Content) -> some View {
        content
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: startColor, location: startPoint),
                        .init(color: endColor, location: endPoint)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
}

extension View {
    func animatableGradient(
        startColor: Color = .black,
        endColor: Color = .clear,
        startPoint: CGFloat = 0.0,
        endPoint: CGFloat = 1.0
    ) -> some View {
        modifier(AnimatableGradientModifier(
            startColor: startColor,
            endColor: endColor,
            startPoint: startPoint,
            endPoint: endPoint
        ))
    }
}
