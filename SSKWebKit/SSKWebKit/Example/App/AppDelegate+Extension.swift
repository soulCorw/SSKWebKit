//
//  AppDelegate+Extension.swift
//  SSKWebKit
//
//  Created by 书梨公子 on 2019/9/10.
//  Copyright © 2019 SSK. All rights reserved.
//

import Foundation
import UIKit


extension AppDelegate {
    
    func initializeUI() {
        
        makeRoot()
        
        if !self.window!.isKeyWindow {
            self.window?.makeKeyAndVisible()
        }
        
    }
    
    
    func makeRoot() {
        
        let viewControllers = [HomeViewController(),
                               DiscoverViewController(),
                               NewsViewController(),
                               MineViewController()]
        
        var titles = ["Home", "Discover", "News", "Mine"]
        
        
        var primaryControllers: [UIViewController] = []
        
        for (index, viewController) in viewControllers.enumerated() {
            let primaryController = BaseNavigationController(rootViewController: viewController)
            
            
            viewController.title = titles[index]
            
            primaryControllers.append(primaryController)
            
        }
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = primaryControllers
        
        self.window?.rootViewController = tabBarController
        
        
        
    }
    

}


extension AppDelegate {
    
    func defaultOption() {
        
    }
    
    
}

