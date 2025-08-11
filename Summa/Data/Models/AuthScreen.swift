//
//  AuthScreen.swift
//  Summa
//
//  Created by Jure Babnik on 11. 8. 25.
//

import Foundation

enum AuthScreen: Equatable {
    case login
    case signup
    case forgotPassword
//    case resetPassword
    case confirmEmail(String)
    case transition
    
    static func == (lhs: AuthScreen, rhs: AuthScreen) -> Bool {
        switch (lhs, rhs) {
            case (.login, .login), (.signup, .signup), (.forgotPassword, .forgotPassword), (.confirmEmail( _), .confirmEmail( _)):
            return true
        default:
            return false
        }
    }
}
