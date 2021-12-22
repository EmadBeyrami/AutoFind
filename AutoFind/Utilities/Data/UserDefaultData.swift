//
//  UserDefaultData.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import Foundation

struct UserDefaultData {
    
    enum UserDefaultsKey: String {
        case appleLanguages  = "AppleLanguages"
        case currentLanguage
        case accessToken
    }
    
    @UserDefaultStorage(.currentLanguage, defaultValue: "en")
    static var currentLanguage: String
    
    @UserDefaultStorage(.appleLanguages, defaultValue: ["en"])
    static var appleLanguage: [String]
    
    @UserDefaultStorage(.accessToken, defaultValue: Constants.WebAccessKey)
    static var accessToken: String
    
    static func clearUserDefaultFor(_ key: UserDefaultsKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func clearAllUserDefault() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        UserDefaults.standard.synchronize()
    }
}
