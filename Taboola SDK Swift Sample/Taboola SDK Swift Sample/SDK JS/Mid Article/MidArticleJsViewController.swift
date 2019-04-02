//
//  MidArticleJsViewController.swift
//  Taboola JS Swift Sample
//
//  Created by Roman Slyepko on 2/12/19.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import UIKit
import WebKit
import TaboolaSDK

class MidArticleJsViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TaboolaJS.sharedInstance()?.delegate = self
        TaboolaJS.sharedInstance()?.logLevel = .debug
        TaboolaJS.sharedInstance()?.registerWebView(webView)
        // Do any additional setup after loading the view.
        try? loadExamplePage()
    }
    
    func loadExamplePage() throws {
        guard let htmlPath = Bundle.main.path(forResource: "sampleContentPage", ofType: "html") else {
            print("Error loading HTML")
            return
        }
        let appHtml = try String.init(contentsOfFile: htmlPath, encoding: .utf8)
        webView.loadHTMLString(appHtml, baseURL: URL(string: "http://cdn.taboola.com/mobile-sdk/init/"))
    }
}

extension MidArticleJsViewController: TaboolaJSDelegate {
    func onItemClick(_ placementName: String!, withItemId itemId: String!, withClickUrl clickUrl: String!, isOrganic organic: Bool) -> Bool {
        return true
    }
}
