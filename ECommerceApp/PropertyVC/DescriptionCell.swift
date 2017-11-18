//
//  DescriptionCell.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 16/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {

    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    func configureCell(property: Property) {
        descriptionTextView.text = property.propertyDescription
        addressLabel.text = property.address
    }

}
