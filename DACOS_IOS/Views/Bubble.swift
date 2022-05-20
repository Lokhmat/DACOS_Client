//
//  Bubble.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 21.05.2022.
//

import UIKit

class Bubble : UIView{
    
    let text = UILabel()
    
    public func initView(text: String, _ value: UIView?){
        self.addSubview(self.text)
        if (value != nil) {
            self.addSubview(value!)
            value!.pinCenter(to: self.centerYAnchor)
            value!.pinRight(to: self, 10)
        }
        self.text.pinLeft(to: self, 10)
        self.text.pinCenter(to: self.centerYAnchor)
        self.text.text = text
        self.text.textColor = StyleExt.fontMainColor()
    }
    
}
