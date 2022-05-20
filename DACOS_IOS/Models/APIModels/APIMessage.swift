//
//  APIMessage.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 21.05.2022.
//

import Foundation

struct ApiMessages : Decodable{
    var block_number: Int
    var messages: [String]
}
