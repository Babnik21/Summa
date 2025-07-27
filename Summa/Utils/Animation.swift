//
//  Animation.swift
//  Summa
//
//  Created by Jure Babnik on 23. 7. 25.
//

import SwiftUI

extension Animation {
    static func logoCustom(duration: Double = 1) -> Animation {
        .timingCurve(1, 0, 0.66, 1, duration: duration)
    }
    
    static func logoCustomReverse(duration: Double = 1) -> Animation {
        .timingCurve(0.33, 0, 0, 1, duration: duration)
    }
    
    static func logoSlide(duration: Double = 1) -> Animation {
        .timingCurve(0.25, 0, 0.2, 0.2, duration: duration)
    }
    
    static func logoSpin(duration: Double = 1) -> Animation {
        .timingCurve(0.5, -0.25, 0.5, 1.25, duration: duration)
    }
}
