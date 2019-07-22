//
//  TaboolaCollectionJSViewCell.swift
//  Taboola SDK Swift Sample
//
//  Created by Liad Elidan on 17/07/2019.
//  Copyright © 2019 LiadElidan. All rights reserved.
//

import UIKit
import WebKit
import TaboolaSDK

class TaboolaCollectionJSViewCell: UICollectionViewCell {
    @IBOutlet weak var webView: WKWebView!
    
    var currentViewId = ""
    
    func loadTaboolaJS(viewId: String) {
        currentViewId = viewId
        TaboolaJS.sharedInstance()?.logLevel = .debug
        TaboolaJS.sharedInstance()?.registerWebView(webView)
        try? loadExamplePage()
    }
    
    func loadExamplePage() throws {
        guard let htmlPath = Bundle.main.path(forResource: "sampleContentPageSTDJS", ofType: "html") else {
            print("Error loading HTML")
            return
        }
        let appHtml = try String.init(contentsOfFile: htmlPath, encoding: .utf8)
        webView.loadHTMLString(appHtml, baseURL: URL(string: "https://cdn.taboola.com/mobile-sdk/init/?\(currentViewId)"))
    }
}
