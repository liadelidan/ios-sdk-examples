//
//  Taboola_SDK_Swift_Sample_Tests.swift
//  Taboola SDK Swift Sample Tests
//
//  Created by Tzufit Lifshitz on 10/3/19.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//
import TaboolaSDK
import XCTest

class TaboolaSDKSwiftSampleTests: XCTestCase, TaboolaViewDelegate {

    private var didReceiveAdExpectation: XCTestExpectation!
    private var adView: UIView!
    
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
        
        let taboolaView = TaboolaView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        taboolaView.delegate = self
        
        taboolaView.mode = "alternating-1x2-widget"
        taboolaView.publisher = "sdk-tester"
        taboolaView.pageType = "article"
        taboolaView.pageUrl = "http://www.example.com"
        taboolaView.placement = "Below Article"
        taboolaView.targetType = "mix"
        
        taboolaView.fetchContent()
        
        // Waits 20 seconds for results.
        // Timeout is always treated as a test failure.
        waitForExpectations(timeout: 20)
        XCTAssertNotNil(self.adView)
    }
    
    func taboolaView(_ taboolaView: UIView!, didLoadPlacementNamed placementName: String!, withHeight height: CGFloat) {
        adView = taboolaView
        didReceiveAdExpectation.fulfill()
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
