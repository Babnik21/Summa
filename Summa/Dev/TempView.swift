//
//  TempView.swift
//  Summa
//
//  Created by Jure Babnik on 18. 7. 25.
//

import SwiftUI


struct TempView: View {
    @State private var animationTrigger: Bool = true
    @State private var customText = "Not completed.."
    
    private let strokeWidth: CGFloat = 10
    
    var body: some View {
        
        VStack {
            
            LogoView(
                animationTrigger: $animationTrigger,
                strokeWidth: strokeWidth
            )
                .onComplete {
                    customText = "Completed!"
                }
                .frame(width: 250, height: 305)

            
            Button {
                animationTrigger = true
            } label: {
                Capsule()
                    .fill(Color.blue)
                    .frame(width: 100, height: 50)
                    .overlay {
                        Text("Animate")
                            .foregroundStyle(.white)
                    }
            }
        
            Text(customText)
        }
    }
}

#Preview {
    TempView()
}
