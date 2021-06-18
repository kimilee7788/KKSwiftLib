//
//  UIColor.swift
//  Scanner7
//
//  Created by lee kimi on 2021/5/8.
//

import Foundation
import UIKit
public extension UIColor{
    
    func dynamic(_ dark:String) -> UIColor{
        
        if #available(iOS 13.0, *) {
            
            let dynamicColor = UIColor.init { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark{
                    return dark.color
                }else{
                    return self
                }
            }
            return dynamicColor
        }else{
            return self
        }
        
        
    }
    
    public class func PythiaColorFromRGB(rgbValue:String) -> UIColor{
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        let hex:   String = rgbValue
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
            green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
            blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            return UIColor.init(red: red, green: green, blue: blue, alpha: 1)
        }else{
            return UIColor.black
        }
    }
    
    func colorWithAlpha(alpha:CGFloat) -> UIColor {
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var al:CGFloat = 1
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &al)
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
//    class var randomColor:UIColor{
//        get {
//            let red = CGFloat(arc4random()%256)/255.0
//            let green = CGFloat(arc4random()%256)/255.0
//            let blue = CGFloat(arc4random()%256)/255.0
//            return UIColor(red: red,green: green,blue: blue,alpha: 1.0)
//        }
//    }

}
