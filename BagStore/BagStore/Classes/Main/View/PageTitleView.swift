//
//  PageTitleView.swift
//  BagStore
//
//  Created by vincentwen on 17/6/6.
//  Copyright © 2017年 vincentwen. All rights reserved.
//

import UIKit


// MARK: 定义代理，只能被类遵守
protocol PageTitleViewDelegate: class  {
    func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int )

}



// MARK: 定义常量
//1.定义ScrollView的线的高度
private let kScrollLineH:CGFloat = 2.0
//2.定义默认的颜色和选中颜色 RGB值
private let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85,85,85)
private let kSelectColor: (CGFloat, CGFloat, CGFloat) = (255,128,0)
//3.定义lable的字体大小16
private let kFontSize: CGFloat = 16.0

class PageTitleView: UIView {
    
    // MARK:自定义属性，定义数组来存储传入的titles参数
    fileprivate var titles : [String]
    
    //定义当前的lable的Index
    fileprivate var currentIndex : Int = 0
  
    // 定义代理
    weak var delegate : PageTitleViewDelegate?


    
    //懒加载titleLabels
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    //懒加载ScrollLine 闭包
    fileprivate lazy var scrollLine : UIView = {
        
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
        
    }()
    
    // MARK: 懒加载，闭包创建UIScrollView
    fileprivate lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        
        //scrolView 的水平线设置为不显示
        scrollView.showsHorizontalScrollIndicator = false
        
        //需要设置状态栏点击，要吧scrollsToTop 关闭
        scrollView.scrollsToTop = false
        
        //scrolView 不允许超过容器的大小
        scrollView.bounces = false
        
        return scrollView
      
        
    }()

    //MARK：自定义构造函数,传入要显示的titles 数组
    init(frame: CGRect,titles: [String]) {
        
        self.titles = titles
        
        super.init(frame: frame)
        
        // 调用设置UI方法的函数
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: 对PageTittleView进行扩展,进行设置UI
extension PageTitleView{
    
    // 定义设置UI的方法
    fileprivate func setupUI(){
        
        //编写具体的UI设置代码
        
        //1.添加ScrollView
        addSubview(scrollView)
        
        scrollView.frame = bounds
        
        // 2.添加title到对应的lable
        setupTitleLables()
        
        //3.添加下划线和滑块
        setupBottomLineAndScrollLine()
        
        
    }
    
    // MARK: 设置title到对应的lable
    fileprivate func setupTitleLables(){
        
        // MARK: 0.确定label的一些Frame值 设置lable的 frame，有frame才能显示,frame 包括： Width ，Height， X， Y

        //lable的宽度 = lable的数量平分 frame的宽度，将int型强转成CGFloat
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        //容器的高度 - Scroll下划线的高度
        let labelH: CGFloat = frame.height - kScrollLineH
        let labelY: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            
            // 1.创建lable
            let label = UILabel()
            
            // 2.设置lable的属性
            label.text = title
            label.tag = index
            //设置lable的字体大小
            label.font = UIFont.systemFont(ofSize: kFontSize)
            //设置lable的默认颜色,通过设置的常量颜色数组下标
            label.textColor = UIColor(r: kNormalColor.0 ,g:kNormalColor.1, b:kNormalColor.2)
            label.textAlignment = .center
            
            // 3.设置label的Frame
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            //4. 将label 添加到 ScrollView中
            scrollView.addSubview(label)
            titleLabels.append(label)
            
             //5.给Label添加手势
            
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action:#selector(self.titleLableClick(_:)))
            label.addGestureRecognizer(tapGes)
            
        
            
            
        }
    }
    
    // MARK:
    fileprivate func setupBottomLineAndScrollLine(){
        
        // 1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH:CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        //2.添加ScrollLine
        
        //2.1获取第一个label,通过第一个balel的位置判断其他的位置
        
        //guard 校验是否存在
        guard let firstLabel = titleLabels.first else { return }
        
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        //2.2 设置ScrolLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)

        
    }
    
}

extension PageTitleView{
    @objc fileprivate func titleLableClick(_ tagGes : UITapGestureRecognizer){
    
        // 0.获取当前Label，如果没有拿到点击，直接返回
        guard let currentLabel = tagGes.view as? UILabel else { return }
        
        // 1.如果是重复点击同一个Title,那么直接返回
        if currentLabel.tag == currentIndex { return }
        
        // 2.获取之前的Label
        let oldLabel = titleLabels[currentIndex]
        
        // 3.切换文字的颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        // 4.保存最新Label的下标值
        currentIndex = currentLabel.tag
        
        // 5.滚动条位置发生改变
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15, animations: {
            self.scrollLine.frame.origin.x = scrollLineX
        })
        
        //6.通知代理，进行事件处理
        delegate? .pageTitleView(self, selectedIndex: currentIndex)
    
    }
    
    
    
}

// MARK:- 对外暴露的方法
extension PageTitleView {
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
    }
}

  
