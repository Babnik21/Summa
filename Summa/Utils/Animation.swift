//
//  Animation.swift
//  Summa
//
//  Created by Jure Babnik on 23. 7. 25.
//

import SwiftUI

extension Animation {
    static func custom(duration: Double = 1) -> Animation {
        .timingCurve(1, 0, 0.66, 1, duration: duration)
    }
    
    static func customReverse(duration: Double = 1) -> Animation {
        .timingCurve(0.33, 0, 0, 1, duration: duration)
    }
}
