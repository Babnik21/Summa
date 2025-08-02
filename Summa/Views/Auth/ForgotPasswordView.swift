//
//  ForgotPasswordView.swift
//  Summa
//
//  Created by Jure Babnik on 1. 8. 25.
//

import SwiftUI

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

struct ForgotPasswordView: View {
    @StateObject var form: ResetPasswordForm = ResetPasswordForm()
    @Binding var status: AuthRequestStatus
    @Binding var errorMessage: String?
    
    var onConfirmTap: ((ResetPasswordForm) -> Void)?
    var onReturnTap: (() -> Void)?
    
    func messageText() -> String {
        switch status {
        case .awaiting:
            return "Reset instructions will be sent to your email."
        case .emailSent:
            return "Success! Check your email for further instructions."
        case .error( _):
            return "Unknown error occurred. Try again later."
        }
    }
    
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
            
            Text("Reset Password")
                .font(.title)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                AuthInputFieldView(text: $form.email, title: "Enter your email:", placeholder: "example@email.com", isError: isError)
                
                Text(messageText())
                    .font(.subheadline)
                    .tint(status == .error(nil) ? .defaultRed : .primary)
                    .lineLimit(1)
                
                Spacer()
                
                AuthButton(.custom("Send"))
                    .onTap {
                        onConfirmTap?(form)
                        // TODO: Login
                    }
                
                AuthButton(.custom("Back"))
                    .onTap {
                        onReturnTap?()
                        // TODO: Login
                    }
                    .padding(.bottom, 60)
            }
                .padding(20)
                .frame(maxHeight: UIScreen.main.bounds.height / 2)
                .background(.white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
        }
        
    }
}

extension ForgotPasswordView {
    func onConfirmTap(_ action: @escaping (ResetPasswordForm) -> Void) -> ForgotPasswordView {
        return ForgotPasswordView(form: self.form, status: self.$status, errorMessage: self.$errorMessage, onConfirmTap: action, onReturnTap: self.onReturnTap)
    }
    
    func onReturnTap(_ action: @escaping () -> Void) -> ForgotPasswordView {
        return ForgotPasswordView(form: self.form, status: self.$status, errorMessage: self.$errorMessage, onConfirmTap: self.onConfirmTap, onReturnTap: action)
    }
}

#Preview {
    ForgotPasswordView(status: .constant(.awaiting), errorMessage: .constant("Test"))
        .appBackground()
}
