//
//  RegisterViewController.swift
//  ECommerceApp
//
//  Created by nag on 14/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var requestButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var phoneNumber: String!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        try! Auth.auth().signOut()
//        print("Signed out")
        
    }
    
    // MARK: - HELPER METHODS
    
    func goToApp() {
        let mainViewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! UITabBarController
        
        self.present(mainViewVC, animated: true, completion: nil)
    }

    // MARK: - ACTIONS
    @IBAction func actionRequestButtonTapped(_ sender: Any) {
        guard let phone = phoneNumberTextField.text else { return }
        
        if phone != "" {
            
            self.phoneNumber = phone
           
            
            PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
                guard error == nil else {
                    print("Error verifyPhoneNumber \(error!.localizedDescription)")
                    return
                }

                self.phoneNumberTextField.text = ""
                self.phoneNumberTextField.placeholder = self.phoneNumber
                self.phoneNumberTextField.isEnabled = false

                self.codeTextField.isHidden = false

                self.requestButton.setTitle("Register", for: [])

                UserDefaults.standard.set(verificationID, forKey: kVERIFICATIONCODE)
                UserDefaults.standard.synchronize()

            }
        }
        
        if codeTextField.text != "" {
            FUser.registerUserWith(phoneNumber: self.phoneNumber, verificationCode: self.codeTextField.text!, completion: { (error, shouldLogin) in
                
                guard error == nil else {
                    print("Error registerUserWithPhoneNumber \(error!.localizedDescription)")
                    return
                }
                
                if shouldLogin {
                    // go to mainVC
                    print("go to main view")
                    self.goToApp()
                    
                } else {
                    // go to finish register view
                    print("go to finish register view")
                    self.performSegue(withIdentifier: "registerToFinishRegisterSeg", sender: nil)
                    
                }
                
            })
        }
        
    }
    
    @IBAction func actionRegisterButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
                let password = passwordTextField.text,
                let firstName = nameTextField.text,
                let lastName = lastNameTextField.text else { return }
        
        if email != "" && password != "" && firstName != "" && lastName != "" {
            
            FUser.registerUserWith(email: email, password: password, firstName: firstName, lastName: lastName) { (error) in
                
                guard error == nil else {
                    print("Error registering user with email \(error!.localizedDescription)")
                    return
                }
                
                self.goToApp()
                
            }
            
        } else if email != "" && password != "" {
            
            FUser.loginUserWith(email: email, password: password, withBlock: { (error) in
                
                guard error == nil else {
                    print("Error login user with email \(error!.localizedDescription)")
                    return
                }
                
                self.goToApp()

                
            })
            
        }
        
        
        
        
    }
    
    @IBAction func actionCloseButtonTapped(_ sender: Any) {
        
        goToApp()
        
    }
    
    
    
}
