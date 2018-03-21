//
//  registerViewController.swift
//  HBook
//
//  Created by mac on 17/7/11.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import LeanCloud

/**
 * 当遇到输入框时应该考虑解盘遮挡问题
 */
class registerViewController: UIViewController {

    @IBOutlet weak var tfUsername: UITextField!
    
    @IBOutlet weak var tfPass: UITextField!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    //上边界索引
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }

    func initView(){
        //注册键盘隐藏和出现
        XKeyBoard.registerHide(self)
        XKeyBoard.registerShow(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //点击注册操作
    @IBAction func actionRegister(_ sender: AnyObject) {
        //判断用户名、密码、邮箱是否为空
        if tfUsername.text == "" {
            JLToast.makeText("用户名不能为空").show()
//            JLToast.makeText("用户名不能为空", duration: 1).show()
            return
        }
        if tfPass.text == "" {
            JLToast.makeText("密码不能为空").show()
            return
        }
        if tfEmail.text == "" {
            JLToast.makeText("邮箱不能为空").show()
            return
        }
        //开始注册
        let user = LCUser()
        user.username = LCString((tfUsername?.text)!)
        user.password = LCString((tfPass?.text)!)
        user.email = LCString((tfEmail?.text)!)
        //注册
        let result = user.signUp()
        //获取注册返回结果
        if result.isSuccess {
            JLToast.makeText("注册成功即将跳转到登录页").show()
            //通过ProgressHUP提示用户
//            ProgressHUD.showSuccess("注册成功即将跳转到登录页")
            let loginVC = loginViewController()
            self.dismiss(animated: true, completion: { 
                self.present(loginVC, animated: true, completion: {
                    print("跳转到登录页")
                })
            })
            
        }else{
//            let errorCode = result.error?.code
            JLToast.makeText((result.error?.reason)!).show()
        }
    }
    
    @IBAction func clickClose(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            print("关闭")
        }
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
