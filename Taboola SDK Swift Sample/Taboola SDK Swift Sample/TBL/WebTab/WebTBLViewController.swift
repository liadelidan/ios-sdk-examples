//
//  WebTBLViewController.swift
//  Taboola SDK Swift Sample
//
//  Created by Liad Elidan on 15/03/2020.
//  Copyright © 2020 Taboola LTD. All rights reserved.
//


import UIKit
import WebKit

class WebTBLViewController: UIViewController, WKNavigationDelegate{
    
    
    override func viewDidLoad() {
        let dummy_id = "Ops_Testing"
        let urlToView = "https://www.thestartmagazine.com/feed/summary?publisherId=" + dummy_id + "&key=0QzhwJKBfOxouyYgW3woxhwv04inkqWH&vendor=Reuters,BangShowbiz,Independent_UK&countryCode=GB&language=en"
        if let url = URL(string: urlToView) {
            UIApplication.shared.open(url, options: [:])
        }
    }

}
