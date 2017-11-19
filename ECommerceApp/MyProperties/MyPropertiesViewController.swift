//
//  MyPropertiesViewController.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 19/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class MyPropertiesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noMyPropsLabel: UILabel!
    
    var properties: [Property] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isUserLoggedIn(viewController: self) {
            
            loadProperties()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }

    
    // MARK: - HELPER METHODS
    func loadProperties() {
        
        self.properties = []
        
        let currentUser = FUser.currentUser()!
        
        let whereClause = "ownerId = '\(currentUser.objectID)'"
        
        print("whereClause = " + whereClause)
        
        Property.fetchPropertiesWith(whereClause: whereClause, completion: { (allProperties) in
            if let allProperties = allProperties, !allProperties.isEmpty {
                self.properties = allProperties
                
                self.noMyPropsLabel.isHidden = true
                self.collectionView.reloadData()
            } else {
                self.noMyPropsLabel.isHidden = false
                self.collectionView.reloadData()
            }
        })
        
        
        
        
    }
   

}



extension MyPropertiesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return properties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let property = properties[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyCell", for: indexPath) as! PropertyCollectionViewCell
        
        cell.generateCell(property: property)
        
        cell.delegate = self
        
        return cell
        
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Show selected property
        let propertyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PropertyViewController") as! PropertyViewController
        
        propertyVC.property = self.properties[indexPath.row]
        
        self.present(propertyVC, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: CGFloat(254))
        
    }
    
}


extension MyPropertiesViewController: PropertyCollectionViewCellDelegate {
    
    func didClickMenuButton(property: Property) {
        
    }
    
    
}


