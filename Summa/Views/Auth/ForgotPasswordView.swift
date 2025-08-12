//
//  ForgotPasswordView.swift
//  Summa
//
//  Created by Jure Babnik on 1. 8. 25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var form: ForgotPasswordForm = ForgotPasswordForm()
    @ObservedObject var authViewModel: AuthViewModel
    
    var onConfirmTap: ((ForgotPasswordForm) -> Void)?
    var onReturnTap: (() -> Void)?
    
    func messageText() -> String {
        switch authViewModel.authRequestStatus {
        case .awaiting:
            return "Reset instructions will be sent to your email."
        case .success:
            return "Success! Check your email for further instructions."
        case .error( _):
            return "Unknown error occurred. Try again later."
        }
    }
    
    @FocusState var focusedField: InputField?
    
    var body: some View {
        let isDisabled = Binding<Bool>(
            get: { !form.isValid || authViewModel.isLoading || authViewModel.authRequestStatus == .success },
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
            Text("Reset Password")
                .font(.title)
                .padding(.top, 120)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                AuthInputFieldView(text: $form.email, title: "Enter your email:", placeholder: "example@email.com", isError: isError, focusedField: $focusedField, equals: .email)
                    .textContentType(.emailAddress)
                    .submitLabel(.send)
                    .onSubmit {
                        onConfirmTap?(form)
                    }
                
                Text(authViewModel.isLoading ? "Please wait..." : messageText())
                    .font(.subheadline)
                    .foregroundStyle(authViewModel.authRequestStatus == .error(nil) ? .defaultRed : .primary)
                    .lineLimit(1)
                
                Spacer()
                
                AuthButton(.custom("Send"))
                    .onTap {
                        onConfirmTap?(form)
                    }
                    .disabled(isDisabled)
                
                AuthButton(.custom("Back"))
                    .onTap {
                        onReturnTap?()
                    }
                    .disabled($authViewModel.isLoading)
                    .padding(.bottom, 60)
            }
                .padding(20)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
                .background(.white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
                .onTapGesture {
                    focusedField = nil
                }
        }
        
    }
}

extension ForgotPasswordView {
    func onConfirmTap(_ action: @escaping (ForgotPasswordForm) -> Void) -> ForgotPasswordView {
        return ForgotPasswordView(form: self.form, authViewModel: self.authViewModel, onConfirmTap: action, onReturnTap: self.onReturnTap)
    }
    
    func onReturnTap(_ action: @escaping () -> Void) -> ForgotPasswordView {
        return ForgotPasswordView(form: self.form, authViewModel: self.authViewModel, onConfirmTap: self.onConfirmTap, onReturnTap: action)
    }
}

#Preview {
    ForgotPasswordView(authViewModel: AuthViewModel())
        .appBackground()
}
