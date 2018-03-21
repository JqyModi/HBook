//
//  AppDelegate.swift
//  HBook
//
//  Created by mac on 17/7/5.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import LeanCloud
import AVOSCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //注册LeanCloud
        // applicationId 即 App Id，applicationKey 是 App Key
        LeanCloud.initialize(applicationID: "8qPaBv9rq0nWzUewpDMzSbYe-gzGzoHsz", applicationKey: "0xrM6gEGB142t9RvEgwlEnYb")
        AVOSCloud.setApplicationId("8qPaBv9rq0nWzUewpDMzSbYe-gzGzoHsz", clientKey: "0xrM6gEGB142t9RvEgwlEnYb")
        
        // Override point for customization after application launch.
        //自定义主页
        self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.window?.backgroundColor = UIColor.white
        //定义主页面tabbar控制器
        let tablebarController = UITabBarController()
        //定义tabbar中的导航navigation控制器
        let rankController = UINavigationController(rootViewController: rankViewController())
        let searchController = UINavigationController(rootViewController: searchViewController())
        let pushController = UINavigationController(rootViewController: pushViewController())
        let circleController = UINavigationController(rootViewController: circleViewController())
        let moreController = UINavigationController(rootViewController: moreViewController())
        //将导航控制器添加到tabbar控制器中
        tablebarController.viewControllers = [rankController,searchController,pushController,circleController,moreController]
        let rankbarItem = UITabBarItem(title: "排行榜", image: UIImage(named: "bio"), selectedImage: UIImage(named: "bio_red"))
        let searchbarItem = UITabBarItem(title: "发现", image: UIImage(named: "timer 2"), selectedImage: UIImage(named: "timer 2_red"))
        let pushbarItem = UITabBarItem(title: "", image: UIImage(named: "pencil"), selectedImage: UIImage(named: "pencil_red"))
        let circlebarItem = UITabBarItem(title: "圈子", image: UIImage(named: "users two-2"), selectedImage: UIImage(named: "users two-2_red"))
        let morebarItem = UITabBarItem(title: "更多", image: UIImage(named: "more"), selectedImage: UIImage(named: "more_red"))
        //为导航控制器设置样式Item bar
        rankController.tabBarItem = rankbarItem
        searchController.tabBarItem = searchbarItem
        pushController.tabBarItem = pushbarItem
        circleController.tabBarItem = circlebarItem
        moreController.tabBarItem = morebarItem
        //设置控制器的整体主题着色
//        tablebarController.tabBar.tintColor
        //设置默认选中的item
        rankController.tabBarController?.tabBar.tintColor = MAIN_RED
        //tabbar控制器作为根视图控制器
        self.window?.rootViewController = tablebarController
        //显示主页
        self.window?.makeKeyAndVisible()
        
        //将数据存储到LeanCloud云端
//        let post = LCObject(className: "TestObject")
//        post.set("words", value: "Hello World!")
//        post.save()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

