//
//  RecentViewController.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 15/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var properties: [Property] = []
    
    var numberOfPropertiestextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProperties(limitNumber: kRECENTPROPERTYLIMIT)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - HELPER METHODS
    func loadProperties(limitNumber: Int) {
        Property.fetchRecentProperties(limitNumber: limitNumber) { (properties) in
            
            guard let properties = properties else { return }
            guard !properties.isEmpty else { return }
            
            self.properties = properties
            
            self.collectionView.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    
    
    
    // MARK: - ACTIONS
    
    @IBAction func actionMixerButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Update", message: "Set the number of properties to display", preferredStyle: .alert)
        
        alertController.addTextField { (numberOfPropertiesTextField) in
            numberOfPropertiesTextField.placeholder = "Number of Properties"
            numberOfPropertiesTextField.borderStyle = .roundedRect
            numberOfPropertiesTextField.keyboardType = .numberPad
            
            self.numberOfPropertiestextField = numberOfPropertiesTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let updateAction = UIAlertAction(title: "Update", style: .default) { (action) in
            
            if self.numberOfPropertiestextField.text != "" && self.numberOfPropertiestextField.text != "0" {
                ProgressHUD.show("Updating...")
                self.loadProperties(limitNumber: Int(self.numberOfPropertiestextField.text!)!)
            }
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(updateAction)
        
        self.present(alertController, animated: true)
        
    }
    
}


extension RecentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return properties.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyCell", for: indexPath) as! PropertyCollectionViewCell
        
        let property = properties[indexPath.row]
        
        cell.generateCell(property: property)
        
        cell.delegate = self
        
        return cell
        
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Show selected property
        let propertyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PropertyViewController") as! PropertyViewController
        
        self.present(propertyVC, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: CGFloat(254))
        
    }
    
}

extension RecentViewController: PropertyCollectionViewCellDelegate {
    
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











