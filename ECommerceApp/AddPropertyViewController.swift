//
//  AddPropertyViewController.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 16/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import ImagePicker

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
    
    var propertyImages: [UIImage] = []
    
    var yearArray: [Int] = []
    var datePicker = UIDatePicker()
    var propertyTypePicker = UIPickerView()
    var advertisementTypePicker = UIPickerView()
    var yearPicker = UIPickerView()
    
    var locationManager: CLLocationManager?
    var locationCoordinates: CLLocationCoordinate2D?
    
    var activeField: UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickes()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        setupYearsArray()
        
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: topView.frame.height)
        
    }
    
    // MARK: - HELPER METHODS
    
    func setupYearsArray() {
        
//        for year in 1850...2030 {
//            yearArray.append(year)
//        }
        yearArray = Array(1800...2030)
        yearArray.reverse()
    }
    
    func save() {
        
        if titleTextField.text != "" &&
            referenceCodeTextField.text != "" &&
            advertisementTypeTextField.text != "" &&
            propertyTypeTextField.text != "" &&
            priceTextField.text != "" {
            
            let newProperty = Property()
            
            ProgressHUD.show("Saving...")
            
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
            
            if !propertyImages.isEmpty {
                
                uploadImages(images: propertyImages, userId: user!.objectID, referenceNumber: newProperty.referenceCode!, withBlock: { (linkString) in
                    newProperty.imageLinks = linkString
                    newProperty.saveProperty()
                    ProgressHUD.showSuccess("Saved")
                    self.dismissView()
                })
                
                
            } else {
                newProperty.saveProperty()
                ProgressHUD.showSuccess("Saved")
                dismissView()
            }
            
        } else {
            ProgressHUD.showError("Error: Missing required fields")
        }
        
    }
    
    func dismissView() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
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
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = kMAXIMAGENUMBER
        
        self.present(imagePickerController, animated: true)
        
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

// MARK: - ImagePickerDelegate
extension AddPropertyViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        propertyImages = images
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: - UITextFieldDelegate
extension AddPropertyViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }
    
//    override func becomeFirstResponder() -> Bool {
//        self.activeField = textField
//        return true
//    }
}

// MARK: - UIPickerViewDataSource
extension AddPropertyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func setupPickes() {
        yearPicker.delegate = self
        propertyTypePicker.delegate = self
        advertisementTypePicker.delegate = self
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.toolbarDonePressed))
        
        toolbar.setItems([flexibleBarButtonItem, doneButton], animated: true)
        
        // !!!IMPORTANT!!!
        // DatePicker and UIPicker for textFields
        buildYearTextField.inputAccessoryView = toolbar
        buildYearTextField.inputView = yearPicker
        
        availableFromTextField.inputAccessoryView = toolbar
        availableFromTextField.inputView = datePicker
        
        propertyTypeTextField.inputAccessoryView = toolbar
        propertyTypeTextField.inputView = propertyTypePicker
        
        advertisementTypeTextField.inputAccessoryView = toolbar
        advertisementTypeTextField.inputView = advertisementTypePicker
        
    }
    
    @objc func toolbarDonePressed() {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case propertyTypePicker:
            return propertyTypes.count
        case advertisementTypePicker:
            return advertismentTypes.count
        case yearPicker:
            return yearArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        case propertyTypePicker:
            return propertyTypes[row]
        case advertisementTypePicker:
            return advertismentTypes[row]
        case yearPicker:
            return "\(yearArray[row])"
        default:
            return nil
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var rowValue = row
        
        switch pickerView {
        case propertyTypePicker:
            if rowValue == 0 {
                rowValue = 1
            }
            propertyTypeTextField.text = propertyTypes[rowValue]
            
        case advertisementTypePicker:
            if rowValue == 0 {
                rowValue = 1
            }
            advertisementTypeTextField.text = advertismentTypes[rowValue]
            
        case yearPicker:
            buildYearTextField.text = "\(yearArray[row])"
            
        default:
            break
        }
        
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        
        if activeField == availableFromTextField {
            availableFromTextField.text = "\(components.day!)/\(components.month!)/\(components.year!)"
        }
        
    }
    
    
    
    
}

// MARK: - CLLocationManagerDelegate
extension AddPropertyViewController: CLLocationManagerDelegate {
    
}




