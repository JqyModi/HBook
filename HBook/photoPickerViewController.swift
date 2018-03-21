//
//  photoPickerViewController.swift
//  HBook
//
//  Created by mac on 17/7/7.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

protocol pickerPhotoDelegate{
    func getPhoto(_ img: UIImage)
}

class photoPickerViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //定义变量
    var picker: UIImagePickerController?
    var alert: UIAlertController?
    var delegate: pickerPhotoDelegate?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //设置背景透明色
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.view.backgroundColor = UIColor.clear
        //开始操作
//        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("aDecoder = \(aDecoder)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        self.picker = UIImagePickerController()
        //自动截图是个正方形：false
        self.picker?.allowsEditing = false
        //设置事件委托
        self.picker?.delegate = self
        
        //初始化弹窗:判断是否为空，否则会出现重复弹出窗体bug
        if self.alert == nil {
            self.alert = UIAlertController(title: "选择封面", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
            let photo = UIAlertAction(title: "拍照", style: UIAlertActionStyle.default) { (UIAlertAction) in
                print("拍照回调")
                self.photo()
            }
            let gallery = UIAlertAction(title: "从相册选择", style: UIAlertActionStyle.default) { (UIAlertAction) in
                print("相册回调")
                self.gallery()
            }
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
                print("取消回调")
                self.dismiss(animated: true, completion: {
                    print("关闭控制器回调")
                })
            }
            self.alert?.addAction(photo)
            self.alert?.addAction(gallery)
            self.alert?.addAction(cancel)
            self.present(self.alert!, animated: true) {
                print("封面选择弹出回调")
            }
        }
        
    }
    
    func photo(){
        //判断相机是否存在
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            //开始调用相机拍照
            self.picker?.sourceType = UIImagePickerControllerSourceType.camera
            //跳转到系统相机界面：打开相机
            self.present(self.picker!, animated: true, completion: { 
                print("打开相机回调")
                //
            })
        }else{
            //弹窗告诉用户相机不存在
            let alert = UIAlertController(title: "", message: "相机不可用", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
                print("相机不可用弹窗回调")
                //关闭该弹出窗体
                self.dismiss(animated: true, completion: { 
                    print("关闭当前弹窗")
                })
            }))
            self.present(alert, animated: true, completion: { 
                print("相机不可用跳转回调")
            })
        }
    }
    
    func gallery(){
        //打开相册
        self.picker?.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //跳转到系统相册：打开相册回调
        self.present(self.picker!, animated: true) {
            print("打开相册回调")
        }
    }
    //通过实现委托事件获取图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("获取图片")
        //通过该字符数组获取图片:强转成UIImage
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        //关闭图片选择界面
        self.picker?.dismiss(animated: true, completion: {
            print("关闭相册选择完成回调")
            self.dismiss(animated: true, completion: {
                print("关闭相册界面回调")
                //通过事件委托方式将选中的相片发送给pushNewBook...界面
                self.delegate?.getPhoto(img)
            })
        })
        
    }
    //当选择完成或者取消图片选择时回调
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("相册选择完成或者取消选择回调")
        self.picker?.dismiss(animated: true, completion: { 
            print("关闭相册选择完成回调")
            self.dismiss(animated: true, completion: { 
                print("关闭相册界面回调")
            })
        })
    }
}
