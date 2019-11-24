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
    
    func loadAd() {
        guard let taboolaView = taboolaView else {
            return
        }
                
        taboolaView.publisher = "foxnews-iosapp"
        taboolaView.placement = "Below Article - iOS Tablet"
        taboolaView.pageType = "article"
        taboolaView.mode = "thumbnails-b"
        taboolaView.pageUrl = "https://foxnews.com"
        taboolaView.fetchContent()
        print("Taboola webview - LOADING with taboolaView: \(taboolaView)")
    }
        
    func update(height: CGFloat) {
        heightConstraint?.constant = height
    }
}
