//
//  Dummies.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 03.05.2022.
//

import Foundation
import CoreData

class Dummies {
    let context = MainUser.context
    
    public func populateWithDummies(){
        let chats = try? context.fetch(Chat.fetchRequest())
        if !(chats?.isEmpty ?? true) {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        
        let msgOne = Message(context: context)
        msgOne.payload = "Hi!"
        msgOne.when = formatter.date(from: "2022.02.08 22:31")
        
        let msgTwo = Message(context: context)
        msgTwo.payload = "Hello"
        msgTwo.seen = true
        msgTwo.when = formatter.date(from: "2022.02.08 22:33")
        
        let msgThree = Message(context: context)
        msgThree.payload = "Greetings"
        msgThree.seen = true
        msgThree.when = formatter.date(from: "2022.02.08 21:33")
        
        let serverOne = Server(context: context)
        serverOne.id = "1"
        serverOne.ip = "192.168.0.1"
        
        let serverTwo = Server(context: context)
        serverTwo.id = "2"
        serverTwo.ip = "192.168.0.2"
        
        let serverThree = Server(context: context)
        serverThree.id = "3"
        serverThree.ip = "192.168.0.3"
        
        let denis = User(context: context)
        denis.login = "denis"
        denis.server = serverOne
        denis.publicKey = "denisPublicKey"
        
        let dima = User(context: context)
        dima.login = "dima"
        dima.server = serverOne
        dima.publicKey = "dimaPublicKey"
        
        let vlad = User(context: context)
        vlad.login = "vlad"
        vlad.server = serverTwo
        vlad.publicKey = "vladPublicKey"
        
        let sasha = User(context: context)
        sasha.login = "sasha"
        sasha.server = serverTwo
        sasha.publicKey = "sashaPublicKey"
        
        let newChat = Chat(context: context)
        newChat.with = denis
        newChat.addToMessages(msgOne)
        newChat.addToMessages(msgTwo)
        
        let newChatTwo = Chat(context: context)
        newChatTwo.with = vlad
        newChatTwo.addToMessages(msgThree)
        
        do {
            try context.save()
        } catch {
            print(error)
            fatalError("Error saving dummies")
        }
    }
}
