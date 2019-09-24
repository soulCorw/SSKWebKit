//
//  SSKWebLifeCycleDelegate.swift
//  SSKWebKit
//
//  Created by mac on 2019/9/12.
//  Copyright © 2019 SSK. All rights reserved.
//

import UIKit
import WebViewJavascriptBridge

// 相对于 SSKWebViewController 的生命周期

class SSKWebLifeCycleDelegate {

    private var jsBridge: WKWebViewJavascriptBridge!
    
    init(_ bridge: WKWebViewJavascriptBridge) {
        jsBridge = bridge
    }
    
    // 加载完成通知H5
    func onLoad() {
        jsBridge.callHandler("onLoad")
    }
    
    // viewDidAppear
    func onShow() {
        jsBridge.callHandler("onShow")
    }
    
    // viewDidDisappear
    func onHide() {
        jsBridge.callHandler("onHide")
    }
    
    // deinit
    func onUnload() {
        jsBridge.callHandler("onUnload")
    }
    
    deinit {
        debugPrint(SSKWebLifeCycleDelegate.self, #function)
    }
}
