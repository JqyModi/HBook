//
//  detailViewController.swift
//  HBook
//
//  Created by mac on 17/7/13.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import LeanCloud
import AVOSCloud

class pushBookDetailViewController: UIViewController, bottomBarDelegate, InputViewDelegate {

    //定义存储书籍对象：在跳转的时候直接赋值传递回来
    var book: LCObject?
    //
    var detailBookTitle: detailBookTitleView?
    var bottomTabbar: bookTabbarView?
    var bookTextView: UITextView?
    //定义评论输入框
    var commentInput: InputView?
    
    var keyboardHeight: CGFloat = 0.0
    //点击评论弹出输入框时的遮罩View
    var layView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //初始化UI
//        self.initView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initView(){
        //设置导航栏颜色样式
        self.view.backgroundColor = UIColor.white
        self.detailBookTitle?.backgroundColor = UIColor.white
        //更改导航栏内容样式
        self.navigationController?.navigationBar.backgroundColor = UIColor.gray
        
        //1.封面部分
        //将高度设置为SCREEN_HEIGHT/4动态适配
        self.detailBookTitle = detailBookTitleView(frame: CGRect(x: 0,y: 64,width: SCREEN_WIDTH,height: SCREEN_HEIGHT/4))
        self.view.addSubview(detailBookTitle!)
        //填充数据
        let name = book!.get("name")?.jsonString
        let title = book!.get("title")?.jsonString
        let editor = book!.get("editor")?.jsonString
        let score = book!.get("score") as! LCString
        //LCString转Int ： LCString -> NSString -> intValue -> int
        let nsScore = score.value as NSString
        
        //获取封面图片URL对应的LCDictionary对象并转化为AnyObject再转为NSDictionary
        let bookImg = book!.get("cover")?.jsonValue as! NSDictionary
        //获取封面图片URL
        let url = bookImg["url"]
        print("url == \(bookImg["url"])")
        
        //获取时间
        let createAt = book!.get("createdAt") as! LCDate
        //将LCDate转化为NSDate
        let nsCreateTime = createAt.value
        //格式化时间
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH-mm-ss"
//        let createTime = format.stringFromDate(nsCreateTime)
        let createTime = format.string(from: nsCreateTime)
        //设置数据:不起作用是因为默认程序是用https协议：需要再info.plist中添加App Transport Secu....: Allow ... :支持http协议
        detailBookTitle!.cover?.sd_setImage(with: URL(string: url! as! String), placeholderImage: UIImage(named: "Cover"))
        detailBookTitle!.name?.text = "<<" + name! + ">> : " + title!
        detailBookTitle!.editor?.text = "作者 : " + editor!
        //获取上传用户数据
//        detailBookTitle?.userName?.text = "小编 ：" + (book!["user"]?.JSONValue.get("username")?.JSONString)!
        detailBookTitle?.score?.show_star = Int(nsScore.intValue)
        detailBookTitle?.date?.text = "日期 ：" + createTime
        detailBookTitle!.more?.text = "100个喜欢   88个评论   1000次浏览"
        
        
        //2.底部导航部分
        self.bottomTabbar = bookTabbarView(frame: CGRect(x: 0,y: SCREEN_HEIGHT-40,width: SCREEN_WIDTH,height: 40))
        self.bottomTabbar?.delegate = self
        self.view.addSubview(bottomTabbar!)
        //3.中间书评描述部分
        self.bookTextView = UITextView(frame: CGRect(x: 0,y: 64+SCREEN_HEIGHT/4,width: SCREEN_WIDTH,height: SCREEN_HEIGHT-64-SCREEN_HEIGHT/4-40))
        //设置不可编辑
        self.bookTextView?.isEditable = false
        self.view.addSubview(bookTextView!)
        //设置内容显示
        self.bookTextView?.text = book?.get("description")?.jsonString
        //查询是否被点赞
        self.isLove()
    }
    
    //查询该书籍是否被点赞
    func isLove(){
        //数据表的设计是：用一个表来存储一本书的所有点赞数据：key : love = 书籍(1...1) ：love(1...n) 
        //获取点赞用户
        let user = LCUser.current
        //获取被点赞数据
        let loveBook = book
        //查询是否被点赞
        let lovetab = LCQuery(className: "Love")
        lovetab.whereKey("user", .equalTo(user!))
        lovetab.whereKey("book", .equalTo(loveBook!))
        lovetab.find { (result) in
            if result.isSuccess && (result.objects?.count)!>0 {
                print("数据查询成功")
                //将按钮图片变红心图片
                //1.获取按钮:通过设置好的tag来获取按钮实例
                let btn = self.bottomTabbar?.viewWithTag(2) as! UIButton
                //先变成红色边框心再变成实心
                btn.setImage(UIImage(named: "heart"), for: UIControlState.highlighted)
                btn.setImage(UIImage(named: "solidheart"), for: UIControlState.normal)
                
            }
        }
        
        
    }
    
    
    //bottomBarDelegate
    
    
    //inputViewDelegate:
    //键盘显示
    func keyboardWillShow(_ inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: TimeInterval, animationCurve: UIViewAnimationCurve) {
        
        self.keyboardHeight = keyboardHeight
        //改变当前评论输入框位置
        UIView.animate(withDuration: duration, delay: 0, options: .beginFromCurrentState, animations: {
            //将输入框的底部设置到键盘上方
            self.commentInput?.bottom = SCREEN_HEIGHT-keyboardHeight
            }) { (finish) in
                print("finish")
                //显示遮罩
                self.layView?.isHidden = false
                //设置透明度增加出现遮罩效果
                self.layView?.alpha = 0.2
                
        }
    }
    //键盘隐藏
    func keyboardWillHide(_ inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: TimeInterval, animationCurve: UIViewAnimationCurve) {
        //改变当前评论输入框位置
        UIView.animate(withDuration: duration, delay: 0, options: .beginFromCurrentState, animations: {
            //将输入框的底部设置到键盘上方
            self.commentInput?.bottom = SCREEN_HEIGHT+(self.commentInput?.height)!
        }) { (finish) in
            print("finish")
            self.layView?.isHidden = true
            //设置透明度为0取消遮罩效果
            self.layView?.alpha = 0
        }
    }
    //控制输入框位置变化
    func textViewHeightDidChange(_ height: CGFloat) {
        //
        self.commentInput?.height = height + 10
        self.commentInput?.bottom = SCREEN_HEIGHT - self.keyboardHeight
    }
    //点击输入框控件中的评论操作
    func publishButtonDidClick(_ button: UIButton!) {
        print("评论")
        //将评论内容上传到LeanCloud后台：评论内容、当前评论用户、评论的书籍
        let content = self.commentInput?.inputTextView.text
        //上传的是一个指针对象
        let user = LCUser.current?.jsonValue
        let book = self.book?.jsonValue
        //上传
        let comment = LCObject(className: "Comment")
        comment.set("content", value: content)
        comment.setValue(user, forKey: "user")
        comment.setValue(book, forKey: "book")
//        comment.set("user", object: user)
//        comment.set("book", object: book)
        comment.save { (result) in
            if result.isSuccess {
                 print("上传成功")
                ProgressHUD.showSuccess("评论成功")
                //清空输入框
                self.commentInput?.inputTextView.text = ""
            }else{
                ProgressHUD.showError("评论失败" + (result.error?.reason)!)
            }
        }
        
    }
    
    //评论功能
    func clickPen() {
        print("1")
        if self.commentInput == nil {
            //初始化输入框控件:通过xib初始化一个控件(.last)
            self.commentInput = Bundle.main.loadNibNamed("InputView", owner: self, options: nil)?.last as! InputView
            self.commentInput?.frame = CGRect(x: 0, y: SCREEN_HEIGHT-44, width: SCREEN_WIDTH, height: 44)
            //控制键盘事件及本身位置变化
            self.commentInput?.delegate = self
            //显示
            self.view.addSubview(self.commentInput!)
            //立即弹出键盘
            self.becomeFirstResponder()
        }
        
        //初始化遮罩层View
        self.layView = UIView(frame: self.view.frame)   //整个屏幕遮罩效果
        self.layView?.backgroundColor = UIColor.gray
        //开始不显示遮罩但需要添加到View上：所有用alpha来控制
        self.layView?.alpha = 0
        //显示:插入到inputView下面
        //self.view.addSubview(self.layView!)
        self.view.insertSubview(self.layView!, belowSubview: self.commentInput!)
        //添加点击手势：当点击时隐藏键盘
        let tap = UITapGestureRecognizer(target: self, action: #selector(pushBookDetailViewController.clickLayView))
        self.layView?.addGestureRecognizer(tap)
        //刚开始不显示
        self.layView?.isHidden = true
        
    }
    //响应遮罩点击手势
    func clickLayView(){
        //隐藏遮罩
        self.layView?.isHidden = true
        //隐藏键盘:移除焦点？
        self.commentInput?.inputTextView.becomeFirstResponder()
        
    }
    
    //评论区展示功能
    func clickChat() {
        print("2")
        let commentVC = commentViewController()
        //初始化导航栏按钮
        GeneralFactory.setTitleWithTile(commentVC, leftTitle: "关闭", rightTitle: "确认")
        //
//        self.navigationController?.pushViewController(commentVC, animated: true)
        self.present(commentVC, animated: true) { 
            print("跳转到评论区")
        }
        
    }
    //点赞功能
    func clickHeart(_ btn: UIButton) {
        print("3")
        //防止用户多次点击按钮
        btn.isEnabled = false
        //先设置为红色边框心
        btn.setImage(UIImage(named: "redheart"), for: UIControlState.highlighted)
        //判断是否已经点赞
        //获取点赞用户
        let user = LCUser.current
        //获取被点赞数据
        let loveBook = book
        //查询是否被点赞
        let lovetab = LCQuery(className: "Love")
        lovetab.whereKey("user", .equalTo(user!))
        lovetab.whereKey("book", .equalTo(loveBook!))
        lovetab.find { (result) in
            if result.isSuccess && (result.objects?.count)! > 0 {
                print("数据查询成功")
                //已经点赞再次操作则取消点赞：删除数据库中的数据
                for item in result.objects! {
                    let obj = item 
                    //删除
                    obj.delete()
                    //改变图片颜色？？
                    btn.setImage(UIImage(named: "heart"), for: UIControlState.normal)
                }
                
            }else{
                //将数据保存到数据库
                let love = LCObject(className: "Love")
                print("数据查询失败")
                let jsonUser = LCUser.current
                let jsonBook = self.book
                
//                love.set("user", object: jsonUser)
//                love.set("book", object: jsonBook)
//                love.setValue(jsonUser, forKey: "user")
//                love.setValue(jsonBook, forKey: "book")
                love.set("user", value: jsonUser)
                love.set("book", value: jsonBook)
                
                print("user --> \(jsonUser)")
                love.save({ (result) in
                    if result.isSuccess {
                        print("数据保存成功")
                        //改变图片为实心
                        btn.setImage(UIImage(named: "solidheart"), for: UIControlState.normal)
                    }else{
                        ProgressHUD.showError("操作失败!")
                    }
                })
            }
            //恢复按钮点击
            btn.isEnabled = true
        }
    }
    //分享功能
    func clickShare() {
        print("4")
        
    }
    
    
    
    

}
