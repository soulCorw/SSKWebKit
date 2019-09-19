//
//  SSKWebViewController.swift
//  EOSPocket
//
//  Created by LiuYing on 2019/1/28.
//  Copyright © 2019 SSK. All rights reserved.
//

import UIKit
import WebKit
import SnapKit


struct NavBarConfig {
    
    var barTintColor: UIColor?
    var tintColor: UIColor?
    
    var titleTextAttributes: [NSAttributedString.Key : Any]?
    
}


class SSKWebNavigationToolBar: UIToolbar {
    
    enum Action {
        case back, next, share
        
        var tag: Int {
            switch self {
            case .back:
                return Tag.back
            case .next:
                return Tag.next
            case .share:
                return Tag.share

            }
        }
        
        
        // tag: 10...12
        static func item(for tag: Int) -> Action? {
            switch tag {
            case Tag.back:
                return .back
            case Tag.next:
                return .next
            case Tag.share:
                return .share
            default:
                return nil
            }
        }
    }
    
    struct Tag {
        static let back  = 10
        static let next  = 11
        static let share = 12
    }
    

    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backItem: UIButton = {
        let item = UIButton(type: .custom)
        item.tag = Tag.back
        let images = Bundle.makeToolBarBackImage()
        item.setImage(images.0.withRenderingMode(.alwaysOriginal), for: .normal)
        item.setImage(images.1.withRenderingMode(.alwaysOriginal), for: .selected)
        item.addTarget(self, action: #selector(itemsAction), for: .touchUpInside)
        return item
    }()
    
    lazy var nextItem: UIButton = {
        let item = UIButton(type: .custom)
        item.tag = Tag.next
        let images = Bundle.makeToolBarNextImage()
        item.setImage(images.0.withRenderingMode(.alwaysOriginal), for: .selected)
        item.setImage(images.1.withRenderingMode(.alwaysOriginal), for: .normal)
        item.addTarget(self, action: #selector(itemsAction), for: .touchUpInside)

        return item
    }()
    

    
    
    var itemHandler: ((Action) -> Void)?
    
    private func setup() {
//        self.backgroundColor = .red
        
        // 在布局自定义的子视图之前，需要先调用完成系统设置的布局，否则自定义的子视图会被遮挡
        // https://www.jianshu.com/p/86767f923293
        self.layoutIfNeeded()
        
        self.addSubview(backItem)
        self.addSubview(nextItem)
        
        backItem.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(0.75)//dividedBy(4)
        }
        
        nextItem.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1.25) // 1.5
        }
        
    }
    
    @objc private func itemsAction(_ sender: UIButton) {
        if let handler = self.itemHandler {
            handler(Action.item(for: sender.tag)!)
        }
    }
}

open class SSKWebViewController: UIViewController {
    
    var navBarOriginBarTintColor: UIColor?
    var navBarOriginTintColor: UIColor?
    var navBarOriginTitleTextAttributes: [NSAttributedString.Key : Any]?
    
    
    open var statusBarStyle: UIStatusBarStyle = .default
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    
    open var urlString: String = ""
    var customTitle: String = "" {
        didSet {
            self.navigationItem.title = customTitle
        }
    }
    
    var isCustomNavBar: Bool = false
    var navBarConfig: NavBarConfig?
    
    // 初始化的URL是否已经加载完成
    var initURLDidFinish: Bool = false
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect.zero)
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.trackTintColor = .white
        view.progressTintColor = UIColor(hex: "4BBA68")
        return view
    }()
    
    private lazy var toolBar: SSKWebNavigationToolBar = {
     
        let bar = SSKWebNavigationToolBar()

        bar.itemHandler = { [unowned self] in
            self.toolBarAction($0)
        }
        return bar
    }()
    
    var jsAlertHandler: ((String, WKFrameInfo) ->Void)?
    
    lazy var jsBridgeHandler: SSKWebViewJSBridgeHandler = {
        let bridge = SSKWebViewJSBridgeHandler()
        return bridge
    }()
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if webView.uiDelegate == nil {
            webView.uiDelegate = self
        }
        if webView.navigationDelegate == nil {
            webView.navigationDelegate = self
        }


        navConfigViewWillAppear()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //initURLDidFinish: 如果html还没有加载完，不会有任何响应
        // 但如果html文件加载比较慢，等加载完成后就会少一次onshow的调用，所以第一次onShow的调用放在加载完成后
        // 但如果加载比较快，加载完成时viewDidAppear还没有走，会不会出现调用两次
        // 错误：html没有加载完成也能响应方法，所以initURLDidFinish计划取消
        debugPrint("viewDidAppear")
        
        //if initURLDidFinish {
            self.jsBridgeHandler.lcDelegate?.onShow()
        //}
        
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navConfigViewWillDisappear()
        
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.jsBridgeHandler.lcDelegate?.onHide()
    }
    
    override open func viewWillLayoutSubviews() {
        print(#function)
        super.viewWillLayoutSubviews()

    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        makeUI()
        loadWebUrlRequest()
        
        // 本控制器不再是webView的代理
        jsBridgeHandler.config(webView, form: self)
        

    }
    

    private func makeUI() {
        self.view.addSubview(webView)
        self.view.addSubview(progressView)
        
        makeWebConstraints()
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(webView)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(3)
        }
        
    }
    
    private func makeWebConstraints() {
        
        webView.snp.makeConstraints {
            
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                $0.top.equalTo(bottomLayoutGuide.snp.top)
                $0.bottom.equalTo(bottomLayoutGuide.snp.bottom)
                
            }
            
             $0.left.right.equalToSuperview()
            
        }
    }
    
    private func showToolBar() {
        
        if webView.canGoBack || webView.canGoForward {
            
            if toolBar.superview == nil {
                let toolBarHeight = 44
                self.view.addSubview(toolBar)
                toolBar.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(toolBarHeight)
                    
                    if #available(iOS 11.0, *) {
                        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                    } else {
                        make.bottom.equalTo(bottomLayoutGuide.snp.bottom)
                    }
                }
                
                // update 是更新已经存在约束的值，而不是新增一个约束
                
                webView.snp.updateConstraints { (make) in
                    if #available(iOS 11.0, *) {
                        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-toolBarHeight)
                    } else {
                        make.bottom.equalTo(bottomLayoutGuide.snp.bottom).offset(-toolBarHeight)
                        
                    }
                }
                
                
            }
            
            
            updateToolBarItems()
        }
        
    }
    
    private func hideToolBar() {
        toolBar.removeFromSuperview()
        
        webView.snp.updateConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.bottom)
            }
        }
        
    }
    
    private func updateToolBarItems() {
        if webView.canGoBack {
            toolBar.backItem.isSelected = false
        } else {
            toolBar.backItem.isSelected = true
        }
        
        if webView.canGoForward {
            toolBar.nextItem.isSelected = false
        } else {
            toolBar.nextItem.isSelected = true
        }
    }
    
    
    
    private func loadWebUrlRequest() {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            webView.load(request)
        }
    }
    
    private func reload() {
        webView.reload()
    }
    
    func redirectTo(_ url: String) {
        urlString = url
        loadWebUrlRequest()
        
    }
    
    
    private func deleteWebCache() {
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        
        let dateFrom = Date.init(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom) {
            debugPrint("清理完成")
        }
    }
    
    // 监控进度
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        print(#function)
        
        if keyPath == "URL" {
            print(keyPath as Any)
            print(change as Any)
            
            print(webView.backForwardList.backList.count)
            print(webView.canGoBack)
            

        }
        
       
        if keyPath == "estimatedProgress" {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.progressView.alpha = 0.0
                }, completion: {
                    if $0 == true {
                        self.progressView.progress = 0
                    }
                })
            }
        }
        
        
    }
    
    deinit {
        
        print(#function)
        
        jsBridgeHandler.lcDelegate?.onUnload()
        
        webView.removeObserver(self, forKeyPath: "URL")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    
    
}


extension SSKWebViewController: WKUIDelegate, WKNavigationDelegate {
    
    // 发起页内跳转Action
    public func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(#function)
        decisionHandler(.allow)
    }
    
    // 单页内跳转时收到服务器响应
    public func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print(#function)
        print(navigationResponse.response.url?.absoluteString as Any)
        decisionHandler(.allow)
    }
    
    
    // 页面开始加载
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.alpha = 1.0
        showToolBar()
        debugPrint(#function)
    }
    
    // 加载完成
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint(#function)
        if self.customTitle == "" {
            self.navigationItem.title = webView.title
        }
        
        if !initURLDidFinish {
            // 加载完成
            jsBridgeHandler.lcDelegate?.onLoad()
           // jsBridgeHandler.lcDelegate?.onShow()
            debugPrint("didFinish------>")
            initURLDidFinish = true
        }
        
        
//        //
        showToolBar()
        
    }
    
    // 服务器重定向
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        debugPrint(#function)
    }
    


    
    // 内容加载失败
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrint(#function)
    }
    
    // 跳转失败
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint(#function)
    }
    
    // 进度
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        debugPrint(#function)
        webView.reload()
    }
    
    // Alert
    public func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        debugPrint(#function)
      
        // js Alert
        
        if let jsHandler = self.jsAlertHandler {
            jsHandler(message, frame)
        } else {
            
            let alert = SSKWebViewAlertController.show(self)
            
            let url = frame.request.url
            print(url?.baseURL as Any)
            print(url?.scheme as Any)
            print(url?.host as Any)
            
            
            alert.topBar.title = url?.host ?? "未知网页"
            alert.message = message
        }

        
        
        // 不调用会崩溃
        completionHandler()
        
    }
    
    // Prompt
    public func webView(_ webView: WKWebView,
                 runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        
    }
    
    // Confirm
    public func webView(_ webView: WKWebView,
                 runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        
    }
}


extension SSKWebViewController {
    
    
    func navConfigViewWillAppear() {
        

        if isCustomNavBar {
            
            navBarOriginBarTintColor = self.navigationController?.navigationBar.barTintColor
            navBarOriginTintColor = self.navigationController?.navigationBar.tintColor
            navBarOriginTitleTextAttributes = self.navigationController?.navigationBar.titleTextAttributes
            
            
            navigationController?.navigationBar.barTintColor = navBarConfig?.barTintColor
            navigationController?.navigationBar.tintColor = navBarConfig?.tintColor
            navigationController?.navigationBar.titleTextAttributes = navBarConfig?.titleTextAttributes
        }
       
        
        
        
    }
    
    func navConfigViewWillDisappear() {
        
        if isCustomNavBar {
            self.navigationController?.navigationBar.barTintColor = navBarOriginBarTintColor
            self.navigationController?.navigationBar.tintColor = navBarOriginTintColor
            self.navigationController?.navigationBar.titleTextAttributes = navBarOriginTitleTextAttributes
        }
        
        
    }
}


extension SSKWebViewController {
    
    func toolBarAction(_ action: SSKWebNavigationToolBar.Action) {
       // print("file:" + #file, "\n", #line, #function)
        switch action {
        case .back:
            if self.webView.canGoBack {
                self.webView.goBack()
            }
            break
        case .next:
            
            if self.webView.canGoForward {
                self.webView.goForward()
            }
     
            break
        default:
            print(#function)
        }
      
    }
}
