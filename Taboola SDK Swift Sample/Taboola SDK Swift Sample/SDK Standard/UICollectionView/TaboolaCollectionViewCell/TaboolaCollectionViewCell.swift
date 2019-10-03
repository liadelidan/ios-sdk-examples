//
//  TaboolaCollectionViewCell.swift
//  Taboola SDK Swift Sample
//
//  Created by Roman Slyepko on 3/18/19.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import UIKit

class TaboolaCollectionViewCell: UICollectionViewCell {
    
    override func prepareForReuse() {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
    }
}
