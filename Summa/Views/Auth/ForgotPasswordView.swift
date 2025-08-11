//
//  ForgotPasswordView.swift
//  Summa
//
//  Created by Jure Babnik on 1. 8. 25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var form: ForgotPasswordForm = ForgotPasswordForm()
    @Binding var status: AuthRequestStatus
    @Binding var isLoading: Bool
    @Binding var errorMessage: String?
    
    var onConfirmTap: ((ForgotPasswordForm) -> Void)?
    var onReturnTap: (() -> Void)?
    
    func messageText() -> String {
        switch status {
        case .awaiting:
            return "Reset instructions will be sent to your email."
        case .success:
            return "Success! Check your email for further instructions."
        case .error( _):
            return "Unknown error occurred. Try again later."
        }
    }
    
    var body: some View {
        let isDisabled = Binding<Bool>(
            get: { !form.isValid || isLoading || status != .awaiting },
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
            Text("Reset Password")
                .font(.title)
                .padding(.top, 120)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                AuthInputFieldView(text: $form.email, title: "Enter your email:", placeholder: "example@email.com", isError: isError)
                
                Text(messageText())
                    .font(.subheadline)
                    .foregroundStyle(status == .error(nil) ? .defaultRed : .primary)
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
                    .disabled(isLoading)
                    .padding(.bottom, 60)
            }
                .padding(20)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
                .background(.white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
        }
        
    }
}

extension ForgotPasswordView {
    func onConfirmTap(_ action: @escaping (ForgotPasswordForm) -> Void) -> ForgotPasswordView {
        return ForgotPasswordView(form: self.form, status: self.$status, isLoading: self.$isLoading, errorMessage: self.$errorMessage, onConfirmTap: action, onReturnTap: self.onReturnTap)
    }
    
    func onReturnTap(_ action: @escaping () -> Void) -> ForgotPasswordView {
        return ForgotPasswordView(form: self.form, status: self.$status, isLoading: self.$isLoading, errorMessage: self.$errorMessage, onConfirmTap: self.onConfirmTap, onReturnTap: action)
    }
}

#Preview {
    ForgotPasswordView(status: .constant(.awaiting), isLoading: .constant(true), errorMessage: .constant("Test"))
        .appBackground()
}
