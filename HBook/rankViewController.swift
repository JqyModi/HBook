//
//  rankViewController.swift
//  HBook
//
//  Created by mac on 17/7/6.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import LeanCloud
import AVOSCloud

class rankViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        // 测试第三方字体是否导入成功
//        let title = UILabel(frame: CGRect(x: (SCREEN_WIDTH-200)/2, y: (SCREEN_HEIGHT-50)/2, width: 200, height: 50))
//        title.text = "排行榜单,modi hello"
//        title.center = self.view.center
//        title.adjustsFontSizeToFitWidth = true
//        title.textAlignment = NSTextAlignment.Center
//        title.font = UIFont(name: MAIN_FONT1, size: 20)
//        self.view.addSubview(title)
//        //字体名称都有哪些 我们可以通过如下方法得到
//        let arr=UIFont.familyNames()
//        print(arr)

        //第一个界面判断用户是否登录：否则跳转到登录界面
        LCUser.logIn(username: "modi", password: "modi")
        //两个SDK同事登录：为了利用AVOSCloud SDK上传图片到服务器
        AVUser.logIn(withUsername: "modi", password: "modi")
        
        if LCUser.current == nil {
            //先获取storyboard
            let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
            //在可视化布局界面中设置Identifier = Login
            let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "Login")
            self.present(loginVC, animated: true, completion: {
                print("跳转到登录页")
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
