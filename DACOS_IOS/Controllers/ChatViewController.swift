//
//  ChatViewController.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 09.05.2022.
//

import UIKit
import MessageKit

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    
    var mesages: [MyMessage] = []
    var me: Sender = Sender(senderId: "a", displayName: "a")
    var with: Sender = Sender(senderId: "b", displayName: "b")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    public func setupChat(chat: Chat){
        self.title = chat.with?.login
        view.backgroundColor = .white
        self.mesages = chat.getKitMessages()
        self.with = Sender(senderId: (chat.with?.login)!, displayName: (chat.with?.login)!)
        // TODO: Remove and add proper superUser
        self.me = Sender(senderId: "superUser", displayName: "Me")
    }
    
    func currentSender() -> SenderType {
        return me
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        mesages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mesages.count
    }
}
