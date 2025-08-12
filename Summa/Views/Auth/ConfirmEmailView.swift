//
//  ConfirmEmailView.swift
//  Summa
//
//  Created by Jure Babnik on 6. 8. 25.
//

import SwiftUI

struct ConfirmEmailView: View {
    var email: String
    @ObservedObject var authViewModel: AuthViewModel
    
    var onResendTap: (() -> Void)?
    var onSignOutTap: (() -> Void)?
    
    var body: some View {
        let isDisabled = Binding<Bool>(
            get: { authViewModel.isLoading || authViewModel.authRequestStatus == .success },
            set: { _ in }
        )
        VStack {
            Text("Confirm Email")
                .font(.title)
                .padding(.top, 120)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("An email with confirmation instructions was sent to \(email).")
                
                Text(authViewModel.isLoading ? "Please wait..." : authViewModel.errorMessage ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.defaultRed)
                    .lineLimit(1)
                
                Spacer()
                
                AuthButton(.custom("Resend email"))
                    .onTap {
                        onResendTap?()
                    }
                    .disabled(isDisabled)
                
                AuthButton(.custom("Sign Out"))
                    .onTap {
                        onSignOutTap?()
                    }
                    .disabled($authViewModel.isLoading)
                    .padding(.bottom, 60)
            }
                .padding(20)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
                .background(.white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
        }
        
    }
}

extension ConfirmEmailView {
    func onResendTap(_ action: @escaping () -> Void) -> ConfirmEmailView {
        return ConfirmEmailView(email: self.email, authViewModel: self.authViewModel, onResendTap: action, onSignOutTap: self.onSignOutTap)
    }
    
    func onSignOutTap(_ action: @escaping () -> Void) -> ConfirmEmailView {
        return ConfirmEmailView(email: self.email, authViewModel: self.authViewModel, onResendTap: self.onResendTap, onSignOutTap: action)
    }
}

#Preview {
    ConfirmEmailView(email: "Test@email.com", authViewModel: AuthViewModel())
        .appBackground()
}
