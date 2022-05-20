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
    
    static func getSuperUser() -> SuperUser? {
        let me = try? context.fetch(SuperUser.fetchRequest())
        if (me != nil && me?.count == 1) {
            return me![0]
        } else {
            return nil
        }
    }
    
    static func getKitSuperUser() -> Sender? {
        let me = try? context.fetch(SuperUser.fetchRequest())
        if (me != nil && me?.count == 1) {
            return Sender(senderId: me![0].login!, displayName: me![0].login!)
        } else {
            return nil
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
            let newSuperUser = SuperUser(context: context)
            newSuperUser.login = login
            newSuperUser.server = server
            newSuperUser.curBlock = 0
            newSuperUser.publicKey = try keyPair.publicKey.base64String()
        }
        catch let error{
            print(error.localizedDescription)
        }
        
        do {
            DispatchQueue.main.async {
                do {
                    try context.save()
                } catch{}
            }
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    static func getPublicKey() -> String?{
        let me = try? context.fetch(SuperUser.fetchRequest())
        if me != nil && !((me?.isEmpty)!) {
            return me![0].publicKey!
        }
        return nil
    }
    
    private static func fetchPrivate() -> Optional<Data>{
        let query = [kSecClass: kSecClassGenericPassword,
               kSecAttrAccount: kSecAttrAccount,
 kSecUseDataProtectionKeychain: true,
                kSecReturnData: true] as [String: Any]
        
        var item: CFTypeRef?
        switch SecItemCopyMatching(query as CFDictionary, &item) {
        case errSecSuccess:
            guard let data = item as? Data else { return nil }
            return data
            
        case errSecItemNotFound: return nil
        default: return nil
        }
    }
    
    static func tryDecrypt(msg: String) -> (Date, String, String)? {
        do {
            
            let formatter = ISO8601DateFormatter()
            let iso8601String = formatter.string(from: Date())
            
            let pk = try PrivateKey(data: fetchPrivate()!)
            let n_enc = try EncryptedMessage(base64Encoded: msg)
            let n_clear = try n_enc.decrypted(with: pk, padding: .PKCS1)
            print(n_clear)
            let arr = try n_clear.string(encoding: .unicode).split(separator: "©")
            return (ISO8601DateFormatter().date(from: String(arr[0])) ?? Date(), String(arr[1]), String(arr[2]))
        } catch let error{
            print(error.localizedDescription)
            print(error)
            return nil
        }
    }
}
