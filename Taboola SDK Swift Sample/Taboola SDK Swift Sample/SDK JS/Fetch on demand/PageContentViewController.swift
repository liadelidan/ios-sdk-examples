//
//  PageContentViewController.swift
//  Taboola JS Swift Sample
//
//  Created by Roman Slyepko on 2/12/19.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import UIKit
import WebKit
import TaboolaSDK

class PageContentViewController: UIViewController {
    var pageIndex: Int?

    @IBOutlet weak var indexLabel: UILabel!
    var didLoadTaboola = false
    
    @IBOutlet weak var webViewContainer: UIView!
    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = view.frame
        webViewContainer.addSubview(webView)
        if let pageIndex = pageIndex {
            indexLabel.text = "\(pageIndex)"
        }
        TaboolaJS.sharedInstance()?.logLevel = .debug
        TaboolaJS.sharedInstance()?.registerWebView(webView, with: self)
        do { try loadExamplePage() }
        catch {
            print("Error loading HTML: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !didLoadTaboola {
            didLoadTaboola = true
            if let pageIndex = pageIndex, pageIndex == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { 
                    self.fetch()
                }
            } else {
                self.fetch()
            }
        }
    }
    
    func loadExamplePage() throws {
        guard let htmlPath = Bundle.main.path(forResource: "sampleContentPageLazyLoad", ofType: "html") else {
            print("Error loading HTML")
            return
        }
        let appHtml = try String.init(contentsOfFile: htmlPath, encoding: .utf8)
        webView.loadHTMLString(appHtml, baseURL: URL(string: "http://cdn.taboola.com/mobile-sdk/init/"))
    }
    
    func fetch() {
        TaboolaJS.sharedInstance()?.fetchContent(webView)
    }
    
    @IBAction func fetchButtonPressed(_ sender: Any) {
       fetch()
    }
}

extension PageContentViewController: TaboolaJSDelegate {
    func onItemClick(_ placementName: String!, withItemId itemId: String!, withClickUrl clickUrl: String!, isOrganic organic: Bool) -> Bool {
        return true
    }
    
    func webView(_ webView: UIView!, didFailToLoadPlacementNamed placementName: String!, withErrorMessage error: String!) {
        
    }
}

