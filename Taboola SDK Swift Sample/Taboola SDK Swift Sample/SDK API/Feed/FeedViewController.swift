//
//  FeedViewController.swift
//  Taboola API Swift Sample
//
//  Created by Roman Slyepko on 2/15/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

import UIKit
import TaboolaSDK

class FeedViewController: UITableViewController {
    var recommendationRequest: TBRecommendationRequest?
    var placement: TBPlacement?
    
    var items = [TBItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TaboolaApi.sharedInstance()?.start(withPublisherID: "sdk-tester", andApiKey: "d39df1418f5a4819c9eae2ca02595d57de98c246")
        TaboolaApi.sharedInstance()?.clickDelegate = self
        
        fetchRecommendations()
    }

    func fetchRecommendations() {
        recommendationRequest = TBRecommendationRequest()
        recommendationRequest?.sourceType = TBSourceTypeText
        recommendationRequest?.setPageUrl("http://www.example.com")
        
        let parameters = TBPlacementRequest()
        parameters.name = "article"
        parameters.recCount = 2
        
        recommendationRequest?.add(parameters)
        
        TaboolaApi.sharedInstance()?.fetchRecommendations(recommendationRequest,
                                                          onSuccess: {[weak self] (response) in
                                                            guard let placement = response?.placements.firstObject as? TBPlacement else { return }
                                                            self?.placement = placement
                                                            self?.items = placement.listOfItems
                                                            self?.tableView.reloadData()
        }, onFailure: { (error) in
            print("Taboola API: error fetching recommendations: \(error?.localizedDescription)")
        })
    }
    
    func fetchNextPage() {
        guard let placement = placement else {
            return
        }
        TaboolaApi.sharedInstance()?.getNextBatch(for: placement, itemsCount: 3, onSuccess: {[weak self] (response) in
            self?.placement = placement
            self?.items.append(contentsOf: placement.listOfItems)
            self?.tableView.reloadData()
        }, onFailure: { (error) in
            print("Taboola API: error fetching next page: \(error?.localizedDescription)")
        })
    }
    
    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? FeedTableViewCell ?? FeedTableViewCell()
        let item = items[indexPath.row]
        item.initTitleView(cell.titleView)
        item.initThumbnailView(cell.mainImageView)
        item.initBrandingView(cell.brandingView)
        item.initDescriptionView(cell.descriptionView)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            fetchNextPage()
        }
    }

}

extension FeedViewController: TaboolaApiClickDelegate {
    func onItemClick(_ placementName: String!, withItemId itemId: String!, withClickUrl clickUrl: String!, isOrganic organic: Bool) -> Bool {
        return true
    }
    
    
}
