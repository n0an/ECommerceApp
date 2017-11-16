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
    
    // MARK: - SAVE METHODS
    
    func saveProperty() {
        let dataStore = backendless!.data.of(Property().ofClass())
        dataStore!.save(self)
    }
    
    func saveProperty(completion: @escaping (_ value: String) -> Void) {
        let dataStore = backendless!.data.of(Property().ofClass())
        dataStore!.save(self, response: { (result) in
            completion("Success")
        }) { (fault) in
            completion(fault!.message)
        }
    }
    
    // MARK: - DELETE METHODS

    func deleteProperty(property: Property) {
        let dataStore = backendless!.data.of(Property().ofClass())
        dataStore!.remove(property)
    }
    
    func deleteProperty(property: Property, completion: @escaping (_ value: String) -> Void) {
        let dataStore = backendless!.data.of(Property().ofClass())
        dataStore!.remove(property, response: { (result) in
            completion("Success")
        }) { (fault) in
            completion(fault!.message)
        }
    }
    
    // MARK: - SEARCH METHODS
    
    class func fetchRecentProperties(limitNumber: Int, completion: @escaping (_ properties: [Property]?) -> Void) {
        
        let queryBuilder = DataQueryBuilder()
        queryBuilder!.setSortBy(["inTopUntil DESC"])
        queryBuilder!.setPageSize(Int32(limitNumber))
        queryBuilder!.setOffset(0)
        
        let dataStore = backendless!.data.of(Property().ofClass())
        dataStore!.find(queryBuilder, response: { (backendLessProperties) in
            completion(backendLessProperties as? [Property])
        }) { (fault) in
            print("Error, couldn't get recent properties \(fault!.message)")
            completion(nil)
        }
        
    }
    
    class func fetchAllProperties(completion: @escaping (_ properties: [Property]?) -> Void) {
        
        let dataStore = backendless!.data.of(Property().ofClass())
        dataStore!.find({ (allProperties) in
            completion(allProperties as? [Property])
        }) { (fault) in
            print("Error, couldn't get recent properties \(fault!.message)")
            completion(nil)
        }
    }
    
    class func fetchPropertiesWith(whereClause: String, completion: @escaping (_ properties: [Property]?) -> Void) {
        
        let queryBuilder = DataQueryBuilder()
        queryBuilder!.setWhereClause(whereClause)
        queryBuilder!.setSortBy(["inTopUntil DESC"])
        
        let dataStore = backendless!.data.of(Property().ofClass())
        
        dataStore!.find(queryBuilder, response: { (allProperties) in
            completion(allProperties as? [Property])

        }) { (fault) in
            print("Error, couldn't get recent properties \(fault!.message)")
            completion(nil)
        }
        
    }
}















