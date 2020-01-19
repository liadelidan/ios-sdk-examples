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

class TableViewWidgetConstraints: UITableViewController {
    private var taboolaCellWidget: TaboolaCellConstraints?
    private var taboolaCellFeed: TaboolaCellConstraints?
    private var didLoadTaboola: Bool = false
    var taboolaWidgetHeight: CGFloat = 0.0
    
    // Constants for cell creation
    let taboolaFirstCell = 1
    let taboolaSecondCell = 3
    let randomCellBeforeWidget = 0
    let randomCellAfterWidget = 2
    
    // Constants for widget/feed locations
    let widgetCellLocation = 6
    let feedCellLocation = 9

    private var cells: [String] {
        var data = [String]()
        for i in 0...3 {
            if i == randomCellBeforeWidget {
                data.append("cell")
                data.append("cell")
                data.append("cell")
                data.append("cell")
                data.append("cell")
                data.append("cell")
                
            }
            else if i == taboolaFirstCell{
                data.append("taboola")
            }
            else if i == randomCellAfterWidget{
                data.append("cell")
                data.append("cell")
            }
            if i == taboolaSecondCell {
                data.append("taboola")
            }
            
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
    
    private func buildTaboolaCell(_ modeFlag: Bool) -> TaboolaCellConstraints {
        let cell = TaboolaCellConstraints()
        cell.customTaboolaContent?.taboolaViewDelegate = self
        cell.loadAd(modeFlag)
        return cell
    }
    
    private func buildFirstTaboolaCell() {
        taboolaCellWidget = buildTaboolaCell(false)
        taboolaCellFeed = buildTaboolaCell(true)
    }
    
    private func createLoadingCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = "Loading Taboola Web View Ad..."
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.row {
        case widgetCellLocation:
            if taboolaWidgetHeight > 0 {
                return taboolaWidgetHeight
            }
            else {
                return 0
            }
        case feedCellLocation:
            return TaboolaView.widgetHeight()
        default:
            return 200
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let dataType = cells[index]
        
        if dataType == "taboola" {
            if indexPath.row == widgetCellLocation {
                if !didLoadTaboola {
                    didLoadTaboola = true
                    taboolaCellWidget?.addTaboolaSubview()
                }
                return taboolaCellWidget ?? createLoadingCell()
            }
            else if indexPath.row == feedCellLocation{
                taboolaCellFeed?.addTaboolaSubview()
                return taboolaCellFeed ?? createLoadingCell()
            }
            else {
                fatalError("Taboola at unexpected index path")
            }
         }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "regularCell", for: indexPath) as? RandomColorCell else {
            fatalError("Wrong cell")
        }
        cell.setRandomColor()
        return cell
    }
    
}

extension TableViewWidgetConstraints: TaboolaViewDelegate {
    
    func taboolaView(_ taboolaView: UIView!, didLoadPlacementNamed placementName: String!, withHeight height: CGFloat) {
        if let firstCell = taboolaCellWidget,
            firstCell.customTaboolaContent?.taboolaView == taboolaView {
            taboolaWidgetHeight = height

            taboolaCellWidget?.customTaboolaContent?.update(height: height)
            let indexPath = IndexPath(row: widgetCellLocation, section: 0)
            print("Taboola webview - loaded a placement with taboolaView: \(taboolaView) - height = \(height)")
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        }    }

    func taboolaView(_ taboolaView: UIView!, didFailToLoadPlacementNamed placementName: String!, withErrorMessage error: String!) {
        //
    }

    func onItemClick(_ placementName: String!, withItemId itemId: String!, withClickUrl clickUrl: String!, isOrganic organic: Bool) -> Bool {
        return true
    }
}

