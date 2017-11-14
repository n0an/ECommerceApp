//
//  RegisterViewController.swift
//  ECommerceApp
//
//  Created by nag on 14/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var requestButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    // MARK: - ACTIONS
    @IBAction func actionRequestButtonTapped(_ sender: Any) {
    }
    
    @IBAction func actionRegisterButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
                let password = passwordTextField.text,
                let firstName = nameTextField.text,
                let lastName = lastNameTextField.text else { return }
        
        guard email != "" && password != "" && firstName != "" && lastName != "" else { return }
        
        FUser.registerUserWith(email: email, password: password, firstName: firstName, lastName: lastName) { (error) in
            
            guard error == nil else {
                print("Error registering user with email \(error!.localizedDescription)")
                return
            }
            
            let mainViewVC = UIStoryboard(name: "MainVC", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! UITabBarController
            
            self.present(mainViewVC, animated: true, completion: nil)


        }
        
        
    }
    
    @IBAction func actionCloseButtonTapped(_ sender: Any) {
        
        let mainViewVC = UIStoryboard(name: "MainVC", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! UITabBarController
        
        self.present(mainViewVC, animated: true, completion: nil)
        
        
        
    }
    
    
    
}
