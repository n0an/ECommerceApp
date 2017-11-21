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
        
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProduct) {
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else { return }
        
        let payment = SKPayment(product: productToPurchase)
        
        paymentQueue.add(payment)
        
    }
    
    func restorePurchase() {
        paymentQueue.restoreCompletedTransactions()
        
    }
    
}

extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        self.products = response.products
    }
    
    
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
//            print("Transaction - status: \(transaction.transactionState.status()) , transaction.payment.productIdentifier: \(transaction.payment.productIdentifier)")
            
            print("Transaction - status: \(transaction.transactionState.status() , transaction.payment.productIdentifier)")

            
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                queue.finishTransaction(transaction)
            default:
                queue.finishTransaction(transaction)
            }
        }
        
        
    }
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred:
            return "deffered"
        case .failed:
            return "failed"
        case .purchasing:
            return "purchasing"
        case .purchased:
            return "purchased"
        case .restored:
            return "restored"
        }
    }
}








