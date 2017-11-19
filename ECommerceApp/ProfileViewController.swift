//
//  ProfileViewController.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 19/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import ImagePicker
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var additionalNumberTextField: UITextField!
    
    var avatarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true

    }
    
    func saveChanges() {
        
        guard nameTextField.text! != "" && lastNameTextField.text != "" else {
            ProgressHUD.showError("Name and Last name can not be empty")
            return
        }
        
        var addPhone = ""
        
        if additionalNumberTextField.text != "" {
            addPhone = additionalNumberTextField.text!
        }
        
        ProgressHUD.show("Saving...")
        
        var values = [kFIRSTNAME: nameTextField.text!,
                      kLASTNAME: lastNameTextField.text!,
                      kADDPHONE: addPhone]
        
        if avatarImage != nil {
            
            // !!!IMPORTANT!!!
            // Encode image to string
            
            let image = UIImageJPEGRepresentation(avatarImage!, 0.5)
            
            let avatarString = image!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            values.updateValue(avatarString, forKey: kAVATAR)
        }
        
        updateCurrentUser(withValues: values) { (success) in
            
            if !success {
                ProgressHUD.showError("Couldn't update user")
            } else {
                ProgressHUD.showSuccess("Saved!")
            }
            
        }
        
        
    }
    
    func updateUI() {
        let mobileImageView = UIImageView(image: UIImage(named: "Mobile"))
        mobileImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        mobileImageView.contentMode = .scaleAspectFit
        
        let mobileImageView1 = UIImageView(image: UIImage(named: "Mobile"))
        mobileImageView1.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        mobileImageView1.contentMode = .scaleAspectFit
        
        let contactImageView = UIImageView(image: UIImage(named: "ContactLogo"))
        contactImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        contactImageView.contentMode = .scaleAspectFit
        
        let contactImageView1 = UIImageView(image: UIImage(named: "ContactLogo"))
        contactImageView1.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        contactImageView1.contentMode = .scaleAspectFit
        
        // !!!IMPORTANT!!!
        // Add small image to textField
        
        nameTextField.leftViewMode = .always
        nameTextField.leftView = contactImageView
        nameTextField.addSubview(contactImageView)
        
        lastNameTextField.leftViewMode = .always
        lastNameTextField.leftView = contactImageView1
        lastNameTextField.addSubview(contactImageView1)
        
        mobileNumberTextField.leftViewMode = .always
        mobileNumberTextField.leftView = mobileImageView
        mobileNumberTextField.addSubview(mobileImageView)
        
        additionalNumberTextField.leftViewMode = .always
        additionalNumberTextField.leftView = mobileImageView1
        additionalNumberTextField.addSubview(mobileImageView1)
        
        let user = FUser.currentUser()!
        
        nameTextField.text = user.firstName
        lastNameTextField.text = user.lastName
        mobileNumberTextField.text = user.phoneNumber
        additionalNumberTextField.text = user.additionalPhoneNumber
        coinsLabel.text = "\(user.coins)"
        
        
        if user.avatar != "" {
            let image = imageFromData(pictureData: user.avatar)
            
            self.avatarImageView.image = image
        }
        
    }
    
    func imageFromData(pictureData: String) -> UIImage? {
        
        // !!!IMPORTANT!!!
        // Decode image from string
        
        // TODO: - add to my extensions
        
        var image: UIImage?
        
        let decodedData = NSData(base64Encoded: pictureData, options: NSData.Base64DecodingOptions(rawValue: 0))
        
        image = UIImage(data: decodedData! as Data)
        
        return image
    }
    
    @IBAction func actionBackButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func actionMenuButtonTapped(_ sender: Any) {
        
        let user = FUser.currentUser()!
        
        let optionMenu = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
        let accountTypeString = user.isAgent ? "You are Agent" : "Become an Agent"
        
        let actionAccountType = UIAlertAction(title: accountTypeString, style: .default) { (action) in
            
        }
        
        let actionRestorePurchase = UIAlertAction(title: "Restore purchase", style: .default) { (action) in
            
            
        }
        
        let actionBuyCoins = UIAlertAction(title: "Buy Coins", style: .default) { (action) in
            
        }
        
        let actionSaveChanges = UIAlertAction(title: "Save changes", style: .default) { (action) in
            
            self.saveChanges()
            
        }
        
        let actionLogout = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            
            FUser.logoutCurrentUser(withBlock: { (success) in
                
                if success {
                    let recentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
                    self.present(recentVC, animated: true, completion: nil)
                    
                    
                }
                
            })
            
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        optionMenu.addAction(actionSaveChanges)
        optionMenu.addAction(actionBuyCoins)
        optionMenu.addAction(actionAccountType)
        optionMenu.addAction(actionRestorePurchase)
        optionMenu.addAction(actionLogout)
        optionMenu.addAction(actionCancel)
        
        self.present(optionMenu, animated: true, completion: nil)

        
    }
    
    
    
    
    @IBAction func actionBuyCoinsButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func actionChangeAvatarButtonTapped(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
}

extension ProfileViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        avatarImage = images.first
        
        avatarImageView.image = avatarImage
        
        self.dismiss(animated: true, completion: nil)

    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)

    }
    
    
}


