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
    @State var id: Int = 0
    
    let supabase = SupabaseClient(
        supabaseURL: Env.apiUrl,
        supabaseKey: Env.apiKey
    )
    
    var body: some View {
        Text("Current id: \(id)")
        
        Button {
            Task {
                do {
                    let results: [TestTableResults] = try await supabase
                        .from("test")
                        .select()
                        .execute()
                        .value
                    
                    id = results[0].id
                } catch {
                    print("Error querying: \(error)")
                }
            }
        } label: {
            Capsule()
                .fill(Color.blue)
                .frame(width: 100, height: 50)
                .overlay(
                    Text("Query")
                        .font(.headline)
                        .foregroundColor(.white)
                )
        }

    }
}

#Preview {
    TempView()
}
