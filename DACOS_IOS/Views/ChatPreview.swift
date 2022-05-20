//
//  ChatPreview.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 03.05.2022.
//

import UIKit

class ChatPreview : UITableViewCell {
    private let picture = UIView()
    private var timeLabel = UILabel()
    private let login = UILabel()
    private let lastMsg = UILabel()
    
    public func initView(login: String, msg: String, date: Date){
        //setHeight(to: 90)
        self.addSubview(picture)
        self.addSubview(self.login)
        self.addSubview(lastMsg)
        self.addSubview(timeLabel)
        self.login.text = login
        let calendar = Calendar.current
        lastMsg.text = msg
        timeLabel.text = "\(calendar.component(.hour, from: date)):\(calendar.component(.minute, from: date))"
        backgroundColor = #colorLiteral(red: 0.9458501935, green: 0.9460085034, blue: 0.9458294511, alpha: 1)
        picture.pinLeft(to: self, 10)
        picture.pinTop(to: self, 10)
        picture.setHeight(to: 70)
        picture.setWidth(to: 70)
        picture.clipsToBounds = true
        picture.layer.cornerRadius = 35
        picture.backgroundColor = getColor()
        
        self.login.pinTop(to: self, 10)
        self.login.pinLeft(to: picture.trailingAnchor, 10)
        self.login.font = UIFont.systemFont(ofSize: 20.0)
        
        lastMsg.pinTop(to: self.login.bottomAnchor, 5)
        lastMsg.pinLeft(to: picture.trailingAnchor, 10)
        lastMsg.textColor = #colorLiteral(red: 0.4782508016, green: 0.4783350825, blue: 0.4782396555, alpha: 1)
        lastMsg.font = UIFont.systemFont(ofSize: 15.0)
        lastMsg.setWidth(to: frame.width / 2.0)
        
        timeLabel.pinRight(to: self, 10)
        timeLabel.pinTop(to: self, 35)
        timeLabel.textColor = #colorLiteral(red: 0.4782508016, green: 0.4783350825, blue: 0.4782396555, alpha: 1)
        timeLabel.font = UIFont.systemFont(ofSize: 15.0)
    }
    
    public func setTime(time: String){
        timeLabel.text = time
    }
    
    private func getColor() -> UIColor {
        let seed = login.text ?? ""
        var total: Int = 0
        for u in seed.unicodeScalars {
            total += Int(UInt32(u))
        }
        
        srand48(total * 200)
        let r = CGFloat(drand48())
        
        srand48(total)
        let g = CGFloat(drand48())
        
        srand48(total / 200)
        let b = CGFloat(drand48())
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
