//
//  SmallCapsText.swift
//  Summa
//
//  Created by Jure Babnik on 26. 7. 25.
//

import SwiftUI

struct SmallCapsText: View {
    let content: String
    let largeFont: Font
    let smallFont: Font
    let padding: CGFloat

    init(
        _ content: String,
        fontSize: CGFloat,
    ) {
        self.content = content
        self.largeFont = .custom("BacasimeAntique-Regular", size: fontSize)
        self.smallFont = .custom("BacasimeAntique-Regular", size: fontSize * 0.8)
        self.padding = fontSize / 20
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Array(content), id: \.self) { char in
                Text(String(char))
                    .font(char.isUppercase ? largeFont : smallFont)
                    .textCase(.uppercase)
                    .padding(.bottom, char.isUppercase ? 0 : padding)
            }
        }
    }
}
