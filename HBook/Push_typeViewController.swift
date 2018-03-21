//
//  Push_typeViewController.swift
//  HBook
//
//  Created by mac on 17/7/10.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

//1.定义一个Block用于数据回传
typealias Push_typeCallBack = (_ type:String, _ detailType: String) -> Void

class Push_typeViewController: UIViewController, IGLDropDownMenuDelegate {

    var segment1: AKSegmentedControl?
    var segment2: AKSegmentedControl?
    
    var literatureArray1:Array<NSDictionary> = []
    var literatureArray2:Array<NSDictionary> = []
    
    
    var humanitiesArray1:Array<NSDictionary> = []
    var humanitiesArray2:Array<NSDictionary> = []
    
    
    var livelihoodArray1:Array<NSDictionary> = []
    var livelihoodArray2:Array<NSDictionary> = []
    
    
    var economiesArray1:Array<NSDictionary> = []
    var economiesArray2:Array<NSDictionary> = []
    
    
    var technologyArray1:Array<NSDictionary> = []
    var technologyArray2:Array<NSDictionary> = []
    
    var NetworkArray1:Array<NSDictionary> = []
    var NetworkArray2:Array<NSDictionary> = []
    
    var dropDownMenu1:IGLDropDownMenu?
    var dropDownMenu2:IGLDropDownMenu?
    
    var type = "文学"
    var detailType = "文学"
    
    //2.声明一个callback
    var callback: Push_typeCallBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initDropArray()
        self.initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     init Array
     */
    func initDropArray(){
        
        self.literatureArray1 = [
            ["title":"小说"],
            ["title":"漫画"],
            ["title":"青春文学"],
            ["title":"随笔"],
            ["title":"现当代诗"],
            ["title":"戏剧"],
        ];
        self.literatureArray2 = [
            ["title":"传记"],
            ["title":"古诗词"],
            ["title":"外国诗歌"],
            ["title":"艺术"],
            ["title":"摄影"],
        ];
        self.humanitiesArray1 = [
            ["title":"历史"],
            ["title":"文化"],
            ["title":"古籍"],
            ["title":"心理学"],
            ["title":"哲学/宗教"],
            ["title":"政治/军事"],
        ];
        self.humanitiesArray2 = [
            ["title":"社会科学"],
            ["title":"法律"],
        ];
        self.livelihoodArray1 = [
            ["title":"休闲/爱好"],
            ["title":"孕产/胎教"],
            ["title":"烹饪/美食"],
            ["title":"时尚/美妆"],
            ["title":"旅游/地图"],
            ["title":"家庭/家居"],
        ];
        self.livelihoodArray2 = [
            ["title":"亲子/家教"],
            ["title":"两性关系"],
            ["title":"育儿/早教"],
            ["title":"保健/养生"],
            ["title":"体育/运动"],
            ["title":"手工/DIY"],
        ];
        self.economiesArray1  = [
            ["title":"管理"],
            ["title":"投资"],
            ["title":"理财"],
            ["title":"经济"],
        ];
        self.economiesArray2  = [
            ["title":"没有更多了"],
        ];
        self.technologyArray1 =  [
            ["title":"科普读物"],
            ["title":"建筑"],
            ["title":"医学"],
            ["title":"计算机/网络"],
        ];
        self.technologyArray2 = [
            ["title":"农业/林业"],
            ["title":"自然科学"],
            ["title":"工业技术"],
        ];
        self.NetworkArray1 =    [
            ["title":"玄幻/奇幻"],
            ["title":"武侠/仙侠"],
            ["title":"都市/职业"],
            ["title":"历史/军事"],
        ];
        self.NetworkArray2 =    [
            ["title":"游戏/竞技"],
            ["title":"科幻/灵异"],
            ["title":"言情"],
        ];
    }

    
    func initView(){
        //默认选中文学下拉菜单
        self.createDropMenu(self.literatureArray1, array2: literatureArray2)
        
        //设置背景色:灰色
        self.view.backgroundColor = RGB(231, g: 231, b: 231)
        
        //设置导航栏标题内容及样式
        let segmentLabel = UILabel(frame: CGRect(x: (SCREEN_WIDTH-300)/2,y: 20,width: 300,height: 20))
        segmentLabel.text = "选择分类"
        //设置字体阴影
        segmentLabel.shadowOffset = CGSize(width: 0, height: 1)
        segmentLabel.shadowColor = UIColor.white
        //设置字体颜色
        segmentLabel.textColor = RGB(82, g: 113, b: 131)
        //设置字体样式
        segmentLabel.font = UIFont(name: MAIN_FONT1, size: 20)
        //设置字体对齐方式
        segmentLabel.textAlignment = .center
        
        //设置segment
        let btnArray1 = [["image":"ledger","title":"文学","font":MAIN_FONT1],
                         ["image":"drama masks","title":"人文社科","font":MAIN_FONT1],
                         ["image":"aperture","title":"文学","font":MAIN_FONT1]]
        let btnArray2 = [["image":"atom","title":"经管","font":MAIN_FONT1],
                         ["image":"alien","title":"科技","font":MAIN_FONT1],
                         ["image":"fire element","title":"网络流行","font":MAIN_FONT1]]
        segment1 = AKSegmentedControl(frame: CGRect(x: 10,y: 60,width: (SCREEN_WIDTH-20),height: 37))
        segment1?.initButton(withTitleandImage: btnArray1)
        segment2 = AKSegmentedControl(frame: CGRect(x: 10,y: 110,width: (SCREEN_WIDTH-20),height: 37))
        segment2?.initButton(withTitleandImage: btnArray2)
        //添加事件委托:两个segment公用一个事件委托:值改变事件
        segment1?.addTarget(self, action: #selector(Push_typeViewController.clickSegment(_:)), for: UIControlEvents.valueChanged)
        segment2?.addTarget(self, action: #selector(Push_typeViewController.clickSegment(_:)), for: UIControlEvents.valueChanged)
        
        self.view.addSubview(segmentLabel)
        self.view.addSubview(self.segment1!)
        self.view.addSubview(self.segment2!)
    }
    
    //segment事件委托
    func clickSegment(_ segment: AKSegmentedControl){
        //selectIndexes包涵多个下标： 表示可以多选
        var index = Int(segment.selectedIndexes.first!)
        print(index)
        //
        self.type = ((segment.buttonsArray[index] as? UIButton)?.currentTitle)!
        
        //重置下拉菜单数据
        if dropDownMenu1 != nil {
            dropDownMenu1?.resetParams()
        }
        if dropDownMenu2 != nil {
            dropDownMenu2?.resetParams()
        }
        
        if segment == segment1 {
            print("点击了segment1")
            //取消另一个segment的点击效果：之所以设置为3时因为segment中只有三个item：0,1,2
            segment2?.setSelectedIndex(3)
        }else{
            print("点击了segment2")
            //取消另一个segment的点击效果
            segment1?.setSelectedIndex(3)
            //是否需要改变index的值？？？:需要+3操作：将两个segment看作一个segment来管理（0,1,2 : 0,1,2 -> 0,1,2,3,4,5）
            index += 3
        }
        //初始化dropMenu
        switch index {
        case 0:
            self.createDropMenu(self.literatureArray1, array2: literatureArray2)
            break
        case 1:
            self.createDropMenu(self.humanitiesArray1, array2: humanitiesArray2)
            break
        case 2:
            self.createDropMenu(self.livelihoodArray1, array2: livelihoodArray2)
            break
        case 3:
            self.createDropMenu(self.economiesArray1, array2: economiesArray2)
            break
        case 4:
            self.createDropMenu(self.technologyArray1, array2: technologyArray2)
            break
        case 5:
            self.createDropMenu(self.NetworkArray1, array2: NetworkArray2)
            break
        default:
            break
        }
    }
    
    //初始化两个下拉菜单
    func createDropMenu(_ array1: Array<NSDictionary>, array2: Array<NSDictionary>){
        
        //初始化下拉项
        
        //定义一个数组来存储第一个下拉菜单的下拉项
        let dropDownItems1 = NSMutableArray()
        for (index,item) in array1.enumerated() {
            //获取字典dict
            let dict = array1[index]
            //创建一个dropItem
            let dropItem = IGLDropDownItem()
            //设置dropItem的title
            dropItem.text = dict["title"] as? String
            dropItem.textLabel.textAlignment = .center
            dropItem.textLabel.font = UIFont(name: MAIN_FONT1, size: 18)
            //将dropItem存储起来
            dropDownItems1.add(dropItem)
        }
        
        let dropDownItems2 = NSMutableArray()
        for (index,item) in array2.enumerated() {
            //获取字典dict
            let dict = array2[index]
            //创建一个dropItem
            let dropItem = IGLDropDownItem()
            //设置dropItem的title
            dropItem.text = dict["title"] as? String
            dropItem.textLabel.textAlignment = .center
            dropItem.textLabel.font = UIFont(name: MAIN_FONT1, size: 18)
            //将dropItem存储起来
            dropDownItems2.add(dropItem)
        }
        
        //初始化菜单项
        //先移除所有的View
        self.dropDownMenu1?.removeFromSuperview()
        //初始化menu
        self.dropDownMenu1 = IGLDropDownMenu()
        //设置下拉菜单样式
        dropDownMenu1?.menuText = "展开列表"
        //自动适应大小
        dropDownMenu1?.menuButton.textLabel.adjustsFontSizeToFitWidth = true
        //设置颜色
        dropDownMenu1?.menuButton.textLabel.textColor = RGB(82, g: 113, b: 131)
        //设置字体样式
        dropDownMenu1?.menuButton.textLabel.font = UIFont(name: MAIN_FONT1, size: 15)
        dropDownMenu1?.menuButton.textLabel.textAlignment = .center
        //设置左边距
        dropDownMenu1?.paddingLeft = 15
        //动画样式
        dropDownMenu1?.type = .stack
        //动画延时时间
        dropDownMenu1?.itemAnimationDelay = 0.1
        //设置Y轴方向距离
        dropDownMenu1?.gutterY = 5
        //绑定下拉Item
        dropDownMenu1?.dropDownItems = dropDownItems1 as [AnyObject]
        //设置显示位置
        dropDownMenu1?.frame = CGRect(x: 20, y: 150, width: (SCREEN_WIDTH)/2-30, height: (SCREEN_HEIGHT-200)/7)
        //显示
        self.view.addSubview(dropDownMenu1!)
        //重新加载
        self.dropDownMenu1?.reloadView()
        
        //先移除所有的View
        self.dropDownMenu2?.removeFromSuperview()
        //初始化menu
        self.dropDownMenu2 = IGLDropDownMenu()
        //设置下拉菜单样式
        dropDownMenu2?.menuText = "展开列表"
        //自动适应大小
        dropDownMenu2?.menuButton.textLabel.adjustsFontSizeToFitWidth = true
        //设置颜色
        dropDownMenu2?.menuButton.textLabel.textColor = RGB(82, g: 113, b: 131)
        //设置字体样式
        dropDownMenu2?.menuButton.textLabel.font = UIFont(name: MAIN_FONT1, size: 15)
        dropDownMenu2?.menuButton.textLabel.textAlignment = .center
        //设置左边距
        dropDownMenu2?.paddingLeft = 15
        //动画样式
        dropDownMenu2?.type = .stack
        //动画延时时间
        dropDownMenu2?.itemAnimationDelay = 0.1
        //设置Y轴方向距离
        dropDownMenu2?.gutterY = 5
        //绑定下拉Item
        dropDownMenu2?.dropDownItems = dropDownItems2 as [AnyObject]
        //设置显示位置:/7：最多有7个item
        dropDownMenu2?.frame = CGRect(x: (SCREEN_WIDTH)/2+10, y: 150, width: (SCREEN_WIDTH)/2-30, height: (SCREEN_HEIGHT-200)/7)
        //显示
        self.view.addSubview(dropDownMenu2!)
        //重新加载
        self.dropDownMenu2?.reloadView()
        
        //设置时间委托
        self.dropDownMenu1?.delegate = self
        self.dropDownMenu2?.delegate = self
        
    }
    
    //下拉菜单事件委托
    func dropDownMenu(_ dropDownMenu: IGLDropDownMenu!, selectedItemAt index: Int) {
        print("下拉菜单委托事件")
        if dropDownMenu == dropDownMenu1 {
            //获取到当前选中的Item
            let dropItem = dropDownMenu.dropDownItems[index] as? IGLDropDownItem
            //设置另一个下拉菜单：dropDownMenu的选中标题
            self.detailType = (dropItem?.text)!
            dropDownMenu2?.menuButton.text = self.detailType
        }else{
            //获取到当前选中的Item
            let dropItem = dropDownMenu.dropDownItems[index] as? IGLDropDownItem
            //设置另一个下拉菜单：dropDownMenu的选中标题
            self.detailType = (dropItem?.text)!
            dropDownMenu1?.menuButton.text = self.detailType
        }
        
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
        self.dismiss(animated: true) { 
            //3.将点击的type和detailType通过Block回传给上一个页面
            self.callback!(self.type, self.detailType)
        }
        
    }

}
