//
//  LogInSignUpToggle.swift
//  Summa
//
//  Created by Jure Babnik on 31. 7. 25.
//

import SwiftUI

struct LogInSignUpToggle: View {
    var toLogin: Bool
    
    var smallText: String {
        toLogin ? "Already have an account?" : "Don't have an account?"
    }
    
    var LargeText: String {
        toLogin ? "Log In!" : "Sign Up for free!"
    }
    
    var action: (() -> Void)?
    
    init(toLogin: Bool, _ action: @escaping () -> Void) {
        self.toLogin = toLogin
        self.action = action
    }
    
    var body: some View {
        Button {
            action?()
        } label: {
            HStack {
                Text(smallText)
                    .font(.subheadline)
                
                Text(LargeText)
                    .font(.headline)
            }
                .tint(.authButtonText)
        }
    }
}

#Preview {
    LogInSignUpToggle(toLogin: true) { return }
}
