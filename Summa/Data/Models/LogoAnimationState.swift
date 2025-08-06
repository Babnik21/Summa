//
//  LoadingState.swift
//  Summa
//
//  Created by Jure Babnik on 28. 7. 25.
//

import Foundation

enum LogoAnimationState: Int, Comparable {
    case loading = 0
    case awaitingSpinnerAnimation = 1
    case logoAnimation = 2
    case preparingTextAnimation = 3
    case textAnimation = 4
    case logoRemoval = 5
    case finished = 6
    
    static func == (lhs: LogoAnimationState, rhs: LogoAnimationState) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    static func < (lhs: LogoAnimationState, rhs: LogoAnimationState) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    static func <= (lhs: LogoAnimationState, rhs: LogoAnimationState) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
}

