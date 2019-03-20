//
//  MidArticleScrollViewController.swift
//  Taboola SDK Swift Sample
//
//  Created by Roman Slyepko on 3/13/19.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import UIKit
import TaboolaSDK

class MidArticleScrollViewController: UIViewController {
    @IBOutlet weak var midTaboolaView: TaboolaView!
    @IBOutlet weak var feedTaboolaView: TaboolaView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load mid tabolaView
        midTaboolaView.delegate = self
        midTaboolaView.ownerViewController = self
        midTaboolaView.publisher = "sdk-tester"
        midTaboolaView.mode = "alternating-widget-without-video-1-on-1"
        midTaboolaView.pageType = "article"
        midTaboolaView.pageUrl = "http://www.example.com"
        midTaboolaView.placement = "Mid Article"
        midTaboolaView.targetType = "mix"
        midTaboolaView.logLevel = .debug
        
        // load feed tabolaView
        feedTaboolaView.delegate = self
        feedTaboolaView.ownerViewController = self
        feedTaboolaView.publisher = "sdk-tester"
        feedTaboolaView.mode = "thumbs-feed-01"
        feedTaboolaView.pageType = "article"
        feedTaboolaView.pageUrl = "http://www.example.com"
        feedTaboolaView.placement = "Feed without video"
        feedTaboolaView.targetType = "mix"
        feedTaboolaView.setInterceptScroll(true)
        feedTaboolaView.logLevel = .debug
        
        midTaboolaView.fetchContent()
        feedTaboolaView.fetchContent()
    }
    
    deinit {
        midTaboolaView.reset()
        feedTaboolaView.reset()
    }
}

extension MidArticleScrollViewController: TaboolaViewDelegate {
    func taboolaView(_ taboolaView: UIView!, didLoadPlacementNamed placementName: String, withHeight height: CGFloat) {
        print("Did load: \(placementName)")
    }
    
    func taboolaView(_ taboolaView: UIView!, didFailToLoadPlacementNamed placementName: String, withErrorMessage error: String) {
        print("Did fail: \(placementName) error: \(error)")
    }
    
    func onItemClick(_ placementName: String!, withItemId itemId: String, withClickUrl clickUrl: String, isOrganic organic: Bool) -> Bool {
        return true
    }
}
