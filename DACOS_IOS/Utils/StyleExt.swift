//
//  StyleExt.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 21.05.2022.
//

import UIKit

class StyleExt {
    static let lightMain = UIColor.white
    static let lightSupport = #colorLiteral(red: 0.9450184703, green: 0.945151031, blue: 0.944976747, alpha: 1)
    static let darkMain = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let darkSupport = #colorLiteral(red: 0.156681031, green: 0.156714499, blue: 0.15667665, alpha: 1)
    
    static func isDark() -> Bool {
        return UserDefaults.standard.string(forKey: "Theme") == "Dark"
    }
    
    static func mainColor() -> UIColor {
        if isDark() {
            return darkMain
        }
        return lightMain
    }
    
    static func fontMainColor() -> UIColor {
        if isDark() {
            return lightMain
        }
        return darkMain
    }

    
    static func supColor() -> UIColor {
        if isDark() {
            return darkSupport
        }
        return lightSupport
    }
}

public extension UIImage {
      convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
      }

}

public extension String {
 func getColor() -> UIColor {
    let seed = self ?? ""
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
