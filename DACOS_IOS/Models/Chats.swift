//
//  Chats.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 03.05.2022.
//

import Foundation
import CoreData

class Chats {
    private var chats: [Chat] = []
        let context: NSManagedObjectContext = {
            let container = NSPersistentContainer(name: "DACOS_IOS")
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Container loading failed")
                }
            }
            return container.viewContext
        }()
        
        public func getChats() -> [Chat]{
            let newChats = try? context.fetch(Chat.fetchRequest())
            if (newChats != nil && newChats?.count != 0) {
                self.chats = newChats!
            } else {
                saveChanges()
            }
            return chats
        }
        
        public func getChat(id: Int) -> Chat{
            return chats[id]
        }
        
        public func saveChanges(){
            if context.hasChanges {
                try? context.save()
            }
            if let chats = try? context.fetch(Chat.fetchRequest()) {
                self.chats = chats
            } else {
                self.chats = []
            }
        }
}
