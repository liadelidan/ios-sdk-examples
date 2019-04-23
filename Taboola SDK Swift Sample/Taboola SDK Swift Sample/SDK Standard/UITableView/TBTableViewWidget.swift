//
//  TBTableViewController.swift
//  TaboolaDemoSwiftApp
//
//  Created by Yuta Amakawa on 2019/02/15.
//  Copyright © 2019 Taboola. All rights reserved.
//

import UIKit
import TaboolaSDK
import WebKit

class TaboolaCell: UITableViewCell {

    
    
    @IBOutlet weak var taboolaView: TaboolaView!
    

}

class TBTableViewWidget: UITableViewController {
    
    var didLoadTaboolaView = false
    var taboolaViewHeight:CGFloat = 0.0
    var cell:TaboolaCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setTaboolaView(taboolaCell:TaboolaCell) {
        cell = taboolaCell
        if !didLoadTaboolaView {
            cell.taboolaView.delegate = self
            cell.taboolaView.ownerViewController = self
            cell.taboolaView.mode = "alternating-widget-without-video";
            cell.taboolaView.publisher = "sdk-tester";
            cell.taboolaView.pageType = "article";
            cell.taboolaView.pageUrl = "http://www.example.com";
            cell.taboolaView.placement = "Below Article";
            cell.taboolaView.targetType = "mix";
            didLoadTaboolaView = true
            cell.taboolaView.fetchContent()
        }
    }
    
    
    // Only for ios10!
    override func viewDidLayoutSubviews() {
        if #available(iOS 10, *) {
            for wView in cell.taboolaView.subviews {
                if let webView = wView as? WKWebView {
                    webView.setNeedsLayout()
                }
            }
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.row {
        case 4:
            return taboolaViewHeight > 0 ? taboolaViewHeight : 20
        default:
            return 200
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 4:
            let taboolaCell = tableView.dequeueReusableCell(withIdentifier: "taboolaCell", for: indexPath) as! TaboolaCell
            setTaboolaView(taboolaCell: taboolaCell)
            
            return taboolaCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath)
            cell.contentView.backgroundColor = UIColor.random
            return cell
        }
    }
    
    
    
}


extension TBTableViewWidget: TaboolaViewDelegate {

    func taboolaView(_ taboolaView: UIView!, didLoadPlacementNamed placementName: String!, withHeight height: CGFloat) {
        taboolaViewHeight = height
        print("did height \(height)")
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func taboolaView(_ taboolaView: UIView!, didFailToLoadPlacementNamed placementName: String!, withErrorMessage error: String!) {
        //
    }

    func onItemClick(_ placementName: String!, withItemId itemId: String!, withClickUrl clickUrl: String!, isOrganic organic: Bool) -> Bool {
        return true
    }
}
