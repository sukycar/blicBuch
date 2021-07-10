//
//  InAppPurchaseAlertViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 3.1.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import StoreKit

class InAppPurchaseAlertViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var freeUserRegisterButton: AlertButton!
    @IBOutlet weak var regularUserRegisterButton: AlertButton!
    @IBOutlet weak var vipUserRegisterButton: AlertButton!
    
    var alertType: AlertType = .orderBooks
    var products = [SKProduct]()
    var subscriptions = [SKProduct]()
    var cartItems = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        fetchProducts()
        styleViews()
        SKPaymentQueue.default().add(self)
    }
    
    func styleViews(){
        holderView.layer.cornerRadius = CornerRadius.medium
        holderView.clipsToBounds = true
        titleLabel?.text = alertType.title
        bodyLabel?.text = alertType.bodyText
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == mainView {
            dismiss(animated: true, completion: nil)
        }//for dismiss of alert controller when clicked outside alert window
    }
    
    func configureButtons(){
        switch alertType {
        case .orderBooks:
            vipUserRegisterButton.isHidden = true
            freeUserRegisterButton.type = .ok
            freeUserRegisterButton.rx.tap.subscribe(onNext: {[weak self] in
                let payment = SKPayment(product: self?.products.first ?? SKProduct())
                SKPaymentQueue.default().add(payment)
            }).disposed(by: freeUserRegisterButton.disposeBag)
            regularUserRegisterButton.type = .cancel
            regularUserRegisterButton.rx.tap.subscribe(onNext: {[weak self] in
                self?.dismiss(animated: true, completion: nil)
                
            }).disposed(by: regularUserRegisterButton.disposeBag)
        case .subscribe:
            vipUserRegisterButton.isHidden = false
            freeUserRegisterButton.type = .free
            regularUserRegisterButton.type = .regular
            vipUserRegisterButton.type = .vip
        }
    }
    

    
}

extension InAppPurchaseAlertViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            switch transaction.transactionState {
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased")
                SKPaymentQueue.default().finishTransaction(transaction)
                presentingViewController?.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paidTransport"), object: nil)
            case .failed:
                print("failed")
            case .restored:
                print("restored")
            case .deferred:
                print("deferred")
            @unknown default:
                print("default")
            }
        }
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        switch alertType {
        case .orderBooks:
            self.products = response.products
        case .subscribe:
            self.subscriptions = response.products
        }
    }
    
    private func fetchProducts(){
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue
        })))
        request.delegate = self
        request.start()
    }
    
    private func fetchSubscriptions(){
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue
        })))
        request.delegate = self
        request.start()
    }

    
}







