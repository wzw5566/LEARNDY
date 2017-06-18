//
//  UIColor-Extension.swift
//  BagStore
//
//  Created by vincentwen on 17/6/10.
//  Copyright © 2017年 vincentwen. All rights reserved.
//

import UIKit

extension UIColor{
    

    //自定义构造函数
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    //生成随机颜色
    class func randomColor() ->UIColor{
        
    return UIColor(r: CGFloat(arc4random_uniform(256)), g:  CGFloat(arc4random_uniform(256)), b:  CGFloat(arc4random_uniform(256)))
    
    }
    
}
