//
//  DetailsCell.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 16/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {
    
    
    @IBOutlet weak var keyLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    let featuresKeysArray = [
        "Balcony size (m2):",
        "Bathrooms",
        "Parking",
        "Floor",
        "Available from:",
        "Construction year:",
        "Central heating:",
        "Solar water heating:",
        "Air condition:",
        "Store room:",
        "Furnished:"
    ]
    


}
