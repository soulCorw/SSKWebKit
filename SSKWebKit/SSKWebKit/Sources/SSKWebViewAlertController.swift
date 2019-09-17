//
//  SSKWebViewAlertController.swift
//  GFInsurance
//
//  Created by 书梨公子 on 2019/9/6.
//  Copyright © 2019 SSK. All rights reserved.
//

import UIKit

class SSKWebViewAlertTopBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    
    
}

class SSKWebViewAlertBottomBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var button: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        return btn
    }()
}

class SSKWebViewAlertTextView: UIView {
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var text: String? {
        didSet {
            textView.text = text
        }
    }
    
    lazy private var textView: UILabel = {
        
        let tv = UILabel()
       // tv.isEditable = false
        tv.textAlignment = .center
        tv.backgroundColor = UIColor.white
        return tv
    }()
}



class SSKWebViewAlertController: UIViewController {
    
    lazy var container: UIView = {
        let content = UIView()
        content.backgroundColor = UIColor.white
        content.layer.cornerRadius = 5
        return content
    }()
    

    lazy var topBar: SSKWebViewAlertTopBar = {
        let bar = SSKWebViewAlertTopBar()
        return bar
    }()
    
    lazy var bottomBar: SSKWebViewAlertBottomBar = {
        let bar = SSKWebViewAlertBottomBar()
        bar.button.addTarget(self, action: #selector(bottomBarItemAction), for: .touchUpInside)
        return bar
    }()
    
    
    lazy var textView: SSKWebViewAlertTextView = {
        let tv = SSKWebViewAlertTextView()
        tv.backgroundColor = UIColor.purple
        return tv
    }()
    
    var message: String? {
        didSet {
            textView.text = message
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setup()
        makeUI()
    }
    
    
    private func setup() {
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }
    
    private func makeUI() {
        
        self.view.addSubview(container)
        
        let screen_width = UIScreen.main.bounds.width
        container.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: screen_width * 0.8, height: 200))
        }
        
        topBar.backgroundColor = .red
        container.addSubview(topBar)
        topBar.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(44)
 
        }
        

        container.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        
        self.container.addSubview(self.textView)
        self.textView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
            make.bottom.equalTo(bottomBar.snp.top)
        }
        
        
    }
    
    @objc private func bottomBarItemAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    
    
    // interface
    func show(_ presenting: UIViewController) {
        
        let app = UIApplication.shared
        
        app.keyWindow?.addSubview(self.view)
        self.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        presenting.addChild(self)
    }
    
    func dismiss() {
        
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @discardableResult
    class func show(_ presenting: UIViewController) -> SSKWebViewAlertController {
        let alertController = SSKWebViewAlertController()
        alertController.show(presenting)
        
        return alertController
    }
    



}
