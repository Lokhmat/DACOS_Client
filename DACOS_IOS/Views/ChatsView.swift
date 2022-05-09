//
//  ChatsView.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 02.05.2022.
//

import UIKit

class ChatsView : UIView {
    internal var table = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(table)
        table.pinTop(to: self)
        table.pinLeft(to: self)
        table.pinRight(to: self)
        table.pinBottom(to: self)
    }
}
