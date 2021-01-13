//
//  Router.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 5/9/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import Alamofire

enum Router {
    
    case books
    case user
    case book(for: Int)
    case updateBook(for: Int32)
    case checkLockStatus(for: Int32)
    
    private var baseURL: String {
        //return Environment.configuration(.baseURL)
        return "https://www.blitzbuch.club/api/api.php/records/"
    }
    
    var path: String {
        
        switch self {
        case .books:
            return "Books"
        case .book(let id):
            return "Books/\(id)"
        case .user:
            return "User"//user/all?
        case .updateBook(let id):
            return "Books/\(id)"
        case .checkLockStatus(let id):
            return "Books/\(id)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .books:
            return .get
        case .user:
            return .get
        case .book:
            return .delete
        case .updateBook:
            return .put
        case .checkLockStatus:
            return .get
        }
    }
    
    
    
    func fullUrl() -> URL{
        return URL(string: self.baseURL + self.path)!
    }
}
