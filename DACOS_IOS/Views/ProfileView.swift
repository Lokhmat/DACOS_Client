//
//  ProfileView.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 21.05.2022.
//

import UIKit

class ProfileView : UIView {
    private let picture = UIView()
    private let login = UILabel()
    private let server = UILabel()
    
    public func initView(login: String, server: String){
        self.addSubview(picture)
        self.addSubview(self.login)
        self.addSubview(self.server)
        self.login.text = login
        self.server.text = "Выбран сервер: \(server)"
        
        backgroundColor = StyleExt.mainColor()
        picture.pinCenter(to: self.centerXAnchor)
        picture.pinTop(to: self, 100)
        picture.setHeight(to: 150)
        picture.setWidth(to: 150)
        picture.clipsToBounds = true
        picture.layer.cornerRadius = 75
        picture.backgroundColor = getColor()
        
        self.login.pinTop(to: picture.bottomAnchor, 30)
        self.login.pinCenter(to: self.centerXAnchor)
        self.login.font = UIFont.systemFont(ofSize: 35.0)
        self.login.textColor = StyleExt.fontMainColor()
        
        let serverBubble = Bubble()
        self.addSubview(serverBubble)
        serverBubble.backgroundColor = StyleExt.supColor()
        serverBubble.pinCenter(to: self.centerXAnchor)
        serverBubble.pinTop(to: self.login.bottomAnchor, 40)
        serverBubble.setWidth(to: 300)
        serverBubble.setHeight(to: 40)
        serverBubble.layer.cornerRadius = 10
        let label = UILabel()
        label.text = server
        label.textColor = StyleExt.fontMainColor()
        serverBubble.initView(text: "Selected server: ", label)
        
        let statusBubble = Bubble()
        self.addSubview(statusBubble)
        statusBubble.backgroundColor = StyleExt.supColor()
        statusBubble.pinCenter(to: self.centerXAnchor)
        statusBubble.pinTop(to: serverBubble.bottomAnchor, 10)
        statusBubble.setWidth(to: 300)
        statusBubble.setHeight(to: 40)
        statusBubble.layer.cornerRadius = 10
        let status = UILabel()
        status.text = "Active"
        status.textColor = #colorLiteral(red: 0, green: 0.7188134789, blue: 0, alpha: 1)
        statusBubble.initView(text: "Status: ", status)
    }
    
    private func getColor() -> UIColor {
        let seed = login.text ?? ""
        var total: Int = 0
        for u in seed.unicodeScalars {
            total += Int(UInt32(u))
        }
        
        srand48(total * 200)
        let r = CGFloat(drand48())
        
        srand48(total)
        let g = CGFloat(drand48())
        
        srand48(total / 200)
        let b = CGFloat(drand48())
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}

