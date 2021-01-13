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
    class func getUser(_ email: String?, _ password: String?) -> Observable<Bool> {
        return Observable.create { observer in
            let router = Router.user
            var parameters : [String : AnyObject]?
            if let email = email {
                parameters?["email"] = email as AnyObject
            }
            if let password = password {
                parameters?["password"] = password as AnyObject
            }
            let request = API.shared.request(router: router, parameters: parameters) { (response) in
                switch response {
                case .Success(let json):
                    if let jsonResponse = json?.dictionary {
                        let jsonArray = jsonResponse["records"]
                        if let jsonData = jsonArray?.array {
                            for user in jsonData {
                                if user["email"].stringValue == email {
                                    print("PASSWORD \(user["password"].stringValue)")
                                    observer.onNext(true)
                                    observer.onCompleted()
                                    return
                                } else {
                                observer.onNext(false)
                                observer.onCompleted()
                                }
                            }
                            }
                        }
                case .Failure(let error):
                    print(error)
                    observer.onNext(false)
                    observer.onCompleted()
                }
            }
            let cancel = Disposables.create() {
            request.cancel()
            }
            
            return cancel
        }
    }
    
//    class func changeLoginStatus(_ id : Int) -> Observable<Bool> {
//        Observable.create { observer in
//            let router = Router.getUser
//        }
//    }
}
