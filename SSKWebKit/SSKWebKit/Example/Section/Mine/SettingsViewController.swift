//
//  SettingsViewController.swift
//  SSKWebKit
//
//  Created by 书梨公子 on 2019/9/10.
//  Copyright © 2019 SSK. All rights reserved.
//

import UIKit
import SafariServices

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.tableFooterView = UIView()
        
        

    }

    // MARK: - Table view data source


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            makeSF()
            return
        }

        
        let webVC = SSKWebViewController()
        webVC.urlString = "http://127.0.0.1:8080/webkit/ExampleApp.html"
        //webVC.urlString = "https://sfestival.lizhi.fm/static/rankList/anchorFansContributionList.html?njId=2570067831857038380&tabIndex=1"
       // webVC.urlString = "https://www.baidu.com"
       // webVC.urlString = "https://wx.gfbxjj.cn/insurance_h5/#/product-agreement"
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    
    func makeSF() {
        
        var urlString = "https://sfestival.lizhi.fm/static/rankList/anchorFansContributionList.html?njId=2570067831857038380&tabIndex=1"
        urlString = "https://wx.gfbxjj.cn/insurance_h5/#/product-agreement"
        let url = URL(string: urlString)
        let sfVC = SFSafariViewController(url: url!)
        self.present(sfVC, animated: true, completion: nil)
        //self.navigationController?.pushViewController(sfVC, animated: true)
    }
    
    deinit {
        debugPrint(#function)
    }
  

}
