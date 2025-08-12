//
//  LogInView.swift
//  Summa
//
//  Created by Jure Babnik on 29. 7. 25.
//

import SwiftUI

enum InputField {
    case email
    case password
    case confirmPassword
    case firstName
    case lastName
    case none
}

struct LogInView: View {
    @StateObject private var logInForm: LogInForm = LogInForm()
    @ObservedObject var authViewModel: AuthViewModel
    
    var onLoginTap: ((LogInForm) -> Void)?
    var onGoogleTap: (() -> Void)?
    var onAppleTap: (() -> Void)?
    var onForgotPasswordTap: (() -> Void)?
    var onToggleTap: (() -> Void)?
    
    @FocusState var focusedField: InputField?
    
    var body: some View {
        let isDisabled = Binding<Bool>(
            get: { !logInForm.isValid || authViewModel.isLoading },
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
            Text("Log in")
                .font(.title)
                .padding(.top, 120)
            
            Spacer()
            
            VStack(spacing: 8) {
                AuthInputFieldView(text: $logInForm.email, title: "Email", placeholder: "example@email.com", isError: isError, focusedField: $focusedField, equals: .email)
                    .textContentType(.emailAddress)
                    .onSubmit {
                        focusedField = .password
                    }
                
                AuthInputFieldView(text: $logInForm.password, title: "Password", placeholder: "Your Password", isSecureField: true, isError: isError, focusedField: $focusedField, equals: .password)
                    .textContentType(.password)
                    .submitLabel(.go)
                    .onSubmit {
                        onLoginTap?(logInForm)
                    }
                
                HStack {
                    Text(authViewModel.errorMessage ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.defaultRed)
                    
                    Spacer()
                    
                    Button {
                        onForgotPasswordTap?()
                    } label: {
                        Text("Forgot Password?")
                            .font(.subheadline)
                            .tint(.primary)
                    }
                }
                
                Spacer()
                
                AuthButton(.custom("Log In"))
                    .onTap {
                        onLoginTap?(logInForm)
                    }
                    .disabled(isDisabled)
                
                AuthButton(.google)
                    .onTap {
                        onGoogleTap?()
                        // TODO: Login with Google
                    }
                    .disabled($authViewModel.isLoading)
                
                AuthButton(.apple)
                    .onTap {
                        onAppleTap?()
                        // TODO: Login with Apple
                    }
                    .disabled($authViewModel.isLoading)
                
                LogInSignUpToggle(toLogin: false) {
                    onToggleTap?()
                    return
                }
                .padding(.bottom, 40)
            }
                .padding(20)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.6)
                .background(.white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
                .onTapGesture {
                    focusedField = nil
                }
            
        }
    }
}

extension LogInView {
    func onLoginTap(_ action: @escaping (LogInForm) -> Void) -> LogInView {
        return LogInView(authViewModel: self.authViewModel, onLoginTap: action, onGoogleTap: self.onGoogleTap, onAppleTap: self.onAppleTap, onForgotPasswordTap: self.onForgotPasswordTap, onToggleTap: self.onToggleTap)
    }
    
    func onGoogleTap(_ action: @escaping () -> Void) -> LogInView {
        return LogInView(authViewModel: self.authViewModel, onLoginTap: self.onLoginTap, onGoogleTap: action, onAppleTap: self.onAppleTap, onForgotPasswordTap: self.onForgotPasswordTap, onToggleTap: self.onToggleTap)
    }
    
    func onAppleTap(_ action: @escaping () -> Void) -> LogInView {
        return LogInView(authViewModel: self.authViewModel, onLoginTap: self.onLoginTap, onGoogleTap: self.onGoogleTap, onAppleTap: action, onForgotPasswordTap: self.onForgotPasswordTap, onToggleTap: self.onToggleTap)
    }
    
    func onForgotPasswordTap(_ action: @escaping () -> Void) -> LogInView {
        return LogInView(authViewModel: self.authViewModel, onLoginTap: self.onLoginTap, onGoogleTap: self.onGoogleTap, onAppleTap: self.onAppleTap, onForgotPasswordTap: action, onToggleTap: self.onToggleTap)
    }
    
    func onToggleTap(_ action: @escaping () -> Void) -> LogInView {
        return LogInView(authViewModel: self.authViewModel, onLoginTap: self.onLoginTap, onGoogleTap: self.onGoogleTap, onAppleTap: self.onAppleTap, onForgotPasswordTap: self.onForgotPasswordTap, onToggleTap: action)
    }
}

#Preview {
    LogInView(authViewModel: AuthViewModel())
        .appBackground()
}
