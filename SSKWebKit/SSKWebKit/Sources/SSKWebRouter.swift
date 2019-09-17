//
//  SSKWebRouter.swift
//  SSKWebKit
//
//  Created by 书梨公子 on 2019/9/10.
//  Copyright © 2019 SSK. All rights reserved.
//

import UIKit


class SSKWebRouter: NSObject {
    
    
    static func switchTab(_ index: Int) {
        
        let toTabHandler: ((UITabBarController) ->Void) = { (tabBarVC) in
            if tabBarVC.selectedIndex != index {
                
                // 先获取没有切换之前的 selectedViewController
                let topViewController = (tabBarVC.selectedViewController as? UINavigationController)?.topViewController
                
                tabBarVC.selectedIndex = index
                topViewController?.navigationController?.popToRootViewController(animated: false)
                
            }
        }
        
        
        let app = UIApplication.shared
        if let rootVC = app.keyWindow?.rootViewController {
            
            if rootVC.isKind(of: UITabBarController.self) {
                
                let tabBarVC = rootVC as! UITabBarController
                if let viewControllers = tabBarVC.viewControllers {
                  
                    if index < viewControllers.count  {
                        toTabHandler(tabBarVC)
                    }
                }
               
            }
        }
        
    }
    
    
    
    
    static func reload() {
        
    }
    
    static func navigateBack(_ formVC: UIViewController, delta: Int) {
        
        if let viewControllers = formVC.navigationController?.viewControllers {
            
            
            /*
             
             因为H5返回的delta是相对于它自身的delta，和原生导航栈里的index并不一定相符，所以需要从导航栈里的第一个webVC开始计算
             导航栈里的第一个web页面为delta的start 其值为0
             */
            
            // 不能为负，即只能从start开始计算
            if delta < 0 {return}
            
            var index = delta
            for (i, viewController) in viewControllers.enumerated() {
                
                // delta相对于此栈帧开始生效，即为delta的start（0）
                if viewController.isKind(of: SSKWebViewController.self) {
                    index += i
                    break
                }
            }
            
            // 如果H5本身就在start页，什么也不做
            if index == delta {return}
            
            if  index < viewControllers.count {

                let toViewController = viewControllers[index]
                
                formVC.navigationController?.popToViewController(toViewController, animated: true)
            }
            
        }
    }
    
    
    static func redirectTo(_ url: String) {
        
    }
    
  
}
