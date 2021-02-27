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
    class func getUser(email: String?, password: String?) -> Observable<Bool> {
        return Observable.create { observer in
            let router = Router.user
            var parameters = [String : AnyObject]()
            if let emailAddress = email {
                parameters["email"] = emailAddress as AnyObject
            }
            if let enteredPassword = password {
                parameters["password"] = enteredPassword as AnyObject
            }
            let request = API.shared.request(router: router, parameters: parameters) { (response) in
                switch response {
                case .Success(let json):
                    if let jsonResponse = json?.dictionary {
                        let jsonArray = jsonResponse["records"]
                        DataManager.shared.work { (context) in
                            if let jsonData = jsonArray?.array {
                                for user in jsonData {
                                    let newEmail = user["email"].string
                                    if let passedEmail = email {
                                        let newPassword = user["password"].string
                                        if let passedPassword = password {
                                            if newEmail == passedEmail {
                                                if newPassword == passedPassword {
                                                    let id = user["id"].int32Value
                                                    let regularBooks = user["numberOfRegularBooks"].intValue
                                                    let vipBooks = user["numberOfVipBooks"].intValue
                                                    let name = user["name"].stringValue
                                                    let cartItems = user["cartItems"].stringValue
                                                    var cartItemsInUserDefaults = [String]()
                                                    
                                                    _ = blicBuchUserDefaults.set(.id, value: id)
                                                    _ = blicBuchUserDefaults.set(.numberOfRegularBooks, value: regularBooks)
                                                    _ = blicBuchUserDefaults.set(.numberOfVipBooks, value: vipBooks)
                                                    _ = blicBuchUserDefaults.set(.username, value: name)
                                                    _ = blicBuchUserDefaults.set(.logedIn, value: true)
                                                    if cartItems != "" {
                                                        let cartItem = cartItems.components(separatedBy: ",")
                                                        cartItem.forEach { (item) in
                                                            cartItemsInUserDefaults.append(item)
                                                        }
                                                        _ = blicBuchUserDefaults.set(.cartItems, value: cartItemsInUserDefaults)
                                                    }
                                                    observer.onNext(true)
                                                    observer.onCompleted()
                                                    return
                                                }
                                            }
                                        }
                                    } else {
                                        observer.onNext(false)
                                        observer.onCompleted()
                                    }
                                }
                                observer.onNext(false)
                                observer.onCompleted()
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
                    _ = blicBuchUserDefaults.set(.numberOfVipBooks, value: numberOfVipBooks)
                    _ = blicBuchUserDefaults.set(.numberOfRegularBooks, value: numberOfRegularBooks)
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
    class func changeNumberOfBooks(vip: Bool, userId: Int32, numberOfBooks: Int) -> Observable<Bool> {
        Observable.create { observer in
            var parameters = [String : AnyObject]()
            let router = Router.changeNumberOfAvailableBooks(for: userId)
            let jsonParameter = vip == true ? "numberOfVipBooks" : "numberOfRegularBooks"
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
