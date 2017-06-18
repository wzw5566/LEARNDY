//
//  UIBarButtonItem-Extension.swift
//  BagStore
//
//  Created by vincentwen on 17/6/2.
//  Copyright © 2017年 vincentwen. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    //MARK: 在extension中只能构造便利构造函数，便利构造函数: 1> convenience开头 2> 在构造函数中必须明确调用一个设计的构造函数(self)
    
    //传入默认的图片名，高亮选中图片名，size属性，默认值为CGSize.zero
    convenience init(imageName : String,highImageName : String = "", size : CGSize = CGSize.zero) {
        
        // 1.构建UIButton
        let btn = UIButton()
        //设置默认的显示图标
        btn.setImage(UIImage(named: imageName), for: UIControlState())
        
        //2.设置高亮显示
        if highImageName != "" {
            
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
            
        }
        
        //3.设置btn的size
        if size == CGSize.zero {
            
            btn.sizeToFit()
        }
        else{
            
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        //4.构建UIBarButton
        self.init(customView : btn)
        
    }
}
