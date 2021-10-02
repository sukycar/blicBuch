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
    
    //MARK: - Delete books after order
    
    class func deleteBook(bookId: Int) -> Observable<Bool> {
        return Observable.create { observer in
            let router = Router.book(for: bookId)
            let request = API.shared.request(router: router, parameters: nil) { (response) in
                switch response {
                case .Success:
                    let context = DataManager.shared.context
                    var book : Book?
                    let fetchRequest = Book.fetchRequest() as NSFetchRequest
                    fetchRequest.predicate = NSPredicate(format: "id = %d", bookId)
                    do{
                        book = try context?.fetch(fetchRequest).first
                        context?.delete(book ?? Book())
                        try! context?.save()
                        try! context?.parent?.save()
                    } catch {
                        print("Fetch failed")
                    }
                    
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
    

    
    //MARK: - lock book when it is in the cart
    
    class func lockBook(bookId: Int32, lockStatus: LockStatus) -> Observable<Bool> {
        return Observable.create { observer in
            let router = Router.updateBook(for: bookId)
            var parameters = [String: AnyObject]()
            parameters["locked"] = lockStatus.rawValue as AnyObject
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
    
    //MARK: - check lock status
    
    class func checkLock(bookId: Int32) -> Observable<Bool> {
        return Observable.create { observer in
            let router = Router.checkLockStatus(for: bookId)
            let request = API.shared.request(router: router, parameters: nil) { (response) in
                switch response {
                case .Success(let json):
                    guard let jsonArray = json else {return}
                    if jsonArray["locked"] == "1" {
                        observer.onNext(true)
                        observer.onCompleted()
                    } else {
                        observer.onNext(false)
                        observer.onCompleted()
                    }
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
        var booksIDs = [String]()
        var jsonFetchedBooksIDs = [String]()
        
        // Get all books for comparation between API and CoreData
        let booksFetch = Book.fetchRequest() as NSFetchRequest
        let allBooksInContext = try! DataManager.shared.context.fetch(booksFetch)
        allBooksInContext.forEach { (book) in
            booksIDs.append("\(book.id)")
        }
        
        // Create observer for response
        return Observable.create { observer in
            let router = Router.books
            let request = API.shared.request(router: router, parameters: nil, completion: { (response) in
                switch response {
                case .Success(let json):
                    if let newJson = json?.dictionary {
                        let jsonArray1 = newJson["records"]
                        
                        if let jsonArray = jsonArray1?.array {
                            jsonArray.forEach { (json) in
                                jsonFetchedBooksIDs.append(json["id"].stringValue)
                            }
                            booksIDs = booksIDs.filter({!jsonFetchedBooksIDs.contains($0)})
                            
                            // Update context
                            DataManager.shared.work { (context) in
                                let bookRequest = Book.fetchRequest() as NSFetchRequest
                                let predicate = NSPredicate(format: "ANY id in %@", booksIDs)
                                bookRequest.predicate = predicate
                                
                                // Delete objects that doesn't exist in API side
                                do {
                                    let booksOnlyFromContext = try context.fetch(bookRequest)
                                    booksOnlyFromContext.forEach { (book) in
                                        context.delete(book)
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                                context.refreshAllObjects()
                                
                                // Update every object which has changes and save it
                                for json in jsonArray {
                                    let id = json["id"].int32Value
                                    let item:Book? = context.update(predicate: NSPredicate(format: "id = %d", id))
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
                }
            })
            let cancel = Disposables.create {
                request.cancel()
            }
            return cancel
        }
    }
    
//    class func getAllCartStatuses() -> Observable<Bool>{
//        return Observable.create { observer in
//            let router = Router.books
//            let request = API.shared.request(router: router, parameters: nil, completion: { (response) in
//                switch response {
//                case .Success(let json):
//                    if let newJson = json?.dictionary {
//                        let jsonArray1 = newJson["records"]
//                        if let jsonArray = jsonArray1?.array {
//                            DataManager.shared.work { (context) in
//                                let fetchForCount: NSFetchRequest<CartBook> = CartBook.fetchRequest()
//                                context.refreshAllObjects()
//                                for (index, json) in jsonArray.enumerated() {
//                                    let item:CartBook? = context.update(predicate: NSPredicate(format: "id = %d", json["id"].int32Value))
//                                    item?.id = json["id"].int32Value
//                                }
//                                
//                                try! context.save()
//                                observer.onNext(true)
//                                observer.onCompleted()
//                            }
//                            observer.onNext(true)
//                            observer.onCompleted()
//                        }
//                    } else {
//                        observer.onNext(false)
//                        observer.onCompleted()
//                        return
//                    }
//                case .Failure(let apiError):
//                    observer.onError(apiError)
//                    print("Failure")
//                }
//            })
//            let cancel = Disposables.create {
//                request.cancel()
//            }
//            return cancel
//        }
//    }
}


