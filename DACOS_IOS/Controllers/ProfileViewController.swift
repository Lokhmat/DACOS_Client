//
//  ProfileViewController.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 02.05.2022.
//

import UIKit

class ProfileViewController : UIViewController {
    
    private let profileView = ProfileView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileView)
        let user = MainUser.getSuperUser()
        profileView.initView(login: user?.login ?? "Conection error", server: user?.server?.ip ?? "")
        profileView.pinTop(to: view)
        profileView.pinLeft(to: view)
        profileView.pinBottom(to: view)
        profileView.pinRight(to: view)
    }
}
