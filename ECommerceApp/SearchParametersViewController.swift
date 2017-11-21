//
//  SearchParametersViewController.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 20/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

protocol SearchParametersViewControllerDelegate: class {
    func didFinishSettingParameters(whereClause: String)
}

class SearchParametersViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var advertisementTypeTextField: UITextField!
    @IBOutlet weak var propertyTypeTextField: UITextField!
    @IBOutlet weak var bedroomsTextField: UITextField!
    @IBOutlet weak var bathroomsTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var buildYearTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var propertySizeTextField: UITextField!
    
    var furnishedSwitchValue = false
    var centralHeatingSwitchValue = false
    var airConditionerSwitchValue = false
    var solarWaterSwitchValue = false
    var storeRoomSwitchValue = false
    
    var propertyTypePicker = UIPickerView()
    var advertisementTypePicker = UIPickerView()
    var bedroomPicker = UIPickerView()
    var bathroomPicker = UIPickerView()
    var pricePicker = UIPickerView()
    var yearPicker = UIPickerView()
    
    var yearArray: [String] = []
    let minPriceArray = ["Minimum", "Any", "10000", "20000", "30000", "40000", "50000", "60000", "70000", "80000", "90000", "100000", "200000", "500000"]
    
    let maxPriceArray = ["Maximum", "Any", "10000", "20000", "30000", "40000", "50000", "60000", "70000", "80000", "90000", "100000", "200000", "500000"]
    
    var bathroomsArray = ["Any", "1+", "2+", "3+"]
    var bedroomsArray = ["Any", "1+", "2+", "3+", "4+", "5+"]
    
    var minPrice = ""
    var maxPrice = ""
    
    var whereClause = ""
    
    var activeTextField: UITextField?

    weak var delegate: SearchParametersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: mainView.frame.height + 30)
        
        setupYearsArray()
        
        setupPickers()
        
    }
    
    func setupYearsArray() {
        
        let years = Array(1800...2030)
        
        yearArray = years.map { "\($0)" }
        yearArray.append("Any")
        
        yearArray.reverse()
    }
    
    func setupPickers() {
        
        propertyTypePicker.delegate = self
        advertisementTypePicker.delegate = self
        bedroomPicker.delegate = self
        bathroomPicker.delegate = self
        pricePicker.delegate = self
        yearPicker.delegate = self
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.toolbarDonePressed))
        
        toolbar.setItems([flexibleBarButtonItem, doneButton], animated: true)
        
        // !!!IMPORTANT!!!
        // DatePicker and UIPicker for textFields
        
        advertisementTypeTextField.inputAccessoryView = toolbar
        advertisementTypeTextField.inputView = advertisementTypePicker

        propertyTypeTextField.inputAccessoryView = toolbar
        propertyTypeTextField.inputView = propertyTypePicker

        
        bedroomsTextField.inputAccessoryView = toolbar
        bedroomsTextField.inputView = bedroomPicker

        bathroomsTextField.inputAccessoryView = toolbar
        bathroomsTextField.inputView = bathroomPicker

        priceTextField.inputAccessoryView = toolbar
        priceTextField.inputView = pricePicker

        buildYearTextField.inputAccessoryView = toolbar
        buildYearTextField.inputView = yearPicker

        
    }
    
    
    // MARK: - ACTIOINS
    @objc func toolbarDonePressed() {
        self.view.endEditing(true)
        
        guard advertisementTypeTextField.text != "" && propertyTypeTextField.text != "" else {
            ProgressHUD.showError("Missing required text fields")
            print("invalid search parameters")
            return
        }
        
        whereClause = "advertisementType = '\(advertisementTypeTextField.text!)' and properyType = '\(propertyTypeTextField.text!)'"
        
        if bedroomsTextField.text != "" && bedroomsTextField.text != "Any" {
            let bedroomNumber = bedroomsTextField.text!.split(separator: "+").first
            
            whereClause += " and numberOfRooms >= '\(bedroomNumber!)'"
        }
        
        if bathroomsTextField.text != "" && bathroomsTextField.text != "Any" {
            let bathroomNumber = bathroomsTextField.text!.split(separator: "+").first
            
            whereClause += " and numberOfBathrooms >= '\(bathroomNumber!)'"
        }
        
        if buildYearTextField.text != "" && buildYearTextField.text != "Any" {
            
            whereClause += " and buildYear = '\(buildYearTextField.text!)'"
        }
        
        if priceTextField.text != "" && priceTextField.text != "Any - Any" && priceTextField.text != "Any -" && priceTextField.text != "- Any" {
            
            if let minPriceVal = Int(minPrice) {
                whereClause += " and price >= \(minPriceVal)"
            }
            
            if let maxPriceVal = Int(maxPrice) {
                whereClause += " and price <= \(maxPriceVal)"
            }
        }
        
        if cityTextField.text != "" {
            whereClause += " and city = '\(cityTextField.text!)'"
        }
        
        if countryTextField.text != "" {
            whereClause += " and country = '\(countryTextField.text!)'"
        }
        
        if propertySizeTextField.text != "" {
            whereClause += " and size >= '\(propertySizeTextField.text!)'"
        }
        
        if furnishedSwitchValue {
            whereClause += " and isFurnished = true"
        }
        
        if centralHeatingSwitchValue {
            whereClause += " and centralHeating = true"
        }
        
        if airConditionerSwitchValue {
            whereClause += " and airConditioner = true"
        }
        
        if solarWaterSwitchValue {
            whereClause += " and solarWaterHeating = true"
        }
        
        if storeRoomSwitchValue {
            whereClause += " and storeRoom = true"
        }
        
        delegate?.didFinishSettingParameters(whereClause: whereClause)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func actionBackButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionDoneButtonTapped(_ sender: Any) {
        
    }
    
    
    
    @IBAction func actionCentralHeatingSwitchValueChanged(_ sender: Any) {
        centralHeatingSwitchValue = !centralHeatingSwitchValue
    }
    
    
    @IBAction func actionSolarWaterSwitchValueChanged(_ sender: Any) {
        solarWaterSwitchValue = !solarWaterSwitchValue
    }
    
    
    @IBAction func actionStoreRoomSwitchValueChanged(_ sender: Any) {
        storeRoomSwitchValue = !storeRoomSwitchValue
    }
    
    @IBAction func actionAirConditionerSwitchValueChanged(_ sender: Any) {
        airConditionerSwitchValue = !airConditionerSwitchValue
    }
    
    
    @IBAction func actionFurnishedSwitchValueChanged(_ sender: Any) {
        furnishedSwitchValue = !furnishedSwitchValue
    }
    
}


extension SearchParametersViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pricePicker {
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
        case propertyTypePicker:
            return propertyTypes.count
        case advertisementTypePicker:
            return advertismentTypes.count
        case bedroomPicker:
            return bedroomsArray.count
        case bathroomPicker:
            return bathroomsArray.count
        case pricePicker:
            return minPriceArray.count
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
        case bedroomPicker:
            return bedroomsArray[row]
        case bathroomPicker:
            return bathroomsArray[row]
        case pricePicker:
            return component == 0 ? minPriceArray[row] : maxPriceArray[row]
        case yearPicker:
            return yearArray[row]
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
            
        case bedroomPicker:
            bedroomsTextField.text = bedroomsArray[row]
            
        case bathroomPicker:
            bathroomsTextField.text = bathroomsArray[row]
            
        case pricePicker:
            if rowValue == 0 {
                rowValue = 1
            }
            
            if component == 0 {
                
                minPrice = minPriceArray[rowValue]
                
//                let minStr = minPriceArray[rowValue]
//                var selectedAnotherRow = pricePicker.selectedRow(inComponent: 1)
//
//                if selectedAnotherRow == 0 {
//                    selectedAnotherRow = 1
//                }
//
//                let maxStr = maxPriceArray[selectedAnotherRow]
//                priceTextField.text = "\(minStr) - \(maxStr)"
                
            } else {
                
                maxPrice = maxPriceArray[rowValue]
                
//                let maxStr = maxPriceArray[rowValue]
//                var selectedAnotherRow = pricePicker.selectedRow(inComponent: 0)
//
//                if selectedAnotherRow == 0 {
//                    selectedAnotherRow = 1
//                }
//
//                let minStr = minPriceArray[selectedAnotherRow]
//                priceTextField.text = "\(minStr) - \(maxStr)"
            }
            
            priceTextField.text = minPrice + " - " + maxPrice
            
        case yearPicker:
            buildYearTextField.text = "\(yearArray[row])"
            
        default:
            break
        }
        
        
    }
    
    
}







