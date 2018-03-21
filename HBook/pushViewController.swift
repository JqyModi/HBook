//
//  pushViewController.swift
//  HBook
//
//  Created by mac on 17/7/6.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import LeanCloud
import AVOSCloud

class pushViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var bookTable: UITableView?
    //存放网络书评数据
    var books: NSMutableArray?
    var naview: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置已进入就掉用下拉刷新后这个方法不需要
        //self.initData()
        self.initView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //网络获取书评数据
    func initData(){
        //创建书评查询对象
        let bookQuery = LCQuery(className: "Book")
        //设置查询条件
        //按createAt降序排列
        bookQuery.whereKey("createAt", .descending)
        //限制每次查询20条数据
        bookQuery.limit = 20
        //设置跳过查询条数
        bookQuery.skip = 0
        //开始查询
        bookQuery.find { (result) in
            if result.isSuccess{
                print("数据获取成功")
            }else{
                print("数据获取失败： reason ：\(result.error?.reason)")
            }
        }
    }
    func initView(){
        //初始化数据源
        self.books = NSMutableArray()
        
        //在导航栏中添加一个新建书评按钮
        
        //1.创建按钮
        let addbtn = UIButton(frame: CGRect(x: 35,y: (60-40)/2,width: 100,height: 20))
        addbtn.setTitle("新建书评", for: UIControlState())
        addbtn.setTitleColor(MAIN_RED, for: UIControlState())
        addbtn.titleLabel?.font = UIFont(name: MAIN_FONT1, size: 20)
        //2.创建图片
        let addimg = UIImageView(frame: CGRect(x: 10, y: (60-45)/2, width: 25, height: 25))
        addimg.image = UIImage(named: "plus circle")
        addimg.tintColor = MAIN_RED
        //创建导航栏存放容器
        naview = UIView(frame: CGRect(x: 0,y: 20,width: SCREEN_WIDTH,height: 40))
        naview!.backgroundColor = UIColor.white
        naview!.addSubview(addimg)
        naview!.addSubview(addbtn)
        naview!.tintColor = MAIN_RED
        //设置点击事件
        addbtn.addTarget(self, action: #selector(pushViewController.clickAddbtn(_:)), for: UIControlEvents.touchUpInside)
        
        //用tableView来显示书评列表
        self.bookTable = UITableView(frame: self.view.frame)
        //将多余的单元格中的线去掉
        bookTable?.tableFooterView = UIView()
        //注册tableView上拉加载下拉刷新控件
        bookTable?.mj_header =  MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(pushViewController.refreshHeader))
        bookTable?.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(pushViewController.refreshFooter))
        //设置已进入马上获取数据:省去initData方法
        bookTable?.mj_header.beginRefreshing()
        //设置数据源及事件委托
        bookTable?.delegate = self
        bookTable?.dataSource = self
        //设置重用标识符：cell :PS: 注册重用会与cellForRowAtIndexPath方法中的tableView.dequeueReusableCellWithIdentifier("cell")重用cell冲突
        bookTable?.register(bookTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        //设置背景色
        bookTable?.backgroundColor = UIColor.gray
        
        
        
        self.navigationController?.view.addSubview(naview!)
        self.view.addSubview(bookTable!)
        
        
    }
    
    //tableView委托回调
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("返回数据源条数")
        return (self.books?.count)!
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
        
        //控制选中跳转:将书籍对象传递过去
        let book = books![indexPath.row] as! LCObject
        let detailBookVC = pushBookDetailViewController()
        //跳转时隐藏底部的tabbar
        self.hidesBottomBarWhenPushed = true
        //设置数据
        detailBookVC.book = book
        print("book  --> \(book.jsonString)")
        //跳转
        self.navigationController?.pushViewController(detailBookVC, animated: true)
        //恢复显示tablebar
        self.hidesBottomBarWhenPushed = false
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("初始化单元格")
        //重用单元格
        let cell = self.bookTable?.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! bookTableViewCell
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        //获取到数据
        let dict = books![indexPath.row] as! LCObject
        let name = dict.get("name")?.jsonString
        let title = dict.get("title")?.jsonString
        let editor = dict.get("editor")?.jsonString
        //获取封面图片URL对应的LCDictionary对象并转化为AnyObject再转为NSDictionary
        let dictImg = dict.get("cover")?.jsonValue as! NSDictionary
        //获取封面图片URL
        let url = dictImg["url"]
        print("url == \(dictImg["url"])")
        
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
        cell.cover?.sd_setImage(with: URL(string: url! as! String), placeholderImage: UIImage(named: "Cover"))
        cell.name?.text = "<<" + name! + ">> : " + title!
        cell.editor?.text = "作者 : " + editor!
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
    override func viewWillAppear(_ animated: Bool) {
//        self.hidesBottomBarWhenPushed = false
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
        let bookQuery = LCQuery(className: "Book")
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
                self.books?.removeAllObjects()
                //数据添加失败??
                self.books?.addObjects(from: result.objects!)
//                self.books?.arrayByAddingObject(result.objects!)
                //刷新数据
                self.bookTable?.reloadData()
                //结束上拉加载
                self.bookTable?.mj_header.endRefreshing()
            }else{
                print("数据获取失败： reason ：\(result.error?.reason)")
                //结束上拉加载
                self.bookTable?.mj_header.endRefreshing()
            }
        }
    }
    func refreshFooter(){
        print("上拉加载")
        //创建书评查询对象
        let bookQuery = LCQuery(className: "Book")
        //设置查询条件
        //按createAt降序排列
        bookQuery.whereKey("createdAt", .descending)
        //限制每次查询20条数据
        bookQuery.limit = 20
        //设置跳过查询条数:跳过已有数据继续添加数据
        bookQuery.skip = self.books?.count
        //开始查询
        bookQuery.find { (result) in
            if result.isSuccess{
                print("数据获取成功")
                //向数据源中追加数据
                self.books?.addObjects(from: result.objects!)
                //刷新数据
                self.bookTable?.reloadData()
                //结束上拉加载
                self.bookTable?.mj_footer.endRefreshing()
            }else{
                print("数据获取失败： reason ：\(result.error?.reason)")
                //结束上拉加载
                self.bookTable?.mj_footer.endRefreshing()
            }
        }
    }
    

}
