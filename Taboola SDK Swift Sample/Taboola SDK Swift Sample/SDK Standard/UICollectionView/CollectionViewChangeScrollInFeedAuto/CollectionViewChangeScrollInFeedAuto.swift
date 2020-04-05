//
//  CollectionViewChangeScrollInFeedAuto.swift
//  Taboola SDK Swift Sample
//
//  Created by Roman Slyepko on 3/18/19.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import UIKit
import TaboolaSDK

class CollectionViewChangeScrollInFeedAuto: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var taboolaWidget: TaboolaView!
    var taboolaFeed: TaboolaView!
    
    var didLoadFeed = false
    
    var taboolaWidgetHeight: CGFloat = 0.0
    
    lazy var viewId: String = {
        let timestamp = Int(Date().timeIntervalSince1970)
        return "\(timestamp)"
    }()
    
    fileprivate struct TaboolaSection {
        let placement: String
        let mode: String
        let index: Int
        let scrollIntercept: Bool
        
        static let widget = TaboolaSection(placement: "Below Article", mode: "alternating-widget-without-video-1x4", index: 1, scrollIntercept: false)
        static let feed = TaboolaSection(placement: "Feed without video", mode: "thumbs-feed-01", index: 3, scrollIntercept: true)
    }
    
    override func viewDidLoad() {
        taboolaWidget = taboolaView(mode: TaboolaSection.widget.mode,
                                    placement: TaboolaSection.widget.placement,
                                    scrollIntercept: TaboolaSection.widget.scrollIntercept)
        taboolaFeed = taboolaView(mode: TaboolaSection.feed.mode,
                                  placement: TaboolaSection.feed.placement,
                                  scrollIntercept: TaboolaSection.feed.scrollIntercept)
        
        taboolaWidget.fetchContent()
    }
    
    func taboolaView(mode: String, placement: String, scrollIntercept: Bool) -> TaboolaView {
        let taboolaView = TaboolaView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        taboolaView.delegate = self
        taboolaView.mode = mode
        taboolaView.publisher = "sdk-tester-demo"
        taboolaView.pageType = "article"
        taboolaView.pageUrl = "http://www.example.com"
        taboolaView.placement = placement
        taboolaView.targetType = "mix"
        taboolaView.setInterceptScroll(scrollIntercept)
        taboolaView.logLevel = .debug
        taboolaView.setExtraProperties(["useOnlineTemplate": true])
        taboolaView.viewID = viewId
        return taboolaView
    }
    
    deinit {
        taboolaWidget.reset()
        taboolaFeed.reset()
    }
    
    func setTaboolaConstraints(taboolaCell:UICollectionViewCell, taboolaView:inout TaboolaView) {
        taboolaView.translatesAutoresizingMaskIntoConstraints = false
        let horizConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[taboolaView]-0-|", options: [], metrics: nil, views: ["taboolaView":taboolaView])
        let vertConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[taboolaView]-0-|", options: [], metrics: nil, views: ["taboolaView":taboolaView])
        taboolaCell.addConstraints(horizConstraints)
        taboolaCell.addConstraints(vertConstraints)
    }
}

extension CollectionViewChangeScrollInFeedAuto: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (section == TaboolaSection.widget.index || section == TaboolaSection.feed.index) ? 1 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let taboolaIdentifier = "TaboolaCell"
        switch indexPath.section {
        case TaboolaSection.widget.index:
            let taboolaCell = collectionView.dequeueReusableCell(withReuseIdentifier: taboolaIdentifier, for: indexPath) as? TaboolaCollectionViewCell ?? TaboolaCollectionViewCell()
            taboolaCell.contentView.addSubview(taboolaWidget)
            setTaboolaConstraints(taboolaCell: taboolaCell, taboolaView: &taboolaWidget)
            return taboolaCell
        case TaboolaSection.feed.index:
            let taboolaCell = collectionView.dequeueReusableCell(withReuseIdentifier: taboolaIdentifier, for: indexPath) as? TaboolaCollectionViewCell ?? TaboolaCollectionViewCell()
            taboolaCell.contentView.addSubview(taboolaFeed)
            setTaboolaConstraints(taboolaCell: taboolaCell, taboolaView: &taboolaFeed)
            return taboolaCell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "randomCell", for: indexPath)
            cell.contentView.backgroundColor = UIColor.random
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case TaboolaSection.widget.index:
            if taboolaWidgetHeight > 0 {
                return CGSize(width: view.frame.size.width, height: taboolaWidgetHeight)
            }
            else {
                return CGSize(width: view.frame.size.width, height: 0)
            }
        case TaboolaSection.feed.index:
            return CGSize(width: view.frame.size.width, height: TaboolaView.widgetHeight())
        default:
            return CGSize(width: view.frame.size.width, height: 200)
        }
    }
        
}

extension CollectionViewChangeScrollInFeedAuto: TaboolaViewDelegate {
    func taboolaView(_ taboolaView: UIView!, didLoadPlacementNamed placementName: String!, withHeight height: CGFloat) {
        if placementName == TaboolaSection.widget.placement {
            taboolaWidgetHeight = height
            if !didLoadFeed {
                didLoadFeed = true
                // We are loading the feed only when the widget finished loading- for dedup.
                taboolaFeed.fetchContent()
            }
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    func taboolaView(_ taboolaView: UIView!, didFailToLoadPlacementNamed placementName: String!, withErrorMessage error: String!) {
        print("Did fail: \(placementName) error: \(error)")
    }
    
    func onItemClick(_ placementName: String!, withItemId itemId: String!, withClickUrl clickUrl: String!, isOrganic organic: Bool) -> Bool {
        return true
    }
}
