//
//  RandomColorCell.swift
//  Taboola SDK Swift Sample
//
//  Created by Liad Elidan on 24/11/2019.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import UIKit

class RandomColorCell: UITableViewCell {
    
    private enum Constants {
        static let height: CGFloat = 200
    }
    
    private var heightConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        heightConstraint = contentView.heightAnchor.constraint(equalToConstant: Constants.height)
        heightConstraint?.isActive = true
    }
    
    func setRandomColor() {
        contentView.backgroundColor = UIColor.randomCreation()
    }
}
