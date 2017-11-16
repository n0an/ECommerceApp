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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
