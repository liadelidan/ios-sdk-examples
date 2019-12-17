//
//  TaboolaSDKApiSwiftSampleTests.swift
//  TaboolaSDKSwiftSampleTests
//
//  Created by Karen Shaham Palman on 17/12/2019.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import TaboolaSDK
import XCTest

class TaboolaSDKApiSwiftSampleTests: XCTestCase, TaboolaApiClickDelegate {
    
    private var didReceiveAdExpectation: XCTestExpectation!
    private var adView: TBPlacement!
    
    var recommendationRequest: TBRecommendationRequest?
    var placement: TBPlacement?
    
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
        
        TaboolaApi.sharedInstance()?.start(withPublisherID: "sdk-tester", andApiKey: "d39df1418f5a4819c9eae2ca02595d57de98c246")
        TaboolaApi.sharedInstance()?.clickDelegate = self
        
        fetchRecommendations()
        
        // Waits 20 seconds for results.
        // Timeout is always treated as a test failure.
        waitForExpectations(timeout: 20)
        XCTAssertNotNil(adView)
    }
    
    func fetchRecommendations() {
        recommendationRequest = TBRecommendationRequest()
        recommendationRequest?.sourceType = TBSourceTypeText
        recommendationRequest?.setPageUrl("http://www.example.com")
        
        let parameters = TBPlacementRequest()
        parameters.name = "article"
        parameters.recCount = 1
        
        recommendationRequest?.add(parameters)
        
        TaboolaApi.sharedInstance()?.fetchRecommendations(recommendationRequest,
                                                          onSuccess: {[weak self] (response) in
                                                            guard let placement = response?.placements.firstObject as? TBPlacement else { return }
                                                            
                                                            self?.adView = placement
                                                            self?.didReceiveAdExpectation.fulfill()

                                                            // self?.items = placement.listOfItems
                                                            // self?.updateTaboolaUI()

            }, onFailure: { (error) in
                self.adView = self.placement
                print("Taboola API: error fetching recommendations: \(error?.localizedDescription)")
        })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
