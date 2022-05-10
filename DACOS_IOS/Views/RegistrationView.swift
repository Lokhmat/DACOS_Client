//
//  RegistrationView.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 10.05.2022.
//

import UIKit

class RegistrationView: UIView {
    private let img = UIImageView()
    private let login = UITextField()
    private let password = UITextField()
    private let register = UIButton()
    internal let servers = UIPickerView()
    internal var onPress: () -> () = {}
    
    func initView(){
        backgroundColor = .white
        addSubview(img)
        img.pinTop(to: self, 100)
        img.pinCenter(to: self.centerXAnchor)
        img.image = UIImage(named: "dacos")
        
        addSubview(login)
        login.pinTop(to: img, 200)
        login.setWidth(to: 200)
        login.setHeight(to: 40)
        login.pinCenter(to: self.centerXAnchor)
        login.placeholder = "login"
        login.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        login.layer.cornerRadius = 10
        
        addSubview(password)
        password.pinTop(to: login, 50)
        password.setWidth(to: 200)
        password.setHeight(to: 40)
        password.pinCenter(to: self.centerXAnchor)
        password.placeholder = "password"
        password.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        password.layer.cornerRadius = 10
        
        addSubview(servers)
        servers.pinTop(to: password, 50)
        servers.pinCenter(to: self.centerXAnchor)
        servers.setWidth(to: 200)
        servers.setHeight(to: 100)
        
        addSubview(register)
        register.pinTop(to: servers, 100)
        register.setWidth(to: 200)
        register.setHeight(to: 50)
        register.backgroundColor = .blue
        register.setTitle("Go!", for: .normal)
        register.pinCenter(to: self.centerXAnchor)
        register.layer.cornerRadius = 20
        register.addTarget(self, action: #selector(kek(_:)), for: .touchUpInside)
    }
    
    @objc func kek(_ sender: AnyObject) {
        onPress()
    }
}
