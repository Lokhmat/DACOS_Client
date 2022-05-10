//
//  MessageKitStructs.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 10.05.2022.
//

import Foundation
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct MyMessage: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
