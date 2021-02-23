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
    case setUserLoginStatus(for: Int32)
    case changeNumberOfAvailableBooks(for: Int32)
    case checkAvailableBooks(for: Int32)
    case updateCart(for: Int32)
    case getCartItems(for: Int32)
    
    private var baseURL: String {
        return Environment.configuration(.baseURL)
//        return "https://www.blitzbuch.club/api/api.php/records/"
    }
    
    var path: String {
        
        switch self {
        case .books:
            return "\(Environment.configuration(.booksPath))"
        case .book(let id):
            return "\(Environment.configuration(.booksPath))/\(id)"
        case .user:
            return "\(Environment.configuration(.usersPath))/"
        case .updateBook(let id):
            return "\(Environment.configuration(.booksPath))/\(id)"
        case .checkLockStatus(let id):
            return "\(Environment.configuration(.booksPath))/\(id)"
        case .setUserLoginStatus(let id):
            return "\(Environment.configuration(.usersPath))/\(id)"
        case .changeNumberOfAvailableBooks(let id):
            return "\(Environment.configuration(.usersPath))/\(id)"
        case .checkAvailableBooks(let id):
            return "\(Environment.configuration(.usersPath))/\(id)"
        case .updateCart(let id):
            return "\(Environment.configuration(.usersPath))/\(id)"
        case .getCartItems(let id):
            return "\(Environment.configuration(.usersPath))/\(id)"
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
        case .setUserLoginStatus:
            return .put
        case .changeNumberOfAvailableBooks:
            return .put
        case .checkAvailableBooks:
            return .get
        case .updateCart:
            return .put
        case .getCartItems:
            return .get
        }
    }
    
    
    
    func fullUrl() -> URL{
        return URL(string: self.baseURL + self.path)!
    }
}
