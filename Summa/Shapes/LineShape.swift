//
//  LineShape.swift
//  Summa
//
//  Created by Jure Babnik on 23. 7. 25.
//

import SwiftUI

struct LineShape: InsettableShape {
    var phase: LogoPhase
    var insetAmount: CGFloat {
        didSet {
            points = phase.points(inset: insetAmount)
        }
    }
    var points: [CGPoint]
    
    init(phase: LogoPhase, insetAmount: CGFloat = 0) {
        self.phase = phase
        self.insetAmount = insetAmount
        self.points = phase.points(inset: insetAmount)
    }
    
    var animatableData: AnimatableLine {
        get { AnimatableLine(values: phase.points(inset: insetAmount)) }
        set { points = newValue.values }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: points[0].x * rect.width, y: points[0].y * rect.height))
        for i in 1..<points.count {
            path.addLine(to: CGPoint(x: points[i].x * rect.width, y: points[i].y * rect.height))
        }
        
        path.closeSubpath()
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var copy = self
        copy.insetAmount += amount
        return copy
    }
}

