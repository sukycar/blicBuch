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
    
    private var baseURL: String {
        //return Environment.configuration(.baseURL)
        return "https://blitzbuch.club/api/api.php/records/"
    }
    
    var path: String {
        
        switch self {
        case .books:
            return "Books"
        case .user:
            return "User"//user/all?
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .books:
            return .get
        case .user:
            return .get
        }
    }
    
    
    
    func fullUrl() -> URL{
        return URL(string: self.baseURL + self.path)!
    }
}
