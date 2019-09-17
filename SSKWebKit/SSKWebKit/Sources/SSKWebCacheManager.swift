//
//  SSKWebCacheManager.swift
//  SSKWebKit
//
//  Created by mac on 2019/9/12.
//  Copyright © 2019 SSK. All rights reserved.
//

import UIKit

typealias SSKWebCachePostHandler = (([String: Any]) ->Void)


protocol SSKWebCacheDelegate {
    
    func didUpdate(key: String, value: Any)
    
    
}





class SSKWebPreference {
    
    static func set(_ key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
        //UserDefaults.standard.synchronize()
    }
    
    static func value(forKey: String) -> Any? {
        return UserDefaults.standard.value(forKey: forKey)
        
    }
}

class SSKWebStorage {
    
    
}


class SSKWebCacheObserver {
    
    // 对象的地址
    var id: String = ""
    
    // 需要监听的keys， 如果为空，则默认监听所有
    // 需要支持Hashable才能放入Set
    var keys: Set<String> = []
    
    // 回调
    var handler: SSKWebCachePostHandler!
}

class SSKWebCache {
    
    /*
     写入一个键值对时，主动通知所有观察者
     
    */
    
    public class var shared: SSKWebCache {
        struct Singleton {
            static let instance = SSKWebCache()
        }
        return Singleton.instance
    }



    private var cacheMap: Dictionary<String, Any> = [:]
    
    private var observers: [String: SSKWebCacheObserver] = [:]


    
    // 监听所有值
    func addObserver(_ observer: SSKWebViewJSBridgeHandler,
                     keys: Set<String> = [],
                     handler: @escaping SSKWebCachePostHandler) {
        
        
      
        let obs = SSKWebCacheObserver()
       

        let key = SSKWebKitTool.address(o: observer)
        obs.id = key
        obs.keys = keys
        obs.handler = handler
        
        observers[key] = obs
        
        
    }
    
    // 监听具体的key
    func addObserver(_ observer: SSKWebViewJSBridgeHandler, forKey: String) {
        
        let key = SSKWebKitTool.address(o: observer)
        let obs = observers[key]
        obs?.keys.insert(forKey)
    }
    
    
    
    func removeObserver(_ observer: SSKWebViewJSBridgeHandler) {
        
        let key = SSKWebKitTool.address(o: observer)
        observers.removeValue(forKey: key)
        
        
    }
    
    // 删除具体的key
    func removeObserver(_ observer: SSKWebViewJSBridgeHandler, forKey: String) {
        
        let key = SSKWebKitTool.address(o: observer)
        let obs = observers[key]
        obs?.keys.remove(forKey)
    }
    
    func removeAllObserver() {
        
        observers.removeAll()
        
    }
    
    
    // cache
    func setCache(_ key: String, value: Any, isPost: Bool = false) {
        cacheMap[key] = value
        
        if isPost {
        
            didUpdate(key: key, value: value)
        }
    }
    
    func getCache(_ key: String) -> Any? {
        return cacheMap[key]
    }
    
    func getAllCache() -> [String: Any] {
        return cacheMap
    }
    
    // 移除Key时自动移除监听者（默认）
    func removeCache(_ key: String, completion:(() ->Void)) {
        cacheMap.removeValue(forKey: key)
        completion()
        
    }
    
    func removeAllCache(_ completion:(() ->Void)) {
        cacheMap.removeAll()
        completion()
    }
    
    
    func didUpdate(key: String, value: Any) {
 
        observers.forEach { (arg) in
      
            let (_, observer) = arg
            let json = [key: value]
            
            if observer.keys.count > 0 {
                
                if observer.keys.contains(key) {
                    observer.handler(json)
                }
            } else {
                // 如果keys为空则默认监听所有key
                observer.handler(json)
            }
           
            
        }
       
    }
    

    

    
}
