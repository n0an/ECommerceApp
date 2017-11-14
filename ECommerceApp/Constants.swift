//
//  Constants.swift
//  ECommerceApp
//
//  Created by nag on 14/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

var backendless = Backendless.sharedInstance()
var firebase = Database.database().reference()


var notifHadler: UInt = 0
let notifRef = firebase.child(KFBNOTIFICATIONS)

let propertyTypes = ["Select", "Appartment", "House", "Villa", "Land", "Flat"]
let advertismentTypes = ["Select", "Sale", "Rent", "Exchange"]

//IDS and Keys
public let kONESIGNALAPPID = "d94352cf-55bb-4110-9baa-336c982b054f"
public let kFILEREFERENCE = "gs://myapp-1f8b0.appspot.com"


//FUser
public let kOBJECTID = "objectId"
public let kUSER = "User"
public let kCREATEDAT = "createdAt"
public let kUPDATEDAT = "updatedAt"
public let kCOMPANY = "company"
public let kPHONE = "phone"
public let kADDPHONE = "addPhone"

public let kCOINS = "coins"
public let kPUSHID = "pushId"
public let kFIRSTNAME = "firstname"
public let kLASTNAME = "lastname"
public let kFULLNAME = "fullname"
public let kAVATAR = "avatar"
public let kCURRENTUSER = "currentUser"
public let kISONLINE = "isOnline"
public let kVERIFICATIONCODE = "firebase_verification"
public let kISAGENT = "isAgent"
public let kFAVORIT = "favoritProperties"



//Property
public let kMAXIMAGENUMBER = 10
public let kRECENTPROPERTYLIMIT = 20

//FBNotification
public let KFBNOTIFICATIONS = "Notifications"
public let kNOTIFICATIONID = "notificationId"
public let kPROPERTYREFERENCEID = "referenceId"
public let kPROPERTYOBJECTID = "propertyObjectId"
public let kBUYERFULLNAME = "buyerFullName"
public let kBUYERID = "buyerId"
public let kAGENTID = "agentId"




//push
public let kDEVICEID = "deviceId"


//other
public let kTEMPFAVORITID = "tempID"
