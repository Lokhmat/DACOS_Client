//
//  Messages.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 21.05.2022.
//

import Foundation

class Messages {
    
    static func updateMessages() {
        let me = MainUser.getSuperUser()!
        var request = URLRequest(url: URL(string: "http://\(me.server!.ip!)/messages/get?block_number=\(me.curBlock)")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let decoder = JSONDecoder()
                let messages = try decoder.decode(ApiMessages.self, from: data as Data)
                for msg in messages.messages{
                    if let decrypted = MainUser.tryDecrypt(msg: msg) {
                        let newMsg = Message(context: MainUser.context)
                        newMsg.payload = decrypted.1
                        newMsg.seen = true
                        newMsg.when = decrypted.0
                        if let chat = Chats().getChats().first(where: {$0.with?.login == decrypted.2}) {
                            chat.addToMessages(newMsg)
                        } else {
                            let newChat = Chat(context: MainUser.context)
                            let user = Users.getUsers().first(where: {$0.login == decrypted.2})
                            if user != nil{
                                newChat.with = user
                                newChat.messages = []
                                newChat.addToMessages(newMsg)
                            } else {
                                return
                            }
                        }
                    }
                }
                MainUser.getSuperUser()?.curBlock = Int32(messages.block_number)
                DispatchQueue.main.async {
                    do {
                        DispatchQueue.main.async {
                            do {
                                try MainUser.context.save()
                            } catch{}
                        }
                    } catch{}
                }
            } catch {}
        }
        
        task.resume()
    }
}
