//
//  Push_titleViewController.swift
//  HBook
//
//  Created by mac on 17/7/10.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

/*
 实现回调的三种方式
 1.delegate 
 2.Block 闭包
 3.通知 NsNotification
 */

//1.定义一个闭包：Block
typealias Push_titleCallBack = (_ title: String) ->Void

class Push_titleViewController: UIViewController {

    var tf: UITextField?
    //2.声明callback
    var callback: Push_titleCallBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        //初始化textField
        tf = UITextField(frame: CGRect(x: 15,y: 60,width: SCREEN_WIDTH-30,height: 30))
        tf?.placeholder = "请输入标题"
        tf?.font = UIFont(name: MAIN_FONT1, size: 18)
        //圆角
        tf?.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(tf!)
        
        //获取焦点
        tf?.becomeFirstResponder()
    }
    
    //实现左右标题按钮点击事件回调
    func close(_ sender: UIButton){
        print("返回按钮回调")
        self.dismiss(animated: true) { 
            print("关闭回调")
            
        }
    }

    func sure(_ sender: UIButton){
        print("确认按钮回调")
        self.dismiss(animated: true) {
            print("关闭回调")
            //3.返回时通过callback回调返回数据:调用的时候需要实现该callback否则会报错
            self.callback!((self.tf?.text)!)
        }
    }
}
