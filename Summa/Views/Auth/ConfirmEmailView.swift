//
//  ConfirmEmailView.swift
//  Summa
//
//  Created by Jure Babnik on 6. 8. 25.
//

import SwiftUI

struct ConfirmEmailView: View {
    var email: String
    @Binding var errorMessage: String?
    
    var onResendTap: (() -> Void)?
    var onSignOutTap: (() -> Void)?
    
    var body: some View {
//        let isError = Binding<Bool>(
//            get: { errorMessage != nil },
//            set: { newValue in
//                if !newValue {
//                    errorMessage = nil
//                }
//            }
//        )
        
        VStack {
            Text("Confirm Email")
                .font(.title)
                .padding(.top, 100)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("An email with confirmation instructions was sent to \(email).")
                
                Text(errorMessage ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.defaultRed)
                    .lineLimit(1)
                
                Spacer()
                
                AuthButton(.custom("Resend email"))
                    .onTap {
                        onResendTap?()
                        // TODO: Login
                    }
                
                AuthButton(.custom("Sign Out"))
                    .onTap {
                        onSignOutTap?()
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

extension ConfirmEmailView {
    func onResendTap(_ action: @escaping () -> Void) -> ConfirmEmailView {
        return ConfirmEmailView(email: self.email, errorMessage: self.$errorMessage, onResendTap: action, onSignOutTap: self.onSignOutTap)
    }
    
    func onSignOutTap(_ action: @escaping () -> Void) -> ConfirmEmailView {
        return ConfirmEmailView(email: self.email, errorMessage: self.$errorMessage, onResendTap: self.onResendTap, onSignOutTap: action)
    }
}

#Preview {
    ConfirmEmailView(email: "Test@email.com", errorMessage: .constant("Test"))
        .appBackground()
}
