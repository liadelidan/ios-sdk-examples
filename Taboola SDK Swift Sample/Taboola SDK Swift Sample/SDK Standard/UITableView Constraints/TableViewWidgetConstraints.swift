//
//  UITableViewConstraints.swift
//  Taboola SDK Swift Sample
//
//  Created by Liad Elidan on 24/11/2019.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import UIKit
import TaboolaSDK

extension UIColor {
    static func randomCreation() -> UIColor {
        func randomColorComponent() -> CGFloat {
           return CGFloat.random(in: 0...255) / 255
        }
        return UIColor(red: randomColorComponent(), green: randomColorComponent(), blue: randomColorComponent(), alpha: 1.0)
    }
}

class TableViewWidgetConstraints: UITableViewController, TaboolaViewDelegate {
    private var firstTaboolaCell: TaboolaCellConstraints?
    private var secondTaboolaCell: TaboolaCellConstraints?
    private var didLoadFirstTaboola: Bool = false
    private var didLoadSecondTaboola: Bool = false

    private var cells: [String] {
        var data = [String]()
        for i in 0...50 {
            if i % 25 == 0 && i != 0 {
                data.append("taboola")
            }
            data.append("cell")
        }
        return data
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(RandomColorCell.self, forCellReuseIdentifier: "regularCell")
        buildFirstTaboolaCell()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    private func buildTaboolaCell() -> TaboolaCellConstraints {
        let cell = TaboolaCellConstraints()
        cell.customTaboolaContent?.taboolaViewDelegate = self
        cell.loadAd()
        return cell
    }
    
    private func buildFirstTaboolaCell() {
        firstTaboolaCell = buildTaboolaCell()
    }
    
    private func buildSecondTaboolaCell() {
        secondTaboolaCell = buildTaboolaCell()
    }
    
    private func creareLoadingCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = "Loading Taboola Web View Ad..."
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let dataType = cells[index]
        
        if dataType == "taboola" {
            if indexPath.row == 25 {
                if !didLoadFirstTaboola {
                    didLoadFirstTaboola = true
                    firstTaboolaCell?.addTaboolaSubview()
                }
                return firstTaboolaCell ?? creareLoadingCell()
            } else if indexPath.row == 51 {
                if !didLoadSecondTaboola {
                    didLoadSecondTaboola = true
                    secondTaboolaCell?.addTaboolaSubview()
                }
                return secondTaboolaCell ?? creareLoadingCell()
            } else {
                fatalError("Taboola at unexpected index path")
            }
         }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "regularCell", for: indexPath) as? RandomColorCell else {
            fatalError("Wrong cell")
        }
        cell.setRandomColor()
        return cell
    }
    
    func taboolaView(_ taboolaView: UIView!, didLoadPlacementNamed placementName: String!, withHeight height: CGFloat) {
        if let firstCell = firstTaboolaCell,
            firstCell.customTaboolaContent?.taboolaView == taboolaView {
            firstTaboolaCell?.customTaboolaContent?.update(height: height)

            
            // Create the second taboola cell if it doesn't already exist
            if secondTaboolaCell == nil {
                buildSecondTaboolaCell()
            }
        } else {
            secondTaboolaCell?.customTaboolaContent?.update(height: height)
            
//            secondTaboolaCell?.layoutIfNeeded()
//            tableView.layoutSubviews()
//            tableView.beginUpdates()
//            tableView.endUpdates()
        }
        print("Taboola webview - loaded a placement with taboolaView: \(taboolaView) - height = \(height)")
        tableView.reloadData()
        
    }
}

