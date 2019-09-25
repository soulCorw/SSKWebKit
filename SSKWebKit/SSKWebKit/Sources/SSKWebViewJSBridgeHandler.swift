//
//  SSKWebViewJSBridgeHandler.swift
//  SSKWebKit
//
//  Created by 书梨公子 on 2019/9/11.
//  Copyright © 2019 SSK. All rights reserved.
//

import UIKit
import WebViewJavascriptBridge
import SwiftyJSON

// 不能使用 static ，因为必须为每一个webViewVC单独配置一个实例
class SSKWebViewJSBridgeHandler {

    
    var jsBridge: WKWebViewJavascriptBridge? = nil {
        didSet {
            
            if jsBridge != nil {
                lcDelegate = SSKWebLifeCycleDelegate(jsBridge!)
                
                
                ocrDelegate = SSKWebOCRDelegate(jsBridge!)
                ocrDelegate?.jsCallOCRHandler = formVC?.jsCallOCRHandler
            } else {
                lcDelegate = nil
                ocrDelegate = nil
            }
            
        }
    }
    
    
    weak var formVC: SSKWebViewController? = nil
    var wkWebView: WKWebView? // tmp
    
    // 与jsBridge对象同步绑定
    
    private(set) var lcDelegate: SSKWebLifeCycleDelegate?
    
    private(set) var ocrDelegate: SSKWebOCRDelegate?
    
    
    init() {
        
    }

    init(_ webView: WKWebView, form viewController: SSKWebViewController) {
        config(webView, form: viewController)
    }
    
    func config(_ webView: WKWebView, form viewController: SSKWebViewController) {
        
        formVC = viewController
        wkWebView = webView
        
        jsBridge = WKWebViewJavascriptBridge(for: webView)
        
        
        jsBridge?.setWebViewDelegate(viewController)
        // 没有循环引用，但还是会泄露。因为会引用加1
        SSKWebCache.shared.addObserver(self) { [unowned self] in
            self.cacheDidChange($0)
        }
        bridgeRegister()
    }
    
    
    private func json(for data: Any?) -> JSON? {
        if let info = data {return JSON(info)}
        return nil
    }
    
    
    
    private func bridgeRegister() {
        
        baseRouter()
        
        baseData()
        
    }
    
    
     private func baseRouter() {
        
        // JS 调原生
        
        // Base Router Protocol 的成员函数 关键参数index
        jsBridge?.registerHandler("switchTab", handler: { [unowned self] (data, callback) in
            
            print("js 调用了原生")
            print("参数：", data!)
            
            if let json = self.json(for: data) {
                if let index = Int(json["index"].stringValue) {
                    SSKWebRouter.switchTab(index)
                }
            }
            
            
            
        })
        
        // 关键参数 url
        jsBridge?.registerHandler("navigateTo", handler: { [unowned self] (data, responseCallback) in
            
            var result = false
            if let json = self.json(for: data) {
                let url = json["url"].stringValue
                
                let webVC = SSKWebViewController()
                webVC.urlString = url
                
                self.formVC?.navigationController?.pushViewController(webVC, animated: true)
                
                result = true
            }
            
            if let callBack = responseCallback {
                callBack(result)
            }
           
            
        })
        
        // 关键参数 delta，range：0...n
        jsBridge?.registerHandler("navigateBack", handler: { [unowned self] (data, callback) in
            if let json = self.json(for: data) {
                print(json)
                let delta = json["delta"].intValue
                print(delta)
                
                
               SSKWebRouter.navigateBack(self.formVC!, delta: delta)
                
                
                
                
            }
        })
        
        
        jsBridge?.registerHandler("reload", handler: { [unowned self] (data, callback) in
            debugPrint("js 调用了 reload")
            self.wkWebView?.reload()
        })
        
        jsBridge?.registerHandler("redirectTo", handler: { [unowned self] (data, callback) in
            if let json = self.json(for: data) {
                 self.formVC?.redirectTo(json.stringValue)
            }
           
        })
        
        
        
    }
    
   
    func baseData() {
        jsBridge?.registerHandler("setPreference", handler: { [unowned self] (data, responseCallback) in
            
            var result = false
            if let json = self.json(for: data) {

                let dictionary = json.dictionaryObject!
                dictionary.forEach({ (arg) in
                    
                    let (key, value) = arg
                    SSKWebPreference.set(key, value: value)
                })
                //dictionary.forEach({ (key, value) in
                    // json 不是 property list object
                    // Attempt to insert non-property list object
                    // 一律转字符串
                    
                //})
//                json.forEach({ (key, value) in
//                    
//                    //
//                })
                
                result = true
            }
            
            if let callback = responseCallback {
                callback(result)
            }
        })
        
        jsBridge?.registerHandler("getPreference", handler: { [unowned self] (data, responseCallback) in
            if let json = self.json(for: data) {
                let key = json.stringValue
                print("key ---->  ", key)
                let value = SSKWebPreference.value(forKey: key)
                
                print("value ----> ", value!)
                if let callBack = responseCallback {
                    
                    callBack(value)
                }
            }
        })
        
        
        
        jsBridge?.registerHandler("setCache", handler: { [unowned self] (data, responseCallback) in
            if let json = self.json(for: data) {
                
                // value 是JSON 传入jsBridge后不能解析
                
                let isPost = json["isPost"].boolValue
                
                var dictionary = json.dictionaryObject!
  
                
                dictionary.removeValue(forKey: "isPost")
                dictionary.forEach({ (arg) in
                    
                    let (key, value) = arg
                    SSKWebCache.shared.setCache(key, value: value, isPost: isPost)
                })
               
                
                if let callback = responseCallback {
                    callback(true)
                }
                
                
            }
            
        })
        
        
        jsBridge?.registerHandler("getCache", handler: { [unowned self] (data, responseCallback) in
            if let json = self.json(for: data) {
                let key = json.stringValue
                let value = SSKWebCache.shared.getCache(key)
                if let callBack = responseCallback {
                     print(type(of: value))
 
                        callBack(value)
                    }
                
            }
        })
        
        jsBridge?.registerHandler("getAllCache", handler: { (data, responseCallback) in
            if let callback = responseCallback {
                callback(SSKWebCache.shared.getAllCache())
            }
        })
        
        jsBridge?.registerHandler("removeCache", handler: { [unowned self] (data, responseCallback) in
            if let json = self.json(for: data) {
                let key = json.stringValue
                SSKWebCache.shared.removeCache(key, completion: {
                    if let callback = responseCallback {
                        callback(true)
                    }
                })
            }
        })
        
        jsBridge?.registerHandler("removeAllCache", handler: { [unowned self] (data, responseCallback) in
            SSKWebCache.shared.removeAllCache {
                if let callback = responseCallback {
                    callback(true)
                }
                
                self.cacheDidRemove()
               
            }
        })
        
        
        jsBridge?.registerHandler("setObserverKey", handler: { [unowned self] (data, responseCallback) in
            if let json = self.json(for: data) {
                json.arrayValue.forEach({ (key) in
                    SSKWebCache.shared.addObserver(self, forKey: key.stringValue)
                })
              
            }
        })
        
        jsBridge?.registerHandler("removeObserverKey", handler: { [unowned self] (data, responseCallback) in
            if let json = self.json(for: data) {
                json.arrayValue.forEach({ (key) in
                     SSKWebCache.shared.removeObserver(self, forKey: key.stringValue)
                })
               
            }
        })
        
        
    }
    
    // 通知H5缓存有更改
    func cacheDidChange(_ json: [String: Any]) {
        jsBridge?.callHandler("cacheDidChange", data:json, responseCallback: { (data) in
            
        })
    }
    
    // 通知所有监听者, cache已经全部删除
    func cacheDidRemove() {
        jsBridge?.callHandler("cacheDidClean")
    }
    

    
    deinit {
        debugPrint(#function)
        SSKWebCache.shared.removeObserver(self)
    }
    
}

