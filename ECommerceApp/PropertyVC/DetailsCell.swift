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
        "Property Type:",
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
            value = property.properyType!
        case 1:
            value = "\(property.balconySize)"
        case 2:
            value = "\(property.numberOfBathrooms)"
        case 3:
            value = "\(property.parking)"
        case 4:
            value = "\(property.floor)"
        case 5:
            value = property.availableFrom ?? ""
        case 6:
            value = property.buildYear ?? ""
        case 7:
            value = property.centralHeating ? "YES" : "NO"
        case 8:
            value = property.solarWaterHeating ? "YES" : "NO"
        case 9:
            value = property.airConditioner ? "YES" : "NO"
        case 10:
            value = property.storeRoom ? "YES" : "NO"
        case 11:
            value = property.isFurnished ? "YES" : "NO"


        default:
            break
        }
        
        valueLabel.text = value
        
        
    }

}
