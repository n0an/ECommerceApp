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
    
    func configureCell(property: Property, row: Int) {
        
        keyLabel.text = featuresKeysArray[row]
        
        var value = ""
        
        switch row {
        case 0:
            value = "\(property.balconySize)"
        case 1:
            value = "\(property.numberOfBathrooms)"
        case 2:
            value = "\(property.parking)"
        case 3:
            value = "\(property.floor)"
        case 4:
            value = "\(property.availableFrom)"
        case 5:
            value = "\(property.buildYear)"
        case 6:
            value = "\(property.centralHeating)"
        case 7:
            value = "\(property.solarWaterHeating)"
        case 8:
            value = "\(property.airConditioner)"
        case 9:
            value = "\(property.storeRoom)"
        case 10:
            value = "\(property.isFurnished)"


        default:
            break
        }
        
        valueLabel.text = value
        
        
    }

}
