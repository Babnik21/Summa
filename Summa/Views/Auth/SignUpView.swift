//
//  SignUpView.swift
//  Summa
//
//  Created by Jure Babnik on 31. 7. 25.
//

import SwiftUI

// TODO: Make it so that when typing stuff in it doesn't push the text into safe area

struct SignUpView: View {
    @StateObject var signUpForm: SignUpForm = SignUpForm()
    @Binding var errorMessage: String?
    
    var onSignupTap: ((SignUpForm) -> Void)?
    var onToggleTap: (() -> Void)?
    
    var body: some View {
        let isError = Binding<Bool>(
            get: { errorMessage != nil },
            set: { newValue in
                if !newValue {
                    errorMessage = nil
                }
            }
        )
        
        VStack {
            Spacer()
            
            Text("Sign up")
                .font(.title)
            
            Spacer()
            
            VStack(spacing: 10) {
                AuthInputFieldView(text: $signUpForm.firstName, title: "First Name", placeholder: "John", isError: isError)
                
                AuthInputFieldView(text: $signUpForm.lastName, title: "Last Name", placeholder: "Doe", isError: isError)
                
                AuthInputFieldView(text: $signUpForm.email, title: "Email", placeholder: "example@email.com", isError: isError)
                
                AuthInputFieldView(text: $signUpForm.password, title: "Password", placeholder: "Your Password", isSecureField: true, isError: isError)
                
                AuthInputFieldView(text: $signUpForm.repeatPassword, title: "Repeat Password", placeholder: "Your Password", isSecureField: true, isError: isError)
                
                HStack {
                    Text(errorMessage ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.defaultRed)
                    
                    Spacer()
                }
                
                Spacer()
                
                AuthButton(.custom("Sign Up"))
                    .onTap {
                        onSignupTap?(signUpForm)
                    }
                
                LogInSignUpToggle(toLogin: true) {
                    onToggleTap?()
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

extension SignUpView {
    func onSignupTap(_ action: @escaping (SignUpForm) -> Void) -> SignUpView {
        return SignUpView(signUpForm: self.signUpForm, errorMessage: self.$errorMessage, onSignupTap: action, onToggleTap: self.onToggleTap)
    }
    
    func onToggleTap(_ action: @escaping () -> Void) -> SignUpView {
        return SignUpView(signUpForm: self.signUpForm, errorMessage: self.$errorMessage, onSignupTap: self.onSignupTap, onToggleTap: action)
    }
}

#Preview {
    SignUpView(errorMessage: .constant("Test"))
        .appBackground()
}
