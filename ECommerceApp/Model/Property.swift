//
//  Property.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 16/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation

@objcMembers

class Property: NSObject {
    
    var objectId: String?
    var referenceCode: String?
    var ownerId: String?
    var title: String?
    var numberOfRooms = 0
    var numberOfBathrooms = 0
    var size = 0.0
    var balconySize = 0.0
    var parking = 0
    var floor = 0
    var address: String?
    var city: String?
    var country: String?
    var propertyDescription: String?
    var latitude = 0.0
    var longitude = 0.0
    var advertisementType: String?
    var availableFrom: String?
    var imageLinks: String?
    var buildYear: String?
    var price = 0
    var properyType: String?
    var titleDeeds = false
    var centralHeating = false
    var solarWaterHeating = false
    var airConditioner = false
    var storeRoom = false
    var isFurnished = false
    var isSold = false
    var inTopUntil: Date?
    
    
}
