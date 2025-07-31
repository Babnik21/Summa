//
//  AppBackground.swift
//  Summa
//
//  Created by Jure Babnik on 30. 7. 25.
//

import SwiftUI

extension View {
    func appBackground(_ color: Color = .greenDefault) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(color)
    }
}
