//
//  AuthInputFieldView.swift
//  Summa
//
//  Created by Jure Babnik on 30. 7. 25.
//

import SwiftUI

struct AuthInputFieldView: View {
    @Binding var text: String
    let title: String
    let placeholder: String?
    var isSecureField: Bool = false
    
    @FocusState var isFocused: Bool
    @Binding var isError: Bool
//    @FocusState.Binding var externalFocus: InputField?
//    var equals: InputField = .none
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.callout)
            
            Group {
                if isSecureField {
                    SecureField(placeholder ?? title, text: $text)
                } else {
                    TextField(placeholder ?? title, text: $text)
                }
            }
                .focused($isFocused)
//                .focused($externalFocus, equals: equals)
                .padding(12)
                .background(
                    RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                        .strokeBorder(isError ? .defaultRed : (isFocused ? .authButtonStroke : .greenDefault), lineWidth: 1)
                )
                .font(.body)
                .onChange(of: isFocused) { _, newValue in
                    if newValue {
                        isError = false
                    }
                }
                .onChange(of: text) {
                    isError = false
                }
        }
    }
}

extension AuthInputFieldView {
//    func focused(_ focusedField: FocusState<InputField?>.Binding, equals: InputField) -> AuthInputFieldView {
//        return AuthInputFieldView(text: self.$text, title: self.title, placeholder: self.placeholder, isError: self.$isError, externalFocus: focusedField, equals: equals)
//    }
    
//    func focused(equals: InputField) -> AuthInputFieldView {
//        return AuthInputFieldView(text: self.$text, title: self.title, placeholder: self.placeholder, isError: self.$isError, externalFocus: self.$externalFocus, equals: equals)
//    }
}

#Preview {
    AuthInputFieldView(text: .constant(""), title: "Name", placeholder: "Name", isError: .constant(true))
        .appBackground()
}



//#Preview {
//    @FocusState var dummy: InputField?
//    AuthInputFieldView(text: .constant(""), title: "Name", placeholder: "Name", isError: .constant(true), externalFocus: $dummy, equals: .none)
//        .appBackground()
//}
