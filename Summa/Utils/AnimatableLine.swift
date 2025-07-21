//
//  AnimatableLine.swift
//  Summa
//
//  Created by Jure Babnik on 20. 7. 25.
//

import SwiftUI

struct AnimatableLine: VectorArithmetic {
    var values: [CGPoint]
    
    var magnitudeSquared: Double {
        return values.map { $0.x * $0.x + $0.y * $0.y }.reduce(0, +)
    }
    
    mutating func scale(by rhs: Double) {
        values = values.map { CGPoint(x: $0.x * rhs, y: $0.y * rhs) }
    }
    
    static var zero: AnimatableLine {
        return AnimatableLine(values: [CGPoint(x: 0, y: 0)])
    }
    
    static func - (lhs: AnimatableLine, rhs: AnimatableLine) -> AnimatableLine {
        return AnimatableLine(values: zip(lhs.values, rhs.values).map{
            return CGPoint(x: $0.x - $1.x, y: $0.y - $1.y)
        })
    }
    
    static func -= (lhs: inout AnimatableLine, rhs: AnimatableLine) {
        lhs = lhs - rhs
    }
    
    static func + (lhs: AnimatableLine, rhs: AnimatableLine) -> AnimatableLine {
        return AnimatableLine(values: zip(lhs.values, rhs.values).map{
            return CGPoint(x: $0.x + $1.x, y: $0.y + $1.y)
        })
    }
    
    static func += (lhs: inout AnimatableLine, rhs: AnimatableLine) {
        lhs = lhs + rhs
    }
}
