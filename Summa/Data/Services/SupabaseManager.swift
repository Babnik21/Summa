//
//  SupabaseManager.swift
//  Summa
//
//  Created by Jure Babnik on 3. 8. 25.
//

import Foundation
import Supabase

final class SupabaseManager {
    static let shared = SupabaseManager()
    private init() { }
    
    let client = SupabaseClient(
        supabaseURL: Env.apiUrl,
        supabaseKey: Env.apiKey
    )
}
