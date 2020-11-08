//
//  BooksService.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 5/7/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import Foundation
import RxSwift
import CoreData
import SwiftyJSON
import Alamofire

class BooksService {
    class func deleteBook(bookId: Int32) -> Observable<Bool> {
        return Observable.create { observer in
            let router = Router.book(for: bookId)
            let request = API.shared.request(router: router, parameters: nil) { (response) in
                switch response {
                case .Success(let json):
                    print(json)
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
    class func getAll() -> Observable<Bool>{
        return Observable.create { observer in
            let router = Router.books
            let request = API.shared.request(router: router, parameters: nil, completion: { (response) in
                switch response {
                case .Success(let json):
                    
                    if let newJson = json?.dictionary {
                        let jsonArray1 = newJson["records"]
                    
                    if let jsonArray = jsonArray1?.array {
                        DataManager.shared.work { (context) in
                            let fetchForCount: NSFetchRequest<Books> = Books.fetchRequest()
//                            let count = try! context.count(for: fetchForCount)
//                            if jsonArray.count == count {
//                                observer.onNext(true)
//                                observer.onCompleted()
//                                return
//                            }
                            context.delete(fetchRequest: fetchForCount, predicate: NSPredicate(format: "id >= 0"))
                            context.refreshAllObjects()
                            for (index, json) in jsonArray.enumerated() {
                                print(json)
                                let item:Books? = context.update(predicate: NSPredicate(format: "id = %d", json["id"].int32Value))
                                item?.updateForList(with: json)
                            }
                            
                            try! context.save()
                            try! context.parent?.save()
                            observer.onNext(true)
                            observer.onCompleted()
                        }
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                } else {
                        observer.onNext(false)
                        observer.onCompleted()
                        return
                    }
                case .Failure(let apiError):
                    observer.onError(apiError)
                    print("Failure")
                }
            })
            let cancel = Disposables.create {
                request.cancel()
            }
            return cancel
        }
    }
}
