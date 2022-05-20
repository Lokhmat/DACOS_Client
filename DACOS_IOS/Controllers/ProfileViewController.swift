//
//  ProfileViewController.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 02.05.2022.
//

import UIKit

class ProfileViewController : UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view?.backgroundColor = UIColor.yellow
    }
}
