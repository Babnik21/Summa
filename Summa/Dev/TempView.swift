//
//  TempView.swift
//  Summa
//
//  Created by Jure Babnik on 18. 7. 25.
//

import SwiftUI
import Supabase

struct TestTableResults: Decodable {
    let id: Int
    let createdAt: Date
    let test: String
}


struct TempView: View {
    @State private var showA = true

    var body: some View {
        VStack {
            ZStack {
                if showA {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 200, height: 200)
                        .transition(.move(edge: .leading))
                        .transaction { t in
                            t.animation = .easeIn(duration: 0.5)
                        }
                } else {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 200, height: 200)
                        .transition(.move(edge: .leading))
                        .transaction { t in
                            t.animation = .easeOut(duration: 0.5)
                        }
                }
            }

            Button("Toggle") {
                showA.toggle()
            }
        }
    }
}

#Preview {
    TempView()
}
