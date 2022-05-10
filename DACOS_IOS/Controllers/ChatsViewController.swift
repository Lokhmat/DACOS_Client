//
//  ChatsViewController.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 02.05.2022.
//

import UIKit

class ChatsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate {
    
    private let chatsData: Chats = Chats()
    private let chats = ChatsView()
    let searchBar = UISearchBar()
    
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
        searchBar.backgroundColor = .black
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255,
                                                 blue: 250/255, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Search Bar"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsData.getChats().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chats.table.dequeueReusableCell(withIdentifier: "\(ChatPreview.self)", for: indexPath) as? ChatPreview else {
            return UITableViewCell()
        }
        let chat = chatsData.getChat(id: indexPath.row)
        let lastMsg = chat.messages?.allObjects.sorted(by: {($0 as! Message).when! > ($1 as! Message).when!}).first as! Message
        cell.initView(login: (chat.with?.login)!, msg: lastMsg.payload!, date: lastMsg.when!)
        return cell
    }
    
    func tableView(_ : UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = ChatViewController()
        chat.setupChat(chat: chatsData.getChat(id: indexPath.row))
        chats.table.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(chat, animated: true)
    }
}
