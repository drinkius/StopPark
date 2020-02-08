//
//  IAPManager.swift
//  StopPark
//
//  Created by Arman Turalin on 1/27/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import StoreKit

enum IAPKey: Int, CaseIterable {
    case lowPrice = 0, preMiddlePrice, middlePrice, highPrice
    
    var identifier: String {
        switch self {
        case .lowPrice: return "tech.stoppark.donateshowlowprice"
        case .preMiddlePrice: return "tech.stoppark.donateshoppremiddleprice"
        case .middlePrice: return "tech.stoppark.donateshopmiddleprice"
        case .highPrice: return "tech.stoppark.donateshophighprice"
        }
    }
}

class IAPManager: NSObject {
    static let shared = IAPManager()
    
    private override init() {
        super.init()
    }
    
    fileprivate var productIds: [String] {
        return IAPKey.allCases.map { $0.identifier }
    }
    fileprivate var products: [SKProduct] = []
    
    fileprivate var productId = ""
    fileprivate var productRequest = SKProductsRequest()
    fileprivate var fetchProductCompletion: ((Result) -> Void)?
    
    fileprivate var productToPurchase: SKProduct?
    fileprivate var purchaseProductCompletion: ((IAPManagerError, SKProduct?, SKPaymentTransaction?) -> Void)?
    
    var isLogEnabled: Bool = true
    
    func canMakePurchase() -> Bool { return SKPaymentQueue.canMakePayments() }
    
    func purchase(on key: IAPKey, completion: @escaping (IAPManagerError, SKProduct?, SKPaymentTransaction?) -> Void) {
        guard let product = products.filter( { $0.productIdentifier == key.identifier }).first else {
            completion(IAPManagerError.noProductIDsFound, nil, nil)
            return
        }
        
        purchase(product: product, completion: completion)
    }
    
    private func purchase(product: SKProduct, completion: @escaping (IAPManagerError, SKProduct?, SKPaymentTransaction?) -> Void) {
        self.purchaseProductCompletion = completion
        self.productToPurchase = product
        
        if canMakePurchase() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            productId = product.productIdentifier
        } else {
            completion(IAPManagerError.productRequestFailed, nil, nil)
        }
    }
    
    func restorePurchase() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func fetchAvailableProduct(completion: @escaping (Result) -> Void) {
        self.fetchProductCompletion = completion
        
        productRequest = SKProductsRequest(productIdentifiers: Set(productIds))
        productRequest.delegate = self
        productRequest.start()
    }
}

// MARK: - SKProductsRequestDelegate, SKPaymentTransactionObserver
extension IAPManager: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if response.products.isEmpty {
            fetchProductCompletion?(.failure("Не смогли получить данные, попробуйте позже."))
            return
        }
        
        products = response.products
        fetchProductCompletion?(.success(nil))
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if let completion = self.purchaseProductCompletion {
            completion(IAPManagerError.restored, nil, nil)
        }
    }
        
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction: AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let completion = self.purchaseProductCompletion {
                        completion(IAPManagerError.purchased, self.productToPurchase, trans)
                    }
                    break
                    
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let completion = self.purchaseProductCompletion {
                        completion(IAPManagerError.cancelled, nil, nil)
                    }
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                default: break
                }
            }
        }
    }
}


// MARK: - Support
extension IAPManager {
    enum IAPManagerError {
        case noProductIDsFound
        case noProductsFound
        case paymentWasCancelled
        case productRequestFailed
        case restored
        case purchased
        case cancelled
        case error
        
        var errorDescription: String {
            switch self {
            case .noProductIDsFound: return "No In-App Purchase product identifiers were found."
            case .noProductsFound: return "No In-App Purchases were found."
            case .paymentWasCancelled: return "Unable to fetch available In-App Purchase products at the moment."
            case .productRequestFailed: return "In-App Purchase process was cancelled."
            case .restored: return "You've successfully restored your purchase!"
            case .purchased: return "You've successfully bought this purchase!"
            case .cancelled: return "Пользователь отменил покупку."
            case .error: return "Неопознанная ошибка, попробуйте позже."
            }
        }
    }
}
