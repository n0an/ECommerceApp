//
//  FBNotification.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 19/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation


class FBNotification {
    
    var notificatonId: String
    let createdAt: Date
    
    let propertyReference: String
    let propertyObjectId: String
    
    var buyerFullName: String
    var buyerId: String
    
    var agentId: String
    var phoneNumber: String
    var additionalPhoneNumber: String
    
    // MARK: - Initializers
    init(buyerId: String, agentId: String, createdAt: Date, phoneNumber: String, additionalPhoneNumber: String = "", buyerFullName: String, propertyReference: String, propertyObjectId: String) {
        
        self.notificatonId = ""
        self.createdAt = createdAt
        
        self.propertyReference = propertyReference
        self.propertyObjectId = propertyObjectId
        
        self.buyerFullName = buyerFullName
        self.buyerId = buyerId
        
        self.agentId = agentId
        self.phoneNumber = phoneNumber
        self.additionalPhoneNumber = additionalPhoneNumber
    }
    
    init(dict: [String: Any]) {
        
        self.notificatonId = dict[kNOTIFICATIONID] as! String
        
        if let created = dict[kCREATEDAT] as? String {
            self.createdAt = dateFormatter().date(from: created)!
        } else {
            self.createdAt = Date()
        }
        
        self.propertyReference = dict[kPROPERTYREFERENCEID] as? String ?? ""
        
        self.propertyObjectId = dict[kPROPERTYOBJECTID] as? String ?? ""
        self.buyerFullName = dict[kBUYERFULLNAME] as? String ?? ""
        self.buyerId = dict[kBUYERID] as? String ?? ""
        self.agentId = dict[kAGENTID] as? String ?? ""
        self.phoneNumber = dict[kPHONE] as? String ?? ""
        self.additionalPhoneNumber = dict[kADDPHONE] as? String ?? ""
    }
}

// MARK: - SAVE NOTIFICATIONS

func saveNotificationInBackground(fbNotification: FBNotification) {
    
    let newNotifRef = notifRef.childByAutoId()
    
    fbNotification.notificatonId = newNotifRef.key
    
    newNotifRef.setValue(notificationDictionaryFrom(fbNotification: fbNotification))
}

func saveNotificationInBackground(fbNotification: FBNotification, completion: @escaping (_ error: Error?) -> ()) {
    
    let newNotifRef = notifRef.childByAutoId()
    
    fbNotification.notificatonId = newNotifRef.key
    
    newNotifRef.setValue(notificationDictionaryFrom(fbNotification: fbNotification)) { (error, firRef) in
        completion(error)
    }
}

func fetchAgentNotification(agentId: String, completion: @escaping (_ allNotifications: [FBNotification]?) -> Void) {
    
    var allNotifications: [FBNotification] = []
    var counter = 0
    
    notifHadler = notifRef.queryOrdered(byChild: kAGENTID).queryEqual(toValue: agentId).observe(.value, with: { (snapshot) in
        
        if snapshot.exists() {
            
//            let allFbn = ((snapshot.value as! NSDictionary).allValues as NSArray)
            
            let allFbnValue = snapshot.value as! [String: Any]
            let arr = allFbnValue.values
            
            for fbNot in arr {
                let fbNotification = FBNotification(dict: fbNot as! [String: Any])
                allNotifications.append(fbNotification)
                counter += 1
            }
            
            // check if done and return
            if counter == arr.count {
                notifRef.removeObserver(withHandle: notifHadler)
                completion(allNotifications)
            }
            
            
        } else {
            notifRef.removeObserver(withHandle: notifHadler)
            completion(allNotifications)
        }
        
        
    })
    
}

func deleteNotification(fbNotification: FBNotification) {
    notifRef.child(fbNotification.notificatonId).removeValue()
}

func notificationDictionaryFrom(fbNotification: FBNotification) -> [String: Any] {
    
    let createdAt = dateFormatter().string(from: fbNotification.createdAt)
   
    let dict = [
        
        kNOTIFICATIONID:        fbNotification.notificatonId,
        kCREATEDAT:             createdAt,
        kPROPERTYREFERENCEID:   fbNotification.propertyReference,
        kPROPERTYOBJECTID:      fbNotification.propertyObjectId,
        kBUYERFULLNAME:         fbNotification.buyerFullName,
        kBUYERID:               fbNotification.buyerId,
        kAGENTID:               fbNotification.agentId,
        kPHONE:                 fbNotification.phoneNumber,
        kADDPHONE:              fbNotification.additionalPhoneNumber
        
        ] as [String : Any]
    
    return dict
    
    
}







