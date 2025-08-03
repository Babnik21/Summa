//
//  LogInView.swift
//  Summa
//
//  Created by Jure Babnik on 29. 7. 25.
//

import SwiftUI

struct LogInView: View {
    @Binding var loadingState: LoadingState
    @StateObject var logInForm: LogInForm = LogInForm()
    @Binding var errorMessage: String?
    
    var onLoginTap: ((LogInForm) -> Void)?
    var onGoogleTap: (() -> Void)?
    var onAppleTap: (() -> Void)?
    var onForgotPasswordTap: (() -> Void)?
    var onToggleTap: (() -> Void)?
    
    var body: some View {
        VStack {
            if loadingState < .finished {
                LogoIntroView(isSignedIn: false, loadingState: $loadingState)
                    .offset(y: loadingState >= .logoRemoval ? -UIScreen.main.bounds.height / 2 - 200 : 0)
            }
            
            if loadingState >= .logoRemoval {
                let isError = Binding<Bool>(
                    get: { errorMessage != nil },
                    set: { newValue in
                        if !newValue {
                            errorMessage = nil
                        }
                    }
                )
                
                Group {
                    Spacer()
                    
                    Text("Log in")
                        .font(.title)
                    
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
                        
                        AuthButton(.google)
                            .onTap {
                                onGoogleTap?()
//                                errorMessage = "Example Error"
                                // TODO: Login with Google
                            }
                        
                        AuthButton(.apple)
                            .onTap {
                                onAppleTap?()
                                // TODO: Login with Apple
                            }
                        
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
                    .offset(y: loadingState < .finished ? UIScreen.main.bounds.height : 0)
            }
        }
    }
}

extension LogInView {
    func onLoginTap(_ action: @escaping (LogInForm) -> Void) -> LogInView {
        return LogInView(loadingState: self.$loadingState, logInForm: self.logInForm, errorMessage: self.$errorMessage, onLoginTap: action, onGoogleTap: self.onGoogleTap, onAppleTap: self.onAppleTap, onForgotPasswordTap: self.onForgotPasswordTap, onToggleTap: self.onToggleTap)
    }
    
    func onGoogleTap(_ action: @escaping () -> Void) -> LogInView {
        return LogInView(loadingState: self.$loadingState, logInForm: self.logInForm, errorMessage: self.$errorMessage, onLoginTap: self.onLoginTap, onGoogleTap: action, onAppleTap: self.onAppleTap, onForgotPasswordTap: self.onForgotPasswordTap, onToggleTap: self.onToggleTap)
    }
    
    func onAppleTap(_ action: @escaping () -> Void) -> LogInView {
        return LogInView(loadingState: self.$loadingState, logInForm: self.logInForm, errorMessage: self.$errorMessage, onLoginTap: self.onLoginTap, onGoogleTap: self.onGoogleTap, onAppleTap: action, onForgotPasswordTap: self.onForgotPasswordTap, onToggleTap: self.onToggleTap)
    }
    
    func onForgotPasswordTap(_ action: @escaping () -> Void) -> LogInView {
        return LogInView(loadingState: self.$loadingState, logInForm: self.logInForm, errorMessage: self.$errorMessage, onLoginTap: self.onLoginTap, onGoogleTap: self.onGoogleTap, onAppleTap: self.onAppleTap, onForgotPasswordTap: action, onToggleTap: self.onToggleTap)
    }
    
    func onToggleTap(_ action: @escaping () -> Void) -> LogInView {
        return LogInView(loadingState: self.$loadingState, logInForm: self.logInForm, errorMessage: self.$errorMessage, onLoginTap: self.onLoginTap, onGoogleTap: self.onGoogleTap, onAppleTap: self.onAppleTap, onForgotPasswordTap: self.onForgotPasswordTap, onToggleTap: action)
    }
}

#Preview {
    LogInView(loadingState: .constant(.finished), errorMessage: .constant("Test"))
        .appBackground()
}
