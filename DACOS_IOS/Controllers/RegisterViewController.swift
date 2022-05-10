//
//  RegisterViewController.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 10.05.2022.
//

import UIKit

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    let registration = RegistrationView()
    internal var changeScreen: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(registration)
        registration.pinTop(to: view)
        registration.pinRight(to: view)
        registration.pinLeft(to: view)
        registration.pinBottom(to: view)
        registration.servers.dataSource = self
        registration.servers.delegate = self
        registration.initView()
        registration.onPress = changeScreen
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Servers.getServers().count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Servers.getServers()[row].ip
    }
}
