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
            
        }
    }
    
    
    // MARK: - ACTIONS
    
    @IBAction func actionMixerButtonTapped(_ sender: Any) {
        
        
        
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
        
        return cell
        
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Show selected property
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: CGFloat(254))
        
    }
    
}













