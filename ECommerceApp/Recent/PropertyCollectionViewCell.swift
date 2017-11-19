//
//  PropertyCollectionViewCell.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 15/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

@objc protocol PropertyCollectionViewCellDelegate:class {
    @objc optional func didClickStarButton(property: Property)
    @objc optional func didClickMenuButton(property: Property)
}

class PropertyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    
    @IBOutlet weak var menuButton: UIButton!
    
    
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var topAdImageView: UIImageView!
    @IBOutlet weak var soldImageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    
    
    weak var delegate: PropertyCollectionViewCellDelegate?
    
    var property: Property!

    
    func generateCell(property: Property) {
        
        self.property = property
        
        self.titleLabel.text = property.title
        self.roomLabel.text = "\(property.numberOfRooms)"
        self.bathroomLabel.text = "\(property.numberOfBathrooms)"
        self.parkingLabel.text = "\(property.parking)"
        self.priceLabel.text = "\(property.price)"
        self.priceLabel.sizeToFit()
        
        // top
        if property.inTopUntil != nil && property.inTopUntil! > Date() {
            topAdImageView.isHidden = false
        } else {
            topAdImageView.isHidden = true
        }
        
        // sold
        if property.isSold {
            soldImageView.isHidden = false
        } else {
            soldImageView.isHidden = true
        }
        
        // image
        if let imageLinks = property.imageLinks, imageLinks != "" {
            
            downloadImages(urls: imageLinks, withBlock: { (images) in
                self.loadingIndicator.stopAnimating()
                
                self.imageView.image = images?.first
            })
            
            
        } else {
            self.imageView.image = UIImage(named: "propertyPlaceholder")
            self.loadingIndicator.stopAnimating()
        }
        
        if self.likeButton != nil, let currentUser = FUser.currentUser() {
            if currentUser.favoriteProperties.contains(property.objectId!) {
                self.likeButton.setImage(UIImage(named: "starFilled"), for: [])
            } else {
                self.likeButton.setImage(UIImage(named: "star"), for: [])
            }
        }
        
        
    }
    
    
    
    @IBAction func actionStarButtonPressed(_ sender: Any) {
        
        delegate?.didClickStarButton!(property: property)
    }
    
    
    @IBAction func actionMenuButtonTapped(_ sender: Any) {
        delegate?.didClickMenuButton!(property: property)
    }
    
    
    
}
