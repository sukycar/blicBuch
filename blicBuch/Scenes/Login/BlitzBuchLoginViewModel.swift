//
//  BlitzBuchLoginViewModel.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 17.7.21..
//  Copyright (c) 2021 Vladimir Sukanica. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Firebase
import RxSwift
import KeychainAccess
import StoreKit
import SwiftKeychainWrapper

protocol BlitzBuchLoginViewModelProtocol {
    var models: Dynamic<[SKProduct]> { get set }
    var loggedIn: Dynamic<Bool> { get set }
    var newSubscription: Dynamic<String> { get set }
    
    func fetchProducts()
    func restorePurchases()
    func validateData(email: String, password: String)
    func navigateToHome()
}

class BlitzBuchLoginViewModel: BaseViewModel, BlitzBuchLoginViewModelProtocol, SKProductsRequestDelegate {
    
    
    // MARK: - BlitzBuchLoginViewModelProtocol Vars & Lets
    
    var models: Dynamic<[SKProduct]> = Dynamic([SKProduct]())
    var loggedIn = Dynamic<Bool>(false)
    var newSubscription: Dynamic<String> = Dynamic("")
    
    // MARK: - Vars & Lets
    
    var productIdentifiers = Set(SubscriptionTypeBundleId.allCases.compactMap({$0.rawValue}))
    var purchasedSubscriptions = Set<String>()
    let keychainServices: KeychainServices
    var disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(keychainServices: KeychainServices) {
        self.keychainServices = keychainServices
        self.purchasedSubscriptions = Set(productIdentifiers.filter {
            KeychainWrapper.standard.bool(forKey: $0) ?? false
        })
        super.init()
    }
    
    // MARK: - BlitzBuchLoginViewModelProtocol methods
    
    func validateData(email: String, password: String) {
        if email.isEmpty {
            self.error.value = .validation(AlertMessage(title: "Email error".localized(), body: "Email can't be empty".localized()))
        } else if !email.isValidEmail {
            self.error.value = .validation(AlertMessage(title: "Email error".localized(), body: "Email address is not valid".localized()))
        } else if password.isEmpty {
            self.error.value = .validation(AlertMessage(title: "Password error".localized(), body: "Password can't be empty".localized()))
        } else if password.count < 6 {
            self.error.value = .validation(AlertMessage(title: "Password error".localized(), body: "Password must contain 6 or more characters".localized()))
        } else {
            let requestObject = BlitzBuchLogin.LoginRequestObject(email: email, password: password)
            self.loginFirebaseUser(data: requestObject)
        }
    }
    
    func navigateToHome() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setWindow(vc: vc, animated: false)
    }
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(SubscriptionTypeBundleId.allCases.compactMap({$0.rawValue})))
        request.delegate = self
        request.start()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Fetch error:\(error.localizedDescription)")
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - SKProductDelegate Methods
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.models.value = response.products
    }
    
    // MARK: - Private methods
    
    private func loginFirebaseUser(data: BlitzBuchLogin.LoginRequestObject?) {
        if let data = data {
            self.isLoaderHidden.value = false
            Auth.auth().signIn(withEmail: data.email ?? "", password: data.password ?? "") { result, error in
                if let error = error {
                    self.isLoaderHidden.value = true
                    if let errorCode = AuthErrorCode(rawValue: error._code) {
                        if let errorString = errorCode.returnLocalizedString() {
                            self.error.value = .general(AlertMessage(title: "Error", body: errorString))
                        }
                    }
                } else {
                    if let uid = result?.user.uid {
                        self.loginUser(userId: uid)
                        self.keychainServices.saveToken(token: uid)
                    } else {
                        self.error.value = .general(AlertMessage(title: "Error", body: "Etwas ist schief gelaufen"))
                    }
                }
            }
        }
    }
    
    private func loginUser(userId: String?) {
        UsersService.getUser(uid: userId).subscribe { [weak self] (logedIn) in
            self?.isLoaderHidden.value = true
            if logedIn == false {
                DispatchQueue.main.async {
                    self?.error.value = .general(AlertMessage(title: "Error", body: "Login failed, please try again".localized()))
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logedIn"), object: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if let subscriptionPaid = self?.purchasedSubscriptions.count ?? 0 > 0 ? true : false {
                            if subscriptionPaid != true {
                                self?.newSubscription.value = "Your membership has expired or you have not fully completed the registration process.".localized()
                            } else {
                                self?.loggedIn.value = true
                            }
                        }
                    }
                }
            }
        } onError: { (error) in
            self.error.value = .general(AlertMessage(title: "Error", body: error.localizedDescription))
        } onCompleted: {
        }.disposed(by: self.disposeBag)
    }
    
}
