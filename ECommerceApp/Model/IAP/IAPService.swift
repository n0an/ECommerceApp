//
//  IAPService.swift
//  ECommerceApp
//
//  Created by nag on 21/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation
import  StoreKit

class IAPService: NSObject {
    
    private override init() {}
    
    static let shared = IAPService()
    
    var products: [SKProduct] = []
    let paymentQueue = SKPaymentQueue.default()
    
    func getProducts() {
        let productIds: Set = [IAPProduct.coins.rawValue, IAPProduct.agentSubscription.rawValue]
        
        let request = SKProductsRequest(productIdentifiers: productIds)
        
        request.delegate = self
        request.start()
        
        
    }
    
}

extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("response \(response.products)")
        
        for product in response.products {
            print("Product = " + product.productIdentifier)
        }
    }
    
    
}









