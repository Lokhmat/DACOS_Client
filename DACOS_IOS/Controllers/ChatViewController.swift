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
    var chat: Chat?
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(rebuild), name: NSNotification.Name.NSManagedObjectContextDidSave, object: MainUser.context)
        messagesCollectionView.backgroundColor = StyleExt.mainColor()
        messageInputBar.backgroundView.backgroundColor = StyleExt.mainColor()
        messageInputBar.inputTextView.textColor = StyleExt.fontMainColor()
        let textAttributes = [NSAttributedString.Key.foregroundColor: StyleExt.fontMainColor()]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        configureMessageCollectionView()
        configureMessageInputBar()
        if self.messages.count != 0{
            self.messagesCollectionView.scrollToItem(at: IndexPath(row: 0, section: self.messages.count - 1), at: .top, animated: true)
        }
    }
    
    @objc
    func rebuild() {
        DispatchQueue.main.async {
            self.messages = (self.chat?.getKitMessages().sorted(by: {$0.sentDate < $1.sentDate}))!
            self.messagesCollectionView.reloadData()
            if self.messages.count != 0{
                self.messagesCollectionView.scrollToItem(at: IndexPath(row: 0, section: self.messages.count - 1), at: .top, animated: true)
            }
        }
    }
    
    public func setupChat(chat: Chat){
        self.chat = chat
        self.title = chat.with?.login
        self.messages = chat.getKitMessages().sorted(by: {$0.sentDate < $1.sentDate})
        self.with = Sender(senderId: (chat.with?.login)!, displayName: (chat.with?.login)!)
        self.me = MainUser.getKitSuperUser() ?? Sender(senderId: "superUser", displayName: "superUser")
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
        let payload = inputBar.inputTextView.text!
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            DispatchQueue.main.async { [weak self] in
                let semaphore = DispatchSemaphore (value: 0)
                var parameters = ""
                var ip = ""
                if (self!.chat?.with?.server?.ip)! == (MainUser.getSuperUser()?.server?.ip)! {
                    parameters = "{\n    \"message\": \"\(payload.getShipheredForSameServer(chat: (self!.chat!)) ?? "failed")\"\n}"
                    ip = (self!.chat?.with?.server?.ip)!
                } else {
                    parameters = "{\n    \"message\": \"\(payload.getShipheredForSameServer(chat: (self!.chat!)) ?? "failed")\"\n}"
                    ip = (self!.chat?.with?.server?.ip)!
                }
                let postData = parameters.data(using: .utf8)
                
                var request = URLRequest(url: URL(string: "http://\(ip)/messages/write")!,timeoutInterval: Double.infinity)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.httpMethod = "POST"
                request.httpBody = postData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data else {
                        print(String(describing: error))
                        semaphore.signal()
                        return
                    }
                    print(String(data: data, encoding: .utf8)!)
                    semaphore.signal()
                    DispatchQueue.main.async {
                        inputBar.sendButton.stopAnimating()
                        inputBar.inputTextView.placeholder = "Aa"
                        self?.insertMessages(components)
                        self?.messagesCollectionView.scrollToLastItem(animated: true)
                    }
                }
                
                task.resume()
                semaphore.wait()
                
            }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = me
            if let str = component as? String {
                let message = MyMessage(sender: user, messageId: UUID().uuidString, sentDate: Date(), kind: .text(str))
                insertMessage(message)
                let msgOne = Message(context: MainUser.context)
                msgOne.payload = str
                msgOne.when = Date()
                chat?.addToMessages(msgOne)
                do {
                    DispatchQueue.main.async {
                        do {
                            try MainUser.context.save()
                        } catch{}
                    }
                } catch {}
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
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar = Avatar(image: UIImage(color: message.sender.senderId.getColor()), initials: "")
        avatarView.set(avatar: avatar)
    }
}
