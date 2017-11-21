//
//  FinishRegistrationViewController.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 21/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import ImagePicker

class FinishRegistrationViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    
    var avatarImage: UIImage?
    var avatar = ""
    var company = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true
    }
    
    // MARK: - HELPER METHODS
    func register() {
        let user = FUser.currentUser()!
        
        user.firstName = nameTextField.text!
        user.lastName = lastNameTextField.text!
        user.avatar = avatar
        user.companyName = company
        
        let updateUserDict = [kFIRSTNAME: user.firstName,
                              kLASTNAME: user.lastName,
                              kFULLNAME: user.fullName,
                              kAVATAR: user.avatar,
                              kCOMPANY: user.companyName]
        
        updateCurrentUser(withValues: updateUserDict) { (success) in
            
            ProgressHUD.dismiss()
            
            guard success else {
                print("Error updating user")
                return
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "userDidLoginNotification"), object: nil, userInfo: ["userId" : FUser.currentId()])
            
            self.goToApp()
            
        }
    }
    
    func goToApp() {
        let mainViewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! UITabBarController
        
        self.present(mainViewVC, animated: true, completion: nil)
    }
    
    @IBAction func actionDismissButtonTapped(_ sender: Any) {
        // delete user in Auth
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionCameraButtonTapped(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func actionFinishRegistrationTapped(_ sender: Any) {
        
        guard nameTextField.text != "" && lastNameTextField.text != "" else {
            ProgressHUD.showError("Please input credentials")
            return
        }
        
        ProgressHUD.show("Registering")
        
        if let avatarImage = avatarImage {
            let image = UIImageJPEGRepresentation(avatarImage, 0.6)
            
            avatar = image!.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        }
        
        if companyTextField.text != "" {
            company = companyTextField.text!
        }
        
        register()
        
    }
    
}

extension FinishRegistrationViewController: ImagePickerDelegate {
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
