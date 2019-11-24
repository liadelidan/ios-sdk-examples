//
//  TaboolaCellConstraints.swift
//  Taboola SDK Swift Sample
//
//  Created by Liad Elidan on 24/11/2019.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import Foundation
import UIKit
import TaboolaSDK

class TaboolaCellConstraints: UITableViewCell {
    
    weak var customTaboolaContent: CustomTaboolaView?
    private var regularWidthConstraints = [NSLayoutConstraint]()
    private var compactWidthConstraints = [NSLayoutConstraint]()
    
    private enum Constants {
        static let regularWidthConstant: CGFloat = 300
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    
    func loadAd() {
        customTaboolaContent?.loadAd()
    }
    
    func addTaboolaSubview() {
        customTaboolaContent?.addTaboolaSubview()
    }
    
    private func setupCell() {
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let view = CustomTaboolaView()
        selectionStyle = .none
        setup(view: view)
    }
    
    private func setup(view: CustomTaboolaView) {
        customTaboolaContent = view
        contentView.addSubview(customTaboolaContent ?? view)
        setupConstraints(withContent: view)
        activateConstraints()
    }
    
    private func setupConstraints(withContent content: CustomTaboolaView) {
        content.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = content.widthAnchor.constraint(equalToConstant: Constants.regularWidthConstant)
        let centerXConstraint = content.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        regularWidthConstraints = [widthConstraint, centerXConstraint]
        
        let leadingConstraint = content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let trailingConstraint = contentView.trailingAnchor.constraint(equalTo: content.trailingAnchor)
        compactWidthConstraints = [leadingConstraint, trailingConstraint]
        
        // Constraints that should always be active
        content.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: 10.0).isActive = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        activateConstraints()
    }
    
    private func activateConstraints() {
        regularWidthConstraints.forEach { $0.isActive = false }
        compactWidthConstraints.forEach { $0.isActive = true }
    }
}
