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

#Preview {
    AuthInputFieldView(text: .constant(""), title: "Name", placeholder: "Name", isError: .constant(true))
        .appBackground()
}
