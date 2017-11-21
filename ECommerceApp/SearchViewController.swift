//
//  SearchViewController.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 20/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var properties: [Property] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func actionMixerButtonTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchParametersViewController") as! SearchParametersViewController
        
        vc.delegate = self
        
        self.present(vc, animated: true, completion: nil)
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return properties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyCell", for: indexPath) as! PropertyCollectionViewCell
        
        cell.delegate = self
        
        cell.generateCell(property: properties[indexPath.row])
        
        return cell
        
    }
    
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


extension SearchViewController: PropertyCollectionViewCellDelegate {
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
                        self.collectionView.reloadData()
                        ProgressHUD.showSuccess("Removed from the favorite list")
                    }
                })
                
            } else {
                // add to favorite list
                currentUser.favoriteProperties.append(property.objectId!)
                
                updateCurrentUser(withValues: [kFAVORIT: currentUser.favoriteProperties], withBlock: { (success) in
                    if !success {
                        print("Error adding favorite")
                    } else {
                        self.collectionView.reloadData()
                        ProgressHUD.showSuccess("Added to the favorite list")
                    }
                })
                
            }
            
        } else {
            // show login/register screen
        }
        
    }
}

extension SearchViewController: SearchParametersViewControllerDelegate {
    func didFinishSettingParameters(whereClause: String) {
        
        loadProperties(whereClause: whereClause)
        
        
    }
    
    // MARK: - Load properties
    
    func loadProperties(whereClause: String) {
        
        properties = []
        
        Property.fetchPropertiesWith(whereClause: whereClause) { (allProps) in
            
            if let allProps = allProps {
                if !allProps.isEmpty {
                    self.properties = allProps
                } else {
                    ProgressHUD.showError("No properties for your search")
                }
            }
            
            self.collectionView.reloadData()
        }
    }
}





