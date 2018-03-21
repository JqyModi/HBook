//
//  Push_descriptionViewController.swift
//  HBook
//
//  Created by mac on 17/7/10.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

typealias Push_descriptionCallBack = (_ descStr: String) -> Void

class Push_descriptionViewController: UIViewController {
    //存储输入描述信息
    var desc: JVFloatLabeledTextView?
    //
    var callback: Push_descriptionCallBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        //注册键盘管理库
        XKeyBoard.registerHide(self)
        XKeyBoard.registerShow(self)
        
        self.desc = JVFloatLabeledTextView(frame: CGRect(x: 8,y: 58,width: SCREEN_WIDTH-16,height: SCREEN_HEIGHT-58-8))
        self.view.addSubview(desc!)
        desc?.placeholder = "请输入该书的详细信息、吐槽、或书评"
        desc?.font = UIFont(name: MAIN_FONT1, size: 17)
        desc?.tintColor = UIColor.gray
        //键盘弹出
        self.desc?.becomeFirstResponder()
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
        self.callback!((self.desc?.text)!)
        self.dismiss(animated: true) {
            print("关闭回调")
            
        }
    }
    
    //键盘显示
    func keyboardWillShowNotification(_ notify: Notification){
        print("键盘显示")
        //处理键盘遮挡
        //1.获取到键盘的窗体大小
        let keyboardRect = XKeyBoard.returnWindow(notify)
        //2.将输入框的边界上移
        self.desc?.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0)
    }
    //键盘隐藏
    func keyboardWillHideNotification(_ notify: Notification){
        print("键盘隐藏")
        //还原输入框移动的距离
        self.desc?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }

}
