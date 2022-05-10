//
//  MainUser.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 10.05.2022.
//

import Foundation
import CoreData

class MainUser {
    static let context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "DACOS_IOS")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Container loading failed")
            }
        }
        return container.viewContext
    }()
    
    static func isRegistered() -> Bool {
        let me = try? context.fetch(SuperUser.fetchRequest())
        if (me != nil && me?.count == 1) {
            return true
        } else {
            return false
        }
    }
    
    static func tryRegisterUser() -> Bool {
        if isRegistered() {
            return true
        }
        
        return true
    }
}
