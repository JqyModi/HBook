//
//  GenaralFactory.swift
//  HBook
//
//  Created by mac on 17/7/7.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

/*
 通过工厂模式来生成每个页面的顶部导航栏按钮
 */
class GeneralFactory: NSObject {
    //设置左右两边的导航栏按钮
    static func setTitleWithTile(_ target: UIViewController, leftTitle: String="关闭", rightTitle: String="确认"){
        //创建左边按钮
        let leftBtn = UIButton(frame: CGRect(x: 10,y: 20,width: 50,height: 20))
        //这样设置无效
//        leftBtn.titleLabel?.text = leftTitle
        //设置按钮文字内容
        leftBtn.setTitle(leftTitle, for: UIControlState())
        leftBtn.setTitleColor(MAIN_RED, for: UIControlState())
//        leftBtn.titleLabel?.textColor = UIColor.redColor()
        leftBtn.titleLabel?.font = UIFont(name: MAIN_FONT1, size: 20)
        //方便后面获取到按钮实例来更改按钮样式
        leftBtn.tag = 1234
        target.view.addSubview(leftBtn)
        print("左边按钮设置成功")
        //创建右边按钮
        let rightBtn = UIButton(frame: CGRect(x: (SCREEN_WIDTH - 60),y: 20,width: 50,height: 20))
        //设置文本内容
        rightBtn.setTitle(rightTitle, for: UIControlState())
        rightBtn.setTitleColor(MAIN_RED, for: UIControlState())
        rightBtn.titleLabel?.font = UIFont(name: MAIN_FONT1, size: 20)
        rightBtn.tag = 1235
        print("右边按钮设置成功")
        target.view.addSubview(rightBtn)
        //设置左右按钮的点击事件回调
        leftBtn.addTarget(target, action: "close:", for: UIControlEvents.touchUpInside)
        rightBtn.addTarget(target, action: "sure:", for: UIControlEvents.touchUpInside)
        
    }
}
