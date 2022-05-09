//
//  ChatViewController.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 09.05.2022.
//

import UIKit

class ChatViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func setupChat(chat: Chat){
        self.title = chat.with?.login
    }
}
