//
//  GalleryCollectionViewCell.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 19/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

protocol GalleryCollectionViewCellDelegate: class {
    func didTapDeleteButton(indexPath: IndexPath)
}

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var indexPath: IndexPath!
    
    weak var delegate: GalleryCollectionViewCellDelegate?
    
    func configureCell(image: UIImage, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        
        self.imageView.image = image
        
    }
    
    @IBAction func actionDeleteButtonTapped(_ sender: Any) {
        delegate?.didTapDeleteButton(indexPath: self.indexPath)
    }
    
    
    
    
}
