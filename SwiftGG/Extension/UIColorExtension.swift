//
//  UIColorExtension.swift
//  SwiftGG
//
//  Created by 徐开源 on 16/3/14.
//  Copyright © 2016年 徐开源. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func ggBlueColor() -> UIColor {
        return UIColor(red:0.46, green:0.8, blue:0.95, alpha:1)
    }
    
    class func ggRedColor() -> UIColor {
        return UIColor(red:0.99, green:0.47, blue:0.43, alpha:1)
    }
    
    class func ggRandomColor() -> UIColor {
        let diceFaceCount: UInt32 = UInt32(2)
        let randomRoll = Int(arc4random_uniform(diceFaceCount))
        if randomRoll == 0 {
            return UIColor.ggRedColor()
        }else {
            return UIColor.ggBlueColor()
        }
    }
    
}