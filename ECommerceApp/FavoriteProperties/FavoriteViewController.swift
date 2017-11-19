//
//  FavoriteViewController.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 19/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var noFavoritesLabel: UILabel!
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
        
        let favPropsArray = currentUser.favoriteProperties
        
        if favPropsArray.count > 0 {
            
            let stringClause = "'" + favPropsArray.joined(separator: "', '") + "'"
            
            print("stringClause = " + stringClause)
            
            let whereClause = "objectId IN (\(stringClause))"
            
            print("whereClause = " + whereClause)

            
            Property.fetchPropertiesWith(whereClause: whereClause, completion: { (allProperties) in
                if let allProperties = allProperties, !allProperties.isEmpty {
                    self.properties = allProperties
                    
                    self.noFavoritesLabel.isHidden = true
                    self.collectionView.reloadData()
                }
            })
            
        } else {
            
            self.collectionView.reloadData()
            self.noFavoritesLabel.isHidden = false
        }
        
        
        
    }

    
}

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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


extension FavoriteViewController: PropertyCollectionViewCellDelegate {
    func didClickStarButton(property: Property) {
        print("didClickStarButton")
        
        if let currentUser = FUser.currentUser() {
            
            // check if property is in favourite
            
            if currentUser.favoriteProperties.contains(property.objectId!) {
                // remove from favorite list
                
                let index = currentUser.favoriteProperties.index(of: property.objectId!)
                currentUser.favoriteProperties.remove(at: index!)
                
                updateCurrentUser(withValues: [kFAVORIT: currentUser.favoriteProperties], withBlock: { (success) in
                    if !success {
                        print("Error removing favorite")
                    } else {
                        
                        self.loadProperties()
                        
                        ProgressHUD.showSuccess("Removed from the favorite list")
                    }
                })
                
            }
            
        } else {
            // show login/register screen
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            
            self.present(vc, animated: true, completion: nil)
        }
        
    }
}


