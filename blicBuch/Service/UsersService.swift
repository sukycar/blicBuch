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
                                            let id = user["id"].int32Value
                                            let regularBooks = user["numberOfRegularBooks"].intValue
                                            let vipBooks = user["numberOfVipBooks"].intValue
                                            let name = user["name"].stringValue
                                            let cartItems = user["cartItems"].stringValue
                                            var cartItemsInUserDefaults = [String]()
                                            
                                            _ = blitzBuchUserDefaults.set(.id, value: id)
                                            _ = blitzBuchUserDefaults.set(.numberOfRegularBooks, value: regularBooks)
                                            _ = blitzBuchUserDefaults.set(.numberOfVipBooks, value: vipBooks)
                                            _ = blitzBuchUserDefaults.set(.username, value: name)
                                            _ = blitzBuchUserDefaults.set(.logedIn, value: true)
                                            if cartItems != "" {
                                                let cartItem = cartItems.components(separatedBy: ",")
                                                cartItem.forEach { (item) in
                                                    cartItemsInUserDefaults.append(item)
                                                }
                                                _ = blitzBuchUserDefaults.set(.cartItems, value: cartItemsInUserDefaults)
                                            }
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
                        int32Array.append(Int32(string) ?? 0)
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
    
    /// add book ids to user cart on server
    class func updateCartBooks(userId: Int32, bookIDs: [String]) -> Observable<Bool> {
        return Observable.create { observer in
            let router = Router.updateCart(for: userId)
            let enumeratedIDs = bookIDs.enumerated()
            var booksString = String()
            enumeratedIDs.forEach { (index, bookId) in
                if index == 0 {
                    booksString.append(bookId)
                } else {
                    booksString.append(",\(bookId)")
                }
            }
            if bookIDs.count == 0 {
                booksString = ""
            }
            
            var parameters = [String: AnyObject]()
            parameters["cartItems"] = booksString as AnyObject
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
            let router = Router.checkAvailableBooks(for: id)
            let request = API.shared.request(router: router, parameters: nil) { (response) in
                switch response {
                case .Success(let json):
                    guard let json = json else {return}
                    let numberOfVipBooks = json["numberOfVipBooks"].intValue
                    let numberOfRegularBooks = json["numberOfRegularBooks"].intValue
                    _ = blitzBuchUserDefaults.set(.numberOfVipBooks, value: numberOfVipBooks)
                    _ = blitzBuchUserDefaults.set(.numberOfRegularBooks, value: numberOfRegularBooks)
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
            let jsonParameter = "numberOfRegularBooks"
            parameters[jsonParameter] = numberOfBooks as AnyObject
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
            let jsonParameter = "numberOfVipBooks"
            parameters[jsonParameter] = numberOfBooks as AnyObject
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
