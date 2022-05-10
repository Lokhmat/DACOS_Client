//
//  Servers.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 10.05.2022.
//

import Foundation
import CoreData

class Servers {
    
    static func updateServers() {
        // TODO: GO TO SERVER AND FETCH SERVERS
    }
    
    static func getServers() -> [Server]{
        let servers = try? MainUser.context.fetch(Server.fetchRequest())
        if (servers != nil && servers?.count != 0) {
            return servers!
        } else {
            return []
        }
    }
}
