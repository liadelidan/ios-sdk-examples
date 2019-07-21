//
//  TaboolaCollectionViewCell.swift
//  Taboola SDK Swift Sample
//
//  Created by Liad Elidan on 17/07/19.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import UIKit

class TaboolaCollectionViewCell: UICollectionViewCell {
    
    override func prepareForReuse() {
        // Removes views from the cell.
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
    }
}
