//
//  AuthRequestStatus.swift
//  Summa
//
//  Created by Jure Babnik on 6. 8. 25.
//

import Foundation

enum AuthRequestStatus: Equatable {
    case awaiting
    case emailSent
    case error(Error?)
    
    static func == (lhs: AuthRequestStatus, rhs: AuthRequestStatus) -> Bool {
        switch (lhs, rhs) {
        case (.awaiting, .awaiting), (.emailSent, .emailSent):
            return true
        case (.error(_), .error(_)):
            return true
        default:
            return false
        }
    }
}
