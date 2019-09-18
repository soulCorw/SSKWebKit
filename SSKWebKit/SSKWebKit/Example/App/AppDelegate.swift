//
//  AppDelegate.swift
//  SSKWebKit
//
//  Created by 书梨公子 on 2019/9/10.
//  Copyright © 2019 SSK. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        return window
    }()
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.defaultOption()
        
        self.initializeUI()
        
        // snp: https://www.jianshu.com/p/f2aba4796463
        // textView: https://www.jianshu.com/p/5e4cf8488bfd
        
        /*
         JSBridge
         https://www.jianshu.com/p/1cd0a4ba6087
         https://www.jianshu.com/p/d12ec047ce52
         */
        // js:
        //
        
        // 访问控制
        // https://www.jianshu.com/p/8ba6d1513141
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

 
