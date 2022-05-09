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
            return UIImage(named: "chats")!
        case .profile:
            return UIImage(named: "profile")!
        case .settings:
            return UIImage(named: "settings")!
        }
    }
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
