//
//  TBTableViewController.swift
//  TaboolaDemoSwiftApp
//
//  Created by Yuta Amakawa on 2019/02/15.
//  Copyright © 2019 Taboola. All rights reserved.
//

import UIKit
import TaboolaSDK

class TaboolaCell: UITableViewCell {

    
    
    

}

class TBTableViewChangeScrollInFeedManual: UITableViewController {
    
    var taboolaView:TaboolaView!
    var didLoadTaboolaView = false

    override func viewDidLoad() {
        super.viewDidLoad()
        taboolaView = TaboolaView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: TaboolaView.widgetHeight()))
        taboolaView.delegate = self
        taboolaView.ownerViewController = self
        taboolaView.mode = "thumbs-feed-01";
        taboolaView.publisher = "sdk-tester";
        taboolaView.pageType = "article";
        taboolaView.pageUrl = "http://www.example.com";
        taboolaView.placement = "Feed without video";
        taboolaView.targetType = "mix";
        taboolaView.overrideScrollIntercept = true
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
            return TaboolaView.widgetHeight()
        default:
            return 200
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 4:
            let taboolaCell = tableView.dequeueReusableCell(withIdentifier: "taboolaCell", for: indexPath) as! TaboolaCell
            for v in taboolaCell.contentView.subviews {
                v.removeFromSuperview()
            }
            taboolaCell.contentView.addSubview(taboolaView)
            if !didLoadTaboolaView {
                didLoadTaboolaView = true
                taboolaView.fetchContent()
            }
            return taboolaCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath)
            cell.contentView.backgroundColor = UIColor.random
            return cell
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didEndScrollOfParentScrollView(scrollView)
    }
    
    func didEndScrollOfParentScrollView(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        var contentYoffset = scrollView.contentOffset.y
        if #available(iOS 11.0, *) {
            contentYoffset = contentYoffset - scrollView.adjustedContentInset.bottom
        }
        else {
            contentYoffset = contentYoffset - scrollView.contentInset.bottom
        }
        let distanceFromBottom = (scrollView.contentSize.height - contentYoffset)
        if didLoadTaboolaView && distanceFromBottom < height && self.tableView.isScrollEnabled {
            print("### did end scroll tableView \(height)")
            taboolaView.scrollEnable = true
            scrollView.isScrollEnabled = false
        }
        
    }
    
    deinit {
        taboolaView.reset()
        print("deinit called")
    }
    
    
}


extension TBTableViewChangeScrollInFeedManual: TaboolaViewDelegate {
    
    func scrollViewDidScroll(toTopTaboolaView taboolaView: UIView!) {
        self.taboolaView.scrollEnable = false
        self.tableView.isScrollEnabled = true
        print("### did scroll to top taboolaView")
    }
    

    func taboolaView(_ taboolaView: UIView!, didLoadPlacementNamed placementName: String!, withHeight height: CGFloat) {
        //
    }

    func taboolaView(_ taboolaView: UIView!, didFailToLoadPlacementNamed placementName: String!, withErrorMessage error: String!) {
        //
    }

    func onItemClick(_ placementName: String!, withItemId itemId: String!, withClickUrl clickUrl: String!, isOrganic organic: Bool) -> Bool {
        return true
    }
}
