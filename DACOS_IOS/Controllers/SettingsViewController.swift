//
//  SettingsViewController.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 02.05.2022.
//

import UIKit

class SettingsViewController : UIViewController {
    
    private let settingsView = SettingsView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        settingsView.toggle.isOn = StyleExt.isDark()
        if StyleExt.isDark() {
            settingsView.backgroundColor = StyleExt.darkMain
            settingsView.title.textColor = StyleExt.lightMain
            settingsView.bubble.backgroundColor = StyleExt.darkSupport
            settingsView.bubble.text.textColor = StyleExt.lightMain
        } else {
            settingsView.backgroundColor = StyleExt.lightMain
            settingsView.title.textColor = StyleExt.darkMain
            settingsView.bubble.backgroundColor = StyleExt.lightSupport
            settingsView.bubble.text.textColor = StyleExt.darkMain
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(settingsView)
        settingsView.initView()
        settingsView.pinTop(to: view)
        settingsView.pinLeft(to: view)
        settingsView.pinBottom(to: view)
        settingsView.pinRight(to: view)
        settingsView.toggle.addTarget(self, action: #selector(changeTheme), for: .touchUpInside)
    }
    
    @objc
    private func changeTheme(){
        if UserDefaults.standard.string(forKey: "Theme") == "Dark"{
            UserDefaults.standard.set("Light", forKey: "Theme")
        } else {
            UserDefaults.standard.set("Dark", forKey: "Theme")
        }
    }
}
