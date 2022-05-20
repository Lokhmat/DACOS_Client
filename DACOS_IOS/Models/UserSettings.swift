//
//  UserSettings.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 21.05.2022.
//

import Foundation

enum Theme: String {
    case dark = "dark"
    case light = "light"
}

class UserSettings {
    private var theme: Theme = .light
    private static let settings = UserSettings()
    
    public static func getSettings() -> UserSettings {
        return settings
    }
    
    func changeTheme(){
        if theme == .dark{
            theme = .light
        } else {
            theme = .dark
        }
    }
    
    func getTheme() -> Theme {
        return theme
    }
}
