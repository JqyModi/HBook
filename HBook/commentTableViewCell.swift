//
//  commentTableViewCell.swift
//  HBook
//
//  Created by mac on 17/7/14.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class commentTableViewCell: UITableViewCell {

    var cover: UIImageView?
    var name: UILabel?
    var comment: UILabel?
    var more: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //首先移除所有内容
        for view in self.subviews {
            view.removeFromSuperview()
        }
        //初始化UI
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        //初始化UI
        self.cover = UIImageView(frame: CGRect(x: 8, y: 9, width: 56, height: 70))
        self.name = UILabel(frame: CGRect(x: 78,y: 8,width: 242,height: 25))
        self.comment = UILabel(frame: CGRect(x: 78,y: 33,width: 242,height: 25))
        self.more = UILabel(frame: CGRect(x: 78,y: 66,width: 242,height: 25))
        //设置字体及颜色
        name!.font = UIFont(name: MAIN_FONT1, size: 15)
        comment!.font = UIFont(name: MAIN_FONT1, size: 15)
        more!.font = UIFont(name: MAIN_FONT1, size: 13)
        more?.textColor = UIColor.gray
        more?.text = "更多"
        //设置图片属性：设置默认图片
        cover?.image = UIImage(named: "cover")
        //显示UIView
        self.addSubview(cover!)
        self.addSubview(name!)
        self.addSubview(comment!)
        self.addSubview(more!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
