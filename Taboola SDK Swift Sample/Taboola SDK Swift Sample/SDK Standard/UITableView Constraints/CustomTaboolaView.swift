//
//  CustomTaboolaView.swift
//  Taboola SDK Swift Sample
//
//  Created by Liad Elidan on 24/11/2019.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import Foundation
import UIKit
import TaboolaSDK

class CustomTaboolaView: UIView {
    
    private enum Constants {
        static let enabledConstraintsModeKey = "enabledConstraints"
    }

    var taboolaView: TaboolaView?
    private var heightConstraint: NSLayoutConstraint!

    weak var taboolaViewDelegate: TaboolaViewDelegate? {
        didSet {
            taboolaView?.delegate = taboolaViewDelegate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        let taboolaView =  TaboolaView()
        taboolaView.delegate = taboolaViewDelegate
        taboolaView.logLevel = .debug
        taboolaView.setOptionalPageCommands([Constants.enabledConstraintsModeKey: true])

        heightConstraint = taboolaView.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint.isActive = true
        self.taboolaView = taboolaView
    }
    
    func addTaboolaSubview() {
        addSubviewAndConstrain(self.taboolaView ?? TaboolaView())
    }
    
    func loadAd(_ modeFlag: Bool) {
        guard let taboolaView = taboolaView else {
            return
        }
        
        if !modeFlag {
            taboolaView.publisher = "sdk-tester"
            taboolaView.placement = "Below Article"
            taboolaView.pageType = "article"
            taboolaView.mode = "alternating-widget-without-video"
            taboolaView.pageUrl = "http://www.example.com"
            taboolaView.fetchContent()
            print("Taboola webview - LOADING with taboolaView: \(taboolaView)")
        }
        else {
            taboolaView.publisher = "sdk-tester"
            taboolaView.placement = "Feed without video"
            taboolaView.pageType = "article"
            taboolaView.mode = "thumbs-feed-01"
            taboolaView.pageUrl = "http://www.example.com"
            taboolaView.fetchContent()
            taboolaView.setInterceptScroll(true)
            print("Taboola webview - LOADING with taboolaView: \(taboolaView)")
            
        }

    }
        
    func update(height: CGFloat) {
        heightConstraint?.constant = height
    }
}
