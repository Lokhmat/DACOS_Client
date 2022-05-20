//
//  vc.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 02.05.2022.
//

import UIKit

enum TabItem: String, CaseIterable {
    case chats = "chats"
    case profile = "profile"
    case settings = "settings"
    var viewController: UIViewController {
        switch self {
        case .chats:
            return ChatsViewController()
        case .profile:
            return ProfileViewController()
        case .settings:
            return SettingsViewController()
        }
    }
    var icon: UIImage {
        switch self {
        case .chats:
            if StyleExt.isDark(){
                return UIImage(named: "chats_dark")!
            }
            return UIImage(named: "chats_light")!
        case .profile:
            if StyleExt.isDark(){
                return UIImage(named: "profile_dark")!
            }
            return UIImage(named: "profile_light")!
        case .settings:
            if StyleExt.isDark(){
                return UIImage(named: "settings_dark")!
            }
            return UIImage(named: "settings_light")!
        }
    }
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
