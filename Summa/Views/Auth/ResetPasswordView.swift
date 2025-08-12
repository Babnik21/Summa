//
//  ResetPasswordView.swift
//  Summa
//
//  Created by Jure Babnik on 11. 8. 25.
//

import SwiftUI

// TODO: Pop a notification after successfully resetting password

struct ResetPasswordView: View {
    @StateObject var form: ResetPasswordForm = ResetPasswordForm()
    @ObservedObject var authViewModel: AuthViewModel
    
    var onConfirmTap: ((ResetPasswordForm) -> Void)?
    var onReturnTap: (() -> Void)?
    
    @FocusState var focusedField: InputField?
    
    var body: some View {
        let isDisabled = Binding<Bool>(
            get: { !form.isValid || authViewModel.isLoading },
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
            
            VStack(alignment: .leading, spacing: 8) {
                AuthInputFieldView(text: $form.password, title: "New password:", placeholder: "password", isSecureField: true, isError: isError, focusedField: $focusedField, equals: .password)
                    .textContentType(.newPassword)
                    .onSubmit {
                        focusedField = .confirmPassword
                    }
                
                AuthInputFieldView(text: $form.repeatPassword, title: "Repeat new password:", placeholder: "password", isSecureField: true, isError: isError, focusedField: $focusedField, equals: .confirmPassword)
                    .textContentType(.newPassword)
                    .submitLabel(.continue)
                    .onSubmit {
                        onConfirmTap?(form)
                    }
                
                Text(authViewModel.errorMessage ?? "")
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

extension ResetPasswordView {
    func onConfirmTap(_ action: @escaping (ResetPasswordForm) -> Void) -> ResetPasswordView {
        return ResetPasswordView(form: self.form, authViewModel: self.authViewModel, onConfirmTap: action, onReturnTap: self.onReturnTap)
    }
    
    func onReturnTap(_ action: @escaping () -> Void) -> ResetPasswordView {
        return ResetPasswordView(form: self.form, authViewModel: self.authViewModel, onConfirmTap: self.onConfirmTap, onReturnTap: action)
    }
}


#Preview {
    ResetPasswordView(authViewModel: AuthViewModel())
        .appBackground()
}
