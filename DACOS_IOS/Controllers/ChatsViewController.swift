//
//  ChatsViewController.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 02.05.2022.
//

import UIKit

class ChatsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let chatsData: Chats = Chats()
    private let chats = ChatsView()
    private let nav = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(chats)
        chats.pinTop(to: view)
        chats.pinLeft(to: view)
        chats.pinRight(to: view)
        chats.pinBottom(to: view)
        chats.table.register(ChatPreview.self, forCellReuseIdentifier: "\(ChatPreview.self)")
        chats.table.delegate = self
        chats.table.dataSource = self
        chats.table.layer.masksToBounds = true
        chats.table.isScrollEnabled = true
        chats.table.delaysContentTouches = true
        chats.table.canCancelContentTouches = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsData.getChats().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chats.table.dequeueReusableCell(withIdentifier: "\(ChatPreview.self)", for: indexPath) as? ChatPreview else {
            return UITableViewCell()
        }
        let chat = chatsData.getChat(id: indexPath.row)
        let lastMsg = chat.messages?.allObjects.sorted(by: {($0 as! Message).when! > ($1 as! Message).when!}).last as! Message
        cell.initView(login: (chat.with?.login)!, msg: lastMsg.payload!, date: lastMsg.when!)
        return cell
    }
    
    func tableView(_ : UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = ChatViewController()
        chat.setupChat(chat: chatsData.getChat(id: indexPath.row))
        navigationController?.pushViewController(chat, animated: true)
    }
}
