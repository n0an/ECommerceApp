//
//  AppDelegate.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 13/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase
import OneSignal


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let BACKENDLESS_APP_ID = "595DEAA1-3065-B102-FFC0-4C109C343C00"
        let BACKENDLESS_API_KEY = "26F1248E-7E79-5523-FFAE-1912DE23B200"
        
        FirebaseApp.configure()
        
        backendless!.initApp(BACKENDLESS_APP_ID, apiKey: BACKENDLESS_API_KEY)
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: kONESIGNALAPPID, handleNotificationReceived: nil, handleNotificationAction: nil, settings: nil)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if user != nil {
                if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil {
                    
                    let userId = FUser.currentId()
                    
                    UserDefaults.standard.set(userId, forKey: "userId")
                    UserDefaults.standard.synchronize()
                    
                    self.onUserDidLogin(userId: userId)
                    
//                    DispatchQueue.main.async {
//                        NotificationCenter.default.post(name: NSNotification.Name("UserDidLoginNotification"), object: nil, userInfo: ["userId": FUser.currentId()])
//                    }
                }
            }
            
        }
        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name("UserDidLoginNotification"), object: nil, queue: nil) { (notification) in
//
//            let userId = notification.userInfo!["userId"] as! String
//
//            UserDefaults.standard.set(userId, forKey: "userId")
//            UserDefaults.standard.synchronize()
//
//            self.onUserDidLogin(userId: userId)
//
//        }
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: [.badge, .alert, .sound], completionHandler: { (granted, error) in
                
            })
            
            application.registerForRemoteNotifications()
            
        }
        
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            
            return
        }
        
        // this is not firebase notification
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Failed to register for user notifications")
        
    }
    
    
    
    func onUserDidLogin(userId: String) {
        // start OneSignal
        
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        
        let userID = status.subscriptionStatus.userId
        let pushToken = status.subscriptionStatus.pushToken
        
        if let userID = userID, pushToken != nil {
            UserDefaults.standard.set(userID, forKey: "OneSignalId")
        } else {
            UserDefaults.standard.removeObject(forKey: "OneSignalId")
        }
        
        // save to user object
        updateOneSignalId()
        
        
    }
    
//    func startOneSignal() {
//        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
//
//        let userID = status.subscriptionStatus.userId
//        let pushToken = status.subscriptionStatus.pushToken
//
//        if let userID = userID, pushToken != nil {
//            UserDefaults.standard.set(userID, forKey: "OneSignalId")
//        } else {
//            UserDefaults.standard.removeObject(forKey: "OneSignalId")
//        }
//
//        // save to user object
//        updateOneSignalId()
//    }
    
    
    
    
}



















