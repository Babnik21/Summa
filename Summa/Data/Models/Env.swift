//
//  Environment.swift
//  Summa
//
//  Created by Jure Babnik on 3. 8. 25.
//

import Foundation

public enum Env {
    enum Keys {
        static let apiKey = "API_KEY"
        static let apiUrl = "API_URL"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Info.plist not set")
        }
        return dict
    }()
    
    static let apiUrl = {
       guard let urlString = infoDictionary[Keys.apiUrl] as? String else {
            fatalError("API URL not set")
        }
        return URL(string: urlString)!
    }()
    
    static let apiKey = {
        guard let apiKey = infoDictionary[Keys.apiKey] as? String else {
            fatalError("API Key not set")
        }
        return apiKey
    }()
}
