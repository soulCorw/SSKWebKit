//
//  SSKWebOCRDelegate.swift
//  SSKWebKit
//
//  Created by mac on 2019/9/24.
//  Copyright © 2019 SSK. All rights reserved.
//

import UIKit
import WebViewJavascriptBridge
import SwiftyJSON

class SSKWebOCRDelegate {

    
    /*
     
     OCR 识别类型编码对照表
     
     100：中国居民二代身份证（正反面）
     101：中国大陆银行卡
 
    */
    
    private var jsBridge: WKWebViewJavascriptBridge!
    
    // 把事件抛给外部
    var jsCallOCRHandler: ((Int) ->Void)?
    
    init(_ bridge: WKWebViewJavascriptBridge) {
        jsBridge = bridge
        
        bridgeRegister()
    }
    
    
    func bridgeRegister() {
        
        
        /* H5传入参数
         type：识别类型编码
         */
        jsBridge.registerHandler("callOCR") { [unowned self] (data, responseCallback) in
            
            var result = false
            
            if let info = data {
                let json = JSON(info)
                let type =  json.intValue
                
                if let handler = self.jsCallOCRHandler {
                    handler(type)
                    
                    result = true
                }
                
            }
            
            // 告诉H5调用成功还是失败
            if let callback = responseCallback {
                callback(result)
            }
            
            
        }
        
        
    }
    
    
    // 给H5返回识别结果
    func ocrResult(_ result: [String: Any]) {
        
       jsBridge.callHandler("ocrResult", data: result) { (info) in
        debugPrint(info as Any)
       }
    }
    
    
    
    deinit {
        debugPrint(SSKWebOCRDelegate.self, #function)
    }
    
}
