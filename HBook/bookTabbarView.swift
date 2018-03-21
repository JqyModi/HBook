//
//  bookTabbarView.swift
//  HBook
//
//  Created by mac on 17/7/13.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

//1.定义事件委托
protocol bottomBarDelegate {
    func clickPen()
    func clickChat()
    func clickHeart(_ btn: UIButton)
    func clickShare()
}
class bookTabbarView: UIView {

    //2.声明委托
    var delegate: bottomBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //
        self.initView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override drawRect: if you perform custom drawing.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //绘制底部tabbar分割线
        //1.获取当前画布所指向上下文
        let context = UIGraphicsGetCurrentContext()
        //2.设置线宽:线宽设置到2才能全部绘制出来？？ bug
        context?.setLineWidth(0.5)
        //设置画笔颜色
        context?.setStrokeColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)
        //设置起始位置坐标
        //同时绘制4条竖线
        for i in 1 ..< 4 {
            context?.move(to: CGPoint(x: CGFloat(i) * SCREEN_WIDTH/4, y: rect.size.height*0.1))
            context?.addLine(to: CGPoint(x: CGFloat(i) * SCREEN_WIDTH/4, y: rect.size.height*0.9))
        }
        //绘制tabbar上边界分割线
        context?.move(to: CGPoint(x: 8, y: 0))
        context?.addLine(to: CGPoint(x: rect.size.width-8, y: 0))
        //绘画
        context?.strokePath()
        
    }

    func initView(){
        //设置背景色
        self.backgroundColor = UIColor.white
        
        //初始化几个按钮
        let imgs = ["Pen 4","chat 3","heart","box outgoing"]
        //绘制并添加点击事件
        for i in 0 ..< 4 {
            let btn = UIButton(frame: CGRect(x: CGFloat(i) * frame.size.width/4, y: 0, width: frame.size.width/4, height: frame.size.height))
            //设置图片
            btn.setImage(UIImage(named: imgs[i]), for: UIControlState())
            self.addSubview(btn)
            //设置tag ： 相当于ID ：并设置点击事件
            btn.tag = i
            btn.addTarget(self, action: #selector(bookTabbarView.clickTabBtn(_:)), for: UIControlEvents.touchUpInside)
        }
    }
    
    func clickTabBtn(_ sender: UIButton){
        print("点击了： \(sender.tag)")
        let tag = sender.tag
        switch tag {
        case 0:
            //
            self.delegate?.clickPen()
            break;
        case 1:
            self.delegate?.clickChat()
            break;
        case 2:
            self.delegate?.clickHeart(sender)
            break;
        case 3:
            self.delegate?.clickShare()
            break;
        default:
            break;
        }
    }

}
