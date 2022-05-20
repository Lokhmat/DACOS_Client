//
//  ChatExtesions.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 10.05.2022.
//

import Foundation
import SwiftyRSA

extension Chat {
    internal func getKitMessages() -> [MyMessage]{
        var result = [MyMessage]()
        for msg in self.messages?.allObjects as! [Message] {
            var sender: Sender = MainUser.getKitSuperUser()!
            if msg.seen{
                sender = Sender(senderId: (with?.login)!, displayName: (with?.login)!)
            }
            result.append(MyMessage(sender: sender, messageId: String(msg.id.hashValue), sentDate: msg.when!, kind: .text(msg.payload!)))
        }
        return result
    }
}

extension String{
    func getShipheredForSameServer(chat: Chat) -> String?{
        do {
            let formatter = ISO8601DateFormatter()
            let iso8601String = formatter.string(from: Date())
            
            let key = (chat.with?.publicKey!)!
            let publicKey = try PublicKey(base64Encoded: key)
            let clear = try ClearMessage(string: "\(iso8601String)©\(self)©\((MainUser.getSuperUser()!.login)!)", using: .unicode)
            let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
            return encrypted.base64String
        } catch {
            return nil
        }
    }
}
