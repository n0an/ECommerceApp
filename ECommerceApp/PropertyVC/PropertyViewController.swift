//
//  PropertyViewController.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 16/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class PropertyViewController: UIViewController {
    
    struct Storyboard {
        enum cellID: String {
            case mainInfoCell       = "MainInfoCell"
            case featuresLabelCell  = "FeaturesLabelCell"
            case detailsCell        = "DetailsCell"
            case descriptionCell    = "DescriptionCell"
            case mapViewCell        = "MapViewCell"

        }
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    

}


extension PropertyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 5
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        switch indexPath.section {
        case 0:
            cell = configureSectionFirst(row: indexPath.row)
            
        case 1:
            cell = configureSectionSecond(row: indexPath.row)
        case 2:
            cell = configureSectionThird(row: indexPath.row)

        default:
            cell = UITableViewCell()
        }
        
        return cell
        
    }
    
    func configureSectionFirst(row: Int) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.mainInfoCell.rawValue, for: IndexPath(row: row, section: 0)) as! MainInfoCell
            
            // configure main cell
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.featuresLabelCell.rawValue, for: IndexPath(row: row, section: 0))  as! FeaturesLabelCell
            
            // configure label cell
        }
        
        return cell
    }
    
    func configureSectionSecond(row: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.detailsCell.rawValue, for: IndexPath(row: row, section: 0)) as! DetailsCell
        
        // configure details cell
        
        return cell
    }
    
    func configureSectionThird(row: Int) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.featuresLabelCell.rawValue, for: IndexPath(row: row, section: 0))  as! FeaturesLabelCell
            
            // configure label cell
            
        } else if row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.descriptionCell.rawValue, for: IndexPath(row: row, section: 0))  as! DescriptionCell
            
            // configure desctiption cell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.mapViewCell.rawValue, for: IndexPath(row: row, section: 0))  as! MapViewCell
            
            // configure mapView cell

        }
        
        return cell
    }
    
}




extension PropertyViewController: UITableViewDelegate {
    
}
