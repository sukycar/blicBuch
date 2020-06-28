//
//  Model.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 5/9/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ApiError:Error {
    case NoInternet(ErrorModel?)
    case BadRequest(ErrorModel?)
    case NotAuthorized(ErrorModel?)
    case ServerError(ErrorModel?)
    case Conflict(ErrorModel?)
    case OtherError(ErrorModel?)
    case UpdateAvailable(ErrorModel?)
    case ApiGenericError(code:Int)
}

struct ErrorModel {
    var description:String?
//    var errorDescription:String?
    init() {
        
    }
    
    init( _ json: JSON?) {
        self.description = json?["description"].string ?? json?.string ?? json?["Message"].string ?? json?["exception"].string ?? json?["title"].string
        if self.description == nil {
             self.description = "Something went wrong. Check your internet connection and, if problem persists, contact the system adnimistrator"
        }
    }
    
    init(title:String){
        self.description = title
    }
    
}

struct ApiHeader {
    static let contentTypeJson = ["ContentType":"application/json"]
}

enum ApiResponse {
    case Success(JSON?)
    case Failure(ApiError)
}
