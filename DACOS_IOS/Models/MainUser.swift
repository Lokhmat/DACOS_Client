//
//  MainUser.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 10.05.2022.
//

import Foundation
import CoreData
import SwiftyRSA

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
    
    static func tryRegisterUser(login: String, password: String, server: Server) -> Bool {
        if isRegistered() {
            return true
        }
        
        do {
            let keyPair = try SwiftyRSA.generateRSAKeyPair(sizeInBits: 2048)
            let privateKey = keyPair.privateKey
            
            let query = [kSecClass: kSecClassGenericPassword,
                        kSecAttrAccount: kSecAttrAccount,
                        kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
                        kSecUseDataProtectionKeychain: true,
                     kSecValueData: try privateKey.data()] as [String: Any]
            
            let code = SecItemAdd(query as CFDictionary, nil)
            if code != errSecSuccess{
                print(SecCopyErrorMessageString(code, nil) ?? "Alright")
            }
        }
        catch let error{
            print(error.localizedDescription)
        }
        
        let newSuperUser = SuperUser(context: context)
        newSuperUser.login = login
        newSuperUser.server = server
        do {
            try context.save()
            return true
        } catch {
            print(error)
            return false
        }
    }
}
