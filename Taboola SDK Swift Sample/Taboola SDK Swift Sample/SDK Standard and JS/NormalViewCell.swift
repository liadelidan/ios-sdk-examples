//
//  NormalViewCell.swift
//  Taboola API Swift Sample
//
//  Created by Liad Elidan on 17/07/2019.
//  Copyright © 2019 LiadElidan. All rights reserved.
//

import UIKit

class NormalViewCell: UICollectionViewCell {
    @IBOutlet weak var myLabel: UILabel!
    
    deinit {
        print("Deleted")
    }
}
