//
//  Enviroment.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 5/9/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import Foundation

public enum PlistKey :String  {
    case baseURL = "baseURL"
    case allowedKingfisherUrl = "allowedKingfisherUrl"

}
public struct Environment {
    
    fileprivate static var infoDict: [String: Any]  {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            }else {
                fatalError("Plist file not found")
            }
        }
    }
    
    static func configuration(_ key: PlistKey) -> String {
        return infoDict[key.rawValue] as? String ?? ""
    }
}
