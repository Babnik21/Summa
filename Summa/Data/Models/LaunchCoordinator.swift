//
//  LaunchCoordinator.swift
//  Summa
//
//  Created by Jure Babnik on 28. 7. 25.
//

import Foundation

enum loadingState: Int, Comparable {
    case loading = 0
    case awaitingSpinnerAnimation = 1
    case spinnerFinished = 2
    case logoAnimation = 3
    case preparingTextAnimation = 4
    case textAnimation = 5
    case logoRemoval = 6
    case finished = 7
    
    static func == (lhs: loadingState, rhs: loadingState) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    static func < (lhs: loadingState, rhs: loadingState) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    static func <= (lhs: loadingState, rhs: loadingState) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
}

class LaunchCoordinator: ObservableObject {
    @Published var loadingState: loadingState = .loading
    
}
