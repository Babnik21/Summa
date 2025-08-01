//
//  InputForm.swift
//  Summa
//
//  Created by Jure Babnik on 30. 7. 25.
//

import Foundation
import SwiftUI

class LogInForm: Validatable, ObservableObject {
    @Published var email: String
    @Published var password: String
    
    init(email: String = "", password: String = "") {
        self.email = email
        self.password = password
    }
    
    var isValid: Bool {
        isEmailValid && isPasswordValid
    }
    
    // common email format
    var isEmailValid: Bool {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    // 8 characters, at least one uppercase, one lowercase and one digit
    var isPasswordValid: Bool {
        let minLength = 8
        let lowerCase = ".*[a-z]+.*"
        let upperCase = ".*[A-Z]+.*"
        let digit = ".*[0-9]+.*"
        return password.count >= minLength &&
            NSPredicate(format: "SELF MATCHES %@", lowerCase).evaluate(with: password) &&
            NSPredicate(format: "SELF MATCHES %@", upperCase).evaluate(with: password) &&
            NSPredicate(format: "SELF MATCHES %@", digit).evaluate(with: password)
    }
}


class SignUpForm: Validatable, ObservableObject {
    @Published var firstName: String
    @Published var lastName: String
    @Published var email: String
    @Published var password: String
    @Published var repeatPassword: String
    
    init(firstName: String = "", lastName: String = "", email: String = "", password: String = "", repeatPassword: String = "") {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.repeatPassword = repeatPassword
    }
    
    var isValid: Bool {
        isEmailValid && isPasswordValid && password == repeatPassword && !firstName.isEmpty && !lastName.isEmpty
    }
    
    var isEmailValid: Bool {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    var isPasswordValid: Bool {
        let minLength = 8
        let lowerCase = ".*[a-z]+.*"
        let upperCase = ".*[A-Z]+.*"
        let digit = ".*[0-9]+.*"
        return password.count >= minLength &&
            NSPredicate(format: "SELF MATCHES %@", lowerCase).evaluate(with: password) &&
            NSPredicate(format: "SELF MATCHES %@", upperCase).evaluate(with: password) &&
            NSPredicate(format: "SELF MATCHES %@", digit).evaluate(with: password)
    }
}

class ResetPasswordForm: Validatable, ObservableObject {
    @Published var email: String
    
    init(email: String = "") {
        self.email = email
    }
    
    var isValid: Bool {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
