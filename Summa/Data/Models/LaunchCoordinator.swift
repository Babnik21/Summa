//
//  LaunchCoordinator.swift
//  Summa
//
//  Created by Jure Babnik on 28. 7. 25.
//

import Foundation

enum loadingState {
    case loading
    case awaitingAnimation
    case finished
}

class LaunchCoordinator: ObservableObject {
    @Published var loadingState: loadingState = .loading
    
}
