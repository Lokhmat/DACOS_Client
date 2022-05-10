//
//  ChatExtesions.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 10.05.2022.
//

import Foundation

extension Chat {
    internal func getKitMessages() -> [MyMessage]{
        var result = [MyMessage]()
        for msg in self.messages?.allObjects as! [Message] {
            var sender: Sender = SuperUserExt.getSender()
            if msg.seen{
                sender = Sender(senderId: (with?.login)!, displayName: (with?.login)!)
            }
            result.append(MyMessage(sender: sender, messageId: String(msg.id.hashValue), sentDate: msg.when!, kind: .text(msg.payload!)))
        }
        return result
    }
}
