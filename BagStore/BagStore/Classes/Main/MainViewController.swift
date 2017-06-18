//
//  MainViewController.swift
//  BagStore
//
//  Created by vincentwen on 17/5/25.
//  Copyright © 2017年 vincentwen. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

          addChilVC(storyNames: ["Home", "Live", "Follow", "Profile"])
        

    }
    
    //定义添加子控制器的方法，通过StoryBoard 获取控制器，强制解包,传入一个数组
    private func addChilVC(storyNames : [String]){
        
        for storyName in storyNames{
           
            let chilVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
            
            //将chilVC作为子控制器
            addChildViewController(chilVC)
        }
        
    }
    
}
