//
//  APIUser.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 21.05.2022.
//

import Foundation

import Foundation

struct ApiUser: Codable {
    var username: String
    var public_key: String
    var register_server: String
}

struct ApiUsers: Codable {
    var users: [ApiUser]
}
