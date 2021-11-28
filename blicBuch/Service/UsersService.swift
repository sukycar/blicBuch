//
//  UsersService.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 13.1.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import RxSwift
import CoreData
import SwiftyJSON
import Alamofire

class UsersService {
    class func getUser(uid: String?) -> Observable<Bool> {
        return Observable.create { observer in
            let router = Router.user
            let userDefaults = BlitzBuchUserDefaults(userDefaults: UserDefaults.standard)
            let userModel = UserCodable()
            var parameters = [String : AnyObject]()
            if let userId = uid {
                parameters["uid"] = userId as AnyObject
            }
            let request = API.shared.request(router: router, parameters: parameters) { (response) in
                switch response {
                case .Success(let json):
                    if let jsonResponse = json?.dictionary {
                        let jsonArray = jsonResponse["records"]
                        DataManager.shared.work { (context) in
                            if let jsonData = jsonArray?.array {
                                for user in jsonData {
                                    let userId = user["uid"].string
                                    if let passedUid = uid {
                                        if userId == passedUid {
                                            print("Korisnik \(user)")
                                            let id = user["id"].int32Value
                                            let regularBooks = user["numberOfRegularBooks"].intValue
                                            let vipBooks = user["numberOfVipBooks"].intValue
                                            let name = user["name"].stringValue
                                            let cartItems = user["cartItems"].stringValue
                                            let orderedItems = user["orderedItems"].stringValue
                                            let payment = user["payment"].boolValue
                                            let expireDate = user["expireDate"].intValue
                                            var cartItemsInUserDefaults = [String]()
                                            
                                            userModel.id = id
                                            userModel.uid = userId
                                            userModel.numberOfRegularBooks = regularBooks
                                            userModel.numberOfVipBooks = vipBooks
                                            userModel.name = name
                                            userModel.cartItems = cartItems
                                            userModel.orderedItems = orderedItems
                                            userModel.payment = payment
                                            userModel.expireDate = expireDate
                                            if cartItems != "" {
                                                let cartItem = cartItems.components(separatedBy: ",")
                                                cartItem.forEach { (item) in
                                                    cartItemsInUserDefaults.append(item)
                                                }
                                                userModel.cartItems = cartItems
                                            }
                                            userDefaults.saveUser(userModel)
                                            observer.onNext(true)
                                            observer.onCompleted()
                                            return
                                        }
                                    }
                                }
                                observer.onNext(false)
                                observer.onCompleted()
                                return
                            }
                        }
                    }
                case .Failure(let error):
                    observer.onError(error)
                    observer.onCompleted()
                }
            }
            let cancel = Disposables.create() {
                request.cancel()
            }
            return cancel
        }
    }
    
    //MARK: - lock book when it is in the cart
    
    class func registerUser(user: BlitzBuchRegister.UserModel) -> Observable<Bool> {
        var parameters = [String: AnyObject]()
        do {
            parameters = try user.toDictionary()
        } catch {
            print("Error in decoding")
        }
        
        return Observable.create { observer in
            let router = Router.register
            let request = API.shared.request(router: router, parameters: parameters) { (response) in
                switch response {
                case .Success:
                    observer.onNext(true)
                    observer.onCompleted()
                case .Failure(let error):
                    observer.onError(error)
                }
            }
            let cancel = Disposables.create {
                request.cancel()
            }
            return cancel
        }
    }
    
    /// get books in cart for user from SQL on server
    class func getCartBooks(userId: Int32) -> Observable<[Int32]> {
        return Observable.create { observer in
            let router = Router.getCartItems(for: userId)
            let request = API.shared.request(router: router, parameters: nil) { (response) in
                switch response {
                case .Success(let json):
                    guard let json = json else {return}
                    let cartItems = json["cartItems"].stringValue
                    var int32Array = [Int32]()
                    let items = cartItems.components(separatedBy: ",")
                    items.forEach { (string) in
                        if let newItem = Int32(string) {
                            int32Array.append(newItem)
                        }
                    }
                    observer.onNext(int32Array)
                    observer.onCompleted()
                case .Failure(let error):
                    observer.onError(error)
                }
            }
            let cancel = Disposables.create {
                request.cancel()
            }
            return cancel
        }
    }
    
    /// update user uid after firebase registration
    class func updateUserUID(userId: Int32, firebaseUID: String) -> Observable<Bool> {
        return Observable.create { observer in
            let router = Router.updateUserId(for: firebaseUID)
            var parameters = [String: AnyObject]()
            parameters["uid"] = firebaseUID as AnyObject
            let request = API.shared.request(router: router, parameters: parameters) { (response) in
                switch response {
                case .Success:
                    observer.onNext(true)
                    observer.onCompleted()
                case .Failure(let error):
                    observer.onError(error)
                }
            }
            let cancel = Disposables.create {
                request.cancel()
            }
            return cancel
        }
    }
    
    /// update membership status when apple payment is completed
    class func updateMembershipStatus(userId: Int32, active: Bool) -> Observable<Bool> {
        return Observable.create { observer in
            let membershipStatus = active
            let router = Router.updateMembershipStatus(for: userId)
            var parameters = [String: AnyObject]()
            parameters["payment"] = membershipStatus as AnyObject
            parameters["expireDate"] = Int(Date().timeIntervalSince1970 + 2592000) as AnyObject
            let request = API.shared.request(router: router, parameters: parameters) { (response) in
                switch response {
                case .Success:
                    observer.onNext(true)
                    observer.onCompleted()
                case .Failure(let error):
                    observer.onError(error)
                }
            }
            let cancel = Disposables.create {
                request.cancel()
            }
            return cancel
        }
    }
    
    /// Send ordered items to server to inform user that he should
    /// prepare products for shipping
    class func updateOrderedItems(userId: Int32, orderedItems: String, handler: @escaping (Bool?, ApiError?) -> Void) {
        let router = Router.updateOrderedItems(for: userId)
        var parameters = [String: AnyObject]()
        parameters["orderedItems"] = orderedItems as AnyObject
        let request = API.shared.request(router: router, parameters: parameters) { response in
            switch response {
            case .Success:
                handler(true, nil)
            case .Failure(let apiError):
                handler(nil, apiError)
            }
        }
        request.resume()
    }
    
    /// add book ids to user cart on server
    class func updateCartBooks(userId: Int32, bookIDs: [String]) -> Observable<Bool> {
        return Observable.create { observer in
            let cartBooks = BlitzBuchUserDefaults(userDefaults: UserDefaults.standard).getUser()?.cartItems
            let router = Router.updateCart(for: userId)
            var parameters = [String: AnyObject]()
            parameters["cartItems"] = cartBooks as AnyObject
            let request = API.shared.request(router: router, parameters: parameters) { (response) in
                switch response {
                case .Success:
                    observer.onNext(true)
                    observer.onCompleted()
                case .Failure(let error):
                    observer.onError(error)
                }
            }
            let cancel = Disposables.create {
                request.cancel()
            }
            return cancel
        }
    }
    
    /// check number of available books on server
    class func checkForAvailableBooks(_ id: Int32) -> Observable<(Int, Int)> {
        Observable.create { observer in
            let id = id
            let userDefaults = BlitzBuchUserDefaults(userDefaults: UserDefaults.standard)
            let router = Router.checkAvailableBooks(for: id)
            let request = API.shared.request(router: router, parameters: nil) { (response) in
                switch response {
                case .Success(let json):
                    guard let json = json else {return}
                    let numberOfVipBooks = json["numberOfVipBooks"].intValue
                    let numberOfRegularBooks = json["numberOfRegularBooks"].intValue
                    if let user = userDefaults.getUser() {
                        user.numberOfVipBooks = numberOfVipBooks
                        user.numberOfRegularBooks = numberOfRegularBooks
                        userDefaults.saveUser(user)
                    }
                    observer.onNext((numberOfVipBooks, numberOfRegularBooks))
                    observer.onCompleted()
                case .Failure(let error):
                    observer.onError(error)
                }
            }
            let cancel = Disposables.create(){
                request.cancel()
            }
            
            return cancel
        }
        
    }
    
    /// update number of books on API depending of number of added books to cart
    class func changeNumberOfBooks( userId: Int32, numberOfBooks: Int) -> Observable<Bool> {
        Observable.create { observer in
            var parameters = [String : AnyObject]()
            let router = Router.changeNumberOfAvailableBooks(for: userId)
            parameters["numberOfRegularBooks"] = numberOfBooks as AnyObject
            let request = API.shared.request(router: router, parameters: parameters) { (response) in
                switch response {
                case .Success(_):
                    observer.onNext(true)
                    observer.onCompleted()
                case .Failure(let error):
                    observer.onError(error)
                    observer.onCompleted()
                }
            }
            let cancel = Disposables.create(){
                request.cancel()
            }
            return cancel
        }
        
    }
    
    class func changeNumberOfVipBooks(userId: Int32, numberOfBooks: Int) -> Observable<Bool> {
        Observable.create { observer in
            var parameters = [String : AnyObject]()
            let router = Router.changeNumberOfAvailableBooks(for: userId)
            parameters["numberOfVipBooks"] = numberOfBooks as AnyObject
            let request = API.shared.request(router: router, parameters: parameters) { (response) in
                switch response {
                case .Success(_):
                    observer.onNext(true)
                    observer.onCompleted()
                case .Failure(let error):
                    observer.onError(error)
                    observer.onCompleted()
                }
            }
            let cancel = Disposables.create(){
                request.cancel()
            }
            return cancel
        }
        
    }
    
}

enum LoginStatus: Int {
    case logedIn = 1
    case notLogedIn = 0
}
