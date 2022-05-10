//
//  ChatViewController.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 09.05.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate{
    
    var messages: [MyMessage] = []
    var me: Sender = Sender(senderId: "a", displayName: "a")
    var with: Sender = Sender(senderId: "b", displayName: "b")
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        configureMessageCollectionView()
        configureMessageInputBar()
    }
    
    public func setupChat(chat: Chat){
        self.title = chat.with?.login
        view.backgroundColor = .white
        self.messages = chat.getKitMessages()
        self.with = Sender(senderId: (chat.with?.login)!, displayName: (chat.with?.login)!)
        // TODO: Remove and add proper superUser
        self.me = Sender(senderId: "superUser", displayName: "Me")
    }
    
    func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true // default false
        showMessageTimestampOnSwipeLeft = true // default false
        
        messagesCollectionView.refreshControl = refreshControl
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
    }
    
    func insertMessage(_ message: MyMessage) {
        messages.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    @objc func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            print(1)
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            
        }
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        // Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = me
            if let str = component as? String {
                let message = MyMessage(sender: user, messageId: UUID().uuidString, sentDate: Date(), kind: .text(str))
                insertMessage(message)
            }
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(messageInputBar)
    }
    
    func currentSender() -> SenderType {
        return me
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
