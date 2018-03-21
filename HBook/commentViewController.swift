//
//  commentViewController.swift
//  HBook
//
//  Created by mac on 17/7/14.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import LeanCloud

class commentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //显示评论详细
    var commentTable: UITableView?
    
    //评论数据
    var comments: NSMutableArray?
    
    var naview: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.view.backgroundColor = UIColor.gray
        //隐藏确认按钮
        let sureBtn = self.view.viewWithTag(1235)
        //
        sureBtn?.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //实现导航栏关闭按钮点击事件
    func close(_ sender: UIButton){
        print("关闭")
        self.dismiss(animated: true) { 
            print("关闭评论区")
        }
    }

    func initView(){
        //初始化数据源
        self.comments = NSMutableArray()
        
        //在导航栏中添加一个新建书评按钮
        
        //1.创建按钮
        let addbtn = UIButton(frame: CGRect(x: (SCREEN_WIDTH-100)/2,y: (60-40)/2,width: 100,height: 20))
        addbtn.setTitle("评论区", for: UIControlState())
        addbtn.setTitleColor(MAIN_RED, for: UIControlState())
        addbtn.titleLabel?.font = UIFont(name: MAIN_FONT1, size: 20)
        //创建导航栏存放容器
        naview = UIView(frame: CGRect(x: 0,y: 20,width: SCREEN_WIDTH,height: 40))
        naview!.backgroundColor = UIColor.white
        naview!.addSubview(addbtn)
        naview!.tintColor = MAIN_RED
        //设置点击事件
        addbtn.addTarget(self, action: #selector(pushViewController.clickAddbtn(_:)), for: UIControlEvents.touchUpInside)
        
        //用tableView来显示书评列表
        self.commentTable = UITableView(frame: CGRect(x: 0, y: 40+20, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-40-20))
        //将多余的单元格中的线去掉
        commentTable?.tableFooterView = UIView()
        //注册tableView上拉加载下拉刷新控件
        commentTable?.mj_header =  MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(pushViewController.refreshHeader))
        commentTable?.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(pushViewController.refreshFooter))
        //设置已进入马上获取数据:省去initData方法
        commentTable?.mj_header.beginRefreshing()
        //设置数据源及事件委托
        commentTable?.delegate = self
        commentTable?.dataSource = self
        //设置重用标识符：cell :PS: 注册重用会与cellForRowAtIndexPath方法中的tableView.dequeueReusableCellWithIdentifier("cell")重用cell冲突
        commentTable?.register(commentTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        //设置背景色
        commentTable?.backgroundColor = UIColor.gray
        
        
        
        self.navigationController?.view.addSubview(naview!)
        self.view.addSubview(commentTable!)
        
        
    }
    
    //tableView委托回调
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("返回数据源条数")
        return (self.comments?.count)!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //设置行高
        return 88
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("响应选中条目回调")
        //设置选中时高亮效果：不会一直保持高亮
        tableView.deselectRow(at: indexPath, animated: true)
        
        var row = indexPath.row
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("初始化单元格")
        //重用单元格
        let cell = self.commentTable?.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! commentTableViewCell
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        //获取到数据
        let dict = comments![indexPath.row] as! LCObject
        
        //获取用户信息
        let user = dict["user"] as! LCObject
        let name = user.get("username")?.jsonString
        //暂时没有加上该字段
//        let icon = user.get("icon")?.jsonString
        let comment = dict.get("content")?.jsonString
//        //获取封面图片URL对应的LCDictionary对象并转化为AnyObject再转为NSDictionary
//        let dictImg = dict.get("cover")?.jsonValue as! NSDictionary
//        //获取封面图片URL
//        let url = dictImg["url"]
//        print("url == \(dictImg["url"])")
        let url = "http://ac-8qpabv9r.clouddn.com/UDnZjYQ9NOdVBJmDlbaRBkD"
        //获取时间
        let createAt = dict.get("createdAt") as! LCDate
        //将LCDate转化为NSDate
        let nsCreateTime = createAt.value
        //格式化时间
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH-mm-ss"
        //        let createTime = format.stringFromDate(nsCreateTime)
        let createTime = format.string(from: nsCreateTime)
        //设置数据:不起作用是因为默认程序是用https协议：需要再info.plist中添加App Transport Secu....: Allow ... :支持http协议
        cell.cover?.sd_setImage(with: URL(string: url ), placeholderImage: UIImage(named: "Cover"))
        cell.name?.text = "<<" + name! + ">> : " + title!
        cell.comment?.text = "作者 : " + comment!
        cell.more?.text = createTime
        
        
        var row = indexPath.row
        //除第二个以外的都加上右侧箭头
        
        
        return cell
    }
    override func viewDidAppear(_ animated: Bool) {
        //出现的时候显示导航栏View
        self.naview?.isHidden = false
        //显示tablebar
        //        self.hidesBottomBarWhenPushed = false
        //        self.tabBarController?.tabBar.hidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        //消失的时候隐藏导航栏View
        self.naview?.isHidden = true
    }
    
    func clickAddbtn(_ sender: UIButton){
        print("点击事件生效")
        //带导航栏的跳转
        //self.navigationController?.pushViewController(pushNewBookController(), animated: true)
        //不带导航栏跳转
        let newbook = pushNewBookController()
        //跳转之前设置导航栏按钮
        GeneralFactory.setTitleWithTile(newbook, leftTitle: "关闭", rightTitle: "发布")
        self.present(newbook, animated: true) {
            print("回调")
        }
        
    }
    
    //回调上拉加载 下拉刷新
    func refreshHeader(){
        print("下拉刷新")
        //创建书评查询对象
        let bookQuery = LCQuery(className: "Comment")
        //设置查询条件
        //按createAt降序排列
        bookQuery.whereKey("createdAt", .descending)
        //限制每次查询20条数据
        bookQuery.limit = 20
        //设置跳过查询条数
        bookQuery.skip = 0
        //开始查询
        bookQuery.find { (result) in
            if result.isSuccess{
                print("数据获取成功")
                //将数据添加到数据源中
                //先清空数据源
                self.comments?.removeAllObjects()
                //数据添加失败??
                self.comments?.addObjects(from: result.objects!)
                //                self.comments?.arrayByAddingObject(result.objects!)
                //刷新数据
                self.commentTable?.reloadData()
                //结束上拉加载
                self.commentTable?.mj_header.endRefreshing()
            }else{
                print("数据获取失败： reason ：\(result.error?.reason)")
                //结束上拉加载
                self.commentTable?.mj_header.endRefreshing()
            }
        }
    }
    func refreshFooter(){
        print("上拉加载")
        //创建书评查询对象
        let bookQuery = LCQuery(className: "Comment")
        //设置查询条件
        //按createAt降序排列
        bookQuery.whereKey("createdAt", .descending)
        //限制每次查询20条数据
        bookQuery.limit = 20
        //设置跳过查询条数:跳过已有数据继续添加数据
        bookQuery.skip = self.comments?.count
        //开始查询
        bookQuery.find { (result) in
            if result.isSuccess{
                print("数据获取成功")
                //向数据源中追加数据
                self.comments?.addObjects(from: result.objects!)
                //刷新数据
                self.commentTable?.reloadData()
                //结束上拉加载
                self.commentTable?.mj_footer.endRefreshing()
            }else{
                print("数据获取失败： reason ：\(result.error?.reason)")
                //结束上拉加载
                self.commentTable?.mj_footer.endRefreshing()
            }
        }
    }
    
}
