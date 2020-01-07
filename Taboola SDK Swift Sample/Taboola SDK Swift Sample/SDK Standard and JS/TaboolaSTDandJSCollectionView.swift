//
//  TaboolaSTDandJSCollectionView.swift
//  Taboola API Swift Sample
//
//  Created by Liad Elidan on 17/07/2019.
//  Copyright © 2019 LiadElidan. All rights reserved.
//

import UIKit
import TaboolaSDK
import WebKit



class TaboolaSTDandJSCollectionView: UIViewController, WKNavigationDelegate, TaboolaContainerDelegate {
    
    // The dynamic height of the widget cell
    var widgetHeight: CGFloat = 1
    // Variable to check that the widget has been loaded once and not more.
    var widgetLoadeed = false
    // Constant of a normal height of cell
    let nativeCellHeight: CGFloat = 200
    // Dedup time-stamp
    lazy var viewId: String = {
        let timestamp = Int(Date().timeIntervalSince1970)
        return "\(timestamp)"
    }()
    // Creating identifiers for the cellviews.
    let taboolaIdentifier = "TaboolaCell"
    let taboolaJSIdentifier = "TaboolaJSCell"
    let normalIdentifier = "normalCell"
    // A simple String array to be used by the label inside the cell.
    let cellsNumber = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var taboolaFeed: TaboolaView!
    
    fileprivate struct TaboolaSection {
        let placement: String
        let whichSection: Int
        
        static let normalMid = TaboolaSection(placement: "", whichSection: 0)
        static let normalEnd = TaboolaSection(placement: "", whichSection: 2)
        static let widget = TaboolaSection(placement: "Mid Article", whichSection: 1)
        static let feed = TaboolaSection(placement: "Feed without video", whichSection: 3)
    }
    
    override func viewDidLoad() {
        
        // Creating the feed.
        taboolaFeed = taboolaViewFeed()
    }
    
    // Function that creates the feed view with the appropriate attributes.
    func taboolaViewFeed() -> TaboolaView {
        let taboolaView = TaboolaView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 0))
    
        taboolaView.delegate = self
        taboolaView.mode = "thumbs-feed-01"
        taboolaView.publisher = "sdk-tester-demo"
        taboolaView.pageType = "article"
        taboolaView.pageUrl = "http://www.example.com"
        taboolaView.placement = "Feed without video"
        taboolaView.targetType = "mix"
        taboolaView.setInterceptScroll(true)
        taboolaView.setOptionalModeCommands(["useOnlineTemplate": true])
        taboolaView.viewID = viewId
        taboolaView.fetchContent()
        return taboolaView
    }
    
    // Reseting the widget
    deinit {
        taboolaFeed.reset()
    }
    
    // Function that sets the right constraints for widget
    func setTaboolaConstraints(taboolaCell:UICollectionViewCell, taboolaView:inout TaboolaView) {
        taboolaView.translatesAutoresizingMaskIntoConstraints = false
        let horizConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[taboolaView]-0-|", options: [], metrics: nil, views: ["taboolaView":taboolaView])
        let vertConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[taboolaView]-0-|", options: [], metrics: nil, views: ["taboolaView":taboolaView])
        taboolaCell.addConstraints(horizConstraints)
        taboolaCell.addConstraints(vertConstraints)
    }
}

extension TaboolaSTDandJSCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    // Choosing how many items(cells) to be in each sections:
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == TaboolaSection.normalMid.whichSection)
        {
            return 0
        }
        else if (section == TaboolaSection.normalEnd.whichSection)
        {
            return 3
        }
        return 1
    }
    
    // Function that creates each cell with the info required.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Switch case for each section.
        switch indexPath.section {
            
        case TaboolaSection.widget.whichSection:
            
            let taboolaCell = collectionView.dequeueReusableCell(withReuseIdentifier: taboolaJSIdentifier, for: indexPath) as? TaboolaCollectionJSViewCell ?? TaboolaCollectionJSViewCell()
            if (!widgetLoadeed)
            {
                taboolaCell.delegate = self
                taboolaCell.loadTaboolaJS(viewId: viewId)
                widgetLoadeed = true
            }
            return taboolaCell
            
        case TaboolaSection.feed.whichSection:
            // Creating the cell, and adding the taboolafeed as a subview of it, while
            // setting the right constraints.
            let taboolaCell = collectionView.dequeueReusableCell(withReuseIdentifier: taboolaIdentifier, for: indexPath) as? TaboolaCollectionViewCell ?? TaboolaCollectionViewCell()
            taboolaCell.contentView.addSubview(taboolaFeed)
            setTaboolaConstraints(taboolaCell: taboolaCell, taboolaView: &taboolaFeed)
            return taboolaCell
            
        // Default case is a regular cell with the number of the cell inside of it.
        default:
            // Creating the cell, and adding the blue color as a background of it, while
            // changing the label text to the right number of the cell.
            let regularCell = collectionView.dequeueReusableCell(withReuseIdentifier: normalIdentifier, for: indexPath) as? NormalViewCell ?? NormalViewCell()
            regularCell.contentView.backgroundColor = UIColor.blue
            
            if (indexPath.section == TaboolaSection.normalMid.whichSection || indexPath.section == TaboolaSection.normalEnd.whichSection)
            {
                regularCell.myLabel.text = cellsNumber[indexPath.item]
            }
            regularCell.myLabel.textColor = UIColor.white
            
            return regularCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case TaboolaSection.widget.whichSection:
            return CGSize(width: view.frame.size.width, height: widgetHeight)
        case TaboolaSection.feed.whichSection:
            return CGSize(width: view.frame.size.width, height: TaboolaView.widgetHeight())
        default:
            return CGSize(width: view.frame.size.width, height: nativeCellHeight)
        }
    }
    
    func didChangeWebViewHeight(height: CGFloat) {
        widgetHeight = height
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension TaboolaSTDandJSCollectionView: TaboolaViewDelegate {
    
    func taboolaView(_ taboolaView: UIView!, didFailToLoadPlacementNamed placementName: String!, withErrorMessage error: String!) {
        print("Did fail: \(placementName) error: \(String(describing: error))")
    }
    
    func onItemClick(_ placementName: String!, withItemId itemId: String!, withClickUrl clickUrl: String!, isOrganic organic: Bool) -> Bool {
        return true
    }
    
}

