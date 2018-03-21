//
//  BookTitleView.swift
//  HBook
//
//  Created by mac on 17/7/7.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

//定义一个oc协议：支持可选
@objc protocol bookTitleDelegate {
    @objc optional func clickCover()
}

class BookTitleView: UIView, bookTitleDelegate {
    
    var bookCover: UIButton?
    //导入一个第三方库来实现安卓中的点击输入框提示文字上浮效果
    var bookName: JVFloatLabeledTextField?
    var bookEditor: JVFloatLabeledTextField?
    weak var delegate: bookTitleDelegate?
    //重写父类构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        //
        self.intiView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func intiView(){
        self.delegate = self
        bookCover = UIButton(frame: CGRect(x: 10,y: 8,width: 110,height: 141))
        bookCover?.setImage(UIImage(named: "Cover"), for: UIControlState())
        
        bookName = JVFloatLabeledTextField(frame: CGRect(x: 128,y: 8+40,width: (SCREEN_WIDTH-128-15),height: 30))
        bookEditor = JVFloatLabeledTextField(frame: CGRect(x: 128,y: 8+40+70,width: (SCREEN_WIDTH-128-15),height: 30))
        
//        bookName?.setPlaceholder("书名", floatingTitle: "书名")
//        bookEditor?.setPlaceholder("作者", floatingTitle: "作者")
        bookName?.placeholder = "书名"
        bookEditor?.placeholder = "作者"
        //
        bookName?.font = UIFont(name: MAIN_FONT1, size: 20)
        bookEditor?.font = UIFont(name: MAIN_FONT1, size: 20)
        
        bookCover?.addTarget(self, action: #selector(BookTitleView.clickbtn(_:)), for: UIControlEvents.touchUpInside)
        
        self.addSubview(bookCover!)
        self.addSubview(bookName!)
        self.addSubview(bookEditor!)
    }

    func clickbtn(_ sender: UIButton) {
        //通过该点击事件回调协议操作
        self.delegate?.clickCover!()
    }
}
