//
//  LogoPhase.swift
//  Summa
//
//  Created by Jure Babnik on 23. 7. 25.
//

import Foundation

enum LogoPhase: CaseIterable {
    case none
    case deltoid
    case chevron
    case movedChevron
    case sigma
    case complete
    
    mutating func next() {
        switch self {
        case .none:
            self = .deltoid
        case .deltoid:
            self = .chevron
        case .chevron:
            self = .movedChevron
        case .movedChevron:
            self = .sigma
        case .sigma:
            self = .complete
        case .complete:
            self = .none
        }
    }
    
    func points(inset: CGFloat) -> [CGPoint] {
        let xInset = inset / 250
        let yInset = inset / 1.21 / 250
        
        switch self {
        case .deltoid:
            return [
                CGPoint(x: 0.3928 + xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0.3928 + xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0.5, y: 0.3508 + yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.3508 + yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.3508 + yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.3508 + yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.3508 + yInset / (1 / 2)),
                CGPoint(x: 0.6072 - xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0.5, y: 0.6492 - yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.6492 - yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.6492 - yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.6492 - yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.6492 - yInset / (1 / 2)),
                CGPoint(x: 0.3928 + xInset * 2 / sqrt(3), y: 0.5)
            ]
        case .chevron:
            return [
                CGPoint(x: 0.3928 + xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0.0428 + xInset * sqrt(3), y: 0 + yInset),
                CGPoint(x: 0.2528 - xInset / sqrt(3), y: 0 + yInset),
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.6072 - xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.2528 - xInset / sqrt(3), y: 1 - yInset),
                CGPoint(x: 0.0428 + xInset * sqrt(3), y: 1 - yInset)
            ]
        case .movedChevron:
            return [
                CGPoint(x: 0.352 + xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0 + xInset * sqrt(3), y: 0 + yInset),
                CGPoint(x: 0.21 - xInset / sqrt(3), y: 0 + yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.5622 - xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.21 - xInset / sqrt(3), y: 1 - yInset),
                CGPoint(x: 0  + xInset * sqrt(3), y: 1 - yInset)
            ]
        case .sigma:
            return [
                CGPoint(x: 0.352 + xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0 + xInset * sqrt(3), y: 0 + yInset),
                CGPoint(x: 1 - xInset * sqrt(3), y: 0 + yInset),
                CGPoint(x: 0.9009 - xInset / sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.8018 + xInset, y: 0.15 - yInset),
                CGPoint(x: 0.8018 + xInset, y: 0.15 - yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.5622 - xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.8018 + xInset, y: 0.85 + yInset),
                CGPoint(x: 0.8018 + xInset, y: 0.85 + yInset),
                CGPoint(x: 0.9009 - xInset / sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 1 - xInset * sqrt(3), y: 1 - yInset),
                CGPoint(x: 0 + xInset * sqrt(3), y: 1 - yInset)
            ]
        case .complete:
            return [
                CGPoint(x: 0.352 + xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0 + xInset * sqrt(3), y: 0 + yInset),
                CGPoint(x: 1 - xInset * sqrt(3), y: 0 + yInset),
                CGPoint(x: 0.8018 + xInset, y: 0.3 - yInset / (2 - sqrt(3))),
                CGPoint(x: 0.8018 + xInset, y: 0.3 - yInset / (2 - sqrt(3))),
                CGPoint(x: 0.8018 + xInset, y: 0.15 - yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.5622 - xInset, y: 0.5),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.8018 + xInset, y: 0.85 + yInset),
                CGPoint(x: 0.8018 + xInset, y: 0.7 + yInset / (2 - sqrt(3))),
                CGPoint(x: 0.8018 + xInset, y: 0.7 + yInset / (2 - sqrt(3))),
                CGPoint(x: 1 - xInset * sqrt(3), y: 1 - yInset),
                CGPoint(x: 0 + xInset * sqrt(3), y: 1 - yInset)
            ]
        case .none:
            return [
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5)
            ]
        }
    }
}
