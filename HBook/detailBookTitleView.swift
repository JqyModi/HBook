//
//  detailBookTitleView.swift
//  HBook
//
//  Created by mac on 17/7/13.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class detailBookTitleView: UIView {

    var cover: UIImageView?
    var name: UILabel?
    var editor: UILabel?
    //编者：就是上传书评的人
    var userName: UILabel?
    var score: LDXScore?
    var more: UILabel?
    var date: UILabel?
    //记录view的宽高
    var VIEW_WIDTH: CGFloat?
    var VIEW_HEIGHT: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.VIEW_WIDTH = frame.size.width
        self.VIEW_HEIGHT = frame.size.height
        
        self.initView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        self.backgroundColor = UIColor.white
        
        //初始化UI并添加到View上
        self.cover = UIImageView(frame: CGRect(x: 8,y: 8,width: (VIEW_HEIGHT! - 16)/1.273,height: VIEW_HEIGHT!-16))
        self.addSubview(self.cover!)
        
        self.name = UILabel(frame: CGRect(x: (VIEW_HEIGHT! - 16)/1.273+16,y: 8,width: VIEW_WIDTH! - (VIEW_HEIGHT! - 16)/1.273 - 16,height: VIEW_HEIGHT!/4))
        self.name?.font = UIFont(name: MAIN_FONT1, size: 18)
        self.addSubview(self.name!)
        
        self.editor = UILabel(frame: CGRect(x: (VIEW_HEIGHT! - 16)/1.273+16,y: 8+VIEW_HEIGHT!/4,width: VIEW_WIDTH! - (VIEW_HEIGHT! - 16)/1.273 - 16,height: VIEW_HEIGHT!/4))
        self.editor?.font = UIFont(name: MAIN_FONT1, size: 18)
        self.addSubview(self.editor!)
        
        
        self.userName = UILabel(frame: CGRect(x: (VIEW_HEIGHT! - 16)/1.273+16,y: 24+VIEW_HEIGHT!/4+VIEW_HEIGHT!/6,width: VIEW_WIDTH! - (VIEW_HEIGHT! - 16)/1.273 - 16,height: VIEW_HEIGHT!/6))
        self.userName?.font = UIFont(name: MAIN_FONT1, size: 13)
        self.userName?.textColor = RGB(35, g: 87, b: 139)
        self.addSubview(self.userName!)
        
        self.date = UILabel(frame: CGRect(x: (VIEW_HEIGHT! - 16)/1.273+16,y: 16+VIEW_HEIGHT!/4+VIEW_HEIGHT!/6*2,width: 80,height: VIEW_HEIGHT!/6))
        self.date?.font = UIFont(name: MAIN_FONT1, size: 13)
        self.date?.textColor = UIColor.gray
        self.addSubview(self.date!)
        
        self.score = LDXScore(frame: CGRect(x: (VIEW_HEIGHT! - 16)/1.273+16+80,y: 16+VIEW_HEIGHT!/4+VIEW_HEIGHT!/6*2,width: 80,height: VIEW_HEIGHT!/6))
        self.score?.isSelect = false
        self.score?.normalImg = UIImage(named: "btn_star_evaluation_normal")
        self.score?.highlightImg = UIImage(named: "btn_star_evaluation_press")
        self.score?.max_star = 5
        self.score?.show_star = 5
        self.addSubview(self.score!)
        
        self.more = UILabel(frame: CGRect(x: (VIEW_HEIGHT! - 16)/1.273+16,y: 8+VIEW_HEIGHT!/4+VIEW_HEIGHT!/6*3,width: VIEW_WIDTH! - (VIEW_HEIGHT! - 16)/1.273 - 16,height: VIEW_HEIGHT!/6))
        self.more?.textColor = UIColor.gray
        self.more?.font = UIFont(name: MAIN_FONT1, size: 13)
        self.addSubview(self.more!)
        
        //
    }
    
    // Only override drawRect: if you perform custom drawing.
    //自定义绘画
    override func draw(_ rect: CGRect) {
        // Drawing code
        //获取画布上下文:通过它指定操作哪个画布
        let context = UIGraphicsGetCurrentContext()
        //设置画笔宽度
        context?.setLineWidth(0.5)
        //设置画笔颜色
        context?.setStrokeColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)
        //设置画线的起始位置
        context?.move(to: CGPoint(x: 8, y: VIEW_HEIGHT!-2))
        //设置画线的终点位置
        context?.addLine(to: CGPoint(x: VIEW_WIDTH!-8, y: VIEW_HEIGHT!-2))
        //绘制
        context?.strokePath()
    }
    

}
