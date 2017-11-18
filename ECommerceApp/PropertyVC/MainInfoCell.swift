//
//  MainInfoCell.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 16/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class MainInfoCell: UITableViewCell {

    
    @IBOutlet weak var propertyTitleLabel: UILabel!
    
    @IBOutlet weak var propertyPriceLabel: UILabel!
    
    @IBOutlet weak var propertySizeAndRoomsLabel: UILabel!
    
    
    func configureCell(property: Property) {
        
        propertyTitleLabel.text = property.title
        propertyPriceLabel.text = "\(property.price)"
        propertySizeAndRoomsLabel.text = "\(property.size) - \(property.numberOfRooms)"
        
    }

}
