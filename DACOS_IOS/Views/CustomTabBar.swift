//
//  TabNavigationMenu.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 02.05.2022.
//

import UIKit

class CustomTabBar: UIView {
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(menuItems: [TabItem], frame: CGRect) {
        self.init(frame: frame)
        self.layer.backgroundColor = UIColor.white.cgColor
        for i in 0 ..< menuItems.count {
            let itemWidth = self.frame.width / CGFloat(menuItems.count)
            let leadingAnchor = itemWidth * CGFloat(i)
            let itemView = self.createTabItem(item: menuItems[i], itemWidth: itemWidth)
            itemView.tag = i
            self.addSubview(itemView)
            itemView.setWidth(to: itemWidth)
            itemView.setHeight(to: 70)
            itemView.pinLeft(to: self.leadingAnchor, leadingAnchor)
            if i != menuItems.count - 1 {
                let separator = UIView()
                separator.setWidth(to: 1)
                separator.setHeight(to: 60)
                separator.backgroundColor = .systemGray
                self.addSubview(separator)
                separator.pinRight(to: itemView)
                separator.pinTop(to: self, 5)
            }
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.activateTab(tab: 0)
    }
    
    func createTabItem(item: TabItem, itemWidth: CGFloat) -> UIView {
        let tabBarItem = UIView(frame: CGRect.zero)
        tabBarItem.backgroundColor = #colorLiteral(red: 0.9528383613, green: 0.9529978633, blue: 0.9528173804, alpha: 0.6790227566)
        let itemTitleLabel = UILabel(frame: CGRect.zero)
        let itemIconView = UIImageView(frame: CGRect.zero)
        itemTitleLabel.text = item.displayTitle
        itemTitleLabel.textAlignment = .center
        itemIconView.image = item.icon.withRenderingMode(.automatic)
        tabBarItem.addSubview(itemIconView)
        tabBarItem.addSubview(itemTitleLabel)
        itemIconView.setHeight(to: itemWidth / 4)
        itemIconView.setWidth(to: itemWidth / 4)
        itemIconView.pinTop(to: tabBarItem, 3)
        itemIconView.pinLeft(to: tabBarItem, 3 * itemWidth / 8 )
        itemTitleLabel.pinTop(to: itemIconView.bottomAnchor, 2)
        itemTitleLabel.setWidth(to: itemWidth)
        itemTitleLabel.font = UIFont.systemFont(ofSize: 12.0)
        tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        return tabBarItem
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.switchTab(from: self.activeItem, to: sender.view!.tag)
    }
    
    func switchTab(from: Int, to: Int) {
        self.deactivateTab(tab: from)
        self.activateTab(tab: to)
    }
    
    func activateTab(tab: Int) {
        let tabToActivate = self.subviews[2 * tab]
        let borderWidth = tabToActivate.frame.size.width - 20
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.systemBlue.cgColor
        borderLayer.name = "active border"
        borderLayer.frame = CGRect(x: 10, y: 0, width: borderWidth, height: 2)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseIn, .allowUserInteraction], animations: {
                tabToActivate.layer.addSublayer(borderLayer)
                tabToActivate.setNeedsLayout()
                tabToActivate.layoutIfNeeded()
            })
            self.itemTapped?(tab)
        }
        self.activeItem = tab
    }
    
    func deactivateTab(tab: Int) {
        let inactiveTab = self.subviews[2 * tab]
        let layersToRemove = inactiveTab.layer.sublayers!.filter({ $0.name == "active border" })
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseIn, .allowUserInteraction], animations: {
                layersToRemove.forEach({ $0.removeFromSuperlayer() })
                inactiveTab.setNeedsLayout()
                inactiveTab.layoutIfNeeded()
            })
        }
    }
}
