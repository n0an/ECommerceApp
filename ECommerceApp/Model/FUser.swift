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
    
    var phoneNumber: String
    var additionalPhoneNumber = ""
    
    var isAgent = false
    
    var favoriteProperties = [String]()
    
    init(objectID: String, pushID: String?, createdAt: Date, updatedAt: Date, firstName: String, lastName: String, avatar: String = "", phoneNumber: String = "") {
        self.objectID = objectID
        self.pushID = pushID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.coins = 10
        self.firstName = firstName
        self.lastName = lastName
        
        self.avatar = avatar
        
        self.phoneNumber = phoneNumber
        
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
            
            // save to user defaults
            saveUserLocally(fUser: fUser)
           
            // save to firebase
            saveUserToFirebase(fUser: fUser)
        
            
            completion(error)
            
        }
        
        
    }
    
    class func registerUserWith(phoneNumber: String, verificationCode: String, completion: @escaping (_ error: Error?, _ shouldLogin: Bool) -> Void) {
        
        let verificationID = UserDefaults.standard.value(forKey: kVERIFICATIONCODE) as! String
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credentials) { (firUser, error) in
            
            if error != nil {
                completion(error, false)
                return
            }
            
            // check if user is logged in else register
            
            fetchUserWith(userId: (firUser?.uid)!, completion: { (user) in
                
                if user != nil && user!.firstName != "" {
                    // we have a user, login now
                    saveUserLocally(fUser: user!)
                    completion(error, true)
                    
                } else {
                    
                    // we have no user, register new one
                    let fUser = FUser(objectID: (firUser?.uid)!, pushID: "", createdAt: Date(), updatedAt: Date(), firstName: "", lastName: "", phoneNumber: firUser!.phoneNumber!)
                    
                    saveUserLocally(fUser: fUser)
                    saveUserToFirebase(fUser: fUser)
                    
                    completion(error, false)
                    
                }
            })
            
        }
        
    }
    
    // MARK: - Login
    
    class func loginUserWith(email: String, password: String, withBlock block: @escaping (_ error: Error?)->Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (firUser, error) in
            
            if let error = error {
                block(error)
            } else {
                
                fetchUserWith(userId: (firUser?.uid)!, completion: { (fUser) in
                    
                    saveUserLocally(fUser: fUser!)
                    
                    block(nil)
                })
                
                
            }
            
        }
        
    }
    
    // MARK: -IAP methods
    func purchase(productId: String) {
        
        switch productId {
        case IAPProduct.coins.rawValue:
            print("User has purchased coins, saving")
            let newCoins = FUser.currentUser()!.coins + 10
            updateCurrentUser(withValues: [kCOINS: newCoins], withBlock: { (success) in
                
            })
            
        case IAPProduct.agentSubscription.rawValue:
            print("User has purchased agent subscription, saving")
            updateCurrentUser(withValues: [kISAGENT: true], withBlock: { (success) in
                
            })

        default:
            break
        }
        
    }
    
    
    // MARK: - LogOut
    
    class func logoutCurrentUser(withBlock block: @escaping (_ success: Bool) -> Void) {
        UserDefaults.standard.removeObject(forKey: "OneSignalId")
        removeOneSignalId { (success) in
            if success {
                UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
                UserDefaults.standard.synchronize()
                
                do {
                    try Auth.auth().signOut()
                    block(true)
                } catch let error {
                    print(error.localizedDescription)
                    block(false)
                }
            }
        }
        
    }
    
    class func deleteUser(completion: @escaping (_ error: Error?) -> Void) {
        let user = Auth.auth().currentUser
        
        user?.delete(completion: { (error) in
            completion(error)
        })
    }
    
    
    
}

func saveUserToFirebase(fUser: FUser) {
    let ref = firebase.child(kUSER).child(fUser.objectID)
    ref.setValue(userDictionaryFrom(user: fUser))
}

func saveUserLocally(fUser: FUser) {
    UserDefaults.standard.set(userDictionaryFrom(user: fUser), forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}

// MARK: - HELPER FUNCTIONS

func fetchUserWith(userId: String, completion: @escaping (_ user: FUser?) -> Void) {
    
    firebase.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userId).observeSingleEvent(of: .value) { (snapshot) in
        
        if snapshot.exists() {
            
            let childSnap = snapshot.childSnapshot(forPath: userId)
            guard let userDict = childSnap.value as? [String: Any] else { return }
            
            
//            guard let userDict = snapshot.value as? [String: Any] else { return }
//
//            let userDictValues = userDict.values
//
//            let first = userDictValues.first as! [String: Any]
            
            
            let user = FUser(dict: userDict)
            
            completion(user)
            
        } else {
            completion(nil)
        }
        
        
    }
    
    
}

func userDictionaryFrom(user: FUser) -> [String: Any] {
    
    let createdAt = dateFormatter().string(from: user.createdAt)
    let updatedAt = dateFormatter().string(from: user.updatedAt)
    
    let dict = [
        kOBJECTID:  user.objectID,
        kCREATEDAT: createdAt,
        kUPDATEDAT: updatedAt,
        kCOMPANY:   user.companyName,
        kPUSHID:    user.pushID!,
        kFIRSTNAME: user.firstName,
        kLASTNAME:  user.lastName,
        kFULLNAME:  user.fullName,
        kAVATAR:    user.avatar,
        kPHONE:     user.phoneNumber,
        kADDPHONE:  user.additionalPhoneNumber,
        kISAGENT:   user.isAgent,
        kCOINS:     user.coins,
        kFAVORIT:   user.favoriteProperties
        ] as [String : Any]
    
    return dict
    
}

func updateCurrentUser(withValues values: [String: Any], withBlock: @escaping (_ success: Bool) -> Void) {
    
    if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil {
        
        let currentUser = FUser.currentUser()!
        
        var userObjectDict = userDictionaryFrom(user: currentUser)
        
        for key in values.keys {
            userObjectDict[key] = values[key]
        }
        
        let ref = firebase.child(kUSER).child(currentUser.objectID)
        
        ref.updateChildValues(values, withCompletionBlock: { (error, ref) in
            
            if error != nil {
                withBlock(false)
                return
            }
            
            UserDefaults.standard.setValue(userObjectDict, forKey: kCURRENTUSER)
            
            UserDefaults.standard.synchronize()
            
            withBlock(true)
            
        })
        
    }
    
}

func isUserLoggedIn(viewController: UIViewController) -> Bool {
    
    if FUser.currentUser() != nil {
        return true
    } else {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        
        viewController.present(vc, animated: true, completion: nil)
        return false
    }
    
}

// MARK: OneSignal

func updateOneSignalId() {
    
    if FUser.currentUser() != nil {
        
        if let pushId = UserDefaults.standard.string(forKey: "OneSignalId") {
            
            setOneSignalId(pushId: pushId)
            
        } else {
            
            removeOneSignalId(completion: { (success) in
                print(success)
            })
            
        }
        
    }
    
}


func setOneSignalId(pushId: String) {
    updateCurrentUserOneSignalId(newId: pushId) { (success) in
        
    }
    
}

func removeOneSignalId(completion: @escaping (Bool)->Void) {
    updateCurrentUserOneSignalId(newId: "") { (success) in
        completion(success)
    }

}

func updateCurrentUserOneSignalId(newId: String, withBlock block: @escaping (_ success: Bool) -> Void) {
    updateCurrentUser(withValues: [kPUSHID: newId, kUPDATEDAT: dateFormatter().string(from: Date())]) { (success) in
        
        
        if success {
            print("One signal Id was updated - \(success)")

            block(success)
        }
        
    }
}











