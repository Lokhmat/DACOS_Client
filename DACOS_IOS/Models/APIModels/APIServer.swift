//
//  APIServer.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 21.05.2022.
//

import Foundation

struct ApiServer: Codable {
    var public_key: String
    var url: String
}

struct ApiServers: Codable {
    var servers: [ApiServer]
}
