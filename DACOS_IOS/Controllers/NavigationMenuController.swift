//
//  NavigationMenuController.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 02.05.2022.
//

import UIKit

class NavigationMenuBaseController: UITabBarController {
    var customTabBar: CustomTabBar!
    var tabBarHeight: CGFloat = 70
    let tabItems: [TabItem] = [.chats, .profile, .settings]
    var searchBar:UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        self.navigationItem.title = "Чаты"
        searchBar.placeholder = "Your placeholder"
        searchBar.sizeToFit()
        var leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
    func setupTabBar() {
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
}
