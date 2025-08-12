//
//  SignUpView.swift
//  Summa
//
//  Created by Jure Babnik on 31. 7. 25.
//

import SwiftUI

// TODO: Make it so that when typing stuff in it doesn't push the text into safe area

struct SignUpView: View {
    @StateObject private var signUpForm: SignUpForm = SignUpForm()
    @ObservedObject var authViewModel: AuthViewModel
    
    var onSignupTap: ((SignUpForm) -> Void)?
    var onToggleTap: (() -> Void)?
    
    @FocusState var focusedField: InputField?
    
    var body: some View {
        let isDisabled = Binding<Bool>(
            get: { !signUpForm.isValid || authViewModel.isLoading },
            set: { _ in }
        )
        let isError = Binding<Bool>(
            get: { authViewModel.errorMessage != nil },
            set: { newValue in
                if !newValue {
                    authViewModel.errorMessage = nil
                }
            }
        )
        
        VStack {
            Text("Sign up")
                .font(.title)
                .padding(.top, 120)
            
            Spacer()
            
            VStack(spacing: 8) {
//            ScrollView {
                AuthInputFieldView(text: $signUpForm.firstName, title: "First Name", placeholder: "John", isError: isError, focusedField: $focusedField, equals: .firstName)
                    .textContentType(.givenName)
                    .onSubmit {
                        focusedField = .lastName
                    }
                
                AuthInputFieldView(text: $signUpForm.lastName, title: "Last Name", placeholder: "Doe", isError: isError, focusedField: $focusedField, equals: .lastName)
                    .textContentType(.familyName)
                    .onSubmit {
                        focusedField = .email
                    }
                
                AuthInputFieldView(text: $signUpForm.email, title: "Email", placeholder: "example@email.com", isError: isError, focusedField: $focusedField, equals: .email)
                    .textContentType(.emailAddress)
                    .onSubmit {
                        focusedField = .password
                    }
                
                AuthInputFieldView(text: $signUpForm.password, title: "Password", placeholder: "Your Password", isSecureField: true, isError: isError, focusedField: $focusedField, equals: .password)
                    .textContentType(.newPassword)
                    .onSubmit {
                        focusedField = .confirmPassword
                    }
                
                AuthInputFieldView(text: $signUpForm.repeatPassword, title: "Repeat Password", placeholder: "Your Password", isSecureField: true, isError: isError, focusedField: $focusedField, equals: .confirmPassword)
                    .textContentType(.newPassword)
                    .submitLabel(.join)
                    .onSubmit {
                        onSignupTap?(signUpForm)
                    }
                
                HStack {
                    Text(authViewModel.errorMessage ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.defaultRed)
                    
                    Spacer()
                }
                
                Spacer()
                
                AuthButton(.custom("Sign Up"))
                    .onTap {
                        onSignupTap?(signUpForm)
                    }
                    .disabled(isDisabled)
                
                LogInSignUpToggle(toLogin: true) {
                    onToggleTap?()
                }
                .padding(.bottom, 40)
            }
                .padding(20)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.75)
                .background(.white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
                .onTapGesture {
                    focusedField = nil
                }
            
        }
    }
}

extension SignUpView {
    func onSignupTap(_ action: @escaping (SignUpForm) -> Void) -> SignUpView {
        return SignUpView(authViewModel: self.authViewModel, onSignupTap: action, onToggleTap: self.onToggleTap)
    }
    
    func onToggleTap(_ action: @escaping () -> Void) -> SignUpView {
        return SignUpView(authViewModel: self.authViewModel, onSignupTap: self.onSignupTap, onToggleTap: action)
    }
}

#Preview {
    SignUpView(authViewModel: AuthViewModel())
        .appBackground()
}
