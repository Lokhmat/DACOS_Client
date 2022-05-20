//
//  NavigationMenuController.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 02.05.2022.
//

import UIKit
import CoreData

class NavigationMenuBaseController: UITabBarController, UISearchBarDelegate {
    var customTabBar: CustomTabBar!
    var tabBarHeight: CGFloat = 70
    let tabItems: [TabItem] = [.chats, .profile, .settings]
    var searchBar:UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        self.navigationItem.title = "Chats"
        searchBar.placeholder = "Insert login"
        searchBar.delegate = self
        searchBar.sizeToFit()
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customTabBar.backgroundColor = StyleExt.mainColor()
        searchBar.searchTextField.textColor = StyleExt.fontMainColor()
        navigationController?.navigationBar.barTintColor = StyleExt.mainColor()
        self.setupCustomTabMenu(tabItems) { (controllers) in
            self.viewControllers = controllers
        }
    }
    
    func setupTabBar() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.changedTheme(notification:)), name: UserDefaults.didChangeNotification, object: nil)
        // TODO: This causes warning; don't know maby bugs too.
        self.setupCustomTabMenu(tabItems) { (controllers) in
            self.viewControllers = controllers
        }
        self.selectedIndex = 0
    }
    
    func setupCustomTabMenu(_ menuItems: [TabItem], completion: @escaping ([UIViewController]) -> Void) {
        let frame = tabBar.frame
        var controllers = [UIViewController]()
        tabBar.isHidden = true
        self.customTabBar = CustomTabBar(menuItems: tabItems, frame: frame)
        self.customTabBar.translatesAutoresizingMaskIntoConstraints = false
        self.customTabBar.clipsToBounds = true
        self.customTabBar.itemTapped = self.changeTab
        self.view.addSubview(customTabBar)
        customTabBar.pinLeft(to: view)
        customTabBar.pinRight(to: view)
        customTabBar.setWidth(to: tabBar.frame.width)
        customTabBar.setHeight(to: tabBarHeight)
        customTabBar.pinBottom(to: view)
        for i in 0 ..< tabItems.count {
            controllers.append(tabItems[i].viewController)
        }
        self.view.layoutIfNeeded()
        completion(controllers)
    }
    
    func changeTab(tab: Int) {
        self.selectedIndex = tab
    }
    
    @objc func changedTheme(notification: Notification) {
        viewWillAppear(true)
        customTabBar.switchTab(from: 2, to: 0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let chatsManager = Chats()
        if let chat = chatsManager.getChats().first(where: {$0.with?.login == searchBar.text}) {
            let chatUI = ChatViewController()
            chatUI.setupChat(chat: chat)
            navigationController?.pushViewController(chatUI, animated: true)
        } else if let user = Users.getUsers().first(where: {$0.login == searchBar.text}) {
            let newChat = Chat(context: MainUser.context)
            newChat.with = user
            do {
                DispatchQueue.main.async {
                    do {
                        try MainUser.context.save()
                    } catch{}
                }
            } catch {}
            let chatUI = ChatViewController()
            chatUI.setupChat(chat: newChat)
            navigationController?.pushViewController(chatUI, animated: true)
        }
    }
}
