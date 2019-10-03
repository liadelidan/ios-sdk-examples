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

protocol TaboolaContainerDelegate : class {
    func didChangeWebViewHeight(height:CGFloat)
}


class TaboolaCollectionJSViewCell: UICollectionViewCell, WKNavigationDelegate{

    // Creating a delegate for the TaboolaContainerDelegate protocol
    weak var delegate: TaboolaContainerDelegate?

    // Creating the webView to be used
    @IBOutlet weak var webViewJS: WKWebView!
    var currentViewId = ""
    var cellTaboolaWidgetHeight: CGFloat = 0.0
    var lastHeight: CGFloat = 0.0
    
    // Function that loads the taboola JS widget while adding an observer to check from height changes
    func loadTaboolaJS(viewId: String){
        
        webViewJS.scrollView.addObserver(self, forKeyPath: "contentSize", options:NSKeyValueObservingOptions.new, context: nil)
        
        currentViewId = viewId
        TaboolaJS.sharedInstance()?.logLevel = .debug
        TaboolaJS.sharedInstance()?.registerWebView(webViewJS)
        try? loadExamplePage()
    }
    
    // Function that do the actual HTML loading of the Taboola Widget from the appropriate HTML String
    func loadExamplePage() throws {
        guard let htmlPath = Bundle.main.path(forResource: "sampleContentPageSTDJS", ofType: "html") else {
            print("Error loading HTML")
            return
        }
        let appHtml = try String.init(contentsOfFile: htmlPath, encoding: .utf8)
        webViewJS.loadHTMLString(appHtml, baseURL: URL(string: "https://cdn.taboola.com/mobile-sdk/init/?\(currentViewId)"))
    }

    // Function that observes any height changes of the HTML to be presented, and sends it to the collectionview through the delegate
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if (object as AnyObject? === self.webViewJS.scrollView && keyPath == "contentSize") {
            // we are here because the contentSize of the WebView's scrollview changed.

            let scrollView = self.webViewJS.scrollView

            if scrollView.contentSize.height != lastHeight{
                lastHeight = scrollView.contentSize.height
                delegate?.didChangeWebViewHeight(height: scrollView.contentSize.height)
            }
        }
    }
}

