//
//  LocalizedStrings.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import Foundation

// We can also using swiftgen for generating string files
enum LocalizedStrings: String {
    
    case manifacture
    case models
    case changeLanguage = "Change_Language"
    case cancel
    case toCars = "toCarSelection"
    case guideline
    case choosenCar
    case welldone
    case error
    case ok
    
    var value: String {
        return localized(key: self.rawValue)
    }
    
    private func localized(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}

extension LocalizedStrings {
    static func localize(_ key: Self, _ args: CVarArg...) -> String {
        return String(format: key.value, locale: Locale.current, arguments: args)
    }
}
