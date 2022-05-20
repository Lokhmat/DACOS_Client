//
//  SettingsView.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 21.05.2022.
//

import UIKit

class SettingsView: UIView {
    
    let title = UILabel()
    let toggle = UISwitch()
    let bubble = Bubble()
    
    func initView(){
        backgroundColor = .white
        self.addSubview(title)
        title.font = UIFont.boldSystemFont(ofSize: 40)
        title.pinTop(to: self, 100)
        title.pinLeft(to: self, 50)
        title.text = "Settings"
        
        toggle.isUserInteractionEnabled = true
        bubble.initView(text: "Dark theme", toggle)
        self.addSubview(bubble)
        bubble.pinTop(to: title, 150)
        bubble.pinLeft(to: self, 50)
        bubble.setWidth(to: 300)
        bubble.setHeight(to: 40)
        bubble.layer.cornerRadius = 10
    }
}
