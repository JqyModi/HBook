//
//  pushNewBookController.swift
//  HBook
//
//  Created by mac on 17/7/7.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class pushNewBookController: UIViewController, bookTitleDelegate, UIAlertViewDelegate, pickerPhotoDelegate, VPImageCropperDelegate, UITableViewDelegate, UITableViewDataSource {

    //上半部分
    var btv: BookTitleView?
    //下半部分
    var table: UITableView?
    var titles = ["标题","评分","分类","书评"]
    var title_Detial = ""
    var score: LDXScore?
    //记录是否需要显示评分cell
    var isShowScore = false
    //记录分类中返回数据:文学 -> 文学
    var type: String? = "文学"
    var detailType: String? = "小说"
    var descStr: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        self.initView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initView(){    
        
        //2.注册一个通知用来接收书评是否上传成功:跟添加点击事件类似
        NotificationCenter.default.addObserver(self, selector: #selector(pushNewBookController.pushBookNotification(_:)), name: NSNotification.Name(rawValue: "pushBookNotification"), object: nil)
        
        //书评基本信息部分
        btv = BookTitleView(frame: CGRect(x: 0,y: 50,width: SCREEN_WIDTH,height: 141))
        btv?.delegate = self
        self.view.addSubview(btv!)
        
        //table部分
        table = UITableView(frame: CGRect(x: 0, y: 200, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-200), style: UITableViewStyle.grouped)
        //将多余的单元格中的线去掉
        table?.tableFooterView = UIView()
        //设置数据源及事件委托
        table?.delegate = self
        table?.dataSource = self
        //设置重用标识符：cell :PS: 注册重用会与cellForRowAtIndexPath方法中的tableView.dequeueReusableCellWithIdentifier("cell")重用cell冲突
        table?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        //设置背景色
        table?.backgroundColor = UIColor.white
        //
        self.view.addSubview(table!)
        
        //table中的评分部分
        score = LDXScore(frame: CGRect(x: 100,y: 10,width: 100,height: 22))
        score?.isSelect = true
        score?.normalImg = UIImage(named: "btn_star_evaluation_normal")
        score?.highlightImg = UIImage(named: "btn_star_evaluation_press")
        score?.max_star = 5
        score?.show_star = 5
    }
    
    //3.响应通知
    func pushBookNotification(_ notify: Notification){
        print("通知接收成功")
        let dict = notify.userInfo
        print("dict == \(dict)")
        let success = dict!["success"] as! Bool
        if (success) {
            //通过ProgressHUP提示用户
            ProgressHUD.showSuccess("书评上传成功")
            //关闭书评发布界面
            self.dismiss(animated: true) {
                print("关闭书评发布界面，显示主界面")
            }
        }else{
            //通过ProgressHUP提示用户
            ProgressHUD.showSuccess("书评上传失败")
            //关闭书评发布界面
            self.dismiss(animated: true) {
                print("关闭书评发布界面，显示主界面")
            }
        }
        
    }
    
    func clickCover() {
        print("点击封面回调")
        //跳转到photoPickerViewController
        let pv = photoPickerViewController()
        pv.delegate = self
        self.present(pv, animated: true) { 
            print("封面选择回调")
        }
//        let alert = UIAlertView(title: "封面选择", message: "封面选择", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "拍照", "从相册中选择")
//        alert.show()
    }
    
    //在跳转时设置导航栏中设置的点击事件
    func close(_ sender: UIButton){
        self.dismiss(animated: true) { 
            print("关闭回调")
        }
    }

    //点击发布操作
    func sure(_ sender: UIButton){
        //获取到将要发布的内容：存储到字典中
        let dict: NSDictionary = [
            "cover": (self.btv?.bookCover?.currentImage)!,
            "name": (self.btv?.bookName?.text)!,
            "editor": (self.btv?.bookEditor?.text)!,
            "title": (self.title_Detial),
            "score": String(describing: self.score?.show_star), //CGFloat
            "type": (self.type)!,
            "detialType": (self.detailType)!,
            "description": (self.descStr)!,
            ]
        //上传字典
        pushBook.pushBookInBackground(dict)
    }
    
    //实现委托方法获取图片
    func getPhoto(_ img: UIImage) {
        print("获取图片成功")
        //设置图片之前先将图片裁剪到合适的大小:利用第三方库实现图片的裁剪：VPImageCropperViewController
        //1.273通过封面的长款比例计算出来的:limitScaleRatio：缩放比例控制
        let cropper = VPImageCropperViewController(image: img, cropFrame: CGRect(x: 0,y: 100,width: SCREEN_WIDTH,height: SCREEN_WIDTH*1.273), limitScaleRatio: 3)
        //监听委托事件
        cropper?.delegate = self
        //跳转
        self.present(cropper!, animated: true) { 
            print("跳转到图片裁剪界面")
        }
        
    }
    //图片裁剪事件回调
    func imageCropper(_ cropperViewController: VPImageCropperViewController!, didFinished editedImage: UIImage!) {
        print("图片裁剪完成回调")
        cropperViewController.dismiss(animated: true) {
            //设置封面图片
            self.btv?.bookCover?.setImage(editedImage, for: UIControlState())
        }
    }
    func imageCropperDidCancel(_ cropperViewController: VPImageCropperViewController!) {
        print("图片裁剪取消回调")
        cropperViewController.dismiss(animated: true) { 
            print("取消裁剪")
        }
    }
    
    //tableView委托回调
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("返回数据源条数")
        return titles.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("响应选中条目回调")
        //设置选中时高亮效果：不会一直保持高亮
        tableView.deselectRow(at: indexPath, animated: true)
        
        var row = indexPath.row
        //当点击新增的cell时跟评分item做相同操作
        if isShowScore && row >= 2 {
            row -= 1
        }
        //控制选中跳转
        switch row {
        case 0:
            self.tabSelectTitleView()
            break
        case 1:
            self.tabSelectScoreView()
            break
        case 2:
            self.tabSelectTypeView()
            break
        case 3:
            self.tabSelectDescriptionView()
            break
            
        default:
            print("闭包回调显示结束")
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("初始化单元格")
        //重用单元格
        //通过重用标志符来获取到重用的单元格:UITableViewCellStyle.Value1：系统提供的默认布局样式：左右都有textLabel
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        //清楚单元格中内容：防止复用时出现显示上一个单元格状态
        for item in cell.contentView.subviews {
            //遍历移除所有子View
            item.removeFromSuperview()
        }
        //设置标题字体样式
        cell.textLabel?.text = titles[indexPath.row]
        cell.textLabel?.textColor = MAIN_RED
        cell.textLabel?.font = UIFont(name: MAIN_FONT1, size: 18)
        
        cell.detailTextLabel?.font = UIFont(name: MAIN_FONT1, size: 18)
        cell.detailTextLabel?.textColor = MAIN_RED
        
        var row = indexPath.row
        //除第二个以外的都加上右侧箭头
        if row != 1 {
            cell.accessoryType = .disclosureIndicator
        }
        
        //显示评分控件:是否去掉箭头
        if isShowScore && row == 2 {
            cell.contentView.addSubview(score!)
            //去掉右侧箭头
            cell.accessoryType = UITableViewCellAccessoryType.none
            //恢复index顺序
            row -= 1
        }
        
        //通过闭包方式回调显示详情内容
        switch row {
        case 0:
            //title_Detial通过回调闭包回调来赋值:与系统样式Value1／Value2配合使用
            cell.detailTextLabel?.text = self.title_Detial
            //设置图标
            //cell.imageView?.image = UIImage(named: "tag")
            break
        case 1:
            break
        case 2:
            cell.detailTextLabel?.text = self.type! + "->" + self.detailType!
            break
        case 4:
            //显示描述信息操作
            //1.去掉默认布局内容
            cell.accessoryType = .none
            //2.初始化要显示的控件及内容
            let tv = UITextView(frame: CGRect(x: 4, y: 4, width: SCREEN_WIDTH-8, height: 80))
            tv.font = UIFont(name: MAIN_FONT1, size: 17)
            tv.isEditable = false
            tv.text = self.descStr
            cell.contentView.addSubview(tv)
            break
            
        default:
            print("闭包回调显示结束")
        }
        
        return cell
    }
    
    func tabSelectTitleView(){
        let tc = Push_titleViewController()
        //用默认的左右title内容
        GeneralFactory.setTitleWithTile(tc)
        //～～4.跳转前实现callback来获取详情页回传数据
        tc.callback = {(title:String) -> Void in
            print("callback回调实现")
            print("title = \(title)")
            //将获取到的结果赋值给定义好的变量
            self.title_Detial = title
            //重载数据：刷新tableView
            self.table?.reloadData()
        }
        self.present(tc, animated: true, completion: {
            print("tc跳转回调")
        })
    }
    func tabSelectScoreView(){
//        let sc = Push_scoreViewController()
//        //用默认的左右title内容
//        GeneralFactory.setTitleWithTile(sc)
//        self.presentViewController(sc, animated: true, completion: {
//            print("sc跳转回调")
//        })
        //显示评分控件相当于在item下面插入了一个新的cell：通过tableView自带动作完成
        table?.beginUpdates()
        if isShowScore {
            //插入一个新cell后cell数量＋1而数据源的数量不变会导致numberOfRowsInSection方法报错：解决方式：通过insert方式插入一条空数据到数据源中
            self.titles.remove(at: 2)
            let tempIndexPath = [IndexPath.init(row: 2, section: 0)]
            self.table?.deleteRows(at: tempIndexPath, with: UITableViewRowAnimation.right)
            isShowScore = false
        }else{
            //插入一个新cell后cell数量＋1而数据源的数量不变会导致numberOfRowsInSection方法报错：解决方式：通过insert方式插入一条空数据到数据源中
            self.titles.insert("", at: 2)
            let tempIndexPath = [IndexPath.init(row: 2, section: 0)]
            self.table?.insertRows(at: tempIndexPath, with: UITableViewRowAnimation.left)
            isShowScore = true
        }
        
        
        table?.endUpdates()
    }
    func tabSelectTypeView(){
        let tc = Push_typeViewController()
        //用默认的左右title内容
        GeneralFactory.setTitleWithTile(tc)
        //通过tag获取到左右两个导航按钮
        let leftBtn = tc.view.viewWithTag(1234) as! UIButton
        let rightBtn = tc.view.viewWithTag(1235) as! UIButton
        //修改按钮的样式
        leftBtn.setTitleColor(RGB(82, g: 113, b: 131), for: UIControlState())
        rightBtn.setTitleColor(RGB(82, g: 113, b: 131), for: UIControlState())

        //4.实现Block获取到下一页面传回的数据
        tc.callback = {(type: String, detialType: String) in
            print("type = \(type)")
            self.type = type
            self.detailType = detialType
            //刷新数据
            self.table?.reloadData()
        }
        
        self.present(tc, animated: true, completion: {
            print("tc跳转回调")
        })
    }
    func tabSelectDescriptionView(){
        let dc = Push_descriptionViewController()
        //用默认的左右title内容
        GeneralFactory.setTitleWithTile(dc)
        //再次点击将值传递过去并赋值
        dc.desc?.text = descStr
        dc.callback = {(descStr: String) -> Void in
            print("descStr = \(descStr)")
            self.descStr = descStr
            //判断是否需要添加显示描述行
            if self.titles.last == "" {
                //移除最后一个原来内容
                self.titles.removeLast()
            }
            if descStr != "" {
                //新增一条空数据为显示描述信息占位置
                self.titles.append("")
            }
            //刷新列表
            self.table?.reloadData()
        }
        self.present(dc, animated: true, completion: {
            print("tc跳转回调")
        })
    }
    
    /**
        析构函数
        通过该方法检查是否发生内存泄漏
        如果发生内存泄漏则该方法不会被调用
        发生内存泄露的几个原因：
        1.Block中引用了self：swift中Block不会发生内存泄露
        2.Delegate是一个普通成员变量
        3.protocol类型变量要声明为weak类型，否则会造成内存泄漏 ：weak var delegate: bookTitleDelegate?
    */
    deinit{
        print("没有发生内存泄漏")
        //移除通知：不移除可能会使通知响应多次操作程序崩溃:移除对象上的所有通知:也可以按name来移除相对应的通知
        NotificationCenter.default.removeObserver(self)
    }
 
}
