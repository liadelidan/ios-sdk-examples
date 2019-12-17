//
//  TaboolaSDKJsSwiftSampleTests.swift
//  TaboolaSDKSwiftSampleTests
//
//  Created by Karen Shaham Palman on 17/12/2019.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import TaboolaSDK
import XCTest
import WebKit

class TaboolaSDKJsSwiftSampleTests: XCTestCase, TaboolaJSDelegate, WKNavigationDelegate {
    
    private var didReceiveAdExpectation: XCTestExpectation!
    private var adView: WKNavigation!
    private var webView: WKWebView!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTaboolaDidReceiveAd() {
        didReceiveAdExpectation = expectation(description: "taboolaDidReceiveAd")
        
        webView = WKWebView()
        TaboolaJS.sharedInstance()?.registerWebView(webView, with: self)
        
        try? loadExamplePage()

        // Waits 20 seconds for results.
        // Timeout is always treated as a test failure.
        waitForExpectations(timeout: 20)
        
        XCTAssertNotNil(self.adView)
    }
    
    func loadExamplePage() throws {
        guard let htmlPath = Bundle.main.path(forResource: "sampleContentPage", ofType: "html") else {
            print("Error loading HTML")
            return
        }
        let appHtml = try String.init(contentsOfFile: htmlPath, encoding: .utf8)
        let wkNav: WKNavigation = (webView.loadHTMLString(appHtml, baseURL: URL(string: "https://cdn.taboola.com/mobile-sdk/init/")) ?? nil)!
        adView = wkNav
        didReceiveAdExpectation.fulfill()
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
