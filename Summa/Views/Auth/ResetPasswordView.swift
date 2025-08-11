//
//  ResetPasswordView.swift
//  Summa
//
//  Created by Jure Babnik on 11. 8. 25.
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject var form: ResetPasswordForm = ResetPasswordForm()
    @Binding var isLoading: Bool
    @Binding var errorMessage: String?
    
    var onConfirmTap: ((ResetPasswordForm) -> Void)?
    var onReturnTap: (() -> Void)?
    
    var body: some View {
        let isDisabled = Binding<Bool>(
            get: { !form.isValid || isLoading },
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
            
            VStack(alignment: .leading, spacing: 8) {
                AuthInputFieldView(text: $form.password, title: "New password:", placeholder: "password", isSecureField: true, isError: isError)
                
                AuthInputFieldView(text: $form.repeatPassword, title: "Repeat new password:", placeholder: "password", isSecureField: true, isError: isError)
                
                Text(errorMessage ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.defaultRed)
                    .lineLimit(1)
                
                Spacer()
                
                AuthButton(.custom("Confirm Password"))
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

extension ResetPasswordView {
    func onConfirmTap(_ action: @escaping (ResetPasswordForm) -> Void) -> ResetPasswordView {
        return ResetPasswordView(form: self.form, isLoading: self.$isLoading, errorMessage: self.$errorMessage, onConfirmTap: action, onReturnTap: self.onReturnTap)
    }
    
    func onReturnTap(_ action: @escaping () -> Void) -> ResetPasswordView {
        return ResetPasswordView(form: self.form, isLoading: self.$isLoading, errorMessage: self.$errorMessage, onConfirmTap: self.onConfirmTap, onReturnTap: action)
    }
}


#Preview {
    ResetPasswordView(isLoading: .constant(true), errorMessage: .constant("Test"))
        .appBackground()
}
