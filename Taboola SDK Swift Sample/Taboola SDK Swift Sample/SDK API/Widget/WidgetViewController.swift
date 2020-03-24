//
//  WidgetViewController.swift
//  Taboola API Swift Sample
//
//  Created by Roman Slyepko on 2/14/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

import UIKit
import TaboolaSDK

class WidgetViewController: UIViewController {
    var recommendationRequest: TBRecommendationRequest?
    var placement: TBPlacement?
    
    var items = [TBItem]()
    // taboola IBOutlets
    @IBOutlet weak var imageView: TBImageView!
    @IBOutlet weak var descriptionView: TBDescriptionLabel!
    @IBOutlet weak var brandingView: TBBrandingLabel!
    @IBOutlet weak var titleView: TBTitleLabel!
    
    @IBOutlet weak var widgetContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TaboolaApi.sharedInstance()?.start(withPublisherID: "sdk-tester", andApiKey: "d39df1418f5a4819c9eae2ca02595d57de98c246")
        TaboolaApi.sharedInstance()?.clickDelegate = self
        
        fetchRecommendations()
        
        // Manual dark mode
        descriptionView.textColor = UIColor.white
        brandingView.textColor = UIColor.white
        titleView.textColor = UIColor.white
        widgetContainer.backgroundColor = UIColor.black
    }
    
    func updateTaboolaUI() {
        if let item = items.first {
            item.initThumbnailView(imageView)
            item.initDescriptionView(descriptionView)
            item.initBrandingView(brandingView)
            item.initTitleView(titleView)
        }
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
                                                                self?.placement = placement
                                                                self?.items = placement.listOfItems
                                                                self?.updateTaboolaUI()
        }, onFailure: { (error) in
            print("Taboola API: error fetching recommendations: \(error?.localizedDescription)")
        })
    }
}

extension WidgetViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetFeed") ?? UITableViewCell(style: .default, reuseIdentifier: "WidgetFeed")
        cell.textLabel?.text = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem"
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
        return cell
    }
}

extension WidgetViewController: TaboolaApiClickDelegate {
    func onItemClick(_ placementName: String!, withItemId itemId: String!, withClickUrl clickUrl: String!, isOrganic organic: Bool) -> Bool {
        return true
    }
    
    
}
