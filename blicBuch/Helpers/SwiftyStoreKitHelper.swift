//
//  SwiftyStoreKitHelper.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 10.10.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import RxSwift
import Combine
import SwiftUI
import SwiftKeychainWrapper
import StoreKit

class SwiftyStoreKitHelper {
    
    var disposeBag = DisposeBag()
    let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "ec5fbc7a5abb4f548f09ba21514326c4")
    
    func completeTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    let userModelService = BlitzBuchUserDefaults(userDefaults: UserDefaults.standard)
                    let userId = userModelService.getUser()?.uid
                    UsersService.getUser(uid: userId).subscribe { finished in
                        switch purchase.productId {
                        case BlitzBuchCart.TransportExpences.transport.rawValue:
                            NotificationCenter.default.post(name: NSNotification.Name(Constants.orderItemsNotification), object: nil, userInfo: nil)
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                            
                        case SubscriptionTypeBundleId.starter.rawValue:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                            SwiftyStoreKit.verifyReceipt(using: self.appleValidator) { result in
                                switch result {
                                case .success:
                                    UsersService.changeNumberOfBooks(userId: userModelService.getUser()?.id ?? 0, numberOfBooks: 1).subscribe { finished in
                                        print("Number of books changed to 1")
                                        UsersService.updateMembershipStatus(userId: userModelService.getUser()?.id ?? 0, active: true).subscribe { updated in
                                            print("User updated")
                                            KeychainWrapper.standard.set(true, forKey: purchase.productId)
                                        } onError: { error in
                                            print(error.localizedDescription)
                                        } onCompleted: {
                                        }.disposed(by: self.disposeBag)
                                    } onError: { error in
                                        print(error.localizedDescription)
                                    } onCompleted: {
                                    }.disposed(by: self.disposeBag)
                                case .error(let error):
                                    debugPrint(error.localizedDescription)
                                }
                            }
                            
                        case SubscriptionTypeBundleId.regular.rawValue:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                            SwiftyStoreKit.verifyReceipt(using: self.appleValidator) { result in
                                switch result {
                                case .success:
                                    UsersService.changeNumberOfBooks(userId: userModelService.getUser()?.id ?? 0, numberOfBooks: 3).subscribe { finished in
                                        print("Number of books changed to 3.")
                                        UsersService.updateMembershipStatus(userId: userModelService.getUser()?.id ?? 0, active: true).subscribe { updated in
                                            print("User updated")
                                            KeychainWrapper.standard.set(true, forKey: purchase.productId)
                                        } onError: { error in
                                            print(error.localizedDescription)
                                        } onCompleted: {
                                        }.disposed(by: self.disposeBag)
                                    } onError: { error in
                                        print(error.localizedDescription)
                                    } onCompleted: {
                                    }.disposed(by: self.disposeBag)
                                case .error(let error):
                                    debugPrint(error.localizedDescription)
                                }
                            }
                        case SubscriptionTypeBundleId.vip.rawValue:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                            SwiftyStoreKit.verifyReceipt(using: self.appleValidator) { result in
                                switch result {
                                case .success:
                                    UsersService.changeNumberOfBooks(userId: userModelService.getUser()?.id ?? 0, numberOfBooks: 4).subscribe { finished in
                                        UsersService.changeNumberOfVipBooks(userId: userModelService.getUser()?.id ?? 0, numberOfBooks: 1).subscribe { finished in
                                            print("Number of books changed to 4. VIP books changed to 1.")
                                            UsersService.updateMembershipStatus(userId: userModelService.getUser()?.id ?? 0, active: true).subscribe { updated in
                                                print("User updated")
                                                KeychainWrapper.standard.set(true, forKey: purchase.productId)
                                            } onError: { error in
                                                print(error.localizedDescription)
                                            } onCompleted: {
                                            }.disposed(by: self.disposeBag)
                                        } onError: { error in
                                            print(error.localizedDescription)
                                        } onCompleted: {
                                        }.disposed(by: self.disposeBag)
                                    } onError: { error in
                                        print(error.localizedDescription)
                                    } onCompleted: {
                                    }.disposed(by: self.disposeBag)
                                case .error(let error):
                                    debugPrint(error.localizedDescription)
                                }
                            }
                        default:
                            break
                        }
                    } onError: { error in
                        print(error.localizedDescription)
                    } onCompleted: {
                    }.disposed(by: self.disposeBag)
                case .failed, .purchasing:
                    break // do nothing
                case .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
        self.disposeBag = DisposeBag()
    }
}
