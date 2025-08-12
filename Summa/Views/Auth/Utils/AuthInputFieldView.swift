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
    
//    @FocusState var isFocused: Bool
    @Binding var isError: Bool
    var textContentType: UITextContentType = .name
    var submitLabel: SubmitLabel = .next
    
    @FocusState.Binding var focusedField: InputField?
    var equals: InputField = .none
    
    var onSubmit: (() -> Void)?
    
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
                .focused($focusedField, equals: equals)
                .textContentType(textContentType)
                .keyboardType(textContentType == .emailAddress ? .emailAddress : .default)
                .autocorrectionDisabled()
                .submitLabel(submitLabel)
                .onSubmit {
                    onSubmit?()
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                        .strokeBorder(isError ? .defaultRed : (focusedField == equals ? .authButtonStroke : .greenDefault), lineWidth: 1)
                )
                .font(.body)
                .onChange(of: focusedField) { _, _ in
                    isError = false
                }
                .onChange(of: text) {
                    isError = false
                }
        }
    }
}

// MARK: modifiers
extension AuthInputFieldView {
    func onSubmit(_ perform: @escaping () -> Void) -> AuthInputFieldView {
        return AuthInputFieldView(text: self.$text, title: self.title, placeholder: self.placeholder, isSecureField: self.isSecureField, isError: self.$isError, textContentType: self.textContentType, submitLabel: self.submitLabel, focusedField: self.$focusedField, equals: self.equals, onSubmit: perform)
    }
    
    func textContentType(_ contentType: UITextContentType) -> AuthInputFieldView {
        return AuthInputFieldView(text: self.$text, title: self.title, placeholder: self.placeholder, isSecureField: self.isSecureField, isError: self.$isError, textContentType: contentType, submitLabel: self.submitLabel, focusedField: self.$focusedField, equals: self.equals, onSubmit: self.onSubmit)
    }
    
    func submitLabel(_ label: SubmitLabel) -> AuthInputFieldView {
        return AuthInputFieldView(text: self.$text, title: self.title, placeholder: self.placeholder, isSecureField: self.isSecureField, isError: self.$isError, textContentType: self.textContentType, submitLabel: label, focusedField: self.$focusedField, equals: self.equals, onSubmit: self.onSubmit)
    }
}

//#Preview {
//    AuthInputFieldView(text: .constant(""), title: "Name", placeholder: "Name", isError: .constant(true), focusedField: FocusState<InputField?>.Binding())
//        .appBackground()
//}



//#Preview {
//    @FocusState var dummy: InputField?
//    AuthInputFieldView(text: .constant(""), title: "Name", placeholder: "Name", isError: .constant(true), externalFocus: $dummy, equals: .none)
//        .appBackground()
//}
