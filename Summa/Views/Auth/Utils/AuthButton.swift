//
//  AuthButton.swift
//  Summa
//
//  Created by Jure Babnik on 31. 7. 25.
//

import SwiftUI

enum AuthButtonType {
    case apple
    case google
    case custom(String)
}

struct AuthButton: View {
    let type: AuthButtonType
    let image: String?
    let systemImage: (name: String, color: Color, size: (width: CGFloat, height: CGFloat))?
    let buttonText: String
    var bgColor: Color
    var buttonStrokeColor: Color
    var onTap: (() -> Void)?
    
//    #1F1F1F
    
    init (_ type: AuthButtonType, onTap: (() -> Void)? = nil) {
        self.type = type
        self.onTap = onTap
        switch type {
        case .apple:
            self.image = nil
            self.systemImage = (name: "apple.logo", color: .primary, size: (14, 16))
            self.buttonText = "Continue with Apple"
            self.bgColor = .clear
            self.buttonStrokeColor = .authButtonStroke
        case .google:
            self.image = "googleIcon"
            self.systemImage = nil
            self.buttonText = "Continue with Google"
            self.bgColor = .clear
            self.buttonStrokeColor = .authButtonStroke
        case .custom(let title):
            self.image = nil
            self.systemImage = nil
            self.buttonText = title
            self.bgColor = .greenDefault
            self.buttonStrokeColor = .greenDefault
        }
    }
    
    var body: some View {
        Button {
            onTap?()
        } label: {
            RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                .fill(bgColor)
                .strokeBorder(buttonStrokeColor, lineWidth: 1)
                .overlay {
                    HStack(alignment: .center, spacing: 12) {
                        if let image {
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                        } else if let systemImage {
                            Image(systemName: systemImage.name)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(systemImage.color)
                        }
                        
                        Text(buttonText)
                            .lineLimit(1)
                            .foregroundStyle(.authButtonText)
                            .minimumScaleFactor(0.5)
                            .font(.headline)
                    }
                    .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: 60, alignment: .center)
        }
    }
}

extension AuthButton {
    func onTap(_ action: @escaping () -> Void) -> AuthButton {
        return AuthButton(self.type, onTap: action)
    }
}

#Preview {
    AuthButton(.apple)
}
