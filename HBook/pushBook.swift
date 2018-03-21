//
//  pushBook.swift
//  HBook
//
//  Created by mac on 17/7/11.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import LeanCloud
import AVOSCloud

class pushBook: NSObject {
    //新建模型类
//    let dict = [
//        "cover": self.btv?.bookCover,
//        "name": self.btv?.bookName,
//        "editor": self.btv?.bookEditor,
//        "title": self.title,
//        "score": self.score?.show_star, //CGFloat
//        "type": self.type,
//        "detialType": self.detailType,
//        "description": self.descStr,
//        ]
    /**
     * 上传书评对象
     * 异步操作
     */
    static func pushBookInBackground(_ dict: NSDictionary){
        //没有指定上传对象的名称：系统默认为该表取名为：。。。
        //额外添加一个参数用来标记书评于用户的联系
        
        //AVOSCloud方式
        let bookObj = AVObject(className: "Book")
        
        bookObj.setObject(dict["name"], forKey: "name")
        bookObj.setObject(dict["editor"], forKey: "editor")
        bookObj.setObject(dict["title"], forKey: "title")
        bookObj.setObject(dict["score"], forKey: "score")
        bookObj.setObject(dict["type"], forKey: "type")
        bookObj.setObject(dict["detialType"], forKey: "detialType")
        bookObj.setObject(dict["description"], forKey: "description")
        //AVUser 与 LCUser区别？ : 此举无效？
        //
        print("avuser ---> \(AVUser.current()?.username)")
        bookObj.setObject(AVUser.current(), forKey: "user")
        
        //LeanCloud方式:上传不了图片
//        let book = LCObject(className: "Book")
//        book.set("name", value: dict["name"] as! String)
//        book.set("editor", value: dict["editor"] as! String)
//        book.set("title", value: dict["title"] as! String)
//        book.set("score", value: dict["score"] as! String)
//        book.set("type", value: dict["type"] as! String)
//        book.set("detialType", value: dict["detialType"] as! String)
//        book.set("description", value: dict["description"] as! String)
//        book.set("user", value: LCUser.current)

        //cover是图片： 需要先将图片上传到服务器（LeanCloud）obj中只需要保存一个索引即可
        let coverImg = dict["cover"] as! UIImage
        //利用coverImg来创建一个AVFile对象进行上传
        let avFile = AVFile(data: UIImagePNGRepresentation(coverImg)!)
        //开始上传avFile
        avFile.saveInBackground { (isSuccess, error) in
            if isSuccess {
                print("上传成功")
                //获取保存的图片索引
                bookObj.setObject(avFile, forKey: "cover")
                //图片上传成功返回？？
                print("avFile === \(avFile.localPath())")
                
                print("图片上传成功 ： bookObj = \(bookObj)")
                bookObj.saveInBackground({ (isSuccess, error) in
                    if isSuccess {
                        //获取保存的图片索引
                        print("书评对象上传成功 ：")
                        //因为这个一个异步操作，当书评上传成功之后需要同知主界面进行后续操作:1.发送通知操作:发送一个空通知
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "pushBookNotification"), object: nil, userInfo: ["success" : true])
                        
                    }else{
//                        print("书评对象上传失败 : \(error?.domain)")
//                        //通过ProgressHUP提示用户
//                        ProgressHUD.showSuccess("书评上传失败：\(error?.domain)")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "pushBookNotification"), object: nil, userInfo: ["success" : false])
                    }
                })
            }else{
//                print("上传失败：error = \(error?.code)")
//                //通过ProgressHUP提示用户
//                ProgressHUD.showSuccess("书评上传失败: \(error?.domain)")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "pushBookNotification"), object: nil, userInfo: ["success" : false])
            }
        }
        
    }
    
}
