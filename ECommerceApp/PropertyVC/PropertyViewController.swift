//
//  PropertyViewController.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 16/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import IDMPhotoBrowser

class PropertyViewController: UIViewController {
    
    struct Storyboard {
        enum cellID: String {
            case mainInfoCell       = "MainInfoCell"
            case featuresLabelCell  = "FeaturesLabelCell"
            case detailsCell        = "DetailsCell"
            case descriptionCell    = "DescriptionCell"
            case mapViewCell        = "MapViewCell"

        }
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var callButton: UIButton!
    
    var property: Property!
    
    var imageArray: [UIImage] = []
    
    var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.separatorStyle = .none
        
        self.tableView.allowsSelection = false
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        
        imageScrollView.addGestureRecognizer(tapGesture)
        
        setupUI()
        
        // image
        if let imageLinks = property.imageLinks, imageLinks != "" {
            
            downloadImages(urls: imageLinks, withBlock: { (images) in
                self.activityIndicator.stopAnimating()
                
                self.imageArray = images!
                
                self.setSlideShow()
            })
            
            
        } else {

            self.imageArray.append(UIImage(named: "propertyPlaceholder")!)
            self.setSlideShow()
            self.activityIndicator.stopAnimating()
        }
        
    }
    
    @objc func imageTapped() {
        
        let photos = IDMPhoto.photos(withImages: imageArray)
        
        let browser = IDMPhotoBrowser(photos: photos)
        
        browser?.setInitialPageIndex(0)
        
        self.present(browser!, animated: true, completion: nil)
        
    }
    
    func setSlideShow() {
        
        for index in 0..<imageArray.count {
            let imageView = UIImageView()
            imageView.image = imageArray[index]
            imageView.contentMode = .scaleAspectFit
            
            let xPos = self.view.frame.width * CGFloat(index)
            imageView.frame = CGRect(x: xPos, y: 0, width: imageScrollView.frame.width, height: imageScrollView.frame.height)
            imageScrollView.contentSize.width = imageScrollView.frame.width * CGFloat(index + 1)
            imageScrollView.addSubview(imageView)
        }
        
    }
    
    func setupUI() {
        if FUser.currentUser() != nil {
            self.callButton.isEnabled = true
        }
        
        
    }
    
    
    @IBAction func actionBackButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func actionCallButtonTapped(_ sender: Any) {
        
        let currentUser = FUser.currentUser()!
        
        let message = "I am interested in property with reference code \(property.referenceCode!)"
        
        sendPushNotification(toProperty: property, message: message)
        
        let fbNotification = FBNotification(buyerId: currentUser.objectID, agentId: property.ownerId!, createdAt: Date(), phoneNumber: currentUser.phoneNumber, additionalPhoneNumber: currentUser.additionalPhoneNumber, buyerFullName: currentUser.fullName, propertyReference: property.referenceCode!, propertyObjectId: property.objectId!)
        
        saveNotificationInBackground(fbNotification: fbNotification)
        
       
        
    }
    

}


extension PropertyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if property.propertyDescription != nil || property.address != nil || (property.latitude != 0 && property.longitude != 0) {
            return 3
        } else {
            return 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 12
        case 2:
            
            if property.latitude != 0 && property.longitude != 0 {
                return 3
            } else {
                
                return 2
            }
            
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        switch indexPath.section {
        case 0:
            cell = configureSectionFirst(row: indexPath.row)
            
        case 1:
            cell = configureSectionSecond(row: indexPath.row)
        case 2:
            cell = configureSectionThird(row: indexPath.row)

        default:
            cell = UITableViewCell()
        }
        
        return cell
        
    }
    
    func configureSectionFirst(row: Int) -> UITableViewCell {
        
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.mainInfoCell.rawValue, for: IndexPath(row: row, section: 0)) as! MainInfoCell
            
            // configure main cell
            
            cell.configureCell(property: property)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.featuresLabelCell.rawValue, for: IndexPath(row: row, section: 0))  as! FeaturesLabelCell
            
            // configure label cell
            cell.centralLabel.text = "Features"
            
            return cell

        }
        

    }
    
    func configureSectionSecond(row: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.detailsCell.rawValue, for: IndexPath(row: row, section: 0)) as! DetailsCell
        
        // configure details cell
        cell.configureCell(property: property, row: row)
        
        return cell
    }
    
    func configureSectionThird(row: Int) -> UITableViewCell {
        
        
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.featuresLabelCell.rawValue, for: IndexPath(row: row, section: 0))  as! FeaturesLabelCell
            
            // configure label cell
            cell.centralLabel.text = "Description"
            return cell

            
        } else if row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.descriptionCell.rawValue, for: IndexPath(row: row, section: 0))  as! DescriptionCell
            
            // configure desctiption cell
            cell.configureCell(property: property)
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellID.mapViewCell.rawValue, for: IndexPath(row: row, section: 0))  as! MapViewCell
            
            // configure mapView cell
            cell.configureCell(property: property)
            return cell

        }
        
        
    }
    
    
    
    
    
}




extension PropertyViewController: UITableViewDelegate {
    

    
    
    
    
    
    
    
}











