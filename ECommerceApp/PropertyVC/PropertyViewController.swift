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
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var property: Property!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        
    }
    
    
    @IBAction func actionBackButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            return 11
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
        
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.mainInfoCell.rawValue, for: IndexPath(row: row, section: 0)) as! MainInfoCell
            
            // configure main cell
            
            cell.configureCell(property: property)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.featuresLabelCell.rawValue, for: IndexPath(row: row, section: 0))  as! FeaturesLabelCell
            
            // configure label cell
            cell.centralLabel.text = "Features"
            
            return cell

        }
        

    }
    
    func configureSectionSecond(row: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.detailsCell.rawValue, for: IndexPath(row: row, section: 0)) as! DetailsCell
        
        // configure details cell
        cell.configureCell(property: property, row: row)
        
        return cell
    }
    
    func configureSectionThird(row: Int) -> UITableViewCell {
        
        
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.featuresLabelCell.rawValue, for: IndexPath(row: row, section: 0))  as! FeaturesLabelCell
            
            // configure label cell
            cell.centralLabel.text = "Description"
            return cell

            
        } else if row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.descriptionCell.rawValue, for: IndexPath(row: row, section: 0))  as! DescriptionCell
            
            // configure desctiption cell
            cell.configureCell(property: property)
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.mapViewCell.rawValue, for: IndexPath(row: row, section: 0))  as! MapViewCell
            
            // configure mapView cell
            cell.configureCell(property: property)
            return cell

        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension

    }
    
}




extension PropertyViewController: UITableViewDelegate {
    
    
    
}











