//
//  FUser.swift
//  ECommerceApp
//
//  Created by nag on 14/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

class FUser {
    
    let objectID: String
    var pushID: String?
    
    let createdAt: Date
    var updatedAt: Date
    
    var coins: Int
    
    var companyName = ""
    
    var firstName: String
    var lastName: String
    var fullName: String {
        return firstName + " " + lastName
    }
    
    var avatar: String
    
    var phoneNumber = ""
    var additionalPhoneNumber = ""
    
    var isAgent = false
    
    var favoriteProperties = [String]()
    
    init(objectID: String, pushID: String?, createdAt: Date, updatedAt: Date, firstName: String, lastName: String, avatar: String = "") {
        self.objectID = objectID
        self.pushID = pushID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.coins = 10
        self.firstName = firstName
        self.lastName = lastName
        
        self.avatar = avatar
        
    }
    
    init(dict: [String: Any]) {
        
        self.objectID = dict[kOBJECTID] as! String
        self.pushID = dict[kPUSHID] as! String?
        
        if let createdAtString = dict[kCREATEDAT] as? String {
            self.createdAt = dateFormatter().date(from: createdAtString)!
        } else {
            self.createdAt = Date()
        }
        
        if let updatedString = dict[kUPDATEDAT] as? String {
            self.updatedAt = dateFormatter().date(from: updatedString)!
        } else {
            self.updatedAt = Date()
        }
        
        self.coins = dict[kCOINS] as? Int ?? 0
        
        self.firstName = dict[kFIRSTNAME] as? String ?? ""
        self.lastName = dict[kLASTNAME] as? String ?? ""
        
        self.avatar = dict[kAVATAR] as? String ?? ""
        
        self.isAgent = dict[kISAGENT] as? Bool ?? false
        
        self.phoneNumber = dict[kPHONE] as? String ?? ""
        
        self.additionalPhoneNumber = dict[kADDPHONE] as? String ?? ""
        
        self.favoriteProperties = dict[kFAVORIT] as? [String] ?? []
        
    }
    
    
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> FUser? {
        if Auth.auth().currentUser != nil {
            
            if let dict = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                return FUser(dict: dict as! [String : Any])
            }
        }
        return nil
    }
    
    class func registerUserWith(email: String, password: String, firstName: String, lastName: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (firUser, error) in
            
            if error != nil {
                completion(error)
                return
            }
            
            let fUser = FUser(objectID: firUser!.uid, pushID: "", createdAt: Date(), updatedAt: Date(), firstName: firstName, lastName: lastName)
            
            UserDefaults.standard.set(fUser, forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            
            
            completion(error)
            
        }
        
        
    }
    
    
    
}














