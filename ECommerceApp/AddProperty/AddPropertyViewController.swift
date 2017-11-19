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
    
    @IBOutlet weak var vcTitleLabel: UILabel!
    
    @IBOutlet weak var cameraButton: UIButton!
    
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
    
    @IBOutlet weak var backButton: UIButton!
    
    var titleDeedSwitchValue = false
    var centralHeatingSwitchValue = false
    var solarWaterHeatingSwitchValue = false
    var storeRoomSwitchValue = false
    var airConditionerSwitchValue = false
    var furnishedSwitchValue = false
    
    var property: Property?
    
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
        
        setupPickers()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        setupYearsArray()
        
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: topView.frame.height)
        
        if property != nil {
            // edit
            
            setUIForEdit()
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard isUserLoggedIn(viewController: self) else {
            return
        }
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManagerStop()
    }
    
    // MARK: - HELPER METHODS
    
    func setUIForEdit() {
        
        self.vcTitleLabel.text = "Edit Property"
        
        self.cameraButton.setImage(UIImage(named: "Picture")!, for: [])
        
        self.backButton.isHidden = false
        
        // required
        referenceCodeTextField.text = property!.referenceCode
        titleTextField.text = property!.title
        advertisementTypeTextField.text = property!.advertisementType
        priceTextField.text = "\(property!.price)"
        propertyTypeTextField.text = property!.properyType
        
        // optional
        balconySizeTextField.text = "\(property!.balconySize)"
        bathroomsTextField.text = "\(property!.numberOfBathrooms)"
        buildYearTextField.text = property!.buildYear
        parkingTextField.text = "\(property!.parking)"
        roomsTextField.text = "\(property!.numberOfRooms)"
        propertySizeTextField.text = "\(property!.size)"
        addressTextField.text = property!.address
        availableFromTextField.text = property!.availableFrom
        floorTextField.text = "\(property!.floor)"
        descriptionTextView.text = property!.propertyDescription
        cityTextField.text = property!.city
        countryTextField.text = property!.country
        
        titleDeedSwitchValue = property!.titleDeeds
        centralHeatingSwitchValue = property!.centralHeating
        solarWaterHeatingSwitchValue = property!.solarWaterHeating
        storeRoomSwitchValue = property!.storeRoom
        airConditionerSwitchValue = property!.airConditioner
        furnishedSwitchValue = property!.isFurnished
        
        if property!.latitude != 0.0 && property!.longitude != 0.0 {
            locationCoordinates = CLLocationCoordinate2DMake(property!.latitude, property!.longitude)
        }
        
        updateSwitches()


    }
    
    func updateSwitches() {
        titleDeedSwitch.isOn = titleDeedSwitchValue
        centralHeatingSwitch.isOn = centralHeatingSwitchValue
        solarWaterHeatingSwitch.isOn = solarWaterHeatingSwitchValue
        storeRoomSwitch.isOn = storeRoomSwitchValue
        airConditionerSwitch.isOn = airConditionerSwitchValue
        furnishedSwitch.isOn = furnishedSwitchValue

    }
    
    func setupYearsArray() {
   
        yearArray = Array(1800...2030)
        yearArray.reverse()
    }
    
    func save() {
        
        
        
        if titleTextField.text != "" &&
            referenceCodeTextField.text != "" &&
            advertisementTypeTextField.text != "" &&
            propertyTypeTextField.text != "" &&
            priceTextField.text != "" {
            
            var newProperty: Property!
            
            if property != nil {
                // editing property
                
                newProperty = property!
                
            } else {
                
                newProperty = Property()
            }
            
            
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
            
            if let coordinate = locationCoordinates {
                newProperty.latitude = coordinate.latitude
                newProperty.longitude = coordinate.longitude
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
        
        let mapViewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        mapViewVC.delegate = self
        
        self.present(mapViewVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func actionCurrentLocationButtonTapped(_ sender: Any) {
        locationManagerStart()

    }
    
    
    @IBAction func actionCameraButtonTapped(_ sender: Any) {
        
        if property != nil {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageGalleryViewController") as! ImageGalleryViewController
            
            vc.property = property!
            
            self.present(vc, animated: true, completion: nil)
            return
        }
        
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
    
    
    @IBAction func actionBackButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    func setupPickers() {
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get the location")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .restricted:
            // parental control
            break
        case .denied:
            self.locationManager = nil
            print("Location denied")
            ProgressHUD.showError("Please enable location from the Settings")
        
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.locationCoordinates = locations.last!.coordinate
        
    }
    
    func locationManagerStart() {
        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager?.requestWhenInUseAuthorization()
        } else {
            self.locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManagerStop() {
        if self.locationManager != nil {
            self.locationManager?.stopUpdatingLocation()
        } else {
            
        }
    }
    
    
}

extension AddPropertyViewController: MapViewControllerDelegate {
    func didFinishWith(coordinate: CLLocationCoordinate2D) {
        
        self.locationCoordinates = coordinate
        print("coordinates = \(coordinate)")
    }
    
    
}

extension AddPropertyViewController: ImageGalleryViewControllerDelegate {
    func didFinishEditingImages(allImages: [UIImage]) {
        
    }
    
    
}






