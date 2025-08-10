//
//  LogInView.swift
//  Summa
//
//  Created by Jure Babnik on 29. 7. 25.
//

import SwiftUI

struct LogInView: View {
    @StateObject private var logInForm: LogInForm = LogInForm()
    @Binding var isLoading: Bool
    @Binding var errorMessage: String?
    
    var onLoginTap: ((LogInForm) -> Void)?
    var onGoogleTap: (() -> Void)?
    var onAppleTap: (() -> Void)?
    var onForgotPasswordTap: (() -> Void)?
    var onToggleTap: (() -> Void)?
    
    var body: some View {
        let isDisabled = Binding<Bool>(
            get: { !logInForm.isValid || isLoading },
            set: { _ in }
        )
        let isError = Binding<Bool>(
            get: { errorMessage != nil },
            set: { newValue in
                if !newValue {
                    errorMessage = nil
                }
            }
        )
        
        VStack {
            Text("Log in")
                .font(.title)
                .padding(.top, 100)
            
            Spacer()
            
            VStack(spacing: 10) {
                AuthInputFieldView(text: $logInForm.email, title: "Email", placeholder: "example@email.com", isError: isError)
                
                AuthInputFieldView(text: $logInForm.password, title: "Password", placeholder: "Your Password", isSecureField: true, isError: isError)
                
                HStack {
                    Text(errorMessage ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.defaultRed)
                    
                    Spacer()
                    
                    Button {
                        onForgotPasswordTap?()
                        // TODO: forgot password
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
                        // TODO: Login
                    }
                    .disabled(isDisabled)
                
                AuthButton(.google)
                    .onTap {
                        onGoogleTap?()
                        // TODO: Login with Google
                    }
                    .disabled($isLoading)
                
                AuthButton(.apple)
                    .onTap {
                        onAppleTap?()
                        // TODO: Login with Apple
                    }
                    .disabled($isLoading)
                
                LogInSignUpToggle(toLogin: false) {
                    onToggleTap?()
                    return
                }
                .padding(.bottom, 60)
            }
                .padding(20)
                .frame(maxHeight: UIScreen.main.bounds.height / 1.5)
                .background(.white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
            
        }
    }
}

extension LogInView {
    func onLoginTap(_ action: @escaping (LogInForm) -> Void) -> LogInView {
        return LogInView(isLoading: self.$isLoading, errorMessage: self.$errorMessage, onLoginTap: action, onGoogleTap: self.onGoogleTap, onAppleTap: self.onAppleTap, onForgotPasswordTap: self.onForgotPasswordTap, onToggleTap: self.onToggleTap)
    }
    
    func onGoogleTap(_ action: @escaping () -> Void) -> LogInView {
        return LogInView(isLoading: self.$isLoading, errorMessage: self.$errorMessage, onLoginTap: self.onLoginTap, onGoogleTap: action, onAppleTap: self.onAppleTap, onForgotPasswordTap: self.onForgotPasswordTap, onToggleTap: self.onToggleTap)
    }
    
    func onAppleTap(_ action: @escaping () -> Void) -> LogInView {
        return LogInView(isLoading: self.$isLoading, errorMessage: self.$errorMessage, onLoginTap: self.onLoginTap, onGoogleTap: self.onGoogleTap, onAppleTap: action, onForgotPasswordTap: self.onForgotPasswordTap, onToggleTap: self.onToggleTap)
    }
    
    func onForgotPasswordTap(_ action: @escaping () -> Void) -> LogInView {
        return LogInView(isLoading: self.$isLoading, errorMessage: self.$errorMessage, onLoginTap: self.onLoginTap, onGoogleTap: self.onGoogleTap, onAppleTap: self.onAppleTap, onForgotPasswordTap: action, onToggleTap: self.onToggleTap)
    }
    
    func onToggleTap(_ action: @escaping () -> Void) -> LogInView {
        return LogInView(isLoading: self.$isLoading, errorMessage: self.$errorMessage, onLoginTap: self.onLoginTap, onGoogleTap: self.onGoogleTap, onAppleTap: self.onAppleTap, onForgotPasswordTap: self.onForgotPasswordTap, onToggleTap: action)
    }
}

#Preview {
    LogInView(isLoading: .constant(true), errorMessage: .constant("Test"))
        .appBackground()
}
