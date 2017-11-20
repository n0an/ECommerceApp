//
//  PushNotifications.swift
//  ECommerceApp
//
//  Created by nag on 20/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation
import OneSignal


func sendPushNotification(toProperty: Property, message: String) {
    
    getUserToPush(userId: toProperty.ownerId!) { (usersPushIds) in
        
        let currentUser = FUser.currentUser()
   
        OneSignal.postNotification(["contents": ["en": "\(currentUser!.firstName) \n \(message)"], "ios_badgeType": "Increase", "ios_badgeCount": "1",  "include_player_ids": usersPushIds])
        
        ProgressHUD.showSuccess("Notification sent!")
                
    }
    
}

func getUserToPush(userId: String, result: @escaping (_ pushIds: [String]) -> Void) {
    
    firebase.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userId).observeSingleEvent(of: .value) { (snapshot) in
        
        if snapshot.exists() {
            
            let childSnap = snapshot.childSnapshot(forPath: userId)
            guard let userDict = childSnap.value as? [String: Any] else { return }
            
            let fUser = FUser(dict: userDict)
            
            result([fUser.pushID!])
            
        } else {
            ProgressHUD.showError("Couldn't send notification")
        }
    }
    
    
    
    
}
