//
//  PropertyCollectionViewCell.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 15/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class PropertyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var topAdImageView: UIImageView!
    
    @IBOutlet weak var soldImageView: UIImageView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    
    func generateCell(property: String) {
        
    }
    
    
    
    @IBAction func actionStarButtonPressed(_ sender: Any) {
    }
    
    
    
}
