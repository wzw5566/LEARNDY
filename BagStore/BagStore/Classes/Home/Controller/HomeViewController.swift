//
//  HomeViewController.swift
//  BagStore
//
//  Created by vincentwen on 17/6/2.
//  Copyright © 2017年 vincentwen. All rights reserved.
//

import UIKit

// 定义常量TitleView的高度，常量以k开头
private let kTitleViewH : CGFloat = 40


class HomeViewController: UIViewController {

    // MARK：闭包定义懒加载的PageTitleView
    fileprivate lazy var pageTitleView: PageTitleView = {
        
        //1.编写闭包创建pageTitleView的具体内容，创建PageTitleView需要传入两个参数，Frame，title数组
        
        //2.定义titleFrame
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        
        //3.定义titles标题数组
        let titles = ["推荐","游戏","娱乐","趣玩"]
        
        //4.调用PageTitleView的自定义构造函数来构建PageTitleView
        
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        
        titleView.delegate = self
        
        
        //5.返回PageTitleView
        return titleView
        
    
    }()
    
    // MARK: 闭包定义，懒加载的PageContentView
    fileprivate lazy var pageContentView: PageContentView = { [weak self] in
        
        
        // 1.确定内容的Frame
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH - kTabbarH
        
        //定义contentFrame
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        
        var childVcs = [UIViewController]()
        
        for _ in 0..<4{
            
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            
            childVcs.append(vc)
        }
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        
        contentView.delegate = self
        
        return contentView
  
    
    }()
    
    
    
    // MARK：系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //调用设置UI界面的方法
        setupUI()

    }

}

// MARK: 设置UI界面
extension HomeViewController {
    
    //设置UI方法，全部关于UI的设置的方法都在这里统一调用
    fileprivate func setupUI() {
        
        //0.不需要设置ScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        //1.调用设置导航栏的方法
        setupNavigationBar()
        
        //2.添加PageTitleView
        view.addSubview(pageTitleView)
        
        //3.添加PageContentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.blue
    
    
    }
    
    //设置导航栏
    fileprivate func setupNavigationBar(){
        
        //MARK: 1.设置左侧item logo
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        // MARK: 2.设置右侧的Item
        
        //定义item图标的大小
        let size = CGSize(width: 40, height: 40)
        
        //定义历史搜索图标
        let histtoryItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "image_my_history_click", size: size)
        
        //定义搜索图标
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        
        //定义扫描图标
        let qrcodeItem = UIBarButtonItem(imageName: "image_scan", highImageName: "image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [histtoryItem,searchItem, qrcodeItem ]
        
    
    }
}


//遵守PageTitleView代理协议
extension HomeViewController : PageTitleViewDelegate{
    
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        
        pageContentView.setCurrentIndex(index)
    }
    
    
}

//遵循PageContentView的协议
extension HomeViewController : PageContentViewDelegate{
    
    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        
        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)

    }
    
}
