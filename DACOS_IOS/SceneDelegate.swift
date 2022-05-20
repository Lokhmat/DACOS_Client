//
//  SceneDelegate.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 02.05.2022.
//

import UIKit
import SwiftyRSA

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var usersTimer: Timer?
    var messagesTimer: Timer?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Populating DB with dumies chats remove in prod
        // let dummiesManager = Dummies()
        // dummiesManager.populateWithDummies()
        // TODO: REMOVE IN PROD
        
        if MainUser.isRegistered() {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            self.window = UIWindow(windowScene: windowScene)
            let nav1 = UINavigationController()
            let mainView = NavigationMenuBaseController()
            nav1.viewControllers = [mainView]
            self.window!.rootViewController = nav1
            self.window?.makeKeyAndVisible()
            usersTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                DispatchQueue.main.async {
                    Users.updateUsers()
                }
            }
            messagesTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
                DispatchQueue.main.async {
                    Messages.updateMessages()
                }
            }
        } else {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            self.window = UIWindow(windowScene: windowScene)
            let defaults = UserDefaults.standard
            defaults.set("Light", forKey: "Theme")
            let controller = RegisterViewController()
            Servers.updateServers(errorCallback: {controller.registration.help.text = "Connection error"})
            controller.changeScreen = moveToMainScreen
            self.window!.rootViewController = controller
            self.window!.makeKeyAndVisible()
        }
    }
    
    func temp(){
        do {
            /*
            let keyPair = try SwiftyRSA.generateRSAKeyPair(sizeInBits: 2048)
            let puk = try keyPair.publicKey.base64String()
            let prk = try keyPair.privateKey.base64String()
            print(puk)
            print()
            print(prk)
            print()
            
            let str = "Clear Text"
            let clear = try ClearMessage(string: str, using: .unicode)
            let encrypted = try clear.encrypted(with: PublicKey(base64Encoded: puk), padding: .PKCS1)
            let base64String = encrypted.base64String
            
            let n_encrypted = try EncryptedMessage(base64Encoded: base64String)
            let n_clear = try n_encrypted.decrypted(with: PrivateKey(base64Encoded: prk), padding: .PKCS1)
            let string = try n_clear.string(encoding: .unicode)
            print(string)*/
            
        } catch {}
        
        
    }
    
    func moveToMainScreen() {
        let nav1 = UINavigationController()
        let mainView = NavigationMenuBaseController()
        nav1.viewControllers = [mainView]
        self.window!.rootViewController = nav1
        self.window?.makeKeyAndVisible()
        usersTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            DispatchQueue.main.async {
                Users.updateUsers()
            }
        }
        messagesTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            DispatchQueue.main.async {
                Messages.updateMessages()
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

