//
//  AddPropertyViewController.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 16/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class AddPropertyViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var referenceCodeTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var roomsTextField: UITextField!
    @IBOutlet weak var bathroomsTextField: UITextField!
    @IBOutlet weak var propertySizeTextField: UITextField!
    @IBOutlet weak var balconySizeTextField: UITextField!
    @IBOutlet weak var parkingTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var advertisementTypeTextField: UITextField!
    @IBOutlet weak var availableFromTextField: UITextField!
    @IBOutlet weak var buildYearTextField: UITextField!
    @IBOutlet weak var propertyTypeTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var titleDeedSwitch: UISwitch!
    @IBOutlet weak var centralHeatingSwitch: UISwitch!
    @IBOutlet weak var solarWaterHeatingSwitch: UISwitch!
    @IBOutlet weak var storeRoomSwitch: UISwitch!
    @IBOutlet weak var airConditionerSwitch: UISwitch!
    @IBOutlet weak var furnishedSwitch: UISwitch!
    
    var titleDeedSwitchValue = false
    var centralHeatingSwitchValue = false
    var solarWaterHeatingSwitchValue = false
    var storeRoomSwitchValue = false
    var airConditionerSwitchValue = false
    var furnishedSwitchValue = false
    
    var user: FUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: topView.frame.height)
        
    }
    
    // MARK: - HELPER METHODS
    
    func save() {
        
        if titleTextField.text != "" &&
            referenceCodeTextField.text != "" &&
            advertisementTypeTextField.text != "" &&
            propertyTypeTextField.text != "" &&
            priceTextField.text != "" {
            
            var newProperty = Property()
            
            newProperty.referenceCode = referenceCodeTextField.text!
            newProperty.ownerId = user!.objectID
            newProperty.title = titleTextField.text!
            newProperty.advertisementType = advertisementTypeTextField.text!
            newProperty.price = Int(priceTextField.text!)!
            newProperty.properyType = propertyTypeTextField.text!
            
            if roomsTextField.text != "" {
                newProperty.numberOfRooms = Int(roomsTextField.text!)!
            }
            
            if bathroomsTextField.text != "" {
                newProperty.numberOfBathrooms = Int(bathroomsTextField.text!)!
            }
            
            if buildYearTextField.text != "" {
                newProperty.buildYear = buildYearTextField.text!
            }
            
            if parkingTextField.text != "" {
                newProperty.parking = Int(parkingTextField.text!)!
            }
            
            if propertySizeTextField.text != "" {
                newProperty.size = Double(propertySizeTextField.text!)!
            }
            
            if balconySizeTextField.text != "" {
                newProperty.balconySize = Double(balconySizeTextField.text!)!
            }
            
            if addressTextField.text != "" {
                newProperty.address = addressTextField.text!
            }
            
            if cityTextField.text != "" {
                newProperty.city = cityTextField.text!
            }
            
            if countryTextField.text != "" {
                newProperty.country = countryTextField.text!
            }
            
            if availableFromTextField.text != "" {
                newProperty.availableFrom = availableFromTextField.text!
            }
            
            if floorTextField.text != "" {
                newProperty.floor = Int(floorTextField.text!)!
            }
            
            if descriptionTextView.text != "" && descriptionTextView.text != "Description" {
                newProperty.propertyDescription = descriptionTextView.text
            }
            
            newProperty.titleDeeds = titleDeedSwitchValue
            newProperty.centralHeating = centralHeatingSwitchValue
            newProperty.solarWaterHeating = solarWaterHeatingSwitchValue
            newProperty.airConditioner = airConditionerSwitchValue
            newProperty.storeRoom = storeRoomSwitchValue
            newProperty.isFurnished = furnishedSwitchValue
            
            // check for property images
            
            newProperty.saveProperty()
            ProgressHUD.showSuccess("Saved")
            
            
        } else {
            ProgressHUD.showError("Error: Missing required fields")
        }
        
        
    }
    
    
    // MARK: - ACTIONS
    
    @IBAction func actionSwitchTriggered(_ sender: Any) {
        
        switch sender as! UISwitch {
        case titleDeedSwitch:
            titleDeedSwitchValue = !titleDeedSwitchValue
        case centralHeatingSwitch:
            centralHeatingSwitchValue = !centralHeatingSwitchValue
        case solarWaterHeatingSwitch:
            solarWaterHeatingSwitchValue = !solarWaterHeatingSwitchValue
        case storeRoomSwitch:
            storeRoomSwitchValue = !storeRoomSwitchValue
        case airConditionerSwitch:
            airConditionerSwitchValue = !airConditionerSwitchValue
        case furnishedSwitch:
            furnishedSwitchValue = !furnishedSwitchValue
        default:
            break
        }
        
    }
    
    
    
    @IBAction func actionPinLocationButtonTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func actionCurrentLocationButtonTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func actionCameraButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func actionSaveButtonTapped(_ sender: Any) {
        user = FUser.currentUser()
        
        if !user!.isAgent {
            // check if user can post
            save()
            
        } else {
            save()
        }
        
    }
    
    
    
    
    

}
