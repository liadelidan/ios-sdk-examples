//
//  FeedTableViewCell.swift
//  Taboola API Swift Sample
//
//  Created by Roman Slyepko on 2/15/19.
//  Copyright © 2019 Taboola. All rights reserved.
//

import UIKit
import TaboolaSDK

class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: TBImageView!
    @IBOutlet weak var descriptionView: TBDescriptionLabel!
    @IBOutlet weak var brandingView: TBBrandingLabel!
    @IBOutlet weak var titleView: TBTitleLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        mainImageView.image = nil
    }
}
