//
//  SuperUser.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 10.05.2022.
//

import Foundation

class SuperUserExt {
    
    internal static func getSender() -> Sender {
        return Sender(senderId: "superUser", displayName: "me")
    }
}
