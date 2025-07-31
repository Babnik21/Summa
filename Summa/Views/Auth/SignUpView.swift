//
//  SignUpView.swift
//  Summa
//
//  Created by Jure Babnik on 31. 7. 25.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var signUpForm: SignUpForm = SignUpForm()
    @State private var isError: Bool = false
    
    var onSignupTap: ((SignUpForm) -> Void)?
    var onToggleTap: (() -> Void)?
    
    var body: some View {
        VStack {
            Group {
                Spacer()
                
                Text("Sign up")
                    .font(.title)
                
                Spacer()
                
                VStack(spacing: 10) {
                    AuthInputFieldView(text: $signUpForm.firstName, title: "First Name", placeholder: "John", isError: $isError)
                    
                    AuthInputFieldView(text: $signUpForm.lastName, title: "Last Name", placeholder: "Doe", isError: $isError)
                    
                    AuthInputFieldView(text: $signUpForm.email, title: "Email", placeholder: "example@email.com", isError: $isError)
                    
                    AuthInputFieldView(text: $signUpForm.password, title: "Password", placeholder: "Your Password", isSecureField: true, isError: $isError)
                    
                    AuthInputFieldView(text: $signUpForm.repeatPassword, title: "Repeat Password", placeholder: "Your Password", isSecureField: true, isError: $isError)
                    
                    Spacer()
                    
                    AuthButton(.custom("Sign Up"))
                        .onTap {
                            // TODO: Login
                        }
                    
                    LogInSignUpToggle(toLogin: true) {
                        // TODO: Return to Log In
                        onToggleTap?()
                        return
                    }
                    .padding(.bottom, 60)
                }
                    .padding(20)
                    .frame(maxHeight: UIScreen.main.bounds.height / 1.3)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
            }
            
        }
    }
}

extension SignUpView {
    func onSignupTap(_ action: @escaping (SignUpForm) -> Void) -> SignUpView {
        return SignUpView(signUpForm: self.signUpForm, onSignupTap: action, onToggleTap: self.onToggleTap)
    }
    
    func onToggleTap(_ action: @escaping () -> Void) -> SignUpView {
        return SignUpView(signUpForm: self.signUpForm, onSignupTap: self.onSignupTap, onToggleTap: action)
    }
}

#Preview {
    SignUpView()
        .appBackground()
}
