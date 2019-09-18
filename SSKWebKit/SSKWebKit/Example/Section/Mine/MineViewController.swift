//
//  MineViewController.swift
//  SSKWebKit
//
//  Created by 书梨公子 on 2019/9/10.
//  Copyright © 2019 SSK. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let item = UIButton(type: .system)
        item.setTitle("next", for: .normal)
        item.addTarget(self, action: #selector(itemAction), for: .touchUpInside)
        self.view.addSubview(item)
        
        item.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    @objc func itemAction(_ sender: UIButton) {
        
        
        let storyboard = UIStoryboard.init(name: "Mine", bundle: nil)
    
        let setringsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
    
        self.navigationController?.pushViewController(setringsVC, animated: true)
    }
    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
