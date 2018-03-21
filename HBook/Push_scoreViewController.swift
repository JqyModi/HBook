//
//  Push_scoreViewController.swift
//  HBook
//
//  Created by mac on 17/7/10.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class Push_scoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }

}
