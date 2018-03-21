//
//  loginViewController.swift
//  HBook
//
//  Created by mac on 17/7/11.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import LeanCloud

class loginViewController: UIViewController {

    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    //上边界的索引
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //登录
    @IBAction func clickLogin(_ sender: AnyObject) {
        //判断用户名、密码、邮箱是否为空
        if tfUserName.text == "" {
            JLToast.makeText("用户名不能为空").show()
            //            JLToast.makeText("用户名不能为空", duration: 1).show()
            return
        }
        if tfPass.text == "" {
            JLToast.makeText("密码不能为空").show()
            return
        }
        //开始登录
        let rs = LCUser.logIn(username: tfUserName.text!, password: tfPass.text!)
        //获取注册返回结果
        if rs.isSuccess {
            print("登录成功")
//            JLToast.makeText("登录成功,即将跳转到主页").show()
            //通过ProgressHUP提示用户
            ProgressHUD.showSuccess("登录成功,即将跳转到主页")
            self.dismiss(animated: true, completion: {
                print("销毁登录页")
            })
//            let rankVC = rankViewController()
//            self.presentViewController(rankVC, animated: true, completion: { 
//                print("登录成功,即将跳转到主页")
//                self.dismissViewControllerAnimated(true, completion: { 
//                    print("销毁登录页")
//                })
//            })
        }else{
            //登录失败输出登录失败原因
//            JLToast.makeText((rs.error?.reason)!)
            //通过ProgressHUP提示用户
            ProgressHUD.showSuccess("登录失败：\(rs.error?.reason)")
            return
        }
    }
    func initView(){
        //注册键盘隐藏和出现
        XKeyBoard.registerHide(self)
        XKeyBoard.registerShow(self)
        //获取焦点弹出键盘
        self.becomeFirstResponder()
    }
    /**
     * 响应键盘事件
     * keyboardWillShowNotification
     */
    func keyboardWillShowNotification(_ notify: Notification){
        UIView.animate(withDuration: 0.3, animations: {
            print("开始执行动画")
            //将约束设置为-200,则界面会上移，需要将上移过程变慢用以下操作layoutIfNeeded():一帧一帧上移界面：动画
            self.topLayout.constant = -200
            self.view.layoutIfNeeded()
        }) 
    }
    
    func keyboardWillHideNotification(_ notify: Notification){
        UIView.animate(withDuration: 0.3, animations: {
            print("开始执行动画")
            //将约束设置为-200,则界面会上移，需要将上移过程变慢用以下操作layoutIfNeeded():一帧一帧上移界面：动画
            self.topLayout.constant = 8
            self.view.layoutIfNeeded()
        }) 
    }
}
